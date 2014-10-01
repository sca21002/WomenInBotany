use utf8;
package WomenInBotany::Import;

# ABSTRACT: Import data from csv file into database

use Modern::Perl;
use Moose;
use WomenInBotany::Types qw(ArrayRef DBIC_Schema File Str);
use Log::Log4perl qw(:easy);
use Text::CSV_XS;
use WomenInBotany::Helper;
use namespace::autoclean;
use Regexp::Common qw /URI/;
use String::Trim;
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use Data::Dumper;

has 'csv_columns' => (
    is => 'ro',
    isa => ArrayRef[Str],
    default => sub{ [ qw(
        familyname      birthname       firstname       year_of_birth
        birthdate       birthplace      year_of_death   deathdate
        deathplace      Nissen_Bd_1     Nissen_Bd_2     Nissen_Bd_3
        Barnhart        category        activity_old    town
        country         reference_1     reference_2     reference_3
        reference_4     reference_5     reference_6     reference_7
        reference_8     reference_9     reference_10    reference_11
        reference_12    reference_13    reference_14    reference_15
        reference_16    reference_17    reference_18    reference_19
        reference_20    reference_21    reference_22    reference_23
        reference_24    reference_25    reference_26    reference_27
        reference_28
    ) ] }
);    

has 'csv_file' => (
    is => 'ro',
    isa => File,
    coerce => 1,
    required => 1,
);

has 'logfile' => (
    is => 'ro',              
    isa => File,
    lazy => 1,
    builder => '_build_logfile',
);

has 'program_file' => (
    is => 'ro',
    isa => File,
    coerce => 1,
    required => 1,
);

has 'schema' => (
    is => 'ro',
    isa => DBIC_Schema,
    lazy => 1,
    builder => '_build_schema',  
);

### log file: same basename as program and same dir as data file
sub _build_logfile {
    my $self = shift;
    
    my $logfile_basename = $self->program_file->basename;
    $logfile_basename =~ s/\.[^.]*\z/\.log/;                     # .pl --> .log
    return Path::Class::File->new($self->csv_file->dir, $logfile_basename);
}

sub _build_schema {
    my $self = shift;
    
    my $schema = WomenInBotany::Helper::get_schema(
        $self->program_file->dir->parent->parent
    );
    return $schema;
}

sub non_primary_columns {
    my $self = shift;
    
    my %primary_columns_map;
    my $source = $self->schema->source('Botanist');
    undef @primary_columns_map{ $source->primary_columns };
    my @non_primary_columns
        = grep { ! exists $primary_columns_map{$_} } $source->columns;
    return @non_primary_columns;
}

sub get_reference {
    my $ref_value = shift;

    my $citation_req = qr{
        \A                   # start of string
        \s*                  # perhaps a space or more
        (?!Abruf)            # we don't want "Abruf ..."
        (?!http(?:s)?\:)           # we don't want links
        (?<title>            # capture by name "title"
            [-\w,.& ]+         # only alphanumeric, comma, point     
        )
        (?:                  # non capturing group
            \(               # opening bracket 
                (?<year>
                   \d{4}
                     |
                   o.\ Jz.  
                )
                (?:
                    (?:\:|,)     # : or , starts more information
                    (?<page_1>   # additional information
                    .+           # all up to the closing bracket    
                    )
                )?    
            \)                   # closing bracket
            (?:
                \s*
                \(
                    (?<page_2>   # additional information
                    .+           # all up to the closing bracket    
                    )                    
                \)
            )?
        )?
        \s*
        \z                   # the end
    }x;

    my $link_reg = qr{
        \A                      # start of string
        \s*                     # perhaps a space or more
        $RE{URI}{HTTP}{-keep}   # a link
        \s*                     # perhaps a space or more
        \z
    }x;
    
    my $last_seen_reg = qr {
        \A
        \s*
        Abruf(:|\ am)\ (?<date>\d{2}\.\d{2}\.(?:\d{2})?\d{2})
        \s*
        \z
    }x;
    
    my $link_sth_reg = qr {
        \A
        \s*
        (http(?:s)?\:\S+)
        \s*
        \z
    }x;

    return unless $ref_value;
    my $reference;

    if (   $ref_value =~ /$citation_req/ && length( $+{title} ) < r30 ) {

        my ($title, $year) = trim( $+{title}, $+{year} );
        my $page = join(' ', grep {$_} trim( $+{page_1}, $+{page_2} ));
            
        $reference->{type}                           = 'botanists_references';
        $reference->{value}{citation}                = $page       if $page;
        $reference->{value}{reference}{short_title}  = $title;  
        $reference->{value}{reference}{short_title} .=  " ($year)" if $year;

    } elsif ( $ref_value =~ /$link_reg/ ) {
 
        $reference->{type}              = 'botanists_links';
        $reference->{value}{uri}        = $1;
        $reference->{value}{link}{host} = $3;

    } elsif ( $ref_value =~ /$link_sth_reg/ ) {
 
        $reference->{type}              = 'botanists_links';
        $reference->{value}{uri}        = $1;
       
    } elsif ( $ref_value =~ /$last_seen_reg/ ) {

        $reference->{type}  = 'last_seen';
        $reference->{value} = $+{date};

    } else {
  
        $reference->{type}            = 'botanists_references';
        $reference->{value}{citation} = $ref_value =~ s/\A\s+|\s+\z//rg;

    }
    return $reference;
}

sub get_categories {
    my $cat_value = shift;
    
    my $category_reg = qr {
        \A
        \s*
        ([A-Z])
        (?:
            \s*
            /
            \s*
            ([A-Z])
        )*
        \s*
        \z
    }x;
    
   my (@categories) = $cat_value =~ qr/$category_reg/;
   @categories = grep {$_} @categories; 
   return   @categories; 
}

sub run {
    my $self = shift;

    ### intitialize easy logging
    my $logfile = $self->logfile;
    Log::Log4perl->easy_init(
        { level   => $INFO,
          file    => ">" . $logfile,
        },
        { level   => $TRACE,
          file    => 'STDOUT',
        },
    );
    INFO('Logging started: ' . $logfile); 
    INFO("CSV file: " . $self->csv_file);
    
    open my $fh, "<:encoding(cp1252)", $self->csv_file
        or LOGDIE $self->csv_file . ": $!";
    
    my $csv = Text::CSV_XS->new ({ binary => 1 })
        or die "Cannot use CSV: ".Text::CSV->error_diag ();

    $csv->column_names( $self->csv_columns );

    my @rows;   
    $csv->sep_char(";");

    while (my $row = $csv->getline_hr ($fh)) {
        push @rows, $row;
    }
    $csv->eof or $csv->error_diag ();
    close $fh;

    my $head_row = shift @rows;
    LOGDIE('Wrong head row in csv ' . $self->csv_file)
        unless $head_row->{ $self->csv_columns->[0] } =~ /^family name/;

    INFO('Lines readed: ' . scalar(@rows));
    
    $self->schema->resultset('Botanist')->delete_all or
        die "Couldn't delete resultset Botanist";  
    $self->schema->resultset('BotanistReference')->delete_all or
        die "Couldn't delete resultset BotanistReference";

    foreach my $botanist (@rows) {
        
        my %row;
        my @non_primary_columns = $self->non_primary_columns;
        @row{ @non_primary_columns } = @$botanist{ @non_primary_columns };
        foreach my $ref_column ( qw( Nissen_Bd_1 Nissen_Bd_2 Nissen_Bd_3 ) ) {
            next unless $botanist->{$ref_column};
            my $reference = {
                citation => $botanist->{$ref_column},
                reference => { short_title => $ref_column },
            };
            push @{$row{botanists_references}}, $reference;
        }
        
        foreach my $ref_value (@$botanist{ map { 'reference_' . $_ } 1..28 } ) {
            my $reference = get_reference($ref_value);
            if ($reference && $reference->{type} eq 'last_seen') {
                die Dumper %row unless $row{'botanists_links'}->[-1];
                $row{'botanists_links'}->[-1]->{last_seen} = $reference->{value};    
            } else {
                push @{ $row{ $reference->{type} } }, $reference->{value}
                    if $reference->{value};
            }
        }
        
        my @categories = get_categories($botanist->{category});
        foreach my $category (@categories) {
            push @{$row{'botanists_categories'}}, {'category_id' => $category};         
        }
        $self->schema->resultset('Botanist')->create(\%row);
    }
}


__PACKAGE__->meta->make_immutable();

1;

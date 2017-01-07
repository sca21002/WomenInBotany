use utf8;
package WomenInBotany::GND;

# ABSTRACT: Get GND Id for botanists

use Modern::Perl;
use Moose;
use WomenInBotany::Types qw(DateTimeFormatStrptime DBIC_Schema File);
use WomenInBotany::Helper;
use LWP::UserAgent;
use Unicode::Normalize;
use Encode;
use JSON::MaybeXS;
use DateTime::Format::Strptime;
use Data::Dumper;
use Path::Tiny;
use Log::Log4perl qw(:easy);

has 'gnd_schema' => (
    is => 'ro',
    isa => DBIC_Schema,
    lazy => 1,
    builder => '_build_gnd_schema',  
);

has 'wib_schema' => (
    is => 'ro',
    isa => DBIC_Schema,
    lazy => 1,
    builder => '_build_wib_schema',  
);

has 'program_file' => (
    is => 'ro',
    isa => File,
    coerce => 1,
    required => 1,
);

has 'strptime' => (
    is => 'ro',
    isa => DateTimeFormatStrptime,
    lazy => 1,
    builder => '_build_strptime',
);

has 'logfile' => (
    is => 'ro',              
    isa => File,
    lazy => 1,
    builder => '_build_logfile',
);

sub _build_strptime {
    return DateTime::Format::Strptime->new(
        pattern => '%d. %B %Y',
        locale  => 'de-De',
    );
}

sub _build_gnd_schema {
    my $self = shift;
    
    my $schema = WomenInBotany::Helper::get_schema(
        $self->program_file->dir->parent->parent,
        'GndDB',
        'GND',
    );
    return $schema;
}

sub _build_wib_schema {
    my $self = shift;
    
    my $schema = WomenInBotany::Helper::get_schema(
        $self->program_file->dir->parent->parent,
        'WomenInBotanyDB',
        'WomenInBotany',
    );
    return $schema;
}

### log file: same basename as program and same dir as data file
sub _build_logfile {
    my $self = shift;
    
    my $logfile_basename = $self->program_file->basename;
    $logfile_basename =~ s/\.[^.]*\z/\.log/;                     # .pl --> .log
    return Path::Class::File->new($self->program_file->dir->parent->parent, $logfile_basename);
}


sub fetch_GND {
    my $hits = shift;
   
    my @gnd;

    while (my $hit = $hits->next) { 
        my $id = $hit->gnd_nr;
        my $url = "http://hub.culturegraph.org/entityfacts/$id";
        my $ua = LWP::UserAgent->new(timeout => 540);
        my $response = $ua->get($url);
        if ($response->is_success) {
            my $entity = $response->content();
            $entity = decode('UTF-8', $entity);
            $entity = Unicode::Normalize::NFC($entity);
            push @gnd, $entity;
        } else {
            # say $response->status_line;
        }
    }
    return \@gnd;  
}


sub format_date {
    my ($self, $date)  = @_;
    
    if (my $date_formated = $self->strptime->parse_datetime($date)) {
        return $date_formated->strftime('%d.%m.%Y');
    } else {
        return $date;
    }
}


sub is_found {
    my ($self, $botanist, $gnd) = @_;

    my ($found, $message);

    if ($gnd->{dateOfBirth}) {
        # GND has only a year 
        if ($gnd->{dateOfBirth} =~ /^\d{4}/) {
            $found = $gnd->{dateOfBirth} eq ($botanist->year_of_birth || '');
            # INFO($gnd->{dateOfBirth}, ' <=> ', $botanist->year_of_birth || '');
        } else {
            if ($botanist->birthdate && $botanist->birthdate =~ /^\d{4}/) {
                $found =  $self->strptime->parse_datetime(
                    $gnd->{dateOfBirth}
                )->year eq $botanist->birthdate;
                $message = 'GND (dateOfBirth): ' . $gnd->{dateOfBirth}; 
            } elsif ($botanist->birthdate) {
                $found = 
                  $self->format_date($gnd->{dateOfBirth}) 
                    eq $botanist->birthdate; 
                    # INFO($self->format_date($gnd->{dateOfBirth}),
                    # ' <=> ', $botanist->birthdate || '');
            }
        }
    }
    if ($gnd->{dateOfDeath}) {
        # GND has only a year 
        if ($gnd->{dateOfDeath} =~ /^\d{4}/) {
            $found = $gnd->{dateOfDeath} eq ($botanist->year_of_death || ''); 
            # INFO($gnd->{dateOfDeath}, ' <=> ', $botanist->year_of_death || '');
        } else {
            if ($botanist->deathdate && $botanist->deathdate =~ /^\d{4}/) {
                $found =  $self->strptime->parse_datetime(
                    $gnd->{dateOfDeath}    
                )->year eq $botanist->deathdate;
                $message .= ' ' if $message;
                $message .= 'GND (dateOfDeath): ' . $gnd->{dateOfDeath}; 
            } elsif ($botanist->deathdate) {
                $found = 
                  $self->format_date($gnd->{dateOfDeath}) 
                    eq $botanist->deathdate; 
                    # INFO($self->format_date($gnd->{dateOfDeath}),
                    # ' <=> ', $botanist->deathdate || '');
            }
        }
    } 
    return ($found, $message);
}


sub update {
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

    my $botanist_rs = $self->wib_schema->resultset('Botanist')->search({
            gnd => undef,
    });
    my $gnd_rs      = $self->gnd_schema->resultset('GndPreferred');
    my $i = 0;
    while (my $botanist = $botanist_rs->next) {
        #say $botanist->familyname, ', ', ($botanist->firstname || '');
        my $search = $botanist->familyname; 
        $search .= ', ' .  $botanist->firstname if $botanist->firstname;
        # 
        my $hits = $gnd_rs->search({
            preferredName => $search,        
        });
        my $cnt = $hits->count;
        if ($cnt > 0) {
            # INFO($search);
            $i++;
            my $entities = fetch_GND($hits);
            INFO("$search") if @$entities; 
            foreach my $entity (@$entities) {
                my $data = decode_json(encode('UTF-8', $entity));
                #say Dumper($data);
                my ($id) = $data->{'@id'} =~ m#/([0-9X]+)$#;
                INFO("\tBirth: ", $botanist->birthdate || '', 
                    ' <=> ', $data->{dateOfBirth} || '', ' (GND: ', $id || $data->{'@id'}, ')');
                INFO("\tDeath: ", $botanist->deathdate || '',
                    ' <=> ', $data->{dateOfDeath} || '', ' (GND: ', $id || $data->{'@id'}, ')');
                my ($found, $message) = $self->is_found($botanist, $data);
                INFO("\tÜbereinstimmung gefunden!" ) if $found;
                INFO("\tBemerkung: ", $message) if $message;
                $botanist->update({
                    gnd => $id,
                });
                if ($message) {
                    my $notes = $botanist->notes;
                    $notes .= ' ' if $notes;
                    $notes .= $message;
                    $botanist->update({
                        notes => $notes,
                    });
                }
                last if $found;
            }
        }    
    }
}

__PACKAGE__->meta->make_immutable();

1;

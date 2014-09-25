use utf8;
package WomenInBotany::Batch;

# ABSTRACT: Mass changes in database 

use DateTime::Format::Excel;
use Log::Log4perl qw(:easy);
use Modern::Perl;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;
use WomenInBotany::Helper;
use WomenInBotany::Schema;
use WomenInBotany::Types qw(DBIC_Schema File);

use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use Data::Dumper;

has 'logfile' => ( is => 'lazy', isa => File );

has 'program_file' => (
    is => 'ro',
    isa => File,
    coerce => 1,
    required => 1,
);

has 'schema' => ( is => 'lazy', isa => DBIC_Schema ); ### move to WIB::Helper?

### log file: same basename as program and same dir as data file
sub _build_logfile {
    my $self = shift;

    my $logfile_basename = $self->program_file->basename;
    $logfile_basename =~ s/\.[^.]*\z/\.log/;                     # .pl --> .log
        return Path::Class::File->new(
            $self->program_file->dir, $logfile_basename
        );
    }

sub _build_schema {
    my $self = shift;
    my $schema = WomenInBotany::Helper::get_schema(
        $self->program_file->dir->parent->parent
    );
    return $schema;
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

    my $dt_xls = DateTime::Format::Excel->new();
    my $botanist_rs = $self->schema->resultset('Botanist');
    while (my $botanist = $botanist_rs->next) {
        my $deathdate = $botanist->deathdate;
        next unless $deathdate; 
        next if $deathdate =~ /[0-9?]{2}\.[0-9?]{2}\.[0-9?]{4}/;
        if ($deathdate =~ /^[1-9][0-9]{1,5}$/) {
            my $dt = $dt_xls->parse_datetime($deathdate);
            #INFO($botanist->id . " - " . $botanist->familyname . ", " 
            #    . $botanist->firstname . ": '" 
            #    . $dt->strftime('%d.%m.%Y')); 
            
            #LOGWARN($botanist->id . " - " . $botanist->familyname . ", " . $botanist->firstname . ": '" . $dt->strftime('%d.%m.%Y') . "'" 
            #    . " <> " . $botanist->year_of_death )
            #        if $botanist->year_of_death &&  $dt->year != $botanist->year_of_death;    
            #$botanist->update({deathdate => $dt->strftime('%d.%m.%Y')});
        } else {
            INFO($botanist->id . " - " . $botanist->familyname . ", " . $botanist->firstname . ": '" . $botanist->deathdate . "'");
        } 
    }        
}    

__PACKAGE__->meta->make_immutable();

1;

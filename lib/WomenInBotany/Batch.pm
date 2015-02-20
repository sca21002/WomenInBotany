use utf8;
package WomenInBotany::Batch;

# ABSTRACT: Mass changes in database 

use DateTime::Format::Strptime;
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

    my $date_fmt = DateTime::Format::Strptime->new(
      pattern   => '%d.%m.%Y',
      locale    => 'de_DE',
      time_zone => 'Europe/Berlin',
    );
    my $year_fmt = DateTime::Format::Strptime->new(
      pattern   => '%Y',
      locale    => 'de_DE',
      time_zone => 'Europe/Berlin',
    );
    



    my $botanist_rs = $self->schema->resultset('Botanist');
    while (my $botanist = $botanist_rs->next) {
        my %event;
        $event{birthdate} = $botanist->birthdate;
        $event{deathdate} = $botanist->deathdate;
        # INFO( sprintf("%s - %s", $event{birthdate} || '<unknown>', $event{deathdate} || '<unknown>'));    
        EVENT: foreach my $date ( qw(birthdate deathdate) ) {
            next EVENT unless $event{$date};
            next EVENT if $event{$date} =~ /\?/;
            my $dt = $date_fmt->parse_datetime($event{$date});   
            $dt = $year_fmt->parse_datetime($event{$date}) unless $dt;
            my ($year_3d) = $event{$date} =~ /^\d{3}$/ unless $dt; 
            # LOGWARN($event{$date}) unless $dt or $year_3d; 
            next EVENT unless $dt or $year_3d;       
            #INFO($dt->year || $year_3d);
            if ( $date eq 'birthdate' ) { 
                $botanist->update({ year_of_birth => $year_3d || $dt->year });  
            } else {
                $botanist->update({ year_of_death => $year_3d || $dt->year });  
           }         
        }


            #my $dt = $dt_xls->parse_datetime($deathdate);
            #INFO($botanist->id . " - " . $botanist->familyname . ", " 
            #    . $botanist->firstname . ": '" 
            #    . $dt->strftime('%d.%m.%Y')); 
            
            #LOGWARN($botanist->id . " - " . $botanist->familyname . ", " . $botanist->firstname . ": '" . $dt->strftime('%d.%m.%Y') . "'" 
            #    . " <> " . $botanist->year_of_death )
            #        if $botanist->year_of_death &&  $dt->year != $botanist->year_of_death;    
            #$botanist->update({deathdate => $dt->strftime('%d.%m.%Y')});
    }        
}    

__PACKAGE__->meta->make_immutable();

1;

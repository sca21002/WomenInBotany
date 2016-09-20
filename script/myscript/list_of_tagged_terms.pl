#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use Carp;
use FindBin qw($Bin);
use Path::Tiny;

use lib path($Bin)->parent(2)->child('lib')->stringify; 
use Log::Log4perl qw(:easy);
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

use Data::Dumper;
use WomenInBotany::Helper;
use Config::ZOMG;
use Text::CSV_XS;

my $logfile = path($Bin)->parent(2)->child('list_of_tagged_terms.log');

### Logdatei initialisieren
Log::Log4perl->easy_init(
    { level   => $DEBUG,
      file    => ">" . $logfile,
    },
    { level   => $TRACE,
      file    => 'STDOUT',
    },
);

my $config_dir = path($Bin)->parent(2);

my $schema = WomenInBotany::Helper::get_schema($config_dir);

my $config_hash = Config::ZOMG->open(
    name => 'womeninbotany',
    path => $config_dir,
    ) or croak "Keine Konfigurationsdatei gefunden in $config_dir";

my @text_fields = qw(
    marital_status
    professional_experience
    peculiar_fields_of_activity
    context_honors
    education
    work
    remarks
);

my $where_clause = [ map {  { $_ => {'like' => '%<<%'} } } @text_fields ];


my $rs = $schema->resultset('Botanist')->search($where_clause);


my $csv = Text::CSV_XS->new ({ 
    eol => "\r\n",
    sep_char => ";",
});

open my $fh, ">:encoding(utf8)", "plant_names.csv" or die "plant_names.csv: $!";

while (my $row = $rs->next) {
    foreach my $field (@text_fields) {
        my @terms;
        if ($row->$field && (@terms =  $row->$field =~ />>([^<]*)<</g)) {
            foreach my $term (@terms) {
                $csv->print(
                    $fh,  
                    [ 
                        $row->id, 
                        sprintf("%s, %s", $row->familyname, $row->firstname), 
                        $field, 
                        $term,
                    ], 
                ) or $csv->error_diag;
            }    
        }
    }
}

close $fh or die "plant_names.csv: $!";

say $rs->count;


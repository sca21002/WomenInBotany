#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use Carp;
use FindBin qw($Bin);
use Path::Tiny;
use lib path($Bin)->parent(2)->child('lib')->stringify; 
use WomenInBotany::Schema;
use Config::ZOMG;
use DBIx::Class::ResultClass::HashRefInflator;
use Log::Log4perl qw(:easy);
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8
use Data::Dumper;

my @tables = ( qw(
    Status Place Botanist Category Reference Link BotanistCategory BotanistReference 
    BotanistLink User Image Role UserRole
));

my $logfile = path($Bin)->parent(2)->child('populate.log');

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

my $config_hash = Config::ZOMG->open(
    name => 'womeninbotany',
    path => $config_dir,
    ) or croak "Keine Konfigurationsdatei gefunden in $config_dir";

my $database_role = $config_hash->{'Database'}{role};
INFO('Database role: ' . $database_role);

LOGCROAK("Database role must be 'slave', but role '$database_role' was found") 
    unless $database_role eq 'slave';

my $connect_info_source = $config_hash->{"ImportDB"}{"connect_info"};
my $schema_source = WomenInBotany::Schema->connect($connect_info_source);
$schema_source->storage->ensure_connected;

my $connect_info_dest = $config_hash->{"Model::WomenInBotanyDB"}{"connect_info"};
my $schema_dest = WomenInBotany::Schema->connect($connect_info_dest);
$schema_dest->storage->ensure_connected;

## emptying destination tables 

foreach my $resultset (reverse @tables) {
    say "Emptying $resultset";
    $schema_dest->resultset($resultset)->delete();
}

## populate tables

foreach my $resultset (@tables) {
    say "Importing $resultset";
    my $rs_source = $schema_source->resultset($resultset)->search( {}, {
       result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    });
    $schema_dest->resultset($resultset)->populate([$rs_source->all]);
    # say Dumper($rs_source->all);
}

say "Please build 'geom' column via SQL:"
say "UPDATE places SET geom = ST_GeomFromText('POINT(' || lon || ' ' || lat || ')', 4326);"

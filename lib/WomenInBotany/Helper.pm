package WomenInBotany::Helper;

# ABSTRACT: Helper functions for WomenInBotany

use Carp;
use Config::ZOMG;
use Path::Class qw(dir file);
use WomenInBotany::Schema;
use GND::Schema;
use DBIx::Class::Helpers::Util ':all';


sub get_schema {
    my $config_dir = shift;
    my $model = shift || 'WomenInBotanyDB';
    my $schema_name = shift || 'WomenInBotany';

    print "Test: ", $schema_name, "\n";
    
    croak "Aufruf: get_schema( [configdir] )" unless $config_dir;
    croak "Kein Konfigurationsverzeichnis: $config_dir" unless -d $config_dir;
    my $config_hash = Config::ZOMG->open(
        name => 'womeninbotany',
        path => $config_dir,
    ) or croak "Keine Konfigurationsdatei gefunden in $config_dir";
    my $dbic_connect_info
        = $config_hash->{"Model::$model"}{connect_info};
    $dbic_connect_info = normalize_connect_info(@$dbic_connect_info)
        if (ref $dbic_connect_info eq 'ARRAY' );    
 
    croak "Keine Datenbank-Verbindungsinformationen" unless  $dbic_connect_info;
    my $schema = "${schema_name}::Schema"->connect($dbic_connect_info);
    $schema->storage->ensure_connected;
    return $schema;
}

1;

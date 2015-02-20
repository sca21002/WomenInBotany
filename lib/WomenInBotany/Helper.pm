package WomenInBotany::Helper;

# ABSTRACT: Helper functions for WomenInBotany

use Carp;
use Config::ZOMG;
use Path::Class qw(dir file);
use WomenInBotany::Schema;


sub get_schema {
    my $config_dir = shift;
    
    croak "Aufruf: get_schema( [configdir] )" unless $config_dir;
    croak "Kein Konfigurationsverzeichnis: $config_dir" unless -d $config_dir;
    my $config_hash = Config::ZOMG->open(
        name => 'womeninbotany',
        path => $config_dir,
    ) or croak "Keine Konfigurationsdatei gefunden in $config_dir";
    my $dbic_connect_info
        = $config_hash->{'Model::WomenInBotanyDB'}{connect_info};
    croak "Keine Datenbank-Verbindungsinformationen" unless  $dbic_connect_info;
    my $schema = WomenInBotany::Schema->connect($dbic_connect_info);
    $schema->storage->ensure_connected;
    return $schema;
}

1;

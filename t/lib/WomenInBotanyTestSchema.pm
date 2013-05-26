use utf8;
package # hide from PAUSE
    WomenInBotanyTestSchema;
 
use Modern::Perl;
use WomenInBotany::Schema;
use Path::Class qw(dir file);
use Config::General;


my $attrs = {
    sqlite_version => 3.3,
    add_drop_table => 1,
    no_comments    => 1,
    quote_identifiers => 1
};

my $var_dir =  file(__FILE__)->dir->parent->subdir('var');
my $db_file = file( $var_dir, 'womeninbotany.db' );

sub get_schema {
    my $dsn    = $ENV{"WOMENINBOTANY_TEST_SCHEMA_DSN"}
                 || "dbi:SQLite:${db_file}";
    my $dbuser = $ENV{"WOMENINBOTANY_TEST_SCHEMA_DBUSER"} || '';
    my $dbpass = $ENV{"WOMENINBOTANY_TEST_SCHEMA_DBPASS"} || '';
 
    return WomenInBotany::Schema->connect($dsn, $dbuser, $dbpass,
        {
            quote_names    => 1,
            sqlite_unicode => 1,
        }                                      
    );
}
 
sub init_schema {
    my $self = shift;
    my %args = @_;
 
    my $schema = $self->get_schema;

    $schema->deploy( $attrs );
 
    $self->populate_schema($schema) if $args{populate};
    
    my $config = {
        name => 'WomenInBotany Test Suite',
        'Model::WomenInBotanyDB' => {
            connect_info => $schema->storage->connect_info,
        },
    };
    my $config_file = file( $var_dir, 'womeninbotany.conf' );
    Config::General::SaveConfig( $config_file, $config );    
        
    return $schema;
}

sub populate_schema {
    my $self = shift;
    my $schema = shift;
 
    $schema->storage->dbh->do("PRAGMA synchronous = OFF");
 
    $schema->storage->ensure_connected;
 
    # $schema->create_initial_data;
    $self->create_test_data($schema);
}

sub create_test_data {
 
    my ($self, $schema)=@_;
    my @data;

    my $data = {
        activity => "Educator at  Anton Ulrich v. Erath's family in Dillenburg."
                    . " Collected plants in Oranien-Nassau (today: Hessen, "
                    . "Germany). Made plant and flower paintings. Not married. "
                    . "\nAuthor of: 'Verzeichniß und Beschreibung der "
                    . "sämtlichen in den Fürstlich Oranien-"
                    . "Nassauischen Landen wildwachsenden Gewächse.' c. "
                    . "800 sheets in seven vols. Herborn 1777. \nDrawings for  "
                    . "A. U. Erath's  'Codex diplomaticus Quedlinburgensis'. "
                    . "1764.  \nMember of 'Società botanica fiorentina' "
                    . "(1766), 'Gesellschaft Naturforschender Freunde zu Berlin"
                    . "(1776) and  'Regensburgische Botanische Gesellschaft' "
                    . "(1790). \nReichenbach dedicated to her - and 10 other "
                    . "ladies - his book 'Botanik für Damen', "
                    . "Leipzig 1828.",
        birthdate => "01.03.1717",
        birthname => "",
        birthplace => "Hildesheim; Germany",
        botanists_links => [
            {
                link => {
                    host => "de.wikipedia.org"
        
                },
                uri => "http://de.wikipedia.org/wiki/Catharina_Helena_D%C3%B6rrien"
            },
            {
                link => {
                    host => "www.fembio.org"
                },
                uri => "http://www.fembio.org/biographie.php/frau/frauendatenbank"
            }
        ],
        botanists_references => [
            {
                citation => 178, 
                reference => {
                    short_title => "Nissen_Bd_1"
                }
            },
            {
                reference => {
                    short_title => "Viereck (2000)"
                }
            },
            {
                citation => "Catharina Helena Dörrien : Zeichnerin, Botanikerin, Schriftstellerin (1717-1795); zum 200. Todestag\n/ Geisthardt, Michael . - In: Dillenburger Blätter, ISSN 0931-1874, Bd. 24 = Jg. 12 (1995), S.2-18"
            },
            {
                citation => "40-41",
                reference => {
                    short_title => "Martin (2009)"
                }
            },
            {
                citation => "I",
                reference => {
                    short_title => "Reichenbach (1828)"
                }
            },
            {
                citation => "63-64",
                reference => {
                    short_title => "Böhne (2011)"
                }
            }
        ],
        botanists_categories => [
            {
                category_id => "A",
            },
        ],
        country => "Germany",
        deathdate => "08.06.1795",
        deathplace => "Dillenburg, Germany",
        familyname => "Dörrien",
        firstname => "Catharina Helena",
        workplace => undef
    };
    
    $schema->resultset('Botanist')->create($data);
    
    my $admin = $schema->resultset('User')->create({
        username => 'admin',
        password => 'test',
    });
    
    $schema->resultset('Category')->create(
        {
            id   => 'A',
            name => 'Artist',
        },
        {
            id   => 'B',
            name => 'Botanist',
        },
    );
}

1;

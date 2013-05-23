use utf8;
use Modern::Perl;
use Test::More;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->subdir('lib')->stringify;
use English qw( -no_match_vars );           # Avoids regex performance penalty
use Data::Dumper;

BEGIN {
    use_ok( 'WomenInBotany::Import' ) or exit;
}

my @tests = (
    {
        in   => 'Abruf am 25.05.2013',
        out  => {
            'value' => '25.05.2013',
            'type'  => 'last_seen'
        },
        name => 'Abruf 1',
    },
    {
        in   => 'Abruf: 16.05.12',
        out  => {
            'value' => '16.05.12',
            'type'  => 'last_seen'
        },
        name => 'Abruf 2',
    },
    {
        in   => 'Herzenberg (1986) (Z,K,D1,R)',
        out  => {
            type => "botanists_references",     
            value => {
                citation => "Z,K,D1,R",
                reference => {
                    short_title => "Herzenberg (1986)"
                },
            },
        },
        name => 'Herzenberg',
    },
    {
        in   => 'Holm (2009, 57, Anm. 8)',
        out  => {
            type => "botanists_references",     
            value => {
                citation => "57, Anm. 8",
                reference => {
                    short_title => "Holm (2009)"
                },
            },
        },
        name => 'Holm',
    },
);

foreach my $test (@tests) {
    my $reference = WomenInBotany::Import::get_reference($test->{in});
    is_deeply($reference, $test->{out}, $test->{name});
};

@tests = (
    {
        in   => 'F/T',
        out  => ['F', 'T'],
        name => 'Category',
    },
);

foreach my $test (@tests) {
    my @categories = WomenInBotany::Import::get_categories($test->{in});
    diag Dumper \@categories;
    is_deeply(\@categories, $test->{out}, $test->{name});
};


done_testing();

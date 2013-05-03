use utf8;
use Modern::Perl;
use Test::More;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->subdir('lib')->stringify;

BEGIN {
    use_ok( 'WomenInBotany::Helper' ) or exit;
}

my $schema = WomenInBotany::Helper::get_schema(dir($Bin)->parent);


$schema->resultset('Botanist')->create({
    familyname => 'Botanist 1'                              
});

done_testing();

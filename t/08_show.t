#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;
use URI;

### prepare test cases

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok( my $botanist = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    } )->first,
    'Search botanist'
);

is( $botanist->name_and_function,
    'Catharina Helena Dörrien, Artist',
    'Got full name and function'
);

ok( $botanist->botanists_categories->delete_all, 'Delete all categories');

is( $botanist->name_and_function,
    'Catharina Helena Dörrien',
    'Got name without function'
);

done_testing();

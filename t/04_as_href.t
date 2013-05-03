#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;
use DBIx::Class::ResultClass::HashRefInflator;

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok( my $botanist = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    })->as_href->first,
    'Search botanist'
);

ok( my $references = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    })->single->botanists_references->as_aref_of_href,
    'Search botanist'
);

done_testing();

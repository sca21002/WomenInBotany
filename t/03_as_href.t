#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok( my $botanist = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    },
    {
        join => {botanists_references => 'reference'},
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    },         
             
    )->first,
    'Search botanist'
);

done_testing();

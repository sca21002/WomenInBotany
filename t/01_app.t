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

ok(my $botanist = $schema->resultset('Botanist')
    ->search( {familyname => 'Dörrien'} )->first, 'Search botanist');
is( $botanist->firstname, 'Catharina Helena',      '... found' );
                                           

done_testing();
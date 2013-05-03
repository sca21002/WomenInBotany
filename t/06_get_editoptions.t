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

ok(
    my @reference = $schema->resultset('Reference')->search(
        undef,
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator' }
    )->all,
    'Reference found',
);

done_testing();

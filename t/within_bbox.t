#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotany::Helper;
use Test::More;
use Test::Exception;
use Data::Dumper;

ok( my $schema = WomenInBotany::Helper::get_schema( dir($Bin)->parent), 'got schema' );

my $rs;
ok( $rs = $schema->resultset('Place')->within_bbox(), 'Places found' );
diag 'Hits: ', $rs->count;

my $row = $rs->next;

diag $row->get_column('botanist_id'); 

diag $row->get_column('point');

done_testing();

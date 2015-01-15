#!/usr/bin/env perl
use utf8;

use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

use FindBin qw($Bin);
use Path::Tiny;
use lib path($Bin)->parent(2)->child('lib')->stringify; 
use Modern::Perl;
use Spreadsheet::ParseXLSX;
use WomenInBotany::Helper;
use Data::Dumper;

my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse(
    path($Bin)->parent(2)->child(qw(data ref_zu_shortlist.xlsx))->stringify
);

my $worksheet = $workbook->worksheet(0);

my ( $row_min, $row_max ) = $worksheet->row_range();
my ( $col_min, $col_max ) = $worksheet->col_range();

my @arr;

for my $row ( 1 .. $row_max ) {

    my @row;

    my $cell_0 = $worksheet->get_cell( $row, 0 );
    my $cell_1 = $worksheet->get_cell( $row, 1 );
    my $short_title = $cell_0->value();
    my $title       = $cell_1->value();

    push @arr, { short_title => $short_title, title => $title };
}

my $schema = WomenInBotany::Helper::get_schema( path($Bin)->parent(2) );

my $rs = $schema->resultset('RefTemp');
$rs->delete_all;

foreach my $row (@arr) {
    $rs->find_or_create($row);
} 

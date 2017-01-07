#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use FindBin qw($Bin);
use Path::Tiny;
use lib path($Bin)->parent(2)->child('lib')->stringify; 
use English qw( -no_match_vars ) ;           # Avoids regex performance penalty
use WomenInBotany::GND;
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

my $gnd = WomenInBotany::GND->new(
    program_file => $PROGRAM_NAME,
);

$gnd->update();

=encoding utf-8


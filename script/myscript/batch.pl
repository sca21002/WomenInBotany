#!/usr/bin/env perl
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->parent->subdir('lib')->stringify;
use English qw( -no_match_vars );           # Avoids regex performance penalty
use Getopt::Long;


use Pod::Usage;
use Modern::Perl;
use WomenInBotany::Batch;
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

### get options

my($opt_help, $opt_man);

GetOptions(
    'help!'                 =>      \$opt_help,
    'man!'                  =>      \$opt_man,
)
    or pod2usage( "Try '$PROGRAM_NAME --help' for more information." );

pod2usage( -verbose => 1 ) if $opt_help;
pod2usage( -verbose => 2 ) if $opt_man;

my $batch = WomenInBotany::Batch->new(
    program_file => $PROGRAM_NAME,
);

$batch->run();

=encoding utf-8

=head1 NAME

batch.pl - runs mass changes in the WomenInBotany database

=head1 SYNOPSIS

batch.pl [options]

 Options:
    --help         display this help and exit
    --man          display extensive help

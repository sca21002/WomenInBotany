#!/usr/bin/env perl
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->parent->subdir('lib')->stringify; 
use English qw( -no_match_vars ) ;           # Avoids regex performance penalty
use Getopt::Long;

use Pod::Usage;
use Modern::Perl;
use WomenInBotany::Import;
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

my $csv_filename = shift @ARGV or pod2usage( -verbose => 1 );


my $import = WomenInBotany::Import->new(
    csv_file   => $csv_filename,
    program_file => $PROGRAM_NAME,
);

$import->run();

=encoding utf-8

=head1 NAME
 
import_from_csv.pl - Imports data from CSV file into the WomenInBotany database

=head1 SYNOPSIS

import_from_csv.pl [options] [csv filename] 

 Options:
   --help         display this help and exit
   --man          display extensive help

 Examples:
   import_from_csv.pl womeninbotany.xlsx
   import_from_csv.pl --help
   import_from_csv.pl --man 
   

=head1 DESCRIPTION

Imports data from CSV into the WomenInBotany database.

Reads the given file in CSV format and fills the data into the WomenInBotany
database

=head1 AUTHOR

Albert Schröder <albert.schroeder@ur.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

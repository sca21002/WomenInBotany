#!/usr/bin/env perl
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->parent->subdir('lib')->stringify; 
use English qw( -no_match_vars ) ;           # Avoids regex performance penalty
use Getopt::Long;
use Log::Log4perl qw(:easy);

use Pod::Usage;
use Modern::Perl;
use Spreadsheet::XLSX;
use WomenInBotany::Helper;
use Data::Dumper::Concise;

my @columns = ( qw(
        familyname
        birthname   
        firstname
        year_of_birth
        birthdate
        birthplace
        year_of_death
        deathdate
        deathplace
        Nissen_Bd_1
        Nissen_Bd_2
        Nissen_Bd_3
        Barnhart
        category
        activity
        town
        country
        ref_1
        ref_2
        ref_3
        ref_4
        ref_5
        ref_6
        ref_7
));    

### get options 

my($opt_help, $opt_man);

GetOptions(
    'help!'                 =>      \$opt_help,
    'man!'                  =>      \$opt_man,
)
  or pod2usage( "Try '$PROGRAM_NAME --help' for more information." );

pod2usage( -verbose => 1 ) if $opt_help;
pod2usage( -verbose => 2 ) if $opt_man;

my $excel_filename = shift @ARGV or pod2usage( -verbose => 1 );
my $excel_file = Path::Class::File->new($excel_filename);


### log file: same basename as program and same dir as data file

my $logfile = $PROGRAM_NAME;                         
$logfile =~ s/\.[^.]*\z/\.log/;                                 # .pl --> .log
$logfile = Path::Class::File->new($logfile);
$logfile = Path::Class::File->new($excel_file->dir, $logfile->basename);


### intitialize easy logging

Log::Log4perl->easy_init(
    { level   => $INFO,
      file    => ">" . $logfile,
    },
    { level   => $TRACE,
      file    => 'STDOUT',
    },
);
INFO('Logging gestartet: ' . $logfile); 
INFO("Excel-Datei: " . $excel_file);

my $biography;

my $excel = Spreadsheet::XLSX->new($excel_file->stringify);
my $worksheet = $excel->{Worksheet}[0];
TRACE('Tabelle: ' . $worksheet->{Name});

my ( $row_min, $row_max ) = $worksheet->row_range();

for my $row ( $row_min+1 .. $row_max ) {
    my $botanist;
    for my $col ( 0 .. $#columns ) {

        my $cell = $worksheet->get_cell( $row, $col );
        next unless $cell;

        $botanist->{$columns[$col]} = $cell->value;
        # print "Row, Col    = ($row, $col)\n";
        # print "Value       = ", $cell->value(),       "\n";
        # print "Unformatted = ", $cell->unformatted(), "\n";
        # print "\n";
    }
    push @$biography, $botanist;
}



my $schema = WomenInBotany::Helper::get_schema(dir($Bin)->parent->parent);

my %e;
undef @e{$schema->source('Botanist')->primary_columns};
my @non_primary_columns
    = grep { ! exists $e{$_} } $schema->source('Botanist')->columns; 

say join "\n", @non_primary_columns;


my %data;
my $i=1;
foreach my $botanist (@$biography) {
   #next unless $i > 5;
   my $key = $botanist->{familyname} . '_' . $botanist->{firstname};
   $data{$key} = [ $i++, @{$botanist}{@non_primary_columns} ];
   # $data{$key} = [ @{$botanist}{@non_primary_columns} ];
}

my $setup_rows = [
    {   Botanist => {
            fields => [ $schema->source('Botanist')->columns ],
            # fields => \@non_primary_columns,
            data => \%data,
        },
    },
];

say Dumper($setup_rows);

$schema->populate_more($setup_rows);


1;

=encoding utf-8

=head1 NAME
 
import_from_excel.pl - Imports data from Excel into the WomenInBotany database

=head1 SYNOPSIS

import_from_excel.pl [options] [excel filename] 

 Options:
   --help         display this help and exit
   --man          display extensive help

 Examples:
   import_from_excel.pl womeninbotany.xlsx
   import_from_excel.pl --help
   import_from_excel.pl --man 
   

=head1 DESCRIPTION

Imports data from Excel into the WomenInBotany database.

Reads the given file in Excel format and fills the data into the WomenInBotany
database

=head1 AUTHOR

Albert Schröder <albert.schroeder@ur.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

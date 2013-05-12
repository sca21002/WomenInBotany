#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use Text::CSV;
use Devel::Dwarn;

# Format:
# Name –- birthdate -– birthplace -– deathdate -– deathplace -– specialties

my @columns = ( qw(
    family_name
    first_name
    birthdate
    birthplace
    deathdate
    deathplace
    specialties

));

my $data_dir = dir($Bin)->parent->parent->subdir('data');
my $infile = file($data_dir, 'FemaleBotanists2012October.txt');
my @lines = $infile->slurp(iomode => '<:encoding(UTF-8)', chomp => 1);
@lines = grep { /\S/ } @lines;

my @rows; 
push @rows, \@columns;

foreach my $line (@lines) {
    my @line = split(' -- ', $line);
    push @rows, [ split(', ', shift @line), @line ];
}

my $csv = Text::CSV_XS->new ({ binary => 1 }) or
        die "Cannot use CSV: ".Text::CSV->error_diag ();
  
$csv->eol ("\n");
$csv->sep_char(";");
my $csv_filename = file($data_dir, 'FemaleBotanists2012October.csv');
open my $fh, ">:encoding(iso-8859-1)", $csv_filename
    or die "$csv_filename: $!";
     

$csv->print ($fh, $_) for @rows;
close $fh or die "$csv_filename: $!";        


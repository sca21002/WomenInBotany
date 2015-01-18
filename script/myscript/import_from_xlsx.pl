#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use Spreadsheet::ParseXLSX;
use FindBin qw($Bin);
use Path::Tiny;
use lib path($Bin)->parent(2)->child('lib')->stringify; 
use WomenInBotany::Helper;
use Log::Log4perl qw(:easy);
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

my $colname =
    [ qw(
        familyname      birthname       firstname       year_of_birth
        birthdate       birthplace      year_of_death   deathdate
        deathplace      Nissen_Bd_1     Nissen_Bd_2     Nissen_Bd_3
        Barnhart        category        activity_old    town
        country         reference_1     reference_2     reference_3
        reference_4     reference_5     reference_6     reference_7
        reference_8     reference_9     reference_10    reference_11
        reference_12    reference_13    reference_14    reference_15
        reference_16    reference_17    reference_18    reference_19
        reference_20    reference_21    reference_22    reference_23
        reference_24    reference_25    reference_26    reference_27
        reference_28
    ) ];

my $logfile = path($Bin)->parent(2)->child('import_xlsx.log');

### Logdatei initialisieren
Log::Log4perl->easy_init(
    { level   => $DEBUG,
      file    => ">" . $logfile,
    },
    { level   => $TRACE,
      file    => 'STDOUT',
    },
);



my $schema = WomenInBotany::Helper::get_schema(
      path($Bin)->parent->parent
);

my $rs = $schema->resultset('Botanist');

my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse(
    path($Bin)->parent(2)->child(qw(data womeninbotany.xlsx))->stringify
);


my $worksheet1 = $workbook->worksheet('Tabelle1'); 
my $worksheet2 = $workbook->worksheet('Tabelle2'); 

my ( $row_min, $row_max ) = $worksheet2->row_range();
my ( $col_min, $col_max ) = $worksheet2->col_range();

for my $row ( 1 .. $row_max ) {
    for my $col ( $col_min .. $col_max ) {
        my $cell = $worksheet2->get_cell( $row, $col );
        next unless $cell;
        if ($cell->value()) {
            my $cell1;
            $cell1 = $worksheet1->get_cell( $row, 0 );
            my $familyname = $cell1->value() if $cell1;
            INFO("family name =  $familyname") if  $familyname; 
            $cell1 = $worksheet1->get_cell( $row, 2 );
            my $firstname =  $cell1->value() if $cell1;
            INFO("first name  = $firstname")  if $firstname; 
            INFO("Row, Col    = ($row, $col)");
            INFO("Value       = Excel(", $colname->[$col], ") ", $cell->value());
            # print "Unformatted = ", $cell->unformatted(), "\n";
            if (my $db_row = $rs->find($row)) {
                INFO("DB familyname = ", $db_row->familyname);
                INFO("DB firstname  = ", $db_row->firstname) if $db_row->firstname;
                WARN("($row,$col) $familyname, $firstname differs from DB") 
                    if $db_row->familyname ne $familyname or $firstname && ($db_row->firstname ne $firstname);
                my $remarks = $db_row->remarks;
                $remarks .= '; ' if $remarks;
                $remarks .=  "Excel(" . $colname->[$col] .  ") " .  $cell->value();
                $db_row->update({ remarks => $remarks });
                INFO("Remark: " . $remarks);
            } else {
                WARN("($row,$col) id $row: DB Row not found");
            }    
        }
        
    }
}

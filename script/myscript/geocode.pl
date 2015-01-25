#!/usr/bin/env perl
use utf8;
use Modern::Perl;
use Geo::Coder::OpenCage;
use FindBin qw($Bin);
use Path::Tiny;
use JSON::XS;
use lib path($Bin)->parent(2)->child('lib')->stringify; 
use Log::Log4perl qw(:easy);
use warnings  qw(FATAL utf8);    # fatalize encoding glitches
use open      qw(:std :utf8);    # undeclared streams in UTF-8

use Data::Dumper;
use WomenInBotany::Helper;

my $logfile = path($Bin)->parent(2)->child('geocode.log');

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
      path($Bin)->parent(2)
);

my $Geocoder = Geo::Coder::OpenCage->new(
    api_key => <fill in>,
);

my $rs = $schema->resultset('Botanist')->search(
    [
        {
            birthplace_id => undef,
            birthplace    => { '!=' => undef }, 
        },
        {
            deathplace_id => undef,
            deathplace    => { '!=' => undef }, 
        },
    ],
);

sub geocode {
    my $place = shift;

    INFO("Searching $place");
    my $result = $Geocoder->geocode(location => $place);
    my $total_results = $result->{total_results};
    INFO("total_results: $total_results");
    my $lat = $result->{results}[0]{geometry}{lat};
    INFO("lat: $lat");
    my $lon = $result->{results}[0]{geometry}{lng};
    INFO("long: $lon");
    my @names = map { $_->{formatted} } @{$result->{results}};
    foreach my $name (@names) {
        INFO("    " . $name);
    }
    INFO("Rest: $result->{rate}{remaining}");
    my $row = $schema->resultset('Place')->create({
        lat => $lat,
        lon => $lon,     
        json => encode_json $result,        
    });
    return unless $row;
    return $row->id;
}

my $i = 0;

while (my $row = $rs->next and $i <= 425) {

    if ($row->birthplace and !($row->birthplace_id) ) {
        my $row_id = geocode($row->birthplace);
        if ($row_id) {
            $row->update({birthplace_id => $row_id});
        }
    }
    if ($row->deathplace and !($row->deathplace_id)) {
        my $row_id = geocode($row->deathplace);
        if ($row_id) {
            $row->update({deathplace_id => $row_id});
        }
    }
    $i++;
}

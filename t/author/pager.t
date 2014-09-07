use utf8;
use Modern::Perl;
use Test::More;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin)->parent->parent->subdir('lib')->stringify;
use WomenInBotany::Helper;

my $wib_root;
BEGIN {
    die 'You must set WIB_ROOT' unless $ENV{WIB_ROOT};
    $wib_root = dir( $ENV{WIB_ROOT} );
}

ok(
   my $schema = WomenInBotany::Helper::get_schema($wib_root),
   'Got schema'
);

my $rs = $schema->resultset('Botanist')->search(
    {},
    {
        page => 23,
        rows => 1,
    }
);
my $pager = $rs->pager;
diag 'Total Entries: ' . $pager->total_entries
     ."\nEntries per Page: " . $pager->entries_per_page
     ."\nCurrent Page: " . $pager->current_page
     ."\nentries_on_this_page: " . $pager->entries_on_this_page
     ."\ncurrent_page: " . $pager->current_page
     ."\nfirst_page: " . $pager->first_page
     ."\nlast_page: " . $pager->last_page
     ."\nfirst: " . $pager->first
     ."\nlast: " . $pager->last
     ."\nprevious_page: " . $pager->previous_page
     ."\nnext_page: " . $pager->next_page;



done_testing();

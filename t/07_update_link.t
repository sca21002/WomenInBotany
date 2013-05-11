#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;
use URI;

#
# Exploring different cases for updating and creating of
# botanist to link relationships 
#

my $uri;    # URI object
my $link;   # link object = entry in table link

### prepare test cases

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok( my $botanist = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    } )->first,
    'Search botanist'
);

ok ( my $botanist_link_1 = $botanist->botanists_links->slice(1,1)->first,
    'Get botanist_link 1'    
);

is ( $botanist_link_1->id, 2, 'id of botanist_reference 1' ); 

$uri = URI->new('http://de.wikipedia.org/test');
ok ( my $botanist_link_2 = $botanist->botanists_links->create( {uri => $uri} ),
    'Create botanist_link 2'
);
ok ($botanist_link_2->discard_changes, 'discard changes');
    # necessary to get auto columns etc.

is ( $botanist_link_2->id, 3, 'id of botanist_reference 2' ); 

# branch 1:
# an existing link is updated, the uri has a new host not in the link table

$uri = URI->new('http://at.wikipedia.org/test');
$botanist_link_1->update_or_create_related( 'link', {host => $uri->host} );

# same as: $botanist_link->link->update({host => URI->new($data->{uri})->host});

# SELECT "me"."id", "me"."host", "me"."title", "me"."remarks"
#     FROM "links" "me" WHERE ( "me"."id" = ? ): '2'
# UPDATE "links" SET "host" = ? WHERE ( "id" = ? ): 'at.wikipedia.org', '2'

# branch 2:
# an existing link is updated, the new uri has an host entry in the link table

$uri = URI->new('http://de.wikipedia.org/test');
$link = $schema->resultset('Link')->find({host => $uri->host});
$botanist_link_1->link($link);

# same as: $botanist_link->update_from_related('link', $link);

# SELECT "me"."id", "me"."host", "me"."title", "me"."remarks"
#     FROM "links" "me" WHERE ( "host" = ? ): 'de.wikipedia.org'
# UPDATE "botanists_links" SET "link_id" = ? WHERE ( "id" = ? ): '1', '2'

# branch 3:
# no link exits, the uri has a new host not in the link table

$uri = URI->new('http://test.org/test');
$botanist_link_2->update_or_create_related('link', {host => $uri->host});

# SELECT "me"."id", "me"."host", "me"."title", "me"."remarks"
#     FROM "links" "me" WHERE ( "me"."id" IS NULL ): 
# INSERT INTO "links" ( "host", "id") VALUES ( ?, ? ): 'test.org', NULL

# branch 4:
# no link exits, the uri has an existing host


$botanist_link_2->link($link);

# SELECT "me"."id", "me"."botanist_id", "me"."link_id", "me"."uri",
#        "me"."last_seen"
#     FROM "botanists_links" "me" WHERE ( "me"."id" = ? ): '4'
# SELECT "me"."id", "me"."host", "me"."title", "me"."remarks"
#     FROM "links" "me" WHERE ( "host" = ? ): 'de.wikipedia.org'
# UPDATE "botanists_links" SET "link_id" = ? WHERE ( "id" = ? ): '1', '4'


done_testing();

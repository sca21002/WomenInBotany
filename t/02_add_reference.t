#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok( my $botanist = $schema->resultset('Botanist')
    ->search( {
        familyname => 'Dörrien',
        firstname  => 'Catharina Helena'
    } )->first,
    'Search botanist'
);

$botanist->add_to_references( 
    { title    => 'Unknown Book' },                                
    { citation => 'S. 123', }                               
);

is($botanist->search_related('botanists_references',
        {
            'reference.title' => 'Unknown Book',
        },
        {
            join => 'reference',
         
        }
    )->first->citation,
   'S. 123',
   'Search related: citation'
);
    
done_testing();

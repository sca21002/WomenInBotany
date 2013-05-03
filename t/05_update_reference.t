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

ok(
    my $reference = $schema->resultset('Reference')->find_or_create({
        title => 'Nissen_Bd_1',
    }),
    'Reference found',
);

my $data = {
    citation => '189',
    reference_id => $reference->id,
    oper => 'edit',
            
};

my @columns = $schema->source('BotanistReference')->columns;
my %columns;
undef @columns{@columns};

my @keys =  grep { exists $columns{$_} } keys %$data ;

my $new_data;
@{$new_data}{@keys} = @{$data}{@keys};   


ok(
    my $botanist_reference = $schema->resultset('BotanistReference')
    ->find(1)->update($new_data),
    'Citation updated',
);

is( $botanist_reference->botanist->familyname, 'Dörrien', 'Botanist found' );
    
done_testing();

#!/usr/bin/env perl
use Modern::Perl;
use utf8;
use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify,
        dir($Bin)->parent->subdir('lib')->stringify; 
use WomenInBotanyTestSchema;
use Test::More;
use Data::Dumper;
use HTTP::Cookies;

BEGIN {
    use_ok ('HTTP::Request::Common') or exit;
}

ok( my $schema = WomenInBotanyTestSchema->init_schema(populate => 1),
    'created a test schema object' );

ok(my $botanist = $schema->resultset('Botanist')
    ->search( {familyname => 'Dörrien'} )->first, 'Search botanist');
is( $botanist->firstname, 'Catharina Helena',      '... found' );
is( $botanist->botanists_categories->first->category_id, 'A',      'Category' );

$ENV{CATALYST_CONFIG} = file($Bin, qw(var womeninbotany.conf));
 
use_ok( 'Catalyst::Test', 'WomenInBotany' );
 
is( request('/')->code, 302, 'Get 302 from /' );            # redirect to login
my ($response, $c) = ctx_request(POST 'http://localhost/login',
        [username => 'admin', password => 'test']
);
ok($c->user_exists(), 'User logged in');
ok( $response->headers->header('set-cookie'), 'Cookie set when logging in.' );

my $cookie_jar = HTTP::Cookies->new();
$cookie_jar->extract_cookies($response);
my $request = HTTP::Request->new(GET => 'http://localhost/botanist/list');
$cookie_jar->add_cookie_header($request);
$response = request($request);
diag Dumper $response;


done_testing();


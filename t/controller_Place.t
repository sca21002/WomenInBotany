use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WomenInBotany';
use WomenInBotany::Controller::Place;

ok( request('/place')->is_success, 'Request should succeed' );
done_testing();

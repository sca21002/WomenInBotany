use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WomenInBotany';
use WomenInBotany::Controller::Botanist;

ok( request('/botanist')->is_success, 'Request should succeed' );
done_testing();

use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WomenInBotany';
use WomenInBotany::Controller::Link;

is( request('/botanist/list')->code, 302, 'Get 302 from /' );  # redirect to login

done_testing();

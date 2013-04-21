use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WomenInBotany';
use WomenInBotany::Controller::Botanist;

is( request('/botanist/list')->code, 302, 'Get 302 from /' );  # redirect to login

done_testing();

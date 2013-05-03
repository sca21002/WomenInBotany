use strict;
use warnings;
use Test::More;


use Catalyst::Test 'WomenInBotany';
use WomenInBotany::Controller::Reference;

is( request('/reference')->code, 302, 'Get 302 from /' );  # redirect to login
done_testing();

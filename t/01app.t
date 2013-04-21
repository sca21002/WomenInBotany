#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'WomenInBotany';


is( request('/botanist/list')->code, 302, 'Get 302 from /' );  # redirect to login


done_testing();

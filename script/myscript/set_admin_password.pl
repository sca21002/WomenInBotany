#!/usr/bin/env perl
 
use strict;
use warnings;
use lib 'lib';
 
#BEGIN { $ENV{CATALYST_DEBUG} = 0 }
 
use WomenInBotany;
use DateTime;
 
my $admin = WomenInBotany->model('WomenInBotanyDB::User')->search({ username => 'xxxx' })->single;

$admin->update({ password => 'xxxx', password_expires => DateTime->now });

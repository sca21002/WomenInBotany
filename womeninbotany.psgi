use utf8;
use strict;
use warnings;

use Path::Class qw(dir file);
use FindBin qw($Bin);
use lib dir($Bin, 'lib')->stringify;

use WomenInBotany;

my $app = WomenInBotany->apply_default_middlewares(WomenInBotany->psgi_app);
$app;


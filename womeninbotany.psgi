use strict;
use warnings;

use WomenInBotany;

my $app = WomenInBotany->apply_default_middlewares(WomenInBotany->psgi_app);
$app;


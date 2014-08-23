#!/usr/bin/perl

use strict;
use warnings;
use lib qw(/home/holznera/lib/perl5 /usr/lib/fvwm/2.6.5);
use feature 'say';

use Storable qw(store retrieve freeze);
use File::Spec::Functions;
use Const::Fast;
use Data::Dump qw(dump);

$Storable::canonical = 1;
const my  $CONFIG_FILE => catfile($ENV{HOME}, '.display.config');

my $display_config = retrieve($CONFIG_FILE);

say dump($display_config);

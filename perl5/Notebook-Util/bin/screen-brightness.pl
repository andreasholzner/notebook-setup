#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Getopt::Long;
use Const::Fast;
use Log::Log4perl qw(:easy);
use File::Spec::Functions;
use Notebook::Notify;
use Notebook::Util::Command;

Log::Log4perl->easy_init({ level => $DEBUG, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });

const my $BACKLIGHT_COMMAND => '/usr/bin/xbacklight';

chomp(my $current_brightness = `$BACKLIGHT_COMMAND -get`);
DEBUG "Found current backlight brightness: $current_brightness";

my $new_brightness;
GetOptions(
    'inc' => sub { $new_brightness = $current_brightness + 10; },
    'dec' => sub { $new_brightness = $current_brightness - 10; },
) or die "Argument must be either '--inc' or '--dec'!";
$new_brightness or die "Mandatory argument '--inc' or '--dec' missing!";

INFO "Setting backlight brightness to $new_brightness.";
Notebook::Util::Command->new($BACKLIGHT_COMMAND, '-set', $new_brightness)->run;

chomp($current_brightness = `$BACKLIGHT_COMMAND -get`);
DEBUG "Found current backlight brightness after change: $current_brightness";

notify(summary => 'Bildschirmhelligkeit', message => sprintf('%d %%', $current_brightness), timeout => 50, icon => 'brightness.png');

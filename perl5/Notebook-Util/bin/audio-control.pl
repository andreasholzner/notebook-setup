#!/usr/bin/perl

use strict;
use warnings;
use local::lib;

use File::Spec::Functions;
use Getopt::Long;
use Log::Log4perl qw(:easy);
use Notebook::Util::Notify;

Log::Log4perl->easy_init({ level => $INFO, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });

my $volume_option;
GetOptions(
    'inc' => sub { $volume_option = '5%+'; },
    'dec' => sub { $volume_option = '5%-'; },
    'mute' => sub { $volume_option = 'toggle'; },
) or die "Argument must be either '--inc', '--dec' or '--mute'!";
$volume_option or die "Mandatory argument '--inc', '--dec' or '--mute' is missing!";

my $command = "amixer -M -D pulse sset Master $volume_option";

DEBUG("changing volume: '$command'");
my @output = `$command`;

$output[-1] =~ /\[(\d+%)\]\s*\[(\w+)\]/;
my $volume = $1;
my $muted = $2 eq 'off';

my $message = $muted ? 'Audio aus' : "Lautstärke: $volume";
notify(summary => 'Lautstärke', message => $message, timeout => 50, icon => ($muted ? 'audio-off.png' : 'audio-volume.png'));

# commands for changing the volume
# amixer -M -D pulse sset Master 5%+
# amixer -M -D pulse sset Master 5%-
# muting/ unmuting
# amixer -M -D pulse sset Master toggle

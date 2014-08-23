#!/usr/bin/perl

use strict;
use warnings;
use lib qw(/home/holznera/lib/perl5 /usr/lib/fvwm/2.6.5);
use feature 'say';

use Log::Log4perl qw(:easy);
use Storable qw(store retrieve freeze);
use File::Spec::Functions;
use Notebook::Display;
use Notebook::Notify;
use FvwmCommand;
use Const::Fast;
use Data::Dump qw(dump);


Log::Log4perl->easy_init({ level => $DEBUG, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });
$Storable::canonical = 1;
const my  $CONFIG_FILE => catfile($ENV{HOME}, '.display.config');

my %display_status = get_xrandr_info;
condense_info(%display_status);

my $display_config = {};
$display_config = retrieve($CONFIG_FILE) if -e $CONFIG_FILE;

unless (%$display_config) {
    DEBUG 'No display config found in config file: ' . $CONFIG_FILE;
    my $new_config = new_current_config(%display_status);
    store($new_config, $CONFIG_FILE);
    exit 0;
}
say "YYYYYYY" . dump(\%display_status);
my $current_displays_key = get_attached_displays_key(%display_status);
say "AAAAAAAAAA $current_displays_key";
say "BBBBBBBBBB" . dump($display_config);

if ($display_config->{current_displays_key} eq $current_displays_key) {
    DEBUG 'Attached displays have not changed.';
    my $frozen_status = freeze(\%display_status);
    my $frozen_status_from_file = freeze($display_config->{display_configs}{$current_displays_key});
    if ($frozen_status ne $frozen_status_from_file) {
        update_config($display_config, %display_status);
    }
} else {
    handle_display_change($display_config, %display_status);
}

sub new_current_config {
    my %status = @_;
    my $current_key = get_attached_displays_key(%status);
    return {
        current_displays_key => $current_key,
        display_configs => {
            $current_key => { %status },
        },
    };
}

sub update_config {
    my ($config, %new_status) = @_;

    INFO 'Display config changed (but still the same displays are in use).';
    $config->{display_configs}{$config->{current_displays_key}} = { %new_status };
    store($config, $CONFIG_FILE);
    Restart();
    notify(summary => 'Display Konfiguration geändert', message => 'Geänderte Konfiguration gespeichert.', icon => 'display.png');
}

sub handle_display_change {
    my ($config, %new_status) = @_;

    INFO 'Attached displays have changed.';
    my $current_key = get_attached_displays_key(%new_status);
    if (exists $config->{display_configs}{$current_key}) {
        INFO "Found known config for attached displays '$current_key'.";
        # TODO
        # apply config
        # restart Fvwm
        # message to user
    } else {
        # TODO
        # activate display
        # restart Fvwm
        # message to user
    }
}

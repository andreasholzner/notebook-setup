#!/usr/bin/perl

use strict;
use warnings;
use local::lib;
use lib qw(/usr/lib/fvwm/2.6.5);
use feature 'say';

use Log::Log4perl qw(:easy);
use Storable qw(store retrieve freeze);
use File::Spec::Functions;
use Notebook::Display::Information;
use Notebook::Display::Configuration;
use Notebook::Notify;
use FvwmCommand;
use Const::Fast;
use Data::Dump qw(dump);


Log::Log4perl->easy_init({ level => $TRACE, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });
$Storable::canonical = 1;
const my  $CONFIG_FILE => catfile($ENV{HOME}, '.display.config');

# TODO: should look like
# my $conf = Configurator->new($CONFIG_FILE);
# $conf->obtain_info();
# $conf->update();
#
# or Configurator->new($CONFIG_FILE)->new();


my %display_status = get_xrandr_info;

my $display_config = {};
$display_config = retrieve($CONFIG_FILE) if -e $CONFIG_FILE;

unless (%$display_config) {
    DEBUG 'No display config found in config file: ' . $CONFIG_FILE;
    my $new_config = new_current_config(%display_status);
    store($new_config, $CONFIG_FILE);
    exit 0;
}
my $current_displays_key = get_attached_displays_key(%display_status);
DEBUG "Determined current display key: $current_displays_key";
TRACE "Config file content: " . dump($display_config);

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

sub update_config {
    my ($config, %new_status) = @_;

    INFO 'Display config changed (but still the same displays are in use).';
    $config->{display_configs}{$config->{current_displays_key}} = { %new_status };
    store($config, $CONFIG_FILE);
    FvwmCommand::FvwmCommand('Restart');
    notify(summary => 'Display Konfiguration geändert', message => 'Geänderte Konfiguration gespeichert.', icon => 'display.png');
}

sub handle_display_change {
    my ($config, %new_status) = @_;

    INFO 'Attached displays have changed.';
    my $current_key = get_attached_displays_key(%new_status);
    DEBUG "new displays_key: $current_key";
    if (exists $config->{display_configs}{$current_key}) {
        INFO "Found known config for attached displays '$current_key'.";
        configure_displays(%{$config->{display_configs}{$current_key}});
        FvwmCommand::FvwmCommand('Restart');
        notify(summary => 'Display Konfiguration geändert', message => 'Bekannte Einstellung angewandt.', icon => 'display.png');
        # TODO: update config
    } else {
        configure_displays(%new_status);
        FvwmCommand::FvwmCommand('Restart');
        notify(summary => 'Display Konfiguration geändert', message => 'Neue Einstellung geraten.', icon => 'display.png');
        # TODO: add new configuration to config
    }
}

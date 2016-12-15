package Notebook::Display::Configuration;

use strict;
use warnings;
use lib qw(/usr/lib/fvwm/2.6.5);

use Log::Log4perl qw(:easy);
use Const::Fast;
use Parse::EDID;
use Notebook::Display::Information qw(get_xrandr_info get_attached_displays_key);
use Notebook::Util::Command;
use Storable qw(store retrieve freeze);
use Notebook::Notify;
use FvwmCommand;
use Data::Dump qw(dump);

$Storable::canonical = 1;

sub new {
    my ($class, %args) = @_;

    my $self = {
        config_file => $args{config_file},
    };
    DEBUG "using config file: $self->{config_file}";
    bless $self, $class;
}

sub update {
    my $self = shift;

    my %display_status = %{get_xrandr_info()};

    my $display_config = {};
    $display_config = retrieve($self->{config_file}) if -e $self->{config_file};

    unless (%$display_config) {
        DEBUG 'No display config found in config file: ' . $self->{config_file};
        my $new_config = new_current_config(%display_status);
        TRACE 'Determined config: ' . dump($new_config);
        store($new_config, $self->{config_file});
        exit 0;
    }
    my $current_displays_key = get_attached_displays_key(%display_status);
    DEBUG "Determined current display key: $current_displays_key";
    TRACE "Config file content: " . dump($display_config);

    if ($display_config->{current_displays_key} eq $current_displays_key) {
        DEBUG 'Attached displays have not changed.';
        TRACE 'Comparing A: ' . dump(\%display_status) . "\nwith B: " . dump($display_config->{display_configs}{$current_displays_key});
        my $frozen_status = freeze(\%display_status);
        my $frozen_status_from_file = freeze($display_config->{display_configs}{$current_displays_key});
        if ($frozen_status ne $frozen_status_from_file) {
            $self->update_config($display_config, %display_status);
        }
    } else {
        $self->handle_display_change($display_config, %display_status);
    }
}

sub configure_displays {
    my %contact_status = @_;

    my @xrandr_args = ();
    foreach my $pin (keys %contact_status) {
        push @xrandr_args, '--output', $pin;
        if ($contact_status{$pin}{is_connected}) {
            push @xrandr_args, '--primary' if $contact_status{$pin}{is_primary};
            if ($contact_status{$pin}{resolution}) {
                push @xrandr_args, '--mode', $contact_status{$pin}{resolution};
            } else {
                push @xrandr_args, '--auto';
            }
            if ($contact_status{$pin}{position}) {
                $contact_status{$pin}{position} =~ /([-+]\d+)([-+]\d+)/;
                push @xrandr_args, '--pos', "${1}x$2";
            }
        } else {
            push @xrandr_args, '--off';
        }
    }

    Notebook::Util::Command->new('xrandr', @xrandr_args)->run();
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
    my ($self, $config, %new_status) = @_;

    INFO 'Display config changed (but still the same displays are in use).';
    $config->{display_configs}{$config->{current_displays_key}} = { %new_status };
    store($config, $self->{config_file});
    FvwmCommand::FvwmCommand('Restart');
    notify(summary => 'Display Konfiguration geändert', message => 'Geänderte Konfiguration gespeichert.', icon => 'display.png');
}

sub handle_display_change {
    my ($self, $config, %new_status) = @_;

    INFO 'Attached displays have changed.';
    my $current_key = get_attached_displays_key(%new_status);
    DEBUG "new displays_key: $current_key";
    if (exists $config->{display_configs}{$current_key}) {
        INFO "Found known config for attached displays '$current_key'.";
        configure_displays(%{$config->{display_configs}{$current_key}});
        FvwmCommand::FvwmCommand('Restart');
        notify(summary => 'Display Konfiguration geändert', message => 'Bekannte Einstellung angewandt.', icon => 'display.png');
    } else {
        configure_displays(%new_status);
        $config->{display_configs}{$current_key} = { %new_status };
        FvwmCommand::FvwmCommand('Restart');
        notify(summary => 'Display Konfiguration geändert', message => 'Neue Einstellung geraten.', icon => 'display.png');
    }
    $config->{current_displays_key} = $current_key;
    store($config, $self->{config_file});
}

1;

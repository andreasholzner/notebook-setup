#!/usr/bin/perl

use strict;
use warnings;

use Const::Fast;
use Gtk3 -init;
use Log::Log4perl qw(:easy);
use File::Spec::Functions;
use Linux::Inotify2;
use Config::Auto;
use Notebook::Util::Command;
use Notebook::Notify;
use Notebook::Monitor::Battery;

Log::Log4perl->easy_init({ level => $DEBUG, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });

const my $CONFIG_FILE => catfile($ENV{HOME}, '.config/battery-monitor.conf');

my $CONFIG;

### MAIN ###
read_config();
my $battery = Notebook::Monitor::Battery->new(device => $CONFIG->{battery_device});
my $icon = Gtk3::StatusIcon->new();
my $last_state = '';
my $inotify = Linux::Inotify2->new;
$inotify->watch($CONFIG_FILE, IN_MODIFY, \&read_config);

update({ status_icon => $icon, battery => $battery, last_state => \$last_state });

Glib::Timeout->add_seconds(2, \&update, { status_icon => $icon, battery => $battery, last_state => \$last_state });
Glib::IO->add_watch($inotify->fileno, in => sub { $inotify->poll; 1; });

Gtk3->main;
### MAIN END ###

sub update {
    my $params = shift;
    my ($battery, $status_icon, $status_ref) = @{$params}{qw(battery status_icon last_state)};
    $battery->update;
    my $config = find_config_state($battery->status);
    my $new_status = $battery->status->{state} . $config->{percentage_upto};

    $status_icon->set_from_file(catfile($CONFIG->{icon_dir}, $config->{icon}));
    $status_icon->set_tooltip_text(prepare_tooltip($config->{tooltip}, $battery->status));

    if ($new_status ne $$status_ref) {
        INFO "BatteryMonitor status change: '$$status_ref' => '$new_status'";
        if ($config->{action}) {
            eval { $config->{action}->($battery); };
            ERROR "eval of action failed: $@" if $@;
        }
        $$status_ref = $new_status;
    }
    1;
}

sub find_config_state {
    my $battery_status = shift;

    my $percent;
    {
        no warnings 'numeric';
        $percent = int $battery_status->{percentage};
    }
    my $state = $battery_status->{state};
    my $list_to_check = $CONFIG->{status}->{$state};
    my $target_idx = 0;
    ++$target_idx until $percent <= $list_to_check->[$target_idx]{percentage_upto};

    return $list_to_check->[$target_idx];
}

sub prepare_tooltip {
    my ($template, $status) = @_;

    $template =~ s/<<([^>]*)>>/$status->{$1} or '?'/ge;
    return $template;
}

sub read_config {
    INFO "reading config file '$CONFIG_FILE'";
    my $ca = Config::Auto->new(source => $CONFIG_FILE);
    $CONFIG = $ca->parse;
}

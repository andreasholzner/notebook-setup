package Notebook::Display;

use strict;
use warnings;

use Exporter;
use Const::Fast;
use Parse::EDID;
use List::Util qw(first any);
use Notebook::Util::Command;

our @ISA = qw(Exporter);
our @EXPORT = qw(
                    get_xrandr_info
                    get_attached_displays_key
                    configure_displays
            );
our @EXPORT_OK = qw(
                       analyze_status_line
                       get_monitor_name
                       get_edid
               );

const our $INTERNAL_DISPLAY_NAME => 'intern';

sub get_attached_displays_key {
    my %contact_status = @_;
    my @display_keys = ();
    foreach my $pin (sort keys %contact_status) {
        no warnings 'uninitialized';
        if ($contact_status{$pin}{is_connected}) {
            push @display_keys, join ';', $pin, $contact_status{$pin}{name};
        }
    }
    return join ':', @display_keys;
}

sub get_xrandr_info {
    my %contact_status = ();
    my $current_pin;
    foreach (Notebook::Util::Command->new('xrandr --prop')->run_with_backticks()) {
        chomp;
        next if /^Screen/;
        if (/^\S/) {
            $current_pin = (split)[0];
        }
        if ($current_pin) {
            push @{$contact_status{$current_pin}{raw}}, $_;
        }
    }

    foreach (keys %contact_status) {
        my $raw_data = $contact_status{$_}{raw};
        analyze_status_line($contact_status{$_});
        if ($contact_status{$_}{is_connected}) {
            $contact_status{$_}{name} = get_monitor_name($raw_data);
        }
        delete $contact_status{$_}{raw};
    }

    return %contact_status;
}

sub analyze_status_line {
    my $contact_data = shift;
    my @infos = split ' ', $contact_data->{raw}[0];
    $contact_data->{is_connected} = $infos[1] eq 'connected' ? 1 : 0;
    if ($contact_data->{is_connected}) {
        $contact_data->{is_primary} = $infos[2] eq 'primary' ? 1 : 0;
        my $resolution_idx = $contact_data->{is_primary} ? 3 : 2;
        if ($infos[$resolution_idx] =~ /(\d+x\d+)([+]\d+[+]\d+)/) {
            $contact_data->{resolution} = $1;
            $contact_data->{position} = $2;
        }
    }
}

sub get_monitor_name {
    my $raw_data = shift;
    my $edid = get_edid($raw_data);

    $edid->{monitor_name} or guess_internal_display($raw_data);
}

sub get_edid {
    my $raw_lines = shift;
    my $source = join "\n", @$raw_lines;

    local $SIG{__WARN__} = sub {};
    eval {
        parse_edid(find_edid_in_string($source));
    }
}

sub guess_internal_display {
    my $raw_data = shift;

    my $connector_type_line = first { /ConnectorType:/ } @$raw_data;
    if ($connector_type_line) {
        $connector_type_line =~ /ConnectorType:\s*(\S+)/;
        return $1 eq 'Panel' ? $INTERNAL_DISPLAY_NAME : undef;
    }

    my $has_backlight = any { /backlight/i } @$raw_data;
    return $has_backlight ? $INTERNAL_DISPLAY_NAME : undef;
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

1;

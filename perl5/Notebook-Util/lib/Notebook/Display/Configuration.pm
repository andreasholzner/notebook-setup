package Notebook::Display::Configuration;

use strict;
use warnings;

use Exporter;
use Const::Fast;
use Parse::EDID;
use Notebook::Util::Command;

use base qw(Exporter);
our @EXPORT = qw(configure_displays);

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

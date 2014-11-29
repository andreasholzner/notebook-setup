#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(/usr/lib/fvwm/2.6.5);
use FvwmCommand;
use List::Util qw(first);

my @export_keys = qw(GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID);

my @output = `/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg`;

foreach my $key (@export_keys) {
    my $line = first { /$key/ } @output;
    if ($line) {
    my $value = (split /=/, $line)[1];
        chomp $value;
        FvwmCommand::FvwmCommand('SetEnv', $key, $value);
    }
}
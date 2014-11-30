#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);

use List::Util qw(first);
use File::Spec::Functions;
use Log::Log4perl qw(:easy);

Log::Log4perl->easy_init({ level => $INFO, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });

my @export_keys = qw(GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID);

my @output = `/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg`;
DEBUG @output;

foreach my $key (@export_keys) {
    my $line = first { /$key/ } @output;
    if ($line) {
        my $value = (split /=/, $line)[1];
        chomp $value;
        DEBUG "setting environment: $key => $value";
        say "SetEnv $key $value";
    }
}

__END__

example output of gnome-keyring-daemon:
GNOME_KEYRING_CONTROL=/run/user/1000/keyring-NUiyVd
SSH_AUTH_SOCK=/run/user/1000/keyring-NUiyVd/ssh
GPG_AGENT_INFO=/run/user/1000/keyring-NUiyVd/gpg:0:1

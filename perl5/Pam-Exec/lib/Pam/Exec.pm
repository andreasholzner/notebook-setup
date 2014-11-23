use strict;
use warnings;
package Pam::Exec;

# ABSTRACT: Use pam_exec to run user defined command for session entry and exit

use File::HomeDir;
use File::Spec::Functions;
use Config::Auto;
use List::Util qw(first);
use Unix::Syslog qw(:macros :subs);

sub new {
    my ($class, $pam_user) = @_;

    my $user_home = File::HomeDir->users_home($pam_user);
    my @config_candidates = map { catfile($user_home, $_) } qw(.config/pam-exec.ini .pam-exec.ini);
    my $config_file = first { -e $_ } @config_candidates;

    bless {
        config => $config_file ? Config::Auto->new(source => $config_file)->parse : {},
        user => $pam_user,
    }, $class;
}

sub run {
    my ($self, $pam_service, $pam_type) = @_;

    if (exists $self->{config}{$pam_service}{$pam_type}) {
        syslog LOG_INFO, 'running configured command for service "%s" and type "%s"', $pam_service, $pam_type;
        if (ref $self->{config}{$pam_service}{$pam_type} eq 'ARRAY') {
            $self->command($_) foreach @{$self->{config}{$pam_service}{$pam_type}};
        } else {
            $self->command($self->{config}{$pam_service}{$pam_type});
        }
    }
}

sub command {
    my ($self, $cmd) = @_;

    my $user = $self->{user};
    syslog LOG_DEBUG, 'calling the command: "%s" as user "%s"', $cmd, $user;
    system "sudo -iu $user $cmd";
}

1;

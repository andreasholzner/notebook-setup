package Notebook::Notify;

use strict;
use warnings;

use Exporter;
use File::Find;
use File::Spec::Functions;
use Carp;
use Config::Auto;
use String::ShellQuote;
use Const::Fast;
use Notebook::Util::Command;

our @ISA = qw(Exporter);
our @EXPORT = qw(notify);

const my $CONFIG_FILE => catfile($ENV{HOME}, '.config/notebook-setup.ini');

sub notify {
    my %config = @_;

    my $notify_conf = _read_config($CONFIG_FILE);

    $config{summary} or croak "Missing argument 'summary' for 'notify'!";

    my @notify_options = ();
    if ($config{icon}) {
        my $icon_file;
        find(sub {
                 $icon_file = $File::Find::name if $_ eq $config{icon};
             }, catdir($ENV{HOME}, $notify_conf->{icon_dir}));
        push @notify_options, "--icon=$icon_file";
    }
    $config{timeout} //= 50;
    push @notify_options, "--expire-time=$config{timeout}";
    push @notify_options, shell_quote $config{summary};
    push @notify_options, shell_quote $config{message} if $config{message};

    Notebook::Util::Command->new(_as_desktop_user($notify_conf->{desktop_user}, 'killall notify-osd'))->run;
    Notebook::Util::Command->new(_as_desktop_user($notify_conf->{desktop_user}, join ' ', $notify_conf->{binary}, @notify_options))->run;
}

sub _read_config {
    my $file = shift;
    my $ca = Config::Auto->new(source => $file);
    my $config = $ca->parse;
# TODO deal with missing config
    my %notify_data = %{$config->{Notify}};
    return \%notify_data;
}

sub _as_desktop_user {
    my ($user, $cmd) = @_;

    return getpwuid $< eq $user ? $cmd : 'su ' . $user . ' -c ' . shell_quote $cmd;
}

1;

package Notebook::Util::Command;

use strict;
use warnings;

use Config;
use Log::Log4perl qw(get_logger);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ();
our @EXPORT_OK = qw(analyze_return_code);

my $logger = get_logger(__PACKAGE__);
my @signal_names = split ' ', $Config{sig_name};

sub new {
    my ($class, @command) = @_;

    my $self = {
        command => \@command,
        readable_command => join( ' ', @command),
        return_code => undef,
    };
    bless $self, $class;

    return $self;
}

sub run {
    my $self = shift;

    $logger->info("Executing command '" . $self->{readable_command} . "'");
    system @{$self->{command}};
    $self->{return_code} = $?;
}

sub handle_result {
    my ($self, %handlers) = @_;

    $self->_setup_default_handlers(\%handlers);

    if ($self->{return_code} != 0) {
        $handlers{failure}->(analyze_return_code($self->{return_code}));
    } else {
        $handlers{success}->();
    }
}

sub run_and_handle {
    my ($self, %handlers) = @_;

    $self->run;
    $self->handle_result(%handlers);
}

sub analyze_return_code {
        my ($return_code) = @_;
        my $message = '';

        my $exit_code = $return_code >> 8;
        $message .= "Command exited with exit code: $exit_code." if $exit_code;

        my $signal = $return_code & 127;
        $message .= "Command was ended by signal: $signal (SIG$signal_names[$signal])." if $signal;

        $message .= ' Core dumped.' if $return_code & 128;

        return $message;
}

sub _setup_default_handlers {
    my ($self, $handlers) = @_;

    unless (exists $handlers->{success}) {
        $handlers->{success} = sub {
            my $message = shift;
            $logger->info("Command '" . $self->{readable_command} . "' was run successfully.");
        };
    }
    unless (exists $handlers->{failure}) {
        $handlers->{failure} = sub {
            my $message = shift;
            $logger->error("Executing command '" . $self->{readable_command} . "' failed: " . $message);
        };
    }
}

1;

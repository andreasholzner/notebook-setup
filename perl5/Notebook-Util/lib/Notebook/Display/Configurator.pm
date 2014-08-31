package Notebook::Display::Configurator;

use strict;
use warnings;

use Log::Log4perl qw(get_logger);

sub new {
    my ($class, $config_file) = @_;

    my $self = {
        config_file => $config_file,
        display_config => undef,
        display_status => undef,
        current_displays_key => undef,
    };

    bless $self, $class;
}

1;

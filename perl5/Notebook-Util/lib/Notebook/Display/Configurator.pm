package Notebook::Display::Configurator;

use Moose;
use namespace::autoclean;

use File::Spec::Functions;
use Log::Log4perl qw(get_logger);
use Storable;

$Storable::canonical = 1;

has config => (
    is => 'ro',
    writer => '_set_config',
    isa => 'HashRef',
);

sub BUILD {
    my ($self, $args) = @_;

    unless ($self->config) {
        my $config_file = $args->{config_file} // catfile($ENV{HOME}, '.config/displays.config');
        my $config_from_file = {};
        $config_from_file = retrieve($config_file) if -e $config_file;
        $self->_set_config($config_from_file) if %$config_from_file;
    }
}

sub run {
    my $self = shift;
}

__PACKAGE__->meta->make_immutable;
1;

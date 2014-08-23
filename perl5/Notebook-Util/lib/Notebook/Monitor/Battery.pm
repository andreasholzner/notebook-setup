package Notebook::Monitor::Battery;

use Moose;
use namespace::autoclean;

has 'device' => (
    is => 'rw',
);

has 'status' => (
    is => 'ro',
    isa => 'HashRef',
    writer => '_set_status',
);

sub BUILD {
    my $self = shift;

    $self->update;
}

sub update {
    my $self = shift;

    my @raw_data = $self->_get_upower_info;
    my @battery_data = $self->_extract_battery_data(@raw_data);

    my %data = map { /^\s+([^:]+):\s*(\S.*)$/; $1 => $2 } @battery_data;
    $self->_set_status(\%data);
}

sub _get_upower_info {
    my $self = shift;

    my $cmd = 'upower -i ' . $self->device;
    chomp(my @lines = `$cmd`);
    return @lines;
}

sub _extract_battery_data {
    my ($self, @data) = @_;

    my $idx_start;
    my $idx_end;
    for (my $line_nr = 0; $line_nr != scalar @data; ++$line_nr) {
        if ($data[$line_nr] =~ /^(\s*)battery$/) {
            my $offset = $1 x 2;
            $idx_start = ++$line_nr;
            ++$line_nr while ($data[$line_nr] and $data[$line_nr] =~ /^$offset/);
            $idx_end = $line_nr - 1;
            last;
        }
    }
    @data[$idx_start..$idx_end];
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

package Notebook::Display::Information;

use Moose;
use namespace::autoclean;

use Const::Fast;
use Parse::EDID;
use List::Util 1.33 qw(first any);
use Notebook::Util::Command;

const our $INTERNAL_DISPLAY_NAME => 'intern';

has contact_status => (
    is => 'ro',
    writer => '_set_contact_status',
    isa => 'HashRef',
    init_arg => undef,
);

has display_key => (
    is => 'ro',
    writer => '_set_display_key',
    isa => 'Str',
    init_arg => undef,
);

sub obtain_info_from_xrandr {
    my $self = shift;

    my $contact_status = {};
    my $current_pin;
    foreach (Notebook::Util::Command->new('xrandr --prop')->run_with_backticks()) {
        chomp;
        next if /^Screen/;
        if (/^\S/) {
            $current_pin = (split)[0];
        }
        if ($current_pin) {
            push @{$contact_status->{$current_pin}{raw}}, $_;
        }
    }

    foreach (keys %$contact_status) {
        my $raw_data = $contact_status->{$_}{raw};
        $self->_analyze_status_line($contact_status->{$_});
        if ($contact_status->{$_}{is_connected}) {
            $contact_status->{$_}{name} = $self->_get_monitor_name($raw_data);
        }
        delete $contact_status->{$_}{raw};
    }

    $self->_set_contact_status($contact_status);

    $self->_set_display_key($self->_determine_display_key)
}

sub _determine_display_key {
    my $self = shift;

    my @display_keys = ();
    foreach my $pin (sort keys %{$self->contact_status}) {
        no warnings 'uninitialized';
        if ($self->contact_status->{$pin}{is_connected}) {
            push @display_keys, join ';', $pin, $self->contact_status->{$pin}{name};
        }
    }
    return join ':', @display_keys;
}

sub _analyze_status_line {
    my ($self, $contact_data) = @_;

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

sub _get_monitor_name {
    my ($self, $raw_data) = @_;

    my $edid = $self->_get_edid($raw_data);

    $edid->{monitor_name} or $self->_guess_internal_display($raw_data);
}

sub _get_edid {
    my ($self, $raw_lines) = @_;

    my $source = join "\n", @$raw_lines;

    local $SIG{__WARN__} = sub {};
    eval {
        parse_edid(find_edid_in_string($source));
    }
}

sub _guess_internal_display {
    my ($self, $raw_data) = @_;

    my $connector_type_line = first { /ConnectorType:/ } @$raw_data;
    if ($connector_type_line) {
        $connector_type_line =~ /ConnectorType:\s*(\S+)/;
        return $1 eq 'Panel' ? $INTERNAL_DISPLAY_NAME : undef;
    }

    my $has_backlight = any { /backlight/i } @$raw_data;
    return $has_backlight ? $INTERNAL_DISPLAY_NAME : undef;
}

__PACKAGE__->meta->make_immutable;
1;

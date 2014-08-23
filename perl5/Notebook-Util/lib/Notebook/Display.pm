package Notebook::Display;

use strict;
use warnings;

use Exporter;
use Parse::EDID;

our @ISA = qw(Exporter);
our @EXPORT = qw(
                    get_xrandr_info
                    condense_info
                    get_attached_displays_key
            );
our @EXPORT_OK = qw(
                       analyze_status_line
                       get_monitor_name
                       get_edid
                       get_resolutions
               );

sub get_attached_displays_key {
    my %contact_status = @_;
    my @display_keys = ();
    foreach my $pin (sort keys %contact_status) {
        no autovivification;
        no warnings 'uninitialized';
        push @display_keys, join ';', $pin, @{$contact_status{$pin}}{qw(is_connected name)};
    }
    return join ':', @display_keys;
}

sub condense_info {
    my %full_status = @_;
    foreach my $pin (keys %full_status) {
        delete $full_status{$pin}{available_resolutions};
    }
}

sub get_xrandr_info {
    my %contact_status = ();
    my $current_pin;
    foreach (`xrandr --prop`) {
        chomp;
        if (/connected/) {
            $current_pin = (split)[0];
        }
        if ($current_pin) {
            push @{$contact_status{$current_pin}{raw}}, $_;
        }
    }

    foreach (keys %contact_status) {
        my $raw_data = $contact_status{$_}{raw};
        analyze_status_line($contact_status{$_});
        if ($contact_status{$_}{is_connected}) {
            $contact_status{$_}{name} = $_ ne 'eDP1' ? get_monitor_name($raw_data) : 'intern';
            $contact_status{$_}{available_resolutions} = get_resolutions($raw_data);
        }
        delete $contact_status{$_}{raw};
    }

    return %contact_status;
}

sub analyze_status_line {
    my $contact_data = shift;
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

sub get_monitor_name {
    my $edid = get_edid(@_);
    $edid->{monitor_name}
}

sub get_edid {
    my $raw_lines = shift;
    my $source = join "\n", @$raw_lines;

    local $SIG{__WARN__} = sub {};
    eval {
        parse_edid(find_edid_in_string($source));
    }
}

sub get_resolutions {
    my $raw_lines = shift;
    my @resolutions = ();
    foreach (@$raw_lines) {
        push @resolutions, $1 if /^\s*(\d+x\d+)/;
    }
    return \@resolutions;
}

1;

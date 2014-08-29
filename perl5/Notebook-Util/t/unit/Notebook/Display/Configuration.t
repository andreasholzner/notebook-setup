use strict;
use warnings;

use local::lib;
use Test::More;
use Test::MockModule;
use Notebook::Display::Configuration;

subtest 'configure_displays' => sub {
    my @commands;
    my $mock = Test::MockModule->new('Notebook::Util::Command');
    $mock->mock('run' => sub {
                    push @commands, shift->{readable_command};
                });

    subtest 'with known config' => sub {
        @commands = ();
        my %status = (
                      "DP-0"    => { is_connected => 0 },
                      "DVI-I-0" => { is_connected => 0 },
                      "DVI-I-1" => {
                                    is_connected => 1,
                                    is_primary => 0,
                                    name => "SMBX2235",
                                    position => "+1920+0",
                                    resolution => "1920x1080",
                                   },
                      "HDMI-0"  => { is_connected => 0 },
                      "LVDS-0"  => {
                                    is_connected => 1,
                                    is_primary => 1,
                                    name => "intern",
                                    position => "+0+0",
                                    resolution => "1920x1080",
                                   },
                     );

        Notebook::Display::Configuration::configure_displays(%status);

        is scalar @commands => 1, 'number of xrandr calls';
        is index($commands[0], 'xrandr') => 0, 'call to xrandr';
        isnt index($commands[0], '--output DVI-I-1 --mode 1920x1080 --pos +1920x+0') => -1, 'arguments for second display' or diag('got ' . $commands[0]);
        isnt index($commands[0], '--output LVDS-0 --primary --mode 1920x1080 --pos +0x+0') => -1, 'arguments for intern display' or diag('got ' . $commands[0]);
        foreach my $pin (qw(DP-0 DVI-I-0 HDMI-0)) {
            isnt index($commands[0], "--output $pin --off") => -1, "disconnected display $pin" or diag('got ' . $commands[0]);
        }
    };

    subtest 'with only partially known config' => sub {
        @commands = ();
        my %status = (
                      "DVI-I-1" => {
                                    is_connected => 1,
                                    is_primary => 0,
                                    name => "SMBX2235",
                                    position => "+1920+0",
                                    resolution => "1920x1080",
                                   },
                      "HDMI-0"  => { is_connected => 0 },
                      "LVDS-0"  => {
                                    is_connected => 1,
                                    is_primary => 1,
                                    name => "intern",
                                   },
                     );

        Notebook::Display::Configuration::configure_displays(%status);

        is scalar @commands => 1, 'number of xrandr calls';
        is index($commands[0], 'xrandr') => 0, 'call to xrandr';
        isnt index($commands[0], '--output DVI-I-1 --mode 1920x1080 --pos +1920x+0') => -1, 'arguments for second display' or diag('got ' . $commands[0]);
        isnt index($commands[0], '--output LVDS-0 --primary --auto') => -1, 'arguments for intern display' or diag('got ' . $commands[0]);
        isnt index($commands[0], '--output HDMI-0 --off') => -1, 'disconnected display HDMI-0' or diag('got ' . $commands[0]);
    };
};

done_testing;

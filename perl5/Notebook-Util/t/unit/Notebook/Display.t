use strict;
use warnings;

use Test::More;
use Test::MockModule;
use Notebook::Display;

subtest 'get_monitor_name' => sub {
	my $edid = <<'ENDL';
	EDID: 
		00ffffffffffff004c2d000735303030
		0a15010380301b782a78f1a655489b26
		125054bfef80714f8100814081809500
		b300a940950f023a801871382d40582c
		4500dd0c1100001e000000fd00384b1e
		5111000a202020202020000000fc0053
		4d4258323233350a20202020000000ff
		0048394d423330313238330a2020015c
		02010400023a80d072382d40102c4580
		dd0c1100001e011d007251d01e206e28
		5500dd0c1100001e011d00bc52d01e20
		b8285540151e1100001e8c0ad0902040
		31200c405500dd1e110000188c0ad08a
		20e02d10103e9600dd1e110000180000
		00000000000000000000000000000000
		00000000000000000000000000000099
ENDL

	is Notebook::Display::get_monitor_name([ split /\n/, $edid ]) => 'SMBX2235';
};

subtest 'get_attached_displays_key' => sub {
	my %contact_status = (
						  'HDMI-0' => { is_connected => 0 },
						  'LVDS-0' => {
									   is_connected => 1,
									   name => undef,
									  },
						  VGA => {
								  is_connected => 1,
								  name => 'SMBX2235',
								 },
						 );

	is Notebook::Display::get_attached_displays_key(%contact_status)
		=> 'LVDS-0;:VGA;SMBX2235';
};

subtest 'analyze_status_line' => sub {
	subtest 'disconnected display' => sub {
		my $data = {
					raw => [ 'HDMI-0 disconnected (normal left inverted right x axis y axis)' ],
				   };

		Notebook::Display::analyze_status_line($data);

		is scalar keys %$data => 2;
		is $data->{is_connected} => 0;
	};

	subtest 'connected display' => sub {
		my $data = {
					raw => [ 'DVI-I-1 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 477mm x 268mm' ],
				   };

		Notebook::Display::analyze_status_line($data);

		is scalar keys %$data => 5;
		is $data->{is_connected} => 1;
		is $data->{is_primary} => 0;
		is $data->{resolution} => '1920x1080';
		is $data->{position} => '+1920+0';
	};
};

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

		Notebook::Display::configure_displays(%status);

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

		Notebook::Display::configure_displays(%status);

		is scalar @commands => 1, 'number of xrandr calls';
		is index($commands[0], 'xrandr') => 0, 'call to xrandr';
		isnt index($commands[0], '--output DVI-I-1 --mode 1920x1080 --pos +1920x+0') => -1, 'arguments for second display' or diag('got ' . $commands[0]);
		isnt index($commands[0], '--output LVDS-0 --primary --auto') => -1, 'arguments for intern display' or diag('got ' . $commands[0]);
		isnt index($commands[0], '--output HDMI-0 --off') => -1, 'disconnected display HDMI-0' or diag('got ' . $commands[0]);
	};
};

subtest 'get_xrandr_info' => sub {
	my $mock = Test::MockModule->new('Notebook::Util::Command');
	$mock->mock('run_with_backticks' => \&get_xrandr_output);

	my %contact_status = get_xrandr_info();

	is_deeply \%contact_status => {
								   'LVDS-0' => {
												is_connected => 1,
												is_primary => 1,
												name => 'intern',
												resolution => '1920x1080',
												position => '+0+0',
											   },
								   'DVI-I-1' => {
												 is_connected => 1,
												 is_primary => 0,
												 name => 'SMBX2235',
												 resolution => '1920x1080',
												 position => '+1920+0',
											   },
								   'DVI-I-0' => { is_connected => 0 },
								   'HDMI-0' => { is_connected => 0 },
								   'DP-0' => { is_connected => 0 },
								  }, 'display information';
};

done_testing;

sub get_xrandr_output {
	my $output = <<'ENDL';
Screen 0: minimum 8 x 8, current 3840 x 1080, maximum 16384 x 16384
DVI-I-0 disconnected (normal left inverted right x axis y axis)
        BorderDimensions: 4 
                supported: 4
        Border: 0 0 0 0 
                range: (0, 65535)
        SignalFormat: VGA 
                supported: VGA
        ConnectorType: DVI-I 
        ConnectorNumber: 3 
        _ConnectorLocation: 3 
LVDS-0 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 344mm x 194mm
        EDID: 
                00ffffffffffff0030e4d90200000000
                00140104902213780a15d59e59509826
                0e505400000001010101010101010101
                0101010101017e3680b070381f403020
                350058c210000018542480b070381f40
                3020350058c210000018000000fe004d
                43364a4e813135365746310a00000000
                000041319e0000000002010a20200030
        BorderDimensions: 4 
                supported: 4
        Border: 0 0 0 0 
                range: (0, 65535)
        SignalFormat: LVDS 
                supported: LVDS
        ConnectorType: Panel 
        ConnectorNumber: 0 
        _ConnectorLocation: 0 
   1920x1080      59.9*+   39.9  
HDMI-0 disconnected (normal left inverted right x axis y axis)
        BorderDimensions: 4 
                supported: 4
        Border: 0 0 0 0 
                range: (0, 65535)
        SignalFormat: TMDS 
                supported: TMDS
        ConnectorType: HDMI 
        ConnectorNumber: 7 
        _ConnectorLocation: 7 
DVI-I-1 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 477mm x 268mm
        EDID: 
                00ffffffffffff004c2d000735303030
                0a15010380301b782a78f1a655489b26
                125054bfef80714f8100814081809500
                b300a940950f023a801871382d40582c
                4500dd0c1100001e000000fd00384b1e
                5111000a202020202020000000fc0053
                4d4258323233350a20202020000000ff
                0048394d423330313238330a2020015c
                02010400023a80d072382d40102c4580
                dd0c1100001e011d007251d01e206e28
                5500dd0c1100001e011d00bc52d01e20
                b8285540151e1100001e8c0ad0902040
                31200c405500dd1e110000188c0ad08a
                20e02d10103e9600dd1e110000180000
                00000000000000000000000000000000
                00000000000000000000000000000099
        BorderDimensions: 4
                supported: 4
        Border: 0 0 0 0
                range: (0, 65535)
        SignalFormat: TMDS
                supported: TMDS
        ConnectorType: DVI-I
        ConnectorNumber: 3
        _ConnectorLocation: 3
   1920x1080      60.0*+   50.0
   1680x1050      60.0
   1600x1200      60.0
   1440x900       75.0     59.9
   1280x1024      75.0     60.0
   1280x960       60.0
   1280x800       59.8
   1280x720       60.0     50.0
   1152x864       75.0
   1024x768       75.0     70.1     60.0
   800x600        75.0     72.2     60.3     56.2
   720x576        50.0
   720x480        59.9
   640x480        75.0     72.8     59.9
DP-0 disconnected (normal left inverted right x axis y axis)
        BorderDimensions: 4
                supported: 4
        Border: 0 0 0 0
                range: (0, 65535)
        SignalFormat: DisplayPort
                supported: DisplayPort
        ConnectorType: DisplayPort
        ConnectorNumber: 8
        _ConnectorLocation: 8
ENDL

	return map { "$_\n" } split /\n/, $output;
}

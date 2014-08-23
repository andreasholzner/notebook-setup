use strict;
use warnings;

use Test::More;
use Test::MockModule;

subtest 'Battery provides data direct after object creation' => sub {
    my $mock = Test::MockModule->new('Notebook::Monitor::Battery');
    $mock->mock('_get_upower_info' => sub {
                    my $info = <<'ENDL';
  battery
    present:             yes
    state:               fully-charged
    percentage:          99%
ENDL

                    return split /\n/, $info;
                });

    my $battery = Notebook::Monitor::Battery->new(device => 'upower battery device');

    is scalar keys $battery->status => 3;
    is $battery->status->{present} => 'yes';
    is $battery->status->{state} => 'fully-charged';
    is $battery->status->{percentage} => '99%';
};

done_testing;

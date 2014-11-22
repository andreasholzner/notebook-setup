use strict;
use warnings;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($INFO);

use Test::More;
use Test::MockModule;
use Test::MockObject::Extends;
use File::Temp;
use File::Spec::Functions;
use Pam::Exec;

subtest 'config file format' => sub {
    my $temp_dir = File::Temp->newdir;
    my $homedir = Test::MockModule->new('File::HomeDir');
    $homedir->mock('users_home' => sub { $temp_dir });
    prepareConfigFile($temp_dir);

    my $exec = Pam::Exec->new('user');

    is_deeply $exec->{config}{lightdm}{open_session} => ['ls', 'la'];
    is_deeply $exec->{config}{lightdm}{close_session} => ['ls', 'll'];
    is $exec->{config}{su}{open_session} => 'ls -al';
};

subtest 'runs the correct commands' => sub {
    my $exec = Pam::Exec->new(getpwuid $<);
    $exec->{config} = {
        lightdm => {
            open_session => ['ls', 'la'],
            close_session => 'll -rt',
        }
    };
    $exec = Test::MockObject::Extends->new($exec);
    $exec->set_true('command');

    subtest 'not configured pam_service' => sub {
        $exec->run('service', 'open_session');
        ok !$exec->called('command');
    };

    subtest 'not configured pam_type' => sub {
        $exec->clear;
        $exec->run('lightdm', 'auth');
        ok !$exec->called('command');
    };

    subtest 'single command' => sub {
        $exec->clear;
        $exec->run('lightdm', 'close_session');

        my ($name, $args) = $exec->next_call();
        is $name => 'command', 'called method';
        is $args->[1] => 'll -rt', 'command arguments';

        is $exec->next_call => undef, 'no more calls';
    };

    subtest 'multiple commands' => sub {
        $exec->clear;
        $exec->run('lightdm', 'open_session');

        my ($name, $args) = $exec->next_call();
        is $name => 'command', 'called method';
        is $args->[1] => 'ls', 'command arguments';
        ($name, $args) = $exec->next_call();
        is $name => 'command', 'called method';
        is $args->[1] => 'la', 'command arguments';

        is $exec->next_call => undef, 'no more calls';
    };
};

done_testing;

sub prepareConfigFile {
    my $dir = shift;

    my $file = catfile($dir, '.config/pam-exec.ini');
    mkdir catdir($dir, '.config');
    open my $fh, '>', $file or die "Cannot open $file for writing: $!";
    print $fh <<'CONFIG';
[lightdm]
open_session=<<EOF
ls
la
EOF

close_session=<<EOF
ls
ll
EOF

[su]
open_session=<<EOF
ls -al
EOF
CONFIG
    close $fh;
}

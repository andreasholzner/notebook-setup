use strict;
use warnings;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($INFO);

use Test::More;
use Notebook::Util::Command qw(analyze_return_code);


subtest 'run executes given command and sets internal return code' => sub {
    my $cmd = Notebook::Util::Command->new('ls /TMP_DOES_NOT_EXIST >/dev/null 2>&1');

    $cmd->run;

    is $cmd->{return_code} => 2 << 8, 'return code of ls (no such file or directory)';
};

subtest 'handle_result calls failure handler' => sub {
    my $callback_counter = 0;
    my $callback_argument;
    my $cmd = Notebook::Util::Command->new('ls /TMP_DOES_NOT_EXIST >/dev/null 2>&1');
    $cmd->run;

    $cmd->handle_result(failure => sub {
                            $callback_argument = shift;
                            $callback_counter++;
                        });

    is $callback_counter => 1, 'number of handler calls';
    is $callback_argument => analyze_return_code(512), 'argument passed to handler';
};

subtest 'handle_result calls success handler' => sub {
    my $callback_counter = 0;
    my $callback_argument;
    my $cmd = Notebook::Util::Command->new('ls / >/dev/null 2>&1');
    $cmd->run;

    $cmd->handle_result(success => sub {
                            $callback_argument = shift;
                            $callback_counter++;
                        });

    is $callback_counter => 1, 'number of handler calls';
    is $callback_argument => undef, 'argument passed to handler';
};

subtest 'run_and_handle combines run and handle_result' => sub {
    my $callback_counter = 0;
    my $callback_argument;
    my $cmd = Notebook::Util::Command->new('ls / >/dev/null 2>&1');

    $cmd->run_and_handle(success => sub {
                            $callback_argument = shift;
                            $callback_counter++;
                        });

    is $callback_counter => 1, 'number of handler calls';
    is $callback_argument => undef, 'argument passed to handler';
};

subtest 'analyze return code' => sub {
    is analyze_return_code(42) => 'Command was ended by signal: 42 (SIGNUM42).';
    is analyze_return_code(139) => 'Command was ended by signal: 11 (SIGSEGV). Core dumped.';
    is analyze_return_code(256) => 'Command exited with exit code: 1.';
};

subtest 'run_with_backticks' => sub {
	my %commands = (
					'as list' => Notebook::Util::Command->new(qw(ls -ld /tmp)),
					'as string' => Notebook::Util::Command->new('ls -ld /tmp'),
				   );
	foreach (keys %commands) {
		subtest "command $_" => sub {
			my @output = $commands{$_}->run_with_backticks();

			is scalar @output => 1, 'number of output lines';
			like $output[0] => qr{/tmp\n}, 'newlines are preserved';
		};
	}
};

done_testing;

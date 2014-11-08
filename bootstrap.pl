#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
use experimental qw(switch);

use Cwd;
use File::Compare qw(compare compare_text);
use File::Copy;
use File::Find;
use File::Spec::Functions qw(catfile catdir rel2abs);
use Getopt::Long;
use Sys::Hostname;
use List::Util 1.33 qw(any all);

my $force;
my $dry_run;
my $repo_dir;
my @filters = ();
my $diff_mode;
GetOptions(
    force => \$force,
    'dry-run' => \$dry_run,
    'source-directory|s=s' => \$repo_dir,
    'filter=s' => \@filters,
    'show-diffs' => \$diff_mode,
) or die 'Invalid arguments';
$repo_dir = $ARGV[0] if not $repo_dir and $ARGV[0];

my @ignores = (qr/~$/, qr/^#[^#]+#$/);
my @diffs = ();

check_and_change_to_repo_dir($repo_dir);
my @copy_dirs = find_top_level_dirs('copy');
my @config_dirs = find_top_level_dirs('config');
my @perl5_dirs = find_top_level_dirs('perl5');

process_copy_dirs(@copy_dirs);
process_config_dirs(@config_dirs);
# TODO
#process_perl5_dirs(@perl5_dirs);

post_process() unless $dry_run or $diff_mode;
view_diffs(@diffs) if @diffs;

sub check_and_change_to_repo_dir {
    my $repo_dir = shift;

    $repo_dir or die "Missing argument 'source-directory'!";
    -d $repo_dir or die "Argument is not an existing directory: '$repo_dir'";
    chdir $repo_dir;
    system 'git status > /dev/null';
    die "Directory '$repo_dir' is not a git repository" if $?;
}

sub find_top_level_dirs {
    my $type = shift;

    for ($type) {
        when ('copy') {
            return grep { -d $_ and not $_ ~~ [qw(config perl5)] } glob '*';
        }
        when ('config') {
            my $hostname = hostname;
            return grep { -d $_ and /\L$hostname$|common$/ } glob 'config/*';
        }
        when ('perl5') {
            return  grep { -d $_ } glob 'perl5/*';
        }
        default {
            die 'invalid directory type';
        }
    }
}

sub process_copy_dirs {
    my @dirs_to_process = @_;

    foreach my $dir (@dirs_to_process) {
        say "processing directory '$dir'...";
        find(\&copy_repo_file, $dir);
    }
}

sub process_config_dirs {
    my @dirs_to_process = @_;

    my $working_dir = cwd();
    foreach my $dir (@dirs_to_process) {
        say "processing directory '$dir'...";
        chdir $dir;
        find(\&copy_repo_file, '.');
        chdir $working_dir;
    }
}

sub copy_repo_file {
    my $target_dir = catdir($ENV{HOME}, $File::Find::dir);
    mkdir $target_dir unless -d $target_dir;
    my $file_to_process = $_;
    if (-f $file_to_process and not any { $file_to_process =~ $_ } @ignores) {
        my $target_file = catfile($target_dir, $file_to_process);
        if (not is_file_excluded($target_file, \@filters)) {
            if (-e $target_file) {
                if (compare($target_file, $file_to_process) == 1) { # files are different
                    if ($diff_mode) {
                        push @diffs, { source => rel2abs($file_to_process), target => $target_file };
                    } elsif ($force) {
                        copy_file($file_to_process, $target_file, $dry_run);
                    } else {
                        say "Skipping modified file: '$File::Find::name'. Use '--force' to override.";
                    }
                }
            } else {
                if ($diff_mode) {
                    push @diffs, { source => rel2abs($file_to_process), target => '/dev/null' };
                } else {
                    copy_file($file_to_process, $target_file, $dry_run);
                }
            }
        }
    }
}

sub is_file_excluded {
    my ($file, $filters) = @_;

    scalar @$filters > 0 and all { index($file, $_) == -1 } @$filters;
}

sub copy_file {
    my ($src, $target, $dry_run) = @_;

    if ($dry_run) {
        say "Dry-run: Would Copy previously non-existing file '$target'";
    } else {
        my $mode = (stat $src)[2] & 07777;
        copy($src, $target) or die "Failed to copy '$src' -> '$target': $!";
        chmod $mode, $target;
    }
}

sub post_process {
    system 'emacs --no-window-system --no-splash --no-desktop --funcall emc-merge-config-files --kill';
}

sub view_diffs {
    my @diffs = @_;

    my @ediff_calls = map {
        my ($a, $b) = @$_{qw(source target)};
        "--eval '(ediff-files \"$a\" \"$b\")'";
    } @diffs;

    system 'emacsclient --create-frame ' . join ' ', @ediff_calls;
}

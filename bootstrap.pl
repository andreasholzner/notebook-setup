#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

use Cwd;
use File::Compare qw(compare compare_text);
use File::Copy;
use File::Find;
use File::Spec::Functions;
use Getopt::Long;
use Sys::Hostname;
use Data::Dump;

my $force;
my $dry_run;
my $repo_dir;
GetOptions(
    force => \$force,
    'dry-run' => \$dry_run,
    'source-directory|s=s' => \$repo_dir,
) or die 'Invalid arguments';
$repo_dir = $ARGV[0] if not $repo_dir and $ARGV[0];

check_and_change_to_repo_dir($repo_dir);
my @non_config_dirs = find_top_level_dirs(config => 0);
my @config_dirs = find_top_level_dirs(config => 1);

process_normal_dirs(@non_config_dirs);
process_config_dirs(@config_dirs);


sub check_and_change_to_repo_dir {
    my $repo_dir = shift;

    $repo_dir or die "Missing argument 'source-directory'!";
    -d $repo_dir or die "Argument is not an existing directory: '$repo_dir'";
    chdir $repo_dir;
    system 'git status > /dev/null';
    die "Directory '$repo_dir' is not a git repository" if $?;
}

sub find_top_level_dirs {
    my %args = @_;

    if ($args{config}) {
        my $hostname = hostname;
        return grep { -d $_ and /\L$hostname$|common$/ } glob 'config/*';
    } else {
        return grep { -d $_ and $_ ne 'config' } glob '*';
    }
}

sub process_normal_dirs {
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
    if (-f $_) {
        my $target_file = catfile($target_dir, $_);
        if (-e $target_file) {
            if (compare($target_file, $_) == 1) { # files are different
                if ($force) {
                    copy_file($_, $target_file, $dry_run);
                } else {
                    say "Skipping modified file: '$File::Find::name'. Use '--force' to override.";
                }
            }
        } else {
            copy_file($_, $target_file, $dry_run);
        }
    }
}

sub copy_file {
    my ($src, $target, $dry_run) = @_;

    if ($dry_run) {
        say "Dry-run: Would Copy previously non-existing file '$target'";
    } else {
        copy($src, $target) or die "Failed to copy '$src' -> '$target': $!";
    }
}

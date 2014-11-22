#!/usr/bin/env perl

use strict;
use warnings;

use Unix::Syslog qw(:macros :subs);
use Pam::Exec;

openlog 'pam-exec-user', LOG_PID | LOG_CONS, LOG_USER;

Pam::Exec->new($ENV{PAM_USER})->run($ENV{PAM_SERVICE}, $ENV{PAM_TYPE});

closelog;

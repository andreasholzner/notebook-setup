#!/usr/bin/env perl

use strict;
use warnings;

use Log::Log4perl qw(:easy);
use File::Spec::Functions;
use Notebook::Display::Configuration;


Log::Log4perl->easy_init({ level => $TRACE, file => '>>' . catfile($ENV{HOME}, '.xsession.log') });
my $config_file = catfile($ENV{HOME}, '.config', 'display.config');

Notebook::Display::Configuration->new(config_file => $config_file)->update;

#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use JSON;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::SocialNetwork qw(no_friends common_friends amount_of_friends);
use Getopt::Long;

my $command = shift;
die "try again" unless $command;

if ($command eq 'nofriends') {
	Local::SocialNetwork::no_friends();	
}

if ($command eq 'friends') {
	say "this function is in the process of creation";
}

if ($command eq 'nofriends') {
	say "this function is in the process of creation";
}

1;
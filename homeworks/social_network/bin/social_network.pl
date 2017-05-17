#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use JSON;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::SocialNetwork qw(no_friends common_friends amount_of_hands);
use Getopt::Long;
use DDP;

my $command = shift;
die "try again" unless $command;

sub take_users {
	my @users;
	GetOptions("user=i", \@users);
	return @users;
}

if ($command eq 'nofriends') {
	Local::SocialNetwork::no_friends() or die "can't do";
}

if ($command eq 'friends') {
	my @users = take_users();
	die "wrong parameters" if (@users ne 2);
	Local::SocialNetwork::common_friends(@users) or die "can't do";
}

if ($command eq 'num_handshakes') {
	my @users = take_users();
	die "wrong parameters" if (@users ne 2);
	Local::SocialNetwork::amount_of_hands(@users) or die "can't do";
}

1;
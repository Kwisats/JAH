package Local::SocialNetwork;

our $VERSION = '1.00';

use strict;
use warnings;
use DBI;
use DDP;
use FindBin;
use lib "$FindBin::Bin/..";
use Local::ConnectNetwork qw(connect);
use Local::User;

sub no_friends {
	my $dbh = Local::ConnectNetwork::connect();
	my $str = "SELECT * FROM users LEFT OUTER JOIN relations ON user.id = user_id WHERE friend_id = NULL";
	my $nofriends = $dbh->selectall_arrayref($str);
	p $nofriends;
	return $nofriends;
}

sub common_friends {
	my ($id1, $id2) = @_;
	my $user1 = Local::User->new($id1);
	my $user2 = Local::User->new($id2);
	say "this function is in the process of creation";
}

sub amount_of_hands {
	say "this function is in the process of creation";
}

our @EXPORT_OK = qw(no_friends common_friends amount_of_friends);

1;
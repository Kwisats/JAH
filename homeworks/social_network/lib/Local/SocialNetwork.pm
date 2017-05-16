package Local::SocialNetwork;

our $VERSION = '1.00';

use strict;
use warnings;
use DBI;
use DDP;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/..";
use Local::ConnectNetwork qw(connect);
use Local::User;

sub no_friends {
	my $dbh = Local::ConnectNetwork::connect();
	my $str1 = "SELECT id FROM users";
	#my $str2 = "SELECT users.id FROM users INNER JOIN relations ON users.id = user_id GROUP BY users.id HAVING COUNT(users.id) > 1";
	#my $str2 = "SELECT user_id FROM relations GROUP BY user_id HAVING COUNT(user_id) > 1 ORDER BY user_id";
	my $str2 = "SELECT users.id FROM WHERE id NOT IN (SELECT user_id FROM relations)";
	#my $str2 = "SELECT users.id FROM users LEFT JOIN relations ON users.id = relations.user_id WHERE friend_id IS NULL";
	my $all = $dbh->selectall_arrayref($str1);
	my $have_friends = $dbh->selectall_arrayref($str2);
	p $have_friends;
	my $j = 0;
	say "compare\n";
	for (my $i = 0; $i < @$all; $i++) {
		if ($all->[$i]->[0] == $have_friends->[$j]->[0]) {$j++;}
		else {say $all->[$i]->[0];}
	}
	say $have_friends->[0]->[0];
	return 1;
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
no_friends();
1;
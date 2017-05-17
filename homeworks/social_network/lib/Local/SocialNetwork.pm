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
use JSON;#он здесь нужен или можно руками сделать?

sub friends_of_all {#sql for amount of handshakes
	my $users = shift;
	my $dbh = Local::ConnectNetwork::connect();
	my $sth = $dbh->prepare("SELECT friend_id FROM relations WHERE user_id IN (?)");
	$sth->execute($users);
	my $buff = $sth->fetchall_arrayref();
	my @friends;
	push @friends, $_->[0] for(@$buff); 
	$dbh->disconnect;
	return \@friends;
}

sub no_friends {
	my $dbh = Local::ConnectNetwork::connect();
	#my $str = "SELECT users.id FROM users LEFT JOIN relations ON users.id = user_id WHERE friend_id IS NULL";
	my $str = "SELECT users.id FROM users WHERE users.id NOT IN (SELECT user_id FROM relations)";#запросы долго выполняются если строить таблицу с именами
	my $buff = $dbh->selectall_arrayref($str);
	my @no_friends;
	push @no_friends, "\"first_name\": first_name, \"second_name\": second_name" for (@$buff);#не уверен, что именно так надо это делать, но таких юзеров всё равно нет и проверить я не могу. В других функциях вывод нормальный.
	return 1, say "there are not such lonely dudes" unless @no_friends;
	p @no_friends;
	return 1;
}

sub common_friends {
	my ($id1, $id2) = @_;
	my $user1 = Local::User->new($id1);
	my $user2 = Local::User->new($id2);
	my $dbh = Local::ConnectNetwork::connect();

	my $friends1 = $user1->get_friends();
	my $friends2 = $user2->get_friends();
	my @common = ();
	my %isect = ();
	my %union = ();
	$union{$_} = 1 for (@$friends1);
	for (@$friends2) {
		if ($union{$_}) {
			$isect{$_} = 1;
		}
	}#вообще, наверное, правильно отсортировать два массива и пробежать их параллельно
	@common = keys %isect;
	
	my $str = join (', ', @common);
	return 1, say "they have not common friends" unless @common;
	my $buff = $dbh->selectall_arrayref("SELECT id, first_name, second_name FROM users WHERE users.id IN ($str)");
	my @array;
	push @array, "\"first_name\": $_->[1], \"second_name\": $_->[2], \"id\": $_->[0]" for (@$buff);
	p @array;
	$dbh->disconnect;
	return 1;
}

sub amount_of_hands {
	#надо бы на каждом шаге делать проверку на то, что у юзера есть друзья, но в этой утопической базе они есть у всех)))
	my ($id1, $id2) = @_;
	#if id1 = id2
	my $handshakes = 0;
	return 1, say $handshakes if $id1 == $id2;
	$handshakes++;
	#if they are friends
	my $friends = Local::User->new($id1)->get_friends();
	my %handshakers;
	$handshakers{$_} = 1 for (@$friends);
	return 1, say $handshakes if exists $handshakers{$id2};
	#if they are not friends
	while ( 1 ) {
		$handshakes++;
		say $handshakes;
		my $str = join(', ', @$friends);
		$friends = friends_of_all($str);
		my @buff_array = ();
		for (@$friends) {
			push @buff_array, $_ unless (exists $handshakers{$_}); 
		}
		$handshakers{$_} = 1 for (@buff_array);
		$friends = \@buff_array;
		last if exists $handshakers{$id2};
		return 1, say "there is no connection" unless @$friends; 
	}
	say $handshakes;
	return 1;
}

our @EXPORT_OK = qw(no_friends common_friends amount_of_friends);
#common_friends();
1;
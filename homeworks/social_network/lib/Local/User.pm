package Local::User;

use strict;
use warnings;
use DDP;
use 5.010;
use Local::ConnectNetwork 'connect';

sub new {
	my $class = shift;
	my $user_id = shift;
	my %self = (id => $user_id);
	
	my $dbh = Local::ConnectNetwork::connect();
	
	my $sth = $dbh->prepare("SELECT first_name, second_name FROM users WHERE id = (?)");
	$sth->execute($user_id);
	my $buff = $sth->fetchrow_hashref();
	$self{first_name} = $buff{first_name};
	$self{second_name} = $buff{second_name};

	my $sth = $dbh->prepare("SELECT friend_id FROM relations WHERE user_id = (?)");
	$sth->execute($user_id);
	my $buff = $sth->fetchrow_arrayref();
	$self{friends} = @$buff;

	return bless \%self, $class;
}

sub get_names {
	my $self = shift;
	return (first_name => $self->{first_name}, second_name => $self->{second_name});
}

sub get_friends {
	my $self = shift;
	return $self{friends};
}

1;
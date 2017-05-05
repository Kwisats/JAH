package Local::SocialNetwork;

our $VERSION = '1.00';

use strict;
use warnings;
use DBI;
use DDP;
use Archive::Zip;
use DBD::mysql;
use Getopt::Long;

my $db_name = 'SocialNetwork';
my $user_name = 'popyan';
my $password = 'popyan71b14';

my $dbh = DBI->connect("dbi:mysql:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});

my $str = "select (first_name, last_name, friend_id) from user left join user_relation on user.id = user_relation.user_id where friend_id = NULL";
my $no_friends = $dbh->prepare($str);

$no_friends->execute();
my @row;
while(@row = $no_friends->fetchrow_array()) { 
	p @row;
}










$dbh->commit();

1;
#BE CAREFULL - IT WORKS HARD. System requirements isn't minimal

package Local::CreateNetwork;

our $VERSION = '1.00';

use strict;
use warnings;
use DBI;
use Archive::Zip;
use DBD::mysql;

sub take_string {
	my $zip = Archive::Zip->new(shift);
	my @zip_files = $zip->members();
	return $zip_files[0]->contents();
}

my $db_name = 'SocialNetwork';
my $user_name = 'popyan';
my $password = 'popyan71b14';

my $dbh = DBI->connect("dbi:mysql:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});

my $create_user = $dbh->prepare("create table user (id serial, first_name character varying(255), last_name character varying(255))");
my $drop_user = $dbh->prepare("drop table user");
my $create_user_relation = $dbh->prepare("create table user_relation (id serial, user_id integer, friend_id integer)");
my $drop_user_relation = $dbh->prepare("drop table user_relation");

#my $select_all = $dbh->prepare("select * from user_relation");
#my $select_all = $dbh->prepare("select * from user");

$drop_user->execute();#comment if needed
$create_user->execute();
$drop_user_relation->execute();
$create_user_relation->execute();
print "Table user is being prepared\n";
my $users = take_string("etc/user.zip");
my @names;
while($users =~ /\d+\s(\D+)\s(\D+)\s/g) {  
	push @names, "'$1','$2'";
}
my $buff_str = join '),(', @names;
my $str = "insert into user (first_name, last_name) values (".$buff_str.")";
my $add_user = $dbh->prepare($str);
$add_user->execute();
print "Table user is ready\n";
print "Table user_relation is being prepared\n";
my @relations;
$users = take_string("etc/user_relation.zip");
while($users =~ /(\d+)\s(\d+)\s/g) { 
	push @relations, "$1,$2"
}
$buff_str = join '),(', @relations;
$str = "insert into user_relation (user_id, friend_id) values (".$buff_str.")";
my $add_user_relation = $dbh->prepare($str);
$add_user_relation->execute();
print "Table user_relation is ready\n";
print "The Database is ready!\n";
# $select_all->execute();
# my @row;
# while(@row = $select_all->fetchrow_array()) { 
# 	p @row;
# }
$dbh->commit();

1;

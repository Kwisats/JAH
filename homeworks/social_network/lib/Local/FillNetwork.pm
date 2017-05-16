package Local::FillNetwork;

our $VERSION = '1.00';

use strict;
use warnings;
use DBI;
use Archive::Zip;
use FindBin;
use lib "$FindBin::Bin/..";
use Local::ConnectNetwork qw(connect);

sub take_string {
	my $zip = Archive::Zip->new(shift);
	my @zip_files = $zip->members();
	return $zip_files[0]->contents();
}

my $dbh = Local::ConnectNetwork::connect();

print "Table users is being prepared\n";
my $zip = take_string("etc/user.zip");
my @names;
while($zip =~ /\d+\s(\D+)\s(\D+)\s/g) {  
	push @names, "'$1','$2'";
}
my $buff_str = join '),(', @names;
print "make insert\n";
my $str = "insert into users (first_name, second_name) values (".$buff_str.")";
my $add_user = $dbh->prepare($str);
$add_user->execute();
print "Table users is ready\n";

print "Table relations is being prepared\n";
$zip = take_string("etc/user_relation.zip");
my @relations;
while($zip =~ /(\d+)\s(\d+)\s/g) { 
	push @relations, "$1,$2";
}
$buff_str = join '),(', @relations;
print "make insert\n";
$str = "insert into relations (user_id, friend_id) values (".$buff_str.")";
my $add_user_relation = $dbh->prepare($str);
$add_user_relation->execute();
print "Table relations is ready\n";

print "Create indexes\n";

# my $select_all = $dbh->prepare("SELECT * FROM relations");
# $select_all->execute();
# my @row;
# while(@row = $select_all->fetchrow_array()) { 
# 	print "$row[0]\t$row[1]\t$row[2]\n";
# }

$str = "CREATE INDEX user_id ON relations(user_id)";
my $index = $dbh->prepare($str);
$index->execute();
$str = "CREATE INDEX friend_id ON relations(friend_id)";
$index = $dbh->prepare($str);
$index->execute();
print "The database is ready!\n";

$dbh->commit();#what is the problem of this commit???

1;

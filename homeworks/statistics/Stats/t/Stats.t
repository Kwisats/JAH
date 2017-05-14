# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Stats.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use DDP;
use 5.010;

use Test::More tests => 1;
BEGIN { use_ok('Stats') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# is(&Stats::is_even(0), 1);
# is(&Stats::is_even(1), 0);
# is(&Stats::is_even(2), 1);

# my $i;
# $i = -1.5; &Stats::round($i); is( $i, -2.0);
# $i = -1.1; &Stats::round($i); is( $i, -1.0);
# $i = 0.0; &Stats::round($i); is( $i, 0.0);
# $i = 0.5; &Stats::round($i); is( $i, 1.0);
# $i = 1.2; &Stats::round($i); is( $i, 1.0);

sub func{
	my $name = shift;
	say $name;
	return "avg sum max";
}

my $obg = Stats->new( \&func );
p $obj;
$obg->add{"m1",10};
p $obj;
$obg->add{"m1",11};
p $obj;
$obg->add{"m2",10};
p $obj;
$obg->add{"m3",10};
p $obj;

# my $stat = $obj->stat();
# p $stat;





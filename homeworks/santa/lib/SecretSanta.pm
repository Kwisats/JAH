package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {
	my @members = @_;
	my @res;
	my @Names;
	my @buff;	
	my %Taboo;
	my %Catchers;
	my $check = 1;
	# make 1-dimensional array of all names and hash of prohibited combinations
	for(@members) {
		if(ref $_ eq "ARRAY") {
			push @Names,$_->[0];
			push @Names,$_->[1];
			$Taboo{$_->[0]}=$_->[1];		
			$Taboo{$_->[1]}=$_->[0];
		} else {
			push @Names,$_;
			$Taboo{$_}='';
		}
	}
	
	if($#members + 1 < 2) {
		print STDERR "IT CAN'T BE SOLVED WITH THESE MEMBERS\n";
		return 1;
	}
	if($#members + 1 == 2) {
		unless(ref $members[0] eq "ARRAY" and ref $members[1] eq "ARRAY") {
			print STDERR "IT CAN'T BE SOLVED WITH THESE MEMBERS\n";
			return 1;
		}
	}

	while($check)
	{
		$check = 0;
		@buff = sort { int(rand(3))-1 } @Names; #shuffle names to have array of granted persons
		for my $i (0 .. $#Names) {
			$Catchers{$Names[$i]}=$buff[$i]; 
		}
		for my $i (@Names) { #check conditions 
			if( $Catchers{$i} eq $i ) {
				$check = 1;
				last;
			}
			if( $Catchers{$i} eq $Taboo{$i} ) {
				$check = 1;
				last;
			}
			if( $Catchers{$Catchers{$i}} eq $i ) {
				$check = 1;
				last;
			}
		}
	}
	
	for my $i (@Names) {
		push @res,[ $i, $Catchers{$i} ];
	}
	return @res;
}
1;

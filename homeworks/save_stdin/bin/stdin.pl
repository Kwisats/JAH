#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

$SIG{STOP} = \&ctrl_d;
$SIG{INT} = \&ctrl_c;
our $check = 0;

our $file;
GetOptions("file=s" => \$file);

open(our $fh, ">", $file);
syswrite (STDOUT , "Get ready", length "Get ready");
while(<>) {	
	syswrite ($fh, $_, length $_);
}
#close($fh);
output();

sub output {
	close($fh);	
	open(my $fh1, "<", $file);
	my $num_symbols = 0;
	my $num_rows = 0;
	my $avg_row = 0;
	while(<$fh1>){
		$num_rows++;
		$num_symbols += (length $_) - 1;
	}
	$avg_row = $num_symbols/$num_rows;
	#print "$num_symbols $num_rows $avg_row";
	my $buff = "$num_symbols $num_rows $avg_row";
	syswrite (STDOUT, $buff, length $buff);
	close($fh1);
}
sub ctrl_c {
	if ($check == 0) {
    	syswrite (STDERR, "Double Ctrl+C for exit", length "Double Ctrl+C for exit");
		$check = 1;	
	}else {
#		close($fh);
		output();
		exit;		
	}
}

sub ctrl_d {
#	close($fh);
	output();
    exit;
}










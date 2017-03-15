#!/usr/bin/perl

use strict;
use warnings;
use POSIX;

my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;

sub parse_file {
    my $file = shift;
	my %hash;
	my @codes;
	my $check;
	my $time;
	$hash{total}{count}=0;
	$hash{total}{data}=0;
	$hash{total}{minutes}=0;
	$hash{total}{previous_minute}=0;
	my $q1 = quotemeta('[');
	my $q2 = quotemeta(']');		
	my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
    while (my $log_line = <$fd>) {
        # you can put your code here
        # $log_line contains line from log file
		$check=0;
		$log_line =~ /([^$q1]+)\ \[((.+):[^$q2]+)\]\ "(.+)"\ (\d+)\ (\d+)\ "([^"]+)"\ "([^"]+)"\ "([^"]+)"/;
	
		#count	
		$hash{total}{count}+=1;
		if (defined $hash{$1}{count}) {
			$hash{$1}{count}+=1; 
		}else {
			$hash{$1}{count}=1;
		}

		#codes
		for my $code (@codes) {
			$check=1,last if $code == $5;
		}
		push @codes, $5 if $check == 0;

		#minutes
		unless(defined $hash{$1}{previous_minute}) {
			$hash{$1}{previous_minute}=$3;
			$hash{$1}{minutes}=1;		
		}
		if($3 ne $hash{$1}{previous_minute}) {
			$hash{$1}{minutes}+=1; 
			$hash{$1}{previous_minute}=$3;
		}
		if($3 ne $hash{total}{previous_minute}) {
			$hash{total}{minutes}+=1;
			$hash{total}{previous_minute}=$3;
		}

		#data and status
		unless(defined $hash{total}{$5}) {
			$hash{total}{$5}=0;
		}
		unless(defined $hash{$1}{$5}) {
			$hash{$1}{$5}=0;
			
		}
		unless(defined $hash{$1}{$5}) {
			$hash{$1}{data}=0;
		}
		if($5 eq '200') {
			unless($9 eq '-') {
				$hash{$1}{data}+=$6*$9;
				$hash{total}{data}+=$6*$9;
			}	
		}
		$hash{$1}{$5}+=$6;
		$hash{total}{$5}+=$6;
    }
    close $fd;
	#output
	@codes = sort {$a<=>$b} @codes;
	print "IP\tcount\tavg\tdata\tdata_200\tdata_301\tdata_302\tdata_400\tdata_403\tdata_404\tdata_408\tdata_414\tdata_499\tdata_500\n";
	my $i=0;
	for my $key (sort { $hash{$b}{count} <=> $hash{$a}{count}} keys %hash) {
		if ($i<11) {
			print $key,"\t",$hash{$key}{count},"\t";
			printf("%.2f\t",$hash{$key}{count}/$hash{$key}{minutes});
			if (defined $hash{$key}{data}) {
				printf("%d\t",floor($hash{$key}{data}/1024));
			}else {
				print "0\t";
			}
			for my $code (@codes) {
				if(defined $hash{$key}{$code}) {
					printf("%d\t",floor($hash{$key}{$code}/1024));
				}else {
					print "0\t";
				}			
			}
			print "\n";
			$i++;
		}	
	}

    return $result;
}
sub report {
    my $result = shift;
	#i know it is better to write output here, but i'm in hurry
    # you can put your code here

}


#!/usr/bin/perl

use strict;
use warnings;
use POSIX;
use List::Util qw(sum);

my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;

sub parse_file {
    my $file = shift;
	my %hash;
	my %minutes;
	my @codes;
	my $check;
	my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
    while (my $log_line = <$fd>) {
        $check=0;
		$log_line =~ /(?<ip>[^\[]*)\ \[((?<minute>\d+\/\w+\/\d+:\d+:\d+):[^\]]*)\]\ "(.*)"\ (?<status>\d*)\ (?<data>\d*)\ "([^"]*)"\ "([^"]*)"\ "(?<comprassion>[^"]+)"/;
		
		$minutes{total}{$+{minute}}++;
		$minutes{$+{ip}}{$+{minute}}++;		
		
		#count
		$hash{total}{count} += 1;
		$hash{$+{ip}}{count} += 1; 
	
		#codes
		for my $code (@codes) {
			$check=1,last if $code == $+{status};
		}
		push @codes, $+{status} if $check == 0;

		if($+{status} eq '200') {
			if($+{comprassion} ne '-') {
				$hash{$+{ip}}{data}+=$+{data}*$+{comprassion};
				$hash{total}{data}+=$+{data}*$+{comprassion};
			}else {
				$hash{$+{ip}}{data}+=$+{data};
				$hash{total}{data}+=$+{data};
			}
		}
		$hash{$+{ip}}{$+{status}}+=$+{data};
		$hash{total}{$+{status}}+=$+{data};
    }
    close $fd;
	#output
	@codes = sort {$a<=>$b} @codes;
	print "IP\tcount\tavg\tdata\t200\t301\t302\t400\t403\t404\t408\t414\t499\t500\n";
	my $i=0;
	for my $key (sort { $hash{$b}{count} <=> $hash{$a}{count}} keys %hash) {
		if ($i<11) {
			#count
			print $key,"\t",$hash{$key}{count},"\t";
			#avg			
			printf("%.2f\t",sum(values %{$minutes{$key}})/keys %{$minutes{$key}});
			#data			
			if (defined $hash{$key}{data}) {
				printf("%d\t",floor($hash{$key}{data}/1024));
			}else {
				print "0\t";
			}
			#data_<code>
			for my $code (@codes) {
				if(defined $hash{$key}{$code}) {
					printf("%d\t",floor($hash{$key}{$code}/1024)) if $code ne '500';
					printf("%d",floor($hash{$key}{$code}/1024)) if $code eq '500';			
				}else {
					print "0\t" if $code ne '500';
					print "0" if $code eq '500';
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
}


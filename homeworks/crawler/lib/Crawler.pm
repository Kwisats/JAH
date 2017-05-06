package Crawler;

use 5.010;
use strict;
use warnings;

use AnyEvent;
use AnyEvent::HTTP;
use URI;
use DDP;
use List::Util qw(min);

my %hash = ();
sub run {
	my ($start_page, $parallel_factor) = @_;
	$start_page or die "You must setup url parameter";
	$parallel_factor or die "You must setup parallel factor > 0";

	my @absolute_for_head = ();#absolute references for head's queue
	my $active_requests = 0;
	push @absolute_for_head, $start_page;
	
	my $cv = AE::cv; 
	my $i_head = 0;
	my $next_get;
	my $next_head; 
	my $request_master; 
	
	$next_head = sub {
		$cv->begin;
		my $cur = $i_head++;
		$active_requests++;
		http_request 
		HEAD => $absolute_for_head[$cur],
		timeout => 10,
		sub {
			my ($body, $hdr) = @_;
			if ($hdr->{Status} == 200) {
				$next_get->($absolute_for_head[$cur]) if $hdr->{"content-type"} =~ /text\/html/;
			} else {
				warn "ALERT: status $hdr->{Status} in head $absolute_for_head[$cur]";
			}
			$cv->end;
		};
	};

	$start_page =~ /http\w?:\/\/[^\/]+(\/.+)/;
	my $url = $1;
	
	$next_get = sub {
		$cv->begin;
		my $page = shift;
		http_request 
		GET => $page,
		timeout => 10,
		sub {
			my @buff = ();
			my ($body, $hdr) = @_;
			if ($hdr->{Status} == 200) {					
				$hash{$page} = length($body);
				my @arr_ref = $body =~ /href="(\/[^#"][^"]+)"/g;					
				for (@arr_ref) {
					push @buff, $start_page.$1 if ($_ =~ /^$url(.+)$/);
				}
				for(@buff){
					push @absolute_for_head, $_ unless exists $hash{$_};
				}
			}else {
				warn "ALERT: status $hdr->{Status} in get $page";
			}
			$cv->end;
			$active_requests--;
			$request_master->();
		};
	};

	$request_master = sub {
		my $requests_spaces = $parallel_factor - $active_requests;
		my $not_headed = @absolute_for_head - $i_head;
		my $number_to_start = min( $requests_spaces, $not_headed);
		for (1..$number_to_start) {
			$next_head->();
		}
		$cv->end if @absolute_for_head > 1000 or $number_to_start == 0; 
	};
	
	$cv->begin;
	$request_master->();
	$cv->recv;
	say "I'm out";
	
	my $total_size = 0;
	my @top10_list = ();

	for my $url (sort{$hash{$b} <=> $hash{$a}} keys %hash ) { push @top10_list, $url; }
	@top10_list = @top10_list[0..9];
	$total_size += $_ for values %hash;
	p @top10_list;
	say $total_size;
	#p %hash;
	return $total_size, @top10_list;
};

#run('https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/', 100);

1;

package Local::Row::Simple;

use strict;
use warnings;

use parent qw(Local::Row);

sub new {
	my $class = shift;
	my %self = @_;
	my %hash_ref;
	return bless \%hash_ref, $class unless $self{str};	
	my @arr = split /,/,$self{str}; 
	for my $row (@arr) {
		return undef if $row =~ /:.*:/;
		return undef unless $row =~ /([^:]+):([^:]+)/;
		$hash_ref{$1} = $2;
	}	
	return bless \%hash_ref, $class;
}

1;

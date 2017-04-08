package Local::Row::Simple;

use strict;
use warnings;
use DDP;
sub get {
	
}

sub new {
	my $class = shift;
	my %self = @_;
	my %empty;
	return bless \%empty, $class unless $self{str};	
	my @arr = split /,/,$self{str}; 
	for my $row (@arr) {
		return undef if $row =~ /:.*:/;
		return undef unless $row =~ /([^:]+):([^:]+)/;
		$self{$1} = $2;
	}	
	delete $self{str};
	return bless \%self, $class;
}

1;

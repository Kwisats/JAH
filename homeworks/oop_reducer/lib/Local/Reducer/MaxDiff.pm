package Local::Reducer::MaxDiff;
	
use strict;
use warnings;

#BEGIN {push(@ISA, 'Local::Reducer')};
use parent qw(Local::Reducer);

sub new {
	my $class = shift;
	my %self = @_;
			
	bless \%self, $class;
	return \%self;
}

1;

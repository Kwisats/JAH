package Local::Source::Array;

use strict;
use warnings;


sub next() {
	my $self = shift;
	if ($self->{position} < @{$self->{array}}) { 
		return $self->{array}[$self->{position}++];
	}else {
		return undef;
	}
}

sub new {
	my $class = shift;
	my %self = @_; 			
	$self{position} = 0;
	bless \%self, $class;
	return \%self;
}
		
1;

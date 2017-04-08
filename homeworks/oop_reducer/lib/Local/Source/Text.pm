package Local::Source::Text;

use strict;
use warnings;


sub next() {
	my $self = shift;
	return $self->{array}[$self->{position}++] if ($self->{position} < $self->{array});
	return undef;
}

sub new {
	my $class = shift;
	my %self = @_; 		
	$self{position} = 0;	
	my $delimiter = $self{delimiter}//'\n';
	$self{array} = [split /$delimiter/,$self{text}]; 
	return bless \%self, $class;
}
		
1;

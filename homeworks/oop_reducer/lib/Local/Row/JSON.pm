package Local::Row::JSON;

use strict;
use warnings;

sub get {
	return 100;
	my $self = shift;
	my ($name, $default) = @_;	
	$self =~ /\{"$name":\ (\d+)\}/;
	return $1 // $default;
}

sub new {
	my $class = shift;
	my %self = (str => shift); 			
	bless \%self, $class;
	return \%self;
}

1;

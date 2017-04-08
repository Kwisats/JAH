package Local::Reducer::Sum;
	
use strict;
use warnings;

use parent qw(Local::Reducer);

sub new {
	my $class = shift;
	my %self = @_;
	return bless \%self, $class;
}

my $sum = 0;

sub reduce_n {
	my $self = shift;
	my $n = shift;	
	my $i = 0;
	while ( $i++ < $n and defined (my $buff = $self->{source}->next()) ) {
		my $row = Local::Row::JSON->new(str => $buff);
		$sum += $row->get($self->{field},0) if defined $row;
	}
	return $sum;	
}

sub reduced {
	return $sum;
}

sub reduce_all {
	my $self = shift;
	while ( defined (my $buff = $self->{source}->next()) ) {
		my $row = Local::Row::JSON->new(str => $buff);
		$sum += $row->get($self->{field},0) if defined $row;
	}
	return $sum;
}

1;

package Local::Reducer::MaxDiff;
	
use strict;
use warnings;

use DDP;
use parent qw(Local::Reducer);

sub new {
	my $class = shift;
	my %self = @_;
			
	return bless \%self, $class;
}

my $max_diff = 0;

sub reduce_n {
	my $self = shift;
	my $n = shift;	
	my $i = 0;
	while ( $i++ < $n and defined (my $buff = $self->{source}->next()) ) {
		my $row = Local::Row::Simple->new(str => $buff);
		my $diff = 0;		
		$diff = $row->get($self->{top},0) - $row->get($self->{bottom},0) if defined $row;
		$max_diff = $diff if $diff > $max_diff;	
	}
	return $max_diff;	
}

sub reduced {
	return $max_diff;
}

sub reduce_all {
	my $self = shift;
	while ( defined (my $buff = $self->{source}->next()) ) {
		my $row = Local::Row::Simple->new(str => $buff);
		my $diff = 0;
		$diff = $row->get($self->{top},0) - $row->get($self->{bottom},0) if defined $row;
		$max_diff = $diff if defined $diff and $diff > $max_diff;	
	}
	return $max_diff;
}

1;

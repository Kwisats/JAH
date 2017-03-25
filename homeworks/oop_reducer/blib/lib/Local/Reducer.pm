package Local::Reducer;

use strict;
use warnings;
=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut


sub reduce_n {
	return undef;	
}

sub reduced {
	return undef;
}

sub reduce_all {
	my $self = shift;
	my $sum = 0;
	while ( defined (my $buff = $self->{source}->next()) ) {#one big ?
		my $row = *{$self->{row_class}}->new($buff);
		$sum += $row->get($self->{field},0);
	}
	return $sum;
}


1;




















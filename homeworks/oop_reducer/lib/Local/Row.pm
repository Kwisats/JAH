package Local::Row;

use strict;
use warnings;
use Scalar::Util qw(looks_like_number);

sub get{
	my $self = shift;
	my $name = shift;
	my $default = shift;
	return $self->{$name} if exists $self->{$name} and looks_like_number($self->{$name});
	return $default;
}

1;

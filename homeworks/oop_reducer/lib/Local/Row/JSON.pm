package Local::Row::JSON;

use strict;
use warnings;
use JSON::XS;

use parent qw(Local::Row);

sub new {
	my $class = shift;
	my %self = @_;
	my $hash_ref;
	return bless $hash_ref, $class unless $self{str};	
	eval {$hash_ref = decode_json($self{str});};
	return undef if $@ or ref $hash_ref ne 'HASH';
	return bless $hash_ref, $class;
}

1;

package myconst;


use strict;
use warnings;
use Scalar::Util 'looks_like_number';

use DDP;
use 5.010;
#use Exporter;
#@ISA = qw(Exporter);
#use Exporter 'import';
#use Exporter ();

=encoding utf8

=head1 NAME

myconst - pragma to create exportable and groupped constants

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
package aaa;

use myconst math => {
        PI => 3.14,
        E => 2.7,
    },
    ZERO => 0,
    EMPTY_STRING => '';

package bbb;

use aaa qw/:math PI ZERO/;

print ZERO;             # 0
print PI;               # 3.14
=cut

sub import{
	shift;
#return 0 if ref @_;
	my %hash = @_;
	my $caller = caller;	
#work with 3 and 4 later
	no strict 'refs';
	#my @EXPORT_OK;
	for my $key (keys %hash) {
		unless (ref $hash{$key}) {
			*{$caller.'::'.$key} = sub() {$hash{$key}};
			#push @EXPORT_OK, $caller.'::'.$key;
		}elsif ((ref $hash{$key} eq 'HASH') and (values %{$hash{$key}} > 0)) {
			for my $deep_key (keys %{$hash{$key}}) {
				*{$caller.'::'.$deep_key} = sub() {%{$hash{$key}}{$deep_key}};
			}
		}	
	}

	

	#myconst->export_to_level(1,@_);
}

1;








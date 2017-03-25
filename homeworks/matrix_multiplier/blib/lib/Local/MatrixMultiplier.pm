package Local::MatrixMultiplier;

use strict;
use warnings;

sub mult {
    my ($mat_a, $mat_b, $max_child) = @_;
    my $res = [];
	my $param = @{$mat_a};
	die if $param == 0;
	for my $element (@{$mat_a}) {
		die if $param != @{$element};	
	}    
	for my $element (@{$mat_b}) {
		die if $param != @{$element};	
	}

	my $pid = fork();
	my $my_space = (@{$mat_a}-1)/2;
	my $start = $pid * $my_space;
	my $end = $start + $my_space;	

	for my $i ($start..$end) {
		for my $j ($start..$end) {
			$res->[$i][$j] = 0;	
			for my $k (0..$param) {
				$res->[$i][$j] += $mat_a->[$i][$k] * $mat_b->[$k][$j];	
			}	
		}	
	}
    return $res;
}

1;

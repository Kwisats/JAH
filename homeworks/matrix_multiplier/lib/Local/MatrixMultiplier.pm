package Local::MatrixMultiplier;

use strict;
use warnings;

sub mult {
    my ($mat_a, $mat_b, $max_child) = @_;
    my $res = [];
	my $param = scalar @{$mat_a};
	die if $param == 0;
	for my $element (@{$mat_a}) {
		die if $param != @{$element};	
	}    
	for my $element (@{$mat_b}) {
		die if $param != @{$element};	
	}

	my ($r, $w);
	pipe ($r, $w);
	my $last_row = (@{$mat_a}-1);
	my $start = 0;
	my $end = int($last_row/2);
	my $pid = fork();
	if ($pid) {#parent
		close $w;
	}else {#child
		$start = int($last_row/2) + 1;
		$end = $last_row;
		close $r;
	}
	
	for my $i ($start..$end) {
		for my $j (0..$last_row) {
			$res->[$i][$j] = 0;	
			for my $k (0..$last_row) {
				$res->[$i][$j] += $mat_a->[$i][$k] * $mat_b->[$k][$j];	
			}	
		}	
	}

	if ($pid) {#parent
		waitpid($pid,0);
		my ($i,$j) = ($end, 0);		
		while (<$r>) {
			$i++ if $j == 0;
			$res->[$i][$j] = 0 + $_;
			$j = ($j+1) % ($last_row+1);
		}
		close $r;
	}else {#child
		for my $i ($start..$end) {
			for my $j (0..$last_row) {
				print $w "$res->[$i][$j]\n"; 
			}
		}
		close $w;
	}
	die unless $pid;
    return $res if $pid;
}

1;

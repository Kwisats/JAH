package Local::MatrixMultiplier;

use strict;
use warnings;
use POSIX qw(sys_wait_h);


sub mult {
    my ($mat_a, $mat_b, $max_child) = @_; 
	my $res = [];
	#check matrix	
	my $param = scalar @{$mat_a};
	die if $param == 0;
	for my $element (@{$mat_a}) {
		die if $param != @{$element};	
	}    
	for my $element (@{$mat_b}) {
		die if $param != @{$element};	
	}

	my %childs;
	my $start;
	my $end;
	my $last_row = @{$mat_a}-1;
	my $interval = int(@{$mat_a}/$max_child);	
	for my $i(0..$max_child-1){
		my ($r, $w);
		pipe ($r, $w);
		my $pid = fork();
		if($pid) {#parent
			close $w;
			$childs{$pid} = {iter => $i, reader => $r};
			#reading		
			waitpid($pid, WNOHANG);
			my ($s,$j) = ($childs{$pid}{iter}*$interval - 1, 0);		
			my $buff = $childs{$pid}{reader};			
			while (<$buff>) {
				$s++ if $j == 0;
				$res->[$s][$j] = 0 + $_;
				$j = ($j + 1)%($last_row + 1);
			}
			close $childs{$pid}{reader};
		}else {#child
			close $r;			
			#definition of frames of the task for each slave, master does obviously nothing
			if ($i == $max_child-1) {
				$start = $interval*$i;
				$end = $last_row;
			}else {
				$start = $i*$interval;
				$end = ($i + 1)*$interval - 1;
			}
			#calculation
			for my $s ($start..$end) {
				for my $j (0..$last_row) {
					$res->[$s][$j] = 0;	
					for my $k (0..$last_row) {
						$res->[$s][$j] += $mat_a->[$s][$k] * $mat_b->[$k][$j];	
					}	
				}	
			}		
			#writing
			for my $j ($start..$end) {
				for my $k (0..$last_row) {
					print $w "$res->[$j][$k]\n";
				}
			}
			close $w;	
			exit;		
		}
	}
    return $res;
}

1;

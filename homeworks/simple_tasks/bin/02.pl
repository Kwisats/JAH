#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Вычисление простых чисел

=head1 run ($x, $y)

Функция вычисления простых чисел в диапазоне [$x, $y].
Пачатает все положительные простые числа в формате "$value\n"
Если простых чисел в указанном диапазоне нет - ничего не печатает.

Примеры: 

run(0, 1) - ничего не печатает.

run(1, 4) - печатает "2\n" и "3\n"

=cut

sub run {
	my ($x, $y) = @_;
	my $simple; #marker    
	for (my $i = $x; $i <= $y; $i++) {
        $simple = 1;
		if ($i>1) {        
			for(my $j = 2; $j <= sqrt($i); $j++ ) {
				if( $i % $j == 0 ) {
					$simple = 0;
				}#don't know how to make "break" yet
			}
		} else {
			$simple = 0;		
		}
		if ($simple == 1) {
			print "$i\n";
		}    
		
	}
}

1;

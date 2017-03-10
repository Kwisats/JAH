package DeepClone;

use 5.010;
use strict;
use warnings;
use DDP;
=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub clone {
	my $orig = shift;
	my $start = shift;
	$start = $orig unless defined $start;	
	my $cloned;
	return $cloned unless (defined $orig);	
	return $cloned = $orig unless (ref $orig);
	
	if (ref $orig eq 'ARRAY') {
		#$cloned = [];
		for my $scal (@{$orig}) {
			unless (defined $scal) {
				push @{$cloned}, undef;
				next;
			}
			if ($scal eq $start) {
				push @{$cloned}, $cloned;
			}else {			
				push @{$cloned}, clone($scal,$start); 
			}
		}
		#p $orig;
		p $cloned;
		return $cloned;
	}

	if (ref $orig eq 'HASH') {
		$cloned = {};
		for my $key (keys %{$orig}) {
			unless (defined $orig->{$key}) {
				$cloned->{$key} = undef;
				next;
			}			
			if ($orig->{$key} eq $start) {
				$cloned->{$key} = $cloned; 
			} else {
				$cloned->{$key} = clone($orig->{$key},$start);
			}					
		}
		#p $orig;
		#p $cloned;
		return $cloned;
	} 

	return undef;
}
1;






















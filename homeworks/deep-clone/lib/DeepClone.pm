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

sub deep {
	my $orig = $_[0];
	my $cloned; 
	#check $orig on type of ref and copy
	if (ref $orig eq 'HASH') {
		$cloned = {%$orig};
	}elsif (ref $orig eq 'ARRAY') {
		$cloned = [@$orig];
	}else {
		$_[1] = 1;
		return undef;
	}
	#remember new ref in %seen
	my $seen = $_[2];	
	unless (defined $seen->{$orig}) {
		$seen->{$orig} = $cloned; 
	}
	#substitute copied refs with use of deep() and %seen
	if (ref $orig eq 'ARRAY') {
		for my $element (@$cloned) {
			if (defined $element && scalar grep{$_ eq $element} keys %$seen) {			
				$element = $seen->{$element};
			}elsif (ref $element) {
				$element = deep($element, $_[1], $seen);
			}
		}
	}elsif (ref $orig eq 'HASH') {
		for my $value (values %$cloned) {
			if (defined $value && scalar grep{$_ eq $value} keys %$seen) {			
				$value = $seen->{$value};
			}elsif (ref $value) {
				$value = deep($value, $_[1], $seen);
			}
		}
	}

	return $cloned;
}

sub clone {
	my $orig = shift;
	my $cloned;
	return undef unless defined $orig;
	return $cloned = $orig unless ref $orig;	
	my $check_function = 0; 
	my $seen = {};
	$cloned = deep($orig, $check_function, $seen);
	return undef if $check_function == 1;
	return $cloned;
}
1;











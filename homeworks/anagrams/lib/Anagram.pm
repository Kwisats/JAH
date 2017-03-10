package Anagram;

use 5.010;
use strict;
use warnings;

#my changes
use DDP;
use Encode qw(decode encode);
use utf8;
#binmode(STDIN,':utf8');
binmode(STDOUT,':utf8');

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub check_anagram{
	my $str1 = shift;
	my $str2 = shift;
	return 0 if (length $str1 ne length $str2);	
	my @array1 = sort { $a cmp $b } split //, $str1;
	my @array2 = sort { $a cmp $b } split //, $str2; 
	for my $i (0..$#array1) {
		return 0 if $array1[$i] ne $array2[$i]
	}	
	return 1;
} 

sub anagram {
    my $words_list = shift; #= ['пятка', 'слиток', 'пятак', 'ЛиСток', 'стул', 'ПяТаК', 'тяпка', 'столик', 'слиток'];
    my %result;
	for my $word (@{$words_list}) {
		$word = lc decode('UTF-8',$word);
		next if exists $result{$word};		
		my $check=0; 
		for my $key (keys %result) {
			if (check_anagram($key,$word)){
				for my $buff(@{$result{$key}}){	
					$check = 1, last if $word eq $buff;
				}			
				push @{$result{$key}},$word if $check == 0;
				$check = 1;
				last; 
			}
		}	 
		next if $check==1;
		$result{$word} = [$word];
	}
	for my $key (keys %result) {#it should be 2 "for"
		delete $result{$key},last if @{$result{$key}} == 1;
	}	
	for my $key (keys %result) {
		@{$result{$key}} = sort { $a cmp $b } @{$result{$key}}
	}
	
	my %output;
	for my $key (keys %result) {
		$output {encode('UTF-8',$key)} = [];		
		for my $word (@{$result{$key}}) {		
			push @{$output{encode('UTF-8',$key)}}, encode('UTF-8',$word);			
		}	
	}

    return \%output;
}
1;









package Anagram;

use 5.010;
use strict;
use warnings;

#my changes
use DDP;
use Encode qw(decode encode);
use utf8;
#binmode(STDIN,':utf8');
#binmode(STDOUT,':utf8');

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

sub anagram {
    my $words_list = shift;# ['пятка', 'слиток', 'пятак', 'ЛиСток', 'стул', 'ПяТаК', 'тяпка', 'столик', 'слиток'];
    my %result;
	my @ideas;
	#make array of "sorted" words
	my @buff_array;
	my $buff;
	for my $word (@{$words_list}) {
		$buff = $word = lc decode('UTF-8',$word);
		@buff_array = sort { $a cmp $b } split //, $buff;
		$buff = join('',@buff_array);		
		push @ideas, $buff;
	}	
	#make hash of idea => words
	for my $i (0..$#ideas) {
		if(exists $result{$ideas[$i]}) {
			unless(scalar grep{$_ eq $words_list->[$i]} @{$result{$ideas[$i]}}) {			
				push @{$result{$ideas[$i]}}, $words_list->[$i]; 
			}		
		} else{
			$result{$ideas[$i]} = [$words_list->[$i]];
		}
	}
	#delete single words	
	for my $key (keys %result) {
		delete $result{$key} if @{$result{$key}} == 1;
	}	
	#sort arrays and change key_word to first from array
	my %buff_output;
	for my $key (keys %result) {
		push @{$buff_output{$result{$key}[0]}}, sort { $a cmp $b } @{$result{$key}};
	}#I don't sure it is always correct, because here it is critical that first argument of "push" should be called first
	#make output encoding
	my %output;
	for my $key (keys %buff_output) {
		$output {encode('UTF-8',$key)} = [];
	}
	for my $key (keys %buff_output) {
		for my $word (@{$buff_output{$key}}) {		
			push @{$output{encode('UTF-8',$key)}}, encode('UTF-8',$word);			
		}	
	}

    return \%output;
}
1;









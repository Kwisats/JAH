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
	#make array of "sorted" words (ideas)
	for my $word (@$words_list) {
		$word = lc decode('UTF-8',$word);			
		push @ideas, join '', sort split //,$word;
	}	
	#make hash of idea => words. Need iterator $i to have a connection between arrays of words and ideas
	for my $i (0..$#ideas) {
		if(exists $result{$ideas[$i]}) {
			#every word only 1 time
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
		push @{$buff_output{$result{$key}[0]}}, sort @{$result{$key}};
	}
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









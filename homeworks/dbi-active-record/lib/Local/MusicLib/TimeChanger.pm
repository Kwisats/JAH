package Local::MusicLib::TimeChanger;

use DateTime;
use Exporter 'import';

sub ct_serializer {
	$_[0]->format_cldr("YYYY-MM-dd HH:mm:ss");
}

sub ct_deserializer {
    my $string = shift;
	$string =~ /^(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)$/;
	return my $dt = DateTime->new (
		year       => $1,
		month      => $2,
		day        => $3,
		hour       => $4,
		minute     => $5,
		second     => $6,
	);
}

sub ext_serializer {
	my $dt = shift;
	my ($h,$m,$s) = split /:/, $dt;
	return $h*3600 + $m*60 + $s;
}

sub ext_deserializer {
	my $seconds = shift;
	my $s = $seconds % 60;
	my $m = int($seconds / 60) % 60;
	my $h = int($seconds / 3600);
	my $result = sprintf("%.2d:%.2d:%.2d", $h,$m,$s);
	return $result;
}

our @EXPORT_OK = qw(ct_serializer ct_deserializer ext_serializer ext_deserializer);
1;
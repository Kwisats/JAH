use FindBin;
use lib "$FindBin::Bin/../lib";
use DDP;
use 5.010;
use Local::MusicLib::Track;

sub test_track {
	my $create_time = DateTime->new (
		year => 1992,
		month => 4,
		day => 20,
		hour => 0,
		minute => 0,
		second => 0
	);

	my $track = Local::MusicLib::Track->new(
		album_id => 1,
		name => 'Nothing Else Matters',
		extension => '00:06:28',
		create_time => $create_time
	);

	say $track->meta->db_class();
	say $track;
}

test_track();
1;
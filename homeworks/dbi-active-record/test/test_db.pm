use FindBin;
use lib "$FindBin::Bin/../lib";
use DDP;
use 5.010;
use Local::MusicLib::Track;
use Local::MusicLib::Album;
use Local::MusicLib::Artist;


my $create_time = DateTime->new (
	year => 1992,
	month => 4,
	day => 20,
	hour => 0,
	minute => 0,
	second => 0
);
my $track = Local::MusicLib::Track->new (
	album_id => 1,
	name => 'Nothing Else Matters',
	extension => '00:06:28',
	create_time => $create_time
);
my $album = Local::MusicLib::Album->new (
	artist_id => 1,
	name => 'Metallica',
	year => 1991,
	type => 'soundtrack',
	create_time => $create_time
);
my $artist = Local::MusicLib::Artist->new (
	name => 'Metallica',
	country => 'us',
	create_time => $create_time
);
$artist->insert;
$album->insert;
$track->insert;

$track_id = $track->id;
$album_id = $album->id;
$artist_id = $artist->id;

$selected_track = Local::MusicLib::Track->select_by_id($track_id);
$selected_album = Local::MusicLib::Album->select_by_id($album_id);
$selected_artist = Local::MusicLib::Artist->select_by_id($artist_id);
p $selected_track;
p $selected_album;
p $selected_artist;

$track->extension('00:06:38');
$track->name('Paradise City');
$track->update;
$album->type('single');
$album->name('Appetite for Destruction');
$album->update;
$artist->name("Guns N'Roses");
$artist->update;

$selected_track = Local::MusicLib::Track->select_by_id($track_id);
$selected_album = Local::MusicLib::Album->select_by_id($album_id);
$selected_artist = Local::MusicLib::Artist->select_by_id($artist_id);
p $selected_track;
p $selected_album;
p $selected_artist;

say "track was deleted" if $track->delete;
say "album was deleted" if $album->delete;
say "artist was deleted" if $artist->delete;



1;
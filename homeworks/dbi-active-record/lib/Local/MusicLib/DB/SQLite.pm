package Local::MusicLib::DB::SQLite;
use Mouse;
extends 'DBI::ActiveRecord::DB::SQLite';

sub _build_connection_params {
    my ($self) = @_;
    return [
        "dbi:mysql:database=musiclib;host=localhost:1234",
        "popyan",
        "popyan71b14", 
        {
        	"RaiseError" => 1, 
			"AutoCommit" => 0, 
			"mysql_enable_utf8" => 1
        }
    ];
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
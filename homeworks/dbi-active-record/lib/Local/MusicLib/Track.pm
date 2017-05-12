package Local::MusicLib::Track;

use DBI::ActiveRecord;
use Local::MusicLib::DB::MySQL;
use Local::MusicLib::TimeChanger qw(ct_serializer ct_deserializer ext_serializer ext_deserializer);
use DateTime;

db "Local::MusicLib::DB::MySQL";

table 'tracks';

has_field (
    'id', 
    {
        isa => 'Int',
        auto_increment => 1,
        index => 'primary'
    } 
);

has_field (
    'name', 
    {
        isa => 'Str',
        index => 'common',
        default_limit => 100
    }
);

has_field (
    'extension', 
    {
        isa => 'Str',
        serializer => \&ext_serializer,
        deserializer => \&ext_deserializer
    }
);

has_field (
    'create_time', 
    {
        isa => 'DateTime',
        serializer => \&ct_serializer,
        deserializer => \&ct_deserializer
    }
);

has_field (
    'album_id',
    {
        isa => 'Int',
        index => 'common',
        default_limit => 100
    }
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;
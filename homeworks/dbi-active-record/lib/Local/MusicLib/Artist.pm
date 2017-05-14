package Local::MusicLib::Artist;

use DBI::ActiveRecord;
use Local::MusicLib::DB::MySQL;
use Local::MusicLib::TimeChanger qw(ct_serializer ct_deserializer);

has_field id => (
    isa => 'Int',
    auto_increment => 1,
    index => 'primary',
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field country => (
    isa => 'Str',
    default_limit => 2,
);

has_field create_time => (
    isa => 'DateTime',
    serializer => \&ct_serializer,
    deserializer => \&ct_deserializer,
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;	
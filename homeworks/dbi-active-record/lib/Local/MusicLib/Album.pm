package Local::MusicLib::Album;

use DBI::ActiveRecord;
use Local::MusicLib::DB::MySQL;
use Local::MusicLib::TimeChanger qw(ct_serializer ct_deserializer);
use Mouse::Util::TypeConstraints;

enum 'TypeEnum' => qw(single soundtrack compilation regular);

no Mouse::Util::TypeConstraints;

use DateTime;

db "Local::MusicLib::DB::MySQL";

table 'albums';

has_field id => (
    isa => 'Int',
    auto_increment => 1,
    index => 'primary',
);

has_field artist_id => (
    isa => 'Int',
    index => 'common',
    default_limit => 100,
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field type => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
    isa => 'TypeEnum',
);

has_field year => (
    isa => 'Int',
);

has_field create_time => (
    isa => 'DateTime',
    serializer => \&ct_serializer,
    deserializer => \&ct_deserializer,
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;
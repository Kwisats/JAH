package Local::ConnectNetwork;

use strict;
use warnings;
use DBI;
use Config::YAML;
use FindBin;
use Exporter 'import';
use DDP;
# use FindBin;
# use lib "$FindBin::Bin/../..";

sub connect{
	my $config = Config::YAML->new(config => "dbi.yaml");
	return my $dbh = DBI->connect($config->{dsn}, $config->{user}, $config->{password}, $config->{dbi_params})
}

our @EXPORT_OK = qw(connect);
1;

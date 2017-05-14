package Local::ConnectNetwork;

use strict;
use warnings;
use DBI;
use DBIx::Config;
use FindBin;
use Exporter 'import';

sub connect{
	return my $dbh = DBIx::Config->connect( "SocialN" );
}

our @EXPORT_OK = qw(connect);
1;

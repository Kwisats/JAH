#fix csrf;
#Dancer2::csrf::plugin;
package fastpaste;
use utf8;
use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::CSRF;
use Digest::CRC qw/crc64/;
use HTML::Entities;
use DDP;

our $VERSION = '0.1';

my $upload_dir = 'paste';

sub get_upload_dir {
	return config->{appdir} . '/' . $upload_dir . '/';
}

sub delete_entry {
	my $id = shift;
	database->do('DELETE FROM paste WHERE id = cast(? as signed)', {}, $id);
	unlink get_upload_dir . $id;
}

get qr{/([a-f0-9]{16})$} => sub {
	session('user') or redirect('/Authorization');
	my ($id) = splat;
	$id = unpack 'Q', pack 'H*', $id;
	my $sth = database->prepare('SELECT cast(id as unsigned) as id, create_time, unix_timestamp(expire_time) as expire_time, title, user_id, user_friends FROM paste where id = cast(? as signed)');#how does it work?###################################################
	unless ($sth->execute($id)) {#how does it work?#########################################################
		response->status(404);
		return template 'index' => {err => ['Fast paste not found'], csrf_token => get_csrf_token()};
	}
	my $db_res = $sth->fetchrow_hashref();
	if ($db_res->{expire_time} and $db_res->{expire_time} < time()) {
		delete_entry($id);
		response->status(404);
		return template 'index' => {err => ['Fast paste expired'], csrf_token => get_csrf_token()};
	}
	my $fh;
	unless (open ($fh, '<:utf8', get_upload_dir . $id)) {
		delete_entry($id);
		response->status(404);
		return template 'index' => {err => ['Fast paste not found'], csrf_token => get_csrf_token()};
	}
	unless ($db_res->{user_id} == session('user')) {
		my $user = database->quick_select('user', { id => session('user')});
		print "\n".session('user');#wrong parse
		unless ($db_res->{user_friends} =~/$user->{username}/ and $db_res->{user_friends} !~/$user->{username}\w/ and $db_res->{user_friends} !~/\w$user->{username}/) {
			return template 'index' => {err => ['Permission denied'], csrf_token => get_csrf_token()};
		}
	}
	my @text = <$fh>;
	close($fh);
	for (@text) {
		$_ = encode_entities($_, '<>&"');
		s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
		s/^ /&nbsp;/g;
	}
	return template 'paste_show.tt' => {id => $id, text => \@text, raw => join('', @text), create_time => $db_res->{create_time}, expire_time => $db_res->{expire_time}, title => $db_res->{title}, csrf_token => get_csrf_token()};
};

get '/' => sub {
	session('user') or redirect('/Authorization');
    redirect('/index');
    #template index => { 'title' => 'Notes', csrf_token => get_csrf_token() };#are you sure?###########################################
};

get '/Authorization' => sub {
	set layout => 'start';
	template login => { csrf_token => get_csrf_token() };
};

get '/index' => sub {
	set layout => 'main';
	template index => { csrf_token => get_csrf_token() };
};

post '/Authorization' => sub {
	my $username = params->{username};
	my $password = params->{password};
	my @err = ();
	push @err, 'Login or password is empty' if (!$username or !$password);
	push @err, 'Login or password is too large' if (length($username) > 255 or length($password) > 255); 
	push @err, 'Login and password can contain only english letters and numbers' if $username =~ /\W/ or $password =~ /\W/;		
	my $select = database->prepare('SELECT cast(id as unsigned) as id, username, password FROM user where username = (?)');
	my $insert = database->prepare('INSERT INTO user (username, password) VALUES ((?),(?))');
	$select->execute($username);
	my $db_res = $select->fetchrow_hashref();
	unless (exists $db_res->{id}) {
		$insert->execute($username, $password);
		$select->execute($username);
		$db_res = $select->fetchrow_hashref();
		session user => $db_res->{id};
		#print STDERR "\n\nd1=$db_res->{'cast(id as unsigned)'}\t$db_res->{username}\ts1=",session('user'),"\n\n";
		redirect '/index';
	}else {
		push @err, 'Wrong password' if $password ne $db_res->{password};
	}
	return template login => {err => \@err} if (@err);
	session user => $db_res->{id};
	#print STDERR "\n\nd2=$db_res->{id}\ts2=",session('user'),"\n\n";
	redirect '/index';
};

post '/index' => sub{
	session('user') or redirect('/Authorization');
	my $text = params->{textpaste};
	my $title = params->{title}||'';
	my $expire = params->{expire};
	my $friends = params->{users}||'';

	my @err = ();
	if (!$text) {
		push @err, 'Empty text';
	}
	if (length($text) > 10240) {
		push @err, 'Text too large';	
	}
	if ($expire =~ /\D/ or $expire < 0 or $expire > 3600 * 24 * 365) {
		push @err, 'Expire more than 365 days or bad format';	
	}
	if ($friends =~ /[^\w ]/) {
		push @err, 'Row of users must include logins separated by spaces';	
	}
	if ($title =~ /[^\w ]/) {
		push @err, 'Title can contain only english letters, numbers and spaces';	
	}
	if (@err) {#mistake
		$text = encode_entities($text, '<>&"');#amy be for friends too?##################################################
		$title = encode_entities($title, '<>&"');
		$expire = encode_entities($expire, '<>&"');
		$friends = encode_entities($friends, '<>&"');
		return template 'index' => {text => $text, title => $title, expire => $expire, err => \@err, csrf_token => get_csrf_token()};
	}

	my $create_time = time();
	my $expire_time = $expire ? $create_time + $expire : undef;
	my $sth = database->prepare('INSERT INTO paste (id, create_time, expire_time, title, user_id, user_friends) VALUES (cast(? as signed),from_unixtime(?),from_unixtime(?),(?),(?),(?))');

	my $id = '';
	my $try_count = 10;
	while (!$id or -f get_upload_dir . $id){
		database->do("DELETE FROM paste where id = cast(? as signed);", {}, [$id]) if $id;
		unless (--$try_count) {
			$id = undef;
			last;
		}
		$id = crc64($text.$create_time.$id);
		#print STDERR "\n\ns3=",session('user'),"\n\n";
		$id = undef unless $sth->execute($id, $create_time, $expire_time, $title, session('user'), $friends);
	}
	unless ($id) {
		die "Try later";
	}

	my $fh;
	unless (open($fh, '>', get_upload_dir.$id)) {
		die "Internal error ", $!, get_upload_dir.$id;
	}
	print $fh $text;
	close($fh);
	redirect '/' . unpack 'H*', pack 'Q', $id;
};

hook before_layout_render => sub { 
	my $tokens = shift;
	my $user_select = database->prepare('SELECT cast(id as unsigned) as id, create_time, title, user_id from paste where (expire_time is null or expire_time > current_timestamp) and user_id = (?) order by create_time desc limit 10');
	$user_select->execute(session('user'));
	my $buff;
	my @user_last_paste = ();
	while ($buff = $user_select->fetchrow_hashref()) {
		$buff->{title} = encode_entities($buff->{title}, '<>&"');
	 	$buff->{id} = unpack 'H*', pack "Q", $buff->{id};
	 	push @user_last_paste, $buff;
	}
	$tokens->{user_last_paste} = \@user_last_paste;

	my $select = database->prepare('SELECT cast(paste.id as unsigned) as id, create_time, title, username FROM paste LEFT JOIN user ON paste.user_id = user.id where (expire_time is null or expire_time > current_timestamp) order by create_time desc limit 10');
	$select->execute();
	my @last_paste = ();
	while ($buff = $select->fetchrow_hashref()) {
		$buff->{title} = encode_entities($buff->{title}, '<>&"');
		$buff->{username} = encode_entities($buff->{username}, '<>&"');
	 	$buff->{id} = unpack 'H*', pack "Q", $buff->{id};
	 	push @last_paste, $buff;
	}
	$tokens->{last_paste} = \@last_paste;
};

hook before => sub {
	warn "\n\n".param('csrf_token')."\n\n";
	if ( request->is_post() ) {
		my $csrf_token = param('csrf_token');
		print $csrf_token;
		if ( !$csrf_token || !validate_csrf_token($csrf_token) ) {
			redirect '/';
		}
	}

};

true;

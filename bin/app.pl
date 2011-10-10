#!/usr/bin/env perl
use Dancer;
use Dancer::Plugin::Database;
use RadioDance;
use POSIX qw(mkfifo);

my $player;

#
#	Main page.  A list of 
#
get '/' => sub {

	`mixerctl -n outputs.master` =~ /(\d+)/;
	my $volume = $1;

	my $is_playing = defined $player ? true : false;

	my @qry = database->quick_select('stations_with_ids', {});
	template 'index', {
		'title' => 'RadioDance',
		'stations' => \@qry,
		'volume' => $volume,
		'playing' => $is_playing
	};


};

get '/add' => sub {
	template 'add_station';
};
post '/add' => sub {
	database->quick_insert('stations', {
		name => params->{name},
		genre => params->{genre},
		url => params->{url}});
	redirect '/';
};

get '/edit/:id' => sub {
	my $q = database->quick_select(
		'stations_with_ids',
		{rowid => params->{id}});
	template 'edit_station' => {
		id => params->{id},
		name => $q->{name},
		genre => $q->{genre},
		url => $q->{url}};
};
post '/edit/:id' => sub {
	database->quick_update('stations', {rowid => params->{id}}, {
		name => params->{name},
		genre => params->{genre},
		url => params->{url}});
	redirect '/';
};

post '/delete/:id' => sub {
	database->quick_delete('stations', {rowid => params->{id}});
	redirect '/';
};

post '/vol' => sub {
	my $volume = params->{vol};
	`mixerctl outputs.master=$volume`;
	redirect '/';
};

get '/play/:id' => sub {
	my $q = database->quick_select(
		'stations_with_ids',
		{ rowid => params->{id}});

	if ($player) {
		print $player "quit\n";
	}

	open($player, "| mplayer -quiet -playlist $q->{url} > logs/mplayer.log 2>&1");

	redirect '/';	
};

get '/stop' => sub {
	print $player "quit\n";
	$player = undef;
	redirect '/';	
};

dance;

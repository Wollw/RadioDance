#!/usr/bin/env perl
use Dancer;
use Dancer::Plugin::Database;
use RadioDance;

# A pipe to the music player.  Undefined if nothing being played.
my $player;

# The name of the current playing station if there is one. Undefined otherwise.
my $current_station_name;

#
#	Main page.
#	Consists of:
#		- Volume control
#		- "Add station" button leading to subpage for adding a radio station
#		- A list of known stations
#		- If a station is currently playing it also shows:
#			- A "Stop" button
#			- The name of the playing radio station
#
#	Volume configuration is OpenBSD specific but should be easy to change
#	for other *nix systems.  A SQLite database is accessed to look for 
#	stations to list.
#
get '/' => sub {

	# OpenBSD specific code for volume
	`mixerctl -n outputs.master` =~ /(\d+)/;
	my $volume = $1;

	my $is_playing = defined $player ? true : false;

	my @qry = database->quick_select('stations_with_ids', {});

	template 'index', {
		'title' => 'RadioDance',
		'stations' => \@qry,
		'volume' => $volume,
		'playing' => $is_playing,
		'current_station_name' => $current_station_name
	};


};

#
#	A page for allowing users to add stations to the database.
#	
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

#
#	A page like the "add" page above but for already defined stations.
#	Allows station data to be edited or be deleted.
#
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

#
#	Volume adjustment called after volume slider on main page is
#	changed.
#
post '/vol' => sub {
	my $volume = params->{vol};
	
	# OpenBSD specific code for volume setting
	`mixerctl outputs.master=$volume`;

	redirect '/';
};

#
#	The request for playing a station. A pipe to the player is opened 
#	and is managed by printing to the pipe.  Makes sure any current
#	instance of the player is quit before playing too.
#
get '/play/:id' => sub {
	my $q = database->quick_select(
		'stations_with_ids',
		{ rowid => params->{id}});

	if ($player) {
		print $player "quit\n";
	}

	$current_station_name = $q->{name};

	open($player, "| mplayer -quiet -playlist $q->{url} > logs/mplayer.log 2>&1");

	redirect '/';	
};

#
#	Stop whatever is playing.  Mark player and station name as undefined.
#
get '/stop' => sub {
	print $player "quit\n";
	$player = undef;
	$current_station_name = undef;
	redirect '/';	
};

dance;

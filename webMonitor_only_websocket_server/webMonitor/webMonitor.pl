package webMonitorPlugin;

# webMonitor - an HTTP interface to monitor bots
# Copyright (C) 2006 kaliwanagan
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#############################################

# webMonitorV2 - Web interface to monitor yor bots
# Copyright (C) 2012 BonScott
# thanks to iMikeLance
#
# ------------------------------
# How use:
#
# Install the following packages:
#
#      Protocol::WebSocket
#      JSON::Any
#      JSON::PP
#      Wx
#      File::ReadBackwards
#
# Add in your config.txt
#
# webBind localhost
# webPort XXXX
# webMapURL http://www.ragdata.com/images/maps/%s.jpg
#
# Where XXXX is a number of your choice. Ex:
# webPort 1020
#
# If webPort not defined in config, the default port is 1025
# ------------------------------
# Set only one port for each bot. For more details, visit:
# [OpenKoreBR]
#	http://openkore.com.br/index.php?/topic/3189-webmonitor-v2-by-bonscott/
# [OpenKore International]
#	http://forums.openkore.com/viewtopic.php?f=34&t=18264
#############################################

use strict;
use lib 'C:/strawberry/perl/lib';
use lib 'C:/strawberry/perl/site/lib';
use lib 'C:/strawberry/perl/vendor/lib';
use Plugins;
use Settings;
our $path;
BEGIN {
	$path = $Plugins::current_plugin_folder;
}
use lib $path;
use Globals;
use Log qw(warning message error);

# Initialize some variables as well as plugin hooks

my $websocket_Port;
my $websocket_Host;
my $webserver;
our $socketServer;

Plugins::register('webMonitor', 'Web interface to monitor yor bots', \&Unload);
my $hook = Plugins::addHooks(
	['mainLoop_post', \&mainLoop],
	['start3', \&post_loading],
);

sub Unload {
	Plugins::delHooks($hook);
}

##### Seting webServer after of plugins loads
sub post_loading {
	$websocket_Port = $config{websocket_Port} || 3333;
	$websocket_Host = $config{websocket_Host} || "localhost";

	eval {
		require WebMonitor::WebSocketServer;
		$socketServer = new WebMonitor::WebSocketServer($websocket_Port, $websocket_Host);
	};
	unless ($socketServer) {
		error "WebSocket server failed to start: $@\n"
	}
}

sub mainLoop {
	return if !$socketServer;
	$socketServer->iterate if $socketServer;
}

1;
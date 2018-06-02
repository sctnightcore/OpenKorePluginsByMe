############################
# forwardPms plugin for OpenKore by thefallen
#
# This software is open source, licensed under the GNU General Public
# License, version 2.
#
# Whenever the bot recives a PM, it will forward to Discord
#
# Use at your own risk.
#
# This plugin should be in a subfolder of plugins like 'plugins/Chattodiscord/Chattodiscord.pl'.
#
############################

package PmtoDiscord;

use strict;
use Plugins;
use Globals;
use Commands;
use LWP::UserAgent;


Plugins::register('PmtoDiscord', 'Forwards PMs received to Discord.', \&onUnload);

my $hooks = Plugins::addHooks(
        ['packet_privMsg', \&receivedPM, undef]
);

sub onUnload {
    Plugins::delHooks($hooks);
}
#TODO : optimized Code ! 
sub receivedPM {
    my ($self, $args, $user, $msg, $ua, $url, $json, $req) = @_;
	#openkore
	$user = $args->{privMsgUser};
	$msg = $args->{privMsg};
	#wehhook setting
	$ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0'); 
	$url = 'https://discordapp.com/api/webhooks/452478667252039680/Lqb0i4-cKm9_OClAtZI-ETFeK2BHYecZXBijggSWchjwzJlFxK820jTo_WISibWoqBBD';
	$json = '{"username":"[PmToDiscord]","content":"'.[$user].':'.$msg.'"}';
	$req = HTTP::Request->new(POST=>$url);
	$req->header('content-type' => 'application/json');
	$req->content($json);
	$ua->request($req);
}
1;
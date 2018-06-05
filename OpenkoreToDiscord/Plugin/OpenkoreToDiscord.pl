############################
# Openkore -> Discord[Webhook]  plugin for OpenKore by sctnightcore & alisonrag
# This software is open source, licensed under the GNU General Public
# License, version 2.
# Whenever the bot recives , it will forward to Discord
# Use at your own risk.
# This plugin should be in a subfolder of plugins like 'plugins/OpenkoreToDiscord/OpenkoreToDiscord.pl'.
# 
############################

package OpenkoreToDiscord;

use strict;
use Plugins;
use Log qw(warning message error debug);
use JSON::Tiny qw(encode_json);
use LWP::UserAgent;
use I18N qw(bytesToString);
use Globals;
use Misc;
use Time::HiRes qw(time);
use Utils qw( existsInList getFormattedDate timeOut makeIP compactArray calcPosition distance);
use Translation;

Plugins::register('OpenkoreToDiscord', 'Forwards received to Discord.', \&onUnload);

my $hooks = Plugins::addHooks(
        ['packet_privMsg', \&receivedPM],
		['disconnected',	\&disconnected],
		['self_died',	\&self_died],
		['base_level_changed',	\&base_level_changed],
		['job_level_changed',	\&job_level_changed],
		['Network::Receive::map_changed',	\&map_changed],			
);

sub onUnload {
    Plugins::delHooks($hooks);
}


sub receivedPM {
	my ($self, $args, $user, $msg) = @_;
	my $msg;
	my $time = getFormattedDate(time);
	$msg .= "```================ [Openkore ChatLog] ===============\n";
	$msg .= ("Time: ".$time."\n", );
	$msg .= ("FROM :[".$args->{privMsgUser}."] : ".$args->{privMsg}."\n"),
	$msg .= "=================================================```\n";
	discordnotifier($msg);
}


sub disconnected {
	my $msg = "```OpenKore Status : Disconnect```";
	debug "Send disconnected To Discord!\n";
	discordnotifier($msg);
}
	
sub self_died {
	my $msg;
	$msg .= "```================ [Openkore Notifier] ===============\n";
	$msg .= "Name: ".$char->{name}." \n",
	$msg .= "Status :".$char->{dead}."\n",
	$msg .= "Map: ".$field->name."\n",
	$msg .= "=================================================```\n";
	debug "Send self_died To Discord!\n";
	discordnotifier($msg);
}

sub base_level_changed {
	my $msg;
	my ($self, $args) = @_;
	$msg .= "```================ [Openkore Notifier] ===============\n";
	$msg .= "Name : ".$char->{name}."\n",
	$msg .= "LvUP! : ".$args->{level}."\n",
	$msg .= "=================================================```\n";
	debug "Send base_level_changed To Discord!\n";
	discordnotifier($msg);
}

sub job_level_changed {
	my $msg;
	my ($self, $args) = @_;
	$msg .= "```================ [Openkore Notifier] ===============\n";
	$msg .= "Name: ".$char->{name}."\n",
	$msg .= "JobLvUP! : ".$args->{level}."\n",
	$msg .= "=================================================```\n";
	discordnotifier($msg);
}

sub map_changed {
	my $msg;
	my ($self, $args) = @_;
	return unless ($field->name ne $args->{oldMap});
	$msg .= "```================ [Openkore Notifier] ===============\n";	
	$msg .= "Name: ".$char->{name}."\n",
	$msg .= "OldMap : ".$args->{oldMap}."\n",
	$msg .= "NewMap : ".$field->name."\n",		
	$msg .= "=================================================```\n";
	debug "Send map_changed To Discord!\n";
	discordnotifier($msg);
}



sub discordnotifier {
	my ($msg) = @_;
	my %content = ('username' => '[OpenKore]', 'content' => $msg);
	my $json = encode_json(\%content);
	require LWP::UserAgent;
	LWP::UserAgent->new->post(
	'https://discordapp.com/api/webhooks/452977815445569537/zIBp-624XFPe6h3KZYNrrMsUjGsf4tSi4K2U2eyRdyXyzTtOXBuQiOnG5H_-pmb09frL', 
	'Content-Type' => 'application/json',
	'User-Agent' => 'Mozilla/4.0',
	'Content' => $json,
	);
}
1;
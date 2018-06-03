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
# This plugin should be in a subfolder of plugins like 'plugins/PmtoDiscord/PmtoDiscord.pl'.
#
############################

package PmtoDiscord;

use strict;
use Plugins;
use Globals;
use Log qw(warning message error debug);
use LWP::UserAgent;
use I18N qw(bytesToString);


Plugins::register('OpenkoreToDiscord', 'Forwards received to Discord.', \&onUnload);

my $hooks = Plugins::addHooks(
        ['packet_privMsg', \&receivedPM],
		['disconnected',	\&disconnected],
		['self_died',	\&self_died],
		['base_level_changed',	\&base_level_changed],
		['job_level_changed',	\&job_level_changed],
		['Network::Receive::map_changed',	\&map_changed],			
		['packet/deal_request',	\&deal_request],
		['packet/party_invite',	\&party_invite],
		['packet/friend_request',	\&friend_request],	
);

sub onUnload {
    Plugins::delHooks($hooks);
}


sub disconnected {
	my ($self, $args) = @_;
	my $openkoretodiscord = '{"username":"[OpenKore]","content":"Openkore Status Changed to: DISCONNECTED"}';
	message "Send self_died To Discord!\n";
	$self->discordnotifier();
}
	
sub self_died {
	my ($self, $args) = @_;
	my $openkoretodiscord = '{"username":"[OpenKore]","content":"The '.$char->{name}.' DIED in '.$field->name.'"}';
	message "Send self_died To Discord!\n";
	$self->discordnotifier();
}

sub base_level_changed {
	my ($self, $args) = @_;
	my $openkoretodiscord = '{"username":"[OpenKore]","content":"The '.$char->{name}.' is now in base level '.$args->{level}.'"}';
	message "Send base_level_changed To Discord!\n";
	$self->discordnotifier();
}

sub job_level_changed {
	my ($self, $args) = @_;
	my $openkoretodiscord = '{"username":"[OpenKore]","content":"The '.$char->{name}.' is now in job level '.$args->{level}.'';
	message "Send job_level_changed To Discord!\n";
	$self->discordnotifier();
}

sub map_changed {
	my ($self, $args) = @_;
	my $openkoretodiscord = '{"username":"[OpenKore]","content":"The '.$char->{name}.' changed map from : '.$args->{oldMap}.' to : '. $field->name.'"}';
	message "Send map_changed To Discord!\n";
	$self->discordnotifier();
}

sub deal_request {
	my ($self, $args) = @_;
	my $user = bytesToString($args->{user});
	my $openkoretodiscord = '{ "username": "OpenKore", "content": "'.$user.' is trying to deal with '.$char->{name}.'"}';
	message "Send deal_request To Discord!\n";
	$self->discordnotifier();
}

sub party_invite {
	my ($self, $args) = @_;
	my $party_name = bytesToString($args->{name});
	my $openkoretodiscord = '{ "username": "OpenKore", "content": "Incoming Request to join party '.$party_name.'"}';
	message "Send party_invite To Discord!\n";
	$self->discordnotifier();
}

sub friend_request {
	my ($self, $args) = @_;
	my $incoming_friend_name = bytesToString($args->{name});
	my $openkoretodiscord = '{ "username": "OpenKore", "content": "'.$incoming_friend_name.' wants to be your friend"}';
	message "Send friend_request To Discord!\n";
	$self->discordnotifier();
}

sub discordnotifier {
	my ($message, $openkoretodiscord) = @_;
	require LWP::UserAgent;
	LWP::UserAgent->new->post(
	'https://discordapp.com/api/webhooks/452478667252039680/Lqb0i4-cKm9_OClAtZI-ETFeK2BHYecZXBijggSWchjwzJlFxK820jTo_WISibWoqBBD', [
	'Content-Type' => 'application/json',
	'User-Agent' => 'Mozilla/4.0',
	'Content' => $openkoretodiscord,
	]);
}

1;
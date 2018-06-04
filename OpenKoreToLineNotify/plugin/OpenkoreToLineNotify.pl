############################
# Openkore -> LineNotify[ToKen]  plugin for OpenKore by sctnightcore & alisonrag
# This software is open source, licensed under the GNU General Public
# License, version 2.
# Whenever the bot recives , it will forward to Discord
# Use at your own risk.
# This plugin should be in a subfolder of plugins like 'plugins/OpenkoreToLineNotify/OpenkoreToLineNotify.pl'.
# 
############################

package OpenkoreToLineNotify;

use strict;
use Plugins;
use Log qw(warning message error debug);
use JSON::Tiny qw(encode_json);
use LWP::UserAgent;
use I18N qw(bytesToString);
use Globals;
use Misc;
use Time::HiRes qw(time);
use Translation;



Plugins::register('OpenkoreToLineNotify', 'Forwards received to Discord.', \&onUnload);

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
	my $MESSAGE = ('```[ChatLog] '.$args->{privMsgUser}.':'.$args->{privMsg}.'```');	
	LineNotify($MESSAGE);
}


sub disconnected {
	my $MESSAGE = ('```[Notifier]: Openkore Status Changed to: DISCONNECTED```');
	debug "Send self_died To Discord!\n";
	LineNotify($MESSAGE);
}
	
sub self_died {
	my $MESSAGE = ('```[Notifier]: '.$char->{name}.' DIED in '.$field->name.'```');
	debug "Send self_died To Discord!\n";
	LineNotify($MESSAGE);
}

sub base_level_changed {
	my ($self, $args) = @_;
	my $MESSAGE = ('```[Notifier]: '.$char->{name}.' is now in base level '.$args->{level}.'```');
	debug "Send base_level_changed To Discord!\n";
	LineNotify($MESSAGE);
}

sub job_level_changed {
	my ($self, $args) = @_;
	my $MESSAGE = ('```[Notifier]: '.$char->{name}.' is now in job level '.$args->{level}.'```');
	debug "Send job_level_changed To Discord!\n";
	LineNotify($MESSAGE);
}

sub map_changed {
	my ($self, $args) = @_;
	return unless ($field->name ne $args->{oldMap});
	my $MESSAGE = ('```[Notifier]: '.$char->{name}.' changed map from: '.$args->{oldMap} . ' to: ' . $field->name. '```');
	debug "Send map_changed To Discord!\n";
	LineNotify($MESSAGE);
}



sub LineNotify {
	my ($MESSAGE) = @_;
	my %content = ('username' => '[OpenKore]', 'content' => $MESSAGE);
	my $json = encode_json(\%content);
	require LWP::UserAgent;
	LWP::UserAgent->new->post(
	'https://notify-api.line.me/api/notify', 
	 { message => $MESSAGE},
	 Authorization => 'Bearer ',
	);
}

1;

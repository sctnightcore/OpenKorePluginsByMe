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
# This plugin should be in a subfolder of plugins like 'pluginsPmtoDiscordPmtoDiscord.pl'.
#
############################

package OpenkoreToDiscord;

use strict;
use Plugins;
use Log qw(warning message error debug);
use JSONTiny qw(encode_json);
use LWPUserAgent;
use I18N qw(bytesToString);
use Globals;




Pluginsregister('OpenkoreToDiscord', 'Forwards received to Discord.', &onUnload);

my $hooks = PluginsaddHooks(
        ['packet_privMsg', &receivedPM],
		['disconnected',	&disconnected],
		['self_died',	&self_died],
		['base_level_changed',	&base_level_changed],
		['job_level_changed',	&job_level_changed],
		['NetworkReceivemap_changed',	&map_changed],			
);

sub onUnload {
    PluginsdelHooks($hooks);
}


sub disconnected {
	my ($self, $args) = @_;
	my $message = '```Openkore Status Changed to DISCONNECTED```';
	message Send self_died To Discord!n;
	discordnotifier($message);
}
	
sub self_died {
	my ($self, $args) = @_;
	my $message = '```The '.$char-{name}.' DIED in '.$field-name.'```';
	message Send self_died To Discord!n;
	discordnotifier($message);
}

sub base_level_changed {
	my ($self, $args) = @_;
	my $message = '```The '.$char-{name}.' is now in base level '.$args-{level}.'```';
	message Send base_level_changed To Discord!n;
	discordnotifier($message);
}

sub job_level_changed {
	my ($self, $args) = @_;
	my $message = '```The '.$char-{name}.' is now in job level '.$args-{level}.'```';
	message Send job_level_changed To Discord!n;
	discordnotifier($message);
}

sub map_changed {
	my ($self, $args) = @_;
	my $message = '```The '.$char-{name}.' changed map from '.$args-{oldMap} . ' to ' . $field-name. '```';
	message Send map_changed To Discord!n;
	discordnotifier($message);
}



sub discordnotifier {
	my ($self, $user, $message) = @_;

	my %content = ('username' = 'OpenKore', 'content' = $message);
	my $json = encode_json(%content);
	
	require LWPUserAgent;
	LWPUserAgent-new-post(
	'httpsdiscordapp.comapiwebhooks452478667252039680Lqb0i4-cKm9_OClAtZI-ETFeK2BHYecZXBijggSWchjwzJlFxK820jTo_WISibWoqBBD', 
	'Content-Type' = 'applicationjson',
	'User-Agent' = 'Mozilla4.0',
	'Content' = $json,
	);
}

1;
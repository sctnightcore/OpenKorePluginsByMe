use LWP::UserAgent;

my	$ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0'); 
my	$url = 'https://discordapp.com/api/webhooks/452478667252039680/Lqb0i4-cKm9_OClAtZI-ETFeK2BHYecZXBijggSWchjwzJlFxK820jTo_WISibWoqBBD';
my	$json = '{"username":"[Chatlog]","content":"<Test>:test1"}';
my	$req = HTTP::Request->new(POST=>$url);
	$req->header('content-type' => 'application/json');
	$req->content($json);
my	$res = $ua->request($req);


use LWP::UserAgent;
use JSON::Tiny qw(encode_json);


my $test = '84848';
my %content = ('username' => 'OpenKore', 'content' => $test);
my $json = encode_json(\%content);

my $ua = LWP::UserAgent->new->post(
	'https://discordapp.com/api/webhooks/452977815445569537/zIBp-624XFPe6h3KZYNrrMsUjGsf4tSi4K2U2eyRdyXyzTtOXBuQiOnG5H_-pmb09frL', 
	'Content-Type' => 'application/json',
	'User-Agent' => 'Mozilla/4.0',
	'Content' => $json,
	);

if ($ua->is_success) {
    my $message = $ua->decoded_content;
    print "Received reply: $message\n";
} else {
    print "HTTP POST error code: ", $ua->code, "\n";
    print "HTTP POST error message: ", $ua->message, "\n";
}
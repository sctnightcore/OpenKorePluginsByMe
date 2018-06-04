use LWP::UserAgent;
my $test = {'sctnightcore'};
my $ua = LWP::UserAgent->new->post(
	'https://notify-api.line.me/api/notify',
	{ message => $test},
	'Authorization' => 'Bearer <token>',
	);
if ($ua->is_success) {
    my $message = $ua->decoded_content;
	print "HTTP POST error code: ", $ua->code, "\n";
	print "Received reply: ", $message, "\n";
} else {
    print "HTTP POST error code: ", $ua->code, "\n";
    print "HTTP POST error message: ", $ua->message, "\n";
}


1;
use exp_analysis_multiple::exp_analysis_multipleImpl;

use exp_analysis_multiple::exp_analysis_multipleServer;
use Plack::Middleware::CrossOrigin;



my @dispatch;

{
    my $obj = exp_analysis_multiple::exp_analysis_multipleImpl->new;
    push(@dispatch, 'model_analysis_expession' => $obj);
}


my $server = exp_analysis_multiple::exp_analysis_multipleServer->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $handler = sub { $server->handle_input(@_) };

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");

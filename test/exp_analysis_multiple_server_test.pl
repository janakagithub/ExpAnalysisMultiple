use strict;
use Data::Dumper;
use Test::More;
use Config::Simple;
use Time::HiRes qw(time);
use Bio::KBase::AuthToken;
use Bio::KBase::workspace::Client;
use exp_analysis_multiple::exp_analysis_multipleImpl;

local $| = 1;
my $token = $ENV{'KB_AUTH_TOKEN'};
my $config_file = $ENV{'KB_DEPLOYMENT_CONFIG'};
my $config = new Config::Simple($config_file)->get_block('exp_analysis_multiple');
my $ws_url = $config->{"workspace-url"};
my $ws_name = undef;
my $ws_client = new Bio::KBase::workspace::Client($ws_url,token => $token);
my $auth_token = Bio::KBase::AuthToken->new(token => $token, ignore_authrc => 1);
my $ctx = LocalCallContext->new($token, $auth_token->user_id);
$exp_analysis_multiple::exp_analysis_multipleServer::CallContext = $ctx;
my $impl = new exp_analysis_multiple::exp_analysis_multipleImpl();
=head
sub get_ws_name {
    if (!defined($ws_name)) {
        my $suffix = int(time * 1000);
        $ws_name = 'test_exp_analysis_multiple_' . $suffix;
        $ws_client->create_workspace({workspace => $ws_name});
    }
    return $ws_name;
}

eval {
    my $obj_name = "contigset.1";
    my $contig = {id => '1', length => 10, md5 => 'md5', sequence => 'agcttttcat'};
    my $obj = {contigs => [$contig], id => 'id', md5 => 'md5', name => 'name',
            source => 'source', source_id => 'source_id', type => 'type'};
    $ws_client->save_objects({workspace => get_ws_name(), objects =>
            [{type => 'KBaseGenomes.ContigSet', name => $obj_name, data => $obj}]});
    my $ret = $impl->count_contigs(get_ws_name(), $obj_name);
    ok($ret->{contig_count} eq 1, "right number of contigs");
    done_testing(1);
};
=cut


my $pa1 = "ExpAnalysisFirst";
my $pa2 = "test_gapffill.fba.1.lb.4c.24th.rmaAnalysis";
my $pa3 = "auto60";
my $ws = 'janakakbase:1450461455608';
my $output = "multiPathway";

my $inputVar = [$pa1,$pa2,$pa3];
eval {
my $ret = $impl->exp_analysis_multiple($ws, $inputVar, $output);
 #print &Dumper ($ret);
};


my $err = undef;
if ($@) {
    $err = $@;
}
eval {
    if (defined($ws_name)) {
        $ws_client->delete_workspace({workspace => $ws_name});
        print("Test workspace was deleted\n");
    }
};
if (defined($err)) {
    if(ref($err) eq "Bio::KBase::Exceptions::KBaseException") {
        die("Error while running tests: " . $err->trace->as_string);
    } else {
        die $err;
    }
}

{
    package LocalCallContext;
    use strict;
    sub new {
        my($class,$token,$user) = @_;
        my $self = {
            token => $token,
            user_id => $user
        };
        return bless $self, $class;
    }
    sub user_id {
        my($self) = @_;
        return $self->{user_id};
    }
    sub token {
        my($self) = @_;
        return $self->{token};
    }
    sub authenticated {
        return 1;
    }
    sub log_debug {
        my($self,$msg) = @_;
        print STDERR $msg."\n";
    }
    sub log_info {
        my($self,$msg) = @_;
        print STDERR $msg."\n";
    }
}
package exp_analysis_multiple::exp_analysis_multipleClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

exp_analysis_multiple::exp_analysis_multipleClient

=head1 DESCRIPTION


A KBase module: exp_analysis_multiple
This module compare multiple_pathway analysis_objects


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => exp_analysis_multiple::exp_analysis_multipleClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
        else
        {
	    #
	    # All methods in this module require authentication. In this case, if we
	    # don't have a token, we can't continue.
	    #
	    die "Authentication failed: " . $token->error_message;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 exp_analysis_multiple

  $return = $obj->exp_analysis_multiple($workspace_name, $pathwayAnalysis, $output_PathwayAnalysisMultiple)

=over 4

=item Parameter and return types

=begin html

<pre>
$workspace_name is a model_analysis_expession.workspace_name
$pathwayAnalysis is a model_analysis_expession.pathwayAnalysis
$output_PathwayAnalysisMultiple is a model_analysis_expession.output_PathwayAnalysisMultiple
$return is a model_analysis_expession.FBAPathwayAnalysisMultiple
workspace_name is a string
pathwayAnalysis is a reference to a list where each element is a model_analysis_expession.pathwayAnalysis
output_PathwayAnalysisMultiple is a string
FBAPathwayAnalysisMultiple is a reference to a hash where the following keys are defined:
	pathwayType has a value which is a string
	fbaexpression has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisPathwayMultiple
FBAPathwayAnalysisPathwayMultiple is a reference to a hash where the following keys are defined:
	expression_matrix_ref has a value which is a model_analysis_expession.expression_matrix_ref
	expression_condition has a value which is a string
	fbamodel_ref has a value which is a model_analysis_expession.fbamodel_ref
	fba_ref has a value which is a model_analysis_expession.fba_ref
	count_list has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisCounts
expression_matrix_ref is a string
fbamodel_ref is a string
fba_ref is a string
FBAPathwayAnalysisCounts is a reference to a hash where the following keys are defined:
	pathwayName has a value which is a string
	pathwayId has a value which is a string
	totalModelReactions has a value which is an int
	totalabsentRxns has a value which is an int
	totalKEGGRxns has a value which is an int
	totalRxnFlux has a value which is an int
	gsrFluxPExpP has a value which is an int
	gsrFluxPExpN has a value which is an int
	gsrFluxMExpP has a value which is an int
	gsrFluxMExpM has a value which is an int
	gpRxnsFluxP has a value which is an int

</pre>

=end html

=begin text

$workspace_name is a model_analysis_expession.workspace_name
$pathwayAnalysis is a model_analysis_expession.pathwayAnalysis
$output_PathwayAnalysisMultiple is a model_analysis_expession.output_PathwayAnalysisMultiple
$return is a model_analysis_expession.FBAPathwayAnalysisMultiple
workspace_name is a string
pathwayAnalysis is a reference to a list where each element is a model_analysis_expession.pathwayAnalysis
output_PathwayAnalysisMultiple is a string
FBAPathwayAnalysisMultiple is a reference to a hash where the following keys are defined:
	pathwayType has a value which is a string
	fbaexpression has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisPathwayMultiple
FBAPathwayAnalysisPathwayMultiple is a reference to a hash where the following keys are defined:
	expression_matrix_ref has a value which is a model_analysis_expession.expression_matrix_ref
	expression_condition has a value which is a string
	fbamodel_ref has a value which is a model_analysis_expession.fbamodel_ref
	fba_ref has a value which is a model_analysis_expession.fba_ref
	count_list has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisCounts
expression_matrix_ref is a string
fbamodel_ref is a string
fba_ref is a string
FBAPathwayAnalysisCounts is a reference to a hash where the following keys are defined:
	pathwayName has a value which is a string
	pathwayId has a value which is a string
	totalModelReactions has a value which is an int
	totalabsentRxns has a value which is an int
	totalKEGGRxns has a value which is an int
	totalRxnFlux has a value which is an int
	gsrFluxPExpP has a value which is an int
	gsrFluxPExpN has a value which is an int
	gsrFluxMExpP has a value which is an int
	gsrFluxMExpM has a value which is an int
	gpRxnsFluxP has a value which is an int


=end text

=item Description



=back

=cut

 sub exp_analysis_multiple
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 3)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function exp_analysis_multiple (received $n, expecting 3)");
    }
    {
	my($workspace_name, $pathwayAnalysis, $output_PathwayAnalysisMultiple) = @args;

	my @_bad_arguments;
        (!ref($workspace_name)) or push(@_bad_arguments, "Invalid type for argument 1 \"workspace_name\" (value was \"$workspace_name\")");
        (ref($pathwayAnalysis) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument 2 \"pathwayAnalysis\" (value was \"$pathwayAnalysis\")");
        (!ref($output_PathwayAnalysisMultiple)) or push(@_bad_arguments, "Invalid type for argument 3 \"output_PathwayAnalysisMultiple\" (value was \"$output_PathwayAnalysisMultiple\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to exp_analysis_multiple:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'exp_analysis_multiple');
	}
    }

    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
	method => "model_analysis_expession.exp_analysis_multiple",
	params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'exp_analysis_multiple',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method exp_analysis_multiple",
					    status_line => $self->{client}->status_line,
					    method_name => 'exp_analysis_multiple',
				       );
    }
}
 
  

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "model_analysis_expession.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'exp_analysis_multiple',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method exp_analysis_multiple",
            status_line => $self->{client}->status_line,
            method_name => 'exp_analysis_multiple',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for exp_analysis_multiple::exp_analysis_multipleClient\n";
    }
    if ($sMajor == 0) {
        warn "exp_analysis_multiple::exp_analysis_multipleClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 pathwayAnalysis

=over 4



=item Description

A string representing a list of pathwayAnalysis.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 pathwayAnalysis

=over 4



=item Definition

=begin html

<pre>
a reference to a list where each element is a model_analysis_expession.pathwayAnalysis
</pre>

=end html

=begin text

a reference to a list where each element is a model_analysis_expession.pathwayAnalysis

=end text

=back



=head2 output_PathwayAnalysisMultiple

=over 4



=item Description

A string representing a multiple pathwayAnalysis objects.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 expression_condition

=over 4



=item Description

A string representing a expression condition.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 workspace_name

=over 4



=item Description

A string representing a workspace name.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 expression_matrix_ref

=over 4



=item Description

Reference to expression data
@id ws KBaseFeatureValues.ExpressionMatrix


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 fbamodel_ref

=over 4



=item Description

Reference to metabolic model
@id ws KBaseFBA.FBAModel


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 fba_ref

=over 4



=item Description

Reference to a FBA object
@id ws KBaseFBA.FBA


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 FBAPathwayAnalysisCounts

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
pathwayName has a value which is a string
pathwayId has a value which is a string
totalModelReactions has a value which is an int
totalabsentRxns has a value which is an int
totalKEGGRxns has a value which is an int
totalRxnFlux has a value which is an int
gsrFluxPExpP has a value which is an int
gsrFluxPExpN has a value which is an int
gsrFluxMExpP has a value which is an int
gsrFluxMExpM has a value which is an int
gpRxnsFluxP has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
pathwayName has a value which is a string
pathwayId has a value which is a string
totalModelReactions has a value which is an int
totalabsentRxns has a value which is an int
totalKEGGRxns has a value which is an int
totalRxnFlux has a value which is an int
gsrFluxPExpP has a value which is an int
gsrFluxPExpN has a value which is an int
gsrFluxMExpP has a value which is an int
gsrFluxMExpM has a value which is an int
gpRxnsFluxP has a value which is an int


=end text

=back



=head2 FBAPathwayAnalysisPathwayMultiple

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
expression_matrix_ref has a value which is a model_analysis_expession.expression_matrix_ref
expression_condition has a value which is a string
fbamodel_ref has a value which is a model_analysis_expession.fbamodel_ref
fba_ref has a value which is a model_analysis_expession.fba_ref
count_list has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisCounts

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
expression_matrix_ref has a value which is a model_analysis_expession.expression_matrix_ref
expression_condition has a value which is a string
fbamodel_ref has a value which is a model_analysis_expession.fbamodel_ref
fba_ref has a value which is a model_analysis_expession.fba_ref
count_list has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisCounts


=end text

=back



=head2 FBAPathwayAnalysisMultiple

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
pathwayType has a value which is a string
fbaexpression has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisPathwayMultiple

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
pathwayType has a value which is a string
fbaexpression has a value which is a reference to a list where each element is a model_analysis_expession.FBAPathwayAnalysisPathwayMultiple


=end text

=back



=cut

package exp_analysis_multiple::exp_analysis_multipleClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;

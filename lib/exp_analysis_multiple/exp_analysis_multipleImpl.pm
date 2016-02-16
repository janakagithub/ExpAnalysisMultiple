package exp_analysis_multiple::exp_analysis_multipleImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = "0.1.0";

=head1 NAME

model_analysis_expession

=head1 DESCRIPTION

A KBase module: exp_analysis_multiple
This module compare multiple_pathway analysis_objects

=cut

#BEGIN_HEADER
use Bio::KBase::AuthToken;
use Bio::KBase::workspace::Client;
use Config::IniFiles;
use Data::Dumper;
#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR

    my $config_file = $ENV{ KB_DEPLOYMENT_CONFIG };
    my $cfg = Config::IniFiles->new(-file=>$config_file);
    my $wsInstance = $cfg->val('exp_analysis_multiple','workspace-url');
    die "no workspace-url defined" unless $wsInstance;

    $self->{'workspace-url'} = $wsInstance;

    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



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
    my $self = shift;
    my($workspace_name, $pathwayAnalysis, $output_PathwayAnalysisMultiple) = @_;

    my @_bad_arguments;
    (!ref($workspace_name)) or push(@_bad_arguments, "Invalid type for argument \"workspace_name\" (value was \"$workspace_name\")");
    (ref($pathwayAnalysis) eq 'ARRAY') or push(@_bad_arguments, "Invalid type for argument \"pathwayAnalysis\" (value was \"$pathwayAnalysis\")");
    (!ref($output_PathwayAnalysisMultiple)) or push(@_bad_arguments, "Invalid type for argument \"output_PathwayAnalysisMultiple\" (value was \"$output_PathwayAnalysisMultiple\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to exp_analysis_multiple:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'exp_analysis_multiple');
    }

    my $ctx = $exp_analysis_multiple::exp_analysis_multipleServer::CallContext;
    my($return);
    #BEGIN exp_analysis_multiple
    my $token=$ctx->token;
    my $wshandle=Bio::KBase::workspace::Client->new($self->{'workspace-url'},token=>$token);
    #my $pa1=$wshandle->get_objects([{workspace=>$workspace_name,name=>$pathwayAnalysisFirst}]);
    #my $pa2=$wshandle->get_objects([{workspace=>$workspace_name,name=>$pathwayAnalysisSecond}]);
    #my $rd = $pa1->[0]->{data}->{pathways};
    #my $rd = $pa2->[0]->{data}->{pathways};
    #print &Dumper ($rd);

    my $expAnalysis = {
    	pathwayType => "KEGG",
    	fbaexpression => []
    };



    my $refs ={

    	expression_matrix_ref => "",
    	expression_condition => "",
    	fbamodel_ref => "",
    	fba_ref => "",
    	count_list => []
    };
   my %totRxns;
   for (my $j=0; $j < @{$pathwayAnalysis}; $j++){
    	my $pa1=$wshandle->get_objects([{workspace=>$workspace_name,name=>$pathwayAnalysis->[$j]}]);
    	#print "$pathwayAnalysis->[$j]\n";

    	my $rd = $pa1->[0]->{data}->{pathways};

    	for (my $k=0; $k< @{$rd}; $k++){
    		my $totModRxns = $rd->[$k]->{totalModelReactions};
    		my $pid = $rd->[$k]->{pathwayId};
    		$totRxns{$pid}->{$pathwayAnalysis->[$j]} = $totModRxns;
    	}
    }


    	my @keys = sort { $totRxns{$a} <=> $totRxns{$b} } keys %totRxns;
    		my %sortedInfo;
    		foreach my $k (keys (%totRxns)){
    			my %tempSort;
    			my @sortA;
    			foreach my $k2 (keys(%{$totRxns{$k}})){
    				 #print "$k -> $k2 -> $totRxns{$k}->{$k2}\n";
    				 #$tempSort{$k2} = $totRxns{$k}->{$k2};
    				 push (@{$tempSort{$k2}},$totRxns{$k}->{$k2});
    				 push (@sortA, $totRxns{$k}->{$k2});

    			}
    			#@sortA =(23,8,39,2);
    			my @sortedA = sort { $a <=> $b } @sortA;

    			foreach my $k3 (keys(%{$totRxns{$k}})){
    				$sortedInfo{$k}->{$k3} = ($sortedA[-1] - $totRxns{$k}->{$k3});
    				#print "$sortedA[-1]\n";
    			}

    		}

    		#print &Dumper (\%sortedInfo);
    		#die;

    for (my $j=0; $j < @{$pathwayAnalysis}; $j++){


    	my $refs ={

    	expression_matrix_ref => "",
    	expression_condition => "",
    	fbamodel_ref => "",
    	fba_ref => "",
    	count_list => []
    	};

    	my $pa1=$wshandle->get_objects([{workspace=>$workspace_name,name=>$pathwayAnalysis->[$j]}]);
    	my $r  =$pa1->[0]->{data};
    	$refs->{expression_matrix_ref} = $r->{expression_matrix_ref};
    	$refs->{expression_condition} = $r->{expression_condition};
    	$refs->{fbamodel_ref} = $r->{fbamodel_ref};
    	$refs->{fba_ref} = $r->{fba_ref};


    	my $rd = $pa1->[0]->{data}->{pathways};

    	my $counts = {
    		pathwayName => "",
    		pathwayId => "",
    		totalModelReactions => 0,
    		totalabsentRxns => 0,
    		totalKEGGRxns => 0,
    		totalRxnFlux => 0,
    		gsrFluxPExpP => 0,
    		gsrFluxPExpN => 0,
    		gsrFluxMExpP => 0,
    		gsrFluxMExpM => 0,
    		gpRxnsFluxP => 0

    	};


    	for (my $i=0; $i< @{$rd}; $i++){
    		$counts = {
    		pathwayName => $rd->[$i]->{pathwayName},
    		pathwayId => $rd->[$i]->{pathwayId},
    		totalModelReactions => $rd->[$i]->{totalModelReactions},
    		totalabsentRxns => $sortedInfo{$rd->[$i]->{pathwayId}}->{$pathwayAnalysis->[$j]},
    		totalKEGGRxns => $rd->[$i]->{totalKEGGRxns},
    		totalRxnFlux => $rd->[$i]->{totalRxnFlux},
    		gsrFluxPExpP => $rd->[$i]->{gsrFluxPExpP},
    		gsrFluxPExpN => $rd->[$i]->{gsrFluxPExpN},
    		gsrFluxMExpP => $rd->[$i]->{gsrFluxMExpP},
    		gsrFluxMExpM => $rd->[$i]->{gsrFluxMExpM},
    		gpRxnsFluxP => $rd->[$i]->{gpRxnsFluxP}

    		};
    		push ($refs->{count_list}, $counts);



    		my $pname = $rd->[$i]->{pathwayName};
    		my $pid = $rd->[$i]->{pathwayId};
    		my $fluxPExpP = $rd->[$i]->{gsrFluxPExpP};
    		my $gpFluxP = $rd->[$i]->{gpRxnsFluxP};
    		my $fluxMExpP = $rd->[$i]->{gsrFluxMExpP};
    		my $fluxPExpN = $rd->[$i]->{gsrFluxPExpN};
    		my $fluxMExpM = $rd->[$i]->{gsrFluxMExpM};
    		my $totFluxRxns = $rd->[$i]->{totalRxnFlux};
    		my $totModRxns = $rd->[$i]->{totalModelReactions};


    		#print "$pname\t$fluxPExpP\t$gpFluxP\t$fluxMExpP\t$fluxPExpN\t$fluxMExpM\t$totFluxRxns\t$totModRxns\n";
    	}

    	push (@{$expAnalysis->{fbaexpression}}, $refs);



    	#print "\n\n\n\n";
    }


    my $saveObjectParams;
	$saveObjectParams->{workspace}=$workspace_name;
    $saveObjectParams->{objects}->[0]->{type} = "KBaseFBA.FBAPathwayAnalysisMultiple";
    $saveObjectParams->{objects}->[0]->{data} = $expAnalysis;
    $saveObjectParams->{objects}->[0]->{name} = $output_PathwayAnalysisMultiple;
    my $meta = $wshandle->save_objects($saveObjectParams);

    print &Dumper ($expAnalysis);
    $return = {'expAnalysis' => $expAnalysis};




    #END exp_analysis_multiple
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to exp_analysis_multiple:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'exp_analysis_multiple');
    }
    return($return);
}




=head2 version 

  $return = $obj->version()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module version. This is a Semantic Versioning number.

=back

=cut

sub version {
    return $VERSION;
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

1;

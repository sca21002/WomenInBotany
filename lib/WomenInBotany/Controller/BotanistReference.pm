package WomenInBotany::Controller::BotanistReference;
use Moose;
use namespace::autoclean;
use Devel::Dwarn;

# ABSTRACT: Controller for listening and editing references of botanists

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::BotanistReference - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub botanists_references
    : Chained('/botanist/botanist')
    : PathPart('references')
    : CaptureArgs(0) {
        
    my ($self, $c) = @_;
}

sub change : Chained('botanists_references') Args(0) {
    my ($self, $c) = @_;
    
    $c->log->debug( Dwarn $c->req->params);
    if ($c->req->params->{oper} eq 'edit') {
        $c->forward('edit');
    } elsif ($c->req->params->{oper} eq 'add') {
        $c->forward('add');        
    } elsif ($c->req->params->{oper} eq 'del') {
        $c->forward('delete');
    }
    $c->stash(
        current_view => 'JSON'
    );
}

sub edit : Private {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    my $source = $c->model('WomenInBotanyDB::BotanistReference')->result_source;
    
    my %columns_map;
    undef @columns_map{$source->columns};
    my @columns =  grep { exists $columns_map{$_} } keys %{$c->req->params};
   
    my $data;
    @{$data}{@columns} = @{$c->req->params}{@columns};
    $data->{reference_id} = undef if $data->{reference_id} == 0;
        
    my $reference
        = $botanist->botanists_references->find($c->req->params->{id});
    $reference->update($data);
  
}

sub add : Private {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    my $source = $c->model('WomenInBotanyDB::BotanistReference')->result_source;
    
    my %columns_map;
    undef @columns_map{$source->columns};
    my @columns =  grep { exists($columns_map{$_}) && $_ ne 'id' } keys %{$c->req->params};
   
    my $data;
    @{$data}{@columns} = @{$c->req->params}{@columns};
    $data->{reference_id} = undef
        if exists $data->{reference_id} && $data->{reference_id} == 0;
            
    my $reference
        = $botanist->botanists_references->create($data);
}

sub delete : Private {
    my ($self, $c) = @_;
    
    my $reference = $c->model('WomenInBotanyDB::BotanistReference')
        ->find($c->req->params->{id});
    $reference->delete;
}

sub json : Chained('botanists_references') PathPart('json') Args(0) {
    my ($self, $c) = @_;
    
    my $data = $c->req->params;
    
    my $page = $data->{page} || 1;
    my $entries_per_page = $data->{rows} || 10;
    my $sidx = $data->{sidx} || 'id';
    my $sord = $data->{sord} || 'asc';

    my $botanist = $c->stash->{botanist};

    my $reference_rs = $botanist->botanists_references->search(
        undef,
        {
            page => $page,
            rows => $entries_per_page,
            order_by => {"-$sord" => $sidx}, 
        }
    );

    my $response;
    $response->{page} = $page;
    $response->{total} = $reference_rs->pager->last_page;
    $response->{records} = $reference_rs->pager->total_entries;
    my @rows; 
    while (my $reference = $reference_rs->next) {
        my $row->{id} = $reference->id;
        $row->{cell} = [
            $reference->reference && $reference->reference->id || '',
            $reference->citation,
        ];
        push @rows, $row;
    }
    $response->{rows} = \@rows;
    
    $c->stash(
        %$response,
        current_view => 'JSON'
    );
}    


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

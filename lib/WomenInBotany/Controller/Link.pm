package WomenInBotany::Controller::Link;
use Moose;
use namespace::autoclean;

# ABSTRACT: Controller for listening and editing web links of botanists

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Link - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub links : Chained('/botanist/botanist') PathPart('links') CaptureArgs(0) {
    my ($self, $c) = @_;
}

sub change : Chained('links') Args(0) {
    my ($self, $c) = @_;
    
    $c->log->debug( 'Bin in link/change' );
    if ($c->req->params->{oper} eq 'edit') {
        $c->forward('edit');
    }
    $c->stash(
        current_view => 'JSON'
    );
}

sub edit : Private {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    my $source = $c->model('WomenInBotanyDB::BotanistLink')->result_source;
    
    my %columns_map;
    undef @columns_map{$source->columns};
    my @columns =  grep { exists $columns_map{$_} } keys %{$c->req->params};
   
    my $data;
    @{$data}{@columns} = @{$c->req->params}{@columns};
    $data->{link_id}   = undef if $data->{link_id}   == 0;
    $data->{last_seen} = undef if $data->{last_seen} eq '';
        
    my $link = $botanist->botanists_links->find( $c->req->params->{id} );
    $link->update($data);
}

sub json : Chained('links') PathPart('json') Args(0) {
    my ($self, $c) = @_;
    
    my $data = $c->req->params;
    
    my $page = $data->{page} || 1;
    my $entries_per_page = $data->{rows} || 10;
    my $sidx = $data->{sidx} || 'id';
    my $sord = $data->{sord} || 'asc';

    my $botanist = $c->stash->{botanist};

    my $link_rs = $botanist->botanists_links->search(
        undef,
        {
            page => $page,
            rows => $entries_per_page,
            order_by => {"-$sord" => $sidx}, 
        }
    );

    my $response;
    $response->{page} = $page;
    $response->{total} = $link_rs->pager->last_page;
    $response->{records} = $link_rs->pager->total_entries;
    my @rows; 
    while (my $link = $link_rs->next) {
        my $row->{id} = $link->id;
        $row->{cell} = [
            $link->link && $link->link->id || '',
            $link->uri,
            $link->last_seen && $link->last_seen->strftime('%d.%m.%Y') || '',
            
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

package WomenInBotany::Controller::Link;
use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Link;

# ABSTRACT: Controller for listing and editing link entries

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Link - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub links : Chained('/base') PathPart('link') CaptureArgs(0) {
    my ($self, $c) = @_;
    
    $c->stash->{links} = $c->model('WomenInBotanyDB::Link');
}

sub list : Chained('links') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        json_url => $c->uri_for_action('link/json'),
        template => 'link/list.tt',
    ); 
}

sub json : Chained('links') PathPart('json') Args(0) {
    my ($self, $c) = @_;
    
    my $data = $c->req->params;
    
    my $page = $data->{page} || 1;
    my $entries_per_page = $data->{rows} || 10;
    my $sidx = $data->{sidx} || 'host';
    my $sord = $data->{sord} || 'asc';

    my $links_rs = $c->stash->{links};
    $links_rs = $links_rs->search(
        {},
        {
            page => $page,
            rows => $entries_per_page,
            order_by => {"-$sord" => $sidx}, 
        }
    );

    my $response;
    $response->{page} = $page;
    $response->{total} = $links_rs->pager->last_page;
    $response->{records} = $links_rs->pager->total_entries;
    my @rows; 
    while (my $link = $links_rs->next) {
        my $row->{id} = $link->id;
        $row->{cell} = [
            $link->id,
            $link->host,
            $link->title,
        ];
        push @rows, $row;
    }
    $response->{rows} = \@rows;    

    $c->log->debug('Records: ' . $response->{records});
    
    $c->stash(
        %$response,
        current_view => 'JSON'
    );    
}

sub link : Chained('links') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    my $link = $c->stash->{link} = $c->stash->{links}->find($id)
        || $c->detach('not_found');
}

sub edit : Chained('link') {
    my ($self, $c) = @_;
    $c->forward('save');
}

# both adding and editing happens here
# no need to duplicate functionality
sub save : Private {
    my ($self, $c) = @_;

    my $link = $c->stash->{link}
        || $c->model('WomenInBotanyDB::Link')->new_result({});
    
    my $form = WomenInBotany::Form::Link->new();
    $c->stash( template => 'link/edit.tt', form => $form );
    $form->process(item => $link, params => $c->req->params );
    return unless $form->validated;

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/link/list'));    
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

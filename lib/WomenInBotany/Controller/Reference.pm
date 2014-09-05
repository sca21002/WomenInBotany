package WomenInBotany::Controller::Reference;

# ABSTRACT: Controller for listing and editing reference entries

use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Reference;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Reference - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 references

=cut

sub references : Chained('/base') PathPart('reference') CaptureArgs(0) {
    my ($self, $c) = @_;
    
    $c->stash->{references} = $c->model('WomenInBotanyDB::Reference');
}

sub list : Chained('references') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        json_url => $c->uri_for_action('reference/json'),
        template => 'reference/list.tt',
    ); 
}

sub json : Chained('references') PathPart('json') Args(0) {
    my ($self, $c) = @_;
    
    my $data = $c->req->params;
    
    my $page = $data->{page} || 1;
    my $entries_per_page = $data->{rows} || 10;
    my $sidx = $data->{sidx} || 'short_title';
    my $sord = $data->{sord} || 'asc';

    my $references_rs = $c->stash->{references};
    $references_rs = $references_rs->search(
        {},
        {
            page => $page,
            rows => $entries_per_page,
            order_by => {"-$sord" => $sidx}, 
        }
    );

    my $response;
    $response->{page} = $page;
    $response->{total} = $references_rs->pager->last_page;
    $response->{records} = $references_rs->pager->total_entries;
    my @rows; 
    while (my $reference = $references_rs->next) {
        my $row->{id} = $reference->id;
        $row->{cell} = [
            $reference->id,
            $reference->short_title,
            $reference->title,
        ];
        push @rows, $row;
    }
    $response->{rows} = \@rows;    

    $c->stash(
        %$response,
        current_view => 'JSON'
    );    
}

sub reference : Chained('references') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    my $reference = $c->stash->{reference} = $c->stash->{references}->find($id)
        || $c->detach('not_found');
}

sub edit : Chained('reference') {
    my ($self, $c) = @_;
    $c->forward('save');
}

# both adding and editing happens here
# no need to duplicate functionality
sub save : Private {
    my ($self, $c) = @_;

    my $reference = $c->stash->{reference}
        || $c->model('WomenInBotanyDB::Reference')->new_result({});
    
    my $form = WomenInBotany::Form::Reference->new();
    $c->stash( template => 'reference/edit.tt', form => $form );
    $form->process(item => $reference, params => $c->req->params );
    return unless $form->validated;

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/reference/list'));    
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

package WomenInBotany::Controller::Botanist;
use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Botanist;
use Devel::Dwarn;

# ABSTRACT: Controller for listing and editing biographic entries

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Botanist - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub botanists : Chained('/base') PathPart('botanist') CaptureArgs(0) {
    my ($self, $c) = @_;
    
    $c->stash->{botanists} = $c->model('WomenInBotanyDB::Botanist');
}

sub list : Chained('botanists') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        json_url => $c->uri_for_action('botanist/json'),
        template => 'botanist/list.tt',
    ); 
}

sub json : Chained('botanists') PathPart('json') Args(0) {
    my ($self, $c) = @_;
    
    my $data = $c->req->params;
    
    my $page = $data->{page} || 1;
    my $entries_per_page = $data->{rows} || 10;
    my $sidx = $data->{sidx} || 'id';
    my $sord = $data->{sord} || 'asc';

    my $botanists_rs = $c->stash->{botanists};
    $botanists_rs = $botanists_rs->search(
        {},
        {
            page => $page,
            rows => $entries_per_page,
            order_by => {"-$sord" => $sidx}, 
        }
    );

    my $response;
    $response->{page} = $page;
    $response->{total} = $botanists_rs->pager->last_page;
    $response->{records} = $botanists_rs->pager->total_entries;
    my @rows; 
    while (my $botanist = $botanists_rs->next) {
        my $row->{id} = $botanist->id;
        $row->{cell} = [
            $botanist->id,
            $botanist->familyname,
            $botanist->firstname,
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

sub botanist : Chained('botanists') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    my $order = $c->stash->{botanist} = $c->stash->{botanists}->find($id)
        || $c->detach('not_found');
}

sub edit : Chained('botanist') {
    my ($self, $c) = @_;
    $c->forward('save');
}

# both adding and editing happens here
# no need to duplicate functionality
sub save : Private {
    my ($self, $c) = @_;

    my $botanist = $c->stash->{botanist}
        || $c->model('WomenInBotanyDB::Botanist')->new_result({});

    $c->stash->{references} = [
        map
        {
            {   $_->get_inflated_columns,
                $_->reference ? $_->reference->get_inflated_columns : (),
            }
        }
        $botanist->botanists_references
    ];
    
    $c->stash->{links} = [
        map
        {
            {   $_->get_inflated_columns,
                $_->link ? $_->link->get_inflated_columns : (),
            }
        }
        $botanist->botanists_links
    ];    
       
    my $form = WomenInBotany::Form::Botanist->new();
    $c->stash( template => 'botanist/edit.tt', form => $form );
    $form->process(item => $botanist, params => $c->req->params );
    return unless $form->validated;

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/botanist/list'));
}



=head1 AUTHOR

Atacama Developer,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

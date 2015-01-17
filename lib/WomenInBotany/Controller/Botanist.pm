package WomenInBotany::Controller::Botanist;

# ABSTRACT: Controller for listing and editing biographic entries

use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Botanist;
use Text::MultiMarkdown;
use JSON;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Botanist - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

has 'tmm' => (
    is => 'ro',          
    isa => 'Text::MultiMarkdown',
    lazy => 1,
    builder => '_build_tmm',
    handles => [qw(markdown)],
);

sub _build_tmm {
    Text::MultiMarkdown->new(
        markdown_in_html_blocks => 0,   # Allow Markdown syntax within HTML
                                        # blocks.
        use_metadata => 0,              # Remove MultiMarkdown behavior change
                                        # to make the top of the document
                                        # metadata.
        heading_ids => 0,               # Remove MultiMarkdown behavior change
                                        # in <hX> tags.
        img_ids     => 0,               # Remove MultiMarkdown behavior change
                                        # in <img> tags. 
    );    
}

sub botanists : Chained('/base') PathPart('botanist') CaptureArgs(0) {
    my ($self, $c) = @_;
    
    $c->stash->{botanists} = $c->model('WomenInBotanyDB::Botanist');
}

sub list : Chained('botanists') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        status => [ 
            $c->model('WomenInBotanyDB::Status')->search(
                { active => 1 },
                { order_by => 'sort' },
            )->all 
        ],
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

    my $filters = $data->{filters};
    $filters = from_json $filters if $filters; 

    my $botanists_rs = $c->stash->{botanists}->filter($filters);
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
            $botanist->status->name,
        ];
        push @rows, $row;
    }
    $response->{rows} = \@rows;    

    $c->stash(
        %$response,
        current_view => 'JSON'
    );    
}

sub botanist : Chained('botanists') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    my $botanist = $c->stash->{botanist} = $c->stash->{botanists}->find($id)
        || $c->detach('/not_found');
}

sub add : Chained('botanists') PathPart('add') Args(0) {
    my ($self, $c, $id) = @_;

    $c->stash->{botanist}
        = $c->model('WomenInBotanyDB::Botanist')->create({status_id => 1});
    $c->forward('save');
}


sub edit : Chained('botanist') {
    my ($self, $c) = @_;
    $c->forward('nav') if $c->req->params->{nav};
    $c->forward('save'); 
}

sub nav : Private {
    my ($self, $c) = @_;
    
    my ($filters, $search, $sidx, $sord)                    # hash-slice
        = @{$c->session->{botanist}{list}}{ qw(filters search sidx sord) };
    $filters = from_json $filters if $filters;
    $sidx ||= 'id';
    $sord ||= 'asc';
    
    my $botanists_rs = $c->stash->{botanists};
    my $botanist     = $c->stash->{botanist};
    my $nav = $c->req->params->{nav};
    my $resp = $c->response;
    my $attrib = { filters => $filters, sidx => $sidx, sord => $sord }; 
    
    if (my $nav = $botanists_rs->nav($nav, $botanist, $attrib)) {
        $resp->redirect( $c->uri_for_action('/botanist/edit', [$nav->id] ));
    } else { $c->detach('not_found') }
}

# both adding and editing happens here
# no need to duplicate functionality
sub save : Private {
    my ($self, $c) = @_;

    my $can_update = $c->check_any_user_role( qw(admin editor) ) ? 1 : 0;

    my $botanist = $c->stash->{botanist};
 
    $c->stash->{json_url_references}
        = $c->uri_for_action('botanistreference/json', [$botanist->id]),
    $c->stash->{json_url_links}
        = $c->uri_for_action('botanistlink/json', [$botanist->id]);
    
    $c->stash->{editoptions_reference} = join(
        ';',
        '0:(leer)',
        map {
            sprintf( 
                "%s:%s",
                $_->{id},
                $_->{short_title} =~ s/:|;|"|\n/ /rg
            )
        }
        $c->model('WomenInBotanyDB::Reference')->search(
            undef,
            {
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
                order_by => { -asc => 'short_title' },
            }
        )->all
    );
    
    $c->stash->{edit_reference_url}
        = $c->uri_for_action('/botanistreference/change', [ $botanist->id ]);
    $c->stash->{edit_link_url}
        = $c->uri_for_action('/botanistlink/change',      [ $botanist->id ]);
    $c->stash->{image} = $self->image_path($c);
    my $form = WomenInBotany::Form::Botanist->new();
    $c->stash( template => 'botanist/edit.tt', form => $form );
    $form->process(
        item => $botanist, 
        params => $c->req->params , 
        no_update => !$can_update, 
    );
    return unless $form->validated;
    if ($can_update) {
        $c->stash(message => 'Changes saved');
    } else {
        $c->stash(error => 'Editing not allowed for your role');
    }
    # Redirect the user back to the list page
    # $c->response->redirect($c->uri_for_action('/botanist/list'));
}

sub show : Chained('botanist') {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    my %data;
    
    $data{full_name}         = $botanist->full_name;
    $data{name_and_function} = $botanist->name_and_function;
    $data{portrait}          = $self->image_path($c);
    $data{botanists_references}
        = $botanist->botanists_references->as_aref_of_href;
    $data{botanists_links}
        = $botanist->botanists_links->as_aref_of_href;
    foreach my $text ( qw(
        marital_status
        professional_experience
        peculiar_fields_of_activity
        context_honors
        education
        work
    )) {
        $data{$text} = $self->markdown( $botanist->$text );
    }
    $c->stash(
        %data,
        current_view => 'User',     
        template     => 'botanist/show.tt',
    ); 
}

sub image_path {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    return unless $botanist && $botanist->images->first;  
    return $c->uri_for(
        '/'
        . $botanist
            ->images
            ->first
            ->file
            ->relative( $c->path_to('root') )
            ->as_foreign('Unix')
    );
}

sub denied : Private {
    my ($self, $c) = @_;

    $c->res->status('403');
    $c->res->body('Denied!');
}

=head1 AUTHOR

Atacama Developer,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

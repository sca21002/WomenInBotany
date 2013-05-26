package WomenInBotany::Controller::Botanist;
use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Botanist;
use Devel::Dwarn;
use Data::Dumper;

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

sub goto : Chained('botanists') PathPart('goto') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{index} = $c->req->params->{index};
    $c->forward('edit_from_list');
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

    my $botanist = $c->stash->{botanist} = $c->stash->{botanists}->find($id)
        || $c->detach('not_found');
}

sub edit : Chained('botanist') {
    my ($self, $c) = @_;
    $c->forward('save');
}

sub edit_from_list : Chained('botanist') {
    my ($self, $c) = @_;
    $c->log->debug('Bin in edit_from_list');
    
    my ($filters, $search, $sidx, $sord)                    # hash-slice
        = @{$c->session->{botanist}{list}}{ qw(filters search sidx sord) };
    $filters = from_json $filters if $filters;
    $sidx ||= 'id';
    $sord ||= 'asc';

    my $botanists_rs = $c->stash->{botanists};
    $botanists_rs = $botanists_rs->filter($filters);
    $botanists_rs = $botanists_rs->search(
        $search,
        {
           order_by => {"-$sord" => $sidx}, 
        }
    );
    my $botanists_count = $botanists_rs->count;
    my $index = $c->stash->{index};
    if ($index) {
        $index += 0;          
        $index = 1 if $index < 1;
        $index = $botanists_count if $index > $botanists_count;
        my($botanist) = $botanists_rs->search({})->slice($index-1, $index-1);
        $c->stash->{botanist} = $botanist;
    }
    my $id = $c->stash->{botanist}->id;

    my $first = $botanists_rs->search(
        {},
        {
           order_by => {"-$sord" => $sidx}, 
        }
    )->single;       
        
    my $prev_rs =  $botanists_rs->search(
        {
            'me.id' => { '<', $id } 
        },
        {
           order_by => { '-' . ($sord eq 'desc' ? 'asc' : 'desc') => $sidx}, 
        }
    );
    my $prev = $prev_rs->single;
    $index ||= $prev eq $id ? 1 : $prev_rs->count +1;
        
    my $next = $botanists_rs->search(
        {
            'me.id' => { '>', $id } 
        },
        {
           order_by => {"-$sord" => $sidx}, 
        }
    )->single;
    my $last = $botanists_rs->search(
        {},
        {
           order_by => { '-' . ($sord eq 'desc' ? 'asc' : 'desc') => $sidx}, 
       }
    )->single;
    
    $c->log->debug('id: ' . $id);
    $c->log->debug('index: ' . $index);
    $c->log->debug('First: ' . $first->id) if $first;
    $c->log->debug('Prev: ' . $prev->id) if $prev;
    $c->log->debug('Next: ' . $next->id) if $next;
    $c->log->debug('Last: ' . $last->id) if $last;
    $c->stash(
        botanists_count => $botanists_count,
        index => $index,
        first => $first && $first->id ne $id && $first->id || '',
        prev  => $prev  && $prev->id  || '',
        next  => $next  && $next->id  || '',
        last  => $last  && $last->id ne $id  && $last->id || '',
    );
    $c->forward('save');
}

# both adding and editing happens here
# no need to duplicate functionality
sub save : Private {
    my ($self, $c) = @_;

    my $botanist = $c->stash->{botanist}
        || $c->model('WomenInBotanyDB::Botanist')->new_result({});
  
  
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
    $form->process(item => $botanist, params => $c->req->params );
    return unless $form->validated;

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/botanist/list'));
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
    $c->log->debug(Dumper \%data);
    $c->stash(
        %data,
        current_view => 'User',     
        template     => 'botanist/show.tt',
    ); 
}

sub image_path {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    return unless $botanist->images->first;  
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

=head1 AUTHOR

Atacama Developer,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

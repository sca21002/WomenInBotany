package WomenInBotany::Controller::BotanistLink;

# ABSTRACT: Controller for listening and editing web links of botanists

use Moose;
use namespace::autoclean;
use URI;
use DateTime::Format::Strptime;


BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::BotanistLink - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub botanists_links : Chained('/botanist/botanist') PathPart('links') CaptureArgs(0) {
    my ($self, $c) = @_;
}

sub change : Chained('botanists_links') Args(0) {
    my ($self, $c) = @_;
    
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

    my $strp = new DateTime::Format::Strptime(
        pattern     => '%d.%m.%Y',
        locale      => 'de_DE',
        on_error    => 'croak',
    );

    my $data;
    @{$data}{@columns} = @{$c->req->params}{@columns};
    $data->{last_seen} = undef if $data->{last_seen} eq '';
    $data->{last_seen} = $strp->parse_datetime( $data->{last_seen} )
        if $data->{last_seen};
    
    my $botanists_links = $botanist->botanists_links->find( $data->{id} );
    if (  my $uri = URI->new( $data->{uri} ) ) {
        
        my $link_rs = $c->model('WomenInBotanyDB::Link');
        
        if ( my $link = $link_rs->find( {host => $uri->host} ) ) {
            $botanists_links->link($link);    
        } else {
            $botanists_links->update_or_create_related(
                'link',
                { host => $uri->host }
            );
        }
    }
    $botanists_links->update($data);
}

sub json : Chained('botanists_links') PathPart('json') Args(0) {
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
            join => 'link',
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
            $link->link && $link->link->host || '',
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

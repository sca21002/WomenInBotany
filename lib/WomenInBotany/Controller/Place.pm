package WomenInBotany::Controller::Place;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Place - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 places

=cut

sub places : Chained('/base') PathPart('places') Args(0) { 
    my ($self, $c) = @_;


    my $bbox = $c->req->params->{bbox};

    $c->log->debug('BBox: ' . $bbox);

    my ($xmin, $ymin, $xmax, $ymax) = split(',', $bbox);

    $c->log->debug('Koord.: ' . join(' ',$xmin, $ymin, $xmax, $ymax));

    #my $xmin = 8.98;
    #my $ymin = 47.27;
    #my $xmax = 13.83;
    #my $ymax = 50.56;

    my $rs = $c->model('WomenInBotanyDB::Place')->within_bbox($xmin, $ymin, $xmax, $ymax);

    my @rows;
    while (my $row = $rs->next) {
	my $href = { $row->get_columns() };
        my @coords = $href->{coordinates} =~ /POINT\(([\d.]+)\s([\d.]+)\)/;
        $href->{coordinates} = [ @coords ];
        push @rows, $href; 
    }    
 
    my $response->{places} = \@rows;
    $response->{places_total} = scalar @rows;

    $c->stash(
        %$response,
        current_view => 'JSON'
    );    
}


=encoding utf8

=head1 AUTHOR

blo development user,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

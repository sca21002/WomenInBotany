package WomenInBotany::Controller::Upload;
use Moose;
use namespace::autoclean;
use WomenInBotany::Form::Upload;

# ABSTRACT: Controller for uploading files

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WomenInBotany::Controller::Upload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub upload : Chained('/botanist/botanist') PathPart('upload') Args(0) {
    my ($self, $c) = @_;
    
    my $botanist = $c->stash->{botanist};
    my $image = $c->stash->{image}
        || $c->model('WomenInBotanyDB::Image')->new_result(
                {
                    botanist_id => $botanist->id,
                }
           );
    
    my $form = WomenInBotany::Form::Upload->new;
    $c->stash( form => $form );
    my @params;
    if ($c->req->method eq 'POST')  {
        @params = ( file => $c->req->upload('file') );
    }
    $form->process( item => $image, params => { @params } );
    return unless ( $form->validated );
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

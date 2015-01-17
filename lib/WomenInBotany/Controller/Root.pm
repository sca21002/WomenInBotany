package WomenInBotany::Controller::Root;

# ABSTRACT: Controller to run before all others

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

WomenInBotany::Controller::Root - Root Controller for WomenInBotany

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 base

The base page (/)

Base page is chained from login/required to allow only logged-in users.

=cut

sub base : Chained('/login/required') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
   
    my $username = 'anonymous';
    $username = $c->user->username if $c->user_exists;

    my $roles_rs;
    $roles_rs = $c->model('WomenInBotanyDB::User')->search({
        username  => $username,
    })->single;
    my @roles = ('readonly');
    @roles = map { $_->name } $roles_rs->roles if $roles_rs; 
    $c->user->set_roles(\@roles);

    $c->log->debug( 'User: ' . $username);
    $c->log->debug( 'Roles: ' . join(' ',$c->user->roles));

    $c->stash(
        roles => [ @roles ],
        user => $username,
    );    
}

=head2 not_found

Standard 404 error page

=cut

sub not_found: Private {
         my ( $self, $c ) = @_;

    $c->response->body( 'Page not found' ); 
    $c->response->status(404);  
}   

=head2 default

Redirect to list

=cut

sub default : Path {
    my ( $self, $c ) = @_;
    
    $c->res->redirect( $c->uri_for_action('/botanist/list') );
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Albert Schröder <albert.schroeder@ur.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

package WomenInBotany;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# ABSTRACT: WomeninBotany is a Web Application of a bibliographic database

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Unicode::Encoding
    Static::Simple
    +CatalystX::SimpleLogin
    Authentication
    Session
    Session::State::Cookie
    Session::Store::FastMmap
    StatusMessage
/;

extends 'Catalyst';

our $VERSION = '0.04';

has 'stage' => (
    is => 'rw',
    default => 'productive',
); 

has 'stage' => (
    is => 'rw',
    default => 'productive',
); 

# Configure the application.
#
# Note that settings in womeninbotany.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'WomenInBotany',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    default_view => 'HTML',
    authentication => {
        default_realm => 'users',
        realms        => {
            users => {
                credential => {
                    class          => 'Password',
                    password_field => 'password',
                    password_type  => 'self_check'
                },
                store => {
                    class         => 'DBIx::Class',
                    user_model    => 'WomenInBotanyDB::User',
                }
            }
        },
    },
    'Controller::Login' => {
        traits => ['-RenderAsTTTemplate'],
        login_form_args => {
               authenticate_username_field_name => 'username',
               authenticate_password_field_name => 'password',
        },
    },
);



# Start the application
__PACKAGE__->setup();


=head1 NAME

WomenInBotany - Catalyst based application

=head1 SYNOPSIS

    script/womeninbotany_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<WomenInBotany::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Albert Schröder <albert.schroeder@ur.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

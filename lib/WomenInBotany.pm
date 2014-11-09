package WomenInBotany;

# ABSTRACT: WomeninBotany is a Web Application of a bibliographic database

use Moose;
use MooseX::AttributeShortcuts;
use WomenInBotany::Types qw(Str);
use namespace::autoclean;
use English qw( -no_match_vars ) ;  # Avoids regex performance penalty
use CPAN::Changes;
use DateTime::Format::W3CDTF;
use Path::Tiny;

use Catalyst::Runtime 5.80;
    with 'CatalystX::DebugFilter';

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
    Static::Simple
    +CatalystX::SimpleLogin
    Authentication
    Authorization::Roles
    Session
    Session::State::Cookie
    Session::Store::FastMmap
    StatusMessage
/;

extends 'Catalyst';

has 'last_modified' => ( is => 'lazy', isa => Str );

has 'stage' => (
    is => 'rw',
    default => 'productive',
); 

sub system_user { scalar getpwuid( $EFFECTIVE_USER_ID ) }

sub _build_last_modified {

    my $changes = CPAN::Changes->load( path(__PACKAGE__->path_to('Changes') ) );
    my $date = ($changes->releases)[-1]->date;
    my $dt = DateTime::Format::W3CDTF->new()->parse_datetime( $date );
    return $dt->strftime('%d.%m.%Y %H:%M')
}

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
    # Plugin Unicode::Encode is auto-applied, config this plugin for UTF-8
    encoding => 'UTF-8',
    default_view => 'Admin',
    'Model::WomenInBotanyDB' => {
        image_path => __PACKAGE__->path_to(
            qw( root static images womeninbotany)
        ),
    },
    'Plugin::Session' => {
        storage => path(
            '/tmp', 'womeninbotany', __PACKAGE__->system_user, 'session'
        )->stringify
    },    
    
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

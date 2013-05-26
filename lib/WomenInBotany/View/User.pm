package WomenInBotany::View::User;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

# ABSTRACT: TT View for WomenInBotany in user mode


__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    INCLUDE_PATH => [
        WomenInBotany->path_to( 'root', 'base' ),
    ],
    ENCODING     => 'utf-8',
    WRAPPER            => 'site/user/wrapper.tt',
);

=head1 NAME

WomenInBotany::View::Admin - TT View for WomenInBotany in user mode

=head1 DESCRIPTION

TT View for WomenInBotany.

=head1 SEE ALSO

L<WomenInBotany>

=head1 AUTHOR

Atacama Developer,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

package WomenInBotany::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

# ABSTRACT: Catalyst JSON View

__PACKAGE__->config({
    expose_stash => [ qw(
        page total records rows 
    ) ]
});

=head1 NAME

WomenInBotany::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<WomenInBotany>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

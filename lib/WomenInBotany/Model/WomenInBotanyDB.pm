package WomenInBotany::Model::WomenInBotanyDB;

# ABSTRACT: Catalyst DBIC Schema Model

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'WomenInBotany::Schema',
);

=head1 NAME

WomenInBotany::Model::WomenInBotanyDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<WomenInBotany>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<WomenInBotany::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.6

=head1 AUTHOR

Atacama Developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

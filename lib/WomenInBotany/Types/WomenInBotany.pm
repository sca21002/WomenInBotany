package WomenInBotany::Types::WomenInBotany;

# ABSTRACT: Types library for project specific types 

use MooseX::Types -declare => [ qw(
    DBIC_Schema
) ];

class_type DBIC_Schema, { class => 'DBIx::Class::Schema' };

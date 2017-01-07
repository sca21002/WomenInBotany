package WomenInBotany::Types::WomenInBotany;

# ABSTRACT: Types library for project specific types 

use MooseX::Types -declare => [ qw(
    DateTimeFormatStrptime
    DBIC_Schema
) ];

use MooseX::Types::Moose qw(
    Str
);

class_type DateTimeFormatStrptime, { class => 'DateTime::Format::Strptime' };

class_type DBIC_Schema, { class => 'DBIx::Class::Schema' };


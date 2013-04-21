package WomenInBotany::Types;

# ABSTRACT: Combining Class for types libraries

use base 'MooseX::Types::Combine';                         # why not extends ?? 
 
__PACKAGE__->provide_types_from( qw(
    MooseX::Types::Path::Class
    MooseX::Types::Moose
    WomenInBotany::Types::WomenInBotany
));

1;

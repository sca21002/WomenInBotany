package WomenInBotany::Schema::ResultSet::BotanistLink;
 
use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';

# ABSTRACT: WomenInBotany::Schema::Result::BotanistLink
 
sub BUILDARGS { $_[2] }
 
sub as_aref_of_href {
    my $self = shift;
    
    return [ $self->search(
        {},
        {
            prefetch => 'link',
            result_class => 'DBIx::Class::ResultClass::HashRefInflator'
        },         
    )->all ];
}
 
__PACKAGE__->meta->make_immutable;
 
1;

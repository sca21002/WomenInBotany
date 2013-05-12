package WomenInBotany::Schema::ResultSet::BotanistReference;
 
use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::InflateColumn::FS::ResultSet';

# ABSTRACT: WomenInBotany::Schema::Result::BotanistReference
 
sub BUILDARGS { $_[2] }
 
sub as_aref_of_href {
    my $self = shift;
    
    return [ $self->search(
        {},
        {
            prefetch => 'reference',
            result_class => 'DBIx::Class::ResultClass::HashRefInflator'
        },         
    )->all ];
}
 
__PACKAGE__->meta->make_immutable;
 
1;

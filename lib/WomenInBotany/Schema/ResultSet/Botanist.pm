package WomenInBotany::Schema::ResultSet::Botanist;
 
use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::InflateColumn::FS::ResultSet';

# ABSTRACT: WomenInBotany::Schema::ResultSet::Botanist
 
sub BUILDARGS { $_[2] }
 
sub as_href {
    my $self = shift;
    
    return $self->search(
        {},
        {
            prefetch => {botanists_references => 'reference'},
            result_class => 'DBIx::Class::ResultClass::HashRefInflator'
        },         
    );
}

sub filter {
    my ($self, $filters) = @_;
    
    return $self;
}
 
__PACKAGE__->meta->make_immutable;
 
1;

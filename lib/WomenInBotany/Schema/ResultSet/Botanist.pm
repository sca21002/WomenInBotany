package WomenInBotany::Schema::ResultSet::Botanist;
 
use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::InflateColumn::FS::ResultSet';
    with 'WomenInBotany::SchemaRole::ResultSet::Navigate';
    
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

    my @and_cond;
    my @join_attr;

    foreach my $rule ( @{ $filters->{rules} } ) {
        my $data = $rule->{data};
        if ($rule->{field} eq 'id') {
            push @and_cond, { 'me.id' => $data } ;
        }
        elsif ($rule->{field} eq 'familyname') {
            push @and_cond, { 'me.familyname' => { like => "%$data%" } };
        }
        elsif ($rule->{field} eq 'firstname') {
            push @and_cond, { 'me.firstname' => { like => "%$data%" } };
        }
        elsif ($rule->{field} eq 'status_id') {
            push @and_cond, { 'me.status_id' => $data } ;
        }
    }

    return $self->search( { -and => \@and_cond }, { join => \@join_attr } );
}


__PACKAGE__->meta->make_immutable;
 
1;

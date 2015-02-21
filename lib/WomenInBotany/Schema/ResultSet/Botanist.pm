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



sub within_bbox {
    my $self = shift;

   my ($xmin, $ymin, $xmax,  $ymax) = @_; 
   my $srt  = 4326; 

   my $aref = [ 
	q{ST_MakeEnvelope(?, ?, ?, ?, ?)},
        $xmin, 
        $ymin, 
        $xmax, 
        $ymax, 
        $srt
   ];

    return $self->search(
        [ 	
             'bplace.geom' => { '&&' => \$aref},
             'dplace.geom' => { '&&' => \$aref},   
        ],
        {
             join => ['bplace', 'dplace' ],
             prefetch => { botanists_categories => 'category' },
             select => [ qw(
                 id
                 familyname 
                 firstname
                 birthdate
                 year_of_birth
                 birthplace
                 deathdate
                 year_of_death
                 deathplace
                 ),
                 \'ST_AsText(bplace.geom)',
                 \'ST_AsText(dplace.geom)',
             ],  
             as => [qw(
                 id
                 familyname 
                 firstname
                 birthdate
                 year_of_birth
                 birthplace
                 deathdate
                 year_of_death
                 deathplace
                 bplace
                 dplace
             )], 
        }
     ); 
}


sub count_of {
    my ($self, $column) = @_;

    return $self->search(
        { $column => { '!=' => undef } },
        {
            select => [
                $column,
                { count => $column }
            ],
            as     => [
                $column,
                'count',
            ],
            group_by => $column,
            order_by => $column,
        }
    );
}


__PACKAGE__->meta->make_immutable;
 
1;

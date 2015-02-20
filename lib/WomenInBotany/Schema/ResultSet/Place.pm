package WomenInBotany::Schema::ResultSet::Place;
 
use Moose;
use namespace::autoclean;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
    
# ABSTRACT: WomenInBotany::Schema::ResultSet::Place
 
sub BUILDARGS { $_[2] }
 
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
	{
             geom => { '&&' => \$aref},
        },
        {
             join => 'botanists',
             select => [ qw( 
                 me.id
                 botanists.id
                 botanists.familyname 
                 botanists.firstname
                 botanists.birthdate
                 botanists.birthplace
                 botanists.deathdate
                 botanists.deathplace
                 ),
                 \'ST_AsText(geom)',
             ],  
             as => [ qw(
                 place_id
                 botanist_id 
                 familyname
                 firstname
                 birthdate
                 birthplace
                 deathdate
                 deathplace
                 coordinates
             ) ], 
        }
     ); 
}

__PACKAGE__->meta->make_immutable;
 
1;

package WomenInBotany::Form::Botanist;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';
use namespace::autoclean;

# ABSTRACT: Form for editing biographic entries 

has '+item_class' => (default =>'Botanist');    # the DBIC source_name
 

has_field 'familyname' => (
    type => 'Text',
    label => 'Family name',
    size =>  60,
    required => 1,
); 

has_field 'birthname' => (
    type => 'Text',
    label => 'Name at birth',
    size =>  60,
);

has_field 'firstname' => (
    type => 'Text',
    label => 'First name',
    size =>  60,
);

has_field 'birthdate' => (
    type => 'Text',
    label => 'Birthdate',
    size =>  30,
);

has_field 'birthplace' => (
    type => 'Text',
    label => 'Birthplace',
    size =>  60,
);

has_field 'deathdate' => (
    type => 'Text',
    label => 'Deathdate',
    size =>  30,
);

has_field 'deathplace' => (
    type => 'Text',
    label => 'Deathplace',
    size =>  60,
);

has_field 'category' => (
    type => 'Text',
    label => 'Category',
    size =>  3,
);

has_field 'activity' => (
    type => 'TextArea',
    label => 'Activity',
    cols => 60,
    rows => 3,
);

has_field 'workplace' => (
    type => 'Text',
    label => 'Workplace',
    size =>  60,
);

has_field 'country' => (
    type => 'Text',
    label => 'Country',
    size =>  60,    
);

#has_field 'botanists_references' => ( type => 'Repeatable' );
#has_field 'botanists_references.id' => ( type => 'PrimaryKey' );
#has_field 'botanists_references.citation';

has_field 'submit' => ( type => 'Submit', value => 'Speichern' );

no HTML::FormHandler::Moose;
1;

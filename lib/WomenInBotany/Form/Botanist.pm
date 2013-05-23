package WomenInBotany::Form::Botanist;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';
use namespace::autoclean;

# ABSTRACT: Form for editing biographic entries 

# sub build_render_list {[ 'familyname', 'birthname' ]};

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

has_field 'activity_old' => (
    type => 'TextArea',
    label => 'Activity (old)',
    cols => 80,
    rows => 3,
    element_attr => { readonly => 1 },
);

has_field 'marital_status' => (
    type => 'TextArea',
    label => 'Marital status',
    cols => 80,
    rows => 1,
);

has_field 'field_of_activity' => (
    type => 'TextArea',
    label => 'Field of activity',
    cols => 80,
    rows => 2,
);

has_field 'context_honors' => (
    type => 'TextArea',
    label => 'Context/Honors',
    cols => 80,
    rows => 1,
);

has_field 'education' => (
    type => 'TextArea',
    label => 'Education',
    cols => 80,
    rows => 2,
);

has_field 'work' => (
    type => 'TextArea',
    label => 'Work',
    cols => 80,
    rows => 2,
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

has_field 'remarks' => (
    type => 'TextArea',
    label => 'Remarks',
    cols => 60,
    rows => 1,
);

has_field 'submit' => ( type => 'Submit', value => 'Speichern' );

has_block 'biography' => (
    tag => 'fieldset',
    render_list => [ qw(
        familyname  birthname   firstname   birthdate   birthplace
        deathdate   deathplace  category    workplace   country
        remarks     submit
    )],
);

has_block 'activity' => (
    tag => 'fieldset',
    render_list => [ qw(
        activity_old    education       field_of_activity   work
        context_honors  marital_status  remarks             submit
    )],
);

no HTML::FormHandler::Moose;
1;

package WomenInBotany::Form::Botanist;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';
use namespace::autoclean;

# ABSTRACT: Form for editing biographic entries 

# sub build_render_list {[ 'familyname', 'birthname' ]};

has '+item_class' => (default =>'Botanist');    # the DBIC source_name

has_field 'status' => ( 
    type => 'Select',
    lookup_options => 'status', 
    sort_column    => 'sort',
);

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

has_field 'year_of_birth' => (
    type => 'Text',
    lable => 'Year of birth',
    size => 40,
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

has_field 'year_of_death' => (
    type => 'Text',
    lable => 'Year of death',
    size => 40,
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

has_field 'gnd' => (
    type => 'Text',
    label => 'GND number',
    size =>  15,
);

has_field 'categories' => (
    type => 'Multiple',
    label => 'Category',
    widget => 'CheckboxGroup',
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
    render_filter => sub { shift },
);

has_field 'professional_experience' => (
    type => 'TextArea',
    label => 'Professional experience',
    cols => 80,
    rows => 2,
    render_filter => sub { shift },
);

has_field 'peculiar_fields_of_activity' => (
    type => 'TextArea',
    label => 'Peculiar fields of activity',
    cols => 80,
    rows => 2,
    render_filter => sub { shift },
);

has_field 'context_honors' => (
    type => 'TextArea',
    label => 'Context/Honors',
    cols => 80,
    rows => 1,
    render_filter => sub { shift },
);

has_field 'education' => (
    type => 'TextArea',
    label => 'Education',
    cols => 80,
    rows => 2,
    render_filter => sub { shift },
);

has_field 'work' => (
    type => 'TextArea',
    label => 'Work',
    cols => 80,
    rows => 2,
    render_filter => sub { shift }, 
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
    render_filter => sub { shift },
);

has_field 'notes' => (
    type => 'TextArea',
    label => 'Notes',
    cols => 60,
    rows => 1,
    render_filter => sub { shift },
);

has_field 'submit' => ( type => 'Submit', value => 'Speichern' );

has_block 'biography' => (
    tag => 'fieldset',
    render_list => [ qw(
        familyname  birthname       firstname   year_of_birth   birthdate
        birthplace  year_of_death   deathdate   deathplace      gnd         
        categories  workplace       country     submit
    )],
);

has_block 'activity' => (
    tag => 'fieldset',
    render_list => [ qw(
        activity_old    education       professional_experience 
        peculiar_fields_of_activity     work                    context_honors 
        marital_status  remarks         notes                   submit
    )],
);

no HTML::FormHandler::Moose;
1;

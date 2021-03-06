package WomenInBotany::Form::Reference;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';
use namespace::autoclean;

# ABSTRACT: Form for editing reference entries 

has '+item_class' => (default =>'Reference');    # the DBIC source_name
 

has_field 'short_title' => (
    type => 'Text',
    label => 'Short title',
    size =>  30,
    required => 1,
); 

has_field 'title' => (
    type => 'Text',
    label => 'Title',
    size =>  60,
);

has_field 'remarks' => (
    type => 'TextArea',
    label => 'Remarks',
    cols => 60,
    rows => 3,
);


has_field 'submit' => ( type => 'Submit', value => 'Speichern' );

no HTML::FormHandler::Moose;
1;

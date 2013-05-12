package WomenInBotany::Form::Upload;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::TraitFor::Model::DBIC';
use namespace::autoclean;

# ABSTRACT: Form for uploading files 

has '+item_class' => (default =>'Image');
has '+enctype' => ( default => 'multipart/form-data');
 
has_field 'file' => ( type => 'Upload', max_size => '2000000' );
has_field 'submit' => ( type => 'Submit', value => 'Upload' );

# after validation we want { file => $filehandle }
# instead of { file => $catalyst_request_upload }
  sub validate {
    my $self = shift;
    if (defined($self->field('file')->value)) {
        my $fh = $self->field('file')->value->fh;
        $self->field('file')->value($fh);
    }
}
  
before 'update_model' => sub {
    my $self = shift;
    my $item = $self->item;
    my $file = $self->params->{file};

    return unless($file); # file field in HFH is inactive    
    $item->basename($file->basename);
};  


no HTML::FormHandler::Moose;
1;

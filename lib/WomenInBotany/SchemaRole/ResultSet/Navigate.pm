package WomenInBotany::SchemaRole::ResultSet::Navigate;

# ABSTRACT: WomenInBotany::SchemaRole::ResultSet::Navigate

use Moose::Role;
use Safe::Isa;

sub nav {
    my ($self, $move, $row, $attrib) = @_;
    
    my $rs = $self->filter($attrib->{filter});    
    if    ($move eq 'first') { return $rs->first }
    elsif ($move eq 'next' ) { return $rs->seek_next($row, $attrib) || $row }
    elsif ($move eq 'prev' ) { return $rs->seek_prev($row, $attrib) || $row }
    elsif ($move eq 'last' ) { return $rs->seek_last($attrib) }
    else                     { return }
}

sub seek_next {
    my ($self, $row, $attrib) = @_;
    
    unless ( $row->$_isa('DBIx::Class::Row') ) { 
        $self->throw_exception(
            "First parameter of seek_next isn't a row object"
        );
    };

    my $sidx = $attrib->{sidx} || 'id';
    my $sord = $attrib->{sord} || 'asc';
    
    $self->search(
        {
            "me.$sidx" => { '>', $row->$sidx } 
        },                  
        {
               order_by => {"-$sord" => "me.$sidx"}, 
        }
    )->first;                  
}

sub seek_prev {
    my ($self, $row, $attrib) = @_;
    
    unless ( $row->$_isa('DBIx::Class::Row') ) { 
        $self->throw_exception(
            "First parameter of seek_prev isn't a row object"
        );
    };

    my $sidx = $attrib->{sidx} || 'id';
    my $sord = $attrib->{sord} || 'asc';
    
    $self->search(
        {
            "me.$sidx" => { '<', $row->$sidx } 
        },                  
        {
            order_by => {'-' . ($sord eq 'desc' ? 'asc':'desc') => "me.$sidx"}, 
        }
    )->first;
}
 
sub seek_last {
    my ($self, $attrib) = @_;

    my $sidx = $attrib->{sidx} || 'id';
    my $sord = $attrib->{sord} || 'asc'; 
   
    $self->search(
        {},
        {
            order_by => {'-' . ($sord eq 'desc' ? 'asc':'desc') => "me.$sidx"}, 
        }
    )->first;    
}

1;

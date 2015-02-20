use utf8;
package WomenInBotany::Schema::Result::Place;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::Place

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=item * L<DBIx::Class::InflateColumn::FS>

=back

=cut

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "TimeStamp",
  "PassphraseColumn",
  "InflateColumn::FS",
);

=head1 TABLE: C<places>

=cut

__PACKAGE__->table("places");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 lat

  data_type: 'double precision'
  is_nullable: 1

=head2 lon

  data_type: 'double precision'
  is_nullable: 1

=head2 json

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lat",
  { data_type => "double precision", is_nullable => 1 },
  "lon",
  { data_type => "double precision", is_nullable => 1 },
  "json",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2015-01-25 16:13:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2YgWTAvhf0qMmDKm/VyZMA

# ABSTRACT: WomenInBotany::Schema::Result::Place

__PACKAGE__->has_many( 
    botanists  => 'WomenInBotany::Schema::Result::Botanist',
    [
        {'foreign.birthplace_id' => 'self.id'},
        {'foreign.deathplace_id' => 'self.id'},
    ]
);

#__PACKAGE__->has_many( 
#    deathplaces => 'WomenInBotany::Schema::Result::Botanist',
#    {'foreign.deathplace_id' => 'self.id'}
#);

# seems like a strange hack, but it is my only idea to overcome problems with 
# defining a custom resultset in combination with InflateColumn::FS
# Error message was:
# DBIx::Class::Schema::load_namespaces(): We found ResultSet class
# 'WomenInBotany::Schema::ResultSet::Place' for 'Place', 
# but it seems that you had already set 'Place' to use
# 'DBIx::Class::InflateColumn::FS::ResultSet' instead 

sub table {
    my $self = shift;
 
    my $ret = $self->next::method(@_);
    if ( @_ && $self->result_source_instance->resultset_class
               ne 'WomenInBotany::Schema::ResultSet::Place' ) {
        $self->result_source_instance->resultset_class(
            'WomenInBotany::Schema::ResultSet::Place'
        );
    }
    return $ret;
}


__PACKAGE__->meta->make_immutable;
1;

use utf8;
package WomenInBotany::Schema::Result::Botanist;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::Botanist

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

=head1 TABLE: C<botanists>

=cut

__PACKAGE__->table("botanists");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 status_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gnd

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 familyname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 birthname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 firstname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 year_of_birth

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 birthdate

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 birthplace

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 birthplace_id

  data_type: 'integer'
  is_nullable: 1

=head2 year_of_death

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 deathdate

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 deathplace

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 deathplace_id

  data_type: 'integer'
  is_nullable: 1

=head2 activity_old

  data_type: 'text'
  is_nullable: 1

=head2 marital_status

  data_type: 'text'
  is_nullable: 1

=head2 professional_experience

  data_type: 'text'
  is_nullable: 1

=head2 peculiar_fields_of_activity

  data_type: 'text'
  is_nullable: 1

=head2 context_honors

  data_type: 'text'
  is_nullable: 1

=head2 education

  data_type: 'text'
  is_nullable: 1

=head2 work

  data_type: 'text'
  is_nullable: 1

=head2 workplace

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 remarks

  data_type: 'text'
  is_nullable: 1

=head2 notes

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "status_id",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 1 },
  "gnd",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "familyname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "year_of_birth",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthdate",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthplace_id",
  { data_type => "integer", is_nullable => 1 },
  "year_of_death",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "deathdate",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "deathplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "deathplace_id",
  { data_type => "integer", is_nullable => 1 },
  "activity_old",
  { data_type => "text", is_nullable => 1 },
  "marital_status",
  { data_type => "text", is_nullable => 1 },
  "professional_experience",
  { data_type => "text", is_nullable => 1 },
  "peculiar_fields_of_activity",
  { data_type => "text", is_nullable => 1 },
  "context_honors",
  { data_type => "text", is_nullable => 1 },
  "education",
  { data_type => "text", is_nullable => 1 },
  "work",
  { data_type => "text", is_nullable => 1 },
  "workplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "remarks",
  { data_type => "text", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2015-01-25 17:10:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ote6t/BFqFxhdfE1yxlrGw

# ABSTRACT: WomenInBotany::Schema::Result::Botanist

__PACKAGE__->belongs_to(
    status => 'WomenInBotany::Schema::Result::Status',
    {'foreign.status_id' => 'self.status_id' },
);

__PACKAGE__->belongs_to(
    bplace => 'WomenInBotany::Schema::Result::Place',
    {'foreign.id' => 'self.birthplace_id' },
    { join_type => 'left' }
);

__PACKAGE__->belongs_to(
    dplace => 'WomenInBotany::Schema::Result::Place',
    {'foreign.id' => 'self.deathplace_id' },
    { join_type => 'left' }
);

__PACKAGE__->has_many( 
    botanists_references => 'WomenInBotany::Schema::Result::BotanistReference',
    {'foreign.botanist_id' => 'self.id'},
);

__PACKAGE__->has_many( 
    botanists_links => 'WomenInBotany::Schema::Result::BotanistLink',
    {'foreign.botanist_id' => 'self.id'},
);

__PACKAGE__->has_many( 
    botanists_categories => 'WomenInBotany::Schema::Result::BotanistCategory',
    {'foreign.botanist_id' => 'self.id'},
);

__PACKAGE__->many_to_many( qw( references botanists_references reference ) );

__PACKAGE__->many_to_many( qw( links botanists_links link ) );

__PACKAGE__->many_to_many( qw( categories botanists_categories category ) );

__PACKAGE__->has_many( 
    images => 'WomenInBotany::Schema::Result::Image',
    {'foreign.botanist_id' => 'self.id'}
);

# seems like a strange hack, but it is my only idea to overcome problems with 
# defining a custom resultset in combination with InflateColumn::FS
# Error message was:
# DBIx::Class::Schema::load_namespaces(): We found ResultSet class
# 'WomenInBotany::Schema::ResultSet::Botanist' for 'Botanist', but it
# seems that you had already set 'Botanist' to use
# 'DBIx::Class::InflateColumn::FS::ResultSet' instead 

sub table {
    my $self = shift;
 
    my $ret = $self->next::method(@_);
    if ( @_ && $self->result_source_instance->resultset_class
               ne 'WomenInBotany::Schema::ResultSet::Botanist' ) {
        $self->result_source_instance
             ->resultset_class('WomenInBotany::Schema::ResultSet::Botanist');
    }
    return $ret;
}

sub full_name {
    my $self = shift;
    
    return join ' ', grep {$_ } $self->firstname, $self->familyname;
}

sub name_and_function {
    my $self = shift;
    
    my $n_and_f = $self->full_name;
    if ( $self->categories ) {
        $n_and_f = join(
            ', ',
            grep {$_} $n_and_f, join(' and ', map {$_->name} $self->categories)
        );    
    }    
    return $n_and_f;
}

__PACKAGE__->meta->make_immutable;
1;

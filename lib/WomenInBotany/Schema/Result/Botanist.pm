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

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<botanists>

=cut

__PACKAGE__->table("botanists");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

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

=head2 birthdate

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 birthplace

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

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 activity

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

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "familyname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthdate",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "birthplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "deathdate",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "deathplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "activity",
  { data_type => "text", is_nullable => 1 },
  "workplace",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "remarks",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-11 09:26:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EHG0E7gsL89BiEUb4Va7nA

# ABSTRACT: WomenInBotany::Schema::Result::Botanist

__PACKAGE__->has_many( 
    botanists_references => 'WomenInBotany::Schema::Result::BotanistReference',
    {'foreign.botanist_id' => 'self.id'}
);

__PACKAGE__->has_many( 
    botanists_links => 'WomenInBotany::Schema::Result::BotanistLink',
    {'foreign.botanist_id' => 'self.id'}
);

__PACKAGE__->many_to_many( qw( references botanists_references reference ) );

__PACKAGE__->many_to_many( qw( links botanists_links link ) );

__PACKAGE__->meta->make_immutable;
1;

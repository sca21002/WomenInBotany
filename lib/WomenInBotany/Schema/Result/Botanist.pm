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

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

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
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-04-06 17:49:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5IUhhEPWlESjdQCuTJc6gg

# ABSTRACT: WomenInBotany::Schema::Result::Botanist

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;

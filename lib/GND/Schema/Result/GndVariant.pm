use utf8;
package GND::Schema::Result::GndVariant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GND::Schema::Result::GndVariant

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<gnd_variant>

=cut

__PACKAGE__->table("gnd_variant");

=head1 ACCESSORS

=head2 gnd_nr

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 variantName

  accessor: 'variant_name'
  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "gnd_nr",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "variantName",
  {
    accessor => "variant_name",
    data_type => "varchar",
    is_nullable => 0,
    size => 255,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2016-11-04 14:40:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HaS3BjXQDINRdN5v8PGwnw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;

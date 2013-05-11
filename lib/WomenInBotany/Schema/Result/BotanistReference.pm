use utf8;
package WomenInBotany::Schema::Result::BotanistReference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::BotanistReference

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

=head1 TABLE: C<botanists_references>

=cut

__PACKAGE__->table("botanists_references");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 botanist_id

  data_type: 'integer'
  is_nullable: 1

=head2 reference_id

  data_type: 'integer'
  is_nullable: 1

=head2 citation

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "botanist_id",
  { data_type => "integer", is_nullable => 1 },
  "reference_id",
  { data_type => "integer", is_nullable => 1 },
  "citation",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-12 10:01:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bqRVxA0opqwjrQgIg8uAnw

# ABSTRACT: WomenInBotany::Schema::Result::BotanistReference

__PACKAGE__->belongs_to(
    botanist => 'WomenInBotany::Schema::Result::Botanist',
    { 'foreign.id' => 'self.botanist_id' }
);

__PACKAGE__->belongs_to(
    reference => 'WomenInBotany::Schema::Result::Reference',
    { 'foreign.id' => 'self.reference_id' }
);

__PACKAGE__->meta->make_immutable;
1;

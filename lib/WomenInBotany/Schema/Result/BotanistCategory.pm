use utf8;
package WomenInBotany::Schema::Result::BotanistCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::BotanistCategory

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

=head1 TABLE: C<botanists_categories>

=cut

__PACKAGE__->table("botanists_categories");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 botanist_id

  data_type: 'integer'
  is_nullable: 1

=head2 category_id

  data_type: 'char'
  is_nullable: 1
  size: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "botanist_id",
  { data_type => "integer", is_nullable => 1 },
  "category_id",
  { data_type => "char", is_nullable => 1, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-25 12:14:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oN/4Oyazc61Wp8cZAkvedQ

# ABSTRACT: WomenInBotany::Schema::Result::BotanistCategory

__PACKAGE__->belongs_to(
    botanist => 'WomenInBotany::Schema::Result::Botanist',
    { 'foreign.id' => 'self.botanist_id' }
);

__PACKAGE__->belongs_to(
    category => 'WomenInBotany::Schema::Result::Category',
    { 'foreign.id' => 'self.category_id' }
);

__PACKAGE__->meta->make_immutable;
1;

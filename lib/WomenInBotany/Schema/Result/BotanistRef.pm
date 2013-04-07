use utf8;
package WomenInBotany::Schema::Result::BotanistRef;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::BotanistRef

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

=head1 TABLE: C<botanists_refs>

=cut

__PACKAGE__->table("botanists_refs");

=head1 ACCESSORS

=head2 botanist_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 ref_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "botanist_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "ref_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</botanist_id>

=item * L</ref_id>

=back

=cut

__PACKAGE__->set_primary_key("botanist_id", "ref_id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-04-06 17:37:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IlxkBMYHzKqr1HHSeUNs5Q

# ABSTRACT: WomenInBotany::Schema::Result::BotanistRef

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;

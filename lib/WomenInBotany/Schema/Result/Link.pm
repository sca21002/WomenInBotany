use utf8;
package WomenInBotany::Schema::Result::Link;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::Link

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

=head1 TABLE: C<links>

=cut

__PACKAGE__->table("links");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 host

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "host",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<host>

=over 4

=item * L</host>

=back

=cut

__PACKAGE__->add_unique_constraint("host", ["host"]);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-03 17:34:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T1CywEWK2TpMYs1/mIEiWg

# ABSTRACT: WomenInBotany::Schema::Result::Ref

__PACKAGE__->add_unique_constraint(["host"]);

__PACKAGE__->has_many( 
    botanists_links => 'WomenInBotany::Schema::Result::BotanistLink',
    {'foreign.link_id' => 'self.id'}
);
    
__PACKAGE__->many_to_many( qw( botanists botanists_links botanist ) );


__PACKAGE__->meta->make_immutable;
1;

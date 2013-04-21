use utf8;
package WomenInBotany::Schema::Result::Reference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::Reference

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

=head1 TABLE: C<references>

=cut

__PACKAGE__->table("references");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-04-20 17:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g5iB43rvvF4MJgjZB0XCtA

# ABSTRACT: WomenInBotany::Schema::Result::Reference

__PACKAGE__->has_many( 
    botanists_references => 'WomenInBotany::Schema::Result::BotanistReference',
    {'foreign.reference_id' => 'self.id'}
);
    
__PACKAGE__->many_to_many( qw( botanists botanists_references botanist ) );

__PACKAGE__->meta->make_immutable;
1;

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


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-23 17:24:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tUZweygoOThXWbIpfWvPPw

# ABSTRACT: WomenInBotany::Schema::Result::Botanist

__PACKAGE__->has_many( 
    botanists_references => 'WomenInBotany::Schema::Result::BotanistReference',
    {'foreign.botanist_id' => 'self.id'}
);

__PACKAGE__->has_many( 
    botanists_links => 'WomenInBotany::Schema::Result::BotanistLink',
    {'foreign.botanist_id' => 'self.id'}
);

__PACKAGE__->has_many( 
    botanists_categories => 'WomenInBotany::Schema::Result::BotanistCategory',
    {'foreign.botanist_id' => 'self.id'}
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

__PACKAGE__->meta->make_immutable;
1;

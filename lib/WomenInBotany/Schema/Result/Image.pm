use utf8;
package WomenInBotany::Schema::Result::Image;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WomenInBotany::Schema::Result::Image

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

=head1 TABLE: C<images>

=cut

__PACKAGE__->table("images");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 botanist_id

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 basename

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "botanist_id",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "basename",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-18 14:28:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nR9MGY1sAFGo3+nLjs7f9w


__PACKAGE__->add_columns(
  '+file',
    {
        is_fs_column => 1,
        fs_column_path =>
            "C:\\Users\\sca21002\\Documents\\Perl\\WomenInBotany\\root\\static\\images\\womeninbotany",
        #   WomenInBotany->path_to(qw( root static images womeninbotany)),
        # we set this value in config in lib/WomanInBotany.pm
    },
);

sub fs_file_name {
    my ($self, $column, $column_info) = @_;
    return $self->basename;
}

sub _fs_column_dirs {
    #my ($self, $filename) = @_;
    my $self = shift;
 
    return $self->botanist_id;
}

__PACKAGE__->belongs_to(
    "botanist",
    "WomenInBotany::Schema::Result::Botanist",
    { "foreign.id" => "self.botanist_id" },
);


__PACKAGE__->meta->make_immutable;
1;

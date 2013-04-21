use utf8;
package WomenInBotany::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-04-20 17:51:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DUgamMv4pcbb4YnAaCNrWg

# ABSTRACT: WomenInBotany::Schema

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;

package WomenInBotany::LDAP;

# ABSTRACT: LDAP authentication

use parent Catalyst::Authentication::Store::LDAP;

use WomenInBotany::LDAP::Backend;

sub new {
    my ( $class, $config, $app ) = @_;
    
    return WomenInBotany::LDAP::Backend->new( $config, $app );
}

1; # Magic true value required at end of module

__END__
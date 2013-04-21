DROP TABLE IF EXISTS `botanists`;
CREATE TABLE `botanists` (
    id INTEGER NOT NULL auto_increment,
    familyname VARCHAR(255),
    birthname VARCHAR(255),   
    firstname VARCHAR(255),
    birthdate VARCHAR(255),
    birthplace VARCHAR(255),
    deathdate VARCHAR(255),
    deathplace VARCHAR(255),
    category VARCHAR(255),
    activity TEXT,
    workplace VARCHAR(255),
    country VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `botanists_references`;
CREATE TABLE `botanists_references` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    reference_id INTEGER REFERENCES `references`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    citation TEXT,
    PRIMARY KEY (id),
    UNIQUE (botanist_id, reference_id)    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `references`;
CREATE TABLE `references` (
    id INTEGER NOT NULL auto_increment,
    title VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `botanists_links`;
CREATE TABLE `botanists_links` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    link_id INTEGER REFERENCES `references`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    uri TEXT,
    last_seen DATE,
    PRIMARY KEY (id),
    UNIQUE (botanist_id, link_id)    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `links`;
CREATE TABLE `links` (
    id INTEGER NOT NULL auto_increment,
    host VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE  IF EXISTS `users`;
CREATE TABLE `users` (
    id            INTEGER NOT NULL auto_increment,
    username      VARCHAR(255) UNIQUE,
    password      VARCHAR(255),
    password_expires TIMESTAMP,
    email_address VARCHAR(255) UNIQUE,
    first_name    VARCHAR(255),
    last_name     VARCHAR(255),
    active        INTEGER,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE  IF EXISTS `roles`;
CREATE TABLE `roles` (
    id   INTEGER NOT NULL auto_increment,
    name VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE  IF EXISTS `users_roles`;
CREATE TABLE `users_roles` (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    role_id INTEGER REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

/*
DROP TABLE IF EXISTS ;
CREATE TABLE `` (

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;
*/

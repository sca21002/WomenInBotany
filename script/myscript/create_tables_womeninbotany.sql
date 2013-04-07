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


DROP TABLE IF EXISTS `botanists_refs`;
CREATE TABLE `botanists_refs` (
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ref_id INTEGER REFERENCES refs(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (botanist_id, ref_id)    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `refs`;
CREATE TABLE `refs` (
    id INTEGER NOT NULL auto_increment,
    title VARCHAR(255),
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
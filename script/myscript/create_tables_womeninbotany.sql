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
    activity TEXT,
    workplace VARCHAR(255),
    country VARCHAR(255),
    remarks TEXT,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `botanists_references`;
CREATE TABLE `botanists_references` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    reference_id INTEGER REFERENCES `references`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    citation TEXT,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `references`;
CREATE TABLE `references` (
    id INTEGER NOT NULL auto_increment,
    short_title VARCHAR(255),
    title TEXT,
    remarks TEXT,
    PRIMARY KEY (id),
    UNIQUE (short_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `botanists_links`;
CREATE TABLE `botanists_links` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    link_id INTEGER REFERENCES `references`(id) ON DELETE CASCADE ON UPDATE CASCADE,
    uri TEXT,
    last_seen DATE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `links`;
CREATE TABLE `links` (
    id INTEGER NOT NULL auto_increment,
    host VARCHAR(255),
    title VARCHAR(255),
    remarks TEXT,
    PRIMARY KEY (id),
    UNIQUE (host)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    title VARCHAR(255),
    description TEXT,
    basename VARCHAR(255),
    file VARCHAR(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `botanists_categories`;
CREATE TABLE `botanists_categories` (
    id INTEGER NOT NULL auto_increment,
    botanist_id INTEGER REFERENCES botanists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    category_id CHAR(1) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE  IF EXISTS `categories`;
CREATE TABLE `categories` (
    id CHAR(1),
    name VARCHAR(255),
    description TEXT,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT INTO `categories` (id, name) values ('A', 'Artist');
INSERT INTO `categories` (id, name) values ('B', 'Botanist');
INSERT INTO `categories` (id, name) values ('C', 'Patron (of the arts)');
INSERT INTO `categories` (id, name) values ('F', 'Fiction');
INSERT INTO `categories` (id, name) values ('H', 'Horticultur(al)ist');
INSERT INTO `categories` (id, name) values ('T', 'Translator');

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

INSERT INTO users (username) values ('admin');

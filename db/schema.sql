DROP SCHEMA IF EXISTS `discord`;
CREATE SCHEMA `discord`;

CREATE TABLE `discord`.`servers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` VARCHAR(48) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `url` VARCHAR(256) NOT NULL,
  `icon` VARCHAR(256) NOT NULL,
  `color` VARCHAR(12) DEFAULT NULL,
  `active` BOOL NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_unique` (`id`),
  KEY `NDX_SERVERS_SERVER_ID` (`server_id`)
);

CREATE TABLE `discord`.`channels` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` VARCHAR(48) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `channel_id` VARCHAR(48) NOT NULL,
  `active` BOOL NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_unique` (`id`),
  KEY `NDX_SERVERS_SERVER_ID` (`server_id`),
  CONSTRAINT `FK_CHANNELS_SERVER_ID` FOREIGN KEY (`server_id`) REFERENCES `discord`.`servers` (`server_id`)
);

CREATE TABLE `discord`.`server_roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` VARCHAR(48) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `role_id` VARCHAR(48) NOT NULL,
  `icon` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` BOOL NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_unique` (`id`),
  KEY `NDX_SERVERS_SERVER_ID` (`server_id`),
  CONSTRAINT `FK_SERVER_ROLES_SERVER_ID` FOREIGN KEY (`server_id`) REFERENCES `discord`.`servers` (`server_id`)
);

CREATE TABLE `discord`.`admin_roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` VARCHAR(48) NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  `role_id` VARCHAR(48) NOT NULL,
  `icon` VARCHAR(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` BOOL NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_unique` (`id`),
  KEY `NDX_SERVERS_SERVER_ID` (`server_id`),
  CONSTRAINT `FK_ADMIN_ROLES_SERVER_ID` FOREIGN KEY (`server_id`) REFERENCES `discord`.`servers` (`server_id`)
);

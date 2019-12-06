CREATE TABLE `landingPage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lpTypeId` int(11) unsigned NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `metaTitle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metaKeywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metaDescription` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `semanticKernel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_url` (`url`),
  KEY `K_lpTypeId` (`lpTypeId`),
  CONSTRAINT `FK_landingPage_lpTypeId` FOREIGN KEY (`lpTypeId`) REFERENCES `lpType` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `lpBlock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `typeId` int(11) unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_slug_typeId` (`slug`,`typeId`),
  KEY `K_typeId` (`typeId`),
  CONSTRAINT `FK_lpType_id` FOREIGN KEY (`typeId`) REFERENCES `lpType` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `lpType` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `rule` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `route` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `view` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `lpName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lpBody` text COLLATE utf8_unicode_ci,
  `lpMetaTitle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lpMetaKeywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lpMetaDescription` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `lpWidget` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `landingPageId` int(11) unsigned DEFAULT NULL,
  `blockId` int(11) unsigned NOT NULL,
  `widgetId` int(11) unsigned NOT NULL,
  `sort` smallint(6) unsigned NOT NULL DEFAULT '0',
  `options` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `K_lpId_blockId_sort` (`landingPageId`,`blockId`,`sort`),
  KEY `K_blockId` (`blockId`),
  KEY `K_widgetId` (`widgetId`),
  CONSTRAINT `FK_lpBlock_id` FOREIGN KEY (`blockId`) REFERENCES `lpBlock` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_lpWidget_landingPageId` FOREIGN KEY (`landingPageId`) REFERENCES `landingPage` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_widget_id` FOREIGN KEY (`widgetId`) REFERENCES `widget` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `widget` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `class` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `isFilter` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `createdDate` datetime DEFAULT NULL,
  `model` enum('company','person','service') COLLATE utf8_unicode_ci NOT NULL,
  `entityId` int(11) unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `K_model_entity_active` (`model`,`entityId`,`active`)
) ENGINE=InnoDB AUTO_INCREMENT=17020 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `isNetwork` tinyint(1) NOT NULL DEFAULT '0',
  `networkId` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lat` decimal(18,15) DEFAULT NULL,
  `lng` decimal(18,15) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `body` text COLLATE utf8_unicode_ci,
  `rating` decimal(4,2) unsigned NOT NULL DEFAULT '0.00',
  `sortOrder` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_slug` (`slug`),
  KEY `K_network` (`networkId`),
  KEY `K_sorting` (`sortOrder`,`rating`)
) ENGINE=InnoDB AUTO_INCREMENT=1614 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `companyPerson` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `companyId` int(11) unsigned NOT NULL,
  `personId` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_company_person` (`companyId`,`personId`),
  KEY `K_company` (`companyId`),
  KEY `K_person` (`personId`),
  CONSTRAINT `FK_companyPerson_companyId` FOREIGN KEY (`companyId`) REFERENCES `company` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_companyPerson_personId` FOREIGN KEY (`personId`) REFERENCES `person` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17896 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `body` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_slug` (`slug`),
  KEY `K_sorting` (`sortOrder`,`rating`)
) ENGINE=InnoDB AUTO_INCREMENT=13047 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

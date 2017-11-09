

DROP TABLE IF EXISTS `ausstage_schema`.`exhibition_section`;

DROP TABLE IF EXISTS `ausstage_schema`.`exhibition`;

CREATE  TABLE IF NOT EXISTS `ausstage_schema`.`exhibition` (
  `exhibitionid` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(250) NULL ,
  `description` VARCHAR(1000) NULL ,
  `published_flag` VARCHAR(1) NULL ,
  `owner` VARCHAR(45) NULL ,
  `entered_by_user` VARCHAR(40) NULL ,
  `entered_date` DATE NULL ,
  `updated_by_user` VARCHAR(40) NULL ,
  `updated_date` DATE NULL ,
  PRIMARY KEY (`exhibitionid`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE  TABLE IF NOT EXISTS `exhibition_section` (
  `exhibition_sectionid` int(11) NOT NULL AUTO_INCREMENT,
  `heading` varchar(250) DEFAULT NULL,
  `text` varchar(4000) DEFAULT NULL,
  `sequencenumber` int(11) DEFAULT NULL,
  `exhibitionid` int(11) DEFAULT NULL,
  `itemid` int(11) DEFAULT NULL,
  `organisationid` int(11) DEFAULT NULL,
  `eventid` int(11) DEFAULT NULL,
  `venueid` int(11) DEFAULT NULL,
  `contributorid` int(11) DEFAULT NULL,
  `workid` int(11) DEFAULT NULL,
  PRIMARY KEY (`exhibition_sectionid`),
  KEY `fk_exhibition_section_exhibition1_idx` (`exhibitionid`),
  KEY `fk_exhibition_section_item1_idx` (`itemid`),
  KEY `fk_exhibition_section_organisation1_idx` (`organisationid`),
  KEY `fk_exhibition_section_events1_idx` (`eventid`),
  KEY `fk_exhibition_section_venue1_idx` (`venueid`),
  KEY `fk_exhibition_section_contributor1_idx` (`contributorid`),
  KEY `fk_exhibition_section_work1_idx` (`workid`),
  CONSTRAINT `fk_exhibition_section_work1` FOREIGN KEY (`workid`) REFERENCES `work` (`workid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_contributor1` FOREIGN KEY (`contributorid`) REFERENCES `contributor` (`contributorid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_events1` FOREIGN KEY (`eventid`) REFERENCES `events` (`eventid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_exhibition1` FOREIGN KEY (`exhibitionid`) REFERENCES `exhibition` (`exhibitionid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_item1` FOREIGN KEY (`itemid`) REFERENCES `item` (`itemid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_organisation1` FOREIGN KEY (`organisationid`) REFERENCES `organisation` (`organisationid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_venue1` FOREIGN KEY (`venueid`) REFERENCES `venue` (`venueid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
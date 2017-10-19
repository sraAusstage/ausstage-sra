

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

CREATE  TABLE IF NOT EXISTS `ausstage_schema`.`exhibition_section` (
  `exhibition_sectionid` INT NOT NULL AUTO_INCREMENT ,
  `heading` VARCHAR(250) NULL ,
  `text` VARCHAR(4000) NULL ,
  `exhibitionid` INT NULL ,
  `itemid` INT(11) NULL ,
  `organisationid` INT(11) NULL ,
  `eventid` INT(11) NULL ,
  `venueid` INT(11) NULL ,
  `contributorid` INT(11) NULL ,
  PRIMARY KEY (`exhibition_sectionid`) ,
  INDEX `fk_exhibition_section_exhibition1_idx` (`exhibitionid` ASC) ,
  INDEX `fk_exhibition_section_item1_idx` (`itemid` ASC) ,
  INDEX `fk_exhibition_section_organisation1_idx` (`organisationid` ASC) ,
  INDEX `fk_exhibition_section_events1_idx` (`eventid` ASC) ,
  INDEX `fk_exhibition_section_venue1_idx` (`venueid` ASC) ,
  INDEX `fk_exhibition_section_contributor1_idx` (`contributorid` ASC) ,
  CONSTRAINT `fk_exhibition_section_exhibition1`
    FOREIGN KEY (`exhibitionid` )
    REFERENCES `ausstage_schema`.`exhibition` (`exhibitionid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_item1`
    FOREIGN KEY (`itemid` )
    REFERENCES `ausstage_schema`.`item` (`itemid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_organisation1`
    FOREIGN KEY (`organisationid` )
    REFERENCES `ausstage_schema`.`organisation` (`organisationid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_events1`
    FOREIGN KEY (`eventid` )
    REFERENCES `ausstage_schema`.`events` (`eventid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_venue1`
    FOREIGN KEY (`venueid` )
    REFERENCES `ausstage_schema`.`venue` (`venueid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exhibition_section_contributor1`
    FOREIGN KEY (`contributorid` )
    REFERENCES `ausstage_schema`.`contributor` (`contributorid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
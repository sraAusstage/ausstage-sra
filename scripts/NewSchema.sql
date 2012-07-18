Drop table if exists artevlink;
Drop table if exists articles;
Drop table if exists artevlink_old;
Drop table if exists articles_old;
Drop table if exists collection_information;
Drop table if exists collection_info_access;
Drop table if exists entity;
Drop table if exists entity_type;
Drop table if exists item_search_old;
Drop table if exists item_type_old;
Drop table if exists itemartlink_old;
Drop table if exists materiallink;
Drop table if exists materials;
Drop table if exists pubsupps;
Drop table if exists publications;
Drop table if exists pubsupps_old;
Drop table if exists publications_old;
Drop table if exists seccontentindicator;
Drop table if exists seccontentindicatorevlink;
Drop table if exists seccontentindicatorpreferred;
Drop table if exists test;
Drop table if exists users;


Alter table contributor modify notes varchar(4000);
ALTER TABLE contributor ADD prefix VARCHAR(40);
ALTER TABLE contributor ADD middle_name VARCHAR(40);
ALTER TABLE contributor ADD suffix VARCHAR(40);
ALTER TABLE contributor ADD place_of_birth INT(11);
ALTER TABLE contributor ADD place_of_death INT(11);
ALTER TABLE contributor ADD display_name VARCHAR(200);
ALTER TABLE contributor ADD nla VARCHAR(100);
Update contributor set display_name = CONCAT_WS(' ', first_name, last_name);	
ALTER TABLE contributor ADD updated_by_user VARCHAR(40);
ALTER TABLE contributor ADD entered_by_user VARCHAR(40);
ALTER TABLE contributor ADD entered_date DATE;
ALTER TABLE contributor ADD updated_date DATE;	

Alter table EVENTS modify description varchar(4000);
-- Alter table EVENTS DROP part_of_a_tour;
ALTER TABLE events ADD updated_by_user VARCHAR(40);
ALTER TABLE events ADD review varchar(5);

ALTER TABLE organisation ADD ddfirst_date VARCHAR(2);
ALTER TABLE organisation ADD mmfirst_date VARCHAR(2);
ALTER TABLE organisation ADD yyyyfirst_date VARCHAR(4);
ALTER TABLE organisation ADD ddlast_date VARCHAR(2);
ALTER TABLE organisation ADD mmlast_date VARCHAR(2);
ALTER TABLE organisation ADD yyyylast_date VARCHAR(4);
ALTER TABLE organisation ADD place_of_origin INT(11);
ALTER TABLE organisation ADD place_of_demise INT(11);
ALTER TABLE organisation MODIFY notes varchar(4000);
ALTER TABLE organisation ADD nla VARCHAR(100);
ALTER TABLE organisation ADD updated_by_user VARCHAR(40);
ALTER TABLE organisation ADD entered_by_user VARCHAR(40);
ALTER TABLE organisation ADD entered_date DATE;
ALTER TABLE organisation ADD updated_date DATE;	

ALTER TABLE venue ADD ddfirst_date VARCHAR(2);
ALTER TABLE venue ADD mmfirst_date VARCHAR(2);
ALTER TABLE venue ADD yyyyfirst_date VARCHAR(4);
ALTER TABLE venue ADD ddlast_date VARCHAR(2);
ALTER TABLE venue ADD mmlast_date VARCHAR(2);
ALTER TABLE venue ADD yyyylast_date VARCHAR(4);
ALTER TABLE venue DROP OTHER_NAMES1;
ALTER TABLE venue DROP OTHER_NAMES2;
ALTER TABLE venue DROP OTHER_NAMES3;
ALTER TABLE venue MODIFY notes varchar(4000);
ALTER TABLE venue ADD radius int(11);
ALTER TABLE venue ADD elevation int(11);
ALTER TABLE venue ADD updated_date DATE;
ALTER TABLE venue ADD entered_date DATE;
ALTER TABLE venue ADD entered_by_user VARCHAR(40);
ALTER TABLE venue ADD updated_by_user VARCHAR(40);


CREATE TABLE `contribcontriblink` (
  `CONTRIBCONTRIBLINKID` int(11) NOT NULL AUTO_INCREMENT,
  `CONTRIBUTORID` int(11) NOT NULL,
  `CHILDID` int(11) NOT NULL,
  `FUNCTION_LOV_ID` int(11) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`CONTRIBCONTRIBLINKID`),
  KEY `CONTRIB_CONTRIB_LINK_FUNCTION_FK` (`FUNCTION_LOV_ID`),
  KEY `coco_child_fk` (`CHILDID`),
  KEY `coco_contributor_fk` (`CONTRIBUTORID`),
  CONSTRAINT `coco_contributor_fk` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `contributor` (`contributorid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `coco_child_fk` FOREIGN KEY (`CHILDID`) REFERENCES `contributor` (`contributorid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CONTRIB_CONTRIB_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `lookup_codes` (`code_lov_id`)
) AUTO_INCREMENT=4872 DEFAULT CHARSET=utf8;


CREATE TABLE `eventeventlink` (
  `EVENTEVENTLINKID` int(11) NOT NULL AUTO_INCREMENT,
  `EVENTID` int(11) NOT NULL,
  `CHILDID` int(11) NOT NULL,
  `FUNCTION_LOV_ID` int(11) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`EVENTEVENTLINKID`),
  KEY `EVENT_EVENT_LINK_FUNCTION_FK` (`FUNCTION_LOV_ID`),
  KEY `evel_child_fk` (`CHILDID`),
  KEY `evev_event_fk` (`EVENTID`),
  CONSTRAINT `evev_event_fk` FOREIGN KEY (`EVENTID`) REFERENCES `events` (`eventid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `evel_child_fk` FOREIGN KEY (`CHILDID`) REFERENCES `events` (`eventid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `EVENT_EVENT_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `lookup_codes` (`code_lov_id`)
) AUTO_INCREMENT=4872 DEFAULT CHARSET=utf8;

CREATE TABLE `workworklink` (
  `WORKWORKLINKID` int(11) NOT NULL AUTO_INCREMENT,
  `WORKID` int(11) NOT NULL,
  `CHILDID` int(11) NOT NULL,
  `FUNCTION_LOV_ID` int(11) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`WORKWORKLINKID`),
  KEY `WORK_WORK_LINK_FUNCTION_FK` (`FUNCTION_LOV_ID`),
  KEY `wowo_child_fk` (`WORKID`),
  KEY `wowo_work_fk` (`WORKID`),
  KEY `CHILDID` (`CHILDID`),
  CONSTRAINT `wowo_child_fk` FOREIGN KEY (`CHILDID`) REFERENCES `work` (`workid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `WORK_WORK_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `lookup_codes` (`code_lov_id`),
  CONSTRAINT `wowo_work_fk` FOREIGN KEY (`WORKID`) REFERENCES `work` (`workid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) AUTO_INCREMENT=4872 DEFAULT CHARSET=utf8;

CREATE TABLE `orgorglink` (
  `ORGORGLINKID` int(11) NOT NULL AUTO_INCREMENT,
  `ORGANISATIONID` int(11) NOT NULL,
  `CHILDID` int(11) NOT NULL,
  `FUNCTION_LOV_ID` int(11) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ORGORGLINKID`),
  KEY `ORGANISATION_ORGANISATION_LINK_FUNCTION_FK` (`FUNCTION_LOV_ID`),
  KEY `oror_child_fk` (`CHILDID`),
  KEY `oror_organisation_fk` (`ORGANISATIONID`),
  CONSTRAINT `oror_organisation_fk` FOREIGN KEY (`ORGANISATIONID`) REFERENCES `organisation` (`organisationid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ORGANISATION_ORGANISATION_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `lookup_codes` (`code_lov_id`),
  CONSTRAINT `oror_child_fk` FOREIGN KEY (`CHILDID`) REFERENCES `organisation` (`organisationid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) AUTO_INCREMENT=4872 DEFAULT CHARSET=utf8;

CREATE TABLE `venuevenuelink` (
  `VENUEVENUELINKID` int(11) NOT NULL AUTO_INCREMENT,
  `VENUEID` int(11) NOT NULL,
  `CHILDID` int(11) NOT NULL,
  `FUNCTION_LOV_ID` int(11) DEFAULT NULL,
  `NOTES` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`VENUEVENUELINKID`),
  KEY `VENUE_VENUE_LINK_FUNCTION_FK` (`FUNCTION_LOV_ID`),
  KEY `veve_child_fk` (`CHILDID`),
  KEY `veve_venue_fk` (`VENUEID`),
  CONSTRAINT `veve_venue_fk` FOREIGN KEY (`VENUEID`) REFERENCES `venue` (`venueid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `VENUE_VENUE_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `lookup_codes` (`code_lov_id`),
  CONSTRAINT `veve_child_fk` FOREIGN KEY (`CHILDID`) REFERENCES `venue` (`venueid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) AUTO_INCREMENT=4874 DEFAULT CHARSET=utf8;


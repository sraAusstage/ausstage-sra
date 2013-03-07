set foreign_key_checks=1;

-- Set Non-Nullables

ALTER TABLE `CODE_ASSOCIATIONS` MODIFY `CODE_1_TYPE` VARCHAR(50) NOT NULL;
ALTER TABLE `CODE_ASSOCIATIONS` MODIFY `CODE_2_TYPE` VARCHAR(50) NOT NULL;
ALTER TABLE `CODE_ASSOCIATIONS` MODIFY `CODE_1_LOV_ID` INT(11) NOT NULL;
ALTER TABLE `CODE_ASSOCIATIONS` MODIFY `CODE_2_LOV_ID` INT(11) NOT NULL;
ALTER TABLE `CONDITION` MODIFY `CONDITION_ID` INT(11) NOT NULL;
ALTER TABLE `CONORGLINK` MODIFY `CONORGLINKID` INT(11) NOT NULL;
ALTER TABLE `CONORGLINK` MODIFY `CONTRIBUTORID` INT(11) NOT NULL;
ALTER TABLE `CONORGLINK` MODIFY `ORGANISATIONID` INT(11) NOT NULL;
ALTER TABLE `CONTRIBUTOR` MODIFY `CONTRIBUTORID` INT(11) NOT NULL;
ALTER TABLE `CONTRIBUTORFUNCTPREFERRED` MODIFY `CONTRIBUTORFUNCTPREFERREDID` INT(11) NOT NULL;
ALTER TABLE `CONTRIBUTORFUNCTPREFERRED` MODIFY `PREFERREDTERM` VARCHAR(300) NOT NULL;
ALTER TABLE `COUNTRY` MODIFY `COUNTRYID` INT(11) NOT NULL;
ALTER TABLE `COUNTRY` MODIFY `COUNTRYNAME` VARCHAR(100) NOT NULL;
ALTER TABLE `DATASOURCEEVLINK` MODIFY `DATASOURCEEVLINKID` INT(11) NOT NULL;
ALTER TABLE `DATASOURCEEVLINK` MODIFY `COLLECTION` VARCHAR(5) NOT NULL;
ALTER TABLE `DATASOURCEEVLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `DATASOURCEEVLINK` MODIFY `DATASOURCEID` INT(11) NOT NULL;
ALTER TABLE `DONATED_PURCHASED` MODIFY `DONATED_PURCHASED_ID` INT(11) NOT NULL;
ALTER TABLE `EVENTWORKLINK` MODIFY `EVENTWORKLINKID` INT(11) NOT NULL;
ALTER TABLE `EVENTWORKLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `EVENTWORKLINK` MODIFY `WORKID` INT(11) NOT NULL;
ALTER TABLE `ITEM` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEM` MODIFY `ITEM_TYPE_LOV_ID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONLINK` MODIFY `ITEMCONLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONLINK` MODIFY `CONTRIBUTORID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONTENTINDLINK` MODIFY `ITEMCONTENTINDLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONTENTINDLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMCONTENTINDLINK` MODIFY `CONTENTINDICATORID` INT(11) NOT NULL;
ALTER TABLE `ITEMEVLINK` MODIFY `ITEMEVLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMEVLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMEVLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `ITEMITEMLINK` MODIFY `ITEMITEMLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMITEMLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMITEMLINK` MODIFY `CHILDID` INT(11) NOT NULL;
ALTER TABLE `ITEMORGLINK` MODIFY `ITEMORGLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMORGLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMORGLINK` MODIFY `ORGANISATIONID` INT(11) NOT NULL;
ALTER TABLE `ITEMSECGENRELINK` MODIFY `ITEMSECGENRELINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMSECGENRELINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMSECGENRELINK` MODIFY `SECGENREPREFERREDID` INT(11) NOT NULL;
ALTER TABLE `ITEMVENUELINK` MODIFY `ITEMVENUELINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMVENUELINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMVENUELINK` MODIFY `VENUEID` INT(11) NOT NULL;
ALTER TABLE `ITEMWORKLINK` MODIFY `ITEMWORKLINKID` INT(11) NOT NULL;
ALTER TABLE `ITEMWORKLINK` MODIFY `ITEMID` INT(11) NOT NULL;
ALTER TABLE `ITEMWORKLINK` MODIFY `WORKID` INT(11) NOT NULL;
ALTER TABLE `LOOKUP_CODES` MODIFY `CODE_LOV_ID` INT(11) NOT NULL;
ALTER TABLE `LOOKUP_CODES` MODIFY `CODE_TYPE` VARCHAR(50) NOT NULL;
ALTER TABLE `LOOKUP_TYPES` MODIFY `CODE_TYPE` VARCHAR(50) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `FEEDBACK_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `PERFORMANCE_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `QUESTION_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `SOURCE_TYPE` INT(11) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `RECEIVED_DATE_TIME` DATE NOT NULL DEFAULT 0;
ALTER TABLE `MOB_FEEDBACK` MODIFY `PUBLIC_DISPLAY` VARCHAR(1) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `MANUAL_ADD` VARCHAR(1) NOT NULL;
ALTER TABLE `MOB_FEEDBACK` MODIFY `RECEIVED_FROM` VARCHAR(64) NOT NULL;
ALTER TABLE `MOB_ORGANISATIONS` MODIFY `ORGANISATION_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_ORGANISATIONS` MODIFY `TWITTER_HASH_TAG` VARCHAR(64) NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `PERFORMANCE_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `EVENT_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `START_DATE_TIME` DATE NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `END_DATE_TIME` DATE NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `QUESTION_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_PERFORMANCES` MODIFY `DEPRECATED_HASH_TAG` VARCHAR(1) NOT NULL;
ALTER TABLE `MOB_QUESTIONS` MODIFY `QUESTION_ID` INT(11) NOT NULL;
ALTER TABLE `MOB_QUESTIONS` MODIFY `QUESTION` VARCHAR(512) NOT NULL;
ALTER TABLE `MOB_SOURCE_TYPES` MODIFY `SOURCE_TYPE` INT(11) NOT NULL;
ALTER TABLE `MOB_SOURCE_TYPES` MODIFY `SOURCE_NAME` VARCHAR(255) NOT NULL;
ALTER TABLE `ORGANISATION` MODIFY `ORGANISATION_TYPE_ID` INT(11) NOT NULL;
ALTER TABLE `ORGANISATION` MODIFY `WEB_LINKS` VARCHAR(2048);
ALTER TABLE `ORGANISATION_TYPE` MODIFY `ORGANISATION_TYPE_ID` INT(11) NOT NULL;
ALTER TABLE `ORGANISATION_TYPE` MODIFY `TYPE` VARCHAR(40) NOT NULL;
ALTER TABLE `PLAYEVLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `PLAYEVLINK` MODIFY `COUNTRYID` INT(11) NOT NULL;
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` MODIFY `PRIMCONTENTINDICATOREVLINKID` INT(11) NOT NULL;
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` MODIFY `PRIMCONTENTINDICATORID` INT(11) NOT NULL;
ALTER TABLE `PRODUCTIONEVLINK` MODIFY `EVENTID` INT(11) NOT NULL;
ALTER TABLE `PRODUCTIONEVLINK` MODIFY `COUNTRYID` INT(11) NOT NULL;
ALTER TABLE `SECGENREPREFERRED` MODIFY `SECGENREPREFERREDID` INT(11) NOT NULL;
ALTER TABLE `SECGENREPREFERRED` MODIFY `PREFERREDTERM` VARCHAR(300) NOT NULL;
ALTER TABLE `STATES` MODIFY `STATE` VARCHAR(40) NOT NULL;
ALTER TABLE `VENUE` MODIFY `WEB_LINKS` VARCHAR(2048);
ALTER TABLE `WORK` MODIFY `WORKID` INT(11) NOT NULL;
ALTER TABLE `WORKCONLINK` MODIFY `WORKCONLINKID` INT(11) NOT NULL;
ALTER TABLE `WORKCONLINK` MODIFY `WORKID` INT(11) NOT NULL;
ALTER TABLE `WORKCONLINK` MODIFY `CONTRIBUTORID` INT(11) NOT NULL;
ALTER TABLE `WORKORGLINK` MODIFY `WORKORGLINKID` INT(11) NOT NULL;
ALTER TABLE `WORKORGLINK` MODIFY `WORKID` INT(11) NOT NULL;
ALTER TABLE `WORKORGLINK` MODIFY `ORGANISATIONID` INT(11) NOT NULL;
ALTER TABLE `WWW` MODIFY `WWW_ID` INT(11) NOT NULL;

-- primary keys
ALTER TABLE `CONDITION` ADD PRIMARY KEY (`CONDITION_ID`);
ALTER TABLE `CONEVLINK` ADD PRIMARY KEY (`CONEVLINKID`);
ALTER TABLE `CONORGLINK` ADD PRIMARY KEY (`CONORGLINKID`);
ALTER TABLE `CONTENTINDICATOR` ADD PRIMARY KEY (`CONTENTINDICATORID`);
ALTER TABLE `CONTFUNCT` ADD PRIMARY KEY (`CONTFUNCTIONID`);
ALTER TABLE `CONTFUNCTLINK` ADD PRIMARY KEY (`CONTRIBUTORID`, `CONTRIBUTORFUNCTPREFERREDID`);
ALTER TABLE `CONTRIBUTOR` ADD PRIMARY KEY (`CONTRIBUTORID`);
ALTER TABLE `CONTRIBUTORFUNCTPREFERRED` ADD PRIMARY KEY (`CONTRIBUTORFUNCTPREFERREDID`);
ALTER TABLE `COUNTRY` ADD PRIMARY KEY (`COUNTRYID`);
ALTER TABLE `COUNTRY` ADD CONSTRAINT `UK_COUNTRYNAME` UNIQUE (`COUNTRYNAME`) ;
ALTER TABLE `DATASOURCE` ADD PRIMARY KEY (`DATASOURCEID`);
ALTER TABLE `DESCRIPTIONSRC` ADD PRIMARY KEY (`DESCRIPTIONSOURCEID`);
ALTER TABLE `DONATED_PURCHASED` ADD PRIMARY KEY (`DONATED_PURCHASED_ID`);
ALTER TABLE `EVENTS` ADD PRIMARY KEY (`EVENTID`);
ALTER TABLE `EVENTWORKLINK` ADD PRIMARY KEY (`EVENTWORKLINKID`);
ALTER TABLE `GENDERMENU` ADD PRIMARY KEY (`GENDERID`);
ALTER TABLE `ITEM` ADD PRIMARY KEY (`ITEMID`);
ALTER TABLE `ITEMCONLINK` ADD PRIMARY KEY (`ITEMCONLINKID`);
ALTER TABLE `ITEMCONTENTINDLINK` ADD PRIMARY KEY (`ITEMCONTENTINDLINKID`);
ALTER TABLE `ITEMEVLINK` ADD PRIMARY KEY (`ITEMEVLINKID`);
ALTER TABLE `ITEMITEMLINK` ADD PRIMARY KEY (`ITEMITEMLINKID`);
ALTER TABLE `ITEMORGLINK` ADD PRIMARY KEY (`ITEMORGLINKID`);
ALTER TABLE `ITEMSECGENRELINK` ADD PRIMARY KEY (`ITEMSECGENRELINKID`);
ALTER TABLE `ITEMVENUELINK` ADD PRIMARY KEY (`ITEMVENUELINKID`);
ALTER TABLE `ITEMWORKLINK` ADD PRIMARY KEY (`ITEMWORKLINKID`);
ALTER TABLE `LOOKUP_CODES` ADD PRIMARY KEY (`CODE_LOV_ID`);
ALTER TABLE `LOOKUP_TYPES` ADD PRIMARY KEY (`CODE_TYPE`);
ALTER TABLE `MOB_FEEDBACK` ADD PRIMARY KEY (`FEEDBACK_ID`);
ALTER TABLE `MOB_PERFORMANCES` ADD PRIMARY KEY (`PERFORMANCE_ID`);
ALTER TABLE `MOB_QUESTIONS` ADD PRIMARY KEY (`QUESTION_ID`);
ALTER TABLE `MOB_SOURCE_TYPES` ADD PRIMARY KEY (`SOURCE_TYPE`);
ALTER TABLE `ORGANISATION` ADD PRIMARY KEY (`ORGANISATIONID`);
ALTER TABLE `ORGANISATION_TYPE` ADD PRIMARY KEY (`ORGANISATION_TYPE_ID`);
ALTER TABLE `ORGEVLINK` ADD PRIMARY KEY (`ORGEVLINKID`);
ALTER TABLE `ORGFUNCTMENU` ADD PRIMARY KEY (`ORGFUNCTIONID`);
ALTER TABLE `PLAYEVLINK` ADD PRIMARY KEY (`EVENTID`, `COUNTRYID`);
ALTER TABLE `PRIGENRECLASS` ADD PRIMARY KEY (`GENRECLASSID`);
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` ADD PRIMARY KEY (`PRIMCONTENTINDICATOREVLINKID`);
ALTER TABLE `PRODUCTIONEVLINK` ADD PRIMARY KEY (`EVENTID`, `COUNTRYID`);
ALTER TABLE `SECGENRECLASS` ADD PRIMARY KEY (`GENRECLASSID`);
ALTER TABLE `SECGENRECLASSLINK` ADD PRIMARY KEY (`EVENTID`, `SECGENREPREFERREDID`);
ALTER TABLE `SECGENREPREFERRED` ADD PRIMARY KEY (`SECGENREPREFERREDID`);
ALTER TABLE `SECGENREPREFERRED` ADD CONSTRAINT `SEGP_UK` UNIQUE (`PREFERREDTERM`) ;
ALTER TABLE `STATES` ADD PRIMARY KEY (`STATEID`);
ALTER TABLE `STATUSMENU` ADD PRIMARY KEY (`STATUSID`);
ALTER TABLE `VENUE` ADD PRIMARY KEY (`VENUEID`);
ALTER TABLE `WORK` ADD PRIMARY KEY (`WORKID`);
ALTER TABLE `WORKCONLINK` ADD PRIMARY KEY (`WORKCONLINKID`);
ALTER TABLE `WORKORGLINK` ADD PRIMARY KEY (`WORKORGLINKID`);
ALTER TABLE `WWW` ADD PRIMARY KEY (`WWW_ID`);

-- foreign keys
ALTER TABLE `CONEVLINK` ADD CONSTRAINT `CONE_CONTR_FK` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `CONTRIBUTOR` (`CONTRIBUTORID`) ;
ALTER TABLE `CONEVLINK` ADD CONSTRAINT `CONE_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `CONORGLINK` ADD CONSTRAINT `CONO_CONT_FK` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `CONTRIBUTOR` (`CONTRIBUTORID`) ;
ALTER TABLE `CONORGLINK` ADD CONSTRAINT `CONO_ORGA_FK` FOREIGN KEY (`ORGANISATIONID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `CONTFUNCT` ADD CONSTRAINT `CONTF_COFP_FK` FOREIGN KEY (`CONTRIBUTORFUNCTPREFERREDID`) REFERENCES `CONTRIBUTORFUNCTPREFERRED` (`CONTRIBUTORFUNCTPREFERREDID`) ;
ALTER TABLE `CONTFUNCTLINK` ADD CONSTRAINT `CONTFL_COFP_FK` FOREIGN KEY (`CONTRIBUTORFUNCTPREFERREDID`) REFERENCES `CONTRIBUTORFUNCTPREFERRED` (`CONTRIBUTORFUNCTPREFERREDID`) ;
ALTER TABLE `CONTFUNCTLINK` ADD CONSTRAINT `CONTFL_CONTR_FK` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `CONTRIBUTOR` (`CONTRIBUTORID`) ;
ALTER TABLE `CONTRIBUTOR` ADD CONSTRAINT `CONTR_COUN_FK` FOREIGN KEY (`COUNTRYID`) REFERENCES `COUNTRY` (`COUNTRYID`) ;
ALTER TABLE `CONTRIBUTOR` ADD CONSTRAINT `CONTR_GEND_FK` FOREIGN KEY (`GENDER`) REFERENCES `GENDERMENU` (`GENDERID`) ;
ALTER TABLE `CONTRIBUTOR` ADD CONSTRAINT `CONTR_STAT_FK` FOREIGN KEY (`STATE`) REFERENCES `STATES` (`STATEID`) ;
ALTER TABLE `DATASOURCEEVLINK` ADD CONSTRAINT `DSEL_DATA_FK` FOREIGN KEY (`DATASOURCEID`) REFERENCES `DATASOURCE` (`DATASOURCEID`) ;
ALTER TABLE `DATASOURCEEVLINK` ADD CONSTRAINT `DSEL_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `EVENTS` ADD CONSTRAINT `EVEN_CONT_FK` FOREIGN KEY (`CONTENT_INDICATOR`) REFERENCES `CONTENTINDICATOR` (`CONTENTINDICATORID`) ;
ALTER TABLE `EVENTS` ADD CONSTRAINT `EVEN_DESC_FK` FOREIGN KEY (`DESCRIPTION_SOURCE`) REFERENCES `DESCRIPTIONSRC` (`DESCRIPTIONSOURCEID`) ;
ALTER TABLE `EVENTS` ADD CONSTRAINT `EVEN_PRIG_FK` FOREIGN KEY (`PRIMARY_GENRE`) REFERENCES `PRIGENRECLASS` (`GENRECLASSID`) ;
ALTER TABLE `EVENTS` ADD CONSTRAINT `EVEN_STME_FK` FOREIGN KEY (`STATUS`) REFERENCES `STATUSMENU` (`STATUSID`) ;
ALTER TABLE `EVENTS` ADD CONSTRAINT `EVEN_VENU_FK` FOREIGN KEY (`VENUEID`) REFERENCES `VENUE` (`VENUEID`) ;
ALTER TABLE `EVENTWORKLINK` ADD CONSTRAINT `EVWO_EVENT_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `EVENTWORKLINK` ADD CONSTRAINT `EVWO_WORK_FK` FOREIGN KEY (`WORKID`) REFERENCES `WORK` (`WORKID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `FK_LANGUAGE_LOV_ID` FOREIGN KEY (`LANGUAGE_LOV_ID`) REFERENCES `LOOKUP_CODES` (`CODE_LOV_ID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `FK_SUB_TYPE_LOV_ID` FOREIGN KEY (`ITEM_SUB_TYPE_LOV_ID`) REFERENCES `LOOKUP_CODES` (`CODE_LOV_ID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `ITEM_COND_FK` FOREIGN KEY (`ITEM_CONDITION_ID`) REFERENCES `CONDITION` (`CONDITION_ID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `ITEM_ORGA_FK` FOREIGN KEY (`INSTITUTIONID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `ITEM_SOURCE_FK` FOREIGN KEY (`SOURCEID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEM` ADD CONSTRAINT `ITEM_TYPE_FK` FOREIGN KEY (`ITEM_TYPE_LOV_ID`) REFERENCES `LOOKUP_CODES` (`CODE_LOV_ID`) ;
ALTER TABLE `ITEMCONLINK` ADD CONSTRAINT `ITCL_CONT_FK` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `CONTRIBUTOR` (`CONTRIBUTORID`) ;
ALTER TABLE `ITEMCONLINK` ADD CONSTRAINT `ITCL_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMCONTENTINDLINK` ADD CONSTRAINT `ITCI_CONTENTIND_FK` FOREIGN KEY (`CONTENTINDICATORID`) REFERENCES `CONTENTINDICATOR` (`CONTENTINDICATORID`) ;
ALTER TABLE `ITEMCONTENTINDLINK` ADD CONSTRAINT `ITCI_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMEVLINK` ADD CONSTRAINT `ITEL_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMEVLINK` ADD CONSTRAINT `ITEL_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `ITEMITEMLINK` ADD CONSTRAINT `ITEM_ITEM_LINK_FUNCTION_FK` FOREIGN KEY (`FUNCTION_LOV_ID`) REFERENCES `LOOKUP_CODES` (`CODE_LOV_ID`) ;
ALTER TABLE `ITEMORGLINK` ADD CONSTRAINT `ITOL_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMORGLINK` ADD CONSTRAINT `ITOL_ORGA_FK` FOREIGN KEY (`ORGANISATIONID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `ITEMSECGENRELINK` ADD CONSTRAINT `ITGE_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMSECGENRELINK` ADD CONSTRAINT `ITGE_SECGENREPREFERRED_FK` FOREIGN KEY (`SECGENREPREFERREDID`) REFERENCES `SECGENREPREFERRED` (`SECGENREPREFERREDID`) ;
ALTER TABLE `ITEMVENUELINK` ADD CONSTRAINT `ITVL_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMVENUELINK` ADD CONSTRAINT `ITVL_VENU_FK` FOREIGN KEY (`VENUEID`) REFERENCES `VENUE` (`VENUEID`) ;
ALTER TABLE `ITEMWORKLINK` ADD CONSTRAINT `ITWO_ITEM_FK` FOREIGN KEY (`ITEMID`) REFERENCES `ITEM` (`ITEMID`) ;
ALTER TABLE `ITEMWORKLINK` ADD CONSTRAINT `ITWO_WORK_FK` FOREIGN KEY (`WORKID`) REFERENCES `WORK` (`WORKID`) ;
ALTER TABLE `LOOKUP_CODES` ADD CONSTRAINT `CODETYPE_FK` FOREIGN KEY (`CODE_TYPE`) REFERENCES `LOOKUP_TYPES` (`CODE_TYPE`) ;
ALTER TABLE `MOB_FEEDBACK` ADD CONSTRAINT `MOB_FEEDBACK_MOB_PERFORMA_FK1` FOREIGN KEY (`PERFORMANCE_ID`) REFERENCES `MOB_PERFORMANCES` (`PERFORMANCE_ID`) ;
ALTER TABLE `MOB_FEEDBACK` ADD CONSTRAINT `MOB_FEEDBACK_MOB_QUESTION_FK1` FOREIGN KEY (`QUESTION_ID`) REFERENCES `MOB_QUESTIONS` (`QUESTION_ID`) ;
ALTER TABLE `MOB_FEEDBACK` ADD CONSTRAINT `MOB_FEEDBACK_MOB_SOURCE_T_FK1` FOREIGN KEY (`SOURCE_TYPE`) REFERENCES `MOB_SOURCE_TYPES` (`SOURCE_TYPE`) ;
ALTER TABLE `MOB_ORGANISATIONS` ADD CONSTRAINT `MOB_ORGANISATIONS_ORGANIS_FK1` FOREIGN KEY (`ORGANISATION_ID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `MOB_PERFORMANCES` ADD CONSTRAINT `MOB_PERFORMANCES_EVENTS_FK1` FOREIGN KEY (`EVENT_ID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `MOB_PERFORMANCES` ADD CONSTRAINT `MOB_PERFORMANCES_MOB_QUES_FK1` FOREIGN KEY (`QUESTION_ID`) REFERENCES `MOB_QUESTIONS` (`QUESTION_ID`) ;
ALTER TABLE `ORGANISATION` ADD CONSTRAINT `ORGA_COUN_FK` FOREIGN KEY (`COUNTRYID`) REFERENCES `COUNTRY` (`COUNTRYID`) ;
ALTER TABLE `ORGANISATION` ADD CONSTRAINT `ORGA_ORGT_FK` FOREIGN KEY (`ORGANISATION_TYPE_ID`) REFERENCES `ORGANISATION_TYPE` (`ORGANISATION_TYPE_ID`) ;
ALTER TABLE `ORGANISATION` ADD CONSTRAINT `ORGA_STAT_FK` FOREIGN KEY (`STATE`) REFERENCES `STATES` (`STATEID`) ;
ALTER TABLE `ORGEVLINK` ADD CONSTRAINT `ORGE_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `ORGEVLINK` ADD CONSTRAINT `ORGE_ORGA_FK` FOREIGN KEY (`ORGANISATIONID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `ORGEVLINK` ADD CONSTRAINT `ORGE_ORGF_FK` FOREIGN KEY (`FUNCTION`) REFERENCES `ORGFUNCTMENU` (`ORGFUNCTIONID`) ;
ALTER TABLE `PLAYEVLINK` ADD CONSTRAINT `PLAY_COUN_FK` FOREIGN KEY (`COUNTRYID`) REFERENCES `COUNTRY` (`COUNTRYID`) ;
ALTER TABLE `PLAYEVLINK` ADD CONSTRAINT `PLAY_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` ADD CONSTRAINT `PRIM_CONT_FK` FOREIGN KEY (`PRIMCONTENTINDICATORID`) REFERENCES `CONTENTINDICATOR` (`CONTENTINDICATORID`) ;
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` ADD CONSTRAINT `PRIM_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `PRODUCTIONEVLINK` ADD CONSTRAINT `PROD_COUN_FK` FOREIGN KEY (`COUNTRYID`) REFERENCES `COUNTRY` (`COUNTRYID`) ;
ALTER TABLE `PRODUCTIONEVLINK` ADD CONSTRAINT `PROD_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `SECGENRECLASS` ADD CONSTRAINT `SECG_SEGP_FK` FOREIGN KEY (`SECGENREPREFERREDID`) REFERENCES `SECGENREPREFERRED` (`SECGENREPREFERREDID`) ;
ALTER TABLE `SECGENRECLASSLINK` ADD CONSTRAINT `SGRL_EVEN_FK` FOREIGN KEY (`EVENTID`) REFERENCES `EVENTS` (`EVENTID`) ;
ALTER TABLE `SECGENRECLASSLINK` ADD CONSTRAINT `SGRL_SEGP_FK` FOREIGN KEY (`SECGENREPREFERREDID`) REFERENCES `SECGENREPREFERRED` (`SECGENREPREFERREDID`) ;
ALTER TABLE `VENUE` ADD CONSTRAINT `VENU_COUN_FK` FOREIGN KEY (`COUNTRYID`) REFERENCES `COUNTRY` (`COUNTRYID`) ;
ALTER TABLE `VENUE` ADD CONSTRAINT `VENU_STAT_FK` FOREIGN KEY (`STATE`) REFERENCES `STATES` (`STATEID`) ;
ALTER TABLE `WORKCONLINK` ADD CONSTRAINT `WOCO_CON_FK` FOREIGN KEY (`CONTRIBUTORID`) REFERENCES `CONTRIBUTOR` (`CONTRIBUTORID`) ;
ALTER TABLE `WORKCONLINK` ADD CONSTRAINT `WOCO_WORK_FK` FOREIGN KEY (`WORKID`) REFERENCES `WORK` (`WORKID`) ;
ALTER TABLE `WORKORGLINK` ADD CONSTRAINT `WOOR_ORG_FK` FOREIGN KEY (`ORGANISATIONID`) REFERENCES `ORGANISATION` (`ORGANISATIONID`) ;
ALTER TABLE `WORKORGLINK` ADD CONSTRAINT `WOOR_WORK_FK` FOREIGN KEY (`WORKID`) REFERENCES `WORK` (`WORKID`) ;
ALTER TABLE `WWW` ADD CONSTRAINT `WWW_COIL_FK` FOREIGN KEY (`COLLECTION_INFORMATION_ID`) REFERENCES `COLLECTION_INFORMATION` (`COLLECTION_INFORMATION_ID`) ;

-- Auto Increments
ALTER TABLE `CONDITION` MODIFY `CONDITION_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONEVLINK` MODIFY `CONEVLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONORGLINK` MODIFY `CONORGLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONTENTINDICATOR` MODIFY `CONTENTINDICATORID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONTFUNCT` MODIFY `CONTFUNCTIONID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONTRIBUTOR` MODIFY `CONTRIBUTORID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `CONTRIBUTORFUNCTPREFERRED` MODIFY `CONTRIBUTORFUNCTPREFERREDID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `COUNTRY` MODIFY `COUNTRYID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `DATASOURCE` MODIFY `DATASOURCEID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `DESCRIPTIONSRC` MODIFY `DESCRIPTIONSOURCEID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `DONATED_PURCHASED` MODIFY `DONATED_PURCHASED_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `EVENTS` MODIFY `EVENTID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `EVENTWORKLINK` MODIFY `EVENTWORKLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `GENDERMENU` MODIFY `GENDERID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEM` MODIFY `ITEMID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMCONLINK` MODIFY `ITEMCONLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMCONTENTINDLINK` MODIFY `ITEMCONTENTINDLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMEVLINK` MODIFY `ITEMEVLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMITEMLINK` MODIFY `ITEMITEMLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMORGLINK` MODIFY `ITEMORGLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMSECGENRELINK` MODIFY `ITEMSECGENRELINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMVENUELINK` MODIFY `ITEMVENUELINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ITEMWORKLINK` MODIFY `ITEMWORKLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `LOOKUP_CODES` MODIFY `CODE_LOV_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `MOB_FEEDBACK` MODIFY `FEEDBACK_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `MOB_PERFORMANCES` MODIFY `PERFORMANCE_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `MOB_QUESTIONS` MODIFY `QUESTION_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `MOB_SOURCE_TYPES` MODIFY `SOURCE_TYPE` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ORGANISATION` MODIFY `ORGANISATIONID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ORGANISATION_TYPE` MODIFY `ORGANISATION_TYPE_ID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ORGEVLINK` MODIFY `ORGEVLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `ORGFUNCTMENU` MODIFY `ORGFUNCTIONID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `PRIGENRECLASS` MODIFY `GENRECLASSID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `PRIMCONTENTINDICATOREVLINK` MODIFY `PRIMCONTENTINDICATOREVLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `SECGENRECLASS` MODIFY `GENRECLASSID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `SECGENREPREFERRED` MODIFY `SECGENREPREFERREDID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `STATES` MODIFY `STATEID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `STATUSMENU` MODIFY `STATUSID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `VENUE` MODIFY `VENUEID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `WORK` MODIFY `WORKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `WORKCONLINK` MODIFY `WORKCONLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `WORKORGLINK` MODIFY `WORKORGLINKID` INT(11) NOT NULL AUTO_INCREMENT; 
ALTER TABLE `WWW` MODIFY `WWW_ID` INT(11) NOT NULL AUTO_INCREMENT; 


CREATE TABLE `SEARCH_WORK`
(   `WORKID` INT(11),
	`WORK_TITLE` VARCHAR(255),
	`ALTER_WORK_TITLE` VARCHAR(255),
	`COMBINED_ALL` VARCHAR(4000)
) ;


-- Fulltext Indexes
ALTER TABLE `SEARCH_ALL` ENGINE = MyISAM;
ALTER TABLE `SEARCH_CONTRIBUTOR` ENGINE = MyISAM;
ALTER TABLE `SEARCH_EVENT` ENGINE = MyISAM;
ALTER TABLE `SEARCH_ORGANISATION` ENGINE = MyISAM;
ALTER TABLE `SEARCH_RESOURCE` ENGINE = MyISAM;
ALTER TABLE `SEARCH_VENUE` ENGINE = MyISAM;
ALTER TABLE `SEARCH_WORK` ENGINE = MyISAM;

CREATE FULLTEXT INDEX combined_all ON `SEARCH_ALL` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_CONTRIBUTOR` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_EVENT` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_ORGANISATION` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_RESOURCE` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_VENUE` (combined_all);
CREATE FULLTEXT INDEX combined_all ON `SEARCH_WORK` (combined_all);

-- Views
CREATE VIEW CON_VENUE_MIN_MAX_EVENT_DATES (contributorid, venueid, min_date, max_date) as
SELECT cl.contributorid, v.venueid,
if(LENGTH(min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`)))=0,NULL,
	min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`))) AS `MIN_EVENT_DATE`,
if(LENGTH(max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`)))=0,NULL,
	max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`))) AS `MAX_EVENT_DATE` 
FROM events e
INNER JOIN conevlink cl ON cl.eventid = e.eventid
INNER JOIN venue v ON e.venueid = v.venueid
GROUP BY cl.contributorid, v.venueid;

CREATE VIEW VENUE_MIN_MAX_EVENT_DATES (VENUEID,MIN_EVENT_DATE,MAX_EVENT_DATE) AS
SELECT v.venueid,
if(LENGTH(min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`)))=0,NULL,
	min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`))) AS `MIN_EVENT_DATE`,
if(LENGTH(max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`)))=0,NULL,
	max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`))) AS `MAX_EVENT_DATE` 
FROM venue v
INNER JOIN events e ON e.venueid = v.venueid
GROUP BY venueid;

CREATE VIEW ORG_VENUE_MIN_MAX_EVENT_DATES (ORGANISATIONID,VENUEID,MIN_DATE,MAX_DATE) AS
SELECT o.organisationid, v.venueid,
if(LENGTH(min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`)))=0,NULL,
	min(concat_ws('',`e`.`yyyyfirst_date`,`e`.`mmfirst_date`,`e`.`ddfirst_date`))) AS `MIN_EVENT_DATE`,
if(LENGTH(max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`)))=0,NULL,
	max(concat_ws('',`e`.`yyyylast_date`,`e`.`mmlast_date`,`e`.`ddlast_date`))) AS `MAX_EVENT_DATE` 
FROM events e
INNER JOIN orgevlink o ON o.eventid = e.eventid
INNER JOIN venue v ON e.venueid = v.venueid
GROUP BY o.organisationid, v.venueid;


-- Fixes the millennium bug /facepalm/

update events set first_date=str_to_date(concat_ws('', yyyyfirst_date, lpad(ifnull(mmfirst_date,'01'),2,'0'), lpad(ifnull(ddfirst_date,'01'),2,'0')), '%Y%m%d') where yyyyfirst_date != date_format(first_date, '%Y');
update events set entered_date=str_to_date(concat_ws('', yyyydate_entered, lpad(ifnull(mmdate_entered,'01'),2,'0'), lpad(ifnull(dddate_entered,'01'),2,'0')), '%Y%m%d') where yyyydate_entered != date_format(entered_date, '%Y');
update events set updated_date=str_to_date(concat_ws('', yyyydate_updated, lpad(ifnull(mmdate_updated,'01'),2,'0'), lpad(ifnull(dddate_updated,'01'),2,'0')), '%Y%m%d') where yyyydate_updated != date_format(updated_date, '%Y');
update events set last_date=str_to_date(concat_ws('', yyyylast_date, lpad(ifnull(mmlast_date,'01'),2,'0'), lpad(ifnull(ddlast_date,'01'),2,'0')), '%Y%m%d') where yyyylast_date != date_format(last_date, '%Y');
update events set opening_night_date=str_to_date(concat_ws('', yyyyopening_night, lpad(ifnull(mmopening_night,'01'),2,'0'), lpad(ifnull(ddopening_night,'01'),2,'0')), '%Y%m%d') where yyyyopening_night != date_format(opening_night_date, '%Y');

update contributor set date_of_birth=str_to_date(concat_ws('', yyyydate_of_birth, lpad(ifnull(mmdate_of_birth,'01'),2,'0'), lpad(ifnull(dddate_of_birth,'01'),2,'0')), '%Y%m%d') where yyyydate_of_birth != date_format(date_of_birth, '%Y');
update contributor set date_of_death=str_to_date(concat_ws('', yyyydate_of_death, lpad(ifnull(mmdate_of_death,'01'),2,'0'), lpad(ifnull(dddate_of_death,'01'),2,'0')), '%Y%m%d') where yyyydate_of_death != date_format(date_of_death, '%Y');

update item set created_date=str_to_date(concat_ws('', yyyycreated_date, lpad(ifnull(mmcreated_date,'01'),2,'0'), lpad(ifnull(ddcreated_date,'01'),2,'0')), '%Y%m%d') where yyyycreated_date != date_format(created_date, '%Y');
update item set copyright_date=str_to_date(concat_ws('', yyyycopyright_date, lpad(ifnull(mmcopyright_date,'01'),2,'0'), lpad(ifnull(ddcopyright_date,'01'),2,'0')), '%Y%m%d') where yyyycopyright_date != date_format(copyright_date, '%Y');
update item set issued_date=str_to_date(concat_ws('', yyyyissued_date, lpad(ifnull(mmissued_date,'01'),2,'0'), lpad(ifnull(ddissued_date,'01'),2,'0')), '%Y%m%d') where yyyyissued_date != date_format(issued_date, '%Y');
update item set accessioned_date=str_to_date(concat_ws('', yyyyaccessioned_date, lpad(ifnull(mmaccessioned_date,'01'),2,'0'), lpad(ifnull(ddaccessioned_date,'01'),2,'0')), '%Y%m%d') where yyyyaccessioned_date != date_format(accessioned_date, '%Y');
update item set terminated_date=str_to_date(concat_ws('', yyyyterminated_date, lpad(ifnull(mmterminated_date,'01'),2,'0'), lpad(ifnull(ddterminated_date,'01'),2,'0')), '%Y%m%d') where yyyyterminated_date != date_format(terminated_date, '%Y');

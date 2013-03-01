delimiter |

create PROCEDURE recreateAllItemCitations() deterministic
begin
 update item set citation=`fn_get_citation`(itemid) where itemid!=145;
 commit;
end;

|

create PROCEDURE set_new_item_titles() deterministic
begin

 declare l_title varchar(4000) default '';
 declare l_citation varchar(4000) default '';
 declare l_itemid long;
 
 declare c1_itemid long;
 declare c1_eventName varchar(1000) default '';
 
 DECLARE no_more_rows BOOLEAN;
 
 declare c_items CURSOR for
 select distinct itemevlink.itemid, events.event_name as event_name
 from itemevlink, events, item
 where itemevlink.eventid=events.eventid
 and itemevlink.itemid=item.itemid
 and item.TITLE is null
 order by itemid;


DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;

 set l_itemid = 0;
 
 the_loop:LOOP

 FETCH c_items
 INTO c1_itemid, c1_eventName;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
if l_itemid != c1_itemid then
 set l_title = fn_get_new_item_title(c1_itemid); 
 if Length(l_title) > 300 then
 set l_title = substr(l_title, 0, 300);
 end if;
 set l_citation = fn_get_citation(c1_itemid);
 update item set title=l_title, citation=l_citation where itemid=c1_itemid;
 commit;
 end if;
 set l_itemid = c1_itemid;
 
 commit;
 END LOOP the_loop;


END;




|


create PROCEDURE FILL_VENUE_SEARCH_TABLE() deterministic
BEGIN
 delete from search_venue;
 truncate table search_venue;
 insert into search_venue(
 select distinct venueid, venue_name,
 '' as venue_other_name1,
 '' as venue_other_name2,
 '' as venue_other_name3,
 street, suburb,
 venue.state, web_links,
 if(states.state='O/S', country.countryname, states.state) as venue_state,
 lcase(concat_ws(' ', venueid, venue_name, suburb, if(states.state='O/S', country.countryname, states.state))) as combined_all,
 fn_Venue_Has_Item(venueid) as resource_flag
 from venue
 left join states on states.stateid=venue.state
 left join country on country.countryid = venue.countryid);
END;




|


create PROCEDURE FILL_RESOURCE_SEARCH_TABLE() deterministic

BEGIN
 


-- remove contents of table (do it twice because of index problems)
DELETE FROM search_resource;
TRUNCATE TABLE search_resource;

 -- insert results from resource query into table
insert into SEARCH_RESOURCE (ITEMID,ITEM_SUB_TYPE_LOV_ID,ITEM_SUB_TYPE,TITLE,TITLE_ALTERNATIVE,COMBINED_ALL,
CITATION,COPYRIGHT_DATE,ISSUED_DATE,ACCESSIONED_DATE,INSTITUTIONID,SOURCEID,CREATED_DATE,CITATION_DATE,SOURCE_CITATION, ITEM_URL)
(
SELECT 
 item.itemid,
 item.ITEM_SUB_TYPE_LOV_ID,
 item_sub_type.description,
 item.title,
 item.title_alternative,
 lcase(left(concat_ws(' ', item.itemid, item_sub_type.description, item.TITLE, item.TITLE_ALTERNATIVE, contributor.FIRST_NAME, contributor.LAST_NAME, organisation.NAME, events.EVENT_NAME, venue.VENUE_NAME, work.WORK_TITLE, contentindicator.CONTENTINDICATORDESCRIPTION, secgenreclass.GENRECLASS, item.DESCRIPTION_ABSTRACT),4000)) AS combined_all,
 item.citation,
 item.COPYRIGHT_DATE,
 item.ISSUED_DATE,
 item.ACCESSIONED_DATE,
 item.INSTITUTIONID,
 item.sourceid,
 item.CREATED_DATE,
 str_to_date(fn_get_citation_date_full(item.yyyyissued_date, item.mmissued_date, item.ddissued_date, item.yyyycreated_date, item.mmcreated_date, item.ddcreated_date, item.yyyycopyright_date, item.mmcopyright_date, item.ddcopyright_date), '%d %M %Y') AS citation_date,
 source.citation AS SOURCE_CITATION,
 item.ITEM_URL
FROM
 item
LEFT OUTER JOIN lookup_codes item_sub_type on item.item_sub_type_lov_id = item_sub_type.code_lov_id
LEFT OUTER JOIN itemconlink on item.itemid = itemconlink.itemid
left outer JOIN item source on item.sourceid = source.itemid
left outer join contributor on itemconlink.CONTRIBUTORID = contributor.CONTRIBUTORID
left outer join itemorglink on item.itemid = itemorglink.itemid
left outer JOIN organisation on itemorglink.ORGANISATIONID = organisation.ORGANISATIONID
left outer join itemevlink on item.itemid = itemevlink.itemid
left outer join events on itemevlink.eventid = events.EVENTID
left outer join itemvenuelink on item.itemid = itemvenuelink.itemid
left outer join venue on itemvenuelink.VENUEID = venue.VENUEID
left outer join itemworklink on item.itemid = itemworklink.ITEMID
left outer join work on itemworklink.WORKID = work.workid
left outer join itemcontentindlink on item.itemid = itemcontentindlink.itemid
left outer join contentindicator on itemcontentindlink.CONTENTINDICATORID = contentindicator.CONTENTINDICATORID
left outer join itemsecgenrelink on item.itemid = itemsecgenrelink.itemid
left outer join secgenreclass on itemsecgenrelink.SECGENREPREFERREDID = secgenreclass.SECGENREPREFERREDID
);


END;





|



create PROCEDURE FILL_ORGANISATION_SEARCH_TABLE() deterministic
BEGIN
 delete from search_organisation;
 truncate table search_organisation;
 insert into search_organisation(
select distinct organisationid, name, address, suburb, web_links,
'' as org_other_name1,
'' as org_other_name2,
'' as org_other_name3,
states.state as org_state,
lcase(concat_ws(' ', organisationid, name)) as combined_all
,fn_Organisation_Has_Item(organisationid) as resource_flag
from organisation, states
where
organisation.state=states.stateid);
END;



|



create PROCEDURE  FILL_EVENT_SEARCH_TABLE() deterministic
BEGIN 
 delete from search_event; 
 truncate table search_event;
 
 insert into search_event( 
 
 select distinct events.eventid, event_name, umbrella, events.venueid as event_venueid, contentindicator, 
 description, further_information, 
 first_date, venue_name,  if(states.state='O/S', country.countryname, states.state) as venue_state, venue.suburb, 
 prigenreclass.genreclass as primary_genre, 
 secgenreclass.genreclass as secondary_genre, 
 lcase(concat_ws(' ', events.eventid, event_name, venue_name, umbrella, contentindicator, description, further_information, prigenreclass.genreclass, secgenreclass.genreclass)) as combined_all ,
 fn_event_has_item(events.eventid) as resource_flag
FROM
 events
 LEFT OUTER JOIN contentindicator ON (contentindicator.contentindicatorid = events.content_indicator)
 LEFT OUTER JOIN prigenreclass ON (events.primary_genre = prigenreclass.genreclassid)
 LEFT OUTER JOIN secgenreclasslink ON (events.eventid = secgenreclasslink.eventid)
 LEFT OUTER JOIN secgenreclass ON (secgenreclasslink.secgenrepreferredid = secgenreclass.secgenrepreferredid)
 Inner JOIN venue ON (events.venueid = venue.venueid)
 LEFT OUTER JOIN states ON (venue.state = states.stateid)
 left join country on country.countryid = venue.countryid
); 
END;

|


create PROCEDURE FILL_CONTRIBUTOR_SEARCH_TABLE() deterministic
BEGIN
set session sql_mode = 'ORACLE';


DELETE FROM search_contributor;
TRUNCATE TABLE search_contributor;

drop table if exists resource_flags;

create temporary table resource_flags
select itemconlink.contributorid contributorid, IF(min(item.itemid) is not NULL, 'ONLINE', 'Y') flag 
  from itemconlink
  left join item on item.itemid = itemconlink.itemid and item.item_url is not null
  left join item item2 on item2.itemid = itemconlink.itemid
  group by itemconlink.contributorid;
  

ALTER TABLE resource_flags
    ADD INDEX(contributorid);

insert into search_contributor(CONTRIBUTORID,LAST_NAME,FIRST_NAME,CONTRIB_GENDER,NATIONALITY,CONTRIB_STATE,DATE_OF_BIRTH,
CONTRIB_NAME,COMBINED_ALL,YYYYDATE_OF_DEATH,YYYYDATE_OF_BIRTH,DATE_OF_BIRTH_STR,DATE_OF_DEATH_STR,EVENT_DATES,RESOURCE_FLAG)
(
select contributor.contributorid, contributor.last_name, contributor.first_name,
 gendermenu.gender as contrib_gender, contributor.nationality,
 states.state as contrib_state, 
 STR_TO_DATE(concat(
 CASE WHEN DDDATE_OF_BIRTH = '' OR DDDATE_OF_BIRTH IS NULL THEN '01' ELSE DDDATE_OF_BIRTH END, '/', 
 CASE WHEN MMDATE_OF_BIRTH = '' OR MMDATE_OF_BIRTH IS NULL THEN '01' ELSE MMDATE_OF_BIRTH END, '/', 
 trim(CASE WHEN YYYYDATE_OF_BIRTH = '' THEN null ELSE YYYYDATE_OF_BIRTH END)
 ), '%d/%m/%Y') as date_of_birth,
 concat(first_name,' ',last_name) as contrib_name,
 lcase(concat(first_name,' ',ifnull(last_name,''))) as combined_all,
 CASE WHEN YYYYDATE_OF_DEATH = '' THEN null ELSE YYYYDATE_OF_DEATH END as YYYYDATE_OF_DEATH, 
 CASE WHEN YYYYDATE_OF_BIRTH = '' THEN null ELSE YYYYDATE_OF_BIRTH END as YYYYDATE_OF_BIRTH,
 concat(ifnull(trim(DDDATE_OF_BIRTH),''), if (strcmp(ifnull(trim(DDDATE_OF_BIRTH),''), ''), concat('/', ifnull(trim(MMDATE_OF_BIRTH),'')), ifnull(trim(MMDATE_OF_BIRTH),'')), if (strcmp(ifnull(trim(MMDATE_OF_BIRTH), ''),''), concat('/', trim(CASE WHEN YYYYDATE_OF_BIRTH = '' THEN null ELSE YYYYDATE_OF_BIRTH END)), trim(CASE WHEN YYYYDATE_OF_BIRTH = '' THEN null ELSE YYYYDATE_OF_BIRTH END))) as date_of_birth_str,
 concat(ifnull(trim(DDDATE_OF_DEATH),''), if (strcmp(ifnull(trim(DDDATE_OF_DEATH),''), ''), concat('/', ifnull(trim(MMDATE_OF_DEATH),'')), ifnull(trim(MMDATE_OF_DEATH),'')), if (strcmp(ifnull(trim(MMDATE_OF_DEATH), ''),''), concat('/', trim(CASE WHEN YYYYDATE_OF_DEATH = '' THEN null ELSE YYYYDATE_OF_DEATH END)), trim(CASE WHEN YYYYDATE_OF_DEATH = '' THEN null ELSE YYYYDATE_OF_DEATH END))) as date_of_death_str,
 CASE WHEN max(CASE WHEN YYYYFIRST_DATE = '' THEN null ELSE YYYYFIRST_DATE END) = min(CASE WHEN YYYYFIRST_DATE = '' THEN null ELSE YYYYFIRST_DATE END) THEN  (min(CASE WHEN YYYYFIRST_DATE = '' THEN null ELSE YYYYFIRST_DATE END))   ELSE   (CONCAT(min(CASE WHEN YYYYFIRST_DATE = '' THEN null ELSE YYYYFIRST_DATE END), ' - ', max(CASE WHEN YYYYFIRST_DATE = ''  THEN null ELSE YYYYFIRST_DATE END)))  END AS EVENT_DATES,
 ifnull(resource_flags.flag, 'N') as resource_flag

from
contributor

left join states on contributor.state=states.stateid
left join conevlink on contributor.contributorid = conevlink.contributorid
left join events ON conevlink.eventid = events.eventid
left join gendermenu on contributor.gender=gendermenu.genderid
left join resource_flags on resource_flags.contributorid = contributor.contributorid

group by contributor.contributorid
 ) ;

END;


|



create PROCEDURE FILL_ALL_SEARCH_TABLE()  deterministic
Begin 

drop table if exists event_contribs;
create temporary table event_contribs
select conevlink.eventid eventid, concat_ws(' ', contributor.first_name, contributor.last_name) contributorname, conevlink.function function
  from conevlink
  inner join contributor on conevlink.contributorid = contributor.contributorid;

ALTER TABLE event_contribs
    ADD INDEX(eventid);

-- DROP INDEX search_all_resource_flag on search_all;

TRUNCATE TABLE search_all;


Insert into search_all (eventid, event_name, first_date, venue_name, 
 suburb, state, venue_state, resource_flag, combined_all) (

SELECT 
 events.eventid,
 events.event_name,
 events.first_date,
 venue.venue_name,
 venue.suburb,
 venue.state,
 if(states.state='O/S', country.countryname, states.state) as state,
 fn_event_has_item(events.eventid),
 lower(left(concat_ws(' ',
 events.eventid,
 events.event_name,
 events.umbrella,
 events.description,
 events.further_information,
 group_concat(distinct concat_ws(' ', venue.venueid, venue.venue_name, venue.suburb, venue.state, '' )) ,
 group_concat(distinct event_contribs.contributorname),
 contentindicator.contentindicator, 
 group_concat(distinct concat_ws(' ', prigenreclass.genreclass, secgenreclass.genreclass, '')),
 contfunct.contfunction,
 group_concat(distinct concat_ws(' ', organisation.organisationid, organisation.name, ''))
 ), 3999))
FROM
 events
 inner JOIN venue ON (events.venueid = venue.venueid)
 LEFT OUTER JOIN states ON (states.stateid = venue.state)
 LEFT JOIN country ON (country.countryid = venue.countryid)
 LEFT OUTER JOIN contentindicator ON (contentindicator.contentindicatorid = events.content_indicator)
 Left outer join event_contribs on events.eventid = event_contribs.eventid
 LEFT OUTER JOIN contfunct ON (event_contribs.`function` = contfunct.contfunctionid)
 LEFT OUTER JOIN orgevlink ON (events.eventid = orgevlink.eventid)
 left join secgenreclasslink on (events.eventid =secgenreclasslink.eventid)
 left JOIN secgenreclass ON (secgenreclasslink.secgenrepreferredid = secgenreclass.secgenrepreferredid)
 Left Outer join prigenreclass on (events.primary_genre=prigenreclass.genreclassid)
 Left outer join organisation on (orgevlink.organisationid=organisation.organisationid)
 

group by events.eventid

);
 
-- create index search_all_resource_flag on search_all(RESOURCE_FLAG) using btree;

end;



|


create PROCEDURE FILL_WORK_SEARCH_TABLE() deterministic
BEGIN
	delete from search_work;
	truncate table search_work;
	insert into search_work(

		SELECT 
		work.WORKID,
		work.WORK_TITLE,
		work.ALTER_WORK_TITLE,
		LOWER(left(CONCAT_WS(' ', 
			work.WORK_TITLE, 
			work.ALTER_WORK_TITLE
		) , 3999)) as COMBINED_ALL

		from WORK

		left join WORKCONLINK on work.WORKID = WORKCONLINK.WORKID
		left join CONTRIBUTOR on WORKCONLINK.CONTRIBUTORID = CONTRIBUTOR.CONTRIBUTORID

		left join WORKORGLINK on work.WORKID = WORKORGLINK.WORKID
		left join ORGANISATION on WORKORGLINK.ORGANISATIONID = ORGANISATION.ORGANISATIONID

		left join EVENTWORKLINK on work.WORKID = EVENTWORKLINK.WORKID
		left join EVENTS on EVENTWORKLINK.EVENTID = EVENTS.EVENTID

		group by work.workid
	 
	);
END;


|


delimiter ;

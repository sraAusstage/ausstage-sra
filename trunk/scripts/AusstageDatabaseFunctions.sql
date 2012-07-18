delimiter |



create FUNCTION fn_get_month_as_string(l_month varchar(3)) returns varchar(10) deterministic
  -- Returns the month as a three character string
  -- eg 01 or 1 is 'Jan'

BEGIN
  IF l_month = '01' OR l_month = '1' OR l_month = 'Jan' THEN
    return 'January';
  ELSEIF l_month = '02' OR l_month = '2' OR l_month = 'Feb' THEN
    return 'February';
  ELSEIF l_month = '03' OR l_month = '3' OR l_month = 'Mar' THEN
    return 'March';
  ELSEIF l_month = '04' OR l_month = '4' OR l_month = 'Apr' THEN
    return 'April';
  ELSEIF l_month = '05' OR l_month = '5' OR l_month = 'May' THEN
    return 'May';
  ELSEIF l_month = '06' OR l_month = '6' OR l_month = 'Jun' THEN
    return 'June';
  ELSEIF l_month = '07' OR l_month = '7' OR l_month = 'Jul' THEN
    return 'July';
  ELSEIF l_month = '08' OR l_month = '8' OR l_month = 'Aug' THEN
    return 'August';
  ELSEIF l_month = '09' OR l_month = '9' OR l_month = 'Sep' THEN
    return 'September';
  ELSEIF l_month = '10' OR l_month = 'Oct' THEN
    return 'October';
  ELSEIF l_month = '11' OR l_month = 'Nov' THEN
    return 'November';
  ELSEIF l_month = '12' OR l_month = 'Dec' THEN
    return 'December';
  END IF;
  return null;
END
|










CREATE FUNCTION 
fn_get_citation_date 
(yyyyissued_date varchar(4),    mmissued_date varchar(3),    ddissued_date varchar(2),
 yyyycreated_date varchar(4),   mmcreated_date varchar(3),   ddcreated_date varchar(2),
 yyyycopyright_date varchar(4), mmcopyright_date varchar(3), ddcopyright_date varchar(2))
returns varchar(20) deterministic

  -- Returns the date to be included in the citation for the given item/resource
  -- Date of issue dd,mm,yyyy, if date of issue is not available then Creation Date dd, mm, yyyy
  -- if Creation Date is not available then Date of Copyright dd,mm,yyyy

BEGIN

 declare l_date varchar(20) default '';
set l_date = null;
if yyyyissued_date is null then
	if yyyycreated_date is null then
		if yyyycopyright_date is not null then
			set l_date = concat_ws(' ', TRIM(LEADING '0' FROM ddcopyright_date), fn_get_month_as_string(mmcopyright_date), yyyycopyright_date);
        end if;
	else
		set l_date = concat_ws(' ', TRIM(LEADING '0' FROM ddcreated_date), fn_get_month_as_string(mmcreated_date), yyyycreated_date);
    end if;
 else
	set l_date = concat_ws(' ', TRIM(LEADING '0' FROM ddissued_date), fn_get_month_as_string(mmissued_date), yyyyissued_date);
 end if;

 return trim(l_date);
END






|





CREATE FUNCTION 
fn_get_citation_date_full
(yyyyissued_date varchar(4),    mmissued_date varchar(3),    ddissued_date varchar(2),
 yyyycreated_date varchar(4),   mmcreated_date varchar(3),   ddcreated_date varchar(2),
 yyyycopyright_date varchar(4), mmcopyright_date varchar(3), ddcopyright_date varchar(2))
returns varchar(20) deterministic

BEGIN

declare l_date varchar(20) default '';

 set l_date = fn_get_citation_date(yyyyissued_date, mmissued_date, ddissued_date,
 yyyycreated_date, mmcreated_date, ddcreated_date,
 yyyycopyright_date, mmcopyright_date, ddcopyright_date);
 
 
 if length(l_date)<=4 then
 -- Add month and day
 set l_date = concat('1 January ', l_date);
 elseif l_date regexp '^[A-Z]' then
 -- Add day
 set l_date = concat('1 ', l_date);
 end if;
 
 return l_date;
END;







|

create FUNCTION fn_get_new_item_title(l_item_id long) returns varchar(4000) deterministic


BEGIN
DECLARE no_more_rows BOOLEAN;
 DECLARE loop_cntr INT DEFAULT 0;
 DECLARE num_rows INT DEFAULT 0;

declare l_title varchar(4000) DEFAULT ''; 
declare evID long;
declare title varchar(4000) default '';
declare c_items CURSOR for
 select distinct itemevlink.itemid, events.event_name as event_name
 from itemevlink, events
 where itemevlink.eventid=events.eventid
 and itemevlink.itemid = l_item_id;

DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;


 the_loop:LOOP

 FETCH c_items
 INTO evID, title;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
 if Length(l_title) >= 1 then
 set l_title = concat(l_title, '; ');
 end if;
 set l_title = concat(l_title, title);

 END LOOP the_loop;

 return l_title;
END;



|



create FUNCTION fn_Contributor_Has_Item(l_contributor_id long) returns varchar(6) deterministic
  -- Returns 'Y' or 'N' if the event has a item (resource association)
  -- If the event does have any resource associations, and there is an
  -- URL for one of these (online) then return 'ONLINE'


BEGIN
DECLARE no_more_rows BOOLEAN;
DECLARE loop_cntr INT DEFAULT 0;
DECLARE num_rows INT DEFAULT 0;

declare l_title varchar(4000) DEFAULT ''; 
declare itemID long;
declare itemURL varchar(4000) default '';

declare l_result varchar(6) DEFAULT 'N';

declare c_items CURSOR for
 select item.ITEMID as itemid, item.ITEM_URL
 from ITEMCONLINK, item
 where ITEMCONLINK.ContributorID = l_Contributor_id
 and item.ITEMID=ITEMCONLINK.ITEMID;
 

DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;


 the_loop:LOOP

 FETCH c_items
 INTO itemID, itemURL;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
 set l_result = 'Y';
 if itemURL is not null then
 return 'ONLINE';
 end if;

 END LOOP the_loop;

 return l_result;
END;





|







create FUNCTION fn_Event_Has_Item(l_event_id long) returns varchar(6) deterministic
  -- Returns 'Y' or 'N' if the event has a item (resource association)
  -- If the event does have any resource associations, and there is an
  -- URL for one of these (online) then return 'ONLINE'


BEGIN
DECLARE no_more_rows BOOLEAN;
DECLARE loop_cntr INT DEFAULT 0;
DECLARE num_rows INT DEFAULT 0;

declare l_title varchar(4000) DEFAULT ''; 
declare itemID long;
declare itemURL varchar(4000) default '';

declare l_result varchar(6) DEFAULT 'N';

declare c_items CURSOR for
 select item.ITEMID as itemid, item.ITEM_URL
 from itemevlink, item
 where itemevlink.eventid = l_event_id
 and item.ITEMID=itemevlink.ITEMID;
 

DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;


 the_loop:LOOP

 FETCH c_items
 INTO itemID, itemURL;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
 set l_result = 'Y';
 if itemURL is not null then
 return 'ONLINE';
 end if;

 END LOOP the_loop;

 return l_result;
END;







|



create FUNCTION fn_Organisation_Has_Item(l_organisation_id long) returns varchar(6) deterministic
  -- Returns 'Y' or 'N' if the event has a item (resource association)
  -- If the event does have any resource associations, and there is an
  -- URL for one of these (online) then return 'ONLINE'


BEGIN
DECLARE no_more_rows BOOLEAN;
DECLARE loop_cntr INT DEFAULT 0;
DECLARE num_rows INT DEFAULT 0;

declare l_title varchar(4000) DEFAULT ''; 
declare itemID long;
declare itemURL varchar(4000) default '';

declare l_result varchar(6) DEFAULT 'N';

declare c_items CURSOR for
 select item.ITEMID as itemid, item.ITEM_URL
 from ITEMORGLINK, item
 where ITEMORGLINK.ORGANISATIONID = l_organisation_id
 and item.ITEMID=ITEMORGLINK.ITEMID;
 

DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;


 the_loop:LOOP

 FETCH c_items
 INTO itemID, itemURL;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
 set l_result = 'Y';
 if itemURL is not null then
 return 'ONLINE';
 end if;

 END LOOP the_loop;

 return l_result;
END;








|

create FUNCTION fn_Venue_Has_Item(l_venue_id long) returns varchar(6) deterministic
  -- Returns 'Y' or 'N' if the event has a item (resource association)
  -- If the event does have any resource associations, and there is an
  -- URL for one of these (online) then return 'ONLINE'


BEGIN
DECLARE no_more_rows BOOLEAN;
DECLARE loop_cntr INT DEFAULT 0;
DECLARE num_rows INT DEFAULT 0;

declare l_title varchar(4000) DEFAULT ''; 
declare itemID long;
declare itemURL varchar(4000) default '';

declare l_result varchar(6) DEFAULT 'N';

declare c_items CURSOR for
 select item.ITEMID as itemid, item.ITEM_URL
 from ITEMVENUELINK, item
 where ITEMVENUELINK.VENUEID = l_venue_id
 and item.ITEMID=ITEMVENUELINK.ITEMID;
 

DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;

open c_items;


 the_loop:LOOP

 FETCH c_items
 INTO itemID, itemURL;

 IF no_more_rows THEN
 CLOSE c_items;
 LEAVE the_loop;
 END IF;
 
 set l_result = 'Y';
 if itemURL is not null then
 return 'ONLINE';
 end if;

 END LOOP the_loop;

 return l_result;
END;



|





create FUNCTION fn_get_citation(l_item_id long) returns varchar(4000) deterministic
  -- Returns the citation for the given item/resource
  -- The citation is in the format
  -- Resource Sub Type- Contributor Creator Names 1, 2, 3 etc, Organisation Creator Names, 1,2,3 etc,
  -- Title, Source, (Resource Title), Publisher, Publisher Location, Holding Institution, Volume,
  -- Issue, Date of issue dd,mm,yyyy, if date of issue is not available then Creation Date dd, mm, yyyy
  -- if Creation Date is not available then Date of Copyright dd,mm,yyyy, Page
BEGIN
DECLARE no_more_rows BOOLEAN;

declare l_data varchar(4000) default '';
declare l_citation varchar(4000);
declare l_resource_subtype varchar(400) default '';
declare l_title varchar(400) default '';
declare l_source_title varchar(400) default '';
declare l_publisher varchar(500) default '';
declare l_publisher_loc varchar(500) default '';
declare l_ddissued_date varchar(500) default '';
declare l_mmissued_date varchar(500) default '';
declare l_yyyyissued_date varchar(500) default '';
declare l_ddcreated_date varchar(500) default '';
declare l_mmcreated_date varchar(500) default '';
declare l_yyyycreated_date varchar(500) default '';
declare l_ddcopyright_date varchar(500) default '';
declare l_mmcopyright_date varchar(500) default '';
declare l_yyyycopyright_date varchar(500) default '';
declare l_PUBLISHER_LOCATION varchar(500) default '';
declare l_VOLUME varchar(500) default '';
declare l_ISSUE varchar(500) default '';
declare l_PAGE varchar(500) default '';
declare l_institution varchar(500) default '';
declare l_date varchar(500) default '';
 
declare l_res_part_length long;
 
declare c_contributor CURSOR for 
 SELECT group_concat(distinct concat_ws(' ', c.FIRST_NAME, c.LAST_NAME) separator ', ') s_data
 FROM `contributor` c, ITEMCONLINK i
 WHERE c.CONTRIBUTORID = i.CONTRIBUTORID
 AND i.itemid = l_item_id and i.creator_flag ='Y'
 ORDER BY i.orderby;



declare c_organisation CURSOR for
 SELECT o.name s_data
 FROM organisation o, ITEMORGLINK i
 WHERE o.ORGANISATIONID = i.ORGANISATIONID
 AND i.itemid = l_item_id and i.creator_flag ='Y'
 ORDER BY i.orderby;


DECLARE CONTINUE HANDLER FOR NOT FOUND
 SET no_more_rows = TRUE;
 
 
 select 
if(lookup_codes.description='',null,lookup_codes.description),
if(item.title='',null,item.title), 
if(item.PUBLISHER='',null,item.PUBLISHER), 
if(item_source.title='',null,item_source.title), 
if(item.ddissued_date='',null,item.ddissued_date), 
if(fn_get_month_as_string(item.mmissued_date)='',null,(item.mmissued_date)) as mmissued_date,
if(item.yyyyissued_date='',null,item.yyyyissued_date),
if(item.ddcreated_date='',null,item.ddcreated_date),
if(fn_get_month_as_string(item.mmcreated_date)='',null,(item.mmcreated_date)) as mmcreated_date,
if(item.yyyycreated_date='',null,item.yyyycreated_date),
if(item.ddcopyright_date='',null,item.ddcopyright_date),
if(fn_get_month_as_string(item.mmcopyright_date)='',null,(item.mmcopyright_date)) as mmcopyright_date, 
if(item.yyyycopyright_date='',null,item.yyyycopyright_date),
if(item.PUBLISHER_LOCATION='',null,item.PUBLISHER_LOCATION),
if(item.VOLUME='',null,item.VOLUME), 
if(item.ISSUE='',null,item.ISSUE),
if(item.PAGE='',null,item.PAGE),
if(organisation.name='',null,organisation.name)
 into l_resource_subtype, l_title, l_publisher, l_source_title, l_ddissued_date, l_mmissued_date,l_yyyyissued_date,
 l_ddcreated_date, l_mmcreated_date,l_yyyycreated_date,l_ddcopyright_date, l_mmcopyright_date,l_yyyycopyright_date,
 l_PUBLISHER_LOCATION, l_VOLUME, l_ISSUE,l_PAGE, l_institution
 FROM
 item
 LEFT OUTER JOIN organisation ON (item.institutionid = organisation.organisationid)
 LEFT OUTER JOIN item item_source ON (item.sourceid = item_source.itemid)
 INNER JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id)
WHERE
 item.itemid=l_item_id;

 -- Citation added at end of function
 

open c_contributor;
the_loop:LOOP

 FETCH c_contributor
 INTO l_data;

 IF no_more_rows THEN
 CLOSE c_contributor;
 LEAVE the_loop;
 END IF;
 
 set l_citation = if(l_data='',null,l_data);

 END LOOP the_loop;

 set no_more_rows = FALSE;

 open c_organisation;
the_loop2:LOOP

 FETCH c_organisation
 INTO l_data;

 IF no_more_rows THEN
 CLOSE c_organisation;
 LEAVE the_loop2;
 END IF;
 
 set l_citation = if(l_data='',l_citation,concat_ws(', ', l_citation, l_data));

 END LOOP the_loop2;

 

 set l_date = fn_get_citation_date(l_yyyyissued_date, l_mmissued_date, l_ddissued_date,
 l_yyyycreated_date, l_mmcreated_date, l_ddcreated_date,
 l_yyyycopyright_date, l_mmcopyright_date, l_ddcopyright_date);
 
 set l_citation = concat_ws(', ', l_citation, l_title, l_source_title, l_publisher, l_publisher_location, l_institution, l_volume, l_issue, l_date, l_page);
 
-- if l_resource_subtype is not null then
--  if Length(l_citation) >= 1 then
--  set l_citation = concat(l_resource_subtype, ': ', l_citation);
--  else
--  set l_citation = l_resource_subtype;
--  end if;
-- end if;
 

-- Publisher Location, Holding Institution, 
-- Volume, Issue, Date of issue dd,mm,yyyy, 
-- if date of issue is not available then Creation Date dd, mm, yyyy 
-- if Creation Date is not available then Date of Copyright dd,mm,yyyy,
-- Page

 return l_citation;
END

|

CREATE FUNCTION `fn_xml_escape`( tag_value VARCHAR(2000))
RETURNS varchar(2000) deterministic 
BEGIN
IF (tag_value IS NULL) THEN
RETURN null;
END IF;
RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
tag_value,'&','&amp;'),
'<','&lt;'),
'>','&gt;'),
'"','&quot;'),
'\'','&apos;');
END 

|

CREATE FUNCTION `fn_xml_attr`(tag_name VARCHAR(2000),
tag_value VARCHAR(2000))
RETURNS varchar(2000) deterministic
BEGIN
IF (tag_value IS NULL) THEN
RETURN null;
END IF;
RETURN CONCAT(' ', tag_name ,'="',fn_xml_escape(tag_value),'" ');
END 

|
CREATE FUNCTION `fn_xml_tag`(tag_name VARCHAR(2000),
tag_value VARCHAR(2000),
attrs VARCHAR(2000), 
subtags VARCHAR(2000)) 
RETURNS varchar(2000) deterministic
BEGIN
DECLARE result VARCHAR(2000);
SET result = CONCAT('<' , tag_name);
IF attrs IS NOT NULL THEN
SET result = CONCAT(result,' ', attrs);
END IF;
IF (tag_value IS NULL AND subtags IS NULL) THEN
RETURN CONCAT(result,' />');
END IF;
RETURN CONCAT(result ,'>',ifnull(fn_xml_escape(tag_value),''),
ifnull(subtags,''),'</',tag_name, '>');
END 

|

delimiter ;

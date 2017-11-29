-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`%` FUNCTION `fn_get_group_concat_contributor`(l_exhibitionid_id long) RETURNS varchar(200) CHARSET utf8
BEGIN
	declare l_DISPLAY_NAME varchar(500) default '';

	select GROUP_CONCAT(display_name) from ausstage_schema.contributor into l_DISPLAY_NAME
	where contributorid in (select contributorid from ausstage_schema.exhibition_section where exhibitionid = l_exhibitionid_id);
	
	return l_DISPLAY_NAME;
END


delimiter $$

CREATE FUNCTION `fn_get_group_concat_contributor`(l_exhibitionid_id long) RETURNS varchar(200) CHARSET utf8
READS SQL DATA
DETERMINISTIC
BEGIN
	declare l_DISPLAY_NAME varchar(500) default '';

	select GROUP_CONCAT(display_name) from contributor 
	where contributorid in (select contributorid from exhibition_section where exhibitionid = l_exhibitionid_id) into l_DISPLAY_NAME;
	
	return l_DISPLAY_NAME;
END$$

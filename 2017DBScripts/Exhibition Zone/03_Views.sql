delimiter $$

CREATE 
VIEW `exhibitions` 
AS select `e`.`exhibitionid` AS `exhibitionid`,
`e`.`name` AS `name`,
`e`.`description` AS `description`,
`e`.`published_flag` AS `published_flag`,
`e`.`owner` AS `owner`,`e`.`entered_by_user` AS `entered_by_user`,
`e`.`entered_date` AS `entered_date`,
`e`.`updated_by_user` AS `updated_by_user`,
`e`.`updated_date` AS `updated_date`,
`fn_get_group_concat_contributor`(`e`.`exhibitionid`) AS `fn_get_group_concat_contributor(exhibitionid)` from `exhibition` `e`
$$

	
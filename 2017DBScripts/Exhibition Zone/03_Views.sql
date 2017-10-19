CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`%` 
    SQL SECURITY DEFINER
VIEW ausstage_schema.exhibitions AS
 select 
	e.*,
	fn_get_group_concat_contributor(exhibitionid)
	from ausstage_schema.exhibition e
	
	
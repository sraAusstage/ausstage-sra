--before running this script need to locate my.ini file in MySQL directory. 
-- add the following lines:
 
-- # disable stop words.
-- ft_stopword_file = ""

-- then restart the database

delimiter $$
repair table search_event;
repair table search_contributor;
repair table search_venue;
repair table search_organisation;
repair table search_all;
repair table search_all_new;
repair table search_resource;
repair table search_work;
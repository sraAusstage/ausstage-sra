#!/bin/bash
# This is a shell script to assist in migrating the AusStage database from Oracle to MySQL on a Unix-based system
# ./MigrateAusStage.sh export.sql

# Brett Eterovic-Soric (brett.eterovic-soric@sra.com.au)
# 06/09/2011 
MYSQLUSER="ausstage"
MYSQLPASS="arkaroo"
NEWSCHEMA="ausstage"
SQLFILE="export.sql"

cd "$(dirname "$0")"

#Turn off HTTP so it doesn't interfere with the import
sudo /etc/init.d/httpd stop
../apache-tomcat-6.0.32/bin/shutdown.sh
sudo /etc/init.d/mysqld restart

# Empty the specified schema in MySQL
echo "Removing Functions, Procedures and Views"
mysql -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA << EOF
DROP PROCEDURE IF EXISTS FILL_ALL_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_CONTRIBUTOR_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_EVENT_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_ORGANISATION_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_RESOURCE_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_VENUE_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS FILL_WORK_SEARCH_TABLE;
DROP PROCEDURE IF EXISTS recreateAllItemCitations;
DROP PROCEDURE IF EXISTS set_new_item_titles;
DROP PROCEDURE IF EXISTS tmp_ems_proc_123;

DROP FUNCTION IF EXISTS fn_Contributor_Has_Item;
DROP FUNCTION IF EXISTS fn_Event_Has_Item;
DROP FUNCTION IF EXISTS fn_get_citation;
DROP FUNCTION IF EXISTS fn_get_citation_date;
DROP FUNCTION IF EXISTS fn_get_citation_date_full;
DROP FUNCTION IF EXISTS fn_get_month_as_string;
DROP FUNCTION IF EXISTS fn_get_new_item_title;
DROP FUNCTION IF EXISTS fn_Organisation_Has_Item;
DROP FUNCTION IF EXISTS fn_Venue_Has_Item;

DROP FUNCTION IF EXISTS fn_xml_escape;
DROP FUNCTION IF EXISTS fn_xml_attr;
DROP FUNCTION IF EXISTS fn_xml_tag;

DROP VIEW IF EXISTS CON_VENUE_MIN_MAX_EVENT_DATES;
DROP VIEW IF EXISTS VENUE_MIN_MAX_EVENT_DATES;
DROP VIEW IF EXISTS ORG_VENUE_MIN_MAX_EVENT_DATES;

set foreign_key_checks=0;
EOF

echo "Removing Tables"
mysqldump -u$MYSQLUSER -p$MYSQLPASS --add-drop-table --no-data $NEWSCHEMA | grep ^DROP | mysql -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA

mysql -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA << EOF
ALTER DATABASE $NEWSCHEMA CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF

# Use the translator to port over most of the SQL and send it straight to the new database
echo "Converting exported SQL"
sed -f "ConvertSQLDeveloperExportToMySQL.sed" "$SQLFILE" > mysqlexport.sql

echo "Converting to UTF-8"
iconv -f ISO-8859-1 -t UTF-8 mysqlexport.sql > converted.sql

echo "Inserting..."
mysql --default-character-set=utf8 -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA << EOF
source converted.sql;
EOF

rm mysqlexport.sql
rm converted.sql

sleep 5
# Set the non-nulls and autoincrementing keys
echo "Custom Tweaks"
cat "CustomTweaks.sql" | mysql --default-character-set=utf8 -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA
echo "New Schema"
cat "NewSchema.sql" | mysql --default-character-set=utf8 -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA
echo "Functions"
cat "AusstageDatabaseFunctions.sql" | mysql --default-character-set=utf8 -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA
echo "Procedures"
cat "AusstageDatabaseProcedures.sql" | mysql --default-character-set=utf8 -u$MYSQLUSER -p$MYSQLPASS $NEWSCHEMA

#Reenable HTTP
../apache-tomcat-6.0.32/bin/startup.sh
sudo /etc/init.d/httpd start

# Sed Script to convert Oracle SQL statements as exported from Oracle SQL Developer to MySQL-compatible statements

#set sqldeveloper.conf to have a larger heap space (1500M works)
#open sqldev
#tools/export
#set as utf-8
#ddl option show schema
#uncheck all types but tables, views, constraints, data
#bring across all wanted tables


# Remove comments
/^--/d

s/EMPTY_CLOB()/''/g	


/^[ \t]*CREATE TABLE/,/) ;/ {
	# Convert Datatypes
	s/VARCHAR2/VARCHAR/g
	
	s/ NUMBER(\([0-9]\),0)/ INT(\1)/g
	s/ NUMBER(\([0-9][0-9][0-9]*\),0)/ BIGINT(\1)/g
	s/ NUMBER(\*,0)/ INT(11)/g
	s/ NUMBER/ INT(11)/g
	
	s/ CLOB/ LONGTEXT/g
	
	s/DEFAULT SYSDATE//g
	
	s/ CHAR(\([^ ]*\) CHAR)/ VARCHAR(\1)/g
	
	s/ FLOAT(\([0-9][0-9][0-9]*\))/ DECIMAL/g
	
	#Remove schema and extra quotes
	s/^\([ \t]*CREATE TABLE \)"[^"]*"\."\([^"]*\)"/\1`\2`/
	
	s/"\([^"]*\)"/`\1`/g 											#" (damn syntax highlighting)
	
}


/^REM /d

#Fix Timestamps
s/to_timestamp('\([0-9]*\)\/\([A-Z]*\)\/\([0-9]*\) \([0-9]*\):\([0-9]*\):\([0-9]*\).\([0-9]*\) \([AP]\)M','DD\/MON\/RR HH12:MI:SS.FF AM')/str_to_date('\1-\2-\3 \4:\5:\6\8M','%d-%b-%y %r')/g

s/\\&/\&/g
s/\\\\/\\/g
s/\\/\\\\/g

/^Insert into/ {
	#Fix schema
	s/^Insert into "*[^"\.]*"*\."*\([^" ]*\)"*/Insert into `\1` /
	
	# Add backticks to field names -- this needs to come last
	s/^\([^(]*(\)/\1`/
	s/,/`,`/g
	s/) values (/`)\n values(/
	P
	s/`,`/,/g
	D
}


/^[ \t]*ALTER TABLE/,/) ;/ {
	#quit - all this stuff should be in CustomTweaks.sql
	d
	q
	

	#Remove schema and extra quotes
	s/^\([ \t]*ALTER TABLE \)"[^"]*"\."\([^"]*\)"/\1`\2`/
	
	s/"\([^"]*\)"/`\1`/g 											#" (damn syntax highlighting)
	/NOT NULL/s/^/-- /
	s/CONSTRAINT .* PRIMARY KEY \(([^"]*)\) ENABLE/PRIMARY KEY \1/
	s/ENABLE//
}
#Remove schema and extra quotes
s/^\([ \t]*REFERENCES \)[^\.]*\./\1/

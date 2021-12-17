/***************************************************

Company: SRA
 Author: Brad Williams
Project: Ausstage

   File: SearchCount.java

Purpose: Provides count of search results for initial page. 
2015 migration to github
***************************************************/

package ausstage;

import admin.Common;
import ausstage.Database;
import java.sql.*;
import java.text.NumberFormat;

import sun.jdbc.rowset.*;
import java.lang.Character;
import java.util.Locale;
import java.util.Vector;
import java.util.GregorianCalendar;

  public class SearchCount {
	private Database m_db;
  	private admin.Common common = new admin.Common();
  	private String m_key_word = "";


  	public SearchCount(Database p_db) {
	  m_db = p_db;
  	}
  
  	public SearchCount(Database p_db,java.sql.Connection p_connection) {
	  m_db = p_db;
  	}
  	
  	/*******************
    GET FUNCTIONS
    *******************/
  	public CachedRowSet getEventCount(){
  	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM events WHERE "
  							+"LOWER(event_name) LIKE '"+m_db.plSqlSafeString(m_key_word)+"'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getEventCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);
  	}
  	
  	
  	public CachedRowSet getContributorCount(){
  	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM contributor WHERE "
  							+"CONCAT(LOWER(first_name),' ',LOWER(last_name)) LIKE '"+m_db.plSqlSafeString(m_key_word)+"'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getContributorCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);
  	}

  	
  	
  	public CachedRowSet getVenueCount(){
  	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM venue WHERE "
  							+"venue_name LIKE '"+m_db.plSqlSafeString(m_key_word)+"'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getVenueCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);
  		
  	}
  	
  	public CachedRowSet getOrganisationCount(){
  	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM organisation WHERE "
  							+"name LIKE '"+m_db.plSqlSafeString(m_key_word)+"'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getOrganisationCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);
  	}
  	
  	
  	public CachedRowSet getGenreCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT COUNT(*) From `secgenreclass` WHERE genreclass like '%"+m_db.plSqlSafeString(m_key_word)+"%'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getGenreCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);	
  	}
  	
  	public CachedRowSet getFunctionCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("select count(*) from (SELECT COUNT(*) From `contributorfunctpreferred` "+
  				"INNER JOIN contfunctlink ON (contributorfunctpreferred.contributorfunctpreferredid = contfunctlink.contributorfunctpreferredid) "+
  				"WHERE lcase(`contributorfunctpreferred`.`preferredterm`) LIKE '%" + m_db.plSqlSafeString(m_key_word) + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid`) a ");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getFunctionCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);	
  		
  	}

  	public CachedRowSet getSubjectCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  		
  		m_sql_string.append("SELECT COUNT(*) FROM (SELECT contentindicator.contentindicator,contentindicator.contentindicatorid, count(distinct events.eventid) eventnum, "+
  				"count(distinct itemcontentindlink.itemid) itemcount FROM contentindicator "+
  				"LEFT JOIN primcontentindicatorevlink on (contentindicator.contentindicatorid = primcontentindicatorevlink.primcontentindicatorid) " +
  				"LEFT JOIN events ON (primcontentindicatorevlink.eventid = events.eventid) "+
  				"LEFT JOIN itemcontentindlink ON (contentindicator.contentindicatorid = itemcontentindlink.contentindicatorid) "+
  				"WHERE lcase(contentindicator.contentindicator) LIKE '%" + m_db.plSqlSafeString(m_key_word) + "%' "+
  				"group by contentindicator.contentindicatorid) contentindicator WHERE contentindicator.eventnum > 0 or contentindicator.itemcount > 0 ");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getSubjectCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);		
  		
  	}

  	public CachedRowSet getResourceCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM item");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getResourceCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);	
  		
  	}
  	
  	public CachedRowSet getWorksCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) "
  							+"FROM work WHERE "
  							+"work_title LIKE '"+m_db.plSqlSafeString(m_key_word)+"'");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getWorksCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);	
  		
  	}

  	public CachedRowSet getCountriesCount(){
 	  	StringBuffer m_sql_string = new StringBuffer("");
  	    Statement l_stmt;
  	    CachedRowSet l_crset = null;
  	    
  		
  		m_sql_string.append("SELECT count(*) from( "+
  							"SELECT c.countryid, c.countryname as countryname, "+ 
  							"COALESCE(org.orgCount,0) AS orgcount, "+ 
  							"COALESCE(ven.venCount,0) AS venuecount, "+ 
  							"COALESCE(wor.workCount,0) AS workcount, "+ 
  							"concat_ws(' - ',dates.mindate, if(dates.maxdate = dates.mindate, null, dates.maxdate)) as dates, "+ 
  							"COALESCE(orgdates.mindate,'') as o_mindate, "+ 
  							"COALESCE(orgdates.maxdate,'') as o_maxdate, "+ 
  							"COALESCE(vendates.mindate,'') as v_mindate, "+ 
  							"COALESCE(vendates.maxdate,'') as v_maxdate, "+ 
  							"COALESCE(wordates.mindate,'') as w_mindate, "+ 
  							"COALESCE(wordates.maxdate,'') as w_maxdate "+ 
  							"FROM country AS c "+ 
  							"LEFT JOIN ( "+ 
  							"select count(distinct work.workid) as workCount, country.countryid AS countryid "+ 
  							"from events, country, playevlink, eventworklink, work "+ 
  							"where events.eventid = playevlink.eventid "+ 
  							"and playevlink.countryid = country.countryid "+ 
  							"and events.eventid = eventworklink.eventid "+ 
  							"and eventworklink.workid = work.workid "+ 
  							"group by country.countryid "+ 
        			 		") AS wor "+ 
        			 		"ON wor.countryId = c.countryid "+ 
        			 		"LEFT JOIN ( "+ 
        			 		"SELECT COUNT(*) AS orgCount, countryid AS countryId "+ 
        			 		"FROM organisation "+ 
        			 		"GROUP BY countryid "+ 
        			 		") AS org "+ 
        			 		"ON org.countryId = c.countryid "+ 
        			 		"LEFT JOIN ( "+ 
        			 		"SELECT COUNT(*) AS venCount, countryid AS countryId "+ 
        			 		"FROM venue "+ 
        			 		"GROUP BY countryid "+ 
        					") AS ven "+ 
        					"ON ven.countryId = c.countryid "+ 
        					"LEFT JOIN ( "+ 
        					"SELECT min(events.yyyyfirst_date) as mindate, max(events.yyyyfirst_date) as maxdate, "+
        					"playevlink.countryid AS countryId "+ 
        					"FROM playevlink, events "+ 
        					"WHERE playevlink.eventid = events.eventid "+ 
        					"GROUP BY countryid "+ 
        					") AS dates "+ 
        					"on dates.countryid = c.countryid "+ 
        					"LEFT JOIN ( "+ 
        					"SELECT countryid, "+ 
                      			"min(events.yyyyfirst_date) mindate, "+ 
                      			"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+ 
                      			"FROM organisation, orgevlink, events "+ 
                      			"WHERE orgevlink.organisationid = organisation.organisationid "+ 
                      			"AND orgevlink.eventid = events.eventid "+ 
                      			"group by organisation.countryid "+ 
	              		  		") as orgdates "+ 
	              		  		"on orgdates.countryid = c.countryid "+ 
	              		  		"LEFT JOIN ( "+ 
	              		  		"select min(events.yyyyfirst_date) as mindate, countryid, "+ 
	              		  		"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+ 
	              		  		"FROM events, venue "+ 
	              		  		"WHERE venue.venueid = events.venueid "+ 
	              		  		"group by countryid "+ 
        				") AS venDates "+ 
        				"ON venDates.countryId = c.countryid "+ 
        				"LEFT JOIN ( "+ 
        				"select      playevlink.countryid as countryid, "+ 
        				"min(events.yyyyfirst_date) as mindate, "+ 
            				"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+ 
            				"FROM work, events, eventworklink, playevlink "+ 
            				"WHERE eventworklink.workid = work.workid "+ 
            				"AND events.eventid = eventworklink.eventid "+ 
            				"AND playevlink.eventid = events.eventid "+ 
            				"group by countryid "+ 
            				 ") AS worDates "+ 
            				 "on wordates.countryid = c.countryid "+ 
            				 "group by c.countryid "+ 
    				") res WHERE countryname != 'Australia' AND(orgcount > 0 OR venuecount > 0 or workcount > 0 OR dates != '')");
  	    
  		try {
  	      l_stmt = m_db.m_conn.createStatement();      
  	      l_crset =  m_db.runSQL(new String(m_sql_string.toString().trim()), l_stmt);
  	      l_stmt.close();
  	     // System.out.println("SQL STRING: " + m_sql_string.toString());

  	    } catch (Exception e) {
  	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
  	      System.out.println("An Exception occured in SearchCount.getCountriesCount()");
  	      System.out.println("MESSAGE: " + e.getMessage());
  	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
  	      System.out.println("SQL STRING: " + m_sql_string.toString());
  	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  	    }
  	    
  	    return (l_crset);	
  		
  	}
  	
  	/*******************
    SET FUNCTIONS
    *******************/
  	public void setKeyWord(String p_key_word) {
  		m_key_word = p_key_word.trim();
  		m_key_word = m_key_word.replaceAll(" ","% %");
  		m_key_word = "%"+m_key_word.toLowerCase()+"%";
  		//System.out.println("search term is "+m_key_word);
  	}
  	
  	// return a formatted search count with commas
  	public static String formatSearchCountWithCommas(int searchCount){
  		return NumberFormat.getIntegerInstance().format(searchCount);
  	}
  	
  	// return a formatted search count with commas
  	public static String formatSearchCountWithCommas(String searchCount){
  		int searchCountValue = Integer.parseInt(searchCount);
  		return NumberFormat.getIntegerInstance().format(searchCountValue);
  	}
  }

 

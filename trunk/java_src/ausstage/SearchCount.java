/***************************************************

Company: SRA
 Author: Brad Williams
Project: Ausstage

   File: SearchCount.java

Purpose: Provides count of search results for initial page. 

***************************************************/

package ausstage;

import admin.Common;
import ausstage.Database;
import java.sql.*;
import sun.jdbc.rowset.*;
import java.lang.Character;
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
  							+"LOWER(event_name) LIKE '"+m_key_word+"'");
  	    
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
  							+"CONCAT(LOWER(first_name),' ',LOWER(last_name)) LIKE '"+m_key_word+"'");
  	    
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
  							+"venue_name LIKE '"+m_key_word+"'");
  	    
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
  							+"name LIKE '"+m_key_word+"'");
  	    
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
  	    
  		
  		m_sql_string.append("SELECT COUNT(*) From `secgenreclass` WHERE genreclass like '%"+m_key_word+"%'");
  	    
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
  				"WHERE lcase(`contributorfunctpreferred`.`preferredterm`) LIKE '%" + m_key_word + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid`) a ");
  	    
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
  				"WHERE lcase(contentindicator.contentindicator) LIKE '%" + m_key_word + "%' "+
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
  							+"FROM item WHERE "
  							+"title LIKE '"+m_key_word+"'");
  	    
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
  							+"work_title LIKE '"+m_key_word+"'");
  	    
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


  	
  	/*******************
    SET FUNCTIONS
    *******************/
  	public void setKeyWord(String p_key_word) {
  		m_key_word = p_key_word.trim();
  		m_key_word = m_key_word.replaceAll(" ","% %");
  		m_key_word = "%"+m_key_word.toLowerCase()+"%";
  		System.out.println("search term is "+m_key_word);
  	}
  }

 

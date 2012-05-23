/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Ausstage

   File: SecondaryGenre.java

Purpose: Provides Secondary Genre object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;

import ausstage.Database;
import sun.jdbc.rowset.*;

public class SecondaryGenre extends AusstageInputOutput
{

  private String  m_error_string;
  private Database m_db;
  /*
  Name: SecondaryGenre ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public SecondaryGenre(ausstage.Database m_db)
  {
    this.m_db = m_db;
  }

  /*
  Name: load()

  Purpose: Sets the class to a contain the Secondary Genre information for the
           specified Secondary Genre id.

  Parameters:
    p_id : id of the Secondary Genre record

  Returns:
     None

  */
  public void load(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString = "";

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM SECGENRECLASS WHERE GENRECLASSID = " + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        m_id           = p_id;
        m_name         = l_rs.getString ("GENRECLASS");
        m_description  = l_rs.getString ("GENRECLASSDESCRIPTION");
        m_preferred_id = l_rs.getInt ("SECGENREPREFERREDID");
      }

      if (m_name == null)        {m_name = "";}
      if (m_description == null) {m_description = "";}
      if (m_new_pref_name == null){m_new_pref_name ="";}
      
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in load().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  public void loadFromPrefId(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString = "";

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM SECGENRECLASS WHERE SECGENREPREFERREDID = " + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        m_id           = l_rs.getInt ("GENRECLASSID");
        m_name         = l_rs.getString ("GENRECLASS");
        m_description  = l_rs.getString ("GENRECLASSDESCRIPTION");
        m_preferred_id = p_id;
      }

      if (m_name == null)        {m_name = "";}
      if (m_description == null) {m_description = "";}
      if (m_new_pref_name == null){m_new_pref_name ="";}
      
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in load().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

 /*
  Name: add ()

  Purpose: Adds this object to the database.

  Parameters:

  Returns:
     True if the add was successful, else false. Also fills out the id of the
     new record in the m_secondary_genre_id member.

  */
  public boolean add ()
  {
    String sqlString = "";
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      boolean   ret = false;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        if(!m_description.equals("") && m_description.length() >= 300)
          m_description = m_description.substring (0, 299);
          
        if(m_preferred_id == 0){            
          sqlString = "Insert into SECGENREPREFERRED " +
                      "(PREFERREDTERM) values " +
                      "('" + m_db.plSqlSafeString(m_new_pref_name) + "')";
          m_db.runSQL (sqlString, stmt);

          setPrefId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "SECGENREPREFERREDID_SEQ")));
        }

        sqlString = "INSERT INTO SECGENRECLASS " + 
                    "(GENRECLASS, GENRECLASSDESCRIPTION, SECGENREPREFERREDID) " + 
                    "VALUES (" +
                    "'" + m_db.plSqlSafeString(m_name) + "', " + 
                    "'" + m_db.plSqlSafeString(m_description) + "'," +
                    " " + m_preferred_id + ")";
                    
        m_db.runSQL (sqlString, stmt);

        // Get the inserted index & set the id state of this object
        setId (Integer.parseInt(m_db.getInsertedIndexValue(stmt, "secgenreclassid_seq")));

        ret = true;
      }
      stmt.close ();
      return (ret);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in SecondaryGenre.add()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (false);
    }
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database.

  Parameters:

  Returns:
     None

  */
  public boolean update ()
  {
    boolean   l_ret = true;
    String    sqlString = "";
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      
      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        if(!m_description.equals("") && m_description.length() >= 300)
          m_description = m_description.substring (0, 299);

        if(m_preferred_id == 0){            
          sqlString = "Insert into SECGENREPREFERRED " +
                      "(PREFERREDTERM) values " +
                      "('" + m_db.plSqlSafeString(m_new_pref_name) + "')";
          m_db.runSQL (sqlString, stmt);

          setPrefId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "SECGENREPREFERREDID_SEQ")));
        }
        
        sqlString = "UPDATE SECGENRECLASS " + 
                    "SET GENRECLASS = '" + m_db.plSqlSafeString(m_name) + "', " +
                    "GENRECLASSDESCRIPTION = '" + m_db.plSqlSafeString(m_description) + "', " +
                    "SECGENREPREFERREDID = " + m_preferred_id + " " +
                    "WHERE GENRECLASSID = " + m_id;
        m_db.runSQL (sqlString, stmt);
      }
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in update().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      l_ret = false;
    }
    return (l_ret);
  }


  /*
  Name: delete ()

  Purpose: Removes this object from the database.

  Parameters:

  Returns:
     None

  */
  public boolean delete ()
  {
    boolean ret          = true;
    String  sqlString    = "";
    boolean delPreferred = false;
    String  secgenprefid = "";
    try
    {
      CachedRowSet  l_rs;
      Statement stmt = m_db.m_conn.createStatement ();

      if(!isInUse()){

        // Get the perferred ID so that we can delete the peferred term id this
        // Secondary Genre is the last one for this preferred ID.
        sqlString = "SELECT SECGENREPREFERREDID " +
                    "FROM SECGENRECLASS WHERE GENRECLASSID = " + m_id;
        l_rs = m_db.runSQL (sqlString, stmt);

        if(l_rs.next()){
          secgenprefid = l_rs.getString("SECGENREPREFERREDID");

          sqlString = "SELECT count(*) as counter FROM SECGENRECLASS " +
                      "WHERE SECGENREPREFERREDID = " +
                      secgenprefid;
        
          l_rs = m_db.runSQL (sqlString, stmt);  

          if(l_rs.next() && l_rs.getInt("counter") == 1){
            // del the preferred term
            delPreferred =true;
          }
        }
        
        // Delete the record from the SECGENRECLASS table
        sqlString = "DELETE FROM SECGENRECLASS WHERE GENRECLASSID = " + m_id;
        m_db.runSQL (sqlString, stmt);
        
        if (delPreferred) {
        // Delete the preferred term
          sqlString = "DELETE FROM SECGENREPREFERRED " +
                      "WHERE SECGENREPREFERREDID = " + secgenprefid;
          m_db.runSQL (sqlString, stmt);  
        }
      }
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in SecondaryGenre.delete().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      ret = false;
    }
    return(ret);
  }

  public boolean isInUse(){
  
    CachedRowSet  l_rs;
    boolean ret = false;
    String sqlString = "";
    String l_secgenrepreferredid = "";
    int counter = 0;

    try{
      Statement stmt = m_db.m_conn.createStatement ();
      // lets check if a preferred term exist this secondary genre
      sqlString = "select SECGENREPREFERRED.SECGENREPREFERREDID from " +
                  "SECGENREPREFERRED, SECGENRECLASS " +
                  "where SECGENRECLASS.GENRECLASSID = " + m_id + " " +
                  "and SECGENRECLASS.SECGENREPREFERREDID=SECGENREPREFERRED.SECGENREPREFERREDID";
      l_rs = m_db.runSQL(sqlString, stmt);
      if (l_rs.next()){
        l_secgenrepreferredid = l_rs.getString("SECGENREPREFERREDID");
        sqlString = "select count(*) as counter from SECGENRECLASS " +
                    "where SECGENREPREFERREDID=" + l_secgenrepreferredid;
        l_rs = m_db.runSQL(sqlString, stmt);
        l_rs.next();
        counter = l_rs.getInt("counter");

        if(counter <= 1){
          // this is the last genre that is related to the preferred term
          // now check if preferred term is in use
          sqlString = "select count(*) as counter from SECGENRECLASSLINK where " +
                      "SECGENREPREFERREDID=" + l_secgenrepreferredid;
          l_rs = m_db.runSQL(sqlString, stmt);
          l_rs.next();
          counter = l_rs.getInt("counter");
          if ((counter > 0))
            ret = true; // can't delete genre & pref term
        }
      }  
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in SecondaryGenre.isInUse().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(ret);
  }
  
  /*
  Name: validateObjectForDB ()

  Purpose: Determines if the object is valid for insert or update.

  Parameters:
     True if the object is valid, else false
     
  Returns:
     None

  */
  private boolean validateObjectForDB ()
  {
    boolean l_ret = true;
    if (m_name.equals (""))
    {
      m_error_string = "Unable to add the genre. Genre name is required.";
      l_ret = false;
    }
    return (l_ret);
  }

  public CachedRowSet getNames(){
    CachedRowSet  l_rs = null;
    String        sqlString;
    try{
      Statement stmt = m_db.m_conn.createStatement ();
      sqlString = "select GENRECLASSID, GENRECLASS from SECGENRECLASS order by GENRECLASS";
      l_rs = m_db.runSQL(sqlString, stmt);
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in SecondaryGenre.getNames().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(l_rs);
  }

  public void loadLinkedProperties(int p_id){
    CachedRowSet  l_rs;
    
    String sqlString = "select SECGENREPREFERREDID," +
                       "PREFERREDTERM " +
                       "from SECGENREPREFERRED " +
                       "where SECGENREPREFERREDID=" + p_id;
    
    try{
      Statement stmt = m_db.m_conn.createStatement();
      l_rs = m_db.runSQL(sqlString, stmt);
      if(l_rs.next()){
        m_id   = l_rs.getInt("SECGENREPREFERREDID");
        m_name = l_rs.getString("PREFERREDTERM");

        if(m_name == null || m_name.equals("")){m_name = "";}
      }
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in SecondaryGenre.loadLinkedProperties().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  public ResultSet getAssociatedEvents(int p_id, Statement p_stmt){
	    String    l_sql = "";
	    ResultSet l_rs  = null;
	    
	    try{
	      
	      l_sql = "SELECT DISTINCT secgenrepreferred.secgenrepreferredid, secgenrepreferred.preferredterm, events.eventid, events.event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state,  " +
	      					  "date_format(STR_TO_DATE(CONCAT(events.ddfirst_date,' ',events.mmfirst_date,' ',events.yyyyfirst_date), '%d %m %Y'), '%e %M %Y') as display_first_date, "+
	      					  "events.ddfirst_date, events.mmfirst_date,events.yyyyfirst_date, "+
	                          "STR_TO_DATE(CONCAT_WS(' ', events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date), '%d %m %Y') as datesort "+
	      					  "FROM secgenrepreferred  " +
	                          "INNER JOIN secgenreclasslink ON (secgenrepreferred.secgenrepreferredid = secgenreclasslink.secgenrepreferredid) "+
	                          "INNER JOIN events ON (secgenreclasslink.eventid = events.eventid) "+
	                          "INNER JOIN venue ON (events.venueid = venue.venueid) "+
	                          "INNER JOIN states ON (venue.state = states.stateid) " +
	                          "INNER JOIN country ON (venue.countryid = country.countryid)  " +
	                          "WHERE secgenrepreferred.secgenrepreferredid=" + p_id + " order by events.yyyyfirst_date DESC, events.mmfirst_date DESC, events.ddfirst_date DESC";
	                  
	      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
	      
	    }catch(Exception e){
	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	      System.out.println ("An Exception occured in Secondary Genre Preferred.getAssociatedEvents().");
	      System.out.println("MESSAGE: " + e.getMessage());
	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	      System.out.println("CLASS.TOSTRING: " + e.toString());
	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	    }
	    return(l_rs);
	    
	  }
  
  public ResultSet getAssociatedItems(int p_id, Statement p_stmt){
	    String    l_sql = "";
	    ResultSet l_rs  = null;
	    
	    try{
	      
	      l_sql = "SELECT DISTINCT item.ITEMID, item.citation, secgenreclass.GENRECLASS, secgenreclass.SECGENREPREFERREDID  " +
	      					  "FROM item "+
	                          "INNER JOIN itemsecgenrelink ON (item.ITEMID = itemsecgenrelink.ITEMID) " +
	                          "INNER JOIN secgenreclass ON (itemsecgenrelink.SECGENREPREFERREDID = secgenreclass.SECGENREPREFERREDID)  " +
	                          "WHERE secgenreclass.SECGENREPREFERREDID=" + p_id + " Order by item.citation";
	                  
	      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
	      
	    }catch(Exception e){
	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	      System.out.println ("An Exception occured in Secondary Genre Preferred.getAssociatedItems().");
	      System.out.println("MESSAGE: " + e.getMessage());
	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	      System.out.println("CLASS.TOSTRING: " + e.toString());
	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	    }
	    return(l_rs);
	    
	  }
  


  ///////////////////////////////
  //  SET FUNCTIONS
  //////////////////////////////
  
  public void setId (int p_id){
    m_id = p_id;
  }

  public void setName (String p_name){
    m_name = p_name;
  }

  public void setDescription (String p_description){
    m_description = p_description;
  }  

  public void setPrefId(int p_id){
    m_preferred_id = p_id;
  }

  public void setNewPrefName(String p_name){
    m_new_pref_name = p_name;
  }
  



  ///////////////////////////////
  //  GET FUNCTIONS
  //////////////////////////////

  
  public int getId(){
    return(m_id);
  }
  public String getName(){
    return (m_name);
  }

  public String getDescription(){
    return (m_description);
  }  

  public int getPrefId(){
    return(m_preferred_id);
  }


  public String getPreferredName(){
    return(m_new_pref_name);
  }
  
  
  
  public String getGenreInfoForItemDisplay(int p_secgenreprefered_id, Statement p_stmt){
    String sqlString   = "", retStr  ="";
    ResultSet l_rs = null;
    
    try{
    
      sqlString = "SELECT concat_ws(', ',SECGENRECLASS.GENRECLASS, "+
      			  "SECGENREPREFERRED.PREFERREDTERM) output "+ 
                  "FROM SECGENRECLASS, SECGENREPREFERRED "+ 
                  "WHERE SECGENRECLASS.SECGENREPREFERREDID = SECGENREPREFERRED.SECGENREPREFERREDID "+
                  "AND SECGENRECLASS.SECGENREPREFERREDID= " + p_secgenreprefered_id;
                  
      l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

      if(l_rs.next())
        retStr = l_rs.getString("output"); 
  
      
    }catch(Exception e){
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in Contributor.getGenreInfoForItemDisplay().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(retStr);

  }
  
  

  /*
  Name: initialise ()

  Purpose: Resets the object to point to no record.

  Parameters:
    None

  Returns:
     None

  */
  public void initialise()
  {
    m_id            = 0;
    m_name          = "";
    m_description   = "";
    m_preferred_id  = 0;
    m_new_pref_name = "";
  }
}



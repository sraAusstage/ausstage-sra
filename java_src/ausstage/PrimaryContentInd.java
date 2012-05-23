/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Centricminds

   File: PrimaryContentInd.java

Purpose: Provides Primary Content Indicator object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class PrimaryContentInd extends AusstageInputOutput
{

  private String  m_error_string;
  Database m_db = null;

  /*
  Name: PrimaryContentInd ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public PrimaryContentInd(Database m_db)
  {
    this.m_db = m_db;
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Primary Content Indicator information for the
           specified Primary Content Indicator id.

  Parameters:
    p_id : id of the Primary Content Indicator record

  Returns:
     None

  */
  public void load(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM CONTENTINDICATOR WHERE CONTENTINDICATORID = " + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        m_id          = p_id;
        m_name        = l_rs.getString ("CONTENTINDICATOR");
        m_description = l_rs.getString ("CONTENTINDICATORDESCRIPTION");
      }

      if (m_name == null) {
        m_name = "";
      }

      if (m_description == null) {
        m_description = "";
      }      


      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryContentInd.load()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: add ()

  Purpose: Adds this object to the database.

  Parameters:

  Returns:
     True if the add was successful, else false. Also fills out the id of the
     new record in the m_id member.

  */
  public boolean add ()
  {
    boolean ret = true;
    try
    {
      
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        // trim the notes first to db specified max chars (-1) before inserting
        if(!m_description.equals("") && m_description.length() >= 300)
          m_description = m_description.substring (0, 299);
        
        if(!isDuplicate()){
          sqlString = "INSERT INTO CONTENTINDICATOR (CONTENTINDICATOR, CONTENTINDICATORDESCRIPTION) " + 
                      "VALUES (" +
                      "'" + m_db.plSqlSafeString(m_name) + "', " + 
                      "'" + m_db.plSqlSafeString(m_description) + "')";
                    
          m_db.runSQL (sqlString, stmt);

          // Get the inserted index & set the id state of the object
          setId (Integer.parseInt(m_db.getInsertedIndexValue(stmt, "CONTENTINDICATORID_SEQ")));
        }else{
          ret = false;
        }
      }
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryContentInd.add()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      ret = false;
    }
     return (ret);
  }

  private boolean isDuplicate(){
    boolean ret    = false;
    try{      
      CachedRowSet   l_rs;      
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      sqlString = "select CONTENTINDICATOR from CONTENTINDICATOR where " +
                  "lower(CONTENTINDICATOR)='" + m_db.plSqlSafeString(m_name).toLowerCase() + "'";
                  if(m_id != 0) 
                    sqlString += " and not CONTENTINDICATORID=" + m_id;
      l_rs = m_db.runSQL (sqlString, stmt);

      if(l_rs.next())
        ret = true;
      stmt.close ();
      
    }catch(Exception e){
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryContentInd.isDuplicate()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(ret);
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
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {

        // trim the notes first to db specified max chars (-1) before inserting
        if(!m_description.equals("") && m_description.length() >= 300)
          m_description = m_description.substring (0, 299);
        if(!isDuplicate()){  
          sqlString = "UPDATE CONTENTINDICATOR " + 
                      "SET CONTENTINDICATOR = '" + m_db.plSqlSafeString(m_name) + "', " +
                      "CONTENTINDICATORDESCRIPTION = '" + m_db.plSqlSafeString(m_description) + "' " +
                      "WHERE CONTENTINDICATORID = " + m_id;
          m_db.runSQL (sqlString, stmt);
        }else{
          l_ret = false;
        }
      }
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryContentInd.update().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
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
    boolean ret = true;
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
 
      if(!isInUse()){
        sqlString = "DELETE FROM CONTENTINDICATOR WHERE CONTENTINDICATORID = " + m_id;
        m_db.runSQL (sqlString, stmt);
      }      
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryContentInd.delete().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      ret = false;
    }
    return(ret);
  }

  public boolean isInUse(){
  
    CachedRowSet  l_rs;
    boolean ret = false;
    String sqlString = "";

    try{
      Statement stmt = m_db.m_conn.createStatement ();
      // check if this primary content indicator exist in the events table
      sqlString = "select EVENTID from PRIMCONTENTINDICATOREVLINK " +
                  "where PRIMCONTENTINDICATORID = " + m_id;
      l_rs = m_db.runSQL(sqlString, stmt);

      if(l_rs.next())
        ret = true;
        
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in PrimaryContentInd.isInUse().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
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
      m_error_string = "Unable to add the Subjects. Primary Subjects name is required.";
      l_ret = false;
    }
    return (l_ret);
  }

  public CachedRowSet getNames(){
    CachedRowSet  l_rs = null;
    String        sqlString;
    try{
      Statement stmt = m_db.m_conn.createStatement ();
      sqlString = "select CONTENTINDICATORID, CONTENTINDICATOR " +
                  "from CONTENTINDICATOR order by CONTENTINDICATOR";
      l_rs = m_db.runSQL(sqlString, stmt);
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in PrimaryContentInd.getNames().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(l_rs);
  }
  
  // methods to set the state of the oject
  
  public void setId (int p_id)
  {
    m_id = p_id;
  }
  
  public void setName (String p_name)
  {
    m_name = p_name;
  }

  public void setDescription (String p_description)
  {
    m_description = p_description;
  }  

  public void setPrefId(int p_id){
    m_preferred_id = 0;
  }

  public void setNewPrefName(String p_name){
    m_new_pref_name = p_name;
  }
  
  // methods to get the state of the oject
  
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
    m_id           = 0;
    m_name         = "";
    m_description  = "";
    m_preferred_id = 0;
  }
}



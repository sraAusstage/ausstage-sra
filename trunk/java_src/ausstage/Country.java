/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: Country.java

Purpose: Provides Country object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Country
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();

  // All of the record information
  private int     m_country_id;
  private String  m_country_name;
  private String  m_error_string;
  /*
  Name: Country ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public Country(ausstage.Database p_db)
  {
    m_db = p_db;
    initialise();
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
    m_country_id   = 0;
    m_country_name   = "";
    m_error_string = "";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Country information for the
           specified Country id.

  Parameters:
    p_id : id of the Country record

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

      sqlString = "SELECT * FROM country WHERE " +
                  "countryid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        // Reset the object
        initialise();

        // Setup the new data
        m_country_id     = l_rs.getInt ("countryid");
        m_country_name   = l_rs.getString ("countryname");

      }
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in loadResource().");
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
     new record in the m_country_id member.

  */
  public boolean add ()
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      boolean   ret = false;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        sqlString = "INSERT INTO country (countryname) VALUES (" +
                    "'" + m_db.plSqlSafeString(m_country_name) + "')";
        m_db.runSQL (sqlString, stmt);

        // Get the inserted index
        m_country_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "countryid_seq"));
        ret = true;
      }
      stmt.close ();
      return (ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add the country. The data may be invalid.";
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
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      boolean   l_ret = false;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        sqlString = "UPDATE country set countryname='" + m_db.plSqlSafeString(m_country_name) + "' " + 
                    "where countryid=" + m_country_id;
        m_db.runSQL (sqlString, stmt);
        l_ret = true;
      }
      stmt.close ();
      return (l_ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the country. The data may be invalid.";
      return (false);
    }
  }


  /*
  Name: delete ()

  Purpose: Removes this object from the database.

  Parameters:

  Returns:
     None

  */
  public void delete ()
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      String    ret;

      sqlString = "DELETE from country WHERE countryid=" + m_country_id;
      m_db.runSQL (sqlString, stmt);
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in delete().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }


  /*
  Name: checkInUse ()

  Purpose: Checks to see if the specified Country is in use in the database.

  Parameters:
    p_id : id of the record

  Returns:
     True if the country is in use, else false

  */
  public boolean checkInUse(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    boolean       ret = false;

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      // Venue
      sqlString = "SELECT * FROM venue WHERE " +
                  "countryid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
        ret = true;
      l_rs.close();

      // Organisation
      sqlString = "SELECT * FROM organisation WHERE " +
                  "countryid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
        ret = true;
      l_rs.close();

      // Contributor
      sqlString = "SELECT * FROM contributor WHERE " +
                  "countryid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
        ret = true;
      l_rs.close();
      
      stmt.close();
      return (ret);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in checkInUse().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (ret);
    }
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
    if (m_country_name.equals (""))
    {
      m_error_string = "Unable to add the country. Country name is required.";
      l_ret = false;
    }
    return (l_ret);
  }

  /*
  Name: getCountries ()

  Purpose: Returns a record set with all of the country information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getCountries(Statement p_stmt)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM country order by countryname";
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getCountries().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }

  void handleException(Exception p_e, String p_description) {
    System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
    System.out.println("MESSAGE: " + p_e.getMessage());
    System.out.println("LOCALIZED MESSAGE: " + p_e.getLocalizedMessage());
    System.out.println("CLASS.TOSTRING: " + p_e.toString());
    System.out.println(">>>>>>> STACK TRACE <<<<<<<");
    p_e.printStackTrace();
    System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
  }

  void handleException(Exception p_e) {
    handleException(p_e, "");
  }

  public boolean addLink (String p_eventid, boolean isNationalPlayOrigin)
  {
    String      l_sql = "";

    try
    {
      Statement l_stmt = m_db.m_conn.createStatement ();

      // first lets delete the event link for this datasource
      if(isNationalPlayOrigin)
        l_sql = "INSERT INTO PLAYEVLINK " +
                "(EVENTID, COUNTRYID) " + 
                "values (" + p_eventid + 
                "," + m_country_id + ")";
      else{
        l_sql = "INSERT INTO PRODUCTIONEVLINK " +
                "(EVENTID, COUNTRYID) " + 
                "values (" + p_eventid + 
                "," + m_country_id + ")";
      }
              
      m_db.runSQL(l_sql, l_stmt);
        
      l_stmt.close();
      return(true);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add link between play/production country and events. The data may be invalid.";
      handleException(e);
    }
    return(false);
  }


  public boolean delLink(String p_eventid, boolean isNationalPlayOrigin){
    String      l_sql = "";
    boolean ret = true;
    try
    {
      Statement l_stmt = m_db.m_conn.createStatement ();

      if(isNationalPlayOrigin)
        l_sql = "DELETE from PLAYEVLINK WHERE EVENTID = " + p_eventid;
      else
        l_sql = "DELETE from PRODUCTIONEVLINK WHERE EVENTID = " + p_eventid;
        
      m_db.runSQL(l_sql, l_stmt);
      l_stmt.close();
    }catch(Exception e){
      m_error_string = "Unable to delete the link between play/production and event.";
      handleException(e);
      ret = false;
    }
    return (ret);
  }


  ///////////////////////////////
  //  SET FUNCTIONS
  //////////////////////////////
  
  public void setId (int p_id)
  {
    m_country_id = p_id;
  }
  public void setName (String p_name)
  {
    m_country_name = p_name;
  }

  public void setMdb(ausstage.Database p_db){
    m_db = p_db;
  }



  
  ///////////////////////////////
  //  GET FUNCTIONS
  //////////////////////////////

  public int getId ()
  {
    return (m_country_id);
  }
  
  public String getName ()
  {
    return (m_country_name);
  }

  public String getError ()
  {
    return (m_error_string);
  }

}



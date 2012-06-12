/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: CollInfoAccess.java

Purpose: Provides CollInfoAccess object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class CollInfoAccess
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();

  // All of the record information
  private int     m_collection_info_access_id;
  private String  m_coll_access;
  private String  m_error_string;

  /*
  Name: CollInfoAccess ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public CollInfoAccess(ausstage.Database p_db)
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
    m_collection_info_access_id = 0;
    m_coll_access               = "";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the CollInfoAccess information for the
           specified collection_info_access_id.

  Parameters:
    p_id : id of the collection_info_access record

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

      sqlString = "SELECT * FROM collection_info_access WHERE " +
                  "collection_info_access_id=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);

      if (l_rs.next())
      {
        // Reset the object
        initialise();

        // Setup the new data
        m_collection_info_access_id = l_rs.getInt    ("COLLECTION_INFO_ACCESS_ID");
        m_coll_access               = l_rs.getString ("COLL_ACCESS");

        if (m_coll_access == null)
          m_coll_access = "";
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
     new record in the m_collection_info_access_id member.

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
        // As the notes is a text area, need to limit characters
        sqlString = "INSERT INTO COLLECTION_INFO_ACCESS (COLL_ACCESS) VALUES ('" +
                    m_coll_access  + "')";
        m_db.runSQL (sqlString, stmt);

        // Get the inserted index
        m_collection_info_access_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "collection_info_access_id_seq"));
        ret = true;
      }
      stmt.close ();
      return (ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add the collection information access record. The data may be invalid.";
      return (false);
    }
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database.

  Parameters:

  Returns:
     True if successful, else false

  */
  public boolean update ()
  {
    String sqlString = "";
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      boolean   l_ret = false;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        sqlString = "UPDATE COLLECTION_INFO_ACCESS set " +
                    "COLL_ACCESS= '" + m_coll_access + "' " +
                    "where collection_info_access_id=" + m_collection_info_access_id;
        m_db.runSQL (sqlString, stmt);
        l_ret = true;
      }
      stmt.close ();
      return (l_ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the collection information access record. The data may be invalid.";
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

      sqlString = "DELETE from COLLECTION_INFO_ACCESS WHERE collection_info_access_id=" + m_collection_info_access_id;
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

  Purpose: Checks to see if the specified Collection Information Access record
          is in use in the database.

  Parameters:
    p_id : id of the collection_info_access record

  Returns:
     True if the collection_info_access record is in use, else false

  */
  public boolean checkInUse(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    boolean       ret = false;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM collection_information WHERE " +
                  "collection_access=" + p_id;
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
    if (m_coll_access.equals (""))
    {
      m_error_string = "Collection Information Access name is required.";
      l_ret = false;
    }
    return (l_ret);
  }

  /*
  Name: getCollInfoAccesses ()

  Purpose: Returns a record set with all of the collection_info_access information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getCollInfoAccesses ()
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM collection_info_access order by coll_access";
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getCollInfoAccesses().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }

  public void setCollAccess (String s) {m_coll_access = s;}

  public int    getCollInfoAccessId () {return m_collection_info_access_id;}
  public String getCollAccess       () {return m_coll_access;}
  public String getError            () {return m_error_string;}
}

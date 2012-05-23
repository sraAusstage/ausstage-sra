/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: EntityType.java

Purpose: Provides EntityType object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class EntityType
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();

  // All of the record information
  private int     m_entity_type_id   = 0;
  private String  m_entity_type_name = "";
  private String  m_error_string     = "";
  

  /*
  Name: EntityType ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public EntityType(ausstage.Database p_db)
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
    m_entity_type_id     = 0;
    m_entity_type_name   = "";
    m_error_string       = "";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Entity Type information for the
           specified Entity Type id.

  Parameters:
    p_id : id of the Entity Type record

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

      sqlString = "SELECT * FROM entity_type WHERE " +
                  "entity_type_id=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        // Reset the object
        initialise();

        // Setup the new data
        m_entity_type_id     = l_rs.getInt ("entity_type_id");
        m_entity_type_name   = l_rs.getString ("type");

      }
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in EntityType.load().");
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
     new record in the m_entity_type_id member.

  */
  public boolean add ()
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      boolean   l_ret = false;

      // Check to make sure that the user has entered in all of the required fields
      if (validateObjectForDB ())
      {
        if(!isDuplicate()){
          sqlString = "INSERT INTO entity_type (type) VALUES (" +
                      "'" + m_db.plSqlSafeString(m_entity_type_name) + "')";
          m_db.runSQL (sqlString, stmt);

          // Get the inserted index
          m_entity_type_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "entity_type_id_seq"));
          l_ret = true;
        }else{
          l_ret = false;
          m_error_string = "Add Entity Type process was unsuccessful.<br>Please make sure that you are not adding a duplicate.";
        }
      }      
      stmt.close ();
      return (l_ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add the entity type. The data may be invalid.";
      return (false);
    }
  }

  private boolean isDuplicate(){
    boolean l_ret    = false;
    try{      
      CachedRowSet   l_rs;      
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      sqlString = "select type from entity_type where " +
                  "lower(type)='" + m_db.plSqlSafeString(m_entity_type_name).toLowerCase() + "'";
                  if(m_entity_type_id != 0) 
                    sqlString += " and not entity_type_id=" + m_entity_type_id;
      l_rs = m_db.runSQL (sqlString, stmt);

      if(l_rs.next())
        l_ret = true;
      stmt.close ();
      
    }catch(Exception e){
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in EntityType.isDuplicate()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    return(l_ret);
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
        if(!isDuplicate()){
          sqlString = "UPDATE entity_type set type='" + m_db.plSqlSafeString(m_entity_type_name) + "' " + 
                      "where entity_type_id=" + m_entity_type_id;
          m_db.runSQL (sqlString, stmt);
          l_ret = true;
        }else{
          l_ret = false;
          m_error_string = "Edit Entity Type process was unsuccessful.<br>Please make sure that you are not adding a duplicate.";
        }
      }
      stmt.close ();
      return (l_ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the entity type. The data may be invalid.";
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

      sqlString = "DELETE from entity_type WHERE entity_type_id=" + m_entity_type_id;
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

  Purpose: Checks to see if the specified Entity Ttype is in use in the database.

  Parameters:
    p_id : id of the record

  Returns:
     True if the entity type is in use, else false

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
      sqlString = "SELECT * FROM entity WHERE " +
                  "type=" + p_id;
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
    if (m_entity_type_name.equals (""))
    {
      m_error_string = "Unable to add the entity type. Entity Type name is required.";
      l_ret = false;
    }
    return (l_ret);
  }

  /*
  Name: getEntityTypes ()

  Purpose: Returns a record set with all of the entity type information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getEntityTypes(Statement p_stmt)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM entity_type order by type";
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getEntityTypes().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }

  public void setName (String p_name)
  {
    m_entity_type_name = p_name;
  }

  public String getName ()
  {
    return (m_entity_type_name);
  }

  public String getError ()
  {
    return (m_error_string);
  }
}



/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: Materials.java

Purpose: Provides Materials object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Materials
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();

  // All of the record information
  private int     m_material_id;
  private String  m_materials;
  private String  m_error_string;

  /*
  Name: Materials ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public Materials(ausstage.Database p_db)
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
    m_material_id = 0;
    m_materials    = "";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Materials information for the
           specified materials id.

  Parameters:
    p_id : id of the materials record

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

      sqlString = "SELECT * FROM materials WHERE " +
                  "material_id=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);

      if (l_rs.next())
      {
        // Reset the object
        initialise();

        // Setup the new data
        m_material_id = l_rs.getInt    ("MATERIAL_ID");
        m_materials    = l_rs.getString ("MATERIALS");

        if (m_materials == null) m_materials = "";
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
     new record in the m_material_id member.

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
        sqlString = "INSERT INTO MATERIALS (MATERIALS) VALUES (" +
                    "'" + m_db.plSqlSafeString(m_materials) + "')";
        m_db.runSQL (sqlString, stmt);

        // Get the inserted index
        m_material_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "material_id_seq"));
        ret = true;
      }
      stmt.close ();
      return (ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to add the materials. The data may be invalid.";
      return (false);
    }
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database.

  Parameters:

  Returns:
     True if successfull, else false

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
        sqlString = "UPDATE MATERIALS set " +
                    "MATERIALS='" + m_db.plSqlSafeString(m_materials) + "' " +
                    "where material_id=" + m_material_id;
        m_db.runSQL (sqlString, stmt);
        l_ret = true;
      }
      stmt.close ();
      return (l_ret);
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the materials record. The data may be invalid.";
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

      sqlString = "DELETE from MATERIALS WHERE material_id=" + m_material_id;
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

  Purpose: Checks to see if the specified Materials is in use in the database.

  Parameters:
    p_id : id of the materials record

  Returns:
     True if the materials is in use, else false

  */
  public boolean checkInUse(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    boolean       ret = false;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM materiallink WHERE " +
                  "materialid=" + p_id;
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
    if (m_materials.equals (""))
    {
      m_error_string = "Materials record name is required.";
      l_ret = false;
    }

    return (l_ret);
  }

  /*
  Name: getAllMaterials ()

  Purpose: Returns a record set with all of the materials information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getAllMaterials(Statement p_stmt)
  {
    CachedRowSet l_rs;
    String       sqlString;
    String       l_ret;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM materials order by materials";
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getAllMaterials().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }

  public void setMaterials (String s) {m_materials = s;}

  public String getMaterials () {return (m_materials);}
  public String getError     () {return (m_error_string);}
}

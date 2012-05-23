/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Centricminds

   File: PrimaryGenre.java

Purpose: Provides Primary Genre object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class PrimaryGenre extends AusstageInputOutput
{

  private String  m_error_string;

  /*
  Name: PrimaryGenre ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public PrimaryGenre(ausstage.Database p_db)
  {
    m_db = p_db;
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the Primary Genre information for the
           specified Primary Genre id.

  Parameters:
    p_id : id of the Primary Genre record

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

      sqlString = "SELECT * FROM PRIGENRECLASS WHERE GENRECLASSID = " + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
      {
        m_id          = p_id;
        m_name        = l_rs.getString ("GENRECLASS");
        m_description = l_rs.getString ("GENRECLASSDESCRIPTION");
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
      System.out.println ("An Exception occured in PrimaryGenre.load()");
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
     new record in the m_primary_genre_id member.

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
          
        sqlString = "INSERT INTO PRIGENRECLASS (GENRECLASS, GENRECLASSDESCRIPTION) " + 
                    "VALUES (" +
                    "'" + m_db.plSqlSafeString(m_name) + "', " + 
                    "'" + m_db.plSqlSafeString(m_description) + "')";
                    
        m_db.runSQL (sqlString, stmt);

        // Get the inserted index & set the id state of the object
        setId (Integer.parseInt(m_db.getInsertedIndexValue(stmt, "prigenreclassid_seq")));
      }
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryGenre.add()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      ret = false;
    }
     return (ret);
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
          
        sqlString = "UPDATE PRIGENRECLASS " + 
                    "SET GENRECLASS = '" + m_db.plSqlSafeString(m_name) + "', " +
                    "GENRECLASSDESCRIPTION = '" + m_db.plSqlSafeString(m_description) + "' " +
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
        sqlString = "DELETE FROM PRIGENRECLASS WHERE GENRECLASSID = " + m_id;
        m_db.runSQL (sqlString, stmt);
      }      
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in PrimaryGenre.delete().");
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
      // check if this primary genre exist in the events table
      sqlString = "select EVENTID from events where PRIMARY_GENRE = " + m_id;
      l_rs = m_db.runSQL(sqlString, stmt);

      if(l_rs.next())
        ret = true;
        
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in PrimaryGenre.isInUse().");
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
      sqlString = "select GENRECLASSID, GENRECLASS from PRIGENRECLASS order by GENRECLASS";
      l_rs = m_db.runSQL(sqlString, stmt);
      stmt.close();
    }catch(Exception e){
      System.out.println ("An Exception occured in PrimaryGenre.getNames().");
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
  
  /*
  Name: getPrimaryGenres ()

  Purpose: Returns a record set with all of the status information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getPrimaryGenres(Statement p_stmt)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret;

    try
    {      
      sqlString = "SELECT * FROM PRIGENRECLASS";
      l_rs = m_db.runSQL (sqlString, p_stmt);
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getPrimaryGenres().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }
}



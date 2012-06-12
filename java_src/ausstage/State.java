/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: State.java

Purpose: Provides State object functions.

***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class State
{
  private ausstage.Database     m_db;
  private admin.AppConstants AppConstants = new admin.AppConstants();
  private admin.Common       Common       = new admin.Common();

  /*
  Name: State ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public State(ausstage.Database p_db)
  {
    m_db = p_db;
  }

  /*
  Name: getName ()

  Purpose: Returns the name of the state.

  Parameters:
    p_id : id of the state record

  Returns:
     The name of the state.

  */
  public String getName(int p_id)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret = "";

    try
    {      
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM STATES WHERE " +
                  "stateid=" + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);
        
      if (l_rs.next())
        l_ret = l_rs.getString ("state");
      l_rs.close();
      stmt.close();
      return (l_ret);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getStateName().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return ("");
    }
  }


  /*
  Name: getStates ()

  Purpose: Returns a record set with all of the state information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getStates(Statement p_stmt)
  {
    CachedRowSet  l_rs;
    String        sqlString;
    String        l_ret;

    try
    {      
      sqlString = "SELECT * FROM STATES order by state";
      l_rs = m_db.runSQL (sqlString, p_stmt);
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getStates().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }
}



/***************************************************

Company: SRA Information Technology
 Author: Omkar Nandurkar

   File: WorkWorkLink.java

Purpose: Provides Work to Work object functions.

***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class WorkWorkLink
{
  private Database     m_db;
  private AppConstants AppConstants = new AppConstants();
  private Common       Common       = new Common();

  // All of the record information
  //
  private String              workId;
  private String              childId;
  private String              functionLovId;
  private String              notes;
  private String              m_error_string;

  /*
  Name: WorkWorkLink ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public WorkWorkLink(ausstage.Database m_db2)
  {
    m_db = m_db2;
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
	  //
    workId          = "0";
    childId         = "0";
    functionLovId   = "0";
    notes           = "";
    m_error_string  = "";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the WorkWorkLink information for the
           specified WorkWorkLink id.

  Parameters:
    p_workworklink_id  : id of the main work record

  Returns:
     None

  */
  public void load(String p_workworklink_id)
  {
    CachedRowSet l_rs;
    String       sqlString;

    // Reset the object
    initialise();

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = " SELECT * FROM WorkWorkLink, lookup_codes " +
                  " WHERE workworklinkId = " + p_workworklink_id +
                  "   AND WorkWorkLink.function_lov_id=lookup_codes.code_lov_id";
      l_rs = m_db.runSQL (sqlString, stmt);

      if (l_rs.next())
      {
    	  //
        workId         = l_rs.getString("workId");
        childId        = l_rs.getString("childId");
		functionLovId  = l_rs.getString("function_lov_id");
		notes          = l_rs.getString("notes");

		    if (notes == null) notes = "";
      }
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in WorkWorkLink: load().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: add ()

  Purpose: Adds this object to the database. Does this by simply calling the update()
           method.

  Parameters:
    workId
    String array of child work ids.

  Returns:
     True if successful, else false

  */
  public boolean add (String p_workId, Vector p_childLinks)
  {
    return update(p_workId, p_childLinks);
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database by deleting all WorkWorkLinks for this
           work and inserting new ones from an array of p_childLinks.

  Parameters:
    Work Id
    String array of child work ids.

  Returns:
     True if successful, else false

  */
   //System.out.println("Before update:" + p_childLinks);
  public boolean update (String p_workId, Vector p_childLinks)
  {
	  //System.out.println("In update:" + p_childLinks + ", Work Id:"+ p_workId);
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String       sqlString;
      boolean      l_ret = false;

      sqlString = "DELETE FROM WorkWorkLink where " +
                  "workId=" + p_workId;
      m_db.runSQL (sqlString, stmt);

      if (p_childLinks != null) {
    	  //System.out.println("Work:"  + p_childLinks + ", Work Id:"+ p_workId);
	      for (int i=0;  i < p_childLinks.size(); i++){
	    	  try{
	    		  sqlString = "INSERT INTO WorkWorkLink "    +
	                    "(workId, childId, function_lov_id) " +
	                    "VALUES (" +
	                    p_workId + ", " + ((WorkWorkLink)p_childLinks.get(i)).getChildId() + ", null)";
	    	  }catch(Exception e){
	    		  sqlString = "INSERT INTO WorkWorkLink "    +
                  "(workId, childId, function_lov_id) " +
                  "VALUES (" +
                  p_workId + ", " + p_childLinks.get(i) + ", null)";
	    	  }
	       // System.out.println("Work loop:" + p_childLinks.get(i));
	        m_db.runSQL (sqlString, stmt);
	      }
	      l_ret = true;
      }
      //System.out.println("In update2:" + p_childLinks);
      stmt.close ();
      return l_ret;
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the links to the selected work Link records.";
      return (false);
    }
  }

  /*
  Name: deleteWorkWorkLinksForWork ()

  Purpose: Deletes all WorkWorkLink records for the specified Work Id.

  Parameters:
    deleteWorkWorkLinksForWork Id

  Returns:
     None

  */
  public void deleteWorkWorkLinksForWork (String workId)
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      sqlString = "DELETE from WorkWorkLink WHERE workId = " + workId;
      m_db.runSQL (sqlString, stmt);
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in deleteWorkWorkLinksForWork().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }
  
  /*
  Name: getWorkWorkLinks ()

  Purpose: Returns a record set with all of the WorkWorkLinks information in it.

  Parameters:
		Work Id

  Returns:
     A record set.

  */
  public CachedRowSet getWorkWorkLinks(int workId)
  {
    CachedRowSet l_rs;
    String       sqlString;
    
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT WorkWorkLink.* " +
      		" FROM WorkWorkLink " +
      		" WHERE WorkWorkLink.workId  = " + workId;
                  
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getWorkWorkLinks().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }
  
  /*
  Name: getWorkWorkLinksForWork (workId)

  Purpose: Returns a Vector containing all the WorkWorkLinks for this work.

  Parameters:
    work Id

  Returns:
     A Vector of all WorkWorkLinks for this work.
  */

  public Vector getWorkWorkLinksForWork(int workId)
  {
    Vector allWorkWorkLinks              = new Vector();
    CachedRowSet rset                 = this.getWorkWorkLinks(workId);
    WorkWorkLink workWorkLink               = null;
    
    try
    {
      while (rset.next())
      {
    	  workWorkLink = new WorkWorkLink(m_db);
    	  workWorkLink.setWorkId(rset.getString("workId"));
    	  workWorkLink.setChildId(rset.getString("childId"));
    	  workWorkLink.setNotes(rset.getString("notes"));

        

        allWorkWorkLinks.add(workWorkLink);
      }
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getWorkWorkLinksForWork().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    finally
    {
      try {rset.close ();} catch (Exception ex) {}
    }
    return allWorkWorkLinks;
  }
  
  public void setWorkId          (String s) {workId       = s;}
  public void setChildId         (String s) {childId       = s;}
  public void setFunctionLovId   (String s) {functionLovId = s;}
  public void setNotes           (String s)
  {
    notes = s;
    if (notes == null) notes = "";
    if (notes.length() > 500) notes = notes.substring(0,499);
  }

  public String              getWorkId          () {return (workId);}
  public String              getChildId         () {return (childId);}
  public String              getFunctionId      () {return (functionLovId);}
  public String              getNotes           () {return (notes);}
  public String              getError           () {return (m_error_string);}
}

/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: SecContentIndicatorEvLink.java

Purpose: Provides SecContentIndicatorEvLink object functions.

***************************************************/

package ausstage;

import java.sql.Statement;

import java.util.Vector;

import sun.jdbc.rowset.CachedRowSet;
import admin.*;


public class SecContentIndicatorEvLink
{
  private Database     m_db;
  private AppConstants AppConstants = new AppConstants();
  private Common       Common       = new Common();

  // All of the record information
  private String eventId;
  private String secContentIndPrefId;
  private String secContentIndPref;
  private String m_error_string;

  /*
  Name: SecContentIndicatorEvLink ()

  Purpose: Constructor.

  Parameters:
    p_db       : The database object

  Returns:
     None

  */
  public SecContentIndicatorEvLink(ausstage.Database p_db)
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
    secContentIndPrefId = "0";
    secContentIndPref   = "";
    eventId             = "0";
  }

  /*
  Name: load ()

  Purpose: Sets the class to a contain the SecContentIndicatorEvLink information for the
           specified Secondary Content Indicator id.

  Parameters:
    p_id : id of the Secondary Content Indicator Preferred record
    e_id : id of the Event record
    Note: There is no unique key for this table.

  Returns:
     None

  */
  public void load(String p_id, String e_id)
  {
    CachedRowSet l_rs;
    String       sqlString;

    // Reset the object
    initialise();

    secContentIndPrefId = p_id;
    eventId             = e_id;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = " SELECT * FROM SecContentIndicatorPreferred" +
                  " WHERE SecContentIndicatorPreferredId = " + p_id;
      l_rs = m_db.runSQL (sqlString, stmt);

      if (l_rs.next())
      {
        // Set up the new data
        secContentIndPref = l_rs.getString("PreferredTerm");
      }
      l_rs.close();
      stmt.close();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in SecContentIndicatorEvLink: load().");
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
    Event Id
    Vector of Secondary Content Indicator EvLink records.

  Returns:
     True if successful, else false

  */
  public boolean add (String eventId, Vector secContentIndicatorEvLinks)
  {
    return update(eventId, secContentIndicatorEvLinks);
  }

  /*
  Name: update ()

  Purpose: Modifies this object in the database by deleting all SecContentIndicatorEvLinks for this
           Event and inserting new ones from an array of Secondary Content Indicator records to link
           to this Event.

  Parameters:
    Event Id
    String array of Secondary Content Indicator Link records.

  Returns:
     True if successful, else false

  */
  public boolean update (String eventId, Vector secContentIndicatorEvLinks)
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      SecContentIndicatorEvLink evLink = null;
      String    sqlString;
      boolean   l_ret = false;

      sqlString = "DELETE FROM SecContentIndicatorEvLink where " +
                  "eventId=" + eventId;
      m_db.runSQL (sqlString, stmt);

      for (int i=0; secContentIndicatorEvLinks != null && i < secContentIndicatorEvLinks.size(); i++)
      {
        evLink = (SecContentIndicatorEvLink)secContentIndicatorEvLinks.get(i);
        sqlString = "INSERT INTO SecContentIndicatorEvLink "    +
                    "(SecContentIndicatorPreferredId, eventId) VALUES (" +
                    evLink.getSecContentIndPrefId() + ", "    + eventId + ")";
        m_db.runSQL (sqlString, stmt);
      }
      l_ret = true;

      stmt.close ();
      return l_ret;
    }
    catch (Exception e)
    {
      m_error_string = "Unable to update the links to the selected Secondary Subjects records. The data may be invalid.";
      return (false);
    }
  }

  /*
  Name: deleteSecContentIndicatorEvLinksForEvent ()

  Purpose: Deletes all SecContentIndicatorEvLink records for the specified Event Id.

  Parameters:
    Event Id

  Returns:
     None

  */
  public void deleteSecContentIndicatorEvLinksForEvent (String eventId)
  {
    try
    {
      Statement stmt = m_db.m_conn.createStatement ();
      String    sqlString;
      String    ret;

      sqlString = "DELETE from SecContentIndicatorEvLink WHERE eventId = " + eventId;
      m_db.runSQL (sqlString, stmt);
      stmt.close ();
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in deleteSecContentIndicatorEvLinksForEvent().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
  }

  /*
  Name: getSecContentIndicatorEvLinks ()

  Purpose: Returns a record set with all of the SecContentIndicatorEvLinks information in it.

  Parameters:
    p_stmt : Database statement

  Returns:
     A record set.

  */
  public CachedRowSet getSecContentIndicatorEvLinks(int eventId)
  {
    CachedRowSet l_rs;
    String       sqlString;
    String       l_ret;

    try
    {
      Statement stmt = m_db.m_conn.createStatement ();

      sqlString = "SELECT * FROM SecContentIndicatorEvLink scil, SecContentIndicatorPreferred scip " +
                  "WHERE scil.SecContentIndicatorPreferredId = scip.SecContentIndicatorPreferredId " +
                  "AND   eventId = " + eventId;
      l_rs = m_db.runSQL (sqlString, stmt);
      stmt.close();
      return (l_rs);
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getSecContentIndicatorEvLinks().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      return (null);
    }
  }

  /*
  Name: getSecContentIndicatorEvLinksForEvent (eventId)

  Purpose: Returns a Vector containing all the SecContentIndicatorEvLinks for this Event.

  Parameters:
    Event Id

  Returns:
     A Vector of all SecContentIndicatorEvLinks for this Event.
  */

  public Vector getSecContentIndicatorEvLinksForEvent(int eventId)
  {
    Vector allSecContentIndicatorEvLinks = new Vector();
    CachedRowSet rset = this.getSecContentIndicatorEvLinks(eventId);
    SecContentIndicatorEvLink secContentIndicatorEvLink = null;
    String SecContentIndPrefId = "0";
    String SecContentIndPref   = "";
    SecondaryContentInd secondaryContentInd = null;
    try
    {
      while (rset.next())
      {
        secContentIndicatorEvLink = new SecContentIndicatorEvLink(m_db);
        SecContentIndPrefId       = rset.getString("SecContentIndicatorPreferredId");
        SecContentIndPref         = rset.getString("PreferredTerm");

        secContentIndicatorEvLink.setSecContentIndPrefId(SecContentIndPrefId);
        secContentIndicatorEvLink.setSecContentIndPref(SecContentIndPref);
        secContentIndicatorEvLink.setEventId(rset.getString("eventId"));

        allSecContentIndicatorEvLinks.add(secContentIndicatorEvLink);
      }
    }
    catch (Exception e)
    {
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in getSecContentIndicatorEvLinksForEvent().");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
    }
    finally
    {
      try {rset.close ();} catch (Exception ex) {}
    }
    return allSecContentIndicatorEvLinks;
  }

  public boolean equals (SecContentIndicatorEvLink p)
  {
    if (p == null) return false;
    if (p.toString().equals(this.toString()))
      return true;
    return false;
  }

  public void setSecContentIndPrefId (String s) {secContentIndPrefId = s;}
  public void setSecContentIndPref   (String s) {secContentIndPref   = s;}
  public void setEventId             (String s) {eventId             = s;}

  public String getSecContentIndPrefId () {return (secContentIndPrefId);}
  public String getSecContentIndPref   () {return (secContentIndPref);}
  public String getEventId             () {return (eventId);}
  public String getError               () {return (m_error_string);}

  public String toString ()
  {
    return secContentIndPrefId + " " + eventId;
  }
}

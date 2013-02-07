/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: OrgEvLink.java

Purpose: Provides OrgEvLink object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class WorkEvLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String eventId;
	private String workId;
	private String m_error_string;

	// private Work work;

	/*
	 * Name: OrgEvLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public WorkEvLink(ausstage.Database m_db2) {
		m_db = m_db2;
		initialise();
	}

	/*
	 * Name: initialise ()
	 * 
	 * Purpose: Resets the object to point to no record.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	public void initialise() {
		eventId = "0";
		workId = "0";

		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the OrgEvLink information for the
	 * specified OrgEvLink id.
	 * 
	 * Parameters: p_id : id of the Organisation record e_id : id of the Event
	 * record Note: There is no unique key for this table.
	 * 
	 * Returns: None
	 */
	public void load(String p_id, String e_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		workId = p_id;
		eventId = e_id;

	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: eventId String array of OrgEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String eventId, Vector orgEvLinks) {
		return update(eventId, orgEvLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all OrgEvLinks
	 * for this Event and inserting new ones from an array of OrgEvLink records
	 * to link to this Event.
	 * 
	 * Parameters: Event Id String array of OrgEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String eventId, Vector work) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM EventWorkLink where " + "eventId=" + eventId;
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; work != null && i < work.size(); i++) {

				sqlString = "INSERT INTO EventWorkLink " + "(eventId, workid) " + "VALUES (" + eventId + ", " + work.elementAt(i) + ")";
				m_db.runSQL(sqlString, stmt);

			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to process the selected Work Link records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteOrgEvLinksForEvent ()
	 * 
	 * Purpose: Deletes all OrgEvLink records for the specified Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deleteWorkEvLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from eventworklink WHERE eventId = " + eventId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteWorkEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getWorkEvLinks ()
	 * 
	 * Purpose: Returns a record set with all of the OrgEvLinks information in
	 * it.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A record set.
	 */
	public Vector getWorkEvLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;
		Vector l_work = new Vector();
		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM EVENTWORKLINK " + " WHERE eventId  = " + eventId;
			l_rs = m_db.runSQL(sqlString, stmt);

			while (l_rs.next()) {

				l_work.add(l_rs.getString("workId"));

			}

			l_rs.close();
			stmt.close();

			return (l_work);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getWorkEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setWorkId(String s) {
		workId = s;
	}

	public String getEventId() {
		return (eventId);
	}

	public String getWorkId() {
		return (workId);
	}

	public String getError() {
		return (m_error_string);
	}

}

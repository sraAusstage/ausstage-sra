/***************************************************

Company: SRA Information Technology
 Author: Omkar Nandurkar

   File: EventEventLink.java

Purpose: Provides Event to Event object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class EventEventLinkBKUP {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information

	private String eventId;
	private String childId;
	private String functionLovId;
	private String notes;
	private String m_error_string;

	/*
	 * Name: EventEventLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public EventEventLinkBKUP(ausstage.Database m_db2) {
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
		childId = "0";
		functionLovId = "0";
		notes = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the EventEventLink information for
	 * the specified EventEventLink id.
	 * 
	 * Parameters: p_event_id : id of the main Event record
	 * 
	 * Returns: None
	 */
	public void load(String p_eventeventlink_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM EventEventLink "
				+ " WHERE eventeventlinkId = " + p_eventeventlink_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {

				eventId = l_rs.getString("eventId");
				childId = l_rs.getString("childId");
				functionLovId = l_rs.getString("function_lov_id");
				notes = l_rs.getString("notes");

				if (notes == null) notes = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in EventEventLink: load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: eventId String array of child Event ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String p_eventId, Vector<EventEventLinkBKUP> p_childLinks) {
		return update(p_eventId, p_childLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * EventEventLinks for this event and inserting new ones from an array of
	 * p_childLinks.
	 * 
	 * Parameters: event Id String array of child event ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String p_eventId, Vector<EventEventLinkBKUP> p_childLinks) {
		// System.out.println("In update:" + p_childLinks + ", Event Id:"+
		// p_eventId);
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			System.out.println("In update");
			sqlString = "DELETE FROM EventEventLink where " + "eventId=" + p_eventId;
			m_db.runSQL(sqlString, stmt);
			if (p_childLinks != null) {
				// System.out.println("Event:" + p_childLinks + ", Event Id:"+
				// p_eventId);
				for (int i = 0; i < p_childLinks.size(); i++) {
					sqlString = "INSERT INTO EventEventLink " + "(eventId, childId, function_lov_id, notes) " + "VALUES (" + p_eventId + ", "
						+ p_childLinks.get(i).getChildId() + ", " + p_childLinks.get(i).getFunctionId() + ", '"+m_db.plSqlSafeString(p_childLinks.get(i).getNotes())+ "' )";
					
					m_db.runSQL(sqlString, stmt);
				}
				l_ret = true;
			}

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected event Link records.";
			return (false);
		}
	}

	/*
	 * Name: deleteEventEventLinksForEvent ()
	 * 
	 * Purpose: Deletes all EventEventLink records for the specified Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deleteEventEventLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from EventEventLink WHERE eventId = " + eventId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteConEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getEventEventLinks ()
	 * 
	 * Purpose: Returns a record set with all of the EventEventLinks information
	 * in it.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getEventEventLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT eventeventlink.* " + " FROM EventEventLink " + " WHERE EventEventLink.eventId  = " + eventId;

			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getEventEventLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getConEvLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the ConEvLinks for this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all ConEvLinks for this Event.
	 */

	public Vector<EventEventLinkBKUP> getEventEventLinksForEvent(int eventId) {
		Vector<EventEventLinkBKUP> allEventEventLinks = new Vector<EventEventLinkBKUP>();
		CachedRowSet rset = this.getEventEventLinks(eventId);
		EventEventLinkBKUP eventEventLink = null;

		try {
			while (rset.next()) {
				eventEventLink = new EventEventLinkBKUP(m_db);
				eventEventLink.setEventId(rset.getString("eventId"));
				eventEventLink.setChildId(rset.getString("childId"));
				eventEventLink.setFunctionLovId(rset.getString("function_lov_Id"));
				eventEventLink.setNotes(rset.getString("notes"));

				allEventEventLinks.add(eventEventLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getEvEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		} finally {
			try {
				rset.close();
			} catch (Exception ex) {
			}
		}
		return allEventEventLinks;
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setChildId(String s) {
		childId = s;
	}

	public void setFunctionLovId(String s) {
		functionLovId = s;
	}

	public void setNotes(String s) {
		notes = s;
		if (notes == null) notes = "";
		if (notes.length() > 500) notes = notes.substring(0, 499);
	}

	public String getEventId() {
		return (eventId);
	}

	public String getChildId() {
		return (childId);
	}

	public String getFunctionId() {
		return (functionLovId);
	}

	public String getNotes() {
		return (notes);
	}

	public String getError() {
		return (m_error_string);
	}
}

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

public class EventEventLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String eventId;
	private String childId;
	private String relationLookupId;
	private String notes;
	private String childNotes;
	private String orderby;
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
	public EventEventLink(ausstage.Database m_db2) {
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
		relationLookupId = "0";
		notes = "";
		childNotes = "";
		orderby = "0";
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
				+ " WHERE eventeventlinkId = " + m_db.plSqlSafeString(p_eventeventlink_id);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {

				eventId = l_rs.getString("eventId");
				childId = l_rs.getString("childId");
				relationLookupId = l_rs.getString("relationlookupid");
				notes = l_rs.getString("notes");
				childNotes = l_rs.getString("childnotes");
				orderby = l_rs.getString("orderby");

				if (notes == null) notes = "";
				if (childNotes == null) childNotes = "";
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
	public boolean add(String p_eventId, Vector<EventEventLink> p_links) {
		return update(p_eventId, p_links);
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
	public boolean update(String p_eventId, Vector<EventEventLink> p_links) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM EventEventLink where " + "eventId=" + m_db.plSqlSafeString(p_eventId);
			m_db.runSQL(sqlString, stmt);
			sqlString = "DELETE FROM EventEventLink where " + "childId=" + m_db.plSqlSafeString(p_eventId);
			m_db.runSQL(sqlString, stmt);
			if (p_links != null) {
				for (int i = 0; i < p_links.size(); i++) {
					sqlString = "INSERT INTO EventEventLink " + "(eventId, childId, relationlookupid, notes, childnotes, orderby) " 
								+ "VALUES (" + p_links.get(i).getEventId() 
								+ ", " + p_links.get(i).getChildId() 
								+ ", " + p_links.get(i).getRelationLookupId()
								+ ", '" + m_db.plSqlSafeString(p_links.get(i).getNotes())+ "' "
								+ ", '" + m_db.plSqlSafeString(p_links.get(i).getChildNotes())+ "' "
								+ ", " + p_links.get(i).getOrderby() + ")";
					
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
			//String ret;
			sqlString = "DELETE from EventEventLink WHERE eventId = " + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);
			sqlString = "DELETE from EventEventLink WHERE childId = " + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteEventEventLinksForEvent().");
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

			/*sqlString = "SELECT eventeventlink.* " 
						+ " FROM EventEventLink " 
						+ " WHERE (EventEventLink.eventId  = " + eventId
						+ " OR EventEventLink.childid = "+ eventId + ")" ;*/
			
			sqlString = "SELECT eventeventlink.* "
						 + "FROM eventeventlink eel, events e, events child, relation_lookup rl " 
						 + "WHERE (eel.eventid =  "+ eventId +"  || eel.childid = "+ eventId +") " 
						 + "AND eel.eventid = e.eventid " 
						 + "AND eel.childid = child.eventid " 
						 + "AND eel.relationlookupid = rl.relationlookupid " 
						 + "ORDER BY CASE WHEN eel.childid = "+ eventId +" THEN rl.child_relation ELSE rl.parent_relation END, " 
						 + "CASE WHEN eel.childid = "+ eventId +" THEN e.event_name ELSE child.event_name END";
			
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
	 * Name: getEventEventLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the ConEvLinks for this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all ConEvLinks for this Event.
	 */

	public Vector<EventEventLink> getEventEventLinksForEvent(int eventId) {
		Vector<EventEventLink> allEventEventLinks = new Vector<EventEventLink>();
		CachedRowSet rset = this.getEventEventLinks(eventId);
		EventEventLink eventEventLink = null;

		try {
			while (rset.next()) {
				eventEventLink = new EventEventLink(m_db);
				eventEventLink.setEventId(rset.getString("eventId"));
				eventEventLink.setChildId(rset.getString("childId"));
				eventEventLink.setRelationLookupId(rset.getString("relationlookupid"));
				eventEventLink.setNotes(rset.getString("notes"));
				eventEventLink.setChildNotes(rset.getString("childnotes"));
				eventEventLink.setOrderby(rset.getString("orderby"));

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

	public void setRelationLookupId(String s) {
		relationLookupId = s;
	}
	public void setNotes(String s) {
		notes = s;
		if (notes == null) notes = "";
		if (notes.length() > 500) notes = notes.substring(0, 499);
	}

	public void setChildNotes(String s) {
		childNotes = s;
		if (childNotes == null) childNotes = "";
		if (childNotes.length() > 500) childNotes = childNotes.substring(0, 499);
	}
	
	public void setOrderby (String s) {
		orderby = s;
	}
	
	public String getEventId() {
		return (eventId);
	}

	public String getChildId() {
		return (childId);
	}
	
	public String getRelationLookupId() {
		return (relationLookupId);
	}

	public String getNotes() {
		return (notes);
	}

	public String getChildNotes() {
		return (childNotes);
	}
	
	public String getOrderby () {
		return orderby;
	}
	
	public String getError() {
		return (m_error_string);
	}
}

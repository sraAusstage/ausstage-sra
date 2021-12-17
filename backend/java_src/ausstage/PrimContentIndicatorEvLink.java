/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: PrimContentIndicatorEvLink.java

Purpose: Provides PrimContentIndicatorEvLink object functions.
2015 migration to github
 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import ausstage.PrimaryContentInd;
import sun.jdbc.rowset.CachedRowSet;

public class PrimContentIndicatorEvLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String primContentIndicatorId;
	private String eventId;
	private PrimaryContentInd primaryContentInd;
	private String m_error_string;

	/*
	 * Name: PrimContentIndicatorEvLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public PrimContentIndicatorEvLink(ausstage.Database p_db) {
		m_db = p_db;
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
		primContentIndicatorId = "0";
		eventId = "0";
		primaryContentInd = new PrimaryContentInd(m_db);
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the PrimContentIndicatorEvLink
	 * information for the specified Primary Content Indicator id.
	 * 
	 * Parameters: p_id : id of the Primary Content Indicator record e_id : id
	 * of the Event record Note: There is no unique key for this table.
	 * 
	 * Returns: None
	 */
	public void load(String p_id, String e_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		primContentIndicatorId = m_db.plSqlSafeString(p_id);
		eventId = m_db.plSqlSafeString(e_id);
		primaryContentInd.load(Integer.parseInt(primContentIndicatorId));

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM PrimContentIndicatorEvLink" + " WHERE primContentIndicatorId = " + p_id + " AND   eventId                = " + e_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Set up the new data
				// Note - no extra data in table in any case!
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in PrimContentIndicatorEvLink: load().");
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
	 * Parameters: collectionInformationId String array of Primary Content
	 * Indicator EvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String eventId, Vector primContentIndicatorEvLinks) {
		return update(eventId, primContentIndicatorEvLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * PrimContentIndicatorEvLinks for this Event and inserting new ones from an
	 * array of Primary Content Indicator records to link to this Event.
	 * 
	 * Parameters: Event Id String array of Primary Content Indicator Link
	 * records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String eventId, Vector primContentIndicatorEvLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			PrimContentIndicatorEvLink evLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM PrimContentIndicatorEvLink where " + "eventId=" + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; primContentIndicatorEvLinks != null && i < primContentIndicatorEvLinks.size(); i++) {
				evLink = (PrimContentIndicatorEvLink) primContentIndicatorEvLinks.get(i);
				sqlString = "INSERT INTO PrimContentIndicatorEvLink " + "(primContentIndicatorId, eventId) VALUES (" + evLink.getPrimContentIndicatorId() + ", " + m_db.plSqlSafeString(eventId) + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Subjects records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deletePrimContentIndicatorEvLinksForEvent ()
	 * 
	 * Purpose: Deletes all PrimContentIndicatorEvLink records for the specified
	 * Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deletePrimContentIndicatorEvLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from PrimContentIndicatorEvLink WHERE eventId = " + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deletePrimContentIndicatorEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getPrimContentIndicatorEvLinks ()
	 * 
	 * Purpose: Returns a record set with all of the PrimContentIndicatorEvLinks
	 * information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getPrimContentIndicatorEvLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			// addition to the select to order results alphabetically. 
			sqlString = "SELECT * FROM PrimContentIndicatorEvLink "+
						"RIGHT JOIN contentindicator ON primcontentindicatorid = contentindicatorid  "+
						"WHERE eventId = " + eventId + 
						" ORDER BY contentindicator";
			
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getPrimContentIndicatorEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getPrimContentIndicatorEvLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the PrimContentIndicatorEvLinks
	 * for this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all PrimContentIndicatorEvLinks for this Event.
	 */

	public Vector getPrimContentIndicatorEvLinksForEvent(int eventId) {
		
		Vector allPrimContentIndicatorEvLinks = new Vector();
		CachedRowSet rset = this.getPrimContentIndicatorEvLinks(eventId);
		
		PrimContentIndicatorEvLink primContentIndicatorEvLink = null;
		String primContentIndicatorId = "0";
		PrimaryContentInd primaryContentInd = null;
		try {
			while (rset.next()) {
				primContentIndicatorEvLink = new PrimContentIndicatorEvLink(m_db);
				primaryContentInd = new PrimaryContentInd(m_db);
				primContentIndicatorId = rset.getString("primContentIndicatorId");				
				primContentIndicatorEvLink.setPrimContentIndicatorId(primContentIndicatorId);
				primContentIndicatorEvLink.setEventId(rset.getString("eventId"));								
				primaryContentInd.load(Integer.parseInt(primContentIndicatorId));
				primContentIndicatorEvLink.setPrimaryContentInd(primaryContentInd);
				allPrimContentIndicatorEvLinks.add(primContentIndicatorEvLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getPrimContentIndicatorEvLinksForEvent().");
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
		return allPrimContentIndicatorEvLinks;
	}

	public boolean equals(PrimContentIndicatorEvLink p) {
		if (p == null) return false;
		if (p.toString().equals(this.toString())) return true;
		return false;
	}

	public void setPrimContentIndicatorId(String s) {
		primContentIndicatorId = s;
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setPrimaryContentInd(PrimaryContentInd p) {
		primaryContentInd = p;
	}

	public String getPrimContentIndicatorId() {
		return (primContentIndicatorId);
	}

	public String getEventId() {
		return (eventId);
	}

	public PrimaryContentInd getPrimaryContentInd() {
		return (primaryContentInd);
	}

	public String getError() {
		return (m_error_string);
	}

	public String toString() {
		return primContentIndicatorId + " " + eventId;
	}
}

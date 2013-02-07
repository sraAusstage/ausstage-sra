/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Ausstage

   File: SecGenreEvLink.java

Purpose: Provides SecGenreEvLink object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import ausstage.SecondaryGenre;
import sun.jdbc.rowset.CachedRowSet;

public class SecGenreEvLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String secGenrePreferredId;
	private String eventId;
	private SecondaryGenre secondaryGenre;
	private String m_error_string;

	/*
	 * Name: SecGenreEvLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public SecGenreEvLink(ausstage.Database m_db2) {
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
		secGenrePreferredId = "0";
		eventId = "0";
		secondaryGenre = new SecondaryGenre(m_db);
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the SecGenreEvLink information for
	 * the specified Secondary Genre id.
	 * 
	 * Parameters: p_id : id of the Secondary Genrerecord e_id : id of the Event
	 * record Note: There is no unique key for this table.
	 * 
	 * Returns: None
	 */
	public void load(String p_id, String e_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		secGenrePreferredId = p_id;
		eventId = e_id;
		secondaryGenre.loadLinkedProperties(Integer.parseInt(secGenrePreferredId));

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM secgenreclasslink " + "WHERE secGenrePreferredId = " + p_id + " " + "AND eventid= " + e_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Set up the new data
				// Note - no extra data in table in any case!
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecGenreEvLink: load().");
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
	 * Parameters: collectionInformationId String array of Secondary Genre
	 * EvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String eventId, Vector secondaryGenreEvLinks) {
		return update(eventId, secondaryGenreEvLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * SecGenreEvLink for this Event and inserting new ones from an array of
	 * Secondary Genre records to link to this Event.
	 * 
	 * Parameters: Event Id String array of Secondary Genre Link records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String eventId, Vector secondaryGenreEvLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			SecGenreEvLink evLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM secgenreclasslink where " + "eventId=" + eventId;
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; secondaryGenreEvLinks != null && i < secondaryGenreEvLinks.size(); i++) {
				evLink = (SecGenreEvLink) secondaryGenreEvLinks.get(i);
				sqlString = "INSERT INTO secgenreclasslink " + "(secGenrePreferredId, eventId) VALUES (" + evLink.getSecGenrePreferredId() + ", " + eventId + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Secondary Genre. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteSecondaryGenreEvLinksForEvent ()
	 * 
	 * Purpose: Deletes all SecGenreEvLink records for the specified Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deleteSecondaryGenreEvLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from secgenreclasslink WHERE eventId = " + eventId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteSecondaryGenreEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getSecondaryGenreEvLinks ()
	 * 
	 * Purpose: Returns a record set with all of the SecondaryGenreEvLinks
	 * information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getSecondaryGenreEvLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM secgenreclasslink WHERE eventId = " + eventId;
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getSecondaryGenreEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getSecondaryGenreEvLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the SecondaryGenreEvLinks for
	 * this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all SecondaryGenreEvLinks for this Event.
	 */

	public Vector getSecondaryGenreEvLinksForEvent(int eventId) {
		Vector allSecondaryGenreEvLinks = new Vector();
		CachedRowSet rset = this.getSecondaryGenreEvLinks(eventId);
		SecGenreEvLink secGenreEvLink = null;
		String secGenrePreferredId = "0";
		SecondaryGenre secondaryGenre = null;
		try {
			while (rset.next()) {
				secGenreEvLink = new SecGenreEvLink(m_db);
				secondaryGenre = new SecondaryGenre(m_db);
				secGenrePreferredId = rset.getString("secGenrePreferredId");

				secGenreEvLink.setSecGenrePreferredId(secGenrePreferredId);
				secGenreEvLink.setEventId(rset.getString("eventId"));

				// secondaryGenre.load(Integer.parseInt(secGenrePreferredId));
				secondaryGenre.loadLinkedProperties(Integer.parseInt(secGenrePreferredId));
				secGenreEvLink.setSecondaryGenre(secondaryGenre);

				allSecondaryGenreEvLinks.add(secGenreEvLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getSecondaryGenreEvLinksForEvent().");
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
		return allSecondaryGenreEvLinks;
	}

	public boolean equals(SecGenreEvLink p) {
		if (p == null) return false;
		if (p.toString().equals(this.toString())) return true;
		return false;
	}

	public void setSecGenrePreferredId(String s) {
		secGenrePreferredId = s;
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setSecondaryGenre(SecondaryGenre p) {
		secondaryGenre = p;
	}

	public String getSecGenrePreferredId() {
		return (secGenrePreferredId);
	}

	public String getEventId() {
		return (eventId);
	}

	public SecondaryGenre getSecondaryGenre() {
		return (secondaryGenre);
	}

	public String getError() {
		return (m_error_string);
	}

	public String toString() {
		return secGenrePreferredId + " " + eventId;
	}
}

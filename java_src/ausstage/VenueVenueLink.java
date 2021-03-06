package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class VenueVenueLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String venueId;
	private String childId;
	private String relationLookupId;
	private String notes;
	private String childNotes;
	private String m_error_string;

	/*
	 * Name: VenueVenueLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public VenueVenueLink(ausstage.Database m_db2) {
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
		venueId = "0";
		childId = "0";
		relationLookupId = "0";
		notes = "";
		childNotes = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * 
	 * Parameters: p_venue_id : id of the main venue record
	 * 
	 * Returns: None
	 */

	public void load(String p_venuevenuelink_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM VenueVenueLink"
					+ " WHERE venuevenuelinkId = " + m_db.plSqlSafeString(p_venuevenuelink_id);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// venuevenuelinkId = l_rs.getString("venuevenuelinkId");
				venueId = l_rs.getString("venueId");
				childId = l_rs.getString("childId");
				relationLookupId = l_rs.getString("relationlookupid");
				notes = l_rs.getString("notes");
				childNotes = l_rs.getString("childnotes");

				if (notes == null) notes = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in VenueVenueLink: load().");
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
	 * Parameters: venueId String array of child venue ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean add(String p_venueId, Vector<VenueVenueLink> p_childLinks) {
		return update(p_venueId, p_childLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * VenueVenueLinks for this Venue and inserting new ones from an array of
	 * p_childLinks.
	 * 
	 * Parameters: Venue Id String array of child venue ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean update(String p_venueId, Vector<VenueVenueLink> p_links) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM VenueVenueLink where " + "venueId=" + m_db.plSqlSafeString(p_venueId);
			m_db.runSQL(sqlString, stmt);
			sqlString = "DELETE FROM VenueVenueLink where " + "childId=" + m_db.plSqlSafeString(p_venueId);
			m_db.runSQL(sqlString, stmt);
			
			if (p_links != null) {
				for (int i = 0; i < p_links.size(); i++) {
					sqlString = "INSERT INTO venueVenueLink " + "(venueId, childId, relationlookupid, notes, childnotes) " 
								+ "VALUES (" + p_links.get(i).getVenueId() 
								+ ", "+ p_links.get(i).getChildId() 
								+ ", " + p_links.get(i).getRelationLookupId() 
								+ ", '" + m_db.plSqlSafeString(p_links.get(i).getNotes()) +"'"
								+ ", '" + m_db.plSqlSafeString(p_links.get(i).getChildNotes()) +"')";
					
					m_db.runSQL(sqlString, stmt);
				}
				l_ret = true;
			}
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected venue Link records.";
			return (false);
		}
	}

	/*
	 * Name: deleteVenueVenueLinksForVenue ()
	 * 
	 * Purpose: Deletes all VenueVenueLink records for the specified Venue Id.
	 * 
	 * Parameters: deleteVenueVenueLinksForVenue Id
	 * 
	 * Returns: None
	 */
	public void deleteVenueVenueLinksForVenue(String venueId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			
			sqlString = "DELETE from VenueVenueLink WHERE venueId = " + m_db.plSqlSafeString(venueId);
			m_db.runSQL(sqlString, stmt);
			//stmt.close();
			
			sqlString = "DELETE from VenueVenueLink WHERE childId = " + m_db.plSqlSafeString(venueId);
			m_db.runSQL(sqlString, stmt);
			stmt.close();
			
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteVenueVenueLinksForVenue().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getVenueVenueLinks ()
	 * 
	 * Purpose: Returns a record set with all of the VenueVenueLinks information
	 * in it.
	 * 
	 * Parameters: Venue Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getVenueVenueLinks(int venueId) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT vvl.* "
						+ " FROM venuevenuelink vvl, venue v, venue child, relation_lookup rl" 
						+ " WHERE (vvl.venueid =  " + venueId + "  || vvl.childid = " + venueId + ")" 
						+ " AND vvl.venueid = v.venueid" 
						+ " AND vvl.childid = child.venueid" 
						+ " AND vvl.relationlookupid = rl.relationlookupid" 
						+ " ORDER BY CASE WHEN vvl.childid = " + venueId + " THEN rl.child_relation ELSE rl.parent_relation END," 
						+ " CASE WHEN vvl.childid = " + venueId + " THEN v.venue_name ELSE child.venue_name END";

			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getVenueVenueLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getVenueVenueLinksForVenue (venueId)
	 * 
	 * Purpose: Returns a Vector containing all the VenueVenueLinks for this
	 * venue.
	 * 
	 * Parameters: venue Id
	 * 
	 * Returns: A Vector of all VenueVenueLinks for this venue.
	 */

	public Vector<VenueVenueLink> getVenueVenueLinksForVenue(int venueId) {
		Vector<VenueVenueLink> allVenueVenueLinks = new Vector<VenueVenueLink>();
		CachedRowSet rset = this.getVenueVenueLinks(venueId);
		VenueVenueLink venueVenueLink = null;

		try {
			while (rset.next()) {
				venueVenueLink = new VenueVenueLink(m_db);
				venueVenueLink.setVenueId(rset.getString("venueId"));
				venueVenueLink.setChildId(rset.getString("childId"));
				venueVenueLink.setRelationLookupId(rset.getString("relationlookupid"));
				venueVenueLink.setNotes(rset.getString("notes"));
				venueVenueLink.setChildNotes(rset.getString("childnotes"));

				allVenueVenueLinks.add(venueVenueLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getVenueVenueLinksForVenue().");
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
		return allVenueVenueLinks;
	}

	public void setVenueId(String s) {
		venueId = s;
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
	
	public String getVenueId() {
		return (venueId);
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
	
	public String getError() {
		return (m_error_string);
	}
}

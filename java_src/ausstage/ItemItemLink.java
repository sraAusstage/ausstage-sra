/***************************************************

Company: Ignition Design
 Author: Justin Brow

   File: ItemItemLink.java

Purpose: Provides Item to Item object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class ItemItemLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	// private String itemItemLinkId;
	private String itemId;
	private String childId;
	private String relationLookupId;
	private String notes;
	private String childNotes;
	private String m_error_string;

	/*
	 * Name: ItemItemLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public ItemItemLink(ausstage.Database m_db2) {
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
		// itemItemLinkId = "0";
		itemId = "0";
		childId = "0";
		relationLookupId = "0";
		notes = "";
		childNotes = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the ConEvLink information for the
	 * specified ConEvLink id.
	 * 
	 * Parameters: p_item_id : id of the main item record
	 * 
	 * Returns: None
	 */
	public void load(String p_itemitemlink_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM ItemItemLink" 
					+ " WHERE itemitemlinkId = " + m_db.plSqlSafeString(p_itemitemlink_id);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// itemItemLinkId = l_rs.getString("itemIdItemLinkId");
				itemId = l_rs.getString("itemId");
				childId = l_rs.getString("childId");
				relationLookupId = l_rs.getString("relationlookupid");
				notes = l_rs.getString("notes");
				childNotes = l_rs.getString("childnotes");

				if (notes == null) notes = "";
				if (childNotes == null) childNotes = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ItemItemLink: load().");
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
	 * Parameters: eventId String array of child item ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String p_itemId, Vector p_childLinks) {
		return update(p_itemId, p_childLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * ItemItemLinks for this item and inserting new ones from an array of
	 * p_childLinks.
	 * 
	 * Parameters: Item Id String array of child item ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String p_itemId, Vector p_childLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			ItemItemLink itemItemLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM ItemItemLink where " + "itemId=" + m_db.plSqlSafeString(p_itemId);
			m_db.runSQL(sqlString, stmt);
			sqlString = "DELETE FROM ItemItemLink where " + "childId=" + m_db.plSqlSafeString(p_itemId);
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; p_childLinks != null && i < p_childLinks.size(); i++) {
				itemItemLink = (ItemItemLink) p_childLinks.get(i);
				sqlString = "INSERT INTO ItemItemLink " 
							+ "(itemId, childId, relationloookupid, notes, childnotes) " 
							+ "VALUES (" + itemItemLink.getItemId() 
							+ ", " + itemItemLink.getChildId() 
							+ ", " + itemItemLink.getRelationLookupId() 
							+ ", '" + m_db.plSqlSafeString(itemItemLink.getNotes()) + "'"
							+ ", '" + m_db.plSqlSafeString(itemItemLink.getChildNotes()) + "')";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected item Link records.";
			return (false);
		}
	}

	public void setItemId(String s) {
		itemId = s;
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
	
	public String getItemId() {
		return (itemId);
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

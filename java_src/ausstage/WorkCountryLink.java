/***************************************************

Company: Ignition Design
 Author: Justin Brow

   File: WorkContribLink.java

Purpose: Provides Item to Item object functions.
2015 migration to github
 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class WorkCountryLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	// private String ItemContribLinkId;
	private String workId;
	private String countryId;
	private String m_error_string;

	/*
	 * Name: ItemCountryLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public WorkCountryLink(ausstage.Database m_db2) {
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
		workId = "0";
		countryId = "0";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the WorkCountryLink information for the
	 * specified WorkCountryLink id.
	 * 
	 * Parameters: p_item_id : id of the main item record
	 * 
	 * Returns: None
	 */
	public void load(String p_WORKCOUNTRYLINKID) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM WORKCOUNTRYLINK" + " WHERE WORKCOUNTRYLINKID = " + m_db.plSqlSafeString(p_WORKCOUNTRYLINKID);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				workId = l_rs.getString("WORKID");
				countryId = l_rs.getString("COUNTRYID");

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in WorkCountryLink: load().");
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
	public boolean add(String p_workId, Vector p_countryLinks) {
		return update(p_workId, p_countryLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * WorkCountryLinks for this item and inserting new ones from an array of
	 * p_childLinks.
	 * 
	 * Parameters: Item Id String array of child item ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String p_workId, Vector p_countryLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			WorkCountryLink workCountryLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM WORKCOUNTRYLINK where " + "workid=" + m_db.plSqlSafeString(p_workId);
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; p_countryLinks != null && i < p_countryLinks.size(); i++) {
				workCountryLink = (WorkCountryLink) p_countryLinks.get(i);
				sqlString = "INSERT INTO WORKCOUNTRYLINK " + "(workid, COUNTRYID) " + "VALUES (" + m_db.plSqlSafeString(p_workId) + ", " + workCountryLink.getCountryId() + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected country Link records.";
			return (false);
		}
	}

	public void setWorkId(String s) {
		workId = s;
	}

	public void setCountryId(String s) {
		countryId = s;
	}

	public String getWorkId() {
		return (workId);
	}

	public String getCountryId() {
		return (countryId);
	}

	public String getError() {
		return (m_error_string);
	}
}

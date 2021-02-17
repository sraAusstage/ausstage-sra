/***************************************************

Company: Ignition Design
 Author: Justin Brow

   File: WorkOrganLink.java

Purpose: Provides Item to Item object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class WorkOrganLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	// private String ItemContribLinkId;
	private String workId;
	private String organId;
	private String orderBy;
	private String m_error_string;

	/*
	 * Name: ItemOrganLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public WorkOrganLink(ausstage.Database m_db2) {
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
		organId = "0";
		orderBy = "0";
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
	public void load(String p_WORKORGLINKID) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM WORKORGLINK" + " WHERE WORKORGLINKID = " + m_db.plSqlSafeString(p_WORKORGLINKID);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// ItemContribLinkId = l_rs.getString("itemIdItemLinkId");
				workId = l_rs.getString("WORKID");
				organId = l_rs.getString("ORGANISATIONID");
				orderBy = l_rs.getString("ORDER_BY");

				if (orderBy == null) orderBy = "0";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in WorkOrganLink: load().");
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
	public boolean add(String p_workId, Vector p_organLinks) {
		return update(p_workId, p_organLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * ItemContribLinks for this item and inserting new ones from an array of
	 * p_childLinks.
	 * 
	 * Parameters: Item Id String array of child item ids.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String p_workId, Vector p_organLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			WorkOrganLink workOrganLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM WORKORGLINK where " + "workid=" + m_db.plSqlSafeString(p_workId);
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; p_organLinks != null && i < p_organLinks.size(); i++) {
				workOrganLink = (WorkOrganLink) p_organLinks.get(i);
				sqlString = "INSERT INTO WORKORGLINK " + "(workid, WORKORGLINK, orderBy) " + "VALUES (" + m_db.plSqlSafeString(p_workId) + ", " + workOrganLink.getOrganId() + ","
						+ workOrganLink.getOrderBy() + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected organ Link records.";
			return (false);
		}
	}

	public void setWorkId(String s) {
		workId = s;
	}

	public void setOrganId(String s) {
		organId = s;
	}

	public void setOrderBy(String s) {
		orderBy = s;
	}

	public String getWorkId() {
		return (workId);
	}

	public String getOrganId() {
		return (organId);
	}

	public String getOrderBy() {
		return (orderBy);
	}

	public String getError() {
		return (m_error_string);
	}
}

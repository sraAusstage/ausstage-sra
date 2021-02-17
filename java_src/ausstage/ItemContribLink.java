/***************************************************

Company: Ignition Design
 Author: Justin Brow

   File: ItemContribLink.java

Purpose: Provides Item to Item object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class ItemContribLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	// private String ItemContribLinkId;
	private String itemId;
	private String contribId;
	private String creatorFlag;
	private String orderBy;
	private String functionId;
	private String m_error_string;

	/*
	 * Name: ItemContribLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public ItemContribLink(ausstage.Database m_db2) {
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
		itemId = "0";
		contribId = "0";
		creatorFlag = "";
		orderBy = "0";
		functionId = "0";
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
	public void load(String p_ITEMCONLINKID, String p_creator_flag) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM ITEMCONLINK" + " WHERE ITEMCONLINKID = " + m_db.plSqlSafeString(p_ITEMCONLINKID) + "   AND ((creator_flag is NULL and '" + m_db.plSqlSafeString(p_creator_flag)
					+ "'='N') or creator_flag='" + m_db.plSqlSafeString(p_creator_flag) + "')";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// ItemContribLinkId = l_rs.getString("itemIdItemLinkId");
				itemId = l_rs.getString("itemid");
				contribId = l_rs.getString("CONTRIBUTORID");
				creatorFlag = p_creator_flag;
				orderBy = l_rs.getString("orderBy");
				functionId = l_rs.getString("function_lov_id");

				if (orderBy == null) orderBy = "0";
				if (functionId == null) functionId = "0";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ItemContribLink: load().");
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
	public boolean add(String p_itemId, Vector p_contribLinks, String p_creator_flag) {
		return update(p_itemId, p_contribLinks, p_creator_flag);
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
	public boolean update(String p_itemId, Vector p_contribLinks, String p_creator_flag) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			ItemContribLink itemContribLink = null;
			String sqlString;
			String functionId;
			boolean l_ret = false;

			sqlString = "DELETE FROM ITEMCONLINK where " + "itemId=" + m_db.plSqlSafeString(p_itemId) + " AND ((creator_flag is NULL and '" + m_db.plSqlSafeString(p_creator_flag) + "'='N') or creator_flag='"
					+ m_db.plSqlSafeString(p_creator_flag) + "')";
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; p_contribLinks != null && i < p_contribLinks.size(); i++) {
				itemContribLink = (ItemContribLink) p_contribLinks.get(i);
				functionId = itemContribLink.getFunctionId();
				if (functionId.equals("0")) {
					functionId = "null";
				}
				sqlString = "INSERT INTO ITEMCONLINK " + "(itemId, CONTRIBUTORID,creator_flag, orderBy, function_lov_id) " + "VALUES (" + m_db.plSqlSafeString(p_itemId) + ", "
						+ itemContribLink.getContribId() + ",'" + m_db.plSqlSafeString(p_creator_flag) + "'," + itemContribLink.getOrderBy() + ", " + m_db.plSqlSafeString(functionId) + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected contrib Link records.";
			return (false);
		}
	}

	public void setItemId(String s) {
		itemId = s;
	}

	public void setContribId(String s) {
		contribId = s;
	}

	public void setOrderBy(String s) {
		orderBy = s;
	}

	public void setFunctionId(String s) {
		functionId = s;
	}

	public void setCreatorFlag(String s) {
		creatorFlag = s;
	}

	public String getItemId() {
		return (itemId);
	}

	public String getContribId() {
		return (contribId);
	}

	public String getOrderBy() {
		return (orderBy);
	}

	public String getFunctionId() {
		return (functionId);
	}

	public String getError() {
		return (m_error_string);
	}
}

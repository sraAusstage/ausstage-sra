/***************************************************

Company: SRA
 Author: Aaron Keatley

   File: ItemOrganLink.java

Purpose: Provides Item to Item object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class ItemOrganLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String itemId;
	private String organId;
	private String creatorFlag;
	private String orderBy;
	private String functionLovId;
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
	public ItemOrganLink(ausstage.Database m_db2) {
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
		organId = "0";
		creatorFlag = "";
		orderBy = "0";
		functionLovId = "0";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the itemOrgLink information for the
	 * specified itemOrgLink id.
	 * 
	 * Parameters: p_item_id : id of the main item record
	 * 
	 * Returns: None
	 */
	public void load(String p_ITEMORGLINKID, String p_creator_flag) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM ITEMORGLINK " + " WHERE ITEMORGLINKID = " + p_ITEMORGLINKID + "   AND ((creator_flag is NULL and '" + p_creator_flag
					+ "'='N') or creator_flag='" + p_creator_flag + "')";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				itemId = l_rs.getString("itemid");
				organId = l_rs.getString("ORGANISATIONID");
				creatorFlag = p_creator_flag;
				orderBy = l_rs.getString("orderBy");
				functionLovId = l_rs.getString("function_lov_id");

				if (orderBy == null) orderBy = "0";
				if (functionLovId == null) functionLovId = "0";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ItemOrganLink: load().");
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
	public boolean add(String p_itemId, Vector p_organLinks, String p_creator_flag) {
		return update(p_itemId, p_organLinks, p_creator_flag);
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
	public boolean update(String p_itemId, Vector p_organLinks, String p_creator_flag) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			ItemOrganLink itemOrganLink = null;
			String sqlString;
			String functionId;
			boolean l_ret = false;

			sqlString = "DELETE FROM ITEMORGLINK where " + " itemId=" + p_itemId + " AND ((creator_flag is NULL and '" + p_creator_flag + "'='N') or creator_flag='"
					+ p_creator_flag + "')";
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; p_organLinks != null && i < p_organLinks.size(); i++) {
				itemOrganLink = (ItemOrganLink) p_organLinks.get(i);
				functionId = itemOrganLink.getFunctionId();
				if (functionId.equals("0")) {
					functionId = "null";
				}
				sqlString = "INSERT INTO ITEMORGLINK " + "(itemId, ORGANISATIONID,creator_flag, orderBy, function_lov_id) " + "VALUES (" + p_itemId + ", "
						+ itemOrganLink.getOrganisationId() + ",'" + p_creator_flag + "'," + itemOrganLink.getOrderBy() + ", " + functionId + ")";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected organistaion Link records.";
			return (false);
		}
	}

	public void setItemId(String s) {
		itemId = s;
	}

	public void setOrganisationId(String s) {
		organId = s;
	}

	public void setOrderBy(String s) {
		orderBy = s;
	}

	public void setFunctionId(String s) {
		functionLovId = s;
	}

	public void setCreatorFlag(String s) {
		creatorFlag = s;
	}

	public String getItemId() {
		return (itemId);
	}

	public String getOrganisationId() {
		return (organId);
	}

	public String getOrderBy() {
		return (orderBy);
	}

	public String getFunctionId() {
		return (functionLovId);
	}

	public String getCreatorFlag() {
		return (creatorFlag);
	}

	public String getError() {
		return (m_error_string);
	}
}

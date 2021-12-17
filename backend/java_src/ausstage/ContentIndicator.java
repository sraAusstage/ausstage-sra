/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Ausstage

   File: ContentIndicator.java

Purpose: Provides Content Indicator object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;

import ausstage.Database;
import sun.jdbc.rowset.*;

public class ContentIndicator {

	ausstage.Database m_db;
	admin.AppConstants AppConstants = new admin.AppConstants();

	// object state section
	int m_id = 0;
	int m_preferred_id = 0;
	String m_name = "";
	String m_description = "";
	String m_new_pref_name = "";
	private String m_error_string;

	/*
	 * Name: ContentIndicator ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public ContentIndicator(ausstage.Database m_db2) {
		m_db = m_db2;
	}

	/*
	 * Name: load()
	 * 
	 * Purpose: Sets the class to a contain the ContentIndicator information for
	 * the specified Content Indicator ID.
	 * 
	 * Parameters: p_id : id of the Secondary Genre record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM CONTENTINDICATOR WHERE CONTENTINDICATORID = " + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				m_id = p_id;
				m_name = l_rs.getString("CONTENTINDICATOR");
				m_description = l_rs.getString("CONTENTINDICATORDESCRIPTION");
			}

			if (m_name == null) {
				m_name = "";
			}
			if (m_description == null) {
				m_description = "";
			}

			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the add was successful, else false. Also fills out the
	 * id of the new record in the m_secondary_genre_id member.
	 */
	public boolean add() {
		String sqlString = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				if (!m_description.equals("") && m_description.length() >= 300) m_description = m_description.substring(0, 299);

				sqlString = "INSERT INTO CONTENTINDICATOR " + "(CONTENTINDICATOR, CONTENTINDICATORDESCRIPTION, SECGENREPREFERREDID) " + "VALUES (" + "'"
						+ m_db.plSqlSafeString(m_name) + "', " + "'" + m_db.plSqlSafeString(m_description) + "')";

				m_db.runSQL(sqlString, stmt);

				// Get the inserted index & set the id state of this object
				setId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "contentindicatorid_seq")));

				ret = true;
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentIndicator.add()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (false);
		}
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: None
	 */
	public boolean update() {
		boolean l_ret = true;
		String sqlString = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				if (!m_description.equals("") && m_description.length() >= 300) m_description = m_description.substring(0, 299);

				sqlString = "UPDATE ContentIndicator " + "SET CONTENTINDICATOR = '" + m_db.plSqlSafeString(m_name) + "', " + "CONTENTINDICATORSDESCRIPTION = '"
						+ m_db.plSqlSafeString(m_description) + "' " + "WHERE CONTENTINDICATORID = " + m_id;
				m_db.runSQL(sqlString, stmt);
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in update().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Removes this object from the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: None
	 */
	public boolean delete() {
		boolean ret = true;
		String sqlString = "";
		boolean delPreferred = false;
		String secgenprefid = "";
		try {
			CachedRowSet l_rs;
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "DELETE FROM ITEMCONTENTINDLINK WHERE CONTENTINDICATORID = " + m_id;
			m_db.runSQL(sqlString, stmt);

			// Delete the record from the SECGENRECLASS table
			sqlString = "DELETE FROM CONTENTINDICATOR WHERE CONTENTINDICATORID = " + m_id;
			m_db.runSQL(sqlString, stmt);

			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecondaryGenre.delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			ret = false;
		}
		return (ret);
	}

	/*
	 * Name: validateObjectForDB ()
	 * 
	 * Purpose: Determines if the object is valid for insert or update.
	 * 
	 * Parameters: True if the object is valid, else false
	 * 
	 * Returns: None
	 */
	private boolean validateObjectForDB() {
		boolean l_ret = true;
		if (m_name.equals("")) {
			m_error_string = "Unable to add the Subjects. Name is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	public CachedRowSet getNames() {
		CachedRowSet l_rs = null;
		String sqlString;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "select CONTNETINDICATORID, CONTNETINDICATOR from CONTNETINDICATOR order by CONTNETINDICATOR";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in CONTNETINDICATOR.getNames().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	/*
	 * public void loadLinkedProperties(int p_id){ CachedRowSet l_rs;
	 * 
	 * String sqlString = "select SECGENREPREFERREDID," + "PREFERREDTERM " +
	 * "from SECGENREPREFERRED " + "where SECGENREPREFERREDID=" + p_id;
	 * 
	 * try{ Statement stmt = m_db.m_conn.createStatement(); l_rs =
	 * m_db.runSQL(sqlString, stmt); if(l_rs.next()){ m_id =
	 * l_rs.getInt("SECGENREPREFERREDID"); m_name =
	 * l_rs.getString("PREFERREDTERM");
	 * 
	 * if(m_name == null || m_name.equals("")){m_name = "";} } stmt.close();
	 * }catch(Exception e){ System.out.println
	 * ("An Exception occured in SecondaryGenre.loadLinkedProperties().");
	 * System.out.println("MESSAGE: " + e.getMessage());
	 * System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	 * System.out.println("CLASS.TOSTRING: " + e.toString());
	 * System.out.println("sqlString: " + sqlString);
	 * System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<"); } }
	 */

	// /////////////////////////////
	// SET FUNCTIONS
	// ////////////////////////////

	public void setId(int p_id) {
		m_id = p_id;
	}

	public void setName(String p_name) {
		m_name = m_db.plSqlSafeString(p_name);
	}

	public void setDescription(String p_description) {
		m_description = m_db.plSqlSafeString(p_description);
	}

	public void setPrefId(int p_id) {
		m_preferred_id = p_id;
	}

	public void setNewPrefName(String p_name) {
		m_new_pref_name = m_db.plSqlSafeString(p_name);
	}

	// /////////////////////////////
	// GET FUNCTIONS
	// ////////////////////////////

	public int getId() {
		return (m_id);
	}

	public String getName() {
		return (m_name);
	}

	public String getDescription() {
		return (m_description);
	}

	public int getPrefId() {
		return (m_preferred_id);
	}

	public String getPreferredName() {
		return (m_new_pref_name);
	}

	public String getContentIndInfoForItemDisplay(int p_contentindicator_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT CONTENTINDICATOR display_info " + "  FROM CONTENTINDICATOR " + " WHERE CONTENTINDICATORID= " + p_contentindicator_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("display_info");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentIndicator.getContentIndInfoForItemDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public ResultSet getAssociatedEvents(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT DISTINCT events.eventid, events.event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state,  "
					+ "date_format(STR_TO_DATE(CONCAT_WS(' ', events.yyyyfirst_date,events.mmfirst_date,events.ddfirst_date), '%Y %m %d'), '%e %M %Y') as display_first_date, "
					+ "STR_TO_DATE(CONCAT_WS(' ', events.yyyyfirst_date,events.mmfirst_date,events.ddfirst_date), '%Y %m %d') as datesort,"
					+ "events.yyyyfirst_date,events.mmfirst_date,events.ddfirst_date " 
					+ "FROM events "
					+ "INNER JOIN venue ON (events.venueid = venue.venueid) " 
					+ "INNER JOIN states ON (venue.state = states.stateid) "
					+ "INNER JOIN country ON (venue.countryid = country.countryid)  "
					+ "INNER JOIN primcontentindicatorevlink ON (primcontentindicatorevlink.eventid = events.eventid)  "
					+ "WHERE primcontentindicatorevlink.primcontentindicatorid =" + p_id
					+ " order by datesort DESC";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentIndicator.getAssociatedEvents().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

	}

	public ResultSet getAssociatedItems(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT item.itemid,item.CITATION as title,contentindicator.contentindicator,item.catalogueid, lookup_codes.description  " + "FROM item "
					+ " LEFT JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id) "		
					+ "INNER JOIN itemcontentindlink ON (item.itemid = itemcontentindlink.itemid) "
					+ "INNER JOIN contentindicator ON (itemcontentindlink.contentindicatorid = contentindicator.contentindicatorid)  "
					+ "WHERE contentindicator.contentindicatorid=" + p_id + " Order by lookup_codes.description, item.citation ";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContentIndicator.getAssociatedItems().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

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
		m_id = 0;
		m_name = "";
		m_description = "";
	}
}

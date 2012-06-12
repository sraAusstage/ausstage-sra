/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: LookupCode.java

Purpose: Provides Lookup Code object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;

import ausstage.Database;
import sun.jdbc.rowset.*;

public class LookupCode {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_code_lov_id;
	private String m_code_type;
	private String m_short_code;
	private String m_description;
	private boolean m_system_code;
	private boolean m_default_flag;
	private int m_sequence_no;

	private String m_error_string;

	/*
	 * Name: LookupCode ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public LookupCode(ausstage.Database p_db) {
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
		m_code_lov_id = 0;
		m_code_type = "";
		m_short_code = "";
		m_description = "";
		m_system_code = false;
		m_default_flag = false;
		m_sequence_no = 0;
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Country information for the
	 * specified Country id.
	 * 
	 * Parameters: p_id : id of the Country record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		Statement stmt = null;

		try {
			stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM lookup_codes WHERE " + "code_lov_id=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_code_lov_id = l_rs.getInt("code_lov_id");
				m_code_type = l_rs.getString("code_type");
				m_short_code = l_rs.getString("short_code");
				m_description = l_rs.getString("description");

				if (m_description == null) m_description = "";
				if (l_rs.getString("system_code").equals("Y"))
					m_system_code = true;
				else
					m_system_code = false;

				if (l_rs.getString("default_flag").equals("Y"))
					m_default_flag = true;
				else
					m_default_flag = false;
				m_sequence_no = l_rs.getInt("sequence_no");

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in LookupCode.load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			if (stmt != null) try {
				stmt.close();
			} catch (SQLException e1) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in LookupCode.load().");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
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
	 * id of the new record in the m_country_id member.
	 */
	public boolean add() {
		Statement stmt = null;
		try {
			stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			String strSystemCode;
			if (m_system_code)
				strSystemCode = "Y";
			else
				strSystemCode = "N";

			String strDefaultFlag;
			if (m_default_flag)
				strDefaultFlag = "Y";
			else
				strDefaultFlag = "N";

			if (m_description.length() > 200) m_description = m_description.substring(0, 200);

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "INSERT INTO lookup_codes ( code_type, short_code, description, system_code, default_flag, sequence_no ) VALUES (" + "'"
						+ m_db.plSqlSafeString(m_code_type) + "','" + m_db.plSqlSafeString(m_short_code) + "'," + "'" + m_db.plSqlSafeString(m_description) + "','"
						+ m_db.plSqlSafeString(strSystemCode) + "', " + "'" + m_db.plSqlSafeString(strDefaultFlag) + "'," + m_sequence_no + " )";
				m_db.runSQL(sqlString, stmt);

				// Get the inserted index
				m_code_lov_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "LOOKUPCODEID_SEQ"));
				ret = true;
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			m_error_string = "Unable to add the lookup code. The data may be invalid.";
			if (stmt != null) try {
				stmt.close();
			} catch (SQLException e1) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in LookupCode.add().");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
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
		Statement stmt = null;
		try {
			stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			String strSystemCode;
			if (m_system_code)
				strSystemCode = "Y";
			else
				strSystemCode = "N";

			String strDefaultFlag;
			if (m_default_flag)
				strDefaultFlag = "Y";
			else
				strDefaultFlag = "N";

			if (m_description.length() > 200) m_description = m_description.substring(0, 200);

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "UPDATE lookup_codes set code_type= '" + m_db.plSqlSafeString(m_code_type) + "', " + "short_code = '" + m_db.plSqlSafeString(m_short_code) + "', "
						+ "description = '" + m_db.plSqlSafeString(m_description) + "', " + "system_code = '" + m_db.plSqlSafeString(strSystemCode) + "', " + "default_flag = '"
						+ m_db.plSqlSafeString(strDefaultFlag) + "', " + "sequence_no = " + m_sequence_no + " where code_lov_id=" + m_code_lov_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to update the lookup code. The data may be invalid, or may be in use.";
			if (stmt != null) try {
				stmt.close();
			} catch (SQLException e1) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in LookupCode.update().");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
			return (false);
		}
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
	public void delete() {
		Statement stmt = null;
		try {
			stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from lookup_codes WHERE code_lov_id=" + m_code_lov_id;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("Unable to delete the Lookup Code. The data may be in use.");
			try {
				if (stmt != null) {
					stmt.close();
				}
			} catch (Exception stmtException) {

			}
		}
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified Lookup code is in use in the
	 * database.
	 * 
	 * Parameters: p_id : id of the record
	 * 
	 * Returns: True if the country is in use, else false
	 *//*
		 * public boolean checkInUse(int p_id) { CachedRowSet l_rs; String
		 * sqlString; boolean ret = false;
		 * 
		 * try { Statement stmt = m_db.m_conn.createStatement ();
		 * 
		 * // Venue sqlString = "SELECT * FROM venue WHERE " + "countryid=" +
		 * p_id; l_rs = m_db.runSQL (sqlString, stmt);
		 * 
		 * if (l_rs.next()) ret = true; l_rs.close();
		 * 
		 * // Organisation sqlString = "SELECT * FROM organisation WHERE " +
		 * "countryid=" + p_id; l_rs = m_db.runSQL (sqlString, stmt);
		 * 
		 * if (l_rs.next()) ret = true; l_rs.close();
		 * 
		 * // Contributor sqlString = "SELECT * FROM contributor WHERE " +
		 * "countryid=" + p_id; l_rs = m_db.runSQL (sqlString, stmt);
		 * 
		 * if (l_rs.next()) ret = true; l_rs.close();
		 * 
		 * stmt.close(); return (ret); } catch (Exception e) {
		 * System.out.println(">>>>>>>> EXCEPTION <<<<<<<<"); System.out.println
		 * ("An Exception occured in checkInUse().");
		 * System.out.println("MESSAGE: " + e.getMessage());
		 * System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
		 * System.out.println("CLASS.TOSTRING: " + e.toString());
		 * System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<"); return (ret); } }
		 */
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
		if (m_short_code.equals("")) {
			if (m_code_lov_id == 0) {
				m_error_string = "Unable to add the lookup code. Short Code is required.";
			} else {
				m_error_string = "Unable to update the lookup code. Short Code is required.";
			}
			l_ret = false;
		} else if (m_description == null || m_description.equals("")) {
			m_error_string = "Unable to update the lookup code. Description is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: getLookupCodes ()
	 * 
	 * Purpose: Returns a record set with all of the specified lookup codes.
	 * 
	 * Parameters: p_code_type : Lookup code type name
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getLookupCodes(String p_code_type) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM lookup_codes where code_type = '" + p_code_type + "' order by SEQUENCE_NO, short_code";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getLookupCodes().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getLookupCodes ()
	 * 
	 * Purpose: Returns a record set with all of the specified lookup codes and
	 * that are in use.
	 * 
	 * Parameters: p_code_type : Lookup code type name
	 * 
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getLookupCodes(String p_code_type, String p_table_to_check, String p_link_column) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT distinct lookup_codes.* FROM lookup_codes, " + p_table_to_check + " " + "where lookup_codes.code_type = '" + p_code_type + "' "
					+ " AND lookup_codes.code_lov_id=" + p_table_to_check + "." + p_link_column + " " + "order by SEQUENCE_NO, short_code";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getLookupCodes().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	void handleException(Exception p_e, String p_description) {
		System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		System.out.println("MESSAGE: " + p_e.getMessage());
		System.out.println("LOCALIZED MESSAGE: " + p_e.getLocalizedMessage());
		System.out.println("CLASS.TOSTRING: " + p_e.toString());
		System.out.println(">>>>>>> STACK TRACE <<<<<<<");
		p_e.printStackTrace();
		System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	}

	void handleException(Exception p_e) {
		handleException(p_e, "");
	}

	public ResultSet getCitationByResourceSubType(Statement p_stmt, int itemTypeLovId) {

		String l_sql = "";
		ResultSet l_rs = null;

		try {
			l_sql = "SELECT DISTINCT item.citation, item.itemid FROM item " + "INNER JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id) "
					+ "WHERE lookup_codes.`code_type`='RESOURCE_SUB_TYPE' and lookup_codes.code_lov_id = " + itemTypeLovId + " order by item.citation";
			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occurred in item - getItemLanguage().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	// /////////////////////////////
	// SET FUNCTIONS
	// ////////////////////////////

	public void setCodeLovId(int p_code_lov_id) {
		m_code_lov_id = p_code_lov_id;
	}

	public void setCodeType(String p_code_type) {
		m_code_type = p_code_type;
	}

	public void setShortCode(String p_short_code) {
		m_short_code = p_short_code;
	}

	public void setDescription(String p_description) {
		m_description = p_description;
	}

	public void setSystemCode(String p_system_code) {
		if (p_system_code.equals("Y"))
			m_system_code = true;
		else
			m_system_code = false;
	}

	public void setDefaultFlag(String p_default_flag) {
		if (p_default_flag.equals("Y"))
			m_default_flag = true;
		else
			m_default_flag = false;
	}

	public void setSequenceNo(int p_sequence_no) {
		m_sequence_no = p_sequence_no;
	}

	public void setName(int p_sequence_no) {
		m_sequence_no = p_sequence_no;
	}

	// /////////////////////////////
	// GET FUNCTIONS
	// ////////////////////////////

	public int getCodeLovID() {
		return (m_code_lov_id);
	}

	public String getCodeType() {
		return (m_code_type);
	}

	public String getShortCode() {
		return (m_short_code);
	}

	public String getDescription() {
		return (m_description);
	}

	public boolean getSystemCode() {
		return (m_system_code);
	}

	public boolean getDefaultFlag() {
		return (m_default_flag);
	}

	public int getSequenceNo() {
		return (m_sequence_no);
	}

	public String getError() {
		return (m_error_string);
	}

}

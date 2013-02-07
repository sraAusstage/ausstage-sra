/***************************************************
Company: Ignition Design

   File: Tag

Purpose: Provides Tag object functions.
 ***************************************************/
package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Tag {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_tag_id;
	private String m_tag_name;
	private String m_error_string;

	/*
	 * Name: Tag () Purpose: Constructor. Parameters: p_db : The database object
	 * Returns: None
	 */

	public Tag(ausstage.Database p_db) {
		m_db = p_db;
		initialise();
	}

	/*
	 * Name: initialise () Purpose: Resets the object to point to no record.
	 * Parameters: None Returns: None
	 */

	public void initialise() {
		m_tag_id = 0;
		m_tag_name = "";
		m_error_string = "";
	}

	/*
	 * Name: add () Purpose: Adds this object to the database. Parameters:
	 * Returns: True if the add was successful, else false. Also fills out the
	 * id of the new record in the m_tag_id member.
	 */

	public boolean add(String tagName, String objectType, String objectId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			// if (validateObjectForDB ())
			// {
			sqlString = "INSERT INTO tag (tag, tag_type, id) VALUES (" + "'" + m_db.plSqlSafeString(tagName) + "'," + "'" + m_db.plSqlSafeString(objectType) + "'," + "'"
					+ m_db.plSqlSafeString(objectId) + "')";
			System.out.println(sqlString);
			m_db.runSQL(sqlString, stmt);

			// Get the inserted index
			m_tag_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "tagid_seq"));
			ret = true;
			// }
			stmt.close();
			return (ret);
		} catch (Exception e) {
			e.printStackTrace();
			m_error_string = "Unable to add the tag. The data may be invalid.";
			return (false);
		}
	}

	public CachedRowSet getTag(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM tags order by tag";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getCountries().");
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

	// /////////////////////////////
	// SET FUNCTIONS
	// ////////////////////////////

	public void setId(int p_id) {
		m_tag_id = p_id;
	}

	public void setName(String p_name) {
		m_tag_name = p_name;
	}

	public void setMdb(ausstage.Database p_db) {
		m_db = p_db;
	}

	// /////////////////////////////
	// GET FUNCTIONS
	// ////////////////////////////

	public int getId() {
		return (m_tag_id);
	}

	public String getName() {
		return (m_tag_name);
	}

	public String getError() {
		return (m_error_string);
	}

}

/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: WebLinks.java

Purpose: Provides WebLinks object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class WebLinks {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_web_links_id;
	private String m_web_links_name;
	private String m_web_links_description;
	private String m_collection_id;
	private String m_error_string;

	/*
	 * Name: WebLinks ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public WebLinks(ausstage.Database p_db) {
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
		m_web_links_id = 0;
		m_web_links_name = "";
		m_web_links_description = "";
		m_collection_id = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Web Links information for the
	 * specified web links id.
	 * 
	 * Parameters: p_id : id of the Web Links record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM www WHERE " + "www_id=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_web_links_id = l_rs.getInt("www_id");
				m_web_links_name = l_rs.getString("weblinks");
				m_web_links_description = l_rs.getString("web_description");
				m_collection_id = l_rs.getString("collection_information_id");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadResource().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
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
	 * id of the new record in the m_web_links_id member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "INSERT INTO www (collection_information_id, weblinks, web_description) VALUES (" + m_db.plSqlSafeString(m_collection_id) + ",  " + "'"
						+ m_db.plSqlSafeString(m_web_links_name) + "', " + "'" + m_db.plSqlSafeString(m_web_links_description) + "'  " + ")";
				m_db.runSQL(sqlString, stmt);

				// Get the inserted index
				m_web_links_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "www_id_seq"));
				ret = true;
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			m_error_string = "Unable to add the web link. The data may be invalid.";
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
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "UPDATE www set " + "weblinks='" + m_db.plSqlSafeString(m_web_links_name) + "', " + "web_description='" + m_db.plSqlSafeString(m_web_links_description)
						+ "' " + "where www_id=" + m_web_links_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to update the web link. The data may be invalid.";
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
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from www WHERE www_id=" + m_web_links_id;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified Web Link is in use in the
	 * database.
	 * 
	 * Parameters: p_id : id of the record
	 * 
	 * Returns: True if the web links record is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = false;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			// Can always delete a web link
			stmt.close();
			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in checkInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (ret);
		}
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
		if (m_web_links_name.equals("")) {
			m_error_string = "Unable to add the web link. The web link name is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: getAllWebLinks ()
	 * 
	 * Purpose: Returns a record set with all of the web link information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getAllWebLinks(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM www order by weblinks";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getWebLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: deleteWebLinksForCollection (p_id)
	 * 
	 * Purpose: Deletes all WebLinks records for the Collection p_id given.
	 * 
	 * Parameters: p_id : Unique ID of the Collection record.
	 */
	public void deleteWebLinksForCollection(int p_id) {
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "DELETE FROM www WHERE collection_information_id = " + p_id;
			m_db.runSQL(sqlString, stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteWebLinksForCollection().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void setWebLinksName(String s) {
		m_web_links_name = s;
	}

	public void setWebLinksDescription(String s) {
		m_web_links_description = s;
	}

	public void setCollectionId(String s) {
		m_collection_id = s;
	}

	public String getWebLinksName() {
		return m_web_links_name;
	}

	public String getWebLinksDescription() {
		return m_web_links_description;
	}

	public String getCollectionId() {
		return m_collection_id;
	}

	public String getError() {
		return m_error_string;
	}

	public ausstage.Database getDatabase() {
		return m_db;
	}
}

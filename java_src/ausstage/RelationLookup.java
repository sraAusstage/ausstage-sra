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

public class RelationLookup {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_relation_lookup_id;
	private String m_code_type;
	private String m_parent_relation;
	private String m_child_relation;
	
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
	public RelationLookup(ausstage.Database p_db) {
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
		m_relation_lookup_id = 0;
		m_code_type = "";
		m_parent_relation = "";
		m_child_relation = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Relation information for the
	 * specified relation id
	 * 
	 * Parameters: p_id : id of the relation record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		Statement stmt = null;

		try {
			stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM relation_lookup WHERE " 
						+ "relationlookupid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_relation_lookup_id = l_rs.getInt("relationlookupid");
				m_code_type = l_rs.getString("code_type");
				m_parent_relation = l_rs.getString("parent_relation");
				m_child_relation = l_rs.getString("child_relation");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in RelationLookup.load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			if (stmt != null) try {
				stmt.close();
			} catch (SQLException e1) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("An Exception occured in RelationLookup.load().");
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

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "INSERT INTO relation_lookup ( code_type, parent_relation, child_relation ) VALUES (" 
						+ "'" + m_db.plSqlSafeString(m_code_type) + "','" + m_db.plSqlSafeString(m_parent_relation) + "'," 
						+ "'" + m_db.plSqlSafeString(m_child_relation) + "')";
				m_db.runSQL(sqlString, stmt);

				// Get the inserted index
				//m_relation_lookup_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "LOOKUPCODEID_SEQ"));
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
			
			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "UPDATE relation_lookup set code_type= '" + m_db.plSqlSafeString(m_code_type) 
							+ "', parent_relation = '" + m_db.plSqlSafeString(m_parent_relation) 
							+ "', child_relation = '" + m_db.plSqlSafeString(m_child_relation) 
							+ "' where relationlookupid=" + m_relation_lookup_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to update the lookup relation code. The data may be invalid, or may be in use.";
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

			sqlString = "DELETE from relation_lookup WHERE relationlookupid=" + m_relation_lookup_id;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("Unable to delete the Relation Lookup Code. The data may be in use.");
			try {
				if (stmt != null) {
					stmt.close();
				}
			} catch (Exception stmtException) {

			}
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
		if (m_parent_relation.equals("") && m_child_relation.equals("")) {
			if (m_relation_lookup_id == 0) {
				m_error_string = "Unable to add the relation lookup code. parent relation and child relation are required.";
			} else {
				m_error_string = "Unable to update the relation lookup code. parent relation and child relation are required.";
			}
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: getRelationLookupCodes ()
	 * 
	 * Purpose: Returns a record set with all of the specified relation lookup codes.
	 * 
	 * Parameters: p_code_type : Lookup code type name
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getRelationLookups(String p_code_type) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM relation_lookup where "
						+ " code_type = '" + p_code_type + "'";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getRelationLookups().");
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
	public CachedRowSet getRelationLookups(String p_code_type, String p_table_to_check, String p_link_column) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT distinct relation_lookup.* FROM relation_lookup, " + p_table_to_check + " " 
						+ "where relation_lookup.code_type = '" + p_code_type + "' "
						+ " AND relation_lookup.relationlookupid=" + p_table_to_check + "." + p_link_column + " ";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getRelationLookups().");
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

	public void setRelationLookupId(int p_relation_lookup_id) {
		m_relation_lookup_id = p_relation_lookup_id;
	}

	public void setCodeType(String p_code_type) {
		m_code_type = p_code_type;
	}

	public void setParentRelation(String p_parent_relation) {
		m_parent_relation = p_parent_relation;
	}

	public void setChildRelation(String p_child_relation) {
		m_child_relation = p_child_relation;
	}

	// /////////////////////////////
	// GET FUNCTIONS
	// ////////////////////////////

	public int getRelationLookupId() {
		return (m_relation_lookup_id);
	}

	public String getCodeType() {
		return (m_code_type);
	}
	
	public String getParentRelation() {
		return (m_parent_relation);
	}

	public String getChildRelation() {
		return (m_child_relation);
	}

	public String getError() {
		return (m_error_string);
	}

}

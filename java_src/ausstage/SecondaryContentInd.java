/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Centricminds

   File: SecondaryContentInd.java

Purpose: Provides SecondaryContentInd object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class SecondaryContentInd extends AusstageInputOutput {

	private String m_error_string;

	/*
	 * Name: SecondaryContentInd ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public SecondaryContentInd(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*
	 * Name: load()
	 * 
	 * Purpose: Sets the class to a contain the Secondary Content Indicator
	 * information for the specified Secondary Content Indicator id.
	 * 
	 * Parameters: p_id : id of the Secondary Content Indicator record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM SECCONTENTINDICATOR WHERE SECCONTENTINDICATORID = " + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				m_id = p_id;
				m_name = l_rs.getString("SECCONTENTINDICATOR");
				m_description = l_rs.getString("SECCONTENTINDICATORDESCRIPTION");
				m_preferred_id = l_rs.getInt("SECCONTENTINDICATORPREFERREDID");
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
			System.out.println("An Exception occured in SecondaryContentInd.load().");
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
	 * id of the new record in the m_id member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				if (!m_description.equals("") && m_description.length() >= 300) m_description = m_description.substring(0, 299);

				if (!isDuplicate()) {
					sqlString = "INSERT INTO SECCONTENTINDICATOR " + "(SECCONTENTINDICATOR, SECCONTENTINDICATORDESCRIPTION, SECCONTENTINDICATORPREFERREDID) " + "VALUES (" + "'"
							+ m_db.plSqlSafeString(m_name) + "', " + "'" + m_db.plSqlSafeString(m_description) + "'," + " " + m_preferred_id + ")";

					m_db.runSQL(sqlString, stmt);

					// Get the inserted index & set the id state of this object
					setId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "SECCONTENTINDICATORID_SEQ")));

					// if the user created a new preffered term then call update
					if (m_preferred_id == 0) update();

					ret = true;
				}
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecondaryContentInd.add()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (false);
		}
	}

	private boolean isDuplicate() {
		boolean ret = false;
		try {
			CachedRowSet l_rs;
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			sqlString = "select SECCONTENTINDICATOR from SECCONTENTINDICATOR where " + "lower(SECCONTENTINDICATOR)='" + m_db.plSqlSafeString(m_name).toLowerCase() + "'";
			if (m_id != 0) sqlString += " and not SECCONTENTINDICATORID=" + m_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) ret = true;
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecondaryContentInd.isDuplicate()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
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
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				if (!isDuplicate()) {
					if (!m_description.equals("") && m_description.length() >= 300) m_description = m_description.substring(0, 299);

					if (m_preferred_id != 0) {
						sqlString = "UPDATE SECCONTENTINDICATOR " + "SET SECCONTENTINDICATOR = '" + m_db.plSqlSafeString(m_name) + "', " + "SECCONTENTINDICATORDESCRIPTION = '"
								+ m_db.plSqlSafeString(m_description) + "', " + "SECCONTENTINDICATORPREFERREDID = " + m_preferred_id + " " + "WHERE SECCONTENTINDICATORID = "
								+ m_id;

					} else {
						sqlString = "UPDATE SECCONTENTINDICATOR " + "SET SECCONTENTINDICATOR = '" + m_db.plSqlSafeString(m_name) + "', " + "SECCONTENTINDICATORDESCRIPTION = '"
								+ m_db.plSqlSafeString(m_description) + "' " + "WHERE SECCONTENTINDICATORID = " + m_id;
						m_db.runSQL(sqlString, stmt);

						sqlString = "Insert into SECCONTENTINDICATORPREFERRED " + "(PREFERREDTERM) values " + "('" + m_db.plSqlSafeString(m_new_pref_name) + "')";
						m_db.runSQL(sqlString, stmt);

						setPrefId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "SECCONTENTINDICATORPREFID_SEQ")));

						sqlString = "UPDATE SECCONTENTINDICATOR " + "SET SECCONTENTINDICATORPREFERREDID = " + m_preferred_id + " " + "WHERE SECCONTENTINDICATORID = " + m_id;

					}
					m_db.runSQL(sqlString, stmt);
				} else {
					l_ret = false;
				}
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecondaryContentInd.update().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
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
		try {
			CachedRowSet l_rs;
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;

			if (!isInUse()) {
				sqlString = "SELECT SECCONTENTINDICATORPREFERREDID " + "FROM SECCONTENTINDICATOR WHERE SECCONTENTINDICATORID = " + m_id;
				l_rs = m_db.runSQL(sqlString, stmt);

				if (l_rs.next()) {
					String seccontindprefid = l_rs.getString("SECCONTENTINDICATORPREFERREDID");

					// find out if this is used by other SECCONTENTINDICATOR
					sqlString = "SELECT count (*) as counter " + "FROM SECCONTENTINDICATOR WHERE " + "SECCONTENTINDICATORPREFERREDID = " + seccontindprefid;
					l_rs = m_db.runSQL(sqlString, stmt);

					if (l_rs.next() && l_rs.getInt("counter") == 1) {
						// del the preferred term
						sqlString = "DELETE FROM SECCONTENTINDICATORPREFERRED " + "WHERE SECCONTENTINDICATORPREFERREDID = " + seccontindprefid;

						m_db.runSQL(sqlString, stmt);
					}
				}
				sqlString = "DELETE FROM SECCONTENTINDICATOR WHERE SECCONTENTINDICATORID = " + m_id;
				m_db.runSQL(sqlString, stmt);
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in SecondaryContentInd.delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			ret = false;
		}
		return (ret);
	}

	public boolean isInUse() {

		CachedRowSet l_rs;
		boolean ret = false;
		String sqlString = "";
		String l_seccontindpreferredid = "";
		int counter = 0;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			// lets check if a preferred term exist in this secondary content
			// indicator
			sqlString = "select SECCONTENTINDICATORPREFERRED.SECCONTENTINDICATORPREFERREDID from " + "SECCONTENTINDICATORPREFERRED, SECCONTENTINDICATOR "
					+ "where SECCONTENTINDICATOR.SECCONTENTINDICATORID = " + m_id + " " + "and SECCONTENTINDICATOR.SECCONTENTINDICATORPREFERREDID="
					+ "SECCONTENTINDICATORPREFERRED.SECCONTENTINDICATORPREFERREDID";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				l_seccontindpreferredid = l_rs.getString("SECCONTENTINDICATORPREFERREDID");

				sqlString = "select count (*) as counter from SECCONTENTINDICATOR " + "where SECCONTENTINDICATORPREFERREDID=" + l_seccontindpreferredid;
				l_rs = m_db.runSQL(sqlString, stmt);
				l_rs.next();
				counter = l_rs.getInt("counter");

				if (counter <= 1) {
					// this is the last content indicator that is related to the
					// preferred term
					// now check if preferred term is in use
					sqlString = "select count (*) as counter from SECCONTENTINDICATOREVLINK where " + "SECCONTENTINDICATORPREFERREDID =" + l_seccontindpreferredid;
					l_rs = m_db.runSQL(sqlString, stmt);
					l_rs.next();
					counter = l_rs.getInt("counter");

					if ((counter <= 0) != true) ret = true; // can't del sec
															// content id & pref
															// term
				}
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in SecondaryContentInd.isInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
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
			m_error_string = "Unable to add the Subjects. Subjects name is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: getSecondaryContentInds ()
	 * 
	 * Purpose: Returns a record set with all of the Secondary Content Indicator
	 * information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getSecondaryContentInds(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			sqlString = "SELECT * FROM SecContentIndicator";
			l_rs = m_db.runSQL(sqlString, p_stmt);
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getSecondaryContentInds().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	// /////////////////////////////
	// SET FUNCTIONS
	// ////////////////////////////

	public void setId(int p_id) {
		m_id = p_id;
	}

	public void setName(String p_name) {
		m_name = p_name;
	}

	public void setDescription(String p_description) {
		m_description = p_description;
	}

	public void setPrefId(int p_id) {
		m_preferred_id = p_id;
	}

	public void setNewPrefName(String p_name) {
		m_new_pref_name = p_name;
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
		m_preferred_id = 0;
	}
}

/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Centricminds

   File: ContributorFunction.java

Purpose: Provides Contributor Functions object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;

import ausstage.Database;
import sun.jdbc.rowset.*;
import admin.Common;

public class ContributorFunction extends AusstageInputOutput {
	private Database m_db;

	/*
	 * Name: ContributorFunction ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */

	public ContributorFunction(ausstage.Database m_db) {
		initialise();
		this.m_db = m_db;
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a new event id and populates the object with
	 * the new contributor function information.
	 * 
	 * Parameters: p_id : id of the event record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM contfunct WHERE contfunctionid = " + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {

				m_id = p_id;
				m_name = l_rs.getString("contfunction");
				m_description = l_rs.getString("contfunctiondescription");
				m_preferred_id = l_rs.getInt("contributorfunctpreferredid");

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorFunction.load()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: initialise ()
	 * 
	 * Purpose: sets the object to point to no record.
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

	/*
	 * Name: reinitialise ()
	 * 
	 * Purpose: Resets the object members.
	 * 
	 * Parameters: p_cont_funct = contributor function p_desc = contributor
	 * function description p_contribfunct_preff_id = contributor function
	 * preferred term id
	 * 
	 * Returns: None
	 */
	public void reinitialise(String p_cont_funct, String p_desc, int p_contribfunct_pref_id) {
		m_name = p_cont_funct;
		m_description = p_desc;
		m_preferred_id = p_contribfunct_pref_id;
	}

	public boolean add() {
		boolean ret = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;

			// As the notes is a text area, need to limit characters
			if (m_description.length() >= 300) m_description = m_description.substring(0, 299);

			// if the user created a new preffered term then call update
			if (m_preferred_id == 0) update();

			sqlString = "insert into contfunct " + "(contfunction, contfunctiondescription, contributorfunctpreferredid) " + "VALUES (" + "'" + m_db.plSqlSafeString(m_name)
					+ "', " + "'" + m_db.plSqlSafeString(m_description) + "'," + " " + m_preferred_id + ")";

			m_db.runSQL(sqlString, stmt);

			// Get the inserted index & set the id state of this object
			setId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "CONTFUNCTIONID_SEQ")));

			ret = true;
			stmt.close();
		} catch (Exception e) {
			ret = false;
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorFunction.add()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
	}

	/*
	 * Name: update()
	 * 
	 * Purpose: edits the current contributor function.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	public boolean update() {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = true;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			// As the notes is a text area, need to limit characters
			if (m_description.length() >= 300) m_description = m_description.substring(0, 299);

			if (m_preferred_id != 0) {
				sqlString = "update contfunct " + "set contfunction='" + m_db.plSqlSafeString(m_name) + "', " + "contfunctiondescription= '" + m_db.plSqlSafeString(m_description)
						+ "', " + "contributorfunctpreferredid= " + m_preferred_id + " " + "where contfunctionid= " + m_id;

			} else {
				sqlString = "update contfunct " + "set contfunction= '" + m_db.plSqlSafeString(m_name) + "', " + "contfunctiondescription= '" + m_db.plSqlSafeString(m_description)
						+ "' " + "where contfunctionid= " + m_id;
				m_db.runSQL(sqlString, stmt);

				sqlString = "Insert into contributorfunctpreferred " + "(preferredterm) values " + "('" + m_db.plSqlSafeString(m_new_pref_name) + "')";
				m_db.runSQL(sqlString, stmt);

				setPrefId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "contribfunctprefid_seq")));

				sqlString = "update contfunct " + "set contributorfunctpreferredid= " + m_preferred_id + " " + "where contfunctionid= " + m_id;

			}
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			ret = false;
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorFunction.update().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
	}

	/*
	 * Name: delete()
	 * 
	 * Purpose: deletes contributor function.
	 * 
	 * Parameters: None
	 * 
	 * Returns: true if successful else false
	 */
	public boolean delete() {
		CachedRowSet l_rs;
		boolean ret = true;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			if (!isInUse()) {
				sqlString = "DELETE FROM CONTFUNCT WHERE CONTFUNCTIONID = " + m_id;
				m_db.runSQL(sqlString, stmt);

				sqlString = "SELECT CONTRIBUTORFUNCTPREFERREDID " + "FROM CONTFUNCT WHERE contfunctionid = " + m_id;
				l_rs = m_db.runSQL(sqlString, stmt);

				if (l_rs.next()) {
					String contribfunctprefid = l_rs.getString("CONTRIBUTORFUNCTPREFERREDID");

					sqlString = "SELECT count(*) as counter " + "FROM CONTFUNCT " + "WHERE CONTRIBUTORFUNCTPREFERREDID = " + contribfunctprefid;
					l_rs = m_db.runSQL(sqlString, stmt);

					if (l_rs.next() && l_rs.getInt("counter") == 1) {
						// del the preferred term
						sqlString = "DELETE FROM CONTRIBUTORFUNCTPREFERRED " + "WHERE CONTRIBUTORFUNCTPREFERREDID = " + contribfunctprefid;
						m_db.runSQL(sqlString, stmt);
					}
				}
			}
			stmt.close();
		} catch (Exception e) {
			ret = false;
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorFunction.delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
	}

	/*
	 * Name: isExistInOtherTable()
	 * 
	 * Purpose: test to see if this object exist in another table.
	 * 
	 * Parameters: None
	 * 
	 * Returns: true or false
	 */

	public boolean isInUse() {

		CachedRowSet l_rs;
		boolean ret = false;
		String sqlString = "";
		String l_contributorfunctpreferredid = "";
		int counter = 0;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			// lets check if a preferred term exist this contributor function
			sqlString = "select CONTRIBUTORFUNCTPREFERRED.CONTRIBUTORFUNCTPREFERREDID from " + "CONTRIBUTORFUNCTPREFERRED, CONTFUNCT " + "where CONTFUNCT.CONTFUNCTIONID = " + m_id
					+ " " + "and CONTFUNCT.CONTRIBUTORFUNCTPREFERREDID=" + "CONTRIBUTORFUNCTPREFERRED.CONTRIBUTORFUNCTPREFERREDID";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				l_contributorfunctpreferredid = l_rs.getString("CONTRIBUTORFUNCTPREFERREDID");

				sqlString = "select count(*) as counter from CONTFUNCT " + "where CONTRIBUTORFUNCTPREFERREDID=" + l_contributorfunctpreferredid;
				l_rs = m_db.runSQL(sqlString, stmt);
				l_rs.next();
				counter = l_rs.getInt("counter");

				if (counter <= 1) {
					// this is the last contfunct that is related to the
					// preferred term
					// now check if preferred term is in use
					sqlString = "select count(*) as counter from CONTFUNCTLINK where " + "CONTRIBUTORFUNCTPREFERREDID=" + l_contributorfunctpreferredid;
					l_rs = m_db.runSQL(sqlString, stmt);
					l_rs.next();
					counter = l_rs.getInt("counter");

					if ((counter <= 0) != true) ret = true; // can't
															// contribfunct &
															// pref term
				}
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in ContributorFunction.isInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret);
	}

	public CachedRowSet getNames() {
		CachedRowSet l_rs = null;
		String sqlString;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "SELECT cf.ContributorFunctPreferredId, ContFunction, PreferredTerm, contfunctionid " + "FROM ContFunct cf, ContributorFunctPreferred cfp "
					+ "WHERE cf.ContributorFunctPreferredId = cfp.ContributorFunctPreferredId " + "ORDER BY ContFunction";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in ContributorFunction.getNames().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	public ResultSet getAssociatedContributors(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT contributorfunctpreferred.preferredterm,concat_ws(' ', contributor.first_name,contributor.last_name) as name,contributorfunctpreferred.contributorfunctpreferredid,contributor.contributorid  "
					+ "FROM contfunctlink "
					+ "INNER JOIN contributorfunctpreferred ON (contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid) "
					+ "INNER JOIN contributor ON (contfunctlink.contributorid = contributor.contributorid)  "
					+ "WHERE contributorfunctpreferred.contributorfunctpreferredid="
					+ p_id + " Order by name ";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorFunction.getAssociatedContributors().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

	}

	/**
	 * object SETTING section
	 */

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

	/**
	 * object OUTPUT section
	 */

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

}

/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: ContFunctPref.java

Purpose: Provides Contributor Function Preferred object functions.

 ***************************************************/

package ausstage;

import java.sql.ResultSet;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.CachedRowSet;
import admin.Common;

public class ContFunctPref {
	String preferredId;
	String preferredTerm;
	Database m_db;

	/*
	 * Name: ContFunctPref ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */

	public ContFunctPref(ausstage.Database p_db) {
		initialise();
		m_db = p_db;
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Populates the object with the new contributor function
	 * information.
	 * 
	 * Parameters: p_id : id of the Contributor Function Preferred record.
	 * 
	 * Returns: None
	 */

	public void load(String p_id) {
		CachedRowSet l_rs;
		String sqlString;
		initialise();
		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM ContributorFunctPreferred WHERE ContributorFunctPreferredId = " + m_db.plSqlSafeString(p_id);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				preferredId = l_rs.getString("ContributorFunctPreferredId");
				preferredTerm = l_rs.getString("PreferredTerm");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContFunctPref.load()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void loadPreferredWithNonPreferredId(String p_id) {
		CachedRowSet l_rs;
		String sqlString;
		initialise();
		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT ContributorFunctPreferred.ContributorFunctPreferredId,  ContributorFunctPreferred.PreferredTerm " + "FROM ContributorFunctPreferred, contfunct "
					+ "WHERE ContributorFunctPreferred.ContributorFunctPreferredId=contfunct.ContributorFunctPreferredId " + "AND contfunct.CONTFUNCTIONID=" + m_db.plSqlSafeString(p_id);
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				preferredId = l_rs.getString("ContributorFunctPreferredId");
				preferredTerm = l_rs.getString("PreferredTerm");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContFunctPref.loadPreferredWithNonPreferredId()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public ResultSet getAssociatedContributors(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT contributorfunctpreferred.preferredterm, " +
					"concat_ws(' ', contributor.first_name,contributor.last_name) as name,contributorfunctpreferred.contributorfunctpreferredid,contributor.contributorid , " +
					"event_dates.min_first_date, event_dates.max_last_date, event_dates.max_first_date " +
					"FROM contfunctlink  " +
					"INNER JOIN contributorfunctpreferred ON (contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid)  " +
					"INNER JOIN contributor ON (contfunctlink.contributorid = contributor.contributorid) " +
					"INNER JOIN (SELECT conel.contributorid, conel.`function`, " +
					"			min(e.yyyyfirst_date) as min_first_date, max(e.yyyylast_date) as max_last_date, max(e.yyyyfirst_date) as max_first_date " +
					"			FROM events e " +
					"			INNER JOIN conevlink conel on (e.eventid = conel.eventid) " +
					"			WHERE conel.contributorid is not null " +
					"			GROUP BY conel.contributorid, conel.`function`) event_dates  " +
					"on (contfunctlink.contributorid = event_dates.contributorid AND contfunctlink.contributorfunctpreferredid = event_dates.`function`) " +
					"WHERE contributorfunctpreferred.contributorfunctpreferredid=  " + p_id + " " +
					"Order by contributor.last_name, contributor.first_name;";

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
		preferredId = "";
		preferredTerm = "";
	}

	public void setPreferredId(String s) {
		preferredId = s;
	}

	public void setPreferredTerm(String s) {
		preferredTerm = s;
	}

	public String getPreferredId() {
		if (preferredId == null) preferredId = "";
		return preferredId;
	}

	public String getPreferredTerm() {
		if (preferredTerm == null) preferredTerm = "";
		return preferredTerm;
	}
}

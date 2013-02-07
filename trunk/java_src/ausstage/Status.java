/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: Status.java

Purpose: Provides Status object functions.

 ***************************************************/

package ausstage;

import java.util.Date;
import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.CachedRowSet;

public class Status {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	/*
	 * Name: Status ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Status(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*
	 * Name: getStatus ()
	 * 
	 * Purpose: Returns the status description.
	 * 
	 * Parameters: p_id : id of the status record
	 * 
	 * Returns: The status description.
	 */
	public String getStatus(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM STATUSMENU WHERE " + "statusid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) l_ret = l_rs.getString("status");
			l_rs.close();
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getStatus().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return ("");
		}
	}

	/*
	 * Name: getStatuses ()
	 * 
	 * Purpose: Returns a record set with all of the status information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getStatuses(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			sqlString = "SELECT * FROM STATUSMENU";
			l_rs = m_db.runSQL(sqlString, p_stmt);
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getStatuses().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}
}

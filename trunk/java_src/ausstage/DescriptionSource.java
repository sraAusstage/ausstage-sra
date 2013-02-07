/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: DescriptionSource.java

Purpose: Provides DescriptionSource object functions.

 ***************************************************/

package ausstage;

import java.util.Date;
import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.CachedRowSet;

public class DescriptionSource {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	/*
	 * Name: DescriptionSource ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public DescriptionSource(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*
	 * Name: getDescriptionSource ()
	 * 
	 * Purpose: Returns the description source description.
	 * 
	 * Parameters: p_id : id of the description source record
	 * 
	 * Returns: The description source description.
	 */
	public String getDescriptionSource(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM DESCRIPTIONSRC WHERE " + "descriptionsourceid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) l_ret = l_rs.getString("descriptionsource");
			l_rs.close();
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getDescriptionSource().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return ("");
		}
	}

	/*
	 * Name: getDescriptionSources ()
	 * 
	 * Purpose: Returns a record set with all of the description source
	 * information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getDescriptionSources(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			sqlString = "SELECT * FROM DESCRIPTIONSRC";
			l_rs = m_db.runSQL(sqlString, p_stmt);
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getDescriptionSources().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}
}

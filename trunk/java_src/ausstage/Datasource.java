/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Ausstage

   File: Datasource.java

Purpose: Provides Datasource object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Datasource {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_datasource_id = 0;
	private int m_event_id = 0;
	private String m_datasource_name = "";
	private String m_datasource_desc = "";
	private String m_error_string = "";
	private String m_collection = "";
	private String m_datasoureevlinkid = "";

	/*
	 * Name: Datasource ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Datasource(ausstage.Database m_db2) {
		m_db = m_db2;
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
		m_datasource_id = 0;
		m_datasource_name = "";
		m_datasource_desc = "";
		m_error_string = "";
		m_collection = "";
		m_datasoureevlinkid = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Datasource information for the
	 * specified datasource id.
	 * 
	 * Parameters: p_id : id of the datasource record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM DATASOURCE WHERE " + "DATASOURCEID=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_datasource_id = l_rs.getInt("DATASOURCEID");
				m_datasource_name = l_rs.getString("DATASOURCE");
				m_datasource_desc = l_rs.getString("DATADESCRIPTION");

				if (m_datasource_desc == null) m_datasource_desc = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			handleException(e);
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
	 * id of the new record in the m_datasource_id member.
	 */
	public boolean add() {
		String l_sql;

		try {
			Statement l_stmt = m_db.m_conn.createStatement();

			// As the description is a text area, need to limit characters
			if (m_datasource_desc.length() >= 300) m_datasource_desc = m_datasource_desc.substring(0, 299);

			l_sql = "INSERT INTO datasource (datasource, datadescription) " + "VALUES ('" + m_db.plSqlSafeString(m_datasource_name) + "', " + "'"
					+ m_db.plSqlSafeString(m_datasource_desc) + "')";
			m_db.runSQL(l_sql, l_stmt);

			m_datasource_id = Integer.parseInt(m_db.getInsertedIndexValue(l_stmt, "datasourceid_seq"));

			l_stmt.close();
			return (true);
		} catch (Exception e) {
			m_error_string = "Unable to add the data source. The data may be invalid.";
			handleException(e);
		}
		return (false);
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
		String l_sql;

		try {
			Statement l_stmt = m_db.m_conn.createStatement();

			// As the description is a text area, need to limit characters
			if (m_datasource_desc.length() >= 300) m_datasource_desc = m_datasource_desc.substring(0, 299);

			l_sql = "UPDATE datasource SET " + "datasource = '" + m_db.plSqlSafeString(m_datasource_name) + "', " + "datadescription = '" + m_db.plSqlSafeString(m_datasource_desc)
					+ "' " + "WHERE datasourceid = " + m_datasource_id;
			m_db.runSQL(l_sql, l_stmt);

			l_stmt.close();
			return (true);
		} catch (Exception e) {
			handleException(e);
		}
		return (false);
	}

	public boolean delLink(String p_eventid) {
		String l_sql;
		boolean ret = true;
		try {
			Statement l_stmt = m_db.m_conn.createStatement();
			l_sql = "DELETE from DATASOURCEEVLINK WHERE EVENTID = " + p_eventid;
			m_db.runSQL(l_sql, l_stmt);
			l_stmt.close();
		} catch (Exception e) {
			m_error_string = "Unable to delete the link between data source and event.";
			handleException(e);
			ret = false;
		}
		return (ret);
	}

	public boolean addLink(String p_eventid) {
		String l_sql;

		try {
			Statement l_stmt = m_db.m_conn.createStatement();

			l_sql = "INSERT INTO DATASOURCEEVLINK " + "(DATASOURCEEVLINKID, DATASOURCEDESCRIPTION, COLLECTION, EVENTID, DATASOURCEID) " 
			//+ "values ('" + m_db.plSqlSafeString(m_datasource_desc) + "','"
			+ "(select (max(datasourceevlinkid)+1),'" + m_db.plSqlSafeString(m_datasource_desc) + "','"
				+ m_db.plSqlSafeString(m_collection) + "'," + p_eventid + "," + m_datasource_id + ")";

			m_db.runSQL(l_sql, l_stmt);

			l_stmt.close();
			return (true);
		} catch (Exception e) {
			m_error_string = "Unable to update data source link. The data may be invalid.";
			handleException(e);
		}
		return (false);
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Deletes the record. This instance will retain all of the
	 * datasource information except the id.
	 * 
	 * Parameters: none.
	 * 
	 * Returns: None
	 */
	public void delete() {
		String l_sql;

		try {
			Statement l_stmt = m_db.m_conn.createStatement();

			l_sql = "DELETE FROM datasource WHERE datasourceid = " + m_datasource_id;
			m_db.runSQL(l_sql, l_stmt);

			m_datasource_id = 0;

			l_stmt.close();
		} catch (Exception e) {
			handleException(e);
		}
	}

	/*
	 * Name: getDataSources ()
	 * 
	 * Purpose: Returns a record set with all of the datasource information in
	 * it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getDataSources(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			sqlString = "SELECT * FROM datasource order by datasource";
			l_rs = m_db.runSQL(sqlString, p_stmt);
			return (l_rs);
		} catch (Exception e) {
			handleException(e);
			return (null);
		}
	}

	/*
	 * Name: getDataSources ()
	 * 
	 * Purpose: Returns a record set (depending on the p_sqlString sql
	 * parameter) with all of the datasource information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getDataSources(Statement p_stmt, String p_sqlString) {
		CachedRowSet l_rs;
		String sqlString = p_sqlString;
		String l_ret;

		try {
			l_rs = m_db.runSQL(sqlString, p_stmt);
			return (l_rs);
		} catch (Exception e) {
			handleException(e);
			return (null);
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
		if (m_datasource_name.equals("")) {
			m_error_string = "Data source name is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified Datasource is in use in the
	 * database.
	 * 
	 * Parameters: p_id : id of the datasource record
	 * 
	 * Returns: True if the datasource is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = false;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM datasourceevlink WHERE " + "datasourceid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) ret = true;
			l_rs.close();
			stmt.close();
			return (ret);
		} catch (Exception e) {
			handleException(e);
			return (ret);
		}
	}

	public String getError() {
		return (m_error_string);
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

	public String isCollection() {
		String ret = "No";
		CachedRowSet l_rs;
		String sqlString = "select collection from DATASOURCEEVLINK " + "where DATASOURCEID=" + m_datasource_id + " and " + "DATASOURCEEVLINKID='" + m_datasoureevlinkid + "'";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				if (l_rs.getString("collection").equals("yes")) ret = "Yes";
			}
			stmt.close();
		} catch (Exception e) {
			handleException(e);
		}
		return (ret);
	}

	public void loadLinkedProperties(int p_id) {
		CachedRowSet l_rs;
		String sqlString = "";

		try {
			// load(p_id);
			Statement stmt = m_db.m_conn.createStatement();
			// if(m_datasource_name != null && !m_datasource_name.equals("")){
			sqlString = "select DATASOURCE.DATASOURCE, " + "DATASOURCEEVLINK.DATASOURCEEVLINKID, " + "DATASOURCEEVLINK.DATASOURCEID, " + "DATASOURCEEVLINK.DATASOURCEDESCRIPTION, "
					+ "DATASOURCEEVLINK.COLLECTION " + "from DATASOURCEEVLINK, DATASOURCE " + "where EVENTID=" + m_event_id + " and DATASOURCEEVLINKID=" + p_id + " and "
					+ "DATASOURCE.DATASOURCEID=DATASOURCEEVLINK.DATASOURCEID " + "ORDER BY DATASOURCE.DATASOURCE ASC";
			l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				// make m_datasource_desc & m_collection are to be
				// the description & colection from
				// DATASOURCEEVLINK.DATASOURCEDESCRIPTION &
				// DATASOURCEEVLINK.COLLECTION
				m_datasource_desc = l_rs.getString("DATASOURCEDESCRIPTION");
				m_collection = l_rs.getString("COLLECTION");
				m_datasoureevlinkid = l_rs.getString("DATASOURCEEVLINKID");
				m_datasource_id = l_rs.getInt("DATASOURCEID");
				// m_datasource_name = getName(l_rs.getInt("DATASOURCEID"));
				m_datasource_name = l_rs.getString("DATASOURCE");
				if (m_datasource_name == null || m_datasource_name.equals("")) {
					m_datasource_name = "";
				}
				if (m_datasource_desc == null || m_datasource_desc.equals("")) {
					m_datasource_desc = "";
				}
				if (m_collection == null || m_collection.equals("")) {
					m_collection = "";
				}
				if (m_datasoureevlinkid == null || m_datasoureevlinkid.equals("")) {
					m_datasoureevlinkid = "";
				}
			}
			// }//else{
			// data source that don't link to any event
			// sqlString = "select DATASOURCE " +
			// "from DATASOURCE " +
			// "where DATASOURCEID=" + p_id;

			// l_rs = m_db.runSQL(sqlString, stmt);
			// if(l_rs.next()){
			// m_datasource_name = l_rs.getString("DATASOURCE");
			// m_datasource_desc = "";
			// m_collection = "";
			// m_datasoureevlinkid = "";
			// }
			// }

			stmt.close();
		} catch (Exception e) {
			handleException(e);
		}
	}

	public void loadLinkedProperties(int p_id, int p_event_id, String p_datasourceevelinkids) {
		CachedRowSet l_rs;

		String sqlString = "select DATASOURCEEVLINK.DATASOURCEEVLINKID, DATASOURCE.DATASOURCE, " + "DATASOURCEEVLINK.DATASOURCEDESCRIPTION, " + "DATASOURCEEVLINK.COLLECTION "
				+ "from DATASOURCE, DATASOURCEEVLINK " + "where DATASOURCE.DATASOURCEID=" + p_id + " " + "and DATASOURCE.DATASOURCEID=DATASOURCEEVLINK.DATASOURCEID "
				+ "and DATASOURCEEVLINK.EVENTID=" + p_event_id + " and " + "DATASOURCEEVLINK.DATASOURCEEVLINKID not in (" + p_datasourceevelinkids + ") "
				+ "ORDER BY DATASOURCE.DATASOURCE ASC";

		// set the id here
		m_datasource_id = p_id;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				m_datasource_name = l_rs.getString("DATASOURCE");
				m_datasource_desc = l_rs.getString("DATASOURCEDESCRIPTION");
				m_collection = l_rs.getString("COLLECTION");
				m_datasoureevlinkid = l_rs.getString("DATASOURCEEVLINKID");

				if (m_datasource_name == null || m_datasource_name.equals("")) {
					m_datasource_name = "";
				}
				if (m_datasource_desc == null || m_datasource_desc.equals("")) {
					m_datasource_desc = "";
				}
				if (m_collection == null || m_collection.equals("")) {
					m_collection = "";
				}
				if (m_datasoureevlinkid == null || m_datasoureevlinkid.equals("")) {
					m_datasoureevlinkid = "";
				}
			} else {
				// data source that don't link to any event
				sqlString = "select DATASOURCE " + "from DATASOURCE " + "where DATASOURCEID=" + p_id;

				l_rs = m_db.runSQL(sqlString, stmt);
				if (l_rs.next()) {
					m_datasource_name = l_rs.getString("DATASOURCE");
					m_datasource_desc = "";
					m_collection = "";
					m_datasoureevlinkid = "";
				}
			}

			stmt.close();
		} catch (Exception e) {
			handleException(e);
		}
	}

	// GETTERS
	/*
	 * Name: getId()
	 * 
	 * Returns: ID of the loaded datasource
	 */
	public int getId() {
		return (m_datasource_id);
	}

	public String getDatasoureEvlinkId() {
		return (m_datasoureevlinkid);
	}

	public int getEventId() {
		return (m_event_id);
	}

	/*
	 * Name: getName()
	 * 
	 * Returns: Name of the loaded datasource
	 */
	public String getName() {
		return (m_datasource_name);
	}

	public String getName(int p_id) {
		CachedRowSet l_rs;
		String ret_val = "";
		String sqlString = "select DATASOURCE from DATASOURCE " + "where DATASOURCEID=" + p_id;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				ret_val = l_rs.getString("DATASOURCE");
			}
			stmt.close();
		} catch (Exception e) {
			handleException(e);
		}
		return (ret_val);
	}

	/*
	 * Name: getDescription()
	 * 
	 * Returns: Description of the loaded datasource
	 */
	public String getDescription() {
		return (m_datasource_desc);
	}

	public String getCollection() {
		return (m_collection);
	}

	// SETTERS
	public void setId(String p_id) {
		m_datasource_id = Integer.parseInt(p_id);
	}

	public void setEventId(String p_event_id) {
		m_event_id = Integer.parseInt(p_event_id);
	}

	/*
	 * Name: setName()
	 * 
	 * Parameters: p_new_name The value to set the name of this datasource to.
	 * 
	 * Returns: None
	 */

	public void setDatasoureEvlinkId(String p_datasoureevlinkid) {
		m_datasoureevlinkid = p_datasoureevlinkid;
	}

	public void setName(String p_name) {
		m_datasource_name = p_name;
	}

	public void setDescription(String p_description) {
		m_datasource_desc = p_description;
	}

	public void setCollection(String p_collection) {
		m_collection = p_collection;
	}

	public void setMdb(ausstage.Database p_db) {
		m_db = p_db;
	}
}

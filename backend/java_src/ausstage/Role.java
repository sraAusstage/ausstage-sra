package ausstage;
import java.util.*;
import java.sql.*;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Role {

	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	public String m_role_id;
	public String m_role_name;
	private String m_error_string;
	
	
	
	public Role(ausstage.Database p_db) {
		m_db = p_db;
		initialise();
	}
	
	public void initialise() {
		m_role_id = "0";
		m_role_name = "";
		m_error_string = "";
	}
	public String getRoleId() {
		return (m_role_id);
	}
	public String getId() {
		return (m_role_id);
	}

	public String getName() {
		return (m_role_name);
	}
	
	public CachedRowSet getRoles(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT role_id,name FROM role";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getroles().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT role_id,name FROM role WHERE " + "role_id=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_role_id = l_rs.getString("role_id");
				m_role_name = l_rs.getString("name");

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadRoles().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}
}

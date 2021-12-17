package admin;

import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package admin:
//            LDAPConnector, AppConstants, Database

public class ValidateLogin {

	private int EXIST;
	private int VALIDATE;
	public String m_user;
	public String m_fullUserName;
	public String m_firstUserName;
	public String m_lastUserName;
	public String m_password;
	public String m_isAdmin;
	public String m_userId;
	public String loginResult;
	private AppConstants AppConstants;

	// private LDAPConnector ldapConnector;

	public ValidateLogin() {
		EXIST = 1111;
		VALIDATE = 2222;
		m_user = "";
		m_fullUserName = "";
		m_firstUserName = "";
		m_lastUserName = "";
		m_password = "";
		m_isAdmin = "false";
		m_userId = "";
		loginResult = "";
		// ldapConnector = new LDAPConnector();
	}

	public boolean checkPermission(boolean p_sval1, boolean p_sval2, boolean p_sval3, boolean p_sval4, boolean p_sval5, boolean p_sval6, int p_f1, int p_f2, int p_f3, int p_f4,
			int p_f5, int p_f6) {
		if (!p_sval1 && p_f1 != 0) {
			return true;
		}
		if (!p_sval2 && p_f2 != 0) {
			return true;
		}
		if (!p_sval3 && p_f3 != 0) {
			return true;
		}
		if (!p_sval4 && p_f4 != 0) {
			return true;
		}
		if (!p_sval5 && p_f5 != 0) {
			return true;
		}
		return !p_sval6 && p_f6 != 0;
	}

	public boolean authenticateUser(String p_username, String p_password, Database p_db) {
		m_user = p_username;
		String errorMessage = p_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
		if (!errorMessage.equals("")) {
			loginResult = errorMessage;
			return false;
		}
		boolean logonSuccess = false;

		if (p_password == null) {
			logonSuccess = checkAuthors(EXIST, p_username, p_password, p_db);
		} else {
			logonSuccess = checkAuthors(VALIDATE, p_username, p_password, p_db);
		}
		System.out.println("check server backend");
		return logonSuccess;
	}

	/*
	 * private boolean checkLDAP(int checkType, String p_username, String
	 * p_password, Database p_db) { boolean success = false; if(checkType ==
	 * VALIDATE) { if(p_password == null || p_password.length() == 0) {
	 * loginResult = "LDAP: Logon not successful - missing User ID or password";
	 * return false; } System.out.println("ValidateLogin.login - before call");
	 * success = ldapConnector.login(p_username, p_password);
	 * System.out.println("//? LDAP Authentication = " + success); loginResult =
	 * ldapConnector.getErrorMessage();
	 * System.out.println("ValidateLogin.login - after check error"); }
	 * if(checkType == EXIST) {
	 * System.out.println("ValidateLogin.ldapConnectAndSearch - before call");
	 * success = ldapConnector.ldapConnectAndSearch(p_username);
	 * System.out.println("ValidateLogin.ldapConnectAndSearch - after call");
	 * loginResult = ldapConnector.getErrorMessage();
	 * System.out.println("ValidateLogin.ldapConnectAndSearch - after check error"
	 * ); } if(!success) { return false; }
	 * System.out.println("ValidateLogin.createUserRecordsIfRequired - before call"
	 * ); success = ldapConnector.createUserRecordsIfRequired(p_db);
	 * System.out.println
	 * ("ValidateLogin.createUserRecordsIfRequired - after call"); if(success) {
	 * success = checkAuthors(EXIST, p_username, p_password, p_db); } return
	 * success; }
	 */

	private boolean checkAuthors(int checkType, String p_username, String p_password, Database p_db) {
		String sqlString = "";
		try {
			Statement stmt = p_db.m_conn.createStatement();
			if (checkType == EXIST) {
				sqlString = "select * from authors where user_name='" + p_username + "'";
			} else {
				sqlString = "select * from authors where user_name='" + p_username + "' and password='" + p_password + "'";
			}
			CachedRowSet rset = p_db.runSQL(sqlString, stmt);
			if (rset.next()) {
				m_userId = rset.getString("auth_id");
				if (rset.getString("is_admin").equals("t")) {
					m_isAdmin = "true";
				} else {
					m_isAdmin = "false";
				}
				m_lastUserName = rset.getString("last_name");
				m_firstUserName = rset.getString("first_name");
				m_fullUserName = m_firstUserName + " " + m_lastUserName;
				stmt.close();

				return true;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to execute the query - We have an exception!!!");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return false;
	}
}

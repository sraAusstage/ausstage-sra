/***************************************************

Company: SRA
Author: Talha Abid
Project: Removal of OpenCms Dependencies from AusStage

File: Authentication.java

Purpose: Provides Login & Authentication Functionality

 ***************************************************/
package admin;

import java.sql.Connection;
import java.sql.Statement;
import sun.jdbc.rowset.CachedRowSet;
import java.util.*;

public class Authentication {

	private ausstage.Database db = new ausstage.Database();
	private AppConstants AppConstant = new AppConstants();

	public Authentication(AppConstants AppConstants) {

		db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
		// db.connDatabase("root","srasra");
	}

	public HashMap login(String username, String password) {
		HashMap<String, String> result = new HashMap<String, String>();
		boolean lockedStatus = false;
		boolean validity = false;
		boolean accountExists = checkAccountExist(username);
		if (accountExists == true) {
			lockedStatus = checkAccountStatus(username);
		} else {
			result.put("message", "User Does Not Exist!");
			result.put("status", "loginfailed");
			return result;
		}

		if (lockedStatus == true) {
			result.put("message",
					"You have attempted to login too many times and your account is now locked. Please contact the administrator");
			result.put("status", "loginfailed");
			return result;
		} else {
			// call validation
			validity = validation(username, password);
		}
		if (validity == true) {
			result.put("message", "success");
			result.put("status", "loginSuccess");
			updateLastLogin(username);
			return result;
		} else {
			result.put("message", "Username/Password Does Not Match Our Record");
			result.put("status", "loginfailed");
			return result;
		}

	}

	private boolean checkAccountStatus(String username) {
		String sqlString = "";
		boolean lockedStatus = false;
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select account_locked_flag from useraccount where username='" +db.plSqlSafeString(username) + "'";
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				if (rset.getString("account_locked_flag").equals("Y")) {
					//System.out.println("Account Locked: " + rset.getString("account_locked_flag"));
					lockedStatus = true;
				} else {
					//System.out.println("Account Locked: " + rset.getString("account_locked_flag"));
					lockedStatus = false;
				}
			}
			stmt.close();

			return lockedStatus;

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

	private boolean checkAccountExist(String username) {
		String sqlString = "";
		boolean accountExists = false;
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select count(1) as userexist from useraccount where username='" + db.plSqlSafeString(username) + "'";
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				if (rset.getInt("userexist") == 1) {
					//System.out.println("User Exists");
					accountExists = true;
				} else {
					//System.out.println("User Does Not Exist");
					accountExists = false;
				}

			}
			stmt.close();

			return accountExists;

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

	private boolean validation(String username, String password) {
		String sqlString = "";
		boolean validity = false;
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select username,Cast(aes_decrypt(password,'"+AppConstant.PASSWORD_ENCRYPTION_KEY+"') as Char) as password from useraccount where username='" + db.plSqlSafeString(username) + "'";
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				if (rset.getString("username").equalsIgnoreCase(username)
						&& rset.getString("password").equals(password)) {
					//System.out.println("Authenticated");
					validity = true;
				} else {
					//System.out.println("Not Authenticated");
					validity = false;
				}
			}
			stmt.close();

			return validity;

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
	
	
	public boolean lockAccount(String username) {
		String sqlString = "";
		boolean lockAccount = false;
		if (checkAccountExist(username)) {
			try {
				Statement stmt = db.m_conn.createStatement();
				sqlString = "update useraccount set account_locked_flag = 'Y',modified_by_user = '"+db.plSqlSafeString(getFullName(username))+"', modified_date= now() where username='" + db.plSqlSafeString(username) + "'";
				db.runSQL(sqlString, stmt);
				if(checkAccountStatus(username)) {
					lockAccount=true;
				}
				stmt.close();

				return lockAccount;

			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("Trying to execute the query - We have an exception!!!");
				System.out.println("The query is " + sqlString);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
		}
		
		return false;
	}
	public String getFullName(String username) {
		String sqlString = "";
		String fullName = "";
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select first_name,last_name from useraccount where username='" + db.plSqlSafeString(username) + "'";
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			if (rset.next()) {
				fullName= rset.getString("first_name")+rset.getString("last_name");
			}
			stmt.close();

			return fullName;

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to execute the query - We have an exception!!!");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return fullName;
	}
	public ArrayList<String> getUserRoles(String username) {
		String sqlString = "";
		ArrayList<String> userRoles = new ArrayList<String>();
		try {
			Statement stmt = db.m_conn.createStatement();
			sqlString = "select role.name from" + 
					"((role inner join userrole ON role.role_id = userrole.role_id) inner join useraccount on userrole.useraccount_id = useraccount.useraccount_id)" + 
					"where useraccount.username='" + db.plSqlSafeString(username) + "'";
			CachedRowSet rset = db.runSQL(sqlString, stmt);
			while (rset.next()) {
				userRoles.add(rset.getString("name"));
			}
			stmt.close();

			return userRoles;

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to execute the query - We have an exception!!!");
			System.out.println("The query is " + sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return userRoles;
	}
	private void updateLastLogin(String username) {
		String sqlString = "";
			try {
				Statement stmt = db.m_conn.createStatement();
				sqlString = "update useraccount set last_login_date = now() where username='" + db.plSqlSafeString(username) + "'";
				db.runSQL(sqlString, stmt);
				stmt.close();

			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("Trying to execute the query - We have an exception!!!");
				System.out.println("The query is " + sqlString);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
	}
}

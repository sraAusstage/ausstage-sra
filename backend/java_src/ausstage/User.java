package ausstage;

import java.sql.ResultSet;
import java.sql.Statement;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Vector;
import java.util.regex.*;


import javax.servlet.http.HttpServletRequest;

import sun.jdbc.rowset.CachedRowSet;

public class User {

	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	
	private String m_username;
	private String m_first_name;
	private String m_last_name;
	private String m_email;
	private String m_organization;
	private String m_password;
	private String m_confirm_password;
	private String m_last_login;
	private String m_created_by_user;
	private String m_created_date;
	private String m_modified_by_user;
	private String m_modified_date;
	private String m_account_lock_flag;
	private Vector<Role> roles;
	
	private String m_error_string;
	
	public User(ausstage.Database p_db) {
		m_db = p_db;
		initialise();
	}
	
	
	public void initialise() {
		m_username="";
		m_first_name="";
		m_last_name="";
		m_email="";
		m_organization="";
		m_password="";
		m_confirm_password="";
		m_last_login="";
		m_created_by_user="";
		m_created_date="";
		m_modified_by_user="";
		m_modified_date="";
		m_account_lock_flag="";
		roles=new Vector();
	}
	public String getUserName() {
		return m_username;
	}
	public String getFirstName() {
		return m_first_name;
	}
	public String getLastName() {
		return m_last_name;
	}
	public String getEmail() {
		return m_email;
	}
	public String getOrganization() {
		return m_organization;
	}
	public String getLastLogin() {
		return m_last_login;
	}
	public String getCreatedByUser() {
		return m_created_by_user;
	}
	public String getCreatedDate() {
		return m_created_date;
	}
	public String getModifiedByUser() {
		return m_modified_by_user;
	}
	public String getModifiedByDate() {
		return m_modified_date;
	}
	public String getAccountFlag() {
		return m_account_lock_flag;
	}
	public Vector<Role> getRoles() {
		return roles;
	}
	public void load(String  p_username) {
		CachedRowSet l_rs;
		String sqlString = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "select username,first_name,last_name,email,ifnull(organization,'') as organization,created_by_user,Date_format(useraccount.created_date,'%D %M %Y') as created_date,ifnull(Date_format(useraccount.last_login_date,'%D %M %Y'),'') as last_login_date,modified_by_user,Date_format(useraccount.modified_date,'%D %M %Y') as modified_date,account_locked_flag from useraccount WHERE username = '"+p_username+"'";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				m_username=l_rs.getString("username");
				m_first_name=l_rs.getString("first_name");
				m_last_name=l_rs.getString("last_name");
				m_email=l_rs.getString("email");
				m_organization=l_rs.getString("organization");
				m_last_login=l_rs.getString("last_login_date");
				m_created_by_user=l_rs.getString("created_by_user");
				m_created_date=l_rs.getString("created_date");
				m_modified_by_user=l_rs.getString("modified_by_user");
				m_modified_date=l_rs.getString("modified_date");
				m_account_lock_flag=l_rs.getString("account_locked_flag");
			}
			l_rs.close();
			stmt.close();
			roles=getUserRoles(p_username);
			//System.out.println(roles);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occurred in User - load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}
	public Vector<Role> getUserRoles(String  p_username) {
		CachedRowSet l_rs;
		String sqlString = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "select role.role_id, role.name from" + 
					"((role inner join userrole ON role.role_id = userrole.role_id) inner join useraccount on userrole.useraccount_id = useraccount.useraccount_id)" + 
					"where useraccount.username='" + p_username + "'";
			l_rs = m_db.runSQL(sqlString, stmt);

			while (l_rs.next()) {
				Role r = new Role(m_db);
				r.m_role_id=l_rs.getString("role_id");
				r.m_role_name=l_rs.getString("name");
				//System.out.println(l_rs.getString("role_id")+" "+l_rs.getString("name"));
				roles.addElement(r);
			}
			//System.out.println(roles);
			l_rs.close();
			stmt.close();
			
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occurred in User - load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return roles;
	}
	public void setUserAddAttributes(HttpServletRequest request, Vector<Role> roles) {
		

		this.m_username = request.getParameter("f_username");
		this.m_first_name = request.getParameter("f_first_name");
		this.m_last_name = request.getParameter("f_last_name");
		this.m_email = request.getParameter("f_email");

		this.m_organization = request.getParameter("f_organization");
		//this.roles
		this.m_password=request.getParameter("f_password");
		this.m_confirm_password=request.getParameter("f_confirm_password");
		this.roles=roles;
		
	}
public void setUserUpdateAttributes(HttpServletRequest request,String username, Vector<Role> roles) {
		
		
		this.m_username = username;
		this.m_first_name = request.getParameter("f_first_name");
		this.m_last_name = request.getParameter("f_last_name");
		this.m_email = request.getParameter("f_email");

		this.m_organization = request.getParameter("f_organization");
		//this.roles
		this.m_password=request.getParameter("f_u_password");
		this.m_confirm_password=request.getParameter("f_u_confirm_password");
		this.roles=roles;
		
	}
	public void setEnteredByUser(String s) {
		m_created_by_user = s;
	}
	public void setDatabaseConnection(ausstage.Database ad) {
		m_db = ad;
	}
	public String getError() {
		return m_error_string;
	}
	private boolean validateObjectForDB(boolean addFlag) {
		boolean l_ret = true;
		
		if (m_first_name.equals("")) {
			m_error_string = "Unable to add the User. First Name is required.";
			l_ret = false;
		} else if (m_last_name.equals("")) {
			m_error_string = "Unable to add the User. Last Name is required.";
			l_ret = false;
		}else if (m_email.equals("")) {
			m_error_string = "Unable to add the User. Email is required.";
			l_ret = false;
		}

		
		if(addFlag) {
			if (m_username.equals("")) {
				m_error_string = "Unable to add the User. username is required.";
				l_ret = false;
			} else if (m_password.equals("")) {
				m_error_string = "Unable to add the User. Password is required.";
				l_ret = false;
			}else if (m_confirm_password.equals("")) {
				m_error_string = "Unable to add the User. Confirm Password is required.";
				l_ret = false;
			}
		} 
		
		return (l_ret);
	}
	

	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			int id = 0;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB(true)) {
				if(checkUsername(m_username)) {
					m_error_string = "Unable to insert the User. The Username already Exists";
					return false;
				}
				if(checkEmail(m_email)) {
					m_error_string = "Unable to insert the User. The Email already Exists";
					return false;
				}
				if(!validateEmail(m_email)) {
					m_error_string = "Invalid Email. The Email does not match a valid email address";
					return false;
				}
				if(!m_password.equals(m_confirm_password)) {
					m_error_string = "Unable to insert the User. The Passwords Do not match";
					return false;
				}
				if(!validatePassword(m_password)) {
					m_error_string = "Invalid Password. The Password Must Contain Atleast 1 Uppercase, 1 LowerCase, 2 Special Characters & be between 8 to 16 Characters Long";
					return false;
				}
				
				sqlString = "Insert into useraccount(username,first_name,last_name,email,password,organization,account_locked_flag,created_by_user,created_date)"
						+"Values('"+m_db.plSqlSafeString(m_username)+"','"+m_db.plSqlSafeString(m_first_name)+"','"+m_db.plSqlSafeString(m_last_name)+"','"+m_db.plSqlSafeString(m_email)+"',"
								+ "aes_encrypt('"+m_db.plSqlSafeString(m_password)+"','"+AppConstants.PASSWORD_ENCRYPTION_KEY+"'),'"+m_db.plSqlSafeString(m_organization)+"','N','"+m_db.plSqlSafeString(m_created_by_user)+"',now())";
				
				m_db.runSQL(sqlString, stmt);
				id=getUserId(m_username);
				insertRoles(id,roles);
				l_ret=true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to insert the User. The data may be invalid.";
			return (false);
		}
	}
	public boolean update() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			int userId=0;
			
			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB(false)) {
				
				
				if(!validateEmail(m_email)) {
					m_error_string = "Invalid Email. The Email does not match a valid email address";
					return false;
				}
				if(checkEmailAgainstOtherUsers(m_email,m_username)) {
					m_error_string = "Unable to update the User. The Email already Exists for another user";
					return false;
				}
				/*for(int i = 0;i<roles.size();i++) {
					System.out.println(roles.get(i).m_role_id);
				}*/
				
				userId=getUserId(m_username);
				
				
				if (!m_password.equals("")&& m_password != null) {
					
					if(!m_password.equals(m_confirm_password)) {
						m_error_string = "Unable to update the User. The Passwords Do not match";
						return false;
					}
					// To Do Add Validate Password
					
					if(!validatePassword(m_password)) {
						m_error_string = "Invalid Password. The Password Must Contain Atleast 1 Uppercase, 1 LowerCase, 2 Special Characters & be between 8 to 16 Characters Long";
						return false;
					}
					
					sqlString = "Update useraccount set first_name='"+ m_db.plSqlSafeString(m_first_name)+"' , "
							+ "last_name='"+ m_db.plSqlSafeString(m_last_name)+"' , "
							+ "email='"+ m_db.plSqlSafeString(m_email)+"' , "
							+ "password=aes_encrypt('"+m_db.plSqlSafeString(m_password)+"','"+AppConstants.PASSWORD_ENCRYPTION_KEY+"') , "
							+ "organization='"+ m_db.plSqlSafeString(m_organization)+"' , "
							+ "account_locked_flag='N' , "
							+ "modified_by_user='"+ m_db.plSqlSafeString(m_created_by_user)+"' , "
							+ "modified_date= now() "
							+ "where username='" + m_db.plSqlSafeString(m_username) + "'";

				} else {
					
					sqlString = "Update useraccount set first_name='"+ m_db.plSqlSafeString(m_first_name)+"' , "
							+ "last_name='"+ m_db.plSqlSafeString(m_last_name)+"' , "
							+ "email='"+ m_db.plSqlSafeString(m_email)+"' , "
							+ "organization='"+ m_db.plSqlSafeString(m_organization)+"' , "
							+ "modified_by_user='"+ m_db.plSqlSafeString(m_created_by_user)+"' , "
							+ "modified_date= now() "
							+ "where username='" + m_db.plSqlSafeString(m_username) + "'";
				}
				m_db.runSQL(sqlString, stmt);
				updateRoles(userId,roles);
				l_ret=true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e)  {
			//throw e;
			m_error_string = "Unable to update the User. The data may be invalid.";
			return (false);
		}
	}
	
	
	
	
	private boolean checkUsername(String username) {
		String sqlString = "";
		boolean accountExists = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "select count(1) as userexist from useraccount where username='" + m_db.plSqlSafeString(username) + "'";
			CachedRowSet rset = m_db.runSQL(sqlString, stmt);
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
	private boolean checkEmail(String email) {
		String sqlString = "";
		boolean accountExists = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "select count(1) as emailexist from useraccount where email='" + m_db.plSqlSafeString(email) + "'";
			CachedRowSet rset = m_db.runSQL(sqlString, stmt);
			if (rset.next()) {
				if (rset.getInt("emailexist") == 1) {
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
	private boolean checkEmailAgainstOtherUsers(String email,String username) {
		String sqlString = "";
		boolean accountExists = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "select count(1) as emailexist from useraccount where email='" + m_db.plSqlSafeString(email) + "' and username != '" + m_db.plSqlSafeString(username) + "' ";
			CachedRowSet rset = m_db.runSQL(sqlString, stmt);
			if (rset.next()) {
				if (rset.getInt("emailexist") == 1) {
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
		private boolean validateEmail (String email) {
			boolean match=false;
			String regex = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$";
			Pattern pattern = Pattern.compile(regex);
			Matcher matcher = pattern.matcher(email);
			if(matcher.matches()) {
				match=true;
			}
			return match;
		}
		private boolean validatePassword (String password) {
			boolean match=true;
			
			if(password.length()<8 || password.length()>16 ) {
				//System.out.println("Length error");
				return false;
			}
			String regex = ".*[A-Z].*";
			Pattern pattern = Pattern.compile(regex);
			Matcher matcher = pattern.matcher(password);
			if(!matcher.matches()) {
				//System.out.println("Uppercase error");
				return false;
			}
			regex = ".*[a-z].*";
			pattern = Pattern.compile(regex);
			matcher = pattern.matcher(password);
			if(!matcher.matches()) {
				//System.out.println("Lowercase error");
				return false;
			}
			regex = ".*(?:[^`!@#$%^&?*\\-_=+'/.,]*[`!@#$%^&?*\\-_=+'/.,]){2}.*";
			pattern = Pattern.compile(regex);
			matcher = pattern.matcher(password);
			if(!matcher.matches()) {
				//System.out.println("Special Character Error");
				return false;
			}			
			return match;
		}
		private int getUserId(String username) {
			String sqlString = "";
			int id=0;
			try {
				Statement stmt = m_db.m_conn.createStatement();
				sqlString = "select useraccount_id from useraccount where username='" + m_db.plSqlSafeString(username) + "'";
				CachedRowSet rset = m_db.runSQL(sqlString, stmt);
				if (rset.next()) {
					id=rset.getInt("useraccount_id");

				}
				stmt.close();

				return id;

			} catch (Exception e) {
				System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
				System.out.println("Trying to execute the query - We have an exception!!!");
				System.out.println("The query is " + sqlString);
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			}
			return id;
		}
		private void insertRoles(int id, Vector<Role> roles) {
			String sqlString = "";
			
			try {
				Statement stmt = m_db.m_conn.createStatement();
				for(int i= 0;i<roles.size();i++) {
				sqlString = "Insert into userrole(useraccount_id,role_id,created_by_user,created_date) values("+id+","+Integer.parseInt(roles.get(i).m_role_id)+",'"+m_created_by_user+"',now())";
				CachedRowSet rset = m_db.runSQL(sqlString, stmt);
				}
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
		private void updateRoles(int id, Vector<Role> roles) {
			String sqlString = "";
			
			try {
				Statement stmt = m_db.m_conn.createStatement();
				deleteRoles(id);
				for(int i= 0;i<roles.size();i++) {
				sqlString = "Insert into userrole(useraccount_id,role_id,created_by_user,created_date,modified_by_user,modified_date) values("+id+","+Integer.parseInt(roles.get(i).m_role_id)+",'"+m_created_by_user+"',now(),'"+m_created_by_user+"',now())";
				CachedRowSet rset = m_db.runSQL(sqlString, stmt);
				}
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
		private void deleteRoles(int id) {
			String sqlString = "";
			
			try {
				Statement stmt = m_db.m_conn.createStatement();
				
				sqlString = "Delete from userrole where useraccount_id="+id;
				CachedRowSet rset = m_db.runSQL(sqlString, stmt);
				
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
		public boolean delete() {
			try {
				Statement stmt = m_db.m_conn.createStatement();
				String sqlString;
				boolean l_ret = false;
				int id = getUserId(m_username);
				if(!checkUsername(m_username)) {
					m_error_string = "Unable to delete the User. The User does not exist";
					return false;
				}
				deleteRoles(id);
		
				sqlString = "DELETE FROM useraccount WHERE useraccount_id = "+id;
				m_db.runSQL(sqlString, stmt);

				l_ret = true;
				
				stmt.close();
				return (l_ret);
			} catch (Exception e) {
				m_error_string = "Unable to delete the User. The data may be invalid.";
				return (false);
			}
		}
		
}

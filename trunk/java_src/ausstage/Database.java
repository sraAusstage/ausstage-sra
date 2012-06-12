package ausstage;

import java.io.PrintStream;
import java.sql.*;
import java.util.Calendar;
import java.util.Date;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package admin:
//            AppConstants, Common

public class Database {

	public Connection m_conn;
	private admin.AppConstants AppConstants;
	private String m_year;
	private String m_month;
	private String m_day;

	public Database() {
		AppConstants = new admin.AppConstants();
		m_year = "";
		m_month = "";
		m_day = "";
		m_year = "";
		m_month = "";
		m_day = "";
	}

	public String connDatabase(String p_user, String p_password) {
		try {
			if (m_conn != null) {
				for (; !m_conn.isClosed(); m_conn.close()) {
				}
			}
			m_conn = DriverManager.getConnection(AppConstants.DB_CONNECTION_STRING, p_user, p_password);
		} catch (Exception e) {
			System.out.println("Trying to open DB - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			String s = e.getLocalizedMessage().substring(e.getLocalizedMessage().indexOf(": ") + 2);
			return s;
		}
		return "";
	}

	public void disconnectDatabase() {
		try {
			m_conn.close();
		} catch (Exception e) {
			System.out.println("Trying to close DB - We have an exception!!!");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
		}
	}

	public ResultSet runSQLResultSet(String p_sqlString, Statement p_stmt) throws Exception {
		ResultSet rset = null;
		try {
			if (p_sqlString.trim().substring(0, 6).toUpperCase().equals("SELECT")) {
				rset = p_stmt.executeQuery(p_sqlString);
			} else {
				p_stmt.executeUpdate(p_sqlString);
				ResultSet resultset = null;
				return resultset;
			}
			ResultSet resultset1 = rset;
			return resultset1;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to execute the query - We have an exception!!!");
			System.out.println("The query is " + p_sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			throw e;
		}
	}

	public CachedRowSet runSQL(String p_sqlString, Statement p_stmt) throws Exception {
		try {
			CachedRowSet crset = new CachedRowSet();
			ResultSet rset = runSQLResultSet(p_sqlString, p_stmt);
			if (rset == null) {
				CachedRowSet cachedrowset = null;
				return cachedrowset;
			} else {
				crset.populate(rset);
				CachedRowSet cachedrowset1 = crset;
				return cachedrowset1;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("Trying to make a CachedRowSet");
			System.out.println("The query is " + p_sqlString);
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			throw e;
		}
	}

	public String plSqlSafeString(String p_string) {
		admin.Common common = new admin.Common();
		Database _tmp = this;
		if (AppConstants.DATABASE_TYPE == 1) {
			int startIndex = 0;
			if (p_string != null && !p_string.equals("")) {
				p_string = common.ReplaceStrWithStr(p_string, "'", "'||CHR(39)||'");
			}
			startIndex = 0;
			if (p_string != null && !p_string.equals("")) {
				p_string = common.ReplaceStrWithStr(p_string, "&", "'||CHR(38)||'");
			}
		} else if (p_string != null && !p_string.equals("")) {
			p_string = common.ReplaceStrWithStr(p_string, "'", "''");
		}
		return p_string;
	}

	public String getInsertedIndexValue(Statement p_stmt, String p_sequence_name) {
		String result;
		label0: {
			result = "";
			try {
				Database _tmp = this;
				if (AppConstants.DATABASE_TYPE == 1) {
					result = getInsertedIndex(p_stmt, p_sequence_name);
					break label0;
				}
				Database _tmp1 = this;
				if (AppConstants.DATABASE_TYPE != 2) {
					Database _tmp2 = this;
					if (AppConstants.DATABASE_TYPE != 4) {
						Database _tmp3 = this;
						if (AppConstants.DATABASE_TYPE != 3) {
							break label0;
						}
					}
				}
				result = getInsertedIndex(p_stmt);
			} catch (Exception e) {
				System.out.println("Exception occured in Database.getInsertedIndexValue()");
				System.out.println("MESSAGE: " + e.getMessage());
				System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
				System.out.println("CLASS.TOSTRING: " + e.toString());
				result = null;
			}
		}
		return result;
	}

	private String getInsertedIndex(Statement p_stmt, String p_sequence_name) throws Exception {
		String sqlString = "";
		try {
			sqlString = "select " + p_sequence_name + ".currval as curr_val FROM DUAL";
			CachedRowSet rset = runSQL(sqlString, p_stmt);
			rset.next();
			String s = rset.getString("curr_val");
			return s;
		} catch (Exception e) {
			System.out.println("Trying to get last identity from DUAL - We have an exception!!!");
			System.out.println("The query is " + sqlString);
			throw e;
		}
	}

	private String getInsertedIndex(Statement p_stmt) throws Exception {
		String sqlString = "";
		try {
			sqlString = "select @@identity as NewID";
			CachedRowSet rset = runSQL(sqlString, p_stmt);
			rset.next();
			String s = rset.getString("NewID");
			return s;
		} catch (Exception e) {
			System.out.println("Trying to get last identity from a table - We have an exception!!!");
			System.out.println("The query is " + sqlString);
			throw e;
		}
	}

	public String safeDateFormat(String p_strDate) {
		String retStr;
		String l_day;
		String l_month;
		String l_year;
		label0: {
			label1: {
				label2: {
					String token = "";
					String dformat = "";
					retStr = "";
					l_day = "";
					l_month = "";
					l_year = "";
					Calendar cal = Calendar.getInstance();
					m_year = "";
					m_month = "";
					m_day = "";
					formatDate(p_strDate);
					if (!m_day.equals("") && Integer.parseInt(m_day) < 10 && m_day.length() < 2) {
						l_day = "0" + m_day;
					} else {
						l_day = m_day;
					}
					if (!m_month.equals("") && Integer.parseInt(m_month) < 10 && m_month.length() < 2) {
						l_month = "0" + m_month;
					} else {
						l_month = m_month;
					}
					if (m_year.equals("") || Integer.parseInt(m_year) >= 10 || m_year.length() >= 2) {
						break label1;
					}
					Database _tmp = this;
					if (AppConstants.DATABASE_TYPE != 2) {
						Database _tmp1 = this;
						if (AppConstants.DATABASE_TYPE != 3) {
							break label2;
						}
					}
					l_year = Integer.toString(cal.get(1));
					break label0;
				}
				l_year = "0" + m_year;
				break label0;
			}
			l_year = m_year;
		}
		label3: {
			Database _tmp2 = this;
			if (AppConstants.DATABASE_TYPE == 1) {
				String token = "yyyy-mm-dd";
				String dformat = l_year + "-" + l_month + "-" + l_day;
				retStr = "to_date('" + dformat + "','" + token + "')";
				break label3;
			}
			Database _tmp3 = this;
			if (AppConstants.DATABASE_TYPE == 4) {
				retStr = "'" + l_year + "-" + l_month + "-" + l_day + "'";
				break label3;
			}
			Database _tmp4 = this;
			if (AppConstants.DATABASE_TYPE != 2) {
				Database _tmp5 = this;
				if (AppConstants.DATABASE_TYPE != 3) {
					break label3;
				}
			}
			retStr = "'" + l_day + "-" + convertMonth(l_month) + "-" + l_year + "'";
		}
		return retStr;
	}

	public String safeDateFormat(Date p_date, boolean p_include_time) {
		if (p_date == null) {
			return "";
		}
		String l_result = "";
		Calendar l_cal = Calendar.getInstance();
		l_cal.setTime(p_date);
		Database _tmp = this;
		switch (AppConstants.DATABASE_TYPE) {
		default:
			break;

		case 2: // '\002'
			l_result = l_cal.get(5) + " " + getMonthName(l_cal.get(2) + 1) + " " + l_cal.get(1);
			if (p_include_time) {
				l_result = l_result + (" " + l_cal.get(11) + ":" + l_cal.get(12) + ":" + l_cal.get(13));
			}
			l_result = "'" + l_result + "'";
			break;

		case 1: // '\001'
			if (p_include_time) {
				l_result = "TO_DATE('" + l_cal.get(1) + "/" + (l_cal.get(2) + 1) + "/" + l_cal.get(5) + ":" + l_cal.get(11) + ":" + l_cal.get(12) + ":" + l_cal.get(13)
						+ "', 'yyyy/mm/dd:hh24:mi:ss')";
			} else {
				l_result = "TO_DATE('" + l_cal.get(1) + "/" + (l_cal.get(2) + 1) + "/" + l_cal.get(5) + "', 'yyyy/mm/dd')";
			}
			break;

		case 3: // '\003'
			l_result = l_cal.get(5) + " " + getMonthName(l_cal.get(2) + 1) + " " + l_cal.get(1);
			if (p_include_time) {
				l_result = l_result + (" " + l_cal.get(11) + ":" + l_cal.get(12) + ":" + l_cal.get(13));
			}
			l_result = "#" + l_result + "#";
			break;

		case 4: // '\004'
			l_result = l_cal.get(1) + "/" + (l_cal.get(2) + 1) + "/" + l_cal.get(5);
			if (p_include_time) {
				l_result = l_result + (" " + l_cal.get(11) + ":" + l_cal.get(12) + ":" + l_cal.get(13));
			}
			l_result = "'" + l_result + "'";
			break;
		}
		return l_result;
	}

	public String safeDateFormat(Date p_date) {
		return safeDateFormat(p_date, false);
	}

	private void formatDate(String strDate) {
		String tmpStr = "";
		String tmpChar = "";
		int dtLn = strDate.length();
		for (int i = 0; i < dtLn; i++) {
			tmpStr = tmpStr + strDate.charAt(i);
			if (!tmpStr.endsWith(" ") && !tmpStr.endsWith("/") && !tmpStr.endsWith("-")) {
				continue;
			}
			tmpStr = tmpStr.trim();
			if (tmpStr.length() > 2) {
				tmpChar = tmpStr.substring(tmpStr.length() - 2, tmpStr.length());
			} else {
				if (tmpStr.endsWith("/") || tmpStr.endsWith("-")) {
					if (m_month.equals("") && !m_day.equals("")) {
						m_month = tmpStr.substring(0, tmpStr.length() - 1);
					}
					if (m_day.equals("")) {
						m_day = tmpStr.substring(0, tmpStr.length() - 1);
					}
				} else {
					m_day = tmpStr;
				}
				tmpStr = "";
				tmpChar = "";
				continue;
			}
			if (!tmpChar.endsWith("/") && !tmpChar.endsWith("-")) {
				if (tmpChar.toUpperCase().endsWith("TH") || tmpChar.toUpperCase().endsWith("RD") || tmpChar.toUpperCase().endsWith("ST") || tmpChar.toUpperCase().endsWith("ND")) {
					if (tmpStr.length() <= 4) {
						if (tmpStr.length() == 4) {
							m_day = tmpStr.substring(0, 2);
						} else {
							m_day = tmpStr.substring(0, 1);
						}
					} else {
						m_month = "08";
					}
					tmpChar = "";
					tmpStr = "";
				} else {
					m_month = convertMonth(tmpStr);
					tmpStr = "";
					tmpChar = "";
				}
				continue;
			}
			if (m_month.equals("") && !m_day.equals("")) {
				m_month = tmpStr.substring(0, tmpStr.length() - 1);
			}
			if (m_day.equals("")) {
				m_day = tmpStr.substring(0, tmpStr.length() - 1);
			}
			tmpChar = "";
			tmpStr = "";
		}

		m_year = tmpStr;
	}

	public String convertMonth(String p_str_month) {
		int i = 0;
		String retStr = "";
		String monthsArray[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" };
		if (p_str_month.length() >= 3) {
			for (i = 0; i < monthsArray.length - 1 && !p_str_month.substring(0, 3).toUpperCase().equals(monthsArray[i].substring(0, 3).toUpperCase()); i++) {
			}
			if (++i < 10) {
				retStr = "0" + Integer.toString(i);
				return retStr;
			} else {
				return Integer.toString(i);
			}
		} else {
			i = Integer.parseInt(p_str_month) - 1;
			return monthsArray[i];
		}
	}

	public String getMonthName(int p_month, boolean p_abbreviated) {
		String l_result = "";
		switch (p_month - 1) {
		case 0: // '\0'
			l_result = "January";
			break;

		case 1: // '\001'
			l_result = "February";
			break;

		case 2: // '\002'
			l_result = "March";
			break;

		case 3: // '\003'
			l_result = "April";
			break;

		case 4: // '\004'
			l_result = "May";
			break;

		case 5: // '\005'
			l_result = "June";
			break;

		case 6: // '\006'
			l_result = "July";
			break;

		case 7: // '\007'
			l_result = "August";
			break;

		case 8: // '\b'
			l_result = "September";
			break;

		case 9: // '\t'
			l_result = "October";
			break;

		case 10: // '\n'
			l_result = "November";
			break;

		case 11: // '\013'
			l_result = "December";
			break;
		}
		if (p_abbreviated && l_result.length() > 3) {
			l_result = l_result.substring(0, 3);
		}
		return l_result;
	}

	public String getMonthName(int p_month) {
		return getMonthName(p_month, false);
	}
}

package content;

import java.io.PrintStream;
import java.sql.Connection;
import java.util.Calendar;
import javax.servlet.http.HttpSession;

// Referenced classes of package content:
//            Database

public class Reports {

	static Database db;

	public Reports(Database p_db) {
		db = p_db;
	}

	public long convertIpToDecimal(String p_browser_ip) {
		int indexA = p_browser_ip.indexOf(".", 0);
		int indexB = p_browser_ip.indexOf(".", indexA + 1);
		int indexC = p_browser_ip.indexOf(".", indexB + 1);
		long A = Integer.parseInt(p_browser_ip.substring(0, indexA));
		long B = Integer.parseInt(p_browser_ip.substring(indexA + 1, indexB));
		long C = Integer.parseInt(p_browser_ip.substring(indexB + 1, indexC));
		long D = Integer.parseInt(p_browser_ip.substring(indexC + 1, p_browser_ip.length()));
		long ipDecimalNumber = (long) 0x1000000 * A + (long) 0x10000 * B + (long) 256 * C + D;
		return ipDecimalNumber;
	}

	public String addLog(String p_browser_ip, String p_page_id, HttpSession p_session) {
		Calendar cal = Calendar.getInstance();
		String sqlString = "";
		java.sql.Statement stmt = null;
		int currentDay = cal.get(5);
		int currentMonth = cal.get(2) + 1;
		int currentYear = cal.get(1);
		if (p_session.getAttribute("session_valid") == null || p_session.getAttribute("session_valid").equals("")) {
			String entry_exit_page = "b";
			String old_page_id = "0";
			p_session.setAttribute("session_valid", "true");
		} else {
			String entry_exit_page = "x";
			String old_page_id = (String) p_session.getAttribute("oldPageId");
		}
		db.connectDatabase();
		try {
			stmt = Database.m_conn.createStatement();
			sqlString = "insert into reportings (browser_ip,page_id,repo_date) values (" + convertIpToDecimal(p_browser_ip) + ", to_date('" + currentYear + "-" + currentMonth
					+ "-" + currentDay + "', 'yyyy-mm-dd'), " + p_page_id + ",)";
			db.runSQL(sqlString, stmt);
			String s = null;
			return s;
		} catch (Exception e) {
			System.out.println("Trying to execute a stored procedure - We have an exception!!!");
		}
		db.closeDatabase();
		return "";
	}
}

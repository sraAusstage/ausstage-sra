package content;

import admin.*;
import admin.Database;

import com.corda.pcis.PopChartEmbedder;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import sun.jdbc.rowset.CachedRowSet;

public class Statistics {

	public Database m_db;
	private AppConstants AppConstants;
	public String p_title;

	public Statistics(Database m_db2) {
		AppConstants = new AppConstants();
		p_title = "";
		m_db = m_db2;
	}

	public void logPublicEvent(String p_browser_ip, String p_page_title) {
		try {
			String sqlString = "";
			String sqlDate = "";
			Statement stmt1 = m_db.m_conn.createStatement();
			Calendar cal = Calendar.getInstance();
			int currentDay = cal.get(5);
			int currentMonth = cal.get(2) + 1;
			int currentYear = cal.get(1);
			sqlDate = m_db.safeDateFormat(currentDay + "/" + currentMonth + "/" + currentYear);
			if (p_page_title != null && !p_page_title.equals("")) {
				sqlString = "INSERT INTO stats_public (stats_ip, stats_date, page_title) VALUES ('" + p_browser_ip + "', to_date(" + sqlDate + "), '"
						+ m_db.plSqlSafeString(p_page_title) + "')";
				m_db.runSQL(sqlString, stmt1);
			}
			stmt1.close();
		} catch (Exception e) {
			System.out.println("Trying to log an event in logPublicEvent() - We have an exception!!!");
		}
	}

	public void logAdminEvent(HttpServletRequest p_request, String p_fun_id) {
		try {
			String sqlString = "";
			String sqlDate = "";
			String sqlAuthId = "";
			String p_browser_ip = "";
			Statement stmt1 = m_db.m_conn.createStatement();
			Calendar cal = Calendar.getInstance();
			int currentDay = cal.get(5);
			int currentMonth = cal.get(2) + 1;
			int currentYear = cal.get(1);
			HttpSession p_session = p_request.getSession(true);
			p_browser_ip = p_request.getRemoteAddr();
			sqlDate = m_db.safeDateFormat(currentDay + "/" + currentMonth + "/" + currentYear);
			sqlAuthId = p_session.getAttribute("authId").toString();
			sqlString = "INSERT INTO stats_admin (stats_ip, stats_date, fun_id, auth_id) VALUES ('" + p_browser_ip + "', to_date(" + sqlDate + "), " + p_fun_id + ", " + sqlAuthId
					+ ")";
			m_db.runSQL(sqlString, stmt1);
			stmt1.close();
		} catch (Exception e) {
			System.out.println("Trying to log an event - We have an exception!!!");
		}
	}

	public String showChart(String p_chart, int p_month, int p_year, boolean p_showTable) {
		String m_buffer = "";
		String m_appearance = "";
		String m_dataXML = "";
		try {
			m_dataXML = getStatsData(p_chart, p_month, p_year);
			m_appearance = "<?xml version='1.0' encoding='ISO-8859-1'?><Chart Version='4.00.00' FitInBounds="
					+ "'False' CollisionProtection='False'><Graph Name='graph' Top='50' Left='50' Width"
					+ "='440' Height='260' Type='Bar' SubType='Basic'><ValueScale Position='Left' Minor"
					+ "Font='Size:10;'/></Graph><Textbox Name='title' Left='60' Width='440' Height='13'"
					+ "><Properties BorderType='None' AutoWidth='False' AutoHeight='False'/><Text></Tex" + "t></Textbox></Chart>";
			PopChartEmbedder myPopChart = new PopChartEmbedder();
			myPopChart.externalServerAddress = String.valueOf("http://").concat(String.valueOf(AppConstants.STATS_SERVER)) + ":2001";
			myPopChart.internalCommPortAddress = String.valueOf("http://").concat(String.valueOf(AppConstants.STATS_SERVER)) + ":2002";
			myPopChart.addPCXML(m_appearance);
			myPopChart.setData("graph", m_dataXML);
			myPopChart.imageType = "FLASH";
			myPopChart.fallback = "STRICT";
			myPopChart.width = 530;
			myPopChart.height = 340;
			myPopChart.pcScript = "title.setText(" + p_title + ")";
			if (p_showTable) {
				myPopChart.addHTMLTable("graph", p_title);
			}
			m_buffer = myPopChart.getEmbeddingHTML();
		} catch (Exception e) {
			System.out.println("Trying to log an event - We have an exception!!!");
		}
		return m_buffer;
	}

	public String getStatsData(String p_chart, int p_month, int p_year) {
		boolean proceed = false;
		String m_sql = "";
		String m_endDay = "";
		String m_startDate = "";
		String m_endDate = "";
		String m_startDateTitle = "";
		String m_endDateTitle = "";
		String m_data = "";
		String m_count = "";
		String m_val = "";
		try {
			int DaysArray[] = new int[13];
			Common myCommon = new Common();
			Statement stmt = m_db.m_conn.createStatement();
			Date m_hitDate = new Date();
			Calendar m_cal = Calendar.getInstance();
			for (int i = 1; i < 13; i++) {
				DaysArray[i] = 31;
				if (i == 4 || i == 6 || i == 9 || i == 11) {
					DaysArray[i] = 30;
				}
				if (i != 2) {
					continue;
				}
				DaysArray[i] = 28;
				if (p_year % 4 == 0 && (p_year % 100 != 0 || p_year % 400 == 0)) {
					DaysArray[i] = 29;
				} else {
					DaysArray[i] = 28;
				}
			}

			int m_testEnd = DaysArray[p_month];
			m_endDay = DaysArray[p_month] + "";
			m_startDateTitle = "01/" + p_month + "/" + p_year;
			m_endDateTitle = m_endDay + "/" + p_month + "/" + p_year;
			m_startDate = m_db.safeDateFormat(m_startDateTitle);
			m_endDate = m_db.safeDateFormat(m_endDateTitle);
			if (p_chart.equals("hits_homepage")) {
				m_sql = String.valueOf("SELECT title FROM pages WHERE page_id=").concat(String.valueOf(AppConstants.ROOT_PAGE));
				CachedRowSet m_rs = m_db.runSQL(m_sql, stmt);
				if (m_rs.next()) {
					p_title = "Total Homepage Hits (" + m_startDateTitle + " to " + m_endDateTitle + ")";
					m_sql = "SELECT count(stats_public_id) as totalValue, stats_date as actualValue FROM stat" + "s_public WHERE stats_date between " + m_startDate + " AND "
							+ m_endDate + " " + "AND page_title = '" + m_rs.getString("title") + "' " + "GROUP BY stats_date " + "ORDER BY stats_date ASC";
				}
				m_rs.close();
			} else if (p_chart.equals("hits_all")) {
				p_title = "Total Site Hits (" + m_startDateTitle + " to " + m_endDateTitle + ")";
				m_sql = "SELECT count(stats_public_id) as totalValue, stats_date as actualValue FROM stat" + "s_public WHERE stats_date between " + m_startDate + " AND "
						+ m_endDate + " " + "GROUP BY stats_date " + "ORDER BY stats_date ASC";
			} else if (p_chart.equals("hits_top10")) {
				p_title = "Top 10 Page Hits (" + m_startDateTitle + " to " + m_endDateTitle + ")";
				m_sql = "SELECT count(stats_public_id) as totalValue, page_title as actualValue FROM stat" + "s_public WHERE stats_date between " + m_startDate + " AND "
						+ m_endDate + " " + "GROUP BY page_title ORDER BY totalValue DESC";
			} else if (p_chart.equals("vistors_top10")) {
				p_title = "Top 10 Visitors (" + m_startDateTitle + " to " + m_endDateTitle + ")";
				m_sql = "SELECT count(stats_public_id) as totalValue, stats_ip as actualValue FROM stats_" + "public WHERE stats_date between " + m_startDate + " AND " + m_endDate
						+ " " + "GROUP BY stats_ip ORDER BY totalValue DESC";
			} else if (p_chart.equals("admin_logins_daily")) {
				p_title = "Daily Administration Logins (" + m_startDateTitle + " to " + m_endDateTitle + ")";
				m_sql = "SELECT count(stats_admin_id) as totalValue, stats_date as actualValue FROM stats" + "_admin WHERE stats_date between " + m_startDate + " AND " + m_endDate
						+ " " + "AND fun_id = " + "-1" + " " + "GROUP BY stats_date " + "ORDER BY stats_date ASC";
			} else if (p_chart.equals("admin_content")) {
				p_title = "Daily Content Authoring (" + m_startDateTitle + " to " + m_endDateTitle + ")";
				m_sql = "SELECT count(stats_admin_id) as totalValue, stats_date as actualValue FROM stats" + "_admin WHERE stats_date between " + m_startDate + " AND " + m_endDate
						+ " " + "AND (fun_id = " + "1" + " " + "OR fun_id = " + "2" + " " + "OR fun_id = " + "3" + " " + "OR fun_id = " + "4" + " " + "OR fun_id = " + "5" + ") "
						+ "GROUP BY stats_date " + "ORDER BY stats_date ASC";
			}
			m_data = "<ImpactArea><Result><Initial>0</Initial>";
			if (!m_sql.equals("")) {
				CachedRowSet m_rs = m_db.runSQL(m_sql, stmt);
				if (p_chart.equals("hits_top10") || p_chart.equals("vistors_top10")) {
					for (int m_testDay = 0; m_rs.next() && m_testDay < 10; m_testDay++) {
						m_count = m_rs.getString("totalValue");
						m_val = m_rs.getString("actualValue");
						m_val = myCommon.ReplaceStrWithStr(m_val, " ", "_");
						m_data = m_data + ("<" + m_val + ">" + m_count + "</" + m_val + ">");
					}

				} else {
					int m_testDay;
					for (m_testDay = 1; m_rs.next(); m_testDay++) {
						m_count = m_rs.getString("totalValue");
						m_hitDate = m_rs.getDate("actualValue");
						m_cal.setTime(m_hitDate);
						int m_hitDay = m_cal.get(5);
						int m_hitMonth = m_cal.get(2) + 1;
						if (m_hitDay != m_testDay) {
							for (; m_testDay < m_hitDay; m_testDay++) {
								m_val = "";
								if (m_testDay < 10) {
									m_val = "0" + m_testDay;
								} else {
									m_val = m_testDay + "";
								}
								m_data = m_data + ("<" + m_val + ">0</" + m_val + ">");
							}

						}
						m_val = "";
						if (m_hitDay < 10) {
							m_val = "0" + m_hitDay;
						} else {
							m_val = m_hitDay + "";
						}
						m_data = m_data + ("<" + m_val + ">" + m_count + "</" + m_val + ">");
					}

					if (m_testDay != m_testEnd) {
						for (; m_testDay < m_testEnd + 1; m_testDay++) {
							m_val = "";
							if (m_testDay < 10) {
								m_val = "0" + m_testDay;
							} else {
								m_val = m_testDay + "";
							}
							m_data = m_data + ("<" + m_val + ">0</" + m_val + ">");
						}

					}
				}
				m_rs.close();
			}
			stmt.close();
			m_data = m_data + "</Result></ImpactArea>";
		} catch (Exception e) {
			System.out.println("Trying to retrieve statistics data.");
		}
		return m_data;
	}
}

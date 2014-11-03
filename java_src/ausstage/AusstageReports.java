/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Ausstage

   File: AusstageReports.java

Purpose: Provide the bean class that 
         handles sql execution and 
         report generations

 **************************************************/
package ausstage;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;

import sun.jdbc.rowset.CachedRowSet;
import admin.AppConstants;
import admin.FileTools;

public class AusstageReports {
	private CachedRowSet crs;
	private Statement stmt;
	private ResultSet rs;
	private int columncount;
	private static final int max_limit_for_sqlInterface_output = 1000; // used to set the number rows returned to sql interface (for select query only).
	private ausstage.Database m_db;
	private StringBuffer m_commaDelimStrBuff = null;
	private HttpServletRequest m_request = null;
	private String m_commaDelimFileUrl = "";
	private String m_file_name = "";
	private String m_report_file_name = "";
	private String m_file_size = "";
	private String m_error_message = "";
	private ResultSetMetaData rsmd;
	private boolean isReachedMaxNumberOfRowsAllowed = false;

	public AusstageReports(ausstage.Database p_db, HttpServletRequest p_request, String p_report_file_name) {
		try {
			if (!p_report_file_name.equals("") && p_report_file_name.indexOf(".") != -1) {
				m_db = p_db;
				m_request = p_request;
				m_report_file_name = p_report_file_name;
			} else {
				throw (new Exception("Can not construct object AusstageReports\ndue to invalid report file name."));
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AusstageReports constructor");
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			m_error_message = e.toString();
		}
	}

	public boolean ExecuteQuery(JspWriter p_out, String p_sqlString) {
		boolean ret = true;
		try {
			stmt = m_db.m_conn.createStatement();

			if (p_sqlString.toLowerCase().startsWith("select")) {
				rs = stmt.executeQuery(p_sqlString);
				rsmd = rs.getMetaData();
				columncount = rsmd.getColumnCount();
				crs = new CachedRowSet();
				crs.populate(rs);
				String table = createHTMLTable();
				try {
					p_out.println(table);
				} catch (IOException ioe) {
					throw (ioe);
				}
				crs.close();
			} else if (p_sqlString.toLowerCase().startsWith("insert") || p_sqlString.toLowerCase().startsWith("update") || p_sqlString.toLowerCase().startsWith("delete")) {
				stmt.executeUpdate(p_sqlString);
			}
		} catch (SQLException se) {
			se.printStackTrace();
			m_error_message = se.toString();
			ret = false;
		} catch (IOException ioe) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AusstageReports.ExecuteQuery(...)");
			System.out.println("MESSAGE: " + ioe.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + ioe.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + ioe.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			m_error_message = ioe.toString();
			ret = false;
		} finally {
			try {
				if (rs != null) rs.close();
				if (stmt != null) stmt.close();
			} catch (SQLException se) {
				se.printStackTrace();
				ret = false;
			}
		}
		return (ret);
	}

	public boolean ExecuteQuery() {
		boolean ret = true;
		String sqlString = "select table_name from information_schema.tables where not table_name like '%$%'";

		try {
			stmt = m_db.m_conn.createStatement();
			Statement table_stmt = m_db.m_conn.createStatement();
			rs = stmt.executeQuery(sqlString);
			rsmd = rs.getMetaData();
			columncount = rsmd.getColumnCount();
			crs = new CachedRowSet();
			crs.populate(rs);

			if (crs.next()) {

				CachedRowSet table_crs = null;
				m_commaDelimStrBuff = new StringBuffer("");

				// lets set the headers
				m_commaDelimStrBuff.append("TABLE NAME,RECORD COUNT");

				// now lets get the table name & row count
				do {
					String table_sql = "", table_name = "", record_count = "0";

					// get the table name
					table_name = crs.getString("table_name");

					// build the comma delimited buffer object
					m_commaDelimStrBuff.append("\n" + table_name);

					// do a select sql using the current table name
					// table_sql = "select * from " + table_name;

					// do a select sql using the current table name - JUST ADDED
					table_sql = "select count(*) as counter from " + table_name;

					// run the sql & get the result from the current table
					try {
						table_crs = m_db.runSQL(table_sql, table_stmt);
					} catch (Exception e) {
						ret = false;
						throw (e);
					}

					// if result not null get record count of the current table
					if (table_crs.next()) {
						// table_crs.last();
						// record_count = Integer.toString(table_crs.getRow());
						record_count = table_crs.getString("counter");
					}

					// add the table record count to the comma delimited buffer
					// object
					m_commaDelimStrBuff.append("," + record_count);

				} while (crs.next());
				table_stmt.close();
				table_crs.close();

				// write out the comma delimited file
				writeCommaDelimFile();
			}
			crs.close();

		} catch (SQLException se) {
			se.printStackTrace();
			m_error_message = se.toString();
			ret = false;
		} catch (IOException ioe) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AusstageReports.ExecuteQuery()");
			System.out.println("MESSAGE: " + ioe.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + ioe.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + ioe.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			m_error_message = ioe.toString();
			ret = false;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AusstageReports.ExecuteQuery() - 'table_crs = m_db.runSQL(table_sql, table_stmt)' statement");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			m_error_message = e.toString();
			ret = false;

		} finally {
			try {
				if (rs != null) rs.close();
				if (stmt != null) stmt.close();
			} catch (SQLException se) {
				se.printStackTrace();
				ret = false;
			}
		}
		return (ret);
	}

	private String createHTMLTable() {
		StringBuffer sbuff = new StringBuffer("");
		String data = "";
		String header_name = "";
		sbuff.append("<TABLE border=\"1\">");
		try {
			if (crs.next()) {
				m_commaDelimStrBuff = new StringBuffer("");

				// lets deal with the html column header
				sbuff.append("<TR>");

				for (int i = 1; i <= columncount; i++) {
					header_name = rsmd.getColumnName(i).toString();
					// build the html column display name
					sbuff.append("<TD class='bodytext'><b>" + header_name + "</b></TD>");

					// build the comma delimited column name text
					if (m_commaDelimStrBuff.toString().equals(""))
						m_commaDelimStrBuff.append(header_name);
					else
						m_commaDelimStrBuff.append("," + header_name);
				}

				sbuff.append("</TR>");

				int counter = 0;

				// now do the column data
				do {

					if (counter == max_limit_for_sqlInterface_output) {
						isReachedMaxNumberOfRowsAllowed = true;
						break;
					}

					sbuff.append("<TR>");
					m_commaDelimStrBuff.append("\n");

					for (int i = 1; i <= columncount; i++) {
						data = crs.getString(i);
						if (data == null) data = "";

						// build the html column display data
						if (data.equals("")) data = "&nbsp;";
						sbuff.append("<TD class='bodytext'>" + data + "</TD>");

						// build the comma delimited column data text
						if (data.equals("&nbsp;")) data = "";
						m_commaDelimStrBuff.append(data);

						if (i < columncount) m_commaDelimStrBuff.append(",");
					}

					sbuff.append("</TR>");

					counter++;

				} while (crs.next());
			}

			// lets write out the comma delimited file
			writeCommaDelimFile();
		} catch (SQLException se) {
			se.printStackTrace();
			m_error_message = se.toString();
		}
		sbuff.append("</TABLE>");
		return new String(sbuff);
	}

	private void writeCommaDelimFile() {
		FileTools filetools;
		try {
			if (m_commaDelimStrBuff != null && m_commaDelimStrBuff.length() > 0) {
				// set up the file
				filetools = new FileTools();

				if (m_report_file_name.equals(""))
					m_commaDelimFileUrl = AppConstants.REPORTS_FILE_PATH + "/ausstage_reports.csv";
				else
					m_commaDelimFileUrl = AppConstants.REPORTS_FILE_PATH + "/" + m_report_file_name;

				m_commaDelimFileUrl = filetools.getAbsoluteFilePath(m_request, "/" + m_commaDelimFileUrl);

				// write the file
				FileOutputStream fileOutputStream = new FileOutputStream(m_commaDelimFileUrl);
				fileOutputStream.write(m_commaDelimStrBuff.toString().getBytes());
				fileOutputStream.close();

				// get the file metadata
				File file = new File(m_commaDelimFileUrl);
				m_file_size = Long.toString(file.length() / 1024);
				m_commaDelimFileUrl = file.getPath();
				m_file_name = file.getName();

			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in AusstageReports.writeCommaDelimFile()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public String getCommaDelimFileUrl() {
		return (m_commaDelimFileUrl);
	}

	public String getErrorMessage() {
		// lets trim it so that Exception & DB are not displayed
		// get rid of 'java.sql.SQLException: ORA-00904:' leading tring
		if (m_error_message.indexOf(":") != -1)
			m_error_message = m_error_message.substring(m_error_message.lastIndexOf(":", m_error_message.length()) + 1, m_error_message.length());

		return ("<b>Your SQL statement did not execute due to the following error:</b><br><br>" + m_error_message);
	}

	public String getCommaDelimFileName() {
		return (m_file_name);
	}

	public String getCommaDelimFileSize() {
		if (m_file_size != null && !m_file_size.equals("")) {
			if (Integer.parseInt(m_file_size) < 1) m_file_size = "1";
		} else {
			m_file_size = "0";
		}
		return (m_file_size);
	}

	public boolean isReachedMaxRowAllowed() {
		return (isReachedMaxNumberOfRowsAllowed);
	}
}

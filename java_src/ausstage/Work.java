package ausstage;

import admin.AppConstants;
import admin.Common;
import java.io.PrintStream;
import java.sql.*;
import java.util.Date;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import sun.jdbc.rowset.CachedRowSet;

// Referenced classes of package ausstage:
//            Database, WorkContribLink, WorkOrganLink, WorkWorkLink, 
//            Contributor, Organisation

public class Work {

	private Database m_db;
	private AppConstants AppConstants;
	private Common Common;
	private final int INSERT = 0;
	private final int DELETE = 1;
	private final int UPDATE = 2;
	private boolean m_is_in_copy_mode;
	private String m_workid;
	private String m_work_title;
	private String m_alter_work_title;
	private String m_error_string;
	private Vector m_work_orglinks;
	private Vector m_work_conlinks;
	private Vector<WorkWorkLink> m_work_worklinks;
	private String m_entered_by_user;
	private Date m_entered_date;
	private String m_updated_by_user;
	private Date m_updated_date;

	public Work(Database m_db2) {
		AppConstants = new AppConstants();
		Common = new Common();
		m_db = m_db2;
		initialise();
	}

	public void initialise() {
		m_is_in_copy_mode = false;
		m_workid = "0";
		m_work_title = "";
		m_alter_work_title = "";
		m_work_orglinks = new Vector();
		m_work_conlinks = new Vector();
		m_work_worklinks = new Vector<WorkWorkLink>();
		m_entered_by_user = "";
		m_updated_by_user = "";
	}

	public void load(int p_work_id) {
		load((new StringBuilder(String.valueOf(p_work_id))).toString());
	}

	public void load(String p_id) {
		String sqlString = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = (new StringBuilder("SELECT * FROM work WHERE workid = '")).append(p_id).append("'").toString();
			ResultSet l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				m_workid = l_rs.getString("workid");
				m_work_title = l_rs.getString("work_title");
				m_alter_work_title = l_rs.getString("alter_work_title");
				m_entered_by_user = l_rs.getString("entered_by_user");
				m_entered_date = l_rs.getDate("entered_date");
				m_updated_by_user = l_rs.getString("modified_by_user");
				m_updated_date = l_rs.getDate("modified_date");
				if (m_workid == null) {
					m_workid = "";
				}
				if (m_work_title == null) {
					m_work_title = "";
				}
				if (m_alter_work_title == null) {
					m_alter_work_title = "";
				}
				if (m_entered_by_user == null) {
					m_entered_by_user = "";
				}
				if (m_entered_date == null) {
					m_entered_date = new Date();
				}
				if (m_updated_date == null) {
					m_updated_date = new Date();
				}
				if (m_updated_by_user == null) {
					m_updated_by_user = "";
				}
				loadLinkedOrganisations();
				loadLinkedContributors();
				loadLinkedWorks();
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occurred in work - load().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(sqlString).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public String getWorkId() {
		return m_workid;
	}

	public String getWorkTitle() {
		return m_work_title;
	}

	public String getAlterWorkTitle() {
		return m_alter_work_title;
	}

	public void setErrorMessage(String p_error_message) {
		m_error_string = p_error_message;
	}

	public String getEnteredByUser() {
		return m_entered_by_user;
	}

	public Date getEnteredDate() {
		return m_entered_date;
	}

	public Date getUpdatedDate() {
		return m_updated_date;
	}

	public String getUpdatedByUser() {
		return m_updated_by_user;
	}

	public Vector getAssociatedOrganisations() {
		return m_work_orglinks;
	}

	public Vector getAssociatedOrgs() {
		return m_work_orglinks;
	}

	public Vector getAssociatedContributors() {
		return m_work_conlinks;
	}

	public Vector<Work> getAssociatedWorks() {
		return getWorks();
	}

	public String getErrorMessage() {
		return m_error_string;
	}

	public Vector<Work> getWorks() {
		Vector<Work> works = new Vector<Work>();
		for (WorkWorkLink wwl : m_work_worklinks) {
			Work work = new Work(m_db);
			work.load(Integer.parseInt(wwl.getChildId()));
			works.add(work);
		}
		return works;
	}

	public Vector<WorkWorkLink> getWorkWorkLinks() {
		return m_work_worklinks;
	}

	public boolean addWork() {
		String l_sql = "";
		boolean l_ret = false;
		String l_work_id = "";
		try {
			int conCount = 0;
			String cons = "";
			for (WorkContribLink wcl : (Vector<WorkContribLink>) m_work_conlinks) {
				conCount ++;
				cons += ", " + wcl.getContribId();
			}
			
			int orgCount = 0;
			String orgs = "";
			for (WorkOrganLink wol : (Vector<WorkOrganLink>) m_work_orglinks) {
				orgCount ++;
				orgs += ", " + wol.getOrganId();
			}
			
			// Check for another work with the same title, contributors and organisations
			Statement stmt = m_db.m_conn.createStatement();
			l_sql = "SELECT workid FROM work WHERE work_title = '" + m_db.plSqlSafeString(m_work_title) + "'" +
					" and (select count(*) from workconlink where workid = work.workid and contributorid in (0" + cons + ")) = " + conCount + 
					" and (select count(*) from workconlink where workid = work.workid and contributorid not in (0" + cons + ")) = 0" +
					" and (select count(*) from workorglink where workid = work.workid and organisationid in (0" + orgs + ")) = " + orgCount +
					" and (select count(*) from workorglink where workid = work.workid and organisationid not in (0" + orgs + ")) = 0"; 
			System.out.println("Work check SQL: " + l_sql);
			
			m_workid = m_db.getInsertedIndexValue(stmt, "workid_seq");
			ResultSet l_rs = m_db.runSQLResultSet(l_sql, stmt);
			if (!l_rs.next()) {
				l_sql = "INSERT INTO work (WORK_TITLE, ALTER_WORK_TITLE, entered_by_user, entered_date) VALUES ('"+
						m_db.plSqlSafeString(m_work_title) + "', '" +
						m_db.plSqlSafeString(m_alter_work_title) + "', '" +
						m_db.plSqlSafeString(m_entered_by_user) + "', NOW())";
				m_db.runSQLResultSet(l_sql, stmt);
				l_sql = "SELECT workid FROM work WHERE work_title='" + m_db.plSqlSafeString(m_work_title) + "' ORDER BY workid DESC";
				l_rs = m_db.runSQLResultSet(l_sql, stmt);
				if (l_rs.next()) {
					l_work_id = l_rs.getString("workid");
				}
				if (!l_work_id.equals("")) {
					m_workid = l_work_id;
					for (int i = 0; i < m_work_conlinks.size(); i++) {
						WorkContribLink workContribLink = (WorkContribLink) m_work_conlinks.elementAt(i);
						l_sql = (new StringBuilder("INSERT INTO workconlink (WORKID, CONTRIBUTORID, ORDER_BY) VALUES (")).append(l_work_id).append(",")
								.append(workContribLink.getContribId()).append(",").append(workContribLink.getOrderBy()).append(")").toString();
						m_db.runSQLResultSet(l_sql, stmt);
					}

					modifyWorkWorkLinks(0);
					for (int i = 0; i < m_work_orglinks.size(); i++) {
						WorkOrganLink workOrganLink = (WorkOrganLink) m_work_orglinks.elementAt(i);
						l_sql = (new StringBuilder("INSERT INTO workorglink (WORKID, ORGANISATIONID, ORDER_BY) VALUES (")).append(l_work_id).append(",")
								.append(workOrganLink.getOrganId()).append(",").append(workOrganLink.getOrderBy()).append(")").toString();
						m_db.runSQLResultSet(l_sql, stmt);
					}

				}
				l_ret = true;
			} else {
				setErrorMessage("Unable to add the Work. A work with this work title, contributors and organisations already exists");
				l_ret = false;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Work.addWork().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			setErrorMessage("Unable to add the Work. Please ensure all mandatory fields (*) are filled in.");
			l_ret = false;
		}
		return l_ret;
	}

	public boolean updateWork() {
		String l_sql = "";
		boolean l_ret = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();

			int conCount = 0;
			String cons = "";
			for (WorkContribLink wcl : (Vector<WorkContribLink>) m_work_conlinks) {
				conCount ++;
				cons += ", " + wcl.getContribId();
			}
			
			int orgCount = 0;
			String orgs = "";
			for (WorkOrganLink wol : (Vector<WorkOrganLink>) m_work_orglinks) {
				orgCount ++;
				orgs += ", " + wol.getOrganId();
			}
			
			// Check for another work with the same title, contributors and organisations
			l_sql = "SELECT workid FROM work WHERE work_title = '" + m_db.plSqlSafeString(m_work_title) + "'" +
					" and workid != " + m_workid +
					" and (select count(*) from workconlink where workid = work.workid and contributorid in (0" + cons + ")) = " + conCount + 
					" and (select count(*) from workconlink where workid = work.workid and contributorid not in (0" + cons + ")) = 0" +
					" and (select count(*) from workorglink where workid = work.workid and organisationid in (0" + orgs + ")) = " + orgCount +
					" and (select count(*) from workorglink where workid = work.workid and organisationid not in (0" + orgs + ")) = 0"; 
			System.out.println("Work check (update) SQL: " + l_sql);
			
			ResultSet l_rs = m_db.runSQLResultSet(l_sql, stmt);
			if (!l_rs.next()) {
				if (m_work_title.length() > 150) {
					m_work_title = m_work_title.substring(0, 149);
				}
				if (m_alter_work_title.length() > 300) {
					m_alter_work_title = m_alter_work_title.substring(0, 299);
				}
				l_sql = "UPDATE work SET ";
				l_sql = (new StringBuilder(String.valueOf(l_sql))).append(" MODIFIED_BY_USER = '").append(m_db.plSqlSafeString(m_updated_by_user)).append("'").toString();
				l_sql = (new StringBuilder(String.valueOf(l_sql))).append(", MODIFIED_DATE =  now()  ").toString();
				if (m_work_title != null && !m_work_title.equals("")) {
					l_sql = (new StringBuilder(String.valueOf(l_sql))).append(", WORK_TITLE='").append(m_db.plSqlSafeString(m_work_title)).append("'").toString();
				}
				if (m_alter_work_title != null && !m_alter_work_title.equals("")) {
					l_sql = (new StringBuilder(String.valueOf(l_sql))).append(", ALTER_WORK_TITLE='").append(m_db.plSqlSafeString(m_alter_work_title)).append("' ").toString();
				}
				if (m_workid != null) {
					l_sql = (new StringBuilder(String.valueOf(l_sql))).append("WHERE WORKID=").append(m_workid).append(" ").toString();
				}
				m_db.runSQLResultSet(l_sql, stmt);
				modifyWorkWorkLinks(2);
				l_sql = (new StringBuilder("DELETE FROM workconlink WHERE workid=")).append(m_workid).toString();
				m_db.runSQLResultSet(l_sql, stmt);
				for (int i = 0; i < m_work_conlinks.size(); i++) {
					WorkContribLink workContribLink = (WorkContribLink) m_work_conlinks.elementAt(i);
					l_sql = (new StringBuilder("INSERT INTO workconlink (WORKID, CONTRIBUTORID, ORDER_BY) VALUES (")).append(m_workid).append(",")
							.append(workContribLink.getContribId()).append(",").append(workContribLink.getOrderBy()).append(")").toString();
					m_db.runSQLResultSet(l_sql, stmt);
				}

				l_sql = (new StringBuilder("DELETE FROM workorglink WHERE workid=")).append(m_workid).toString();
				m_db.runSQLResultSet(l_sql, stmt);
				for (int i = 0; i < m_work_orglinks.size(); i++) {
					WorkOrganLink workOrganLink = (WorkOrganLink) m_work_orglinks.elementAt(i);
					l_sql = (new StringBuilder("INSERT INTO workorglink (WORKID, ORGANISATIONID, ORDER_BY) VALUES (")).append(m_workid).append(",")
							.append(workOrganLink.getOrganId()).append(",").append(workOrganLink.getOrderBy()).append(")").toString();
					m_db.runSQLResultSet(l_sql, stmt);
				}

			}
			l_ret = true;
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in updateWork().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			l_ret = false;
			setErrorMessage("Unable to update the Work.");
		}
		return l_ret;
	}

	public boolean deleteWork() {
		String l_sql = "";
		boolean l_ret = false;
		try {
			if (!isInUse()) {
				Statement stmt = m_db.m_conn.createStatement();
				l_sql = (new StringBuilder("DELETE FROM workconlink WHERE workid=")).append(m_workid).toString();
				m_db.runSQLResultSet(l_sql, stmt);
				l_sql = (new StringBuilder("DELETE FROM workorglink WHERE workid=")).append(m_workid).toString();
				m_db.runSQLResultSet(l_sql, stmt);
				modifyWorkWorkLinks(1);
				l_sql = (new StringBuilder("DELETE FROM work WHERE workid=")).append(m_workid).toString();
				m_db.runSQLResultSet(l_sql, stmt);
				stmt.close();
				l_ret = true;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteWork().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			l_ret = false;
		}
		return l_ret;
	}

	public boolean isInUse() {
		boolean ret = false;
		String sqlString = "";
		int counter = 0;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = (new StringBuilder("select sum(c.counter) counter from ( select count(*) as counter from itemworklin" + "k where workid=")).append(m_workid).toString();
			sqlString = (new StringBuilder(String.valueOf(sqlString))).append(" UNION ALL select count(*) as counter from eventworklink where workid=").append(m_workid)
					.append(") c").toString();
			CachedRowSet l_rs = m_db.runSQL(sqlString, stmt);
			l_rs.next();
			counter = l_rs.getInt("counter");
			if (counter >= 1) {
				ret = true;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in Work.isInUse().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(sqlString).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return ret;
	}

	private void modifyWorkWorkLinks(int modifyType) {
		try {
			WorkWorkLink temp_object = new WorkWorkLink(m_db);
			switch (modifyType) {
			case 2: // '\002'
				temp_object.update(m_workid, m_work_worklinks);
				break;

			case 1: // '\001'
				temp_object.deleteWorkWorkLinksForWork(m_workid);
				break;

			case 0: // '\0'
				temp_object.add(m_workid, m_work_worklinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyEventEventLinks().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private void loadLinkedOrganisations() {
		ResultSet l_rs = null;
		String l_sql = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_sql = (new StringBuilder("SELECT DISTINCT organisation.organisationid, WORKORGLINKID, workorglink.ORDER_BY"
					+ " FROM organisation, workorglink, work WHERE work.workid = workorglink.workid AND"
					+ " workorglink.organisationid = organisation.organisationid AND work.workid=")).append(m_workid).append(" ").append("ORDER BY WORKORGLINK.ORDER_BY ")
					.toString();
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			m_work_orglinks.removeAllElements();
			WorkOrganLink workOrganLink;
			for (; l_rs.next(); m_work_orglinks.addElement(workOrganLink)) {
				workOrganLink = new WorkOrganLink(m_db);
				workOrganLink.load(l_rs.getString("WORKORGLINKID"));
			}

			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedOrganisations().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public ResultSet getAssociatedEvents(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;
		try {
			l_sql = (new StringBuilder("SELECT Distinct  work.workid,work.work_title, work.alter_work_title,contributor."
					+ "last_name, contributor.first_name,contributor.contributorid, concat_ws(' ',contr"
					+ "ibutor.first_name ,contributor.last_name)  creator  FROM work LEFT OUTER JOIN wo"
					+ "rkconlink ON (work.workid = workconlink.workid) JOIN contributor ON ("
					+ "workconlink.contributorid = contributor.contributorid) LEFT OUTER JOIN conevlink"
					+ " ON (contributor.contributorid = conevlink.contributorid) WHERE  work.workid=")).append(p_id).append(" ").toString();
			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Works.getAssociatedEvents().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_rs;
	}

	public ResultSet getAssociatedOrganisations(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;
		try {
			l_sql = (new StringBuilder("SELECT distinct work.work_title title,`organisation`.`name` name,work.workid, or"
					+ "ganisation.organisationid organisationid FROM `workorglink` Left  Join work ON"
					+ " (`workorglink`.`workid` = work.`workid`) Left  Join `organisation` ON (`workorgl"
					+ "ink`.`organisationid`= `organisation`.`organisationid`) WHERE  work.workid=")).append(p_id).append(" ").toString();
			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Works.getAssociatedEvents().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_rs;
	}

	public ResultSet getAssociatedEv(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;
		try {
			l_sql = (new StringBuilder("SELECT work.workid, events.eventid, events.event_name,work.work_title,concat_ws("
					+ "', ',venue.venue_name, venue.suburb,states.state) as Output,  date_format(STR_TO"
					+ "_DATE(CONCAT(events.ddfirst_date,' ',events.mmfirst_date,' ',events.yyyyfirst_da"
					+ "te), '%d %m %Y'), '%e %M %Y'), events.ddfirst_date, events.mmfirst_date, events."
					+ "yyyyfirst_date,events.FIRST_DATE, STR_TO_DATE(CONCAT_WS(' ', events.ddfirst_date"
					+ ", events.mmfirst_date, events.yyyyfirst_date), '%d %m %Y') as datesort FROM work"
					+ " INNER JOIN eventworklink ON (work.workid = eventworklink.workid) INNER JOIN eve"
					+ "nts ON (eventworklink.eventid = events.eventid) INNER JOIN venue ON (events.venu"
					+ "eid = venue.venueid)  INNER JOIN states ON (venue.state = states.stateid) WHERE " + "work.workid=")).append(p_id).append(" order by events.FIRST_DATE DESC")
					.toString();
			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Works.getAssociatedEv().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_rs;
	}

	public ResultSet getAssociatedItems(int p_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;
		try {
			l_sql = (new StringBuilder("SELECT DISTINCT item.ITEMID,item.citation,work.WORKID, lookup_codes.description FROM item "
					+ " LEFT JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id) "
					+ " INNER JOIN itemworklink ON (item.ITEMID = itemworklink.ITEMID)  INNER JOIN work ON (itemworklink" + ".WORKID = work.WORKID) WHERE  work.workid=")).append(p_id)
					.append(" order by lookup_codes.description, item.citation").toString();
			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Works.getAssociatedItems().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return l_rs;
	}

	public void setDb(Database p_db) {
		m_db = p_db;
	}

	public void setId(String p_id) {
		p_id = m_workid;
	}

	public void setName(String p_name) {
		m_work_title = p_name;
	}

	public void setOtherNames1(String p_name) {
		m_alter_work_title = p_name;
	}

	public String getId() {
		return m_workid;
	}

	public String getName() {
		return m_work_title;
	}

	public String getOtherNames1() {
		return m_alter_work_title;
	}

	public String getError() {
		return m_error_string;
	}

	private void loadLinkedContributors() {
		ResultSet l_rs = null;
		String l_sql = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_sql = (new StringBuilder("SELECT DISTINCT WORKCONLINKID, workconlink.ORDER_BY FROM contributor, workconlin"
					+ "k, work WHERE work.workid = workconlink.workid AND workconlink.contributorid = c" + "ontributor.contributorid AND work.workid=")).append(m_workid)
					.append(" ").append("ORDER BY workconlink.ORDER_BY ").toString();
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			m_work_conlinks.removeAllElements();
			WorkContribLink workContribLink;
			for (; l_rs.next(); m_work_conlinks.addElement(workContribLink)) {
				workContribLink = new WorkContribLink(m_db);
				workContribLink.load(l_rs.getString("WORKCONLINKID"));
			}

			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedContributors().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private void loadLinkedWorks() {
		ResultSet l_rs = null;
		String l_sql = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			l_sql = "SELECT DISTINCT workworklinkid FROM workworklink WHERE workworklink.workid = " + m_workid;
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			m_work_worklinks.removeAllElements();
			while (l_rs.next()) {
				WorkWorkLink wwl = new WorkWorkLink(m_db);
				wwl.load(l_rs.getString("WORKWORKLINKID"));
				m_work_worklinks.addElement(wwl);
			}
			
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedWorks().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println((new StringBuilder("sqlString: ")).append(l_sql).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public Vector generateDisplayInfo(Vector p_ids, String p_id_type, Statement p_stmt) {
		Vector l_display_info = new Vector();
		String l_info_to_add = "";
		for (int i = 0; i < p_ids.size(); i++) {
			if (p_id_type.equals("contributor")) {
				Contributor contributor = new Contributor(m_db);
				WorkContribLink workContribLink = (WorkContribLink) m_work_conlinks.elementAt(i);
				l_info_to_add = contributor.getContributorInfoForItemDisplay(Integer.parseInt(workContribLink.getContribId()), p_stmt);
				l_display_info.add(l_info_to_add);
			}
			if (p_id_type.equals("work")) {
				Work childWork = new Work(m_db);
				int childWorkId = Integer.parseInt(((WorkWorkLink) m_work_worklinks.elementAt(i)).getChildId());
				l_info_to_add = childWork.getWorkInfoForWorkDisplay(childWorkId, p_stmt);
				l_display_info.add(l_info_to_add);
			}
			if (p_id_type.equals("organisation")) {
				Organisation organisation = new Organisation(m_db);
				WorkOrganLink workOrganLink = (WorkOrganLink) m_work_orglinks.elementAt(i);
				l_info_to_add = organisation.getOrganisationInfoForOrganisationDisplay(Integer.parseInt(workOrganLink.getOrganId()), p_stmt);
				l_display_info.add(l_info_to_add);
			}
		}

		return l_display_info;
	}
	
	public Vector generateBasicDisplayInfo(Vector p_ids, String p_id_type, Statement p_stmt) {
		Vector l_display_info = new Vector();
		String l_info_to_add = "";
		for (int i = 0; i < p_ids.size(); i++) {
			if (p_id_type.equals("contributor")) {
				Contributor contributor = new Contributor(m_db);
				WorkContribLink workContribLink = (WorkContribLink) m_work_conlinks.elementAt(i);
				l_info_to_add = contributor.getBasicContributorInfoForItemDisplay(Integer.parseInt(workContribLink.getContribId()), p_stmt);
				l_display_info.add(l_info_to_add);
			}
			if (p_id_type.equals("work")) {
				Work childWork = new Work(m_db);
				int childWorkId = Integer.parseInt(((WorkWorkLink) m_work_worklinks.elementAt(i)).getChildId());
				l_info_to_add = childWork.getWorkInfoForWorkDisplay(childWorkId, p_stmt);
				l_display_info.add(l_info_to_add);
			}
			if (p_id_type.equals("organisation")) {
				Organisation organisation = new Organisation(m_db);
				WorkOrganLink workOrganLink = (WorkOrganLink) m_work_orglinks.elementAt(i);
				l_info_to_add = organisation.getOrganisationInfoForOrganisationDisplay(Integer.parseInt(workOrganLink.getOrganId()), p_stmt);
				l_display_info.add(l_info_to_add);
			}
		}

		return l_display_info;
	}

	public void setWorkOrgLinks(Vector p_work_orglinks) {
		m_work_orglinks = p_work_orglinks;
	}

	public void setWorkConLinks(Vector p_work_conlinks) {
		m_work_conlinks = p_work_conlinks;
	}

	public void setDatabaseConnection(Database ad) {
		m_db = ad;
	}

	public void setWorkTitle(String p_work_title) {
		m_work_title = p_work_title;
	}

	public void setAlterWorkTitle(String p_alter_work_title) {
		m_alter_work_title = p_alter_work_title;
	}

	public void setEnteredByUser(String p_user_name) {
		m_entered_by_user = p_user_name;
	}

	public void setUpdatedByUser(String p_user_name) {
		m_updated_by_user = p_user_name;
	}

	public void setWorkWorkLinks(Vector<WorkWorkLink> p_work_worklinks) {
		m_work_worklinks = p_work_worklinks;
	}

	public void setWorkAttributes(HttpServletRequest request) {
		m_workid = request.getParameter("f_workid");
		if (m_workid == null) {
			m_workid = "0";
		}
		m_work_title = request.getParameter("f_work_title");
		if (m_work_title == null) {
			m_work_title = "";
		}
		m_alter_work_title = request.getParameter("f_alter_work_title");
		if (m_alter_work_title == null) {
			m_alter_work_title = "";
		}
		if (request.getParameter("action") != null && !request.getParameter("action").equals("") && request.getParameter("action").equals("copy")) {
			m_is_in_copy_mode = true;
		}
	}

	public String getWorkInfoForWorkDisplay(int p_work_id, Statement p_stmt) {
		String sqlString = "";
		String retStr = "";
		ResultSet l_rs = null;
		try {
			sqlString = (new StringBuilder("SELECT work.work_title display_info FROM work WHERE workid = ")).append(p_work_id).toString();
			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);
			if (l_rs.next()) {
				retStr = l_rs.getString("display_info");
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Work.getWorkInfoForWorkDisplay().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}

	public String getWorkInfoForDisplay(int p_work_id, Statement p_stmt) {
		String sqlString = "";
		String retStr = "";
		ResultSet l_rs = null;
		try {
			sqlString = (new StringBuilder("SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_na"
					+ "me, contributor.last_name) separator ', ') contribname FROM work  LEFT JOIN work"
					+ "conlink ON work.workid = workconlink.workid LEFT JOIN contributor ON workconlink" + ".contributorid = contributor.contributorid WHERE work.workid =  "))
					.append(p_work_id).toString();
			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);
			if (l_rs.next()) {
				retStr = l_rs.getString("work_title");
			}
			if (l_rs.getString("contribname") != null && !l_rs.getString("contribname").equals("")) {
				retStr = (new StringBuilder(String.valueOf(retStr))).append(", ").toString();
				retStr = (new StringBuilder(String.valueOf(retStr))).append(l_rs.getString("contribname")).toString();
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Work.getWorkInfoForDisplay().");
			System.out.println((new StringBuilder("MESSAGE: ")).append(e.getMessage()).toString());
			System.out.println((new StringBuilder("LOCALIZED MESSAGE: ")).append(e.getLocalizedMessage()).toString());
			System.out.println((new StringBuilder("CLASS.TOSTRING: ")).append(e.toString()).toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return retStr;
	}
}

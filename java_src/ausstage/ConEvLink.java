/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: ConEvLink.java

Purpose: Provides ConEvLink object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.ResultSet;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import ausstage.ContributorFunction;

//import javax.sql.rowset.CachedRowSet;

import sun.jdbc.rowset.CachedRowSet;

public class ConEvLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String eventId;
	private String contributorId;
	private String function;
	private String functionDesc;
	// private String functionDescid;
	private String notes;
	private ContributorFunction contFunctBean;
	private Contributor contributorBean;
	private String m_error_string;

	/*
	 * Name: ConEvLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public ConEvLink(ausstage.Database p_db) {
		m_db = p_db;
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
		eventId = "0";
		contributorId = "0";
		function = "0";
		functionDesc = "";
		// functionDescid = "";
		notes = "";
		contFunctBean = null;
		contributorBean = null;
		m_error_string = "";
	}
	
	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the ConEvLink information for the
	 * specified ConEvLink id.
	 * 
	 * Parameters: p_id : id of the Contributor record e_id : id of the Event
	 * record Note: There is no unique key for this table.
	 * 
	 * Returns: None
	 */
	public void load(String p_id, String e_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		contributorId = m_db.plSqlSafeString(p_id);
		eventId = m_db.plSqlSafeString(e_id);
		contributorBean = new Contributor(m_db);
		contributorBean.load(Integer.parseInt(contributorId));
		contFunctBean = new ContributorFunction(m_db);

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT ConEvLink.*, ContributorFunctPreferred.*" + 
						" FROM ConEvLink" + 
						" INNER JOIN contributor ON (ConEvLink.CONTRIBUTORID = contributor.CONTRIBUTORID)" +
						" LEFT JOIN contributorfunctpreferred ON (ConEvLink.`function` = contributorfunctpreferred.contributorfunctpreferredid)" +
						" WHERE contributor.contributorId = " + p_id + " " +
						" AND   ConEvLink.eventId       = " + e_id + " " +
						" ORDER BY ContributorFunctPreferred.PREFERREDTERM,contributor.LAST_NAME,contributor.FIRST_NAME";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				function = l_rs.getString("function");
				functionDesc = l_rs.getString("PreferredTerm");
				// functionDescid = l_rs.getString("ContributorFunctPreferred");
				notes = l_rs.getString("notes");
				contFunctBean.load(Integer.parseInt(function));

				if (notes == null) notes = "";
				if (functionDesc == null) functionDesc = "";
				// if (functionDescid == null) functionDescid = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ConEvLink: load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void refresh(ausstage.Database p_db){
		contributorBean = new Contributor(p_db);
		contributorBean.load(Integer.parseInt(contributorId));
		
	}
	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: eventId String array of ConEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String eventId, Vector conEvLinks) {
		return update(eventId, conEvLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all ConEvLinks
	 * for this Event and inserting new ones from an array of ConEvLink records
	 * to link to this Event.
	 * 
	 * Parameters: Event Id String array of ConEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String eventId, Vector conEvLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			ConEvLink conEvLink = null;
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM ConEvLink where " + "eventId=" + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; conEvLinks != null && i < conEvLinks.size(); i++) {
				conEvLink = (ConEvLink) conEvLinks.get(i);

				sqlString = "INSERT INTO ConEvLink " + "(eventId, contributorId, `function`, notes) " + "VALUES (" + m_db.plSqlSafeString(eventId) + ", " + conEvLink.getContributorId() + ", "
			+ m_db.plSqlSafeString(conEvLink.getFunction()) + ", '" + m_db.plSqlSafeString(conEvLink.getNotes()) + "')";
				m_db.runSQL(sqlString, stmt);

				Contributor contrib = conEvLink.getContributorBean();
				if (contrib != null && contrib.getId() != 0) {
					contrib.setDb(m_db);
					contrib.update();
				}
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Contributor Link records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteConEvLinksForEvent ()
	 * 
	 * Purpose: Deletes all ConEvLink records for the specified Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deleteConEvLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from ConEvLink WHERE eventId = " + m_db.plSqlSafeString(eventId);
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteConEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getConEvLinks ()
	 * 
	 * Purpose: Returns a record set with all of the ConEvLinks information in
	 * it.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getConEvLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT ConEvLink.*, ContributorFunctPreferred.* " + 
						"FROM ConEvLink " +
						"left join ContributorFunctPreferred on ConEvLink.function = ContributorFunctPreferredId " +
						"inner join contributor on ConEvLink.CONTRIBUTORID = contributor.CONTRIBUTORID " +
						"WHERE ConEvLink.eventId  = " + eventId + " " + 
						"ORDER BY if(preferredterm is null,1,0), PREFERREDTERM, contributor.LAST_NAME, contributor.FIRST_NAME";
			
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getConEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getConEvLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the ConEvLinks for this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all ConEvLinks for this Event.
	 */

	public Vector getConEvLinksForEvent(int eventId) {
		Vector allConEvLinks = new Vector();
		CachedRowSet rset = this.getConEvLinks(eventId);
		ConEvLink conEvLink = null;
		Contributor contributorBean = null;
		ContributorFunction contFunctBean = null;

		try {
			while (rset.next()) {
				conEvLink = new ConEvLink(m_db);
				conEvLink.setEventId(rset.getString("eventId"));
				conEvLink.setContributorId(rset.getString("contributorId"));
				conEvLink.setFunction(rset.getString("function"));
				conEvLink.setFunctionDesc(rset.getString("PreferredTerm"));
				conEvLink.setNotes(rset.getString("notes"));

				contributorBean = new Contributor(m_db);
				contributorBean.load(Integer.parseInt(conEvLink.getContributorId()));
				conEvLink.setContributorBean(contributorBean);

				contFunctBean = new ContributorFunction(m_db);
				contFunctBean.load(Integer.parseInt(function));
				conEvLink.setContFunctBean(contFunctBean);

				allConEvLinks.add(conEvLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getConEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		} finally {
			try {
				rset.close();
			} catch (Exception ex) {
			}
		}
		return allConEvLinks;
	}

	public String getConDispInfo(Statement stmt) {
		try {
			String sqlString = "SELECT contributor.`contributorid`,concat_ws(' ',contributor.last_name ,contributor.first_name) name, "
					+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))) dates, "
					+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') preferredterm "
					+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
					+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
					+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) where contributor.contributorId = "
					+ this.getContributorId();
			ResultSet rs = m_db.runSQL(sqlString, stmt);
			String ret = null;
			if (rs.next()) ret = rs.getString("name");
			ret += ' ' + rs.getString("dates");
			ret += ' ' + rs.getString("preferredterm");
			return ret;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean equals(ConEvLink p) {
		if (p == null) return false;
		if (p.toString().equals(this.toString())) return true;
		return false;
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setContributorId(String s) {
		contributorId = s;
	}

	public void setFunction(String s) {
		function = s;
	}

	public void setFunctionDesc(String s) {
		functionDesc = s;
	}

	// public void setFunctionDescId (String s) {functionDescid = s;}
	public void setNotes(String s) {
		notes = s;
		if (notes == null) notes = "";
		if (notes.length() > 500) notes = notes.substring(0, 499);
	}

	public void setContributorBean(Contributor c) {
		contributorBean = c;
	}

	public void setContFunctBean(ContributorFunction cf) {
		contFunctBean = cf;
	}

	public String getEventId() {
		return (eventId);
	}

	public String getContributorId() {
		return (contributorId);
	}

	public String getFunction() {
		return (function);
	}

	public String getFunctionDesc() {
		if (functionDesc == null) functionDesc = "";
		return (functionDesc);
	}

	// public String getFunctionDescId () {if(functionDescid == null)
	// functionDescid =""; return (functionDescid);}
	public String getNotes() {
		return (notes);
	}

	public Contributor getContributorBean() {
		return (contributorBean);
	}

	public ContributorFunction getContFunctBean() {
		return (contFunctBean);
	}

	public String getError() {
		return (m_error_string);
	}

	public boolean sameContributorAndFunction(ConEvLink conEvLink) {
		if (this.toLongString().equals(conEvLink.toLongString())) return true;
		return false;
	}

	public String toLongString() {
		return eventId + " " + contributorId + " " + function + " " + functionDesc;
	}

	public String toString() {
		return eventId + " " + contributorId;
	}
}

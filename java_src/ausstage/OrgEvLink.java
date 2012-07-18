/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: OrgEvLink.java

Purpose: Provides OrgEvLink object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.ResultSet;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class OrgEvLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String eventId;
	private String organisationId;
	private String function;
	private String functionDesc;
	private String artisticFunction;
	private String artisticFunctionDesc;
	private Organisation organisationBean;
	private String m_error_string;

	/*
	 * Name: OrgEvLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public OrgEvLink(ausstage.Database p_db) {
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
		organisationId = "0";
		function = "0";
		functionDesc = "";
		artisticFunction = "0";
		artisticFunctionDesc = "";
		organisationBean = null;
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the OrgEvLink information for the
	 * specified OrgEvLink id.
	 * 
	 * Parameters: p_id : id of the Organisation record e_id : id of the Event
	 * record Note: There is no unique key for this table.
	 * 
	 * Returns: None
	 */
	public void load(String p_id, String e_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		organisationId = p_id;
		eventId = e_id;
		organisationBean = new Organisation(m_db);
		organisationBean.load(Integer.parseInt(organisationId));

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT orgevlink.orgevlinkid,orgevlink.eventid,orgevlink.organisationid,orgevlink.`function`,"
					+ "orgevlink.artistic_function,orgfunctmenu.orgfunctionid,orgfunctmenu.orgfunction,contributorfunctpreferred.contributorfunctpreferredid,"
					+ "contributorfunctpreferred.preferredterm " + "From orgfunctmenu" + " INNER JOIN orgevlink ON (orgfunctmenu.orgfunctionid = orgevlink.`function`)"
					+ " INNER JOIN contributorfunctpreferred ON (orgevlink.artistic_function = contributorfunctpreferred.contributorfunctpreferredid)" + " WHERE organisationId = "
					+ p_id + " AND   eventId        = " + e_id + " AND   `function`       = OrgFunctionId ";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				function = l_rs.getString("function");
				functionDesc = l_rs.getString("orgFunction");
				artisticFunction = l_rs.getString("artistic_function");
				artisticFunctionDesc = l_rs.getString("orgFunction");
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in OrgEvLink: load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: eventId String array of OrgEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String eventId, Vector orgEvLinks) {
		return update(eventId, orgEvLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all OrgEvLinks
	 * for this Event and inserting new ones from an array of OrgEvLink records
	 * to link to this Event.
	 * 
	 * Parameters: Event Id String array of OrgEvLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String eventId, Vector orgEvLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			OrgEvLink orgEvLink = null;
			String sqlString;
			boolean l_ret = false;
			String l_function;
			String l_artisticFunction;

			sqlString = "DELETE FROM OrgEvLink where " + "eventId=" + eventId;
			m_db.runSQL(sqlString, stmt);

			for (int i = 0; orgEvLinks != null && i < orgEvLinks.size(); i++) {
				orgEvLink = (OrgEvLink) orgEvLinks.get(i);
				l_function = orgEvLink.getFunction();
				l_artisticFunction = orgEvLink.getArtisticFunction();

				if (l_function != null && l_function.equals("0")) l_function = null;

				if (l_artisticFunction != null && l_artisticFunction.equals("0")) l_artisticFunction = null;

				sqlString = "INSERT INTO OrgEvLink " + "(eventId, organisationId, function, artistic_function) " + "VALUES (" + eventId + ", " + orgEvLink.getOrganisationId()
						+ ", " + l_function + ", " + l_artisticFunction + ")";
				m_db.runSQL(sqlString, stmt);

				Organisation org = orgEvLink.getOrganisationBean();
				if (org != null && org.getId() != 0) {
					org.setDb(m_db);
					org.update();
				}
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to process the selected Organisation Link records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteOrgEvLinksForEvent ()
	 * 
	 * Purpose: Deletes all OrgEvLink records for the specified Event Id.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: None
	 */
	public void deleteOrgEvLinksForEvent(String eventId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from OrgEvLink WHERE eventId = " + eventId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteOrgEvLinksForEvent().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getOrgEvLinks ()
	 * 
	 * Purpose: Returns a record set with all of the OrgEvLinks information in
	 * it.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getOrgEvLinks(int eventId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT orgevlink.orgevlinkid,orgevlink.eventid,orgevlink.organisationid,orgevlink.`function`,"
					+ "orgevlink.artistic_function,orgfunctmenu.orgfunctionid,orgfunctmenu.orgfunction,contributorfunctpreferred.contributorfunctpreferredid,"
					+ "contributorfunctpreferred.preferredterm" 
					+ " From orgevlink " 
					+ "LEFT JOIN orgfunctmenu ON (orgfunctmenu.orgfunctionid = orgevlink.`function`) "
					+ "LEFT JOIN contributorfunctpreferred ON (orgevlink.artistic_function = contributorfunctpreferred.contributorfunctpreferredid)" 
					+ " WHERE eventId  = "
					+ eventId;

			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getOrgEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getOrgEvLinksForEvent (eventId)
	 * 
	 * Purpose: Returns a Vector containing all the OrgEvLinks for this Event.
	 * 
	 * Parameters: Event Id
	 * 
	 * Returns: A Vector of all OrgEvLinks for this Event.
	 */

	public Vector getOrgEvLinksForEvent(int eventId) {
		Vector allOrgEvLinks = new Vector();
		CachedRowSet rset = this.getOrgEvLinks(eventId);
		OrgEvLink orgEvLink = null;
		Organisation organisationBean = null;

		try {
			while (rset.next()) {
				orgEvLink = new OrgEvLink(m_db);
				orgEvLink.setEventId(rset.getString("eventId"));
				orgEvLink.setOrganisationId(rset.getString("organisationId"));
				orgEvLink.setFunction(rset.getString("function"));
				orgEvLink.setFunctionDesc(rset.getString("orgFunction"));
				orgEvLink.setArtisticFunction(rset.getString("artistic_function"));
				orgEvLink.setArtisticFunctionDesc(rset.getString("preferredTerm"));

				organisationBean = new Organisation(m_db);
				organisationBean.load(Integer.parseInt(orgEvLink.getOrganisationId()));
				orgEvLink.setOrganisationBean(organisationBean);

				allOrgEvLinks.add(orgEvLink);
			}
			rset.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getOrgEvLinksForEvent().");
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
		return allOrgEvLinks;
	}

	/*
	 * Name: getOrgFunctMenus ()
	 * 
	 * Purpose: Returns a record set with all of the OrgFunctMenus information
	 * in it.
	 * 
	 * Parameters: The database connection.
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getOrgFunctMenus(Database p_db) {
		m_db = p_db;
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM OrgFunctMenu";
			l_rs = m_db.runSQL(sqlString, stmt);
			return l_rs;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getOrgFunctMenus().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	public String getOrgDispInfo(Statement stmt) {
		try {
			String sqlString = "SELECT organisation.organisationid, organisation.name, "
					+ "if (min(events.yyyyfirst_date) = max(events.yyyylast_date), "
					+ "min(events . yyyyfirst_date), concat(min(events . yyyyfirst_date), ' - ', max(events . yyyylast_date))) dates, "
					+ "CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "
					+ "FROM organisation left join orgevlink on (orgevlink.organisationid = organisation.organisationid) "
					+ "left join events on orgevlink.eventid = events . eventid where organisation.organisationid = " + this.getOrganisationId();
			ResultSet rs = m_db.runSQL(sqlString, stmt);
			String ret = null;
			if (rs.next()) ret = rs.getString("output");
			return ret;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean equals(OrgEvLink p) {
		if (p == null) return false;
		if (p.toString().equals(this.toString())) return true;
		return false;
	}

	public void setEventId(String s) {
		eventId = s;
	}

	public void setOrganisationId(String s) {
		organisationId = s;
	}

	public void setFunction(String s) {
		function = s;
	}

	public void setFunctionDesc(String s) {
		functionDesc = s;
	}

	public void setArtisticFunction(String s) {
		artisticFunction = s;
	}

	public void setArtisticFunctionDesc(String s) {
		artisticFunctionDesc = s;
	}

	public void setOrganisationBean(Organisation c) {
		organisationBean = c;
	}

	public String getEventId() {
		return (eventId);
	}

	public String getOrganisationId() {
		return (organisationId);
	}

	public String getFunction() {
		return (function);
	}

	public String getFunctionDesc() {
		if (functionDesc == null) {
			functionDesc = "";
		}
		return (functionDesc);
	}

	public String getArtisticFunction() {
		return (artisticFunction);
	}

	public String getArtisticFunctionDesc() {
		if (artisticFunctionDesc == null) {
			artisticFunctionDesc = "";
		}
		return (artisticFunctionDesc);
	}

	public Organisation getOrganisationBean() {
		return (organisationBean);
	}

	public String getError() {
		return (m_error_string);
	}

	public boolean sameOrganisationAndFunction(OrgEvLink orgEvLink) {
		if (this.toLongString().equals(orgEvLink.toLongString())) return true;
		return false;
	}

	public String toLongString() {
		return eventId + " " + organisationId + " " + function + " " + functionDesc + " " + artisticFunction + " " + artisticFunctionDesc;
	}

	public String toString() {
		return eventId + " " + organisationId;
	}
}

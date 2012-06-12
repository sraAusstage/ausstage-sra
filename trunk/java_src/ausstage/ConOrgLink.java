/***************************************************

Company: SRA
 Author: Justin Brown
Project: Ausstage

   File: ConOrgLink.java

Purpose: Provides ConOrgLink object functions.

 ***************************************************/

package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import ausstage.ContributorFunction;
import sun.jdbc.rowset.CachedRowSet;

public class ConOrgLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	private String contributorId;
	private String organisationId;
	private String description;
	private String m_error_string;

	/*
	 * Name: ConOrgLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public ConOrgLink(Database m_db2) {
		m_db = m_db2;
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
		contributorId = "0";
		organisationId = "0";
		description = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the ConOrgLink information for the
	 * specified ConOrgLink.
	 * 
	 * Parameters: p_contributorId : id of the Contributor record
	 * p_organisationId : id of the Organisation record
	 * 
	 * Returns: None
	 */
	public void load(String p_contributorId, String p_organisationId) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		contributorId = p_contributorId;
		organisationId = p_organisationId;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM ConOrgLink " + " WHERE organisationId = " + contributorId;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				description = l_rs.getString("description");

				if (description == null) description = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			handleException(e, "An Exception occured in ConOrgLink: load().");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database. Does this by simply calling
	 * the update() method.
	 * 
	 * Parameters: eventId String array of ConOrgLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean add(String p_contributorId, Vector p_conOrgLinks) {
		return update(p_contributorId, p_conOrgLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all ConOrgLinks
	 * for this Contributor and inserting new ones from an array of ConOrgLink
	 * records to link to this Contributor.
	 * 
	 * Parameters: Contributor Id String array of ConOrgLink records.
	 * 
	 * Returns: True if successful, else false
	 */
	public boolean update(String p_contributorId, Vector p_conOrgLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			ConOrgLink conOrgLink = null;
			String sqlString;
			boolean l_ret = false;

			deleteConOrgLinksForContributor(p_contributorId);

			for (int i = 0; p_conOrgLinks != null && i < p_conOrgLinks.size(); i++) {
				conOrgLink = (ConOrgLink) p_conOrgLinks.get(i);
				sqlString = "INSERT INTO ConOrgLink " + "(contributorId, organisationId, description) " + "VALUES (" + p_contributorId + ", " + conOrgLink.getOrganisationId()
						+ ", '" + m_db.plSqlSafeString(conOrgLink.getDescription()) + "')";
				m_db.runSQL(sqlString, stmt);
			}
			l_ret = true;

			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Organisation Link records. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: deleteConOrgLinksForContributor ()
	 * 
	 * Purpose: Deletes all ConOrgLink records for the specified Contributor Id.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: None
	 */
	public void deleteConOrgLinksForContributor(String p_contributorId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from ConOrgLink WHERE contributorId = " + p_contributorId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			handleException(e, "An Exception occured in deleteConOrgLinksForContributor().");
		}
	}

	/*
	 * Name: getConOrgLinks ()
	 * 
	 * Purpose: Returns a record set with all of the ConOrgLinks information in
	 * it.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getConOrgLinks(int p_contributorId) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM ConOrgLink " + "WHERE contributorId  = " + p_contributorId;
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			handleException(e, "An Exception occured in getConOrgLinks().");
			return (null);
		}
	}

	/*
	 * Name: getConOrgLinksForContributor ()
	 * 
	 * Purpose: Returns a Vector containing all the ConOrgLinks for this
	 * contributor.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: A Vector of all ConOrgLinks for this contributor.
	 */

	public Vector getConOrgLinksForContributor(int p_contributorId) {
		Vector allConOrgLinks = new Vector();
		CachedRowSet rset = this.getConOrgLinks(p_contributorId);
		ConOrgLink conOrgLink = null;

		try {
			while (rset.next()) {
				conOrgLink = new ConOrgLink(m_db);
				conOrgLink.setContributorId(rset.getString("contributorId"));
				conOrgLink.setOrganisationId(rset.getString("organisationId"));
				conOrgLink.setDescription(rset.getString("description"));

				allConOrgLinks.add(conOrgLink);
			}
		} catch (Exception e) {
			handleException(e, "An Exception occured in getConOrgLinksForContributor().");
		} finally {
			try {
				rset.close();
			} catch (Exception ex) {
			}
		}
		return allConOrgLinks;
	}

	public boolean equals(ConOrgLink p) {
		if (p == null) return false;
		if (p.toString().equals(this.toString())) return true;
		return false;
	}

	public String toString() {
		return contributorId + " " + organisationId;
	}

	public void setContributorId(String p_contributorId) {
		contributorId = p_contributorId;
	}

	public void setOrganisationId(String p_organisationId) {
		organisationId = p_organisationId;
	}

	public void setDescription(String p_description) {
		description = p_description;
	}

	public String getContributorId() {
		return (contributorId);
	}

	public String getOrganisationId() {
		return (organisationId);
	}

	public String getDescription() {
		if (description == null) description = "";
		return (description);
	}

	public String getError() {
		return (m_error_string);
	}

	void handleException(Exception p_e, String p_description) {
		System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
		System.out.println("MESSAGE: " + p_e.getMessage());
		System.out.println("LOCALIZED MESSAGE: " + p_e.getLocalizedMessage());
		System.out.println("CLASS.TOSTRING: " + p_e.toString());
		System.out.println(">>>>>>> STACK TRACE <<<<<<<");
		System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	}

	void handleException(Exception p_e) {
		handleException(p_e, "");
	}
}

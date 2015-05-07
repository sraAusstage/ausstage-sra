package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import admin.AppConstants;
import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class OrganisationOrganisationLink {
	private Database m_db;
	private AppConstants AppConstants = new AppConstants();
	private Common Common = new Common();

	// All of the record information
	// private String OrganisationOrganisationLinkId;
	private String organisationId;
	private String childId;
	private String functionLovId;
	private String notes;
	private String m_error_string;

	/*
	 * Name: OrganisationOrganisationLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public OrganisationOrganisationLink(ausstage.Database m_db2) {
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
		// OrganisationOrganisationLinkId = "0";
		organisationId = "0";
		childId = "0";
		functionLovId = "0";
		notes = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * 
	 * Parameters: p_organisation_id : id of the main Organisation record
	 * 
	 * Returns: None
	 */

	public void load(String p_organisationorganisationlink_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM OrgOrgLink"
					+ " WHERE OrgOrgLinkId = " + p_organisationorganisationlink_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				organisationId = l_rs.getString("organisationId");
				childId = l_rs.getString("childId");
				functionLovId = l_rs.getString("function_lov_id");
				notes = l_rs.getString("notes");

				if (notes == null) notes = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in OrganisationOrganisationLink: load().");
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
	 * Parameters: organisationId String array of child Organisation ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean add(String p_organisationId, Vector<OrganisationOrganisationLink> p_childLinks) {
		return update(p_organisationId, p_childLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * OrganisationOrganisationLinks for this Organisation and inserting new
	 * ones from an array of p_childLinks.
	 * 
	 * Parameters: Organisation Id String array of child Organisation ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean update(String p_organisationId, Vector<OrganisationOrganisationLink> p_childLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			System.out.println("In update");
			sqlString = "DELETE FROM OrgOrgLink where " + "organisationId=" + p_organisationId;
			m_db.runSQL(sqlString, stmt);

			if (p_childLinks != null) {
				for (int i = 0; i < p_childLinks.size(); i++) {
					sqlString = "INSERT INTO OrgOrgLink " + "(organisationId, childId, function_lov_id, notes) " + "VALUES (" + p_organisationId + ", "
							+ p_childLinks.get(i).getChildId() + ", " + p_childLinks.get(i).getFunctionId() +", '" + m_db.plSqlSafeString(p_childLinks.get(i).getNotes()) + "' )";
					
					m_db.runSQL(sqlString, stmt);
				}
				l_ret = true;
			}
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Organisation Link records.";
			return (false);
		}
	}

	/*
	 * Name: deleteOrganisationOrganisationLinksForOrganisation ()
	 * 
	 * Purpose: Deletes all OrganisationOrganisationLink records for the
	 * specified Organisation Id.
	 * 
	 * Parameters: deleteOrganisationOrganisationLinksForOrganisation Id
	 * 
	 * Returns: None
	 */
	public void deleteOrganisationOrganisationLinksForOrganisation(String organisationId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			sqlString = "DELETE from OrgOrgLink WHERE organisationId = " + organisationId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteOrganisationOrganisationLinksForOrganisation().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getOrganisationOrganisationLinks ()
	 * 
	 * Purpose: Returns a record set with all of the
	 * OrganisationOrganisationLinks information in it.
	 * 
	 * Parameters: Organisation Id
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getOrganisationOrganisationLinks(int organisationId) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT OrgOrgLink.* " + " FROM OrgOrgLink " + " WHERE OrgOrgLink.organisationId  = " + organisationId;

			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getOrganisationOrganisationLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getOrganisationOrganisationLinksForOrganisation (organisationId)
	 * 
	 * Purpose: Returns a Vector containing all the
	 * OrganisationOrganisationLinks for this organisation.
	 * 
	 * Parameters: organisation Id
	 * 
	 * Returns: A Vector of all OrganisationOrganisationLinks for this
	 * organisation.
	 */

	public Vector<OrganisationOrganisationLink> getOrganisationOrganisationLinksForOrganisation(int organisationId) {
		Vector<OrganisationOrganisationLink> allOrganisationOrganisationLinks = new Vector<OrganisationOrganisationLink>();
		CachedRowSet rset = this.getOrganisationOrganisationLinks(organisationId);
		OrganisationOrganisationLink organisationOrganisationLink = null;

		try {
			while (rset.next()) {
				organisationOrganisationLink = new OrganisationOrganisationLink(m_db);
				organisationOrganisationLink.setOrganisationId(rset.getString("organisationId"));
				organisationOrganisationLink.setChildId(rset.getString("childId"));
				organisationOrganisationLink.setFunctionLovId(rset.getString("function_Lov_Id"));
				organisationOrganisationLink.setNotes(rset.getString("notes"));

				allOrganisationOrganisationLinks.add(organisationOrganisationLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getOrganisationOrganisationLinksForOrganisation().");
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
		return allOrganisationOrganisationLinks;
	}

	public void setOrganisationId(String s) {
		organisationId = s;
	}

	public void setChildId(String s) {
		childId = s;
	}

	public void setFunctionLovId(String s) {
		functionLovId = s;
	}

	public void setNotes(String s) {
		notes = s;
		if (notes == null) notes = "";
		if (notes.length() > 500) notes = notes.substring(0, 499);
	}

	public String getOrganisationId() {
		return (organisationId);
	}

	public String getChildId() {
		return (childId);
	}

	public String getFunctionId() {
		return (functionLovId);
	}

	public String getNotes() {
		return (notes);
	}

	public String getError() {
		return (m_error_string);
	}
}

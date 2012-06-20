package ausstage;

import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
//import admin.AppConstants;
//import admin.Common;
import sun.jdbc.rowset.CachedRowSet;

public class ContributorContributorLink {
	private Database m_db;

	// All of the record information
	private String contributorId;
	private String childId;
	private String functionLovId;
	private String notes;
	private String m_error_string;

	/*
	 * Name: ContributorContributorLink ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	
	public ContributorContributorLink(ausstage.Database m_db2) {
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
		childId = "0";
		functionLovId = "0";
		notes = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * 
	 * Parameters: p_contributor_id : id of the main Contributor record
	 * 
	 * Returns: None
	 */
	
	public void load(String p_contributorcontributorlink_id) {
		CachedRowSet l_rs;
		String sqlString;

		// Reset the object
		initialise();

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT * FROM ContribContribLink"
					+ " left join lookup_codes on ContribContribLink.function_lov_id=lookup_codes.code_lov_id" 
					+ " WHERE ContribContribLinkId = " + p_contributorcontributorlink_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				contributorId = l_rs.getString("contributorId");
				childId = l_rs.getString("childId");
				functionLovId = l_rs.getString("function_lov_id");
				notes = l_rs.getString("notes");

				if (notes == null) notes = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in ContributorContributorLink: load().");
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
	 * Parameters: contributorId String array of child Contributor ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean add(String p_contributorId, Vector<ContributorContributorLink> p_childLinks) {
		return update(p_contributorId, p_childLinks);
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database by deleting all
	 * ContributorContributorLinks for this Contributor and inserting new ones
	 * from an array of p_childLinks.
	 * 
	 * Parameters: Contributor Id String array of child Contributor ids.
	 * 
	 * Returns: True if successful, else false
	 */

	public boolean update(String p_contributorId, Vector<ContributorContributorLink> p_childLinks) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			sqlString = "DELETE FROM ContribContribLink where contributorId=" + p_contributorId;
			m_db.runSQL(sqlString, stmt);

			if (p_childLinks != null) {
				for (int i = 0; i < p_childLinks.size(); i++) {
					sqlString = "INSERT INTO ContribContribLink " 
							+ "(contributorId, childId, function_lov_id) " 
							+ "VALUES (" + p_contributorId + ", " + p_childLinks.get(i).getChildId() + ", " + p_childLinks.get(i).getFunctionId() + ")";
					m_db.runSQL(sqlString, stmt);
				}
				l_ret = true;
			}
			stmt.close();
			return l_ret;
		} catch (Exception e) {
			m_error_string = "Unable to update the links to the selected Contributor Link records.";
			return (false);
		}
	}

	/*
	 * Name: deleteContributorContributorLinksForContributor ()
	 * 
	 * Purpose: Deletes all ContributorContributorLink records for the specified
	 * Contributor Id.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: None
	 */
	
	public void deleteContributorContributorLinksForContributor(String contributorId) {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;

			sqlString = "DELETE from ContribContribLink WHERE contributorId = " + contributorId;
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in deleteContributorContributorLinksForContributor().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getContributorContributorLinks ()
	 * 
	 * Purpose: Returns a record set with all of the ContributorContributorLinks
	 * information in it.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: A record set.
	 */
	
	public CachedRowSet getContributorContributorLinks(int contributorId) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT contribcontriblink.* " + " FROM ContribContribLink " + " WHERE contributorId  = " + contributorId;

			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getContributorContributorLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	/*
	 * Name: getContributorContributorLinksForContributor (contributorId)
	 * 
	 * Purpose: Returns a Vector containing all the ContributorContributorLinks for this
	 * Contributor.
	 * 
	 * Parameters: Contributor Id
	 * 
	 * Returns: A Vector of all ContributorContributorLinks for this Contributor.
	 */

	public Vector<ContributorContributorLink> getContributorContributorLinksForContributor(int contributorId) {
		Vector<ContributorContributorLink> allContributorContributorLinks = new Vector<ContributorContributorLink>();
		CachedRowSet rset = this.getContributorContributorLinks(contributorId);
		ContributorContributorLink contributorContributorLink = null;

		try {
			while (rset.next()) {
				contributorContributorLink = new ContributorContributorLink(m_db);
				contributorContributorLink.setContributorId(rset.getString("contributorId"));
				contributorContributorLink.setChildId(rset.getString("childId"));
				contributorContributorLink.setFunctionLovId(rset.getString("function_Lov_Id"));
				contributorContributorLink.setNotes(rset.getString("notes"));

				allContributorContributorLinks.add(contributorContributorLink);
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getContributorContributorLinksForContributor().");
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
		return allContributorContributorLinks;
	}

	public void setContributorId(String s) {
		contributorId = s;
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

	public String getContributorId() {
		return (contributorId);
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

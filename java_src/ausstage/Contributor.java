/***************************************************

Company: Ignition Design
 Author: Jeoff Bongar
Project: Centricminds

   File: Contributor.java

Purpose: Provides Contributor object functions.

 ***************************************************/

package ausstage;

import java.util.*;

import ausstage.Database;
import admin.AppConstants;
import sun.jdbc.rowset.*;
import java.sql.*;
import java.sql.Date;

import javax.servlet.http.*;
import sun.jdbc.rowset.CachedRowSet;

public class Contributor {
	ausstage.Database m_db;
	admin.AppConstants AppConstants = new admin.AppConstants();

	private final int INSERT = 0;
	private final int DELETE = 1;
	private final int UPDATE = 2;

	public String m_error_string = "";
	int m_id = 0;
	String m_prefix = "";
	String m_name = "";
	String m_m_name = "";
	String m_l_name = "";
	String m_suffix = "";
	String m_display_name = "";
	String m_place_of_birth = "";
	String m_place_of_death = "";
	String m_other_names = "";
	String m_gender_id = "";
	String m_dob_d = "";
	String m_dob_m = "";
	String m_dob_y = "";
	String m_nationality = "";
	String m_address = "";
	String m_town = "";
	String m_state = "";
	String m_post_code = "";
	String m_phone = "";
	String m_email = "";
	String m_weblink = "";
	String m_notes = "";
	String m_nla = "";
	String m_dod_d = "";
	String m_dod_m = "";
	String m_dod_y = "";
	String m_country_id = "";
	String m_contfunct_ids = "";
	String m_contfunct_name = "";
	private String m_entered_by_user = "";
	private Date m_entered_date;
	private String m_updated_by_user = "";
	private Date m_updated_date;
	// delete me
	// Derived Objects
	private Vector m_conOrgLinks = new Vector();
	private Vector<ContributorContributorLink> m_contrib_contriblinks = new Vector<ContributorContributorLink>();

	/*
	 * Name: Contributor ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Contributor(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*
	 * Name: load()
	 * 
	 * Purpose: Sets the class to a contain the Contributor information for the
	 * specified Contributor id.
	 * 
	 * Parameters: p_id : id of the Contributor record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM CONTRIBUTOR WHERE CONTRIBUTORID = " + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {

				m_id = p_id;
				m_prefix = l_rs.getString("PREFIX");
				m_name = l_rs.getString("FIRST_NAME");
				m_m_name = l_rs.getString("MIDDLE_NAME");
				m_l_name = l_rs.getString("LAST_NAME");
				m_suffix = l_rs.getString("SUFFIX");
				m_display_name = l_rs.getString("DISPLAY_NAME");
				m_place_of_birth = l_rs.getString("PLACE_OF_BIRTH");
				m_place_of_death = l_rs.getString("PLACE_OF_DEATH");
				m_other_names = l_rs.getString("OTHER_NAMES");
				m_gender_id = l_rs.getString("GENDER");
				m_dob_d = l_rs.getString("DDDATE_OF_BIRTH");
				m_dob_m = l_rs.getString("MMDATE_OF_BIRTH");
				m_dob_y = l_rs.getString("YYYYDATE_OF_BIRTH");
				m_nationality = l_rs.getString("NATIONALITY");
				m_address = l_rs.getString("ADDRESS");
				m_town = l_rs.getString("SUBURB");
				m_state = l_rs.getString("STATE");
				m_post_code = l_rs.getString("POSTCODE");
				m_email = l_rs.getString("EMAIL");
				m_notes = l_rs.getString("NOTES");
				m_nla = l_rs.getString("NLA");
				m_dod_d = l_rs.getString("DDDATE_OF_DEATH");
				m_dod_m = l_rs.getString("MMDATE_OF_DEATH");
				m_dod_y = l_rs.getString("YYYYDATE_OF_DEATH");
				m_country_id = l_rs.getString("COUNTRYID");
				m_phone = "";
				m_weblink = "";
				m_entered_by_user = l_rs.getString("entered_by_user");
				m_entered_date = l_rs.getDate("entered_date");
				m_updated_by_user = l_rs.getString("updated_by_user");
				m_updated_date = l_rs.getDate("updated_date");

				loadOrganisationLinks();
				loadLinkedContributors();

				// set the contributor function ids
				sqlString = "select CONTRIBUTORFUNCTPREFERREDID from " + "CONTFUNCTLINK where CONTRIBUTORID=" + p_id;

				l_rs = m_db.runSQL(sqlString, stmt);

				if (l_rs.next()) {
					String temp_contfunct_ids = "";
					do {
						if (temp_contfunct_ids.equals(""))
							temp_contfunct_ids = l_rs.getString("CONTRIBUTORFUNCTPREFERREDID");
						else
							temp_contfunct_ids += "," + l_rs.getString("CONTRIBUTORFUNCTPREFERREDID");
					} while (l_rs.next());
					m_contfunct_ids = temp_contfunct_ids;
				}
			}

			if (m_prefix == null) {
				m_prefix = "";
			}
			if (m_name == null) {
				m_name = "";
			}
			if (m_m_name == null) {
				m_m_name = "";
			}
			if (m_l_name == null) {
				m_l_name = "";
			}
			if (m_suffix == null) {
				m_suffix = "";
			}
			if (m_display_name == null) {
				m_display_name = "";
			}
			if (m_place_of_birth == null) {
				m_place_of_birth = "";
			}
			if (m_place_of_death == null) {
				m_place_of_death = "";
			}
			if (m_other_names == null) {
				m_other_names = "";
			}
			if (m_gender_id == null) {
				m_gender_id = "";
			}
			if (m_dob_d == null) {
				m_dob_d = "";
			}
			if (m_dob_m == null) {
				m_dob_m = "";
			}
			if (m_dob_y == null) {
				m_dob_y = "";
			}
			if (m_nationality == null) {
				m_nationality = "";
			}
			if (m_address == null) {
				m_address = "";
			}
			if (m_town == null) {
				m_town = "";
			}
			if (m_state == null) {
				m_state = "";
			}
			if (m_post_code == null) {
				m_post_code = "";
			}
			if (m_phone == null) {
				m_phone = "";
			}
			if (m_email == null) {
				m_email = "";
			}
			if (m_notes == null) {
				m_notes = "";
			}
			if (m_nla == null) {
				m_nla = "";
			}
			if (m_dod_d == null) {
				m_dod_d = "";
			}
			if (m_dod_m == null) {
				m_dod_m = "";
			}
			if (m_dod_y == null) {
				m_dod_y = "";
			}
			if (m_country_id == null) {
				m_country_id = "";
			}
			if (m_weblink == null) {
				m_weblink = "";
			}
			if (m_contfunct_ids == null) {
				m_contfunct_ids = "";
			}
			if (m_entered_by_user == null) m_entered_by_user = "";
			if (m_updated_by_user == null) m_updated_by_user = "";

			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public Vector<Contributor> getContributors() {
		Vector<Contributor> contributors = new Vector<Contributor>();
		for (ContributorContributorLink ccl : m_contrib_contriblinks) {
			Contributor contributor = new Contributor(m_db);
			contributor.load(Integer.parseInt(ccl.getChildId()));
			contributors.add(contributor);
		}
		return contributors;
	}
	
	public Vector<ContributorContributorLink> getContributorContributorLinks() {
		return m_contrib_contriblinks;
	}

	/*
	 * Name: loadOrganisations ()
	 * 
	 * Purpose: Sets the class to a contain the Organisation information for the
	 * specified contributor id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	private void loadOrganisationLinks() {
		CachedRowSet l_rs;
		String sqlString;
		ConOrgLink temp_conOrgLink;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT organisationid, description " + "FROM CONORGLINK " + "WHERE CONTRIBUTORID=" + m_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			// Reset the object
			clearConOrgLinks();

			while (l_rs.next()) {
				temp_conOrgLink = new ConOrgLink(m_db);
				temp_conOrgLink.setContributorId(m_id + "");
				temp_conOrgLink.setOrganisationId(l_rs.getString("organisationid"));
				temp_conOrgLink.setDescription(l_rs.getString("description"));
				m_conOrgLinks.addElement(temp_conOrgLink);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.loadOrganisationLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadLinkedContributors ()
	 * 
	 * Purpose: Sets the class to a contain the Contributors information for the
	 * specified contributor id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	private void loadLinkedContributors() {
		ResultSet l_rs = null;
		String l_sql = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			l_sql = "SELECT DISTINCT contribcontriblinkid " + "FROM contribcontriblink " + "WHERE contribcontriblink.contributorid =" + m_id;
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			// Reset the object
			m_contrib_contriblinks.removeAllElements();

			while (l_rs.next()) {
				ContributorContributorLink ccl = new ContributorContributorLink(m_db);
				ccl.load(l_rs.getString("CONTRIBCONTRIBLINKID"));
				m_contrib_contriblinks.addElement(ccl);

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedContributors().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the add was successful, else false. Also fills out the
	 * id of the new record in the Contributor member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// trim the notes first to db specified max chars (-1) before
			// inserting
			if (m_notes.length() >= 600) m_notes = m_notes.substring(0, 599);

			// Check to make sure that it can be added
			if (validateObjectForDB()) {
				sqlString = "INSERT INTO Contributor " + "(PREFIX, FIRST_NAME, MIDDLE_NAME, LAST_NAME, SUFFIX, DISPLAY_NAME, OTHER_NAMES, "
						+ "GENDER, DDDATE_OF_BIRTH, MMDATE_OF_BIRTH, " + "YYYYDATE_OF_BIRTH, PLACE_OF_BIRTH, PLACE_OF_DEATH, NATIONALITY, ADDRESS, " + "SUBURB, STATE, POSTCODE, "
						+ "EMAIL, NOTES, NLA, DDDATE_OF_DEATH, MMDATE_OF_DEATH, " + "YYYYDATE_OF_DEATH, COUNTRYID, entered_by_user, entered_date) " + "VALUES (" + "'"
						+ m_db.plSqlSafeString(m_prefix) + "', "
						+ "'" + m_db.plSqlSafeString(m_name) + "', "
						+ "'" + m_db.plSqlSafeString(m_m_name) + "', "
						+ "'" + m_db.plSqlSafeString(m_l_name) + "', "
						+ "'" + m_db.plSqlSafeString(m_suffix) + "', "
						+ "'" + m_db.plSqlSafeString(m_display_name) + "', "
						+ "'" + m_db.plSqlSafeString(m_other_names) + "', "
						+ Integer.parseInt(m_gender_id) + ", "
						+ "'" + m_db.plSqlSafeString(m_dob_d) + "', "
						+ "'" + m_db.plSqlSafeString(m_dob_m) + "', "
						+ "'" + m_db.plSqlSafeString(m_dob_y) + "', "
						+ m_db.plSqlSafeString(m_place_of_birth.equals("") ? "null" : m_place_of_birth) + ","
						+ m_db.plSqlSafeString(m_place_of_death.equals("") ? "null" : m_place_of_death) + ","
						+ "'" + m_db.plSqlSafeString(m_nationality) + "', "
						+ "'" + m_db.plSqlSafeString(m_address) + "', "
						+ "'" + m_db.plSqlSafeString(m_town) + "', "
						+ Integer.parseInt(m_state) + ","
						+ m_db.plSqlSafeString(m_post_code.equals("") ? "null" : m_post_code) + ","
						+ "'" + m_db.plSqlSafeString(m_email) + "', "
						+ "'" + m_db.plSqlSafeString(m_notes) + "', "
						+ "'" + m_db.plSqlSafeString(m_nla) + "', "
						+ "'" + m_db.plSqlSafeString(m_dod_d) + "', "
						+ "'" + m_db.plSqlSafeString(m_dod_m) + "', "
						+ "'" + m_db.plSqlSafeString(m_dod_y) + "', "
						+ Integer.parseInt(m_country_id) + ", "
						+ "'" + m_db.plSqlSafeString(m_entered_by_user) + "', NOW())";

				m_db.runSQL(sqlString, stmt);

				// Get the inserted index & set the id state of this object
				setId(Integer.parseInt(m_db.getInsertedIndexValue(stmt, "CONTRIBUTORID_SEQ")));

				// now lets add the chosen contributor function(s) if any
				if (!m_contfunct_ids.equals("")) {
					if (m_contfunct_ids.indexOf(",") != -1) {
						// we are dealing with comma delimited string ids
						StringTokenizer contribfunct_ids = new StringTokenizer(m_contfunct_ids, ",");
						while (contribfunct_ids.hasMoreTokens()) {
							sqlString = "Insert into contfunctlink(CONTRIBUTORID, CONTRIBUTORFUNCTPREFERREDID) values " + "(" + m_id + "," + contribfunct_ids.nextToken() + ")";
							m_db.runSQL(sqlString, stmt);
						}
					} else {
						// deal with single id
						sqlString = "Insert into contfunctlink(CONTRIBUTORID, CONTRIBUTORFUNCTPREFERREDID) values " + "(" + m_id + "," + m_contfunct_ids + ")";
						m_db.runSQL(sqlString, stmt);
					}
				}
				ret = true;
			}
			modifyConOrgLinks();
			modifyContribContribLinks(INSERT);
			stmt.close();
			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.add()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (false);
		}
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: None
	 */
	public boolean update() {
		boolean l_ret = true;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			// trim the notes first to db specified max chars (-1) before
			// updating
			if (m_notes.length() >= 4000) m_notes = m_notes.substring(0, 3999);

			if (m_country_id == null || m_country_id.equals("") || m_country_id.equals("0")) {
				m_country_id = "null";
			}
			if (m_state == null || m_state.equals("") || m_state.equals("0")) {
				m_state = "null";
			}
			if (m_gender_id == null || m_gender_id.equals("") || m_gender_id.equals("0")) {
				m_gender_id = "null";
			}
			if (m_post_code == null || m_post_code.equals("") || m_post_code.equals("0")) {
				m_post_code = "null";
			}
			if (m_place_of_birth == null || m_place_of_birth.equals("") || m_place_of_birth.equals("0")) {
				m_place_of_birth = "null";
			}
			if (m_place_of_death == null || m_place_of_death.equals("") || m_place_of_death.equals("0")) {
				m_place_of_death = "null";
			}

			sqlString = "UPDATE Contributor " 
					+ "SET PREFIX= '" + m_db.plSqlSafeString(m_prefix) + "'," 
					+ "FIRST_NAME= '" + m_db.plSqlSafeString(m_name) + "'," 
					+ "MIDDLE_NAME= '" + m_db.plSqlSafeString(m_m_name) + "'," 
					+ "LAST_NAME= '" + m_db.plSqlSafeString(m_l_name) + "'," 
					+ "SUFFIX= '" + m_db.plSqlSafeString(m_suffix) + "',"
					+ "DISPLAY_NAME= '" + m_db.plSqlSafeString(m_display_name) + "'," 
					+ "OTHER_NAMES= '" + m_db.plSqlSafeString(m_other_names) + "'," 
					+ "GENDER= " + m_gender_id + "," 
					+ "DDDATE_OF_BIRTH= '" + m_db.plSqlSafeString(m_dob_d) + "'," 
					+ "MMDATE_OF_BIRTH= '" + m_db.plSqlSafeString(m_dob_m) + "'," 
					+ "YYYYDATE_OF_BIRTH= '" + m_db.plSqlSafeString(m_dob_y) + "'," 
					+ "PLACE_OF_BIRTH= " + m_place_of_birth + "," 
					+ "PLACE_OF_DEATH= " + m_place_of_death + "," 
					+ "NATIONALITY= '" + m_db.plSqlSafeString(m_nationality) + "'," 
					+ "ADDRESS= '" + m_db.plSqlSafeString(m_address) + "'," 
					+ "SUBURB= '" + m_db.plSqlSafeString(m_town) + "',"
					+ "STATE= " + m_state + "," 
					+ "POSTCODE= " + m_post_code + "," 
					+ "EMAIL= '" + m_db.plSqlSafeString(m_email) + "'," 
					+ "NOTES= '" + m_db.plSqlSafeString(m_notes) + "'," 
					+ "NLA= '" + m_db.plSqlSafeString(m_nla) + "'," 
					+ "DDDATE_OF_DEATH= '" + m_db.plSqlSafeString(m_dod_d) + "'," 
					+ "MMDATE_OF_DEATH= '" + m_db.plSqlSafeString(m_dod_m) + "'," 
					+ "YYYYDATE_OF_DEATH= '" + m_db.plSqlSafeString(m_dod_y) + "'," 
					+ (m_updated_by_user!=null && !m_updated_by_user.equals("")? "UPDATED_BY_USER = '" + m_db.plSqlSafeString(m_updated_by_user) + "', UPDATED_DATE = now(), ":"") 
					+ "COUNTRYID= " + m_country_id + " " 
					+ "WHERE CONTRIBUTORID = " + m_id;

			m_db.runSQL(sqlString, stmt);

			if (!m_contfunct_ids.equals("")) {
				// now lets delete the old relationship between
				// contributor & contributor function tables
				sqlString = "Delete from contfunctlink where CONTRIBUTORID=" + m_id;
				m_db.runSQL(sqlString, stmt);

				// now lets add these updated contributor function
				// & contributor relationship
				if (m_contfunct_ids.indexOf(",") != -1) {
					// we are dealing with comma delimited string ids
					StringTokenizer contribfunct_ids = new StringTokenizer(m_contfunct_ids, ",");
					while (contribfunct_ids.hasMoreTokens()) {
						sqlString = "Insert into contfunctlink(CONTRIBUTORID, CONTRIBUTORFUNCTPREFERREDID) values " + "(" + m_id + "," + contribfunct_ids.nextToken() + ")";
						m_db.runSQL(sqlString, stmt);
					}
				} else {
					// deal with single id
					sqlString = "Insert into contfunctlink(CONTRIBUTORID, CONTRIBUTORFUNCTPREFERREDID) values " + "(" + m_id + "," + m_contfunct_ids + ")";
					m_db.runSQL(sqlString, stmt);
				}
			}

			modifyConOrgLinks();
			modifyContribContribLinks(UPDATE);
			System.out.println("In UPDATE 3");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.update().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Removes this object from the database.
	 * 
	 * Parameters: None
	 * 
	 * Returns: true if successful else false
	 */
	public boolean delete() {
		boolean ret = true;
		ConOrgLink conOrgLink = new ConOrgLink(m_db);
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			if (!isInUse()) {
				// Remove the ConOrgLinks
				conOrgLink.deleteConOrgLinksForContributor(m_id + "");

				modifyContribContribLinks(DELETE);

				sqlString = "DELETE FROM Contfunctlink WHERE CONTRIBUTORID = " + m_id;
				m_db.runSQL(sqlString, stmt);

				sqlString = "DELETE FROM Contributor WHERE CONTRIBUTORID = " + m_id;
				m_db.runSQL(sqlString, stmt);

			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Publications.delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			ret = false;
		}
		return (ret);
	}

	public boolean isInUse() {
		boolean ret = false;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			CachedRowSet l_rs;

			// check first if exist in CONTRIBUTORID table
			sqlString = "select CONTRIBUTORID from CONEVLINK where CONTRIBUTORID=" + m_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				ret = true;
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.isInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			ret = true;
		}
		return (ret);
	}

	/*
	 * Name: modifyContribContribLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyContribContribLinks(int modifyType) {
		try {
			ContributorContributorLink temp_object = new ContributorContributorLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(Integer.toString(m_id), m_contrib_contriblinks);
				break;
			case DELETE:
				temp_object.deleteContributorContributorLinksForContributor(Integer.toString(m_id));
				break;
			case INSERT:
				temp_object.add(Integer.toString(m_id), m_contrib_contriblinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyEventEventLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public CachedRowSet getNames() {
		CachedRowSet l_rs = null;
		String sqlString;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "select CONTRIBUTORID, FIRST_NAME, LAST_NAME from CONTRIBUTOR " + "order by LAST_NAME";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in Contributor.getNames().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	public CachedRowSet getContFunctPreff(int contFunctPreffId) {
		CachedRowSet l_rs = null;
		String sqlString;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "SELECT * FROM ContributorFunctPreferred " + "where ContributorFunctPreferredid=" + contFunctPreffId;
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in Contributor.getContFunctPreff().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	public String getContFunctPreffTermByContributor(String p_id) {
		CachedRowSet l_rs = null;
		String sqlString, ret_str = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "SELECT PreferredTerm FROM ContFunctLink, ContributorFunctPreferred where " + "ContFunctLink.contributorid=" + p_id + " "
					+ "and ContFunctLink.ContributorFunctPreferredid=" + "ContributorFunctPreferred.ContributorFunctPreferredid";

			l_rs = m_db.runSQL(sqlString, stmt);
			while (l_rs.next()) {
				if (ret_str.equals(""))
					ret_str = l_rs.getString("PreferredTerm");
				else
					ret_str += ", " + l_rs.getString("PreferredTerm");
			}
			stmt.close();
		} catch (Exception e) {
			System.out.println("An Exception occured in Contributor.getContFunctPrefftTermByContributor().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (ret_str);
	}

	/*
	 * Name: validateObjectForDB ()
	 * 
	 * Purpose: Determines if the object is valid for insert or update.
	 * 
	 * Parameters: True if the object is valid, else false
	 * 
	 * Returns: None
	 */
	private boolean validateObjectForDB() {
		boolean l_ret = true;

		try {
			// Nothing to do at the moment, always return true
			return (l_ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in validateObjectForDB().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (l_ret);
		}
	}

	/*
	 * Name: doesContributorAlreadyExist ()
	 * 
	 * Purpose: Checks to see if a Contributor already exist (by first and last
	 * names)
	 * 
	 * Parameters: None
	 * 
	 * Returns: True if the contributor already exists, else false
	 */
	public boolean doesContributorAlreadyExist() {
		boolean l_ret = false;
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			// Check to see if a Contributor record exists (same last and first
			// names)
			sqlString = "select CONTRIBUTORID from CONTRIBUTOR where LAST_NAME='" + m_l_name + "' and FIRST_NAME='" + m_name + "'";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) l_ret = true;
			l_rs.close();
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in validateObjectForDB().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (l_ret);
		}
	}

	// /////////////////////////////
	// SET FUNCTIONS
	// ////////////////////////////

	public void setDb(ausstage.Database p_db) {
		m_db = p_db;
	}

	public void setId(int p_id) {
		m_id = p_id;
	}

	public void setPrefix(String p_prefix) {
		m_prefix = p_prefix;
	}

	public void setName(String p_name) {
		m_name = p_name;
	}

	public void setMiddleName(String p_m_name) {
		m_m_name = p_m_name;
	}

	public void setLastName(String p_l_name) {
		m_l_name = p_l_name;
	}

	public void setSuffix(String p_suffix) {
		m_suffix = p_suffix;
	}

	public void setDisplayName(String p_display_name) {
		m_display_name = p_display_name;
	}

	public void setPlaceOfBirth(String p_place_of_birth) {
		m_place_of_birth = p_place_of_birth;
	}

	public void setPlaceOfDeath(String p_place_of_death) {
		m_place_of_death = p_place_of_death;
	}

	public void setOtherNames(String p_other_name) {
		m_other_names = p_other_name;
	}

	public void setGenderId(String p_gender_id) {
		m_gender_id = p_gender_id;
	}

	public void setGenderIdName(String p_gender_id) {
		m_gender_id = p_gender_id;
	}

	public void setDobDay(String p_dob_d) {
		m_dob_d = p_dob_d;
	}

	public void setDobMonth(String p_dob_m) {
		m_dob_m = p_dob_m;
	}

	public void setDobYear(String p_dob_y) {
		m_dob_y = p_dob_y;
	}

	public void setNationality(String p_nationality) {
		m_nationality = p_nationality;
	}

	public void setAddress(String p_address) {
		m_address = p_address;
	}

	public void setTown(String p_town) {
		m_town = p_town;
	}

	public void setState(String p_state) {
		m_state = p_state;
	}

	public void setPostCode(String p_post_code) {
		m_post_code = p_post_code;
	}

	public void setPhone(String p_phone) {
		m_phone = p_phone;
	}

	public void setEmail(String p_email) {
		m_email = p_email;
	}

	public void setWeblink(String p_weblink) {
		m_weblink = p_weblink;
	}

	public void setNotes(String p_notes) {
		m_notes = p_notes;
	}

	public void setNLA(String p_nla) {
		m_nla = p_nla;
	}

	public void setDodDay(String p_dod_d) {
		m_dod_d = p_dod_d;
	}

	public void setDodMonth(String p_dod_m) {
		m_dod_m = p_dod_m;
	}

	public void setDodYear(String p_dod_y) {
		m_dod_y = p_dod_y;
	}

	public void setCountryId(String p_country_id) {
		m_country_id = p_country_id;
	}

	public void setContFunctIds(String p_contfunct_ids) {
		m_contfunct_ids = p_contfunct_ids;
	}

	public void setConOrgLinks(Vector v) {
		m_conOrgLinks = v;
	}

	public void setEnteredByUser(String p_user_name) {
		m_entered_by_user = p_user_name;
	}

	public void setUpdatedByUser(String p_user_name) {
		m_updated_by_user = p_user_name;
	}

	public void setContributorContributorLinks(Vector<ContributorContributorLink> p_contrib_contriblinks) {
		m_contrib_contriblinks = p_contrib_contriblinks;
	}


	// /////////////////////////////
	// GET FUNCTIONS
	// ////////////////////////////

	public int getId() {
		return (m_id);
	}

	public String getPrefix() {
		return (m_prefix);
	}

	public String getName() {
		return (m_name);
	}

	public String getMiddleName() {
		return (m_m_name);
	}

	public String getLastName() {
		return (m_l_name);
	}

	public String getSuffix() {
		return (m_suffix);
	}

	public String getDisplayName() {
		return (m_display_name);
	}

	public String getPlaceOfBirth() {
		return (m_place_of_birth);
	}

	public String getPlaceOfDeath() {
		return (m_place_of_death);
	}

	public String getOtherNames() {
		return (m_other_names);
	}

	public String getGenderId() {
		return (m_gender_id);
	}

	public String getDobDay() {
		return (m_dob_d);
	}

	public String getDobMonth() {
		return (m_dob_m);
	}

	public String getDobYear() {
		return (m_dob_y);
	}

	public String getNationality() {
		return (m_nationality);
	}

	public String getAddress() {
		return (m_address);
	}

	public String getTown() {
		return (m_town);
	}

	public String getState() {
		return (m_state);
	}

	public String getPostCode() {
		return (m_post_code);
	}

	public String getPhone() {
		return (m_phone);
	}

	public String getEmail() {
		return (m_email);
	}

	public String getWeblink() {
		return (m_weblink);
	}

	public String getNotes() {
		return (m_notes);
	}

	public String getNLA() {
		return (m_nla);
	}

	public String getDodDay() {
		return (m_dod_d);
	}

	public String getDodMonth() {
		return (m_dod_m);
	}

	public String getDodYear() {
		return (m_dod_y);
	}

	public String getCountryId() {
		return (m_country_id);
	}

	public String getContFunctIds() {
		return (m_contfunct_ids);
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

	public String getGender() {
		String sqlString = "", retStr = "";
		CachedRowSet crset = null;

		try {
			if (m_gender_id == "") m_gender_id = "3";
			sqlString = "select gender from gendermenu where genderid=" + m_gender_id;

			Statement stmt = m_db.m_conn.createStatement();
			crset = m_db.runSQL(sqlString, stmt);

			if (crset.next()) retStr = crset.getString("gender");

			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getGender().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	// //////////////////////
	// Derived Objects
	// //////////////////////

	public Vector getConOrgLinks() {
		return m_conOrgLinks;
	}

	public Vector<Contributor> getAssociatedContributors() {
		return getContributors();
	}

	// //////////////////////
	// Utility methods
	// //////////////////////

	public String getContributorInfoForContributorDisplay(int p_contrib_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT contributor.contributorid, concat_ws(' ', last_name, first_name) AS name " + "FROM contributor "
					+ "LEFT OUTER JOIN contribcontriblink ON (contributor.contributorid = contribcontriblink.CONTRIBUTORID) " + "WHERE contributor.contributorid=" + p_contrib_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("name");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getContributorInfoForContributorDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);
	}

	public String getContributorInfoForItemDisplay(int p_contrib_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {
			sqlString = "SELECT contributor.`contributorid`,concat_ws(' ', last_name, first_name) as name, "
					+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "
					+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') preferredterm, "
					+ "concat_ws(', ', concat_ws(' ', contributor.last_name, contributor.first_name), if(min(events.yyyyfirst_date) = max(events.yyyylast_date), min(events.yyyyfirst_date), concat(min(events.yyyyfirst_date), ' - ', max(events.yyyylast_date))) , group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) AS output "
					+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
					+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
					+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) " + "WHERE contributor.contributorid="
					+ p_contrib_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("output");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getContributorInfoForItemDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}
	
	public String getBasicContributorInfoForItemDisplay(int p_contrib_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {
			sqlString = "SELECT contributor.`contributorid`,concat_ws(' ', last_name, first_name) as name, "
				+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "
				+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') preferredterm, "
				+ "concat_ws(', ', concat_ws(' ', contributor.last_name, contributor.first_name), if(min(events.yyyyfirst_date) = max(events.yyyylast_date), min(events.yyyyfirst_date), concat(min(events.yyyyfirst_date), ' - ', max(events.yyyylast_date))) , group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) AS output "
				+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
				+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
				+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) " + "WHERE contributor.contributorid="
				+ p_contrib_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("name");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getBasicContributorInfoForItemDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public ResultSet getContributorsByItem(int p_contributor_id, Statement p_stmt) {
		String sqlString = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT DISTINCT contributor.contributorid, display_name as name, preferredterm "
					+ "FROM contributor, itemconlink, contributorfunctpreferred, contfunctlink " + "WHERE itemconlink.contributorid=" + p_contributor_id + " "
					+ "AND itemconlink.contributorid = contributor.contributorid " + "AND contributor.contributorid = contfunctlink.contributorid "
					+ "AND contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid " + "ORDER BY name ASC";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getContributorsByItem().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	// ////////////////////////////////////////////////////////
	/*
	 * Name: setContributorAttributes (HttpServletRequest request)
	 * 
	 * Purpose: Sets the attributes in this object from the request.
	 * 
	 * Parameters: request - The request received by the current page.
	 * 
	 * Returns: None.
	 */
	public void setContributorAttributes(HttpServletRequest request) {

		if (request.getParameter("f_contrib_id") == null || request.getParameter("f_contrib_id").equals("")) {
			this.m_id = 0;
		} else {
			this.m_id = Integer.parseInt(request.getParameter("f_contrib_id"));
		}
		this.m_prefix = request.getParameter("f_prefix");
		this.m_name = request.getParameter("f_f_name");
		this.m_m_name = request.getParameter("f_m_name");
		this.m_l_name = request.getParameter("f_l_name");
		this.m_suffix = request.getParameter("f_suffix");
		this.m_display_name = request.getParameter("f_display_name");
		this.m_place_of_birth = request.getParameter("f_place_of_birth");
		this.m_place_of_death = request.getParameter("f_place_of_death");
		this.m_other_names = request.getParameter("f_contrib_other_names");
		this.m_gender_id = request.getParameter("f_contrib_gender_id");
		this.m_dob_d = request.getParameter("f_contrib_day");
		this.m_dob_m = request.getParameter("f_contrib_month");
		this.m_dob_y = request.getParameter("f_contrib_year");
		this.m_nationality = request.getParameter("f_contrib_nationality");
		this.m_address = request.getParameter("f_contrib_address");
		this.m_town = request.getParameter("f_contrib_town");
		this.m_state = request.getParameter("f_contrib_state");
		this.m_post_code = request.getParameter("f_contrib_postcode");
		this.m_email = request.getParameter("f_contrib_email");
		this.m_notes = request.getParameter("f_contrib_notes");
		this.m_nla = request.getParameter("f_contrib_nla");
		this.m_dod_d = request.getParameter("f_contrib_day_death");
		this.m_dod_m = request.getParameter("f_contrib_month_death");
		this.m_dod_y = request.getParameter("f_contrib_year_death");
		this.m_country_id = request.getParameter("f_contrib_country_id");
		// allow posting from contributor to organisations and retain the
		// contributor functions
		// this.m_contfunct_ids = request.getParameter("f_contrib_funct_ids");
		this.m_contfunct_ids = request.getParameter("delimited_contrib_funct_ids");
	}

	/*
	 * Name: modifyConOrgLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */
	private void modifyConOrgLinks() {
		ConOrgLink conOrgLink = new ConOrgLink(m_db);

		try {
			conOrgLink.add(m_id + "", m_conOrgLinks);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyConOrgLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*************************************************************************
	 * this method is used for passing in a vector containing id strings of the
	 * relevant object. i.e eventids, contributor ids etc. It then appends the
	 * appropriate display info to the id as a string. Such that when used in
	 * the displayLinkedItem method from item_addedit.jsp it has all the
	 * information as a string per element ready to be displayed.
	 **************************************************************************/
	public Vector generateDisplayInfo(Vector p_ids, String p_id_type, Statement p_stmt) {
		Vector l_display_info = new Vector();
		String l_info_to_add = "";
		;

		for (int i = 0; i < p_ids.size(); i++) {
			if (p_id_type.equals("contributor")) {
				Contributor childContributor = new Contributor(m_db);
				int childContributorId = Integer.parseInt((m_contrib_contriblinks.elementAt(i)).getChildId());
				l_info_to_add = childContributor.getContributorInfoForContributorDisplay(childContributorId, p_stmt);

				// Get the selected item function
				l_display_info.add(l_info_to_add);
			}
		}
		return l_display_info;
	}

	/*
	 * Name: getAssociatedItems (int p_contributor_id)
	 * 
	 * Purpose: Find any items that are associated to a contributor.
	 * 
	 * Parameters: p_contributor_id - The id of the contributor.
	 * 
	 * Returns: A ResultSet with item information if the contributor is found to
	 * be associated.
	 */

	public ResultSet getAssociatedItems(int p_contributor_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT distinct contributor.last_name,contributor.first_name, contributor.contributorid,item.itemid,item.citation, lookup_codes.description " + " FROM item "
					+ " LEFT JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id) "
					+ " INNER JOIN itemconlink ON (item.itemid = itemconlink.itemid) " + " INNER JOIN contributor ON (itemconlink.contributorid = contributor.contributorid) "
					+ " WHERE itemconlink.contributorid=" + p_contributor_id + " " + " ORDER BY lookup_codes.description, item.citation ";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getAccociatedItems().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	/*
	 * Name: getAssociatedWorks (int p_contributor_id)
	 * 
	 * Purpose: Find any items that are associated to a contributor.
	 * 
	 * Parameters: p_contributor_id - The id of the contributor.
	 * 
	 * Returns: A ResultSet with item information if the contributor is found to
	 * be associated.
	 */

	public ResultSet getAssociatedWorks(int p_contributor_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT DISTINCT w.workid, WORK_TITLE " + "FROM work w, workconlink wcl " + "WHERE wcl.contributorid=" + p_contributor_id + " " + "AND wcl.workid = w.workid  "
					+ "ORDER BY WORK_TITLE";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getAssociatedWorks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	public String getContributorInfoForDisplay(int p_contrib_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT contributor.`contributorid`,concat_ws(', ',  first_name,last_name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date), "
					+ "min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) , "
					+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "
					+ "concat_ws(', ',concat_ws(' ',contributor.first_name, contributor.last_name), "
					+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date), "
					+ "concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output  "
					+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
					+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
					+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid)   "
					+ "WHERE contributor.contributorid =  " + p_contrib_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("output");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getContributorInfoForDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public void clearConOrgLinks() {
		m_conOrgLinks.removeAllElements();
	}
}

/***************************************************

Company: Ignition Design
 Author: Bill malkin
Project: Centricminds

   File: Collection.java

Purpose: Provides Collection object functions.

 ***************************************************/

package ausstage;

import java.util.Date;
import java.util.Vector;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Collection {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private String m_collection_information_id;
	private String m_entity;
	private Date m_date_entered;
	private Date m_date_updated;
	private String m_input_person;
	private String m_collection_name;
	private String m_description;
	private String m_size;
	private String m_location;
	private String m_access;
	private String m_access_other_detail;
	private String m_related_sources;
	private String m_comments;
	private String m_materials[];
	private String m_error_string;

	/*
	 * Name: Collection ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Collection(ausstage.Database p_db) {
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
		m_collection_information_id = "";
		m_entity = "";
		m_date_entered = new Date();
		m_date_updated = new Date();
		m_input_person = "";
		m_collection_name = "";
		m_description = "";
		m_size = "";
		m_location = "";
		m_access = "";
		m_access_other_detail = "";
		m_related_sources = "";
		m_comments = "";
		m_error_string = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Collection information for the
	 * specified Collection id.
	 * 
	 * Parameters: p_id : id of the Collection record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM collection_information WHERE " + "collection_information_id=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_collection_information_id = l_rs.getString("collection_information_id");
				m_entity = l_rs.getString("entity");
				m_date_entered = l_rs.getDate("date_entered");
				m_date_updated = l_rs.getDate("date_updated");
				m_input_person = l_rs.getString("input_person");
				m_collection_name = l_rs.getString("collection_name");
				m_description = l_rs.getString("description");
				m_size = l_rs.getString("collection_size");
				m_location = l_rs.getString("location");
				m_access = l_rs.getString("collection_access");
				m_access_other_detail = l_rs.getString("access_other_detail");
				m_related_sources = l_rs.getString("related_sources");
				m_comments = l_rs.getString("comments");

				if (m_input_person == null) m_input_person = "";
				if (m_collection_name == null) m_collection_name = "";
				if (m_description == null) m_description = "";
				if (m_size == null) m_size = "";
				if (m_location == null) m_location = "";
				if (m_access == null) m_access = "";
				if (m_access_other_detail == null) m_access_other_detail = "";
				if (m_related_sources == null) m_related_sources = "";
				if (m_comments == null) m_comments = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadResource().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
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
	 * id of the new record in the m_collection_information_id member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the Description is a text area, need to limit characters
				if (m_description.length() >= 300) m_description = m_description.substring(0, 4000);

				// As the Comments is a text area, need to limit characters
				if (m_comments.length() > 4000) m_comments = m_comments.substring(0, 3999);

				// As the Related Sources is a text area, need to limit
				// characters
				if (m_related_sources.length() > 4000) m_related_sources = m_related_sources.substring(0, 3999);

				sqlString = "INSERT INTO collection_information (ENTITY, DATE_ENTERED, " + "INPUT_PERSON, COLLECTION_NAME, DESCRIPTION, COLLECTION_SIZE, "
						+ "LOCATION, COLLECTION_ACCESS, ACCESS_OTHER_DETAIL, " + "RELATED_SOURCES, COMMENTS) VALUES ( "
						+ m_entity
						+ " , "
						+ m_db.safeDateFormat(m_date_entered, false)
						+ ", "
						+ "'"
						+ m_db.plSqlSafeString(m_input_person)
						+ "', "
						+ "'"
						+ m_db.plSqlSafeString(m_collection_name)
						+ "', "
						+ "'"
						+ m_db.plSqlSafeString(m_description)
						+ "', "
						+ "'"
						+ m_db.plSqlSafeString(m_size)
						+ "', "
						+ "'"
						+ m_db.plSqlSafeString(m_location)
						+ "', "
						+ m_db.plSqlSafeString(m_access)
						+ " , "
						+ "'"
						+ m_db.plSqlSafeString(m_access_other_detail)
						+ "', "
						+ "'"
						+ m_db.plSqlSafeString(m_related_sources) + "', " + "'" + m_db.plSqlSafeString(m_comments) + "')";
				m_db.runSQL(sqlString, stmt);
				// Get the inserted index
				m_collection_information_id = m_db.getInsertedIndexValue(stmt, "collection_information_id_seq");
				ret = true;
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			m_error_string = "Unable to add the collection. The data may be invalid.";
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
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the Description is a text area, need to limit characters
				if (m_description.length() > 4000) m_description = m_description.substring(0, 3999);

				// As the Comments is a text area, need to limit characters
				if (m_comments.length() > 4000) m_comments = m_comments.substring(0, 3999);

				// As the Related Sources is a text area, need to limit
				// characters
				if (m_related_sources.length() > 4000) m_related_sources = m_related_sources.substring(0, 3999);

				m_date_updated = new Date();
				sqlString = "UPDATE collection_information set " + "entity = " + m_entity + " , " + "date_updated = " + m_db.safeDateFormat(m_date_updated, false) + ", "
						+ "collection_name = '" + m_db.plSqlSafeString(m_collection_name) + "', " + "description = '" + m_db.plSqlSafeString(m_description) + "', "
						+ "collection_size = '" + m_db.plSqlSafeString(m_size) + "', " + "location = '" + m_db.plSqlSafeString(m_location) + "', " + "collection_access = "
						+ m_db.plSqlSafeString(m_access) + " , " + "access_other_detail = '" + m_db.plSqlSafeString(m_access_other_detail) + "', " + "related_sources = '"
						+ m_db.plSqlSafeString(m_related_sources) + "', " + "comments = '" + m_db.plSqlSafeString(m_comments) + "'  " + "where collection_information_id = "
						+ m_collection_information_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to update the collection. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Removes this object from the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: None
	 */
	public void delete() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			String ret;

			sqlString = "DELETE from collection_information WHERE collection_information_id=" + m_db.plSqlSafeString(m_collection_information_id);
			m_db.runSQL(sqlString, stmt);
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in delete().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified Collection is in use in the
	 * database.
	 * 
	 * Parameters: p_id : id of the record
	 * 
	 * Returns: True if the collection is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		try {
			// WWW_Information
			// Not concerned about Web Links - when Collection is deleted, all
			// Web Link records
			// for the Connection will also be deleted.

			// MaterialLink
			// Not concerned about Materials - when Collection is deleted, all
			// MaterialLink records
			// for the Connection will also be deleted.
			return false;
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in checkInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return false;
		}
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
		if (m_collection_name.equals("")) {
			m_error_string = "Unable to add the collection. Collection name is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: getCollections ()
	 * 
	 * Purpose: Returns a record set with all of the collection information in
	 * it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getCollections(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM collection_information order by collection_name";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getCollections().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	public CachedRowSet getCollectionsWithEntity() {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT collection_information.*, entity.name " + "FROM collection_information, entity " + "where entity.entity_id=collection_information.entity "
					+ "order by collection_information.collection_name";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getCollectionsWithEntity().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	public void setCollectionInformationId(String s) {
		m_collection_information_id = s;
	}

	public void setEntity(String s) {
		m_entity = s;
	}

	public void setDateEntered(Date d) {
		m_date_entered = d;
	}

	public void setDateUpdated(Date d) {
		m_date_updated = d;
	}

	public void setInputPerson(String s) {
		m_input_person = s;
	}

	public void setCollectionName(String s) {
		m_collection_name = s;
	}

	public void setDescription(String s) {
		m_description = s;
	}

	public void setSize(String s) {
		m_size = s;
	}

	public void setLocation(String s) {
		m_location = s;
	}

	public void setAccess(String s) {
		m_access = s;
	}

	public void setAccessOtherDetail(String s) {
		m_access_other_detail = s;
	}

	public void setRelatedSources(String s) {
		m_related_sources = s;
	}

	public void setComments(String s) {
		m_comments = s;
	}

	public void setMaterials(String[] s) {
		m_materials = s;
	}

	public String getCollectionInformationId() {
		return m_collection_information_id;
	}

	public String getEntity() {
		return m_entity;
	}

	public Date getDateEntered() {
		return m_date_entered;
	}

	public Date getDateUpdated() {
		return m_date_updated;
	}

	public String getInputPerson() {
		return m_input_person;
	}

	public String getCollectionName() {
		return m_collection_name;
	}

	public String getDescription() {
		return m_description;
	}

	public String getSize() {
		return m_size;
	}

	public String getLocation() {
		return m_location;
	}

	public String getAccess() {
		return m_access;
	}

	public String getAccessOtherDetail() {
		return m_access_other_detail;
	}

	public String getRelatedSources() {
		return m_related_sources;
	}

	public String getComments() {
		return m_comments;
	}

	public String[] getMaterialsArray() {
		return m_materials;
	}

	public Vector getMaterialsVector() {
		Vector materialsVector = new Vector();
		if (m_materials != null) {
			for (int i = 0; i < m_materials.length; i++)
				materialsVector.add(new Integer(m_materials[i]));
		}
		return materialsVector;
	}

	public String getError() {
		return m_error_string;
	}
}

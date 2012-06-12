/***************************************************

Company: Ignition Design
 Author: Bill Malkin
Project: Centricminds

   File: Entity.java

Purpose: Provides Entity object functions.

 ***************************************************/

package ausstage;

import java.util.*;
import java.sql.Statement;
import ausstage.Database;
import sun.jdbc.rowset.*;

public class Entity {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	// All of the record information
	private int m_entity_id;
	private String m_input_person;
	private String m_type;
	private String m_name;
	private String m_address;
	private String m_city_suburb;
	private String m_stateid;
	private String m_postcode;
	private String m_contacts;
	private String m_phone;
	private String m_fax;
	private String m_email;
	private String m_www;
	private String m_error_string;

	/*
	 * Name: Entity ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Entity(ausstage.Database p_db) {
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
		m_entity_id = 0;
		m_input_person = "";
		m_type = "";
		m_name = "";
		m_address = "";
		m_city_suburb = "";
		m_stateid = "";
		m_postcode = "";
		m_contacts = "";
		m_phone = "";
		m_fax = "";
		m_email = "";
		m_www = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Entity information for the
	 * specified entity id.
	 * 
	 * Parameters: p_id : id of the entity record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM entity WHERE " + "entity_id=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_entity_id = l_rs.getInt("ENTITY_ID");
				m_type = Integer.toString(l_rs.getInt("TYPE"));
				m_name = l_rs.getString("NAME");
				m_address = l_rs.getString("ADDRESS");
				m_city_suburb = l_rs.getString("CITY_SUBURB");
				m_stateid = l_rs.getString("STATEID");
				m_postcode = l_rs.getString("POSTCODE");
				m_contacts = l_rs.getString("CONTACTS");
				m_phone = l_rs.getString("PHONE");
				m_fax = l_rs.getString("FAX");
				m_email = l_rs.getString("EMAIL");
				m_www = l_rs.getString("WWW");

				if (m_type == null) m_type = "";
				if (m_name == null) m_name = "";
				if (m_address == null) m_address = "";
				if (m_city_suburb == null) m_city_suburb = "";
				if (m_stateid == null) m_stateid = "";
				if (m_postcode == null) m_postcode = "";
				if (m_contacts == null) m_contacts = "";
				if (m_phone == null) m_phone = "";
				if (m_fax == null) m_fax = "";
				if (m_email == null) m_email = "";
				if (m_www == null) m_www = "";
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
	 * id of the new record in the m_entity_id member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the notes is a text area, need to limit characters
				sqlString = "INSERT INTO ENTITY (TYPE, DATE_ENTERED, INPUT_PERSON, NAME, ADDRESS, " + "CITY_SUBURB, STATEID, POSTCODE, CONTACTS, PHONE, FAX, EMAIL, WWW) VALUES ("
						+ "    "
						+ m_type
						+ " , "
						+ m_db.safeDateFormat(new Date(), false)
						+ " , '"
						+ m_db.plSqlSafeString(m_input_person)
						+ "', '"
						+ m_db.plSqlSafeString(m_name)
						+ "', '"
						+ m_db.plSqlSafeString(m_address)
						+ "', '"
						+ m_db.plSqlSafeString(m_city_suburb)
						+ "',  "
						+ Integer.parseInt(m_stateid)
						+ " , '"
						+ m_db.plSqlSafeString(m_postcode)
						+ "', '"
						+ m_db.plSqlSafeString(m_contacts)
						+ "', '"
						+ m_db.plSqlSafeString(m_phone)
						+ "', '"
						+ m_db.plSqlSafeString(m_fax) + "', '" + m_db.plSqlSafeString(m_email) + "', '" + m_db.plSqlSafeString(m_www) + "')";
				m_db.runSQL(sqlString, stmt);

				// Get the inserted index
				m_entity_id = Integer.parseInt(m_db.getInsertedIndexValue(stmt, "entity_id_seq"));
				ret = true;
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			m_error_string = "Unable to add the entity. The data may be invalid.";
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
	 * Returns: True if successfull, else false
	 */
	public boolean update() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				sqlString = "UPDATE ENTITY set " + "TYPE= " + m_type + " , " + "DATE_UPDATED=" + m_db.safeDateFormat(new Date(), false) + ", " + "NAME='"
						+ m_db.plSqlSafeString(m_name) + "', " + "ADDRESS='" + m_db.plSqlSafeString(m_address) + "', " + "CITY_SUBURB='" + m_db.plSqlSafeString(m_city_suburb)
						+ "', " + "STATEID=" + Integer.parseInt(m_stateid) + ", " + "POSTCODE='" + m_db.plSqlSafeString(m_postcode) + "', " + "PHONE='"
						+ m_db.plSqlSafeString(m_phone) + "', " + "FAX='" + m_db.plSqlSafeString(m_fax) + "', " + "EMAIL='" + m_db.plSqlSafeString(m_email) + "', " + "WWW='"
						+ m_db.plSqlSafeString(m_www) + "' " + "where entity_id=" + m_entity_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to update the entity. The data may be invalid.";
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

			sqlString = "DELETE from ENTITY WHERE entity_id=" + m_entity_id;
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
	 * Purpose: Checks to see if the specified Entity is in use in the database.
	 * 
	 * Parameters: p_id : id of the entity record
	 * 
	 * Returns: True if the entity is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = false;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM collection_information WHERE " + "entity=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) ret = true;
			l_rs.close();
			stmt.close();
			return (ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in checkInUse().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (ret);
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
		if (m_name.equals("")) {
			m_error_string = "Entity name is required.";
			l_ret = false;
		}

		// Default
		if (m_postcode.equals("")) m_postcode = "0";

		return (l_ret);
	}

	/*
	 * Name: getEntities ()
	 * 
	 * Purpose: Returns a record set with all of the entity information in it.
	 * 
	 * Parameters: p_stmt : Database statement
	 * 
	 * Returns: A record set.
	 */
	public CachedRowSet getEntities(Statement p_stmt) {
		CachedRowSet l_rs;
		String sqlString;
		String l_ret;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM entity order by name";
			l_rs = m_db.runSQL(sqlString, stmt);
			stmt.close();
			return (l_rs);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in getEntities().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (null);
		}
	}

	public void setInputPerson(String s) {
		m_input_person = s;
	}

	public void setType(String s) {
		m_type = s;
	}

	public void setName(String s) {
		m_name = s;
	}

	public void setAddress(String s) {
		m_address = s;
	}

	public void setCitySuburb(String s) {
		m_city_suburb = s;
	}

	public void setStateid(String s) {
		m_stateid = s;
	}

	public void setContacts(String s) {
		m_contacts = s;
	}

	public void setPostcode(String s) {
		m_postcode = s;
	}

	public void setPhone(String s) {
		m_phone = s;
	}

	public void setFax(String s) {
		m_fax = s;
	}

	public void setEmail(String s) {
		m_email = s;
	}

	public void setWWW(String s) {
		m_www = s;
	}

	public int getEntityId() {
		return (m_entity_id);
	}

	public String getInputPerson() {
		return (m_input_person);
	}

	public String getType() {
		return (m_type);
	}

	public String getName() {
		return (m_name);
	}

	public String getAddress() {
		return (m_address);
	}

	public String getCitySuburb() {
		return (m_city_suburb);
	}

	public String getStateid() {
		return (m_stateid);
	}

	public String getPostcode() {
		return (m_postcode);
	}

	public String getContacts() {
		return (m_contacts);
	}

	public String getPhone() {
		return (m_phone);
	}

	public String getFax() {
		return (m_fax);
	}

	public String getEmail() {
		return (m_email);
	}

	public String getWWW() {
		return (m_www);
	}

	public String getError() {
		return (m_error_string);
	}
}

/***************************************************

Company: Ignition Design
 Author: Justin Brown
Project: Centricminds

   File: Venue.java

Purpose: Provides Venue object functions.
2015 migration to github
 ***************************************************/

package ausstage;

import java.util.*;
import java.util.Date;
import java.sql.*;

import ausstage.Database;
import sun.jdbc.rowset.*;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

public class Venue {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	private final int INSERT = 0;
	private final int DELETE = 1;
	private final int UPDATE = 2;
	

	// All of the record information
	private String m_venue_id;
	private String m_venue_name;
	private String m_street;
	private String m_suburb;
	private String m_postcode;
	private String m_state_id;
	private String m_capacity;
	private String m_contact;
	private String m_phone;
	private String m_fax;
	private String m_email;
	private String m_web_links;
	private String m_notes;
	private String m_country;
	private String m_longitude;
	private String m_latitude;
	private String m_radius;
	private String m_elevation;
	private String m_regional_or_metro;
	private String m_error_string;
	private String m_entered_by_user;
	private Date m_entered_date;
	private String m_updated_by_user;
	private Date m_updated_date;
	private boolean m_is_in_copy_mode;
	private String m_ddfirst_date;
	private String m_mmfirst_date;
	private String m_yyyyfirst_date;
	private String m_ddlast_date;
	private String m_mmlast_date;
	private String m_yyyylast_date;
	private String m_other_names1;
	private String m_other_names2;
	private String m_other_names3;

	private Vector<VenueVenueLink> m_venue_venuelinks;

	/*
	 * Name: Venue ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Venue(ausstage.Database m_db2) {
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
		m_venue_id = "";
		m_venue_name = "";
		m_street = "";
		m_suburb = "";
		m_postcode = "";
		m_state_id = "";
		m_capacity = "";
		m_contact = "";
		m_phone = "";
		m_fax = "";
		m_email = "";
		m_web_links = "";
		m_notes = "";
		m_country = "";
		m_error_string = "";
		m_longitude = "";
		m_latitude = "";
		m_radius = "";
		m_elevation = "";
		m_regional_or_metro = "";
		m_entered_by_user = "";
		m_updated_by_user = "";
		m_venue_venuelinks = new Vector<VenueVenueLink>();
		m_is_in_copy_mode = false;
		m_ddfirst_date = "";
		m_mmfirst_date = "";
		m_yyyyfirst_date = "";
		m_ddlast_date = "";
		m_mmlast_date = "";
		m_yyyylast_date = "";
		m_other_names1 = "";
		m_other_names2 = "";
		m_other_names3 = "";
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a contain the Venue information for the
	 * specified venue id.
	 * 
	 * Parameters: p_id : id of the venue record
	 * 
	 * Returns: None
	 */
	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			sqlString = "SELECT * FROM venue WHERE " + "venueid=" + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);
			if (l_rs.next()) {
				// Reset the object
				initialise();

				// Setup the new data
				m_venue_id = l_rs.getString("VENUEID");
				m_venue_name = l_rs.getString("VENUE_NAME");
				m_street = l_rs.getString("STREET");
				m_suburb = l_rs.getString("SUBURB");
				m_postcode = l_rs.getString("POSTCODE");
				m_state_id = l_rs.getString("STATE");
				m_capacity = l_rs.getString("CAPACITY");
				m_contact = l_rs.getString("CONTACT");
				m_phone = l_rs.getString("PHONE");
				m_fax = l_rs.getString("FAX");
				m_email = l_rs.getString("EMAIL");
				m_web_links = l_rs.getString("WEB_LINKS");
				m_notes = l_rs.getString("NOTES");
				m_country = l_rs.getString("COUNTRYID");
				m_longitude = l_rs.getString("LONGITUDE");
				m_latitude = l_rs.getString("LATITUDE");
				m_radius = l_rs.getString("RADIUS");
				m_elevation = l_rs.getString("ELEVATION");
				m_regional_or_metro = l_rs.getString("REGIONAL_OR_METRO");
				m_entered_by_user = l_rs.getString("entered_by_user");
				m_entered_date = l_rs.getDate("entered_date");
				m_updated_by_user = l_rs.getString("updated_by_user");
				m_updated_date = l_rs.getDate("updated_date");
				m_ddfirst_date = l_rs.getString("ddfirst_date");
				m_mmfirst_date = l_rs.getString("mmfirst_date");
				m_yyyyfirst_date = l_rs.getString("yyyyfirst_date");
				m_ddlast_date = l_rs.getString("ddlast_date");
				m_mmlast_date = l_rs.getString("mmlast_date");
				m_yyyylast_date = l_rs.getString("yyyylast_date");
				m_other_names1 = l_rs.getString("other_names1");
				m_other_names2 = l_rs.getString("other_names2");
				m_other_names3 = l_rs.getString("other_names3");

				
				if (m_venue_name == null) m_venue_name = "";
				if (m_street == null) m_street = "";
				if (m_suburb == null) m_suburb = "";
				if (m_postcode == null) m_postcode = "";
				if (m_contact == null) m_contact = "";
				if (m_phone == null) m_phone = "";
				if (m_fax == null) m_fax = "";
				if (m_email == null) m_email = "";
				if (m_web_links == null) m_web_links = "";
				if (m_notes == null) m_notes = "";
				if (m_capacity == null) m_capacity = "";
				if (m_country == null) m_country = "";
				if (m_longitude == null) m_longitude = "";
				if (m_latitude == null) m_latitude = "";
				if (m_radius == null) m_radius = ""; 
				if (m_elevation == null) m_elevation = "";
				if (m_regional_or_metro == null) m_regional_or_metro = "";
				if (m_entered_by_user == null) m_entered_by_user = "";
				if (m_entered_date == null) m_entered_date = new Date();
				if (m_updated_date == null) m_updated_date = new Date();
				if (m_updated_by_user == null) m_updated_by_user = "";
				if (m_ddfirst_date == null) m_ddfirst_date = "";
				if (m_mmfirst_date == null) m_mmfirst_date = "";
				if (m_yyyyfirst_date == null) m_yyyyfirst_date = "";
				if (m_ddlast_date == null) m_ddlast_date = "";
				if (m_mmlast_date == null) m_mmlast_date = "";
				if (m_yyyylast_date == null) m_yyyylast_date = "";
				if (m_other_names1 == null) m_other_names1 = "";
				if (m_other_names2 == null) m_other_names2 = "";
				if (m_other_names3 == null) m_other_names3 = "";
				
				loadLinkedVenues();
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

	public void setDb(ausstage.Database p_db) {
		m_db = p_db;
	}

	/*public Vector<Venue> getVenues() {
		Vector<Venue> venues = new Vector<Venue>();
		for (VenueVenueLink vvl : m_venue_venuelinks) {
			Venue venue = new Venue(m_db);
			venue.load(Integer.parseInt(vvl.getChildId()));
			venues.add(venue);
		}
		return venues;
	}*/
	public Vector<Venue> getVenues() {
		Vector<Venue> venues = new Vector<Venue>();
		for (VenueVenueLink vvl : m_venue_venuelinks) {
			Venue venue = new Venue(m_db);
			venue.load(Integer.parseInt((m_venue_id.equals(vvl.getChildId()))? vvl.getVenueId(): vvl.getChildId()));
			venues.add(venue);
		}
		return venues;
	}
	/*
	 * Name: add ()
	 * 
	 * Purpose: Adds this object to the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the add was successful, else false. Also fills out the
	 * id of the new record in the m_venue_id member.
	 */
	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean ret = false;

			String strCapacity = "";
			if (m_capacity.equals("null") || m_capacity.equals("")) {
				strCapacity = "null";
			} else {
				strCapacity = Integer.toString(Integer.parseInt(m_capacity));
			}
			// System.out.println("In insert:");
			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the notes is a text area, need to limit characters
				if (m_notes.length() >= 300) m_notes = m_notes.substring(0, 299);
				sqlString = "INSERT INTO VENUE (VENUE_NAME, OTHER_NAMES1, OTHER_NAMES2, OTHER_NAMES3, "
						+ "STREET, SUBURB, POSTCODE, STATE, CAPACITY, CONTACT, PHONE, "
						+ "FAX, EMAIL, WEB_LINKS, NOTES, COUNTRYID, entered_by_user, entered_date, ddfirst_date, mmfirst_date, yyyyfirst_date, ddlast_date, mmlast_date, yyyylast_date ";
				if (!m_longitude.equals("")) sqlString += ",LONGITUDE ";
				if (!m_latitude.equals("")) sqlString += ",LATITUDE ";
				if (!m_radius.equals("")) sqlString += ",RADIUS ";
				if (!m_elevation.equals("")) sqlString += ",ELEVATION ";

				sqlString += ") VALUES (" + "'" + m_db.plSqlSafeString(m_venue_name) + "',"
						  + "'" + m_db.plSqlSafeString(m_other_names1)+ "',"
						  + "'" + m_db.plSqlSafeString(m_other_names2)+ "',"
						  + "'" + m_db.plSqlSafeString(m_other_names3)+ "',"
						  + "'" + m_db.plSqlSafeString(m_street) + "','" + m_db.plSqlSafeString(m_suburb) + "','"
						+ m_db.plSqlSafeString(m_postcode) + "'," + Integer.parseInt(m_state_id) + "," + strCapacity + "," + "'" + m_db.plSqlSafeString(m_contact) + "','"
						+ m_db.plSqlSafeString(m_phone) + "'," + "'" + m_db.plSqlSafeString(m_fax) + "','" + m_db.plSqlSafeString(m_email) + "'," + "'"
						+ m_db.plSqlSafeString(m_web_links) + "','" + m_db.plSqlSafeString(m_notes) + "'," + m_country + "," + "'" + m_db.plSqlSafeString(m_entered_by_user)
						+ "', NOW(),'" + m_db.plSqlSafeString(m_ddfirst_date) + "', " + "'" + m_db.plSqlSafeString(m_mmfirst_date) + "', " + "'"
						+ m_db.plSqlSafeString(m_yyyyfirst_date) + "', " + "'" + m_db.plSqlSafeString(m_ddlast_date) + "', " + "'" + m_db.plSqlSafeString(m_mmlast_date) + "', "
						+ "'" + m_db.plSqlSafeString(m_yyyylast_date) + "'";
				if (!m_longitude.equals("")) sqlString += ",'" + m_longitude + "'";
				if (!m_latitude.equals("")) sqlString += ",'" + m_latitude + "'";
				if (!m_radius.equals("")) sqlString += ",'" + m_radius + "'";
				if (!m_elevation.equals("")) sqlString += ",'" + m_elevation + "'";
				// System.out.println("SQL completed: "+ sqlString);

				sqlString += ")";
				m_db.runSQL(sqlString, stmt);

				// Get the inserted index
				m_venue_id = m_db.getInsertedIndexValue(stmt, "venueid_seq");
				// System.out.println("Venue ID inserted:" + m_venue_id);
				// m_eventid = m_db.getInsertedIndexValue(stmt, "eventid_seq");
				ret = true;

				modifyVenueVenueLinks(INSERT);
			}
			stmt.close();
			return (ret);
		} catch (Exception e) {
			// System.out.println("Insert exception");
			m_error_string = "Unable to add the venue. The data may be invalid.";
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
			// System.out.println("In update");

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the notes is a text area, need to limit characters
				if (m_notes.length() >= 300) m_notes = m_notes.substring(0, 299);

				String strCapacity = "";
				if (m_capacity.equals("null")) {
					strCapacity = m_capacity;
				} else {
					strCapacity = Integer.toString(Integer.parseInt(m_capacity));
				}

				sqlString = "UPDATE VENUE set VENUE_NAME='" + m_db.plSqlSafeString(m_venue_name) + "', "
						+ "OTHER_NAMES1 ='" + m_db.plSqlSafeString(m_other_names1)+ "',"
						+ "OTHER_NAMES2 ='" + m_db.plSqlSafeString(m_other_names2)+ "',"
						+ "OTHER_NAMES3 ='" + m_db.plSqlSafeString(m_other_names3)+ "',"
						+ "STREET='" + m_db.plSqlSafeString(m_street) + "', " + "SUBURB='"
						+ m_db.plSqlSafeString(m_suburb) + "', STATE=" + Integer.parseInt(m_state_id) + ", " + "POSTCODE='" + m_db.plSqlSafeString(m_postcode) + "',"
						+ " updated_BY_USER = '" + m_db.plSqlSafeString(m_updated_by_user) + "'" + ", updated_DATE =  now()  " + ",CAPACITY=" + strCapacity + " , CONTACT='"
						+ m_db.plSqlSafeString(m_contact) + "', " + "PHONE='" + m_db.plSqlSafeString(m_phone) + "', FAX='" + m_db.plSqlSafeString(m_fax) + "', EMAIL='"
						+ m_db.plSqlSafeString(m_email) + "', " + "WEB_LINKS='" + m_db.plSqlSafeString(m_web_links) + "', NOTES='" + m_db.plSqlSafeString(m_notes)
						+ "', COUNTRYID=" + m_country + ", " + "ddfirst_date= '" + m_db.plSqlSafeString(m_ddfirst_date) + "'," + "mmfirst_date= '"
						+ m_db.plSqlSafeString(m_mmfirst_date) + "'," + "yyyyfirst_date= '" + m_db.plSqlSafeString(m_yyyyfirst_date) + "'," + "ddlast_date= '"
						+ m_db.plSqlSafeString(m_ddlast_date) + "'," + "mmlast_date= '" + m_db.plSqlSafeString(m_mmlast_date) + "'," + "yyyylast_date= '"
						+ m_db.plSqlSafeString(m_yyyylast_date) + "'";

				if (m_longitude.equals(""))
					sqlString += ",LONGITUDE=null ";
				else
					sqlString += ",LONGITUDE='" + m_longitude + "' ";
				if (m_latitude.equals(""))
					sqlString += ",LATITUDE=null ";
				else
					sqlString += ",LATITUDE='" + m_latitude + "' ";
				if (m_radius.equals(""))
					sqlString += ",RADIUS=null ";
				else
					sqlString += ",RADIUS='" + m_radius + "' ";
				if (m_elevation.equals(""))
					sqlString += ",ELEVATION=null ";
				else
					sqlString += ",ELEVATION='" + m_elevation + "' ";
				if (m_regional_or_metro != null && !m_regional_or_metro.equals("")) {
					sqlString += ",REGIONAL_OR_METRO='" + m_regional_or_metro + "' ";
				} else {
					sqlString += ",REGIONAL_OR_METRO=null ";
				}

				sqlString += "where venueid=" + m_venue_id;
				m_db.runSQL(sqlString, stmt);
				l_ret = true;
				modifyVenueVenueLinks(UPDATE);
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = e.getMessage();
			// m_error_string =
			// "Unable to update the venue. The data may be invalid.";
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

			modifyVenueVenueLinks(DELETE);
			
			
			sqlString = "DELETE from VENUE WHERE venueid=" + m_venue_id;
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
	 * Purpose: Checks to see if the specified Venue is in use in the database.
	 * 
	 * Parameters: p_id : id of the venue record
	 * 
	 * Returns: True if the venue is in use, else false
	 */
	public boolean checkInUse(int p_id) {
		CachedRowSet l_rs;
		String sqlString;
		boolean ret = false;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM events WHERE " + "venueid=" + p_id;
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
		CachedRowSet l_rs;
		String sqlString;

		try {
			Statement stmt = m_db.m_conn.createStatement();
			// System.out.println("1");
			// Must have a name
			if (m_venue_name != null && m_venue_name.equals("")) {
				m_error_string = "Venue name is required.";
				l_ret = false;
			}
			/*
			 * // Postcode must be a number if(!
			 * admin.Common.checkIfNumber(m_postcode)){ m_error_string =
			 * "Postcode must be a number."; l_ret = false; }
			 */
			// System.out.println("2");
			// Default
			if (m_capacity.equals("")) m_capacity = "null";

			// Check to see if a Venue record exists (same name and state)
			sqlString = "select venueid from venue where venue_name='" 
						+ m_db.plSqlSafeString(m_venue_name) 
						+ "' and state=" + m_state_id 
						+ " and suburb='" + m_db.plSqlSafeString(m_suburb) 
						+ "' and venueid!=" + (m_venue_id.equals("") ? "0" : m_venue_id);
			System.out.println(sqlString);
			l_rs = m_db.runSQL(sqlString, stmt);
			// System.out.println("3 Query executed");
			if (l_rs.next()) {
				m_error_string = "A venue with that name and suburb in that state already exists.";
				l_ret = false;
			}
			l_rs.close();
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.validateObjectForDB().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (l_ret);
		}
	}

	public void setName(String p_name) {
		m_venue_name = p_name;
	}

	public void setOtherNames1(String p_name) {
		m_other_names1 = p_name;
	}
	public void setOtherNames2(String p_name) {
		m_other_names2 = p_name;
	}
	public void setOtherNames3(String p_name) {
		m_other_names3 = p_name;
	}
	
	
	public void setStreet(String p_street) {
		m_street = p_street;
	}

	public void setSuburb(String p_suburb) {
		m_suburb = p_suburb;
	}

	public void setPostcode(String p_postcode) {
		m_postcode = p_postcode;
	}

	public void setState(String p_state) {
		m_state_id = p_state;
	}

	public void setContact(String p_contact) {
		m_contact = p_contact;
	}

	public void setCapacity(String p_capacity) {
		m_capacity = p_capacity;
	}

	public void setPhone(String p_phone) {
		m_phone = p_phone;
	}

	public void setFax(String p_fax) {
		m_fax = p_fax;
	}

	public void setEmail(String p_email) {
		m_email = p_email;
	}

	public void setWebLinks(String p_weblinks) {
		m_web_links = p_weblinks;
	}

	public void setNotes(String p_notes) {
		m_notes = p_notes;
	}

	public void setCountry(String p_country) {
		m_country = p_country;
	}

	public void setLongitude(String p_longitude) {
		m_longitude = p_longitude;
	}

	public void setLatitude(String p_latitude) {
		m_latitude = p_latitude;
	}

	public void setRadius(String p_radius) {
		m_radius = p_radius;
	}

	public void setElevation(String p_elevation) {
		m_elevation = p_elevation;
	}

	public void setRegionalOrMetro(String p_regional_or_metro) {
		m_regional_or_metro = p_regional_or_metro;
	}

	public void setVenueId(String p_venue_id) {
		m_venue_id = p_venue_id;
	}

	public void setEnteredByUser(String p_user_name) {
		m_entered_by_user = p_user_name;
	}

	public void setUpdatedByUser(String p_user_name) {
		m_updated_by_user = p_user_name;
	}

	public void setVenueVenueLinks(Vector<VenueVenueLink> p_venue_venuelinks) {
		m_venue_venuelinks = p_venue_venuelinks;
	}

	public void setDdfirstDate(String p_ddfirst_date) {
		m_ddfirst_date = p_ddfirst_date;
	}

	public void setMmfirstDate(String p_mmfirst_date) {
		m_mmfirst_date = p_mmfirst_date;
	}

	public void setYyyyfirstDate(String p_yyyyfirst_date) {
		m_yyyyfirst_date = p_yyyyfirst_date;
	}

	public void setDdlastDate(String p_ddlast_date) {
		m_ddlast_date = p_ddlast_date;
	}

	public void setMmlastDate(String p_mmlast_date) {
		m_mmlast_date = p_mmlast_date;
	}

	public void setYyyylastDate(String p_yyyylast_date) {
		m_yyyylast_date = p_yyyylast_date;
	}

	// ////////Get Functions//////////////////

	public String getName() {
		return (m_venue_name);
	}
	
	public String getOtherNames1() {
		return (m_other_names1);
	}
	
	public String getOtherNames2() {
		return (m_other_names2);
	}
	
	public String getOtherNames3() {
		return (m_other_names3);
	}

	public String getStreet() {
		return (m_street);
	}

	public String getSuburb() {
		return (m_suburb);
	}

	public String getPostcode() {
		return (m_postcode);
	}

	public String getState() {
		return (m_state_id);
	}

	public String getCapacity() {
		return (m_capacity);
	}

	public String getContact() {
		return (m_contact);
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

	public String getWebLinks() {
		return (m_web_links);
	}

	public String getNotes() {
		return (m_notes);
	}

	public String getLongitude() {
		return (m_longitude);
	}

	public String getLatitude() {
		return (m_latitude);
	}

	public String getRadius() {
		return (m_radius);
	}

	public String getElevation() {
		return (m_elevation);
	}

	public String getRegionalOrMetro() {
		return (m_regional_or_metro);
	}

	public String getVenueId() {
		return (m_venue_id);
	}

	public String getCountry() {
		return (m_country);
	}

	public String getError() {
		return (m_error_string);
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

	public Vector<Venue> getAssociatedVenues() {
		return getVenues();
	}

	public Vector<VenueVenueLink> getVenueVenueLinks() {
		return m_venue_venuelinks;
	}

	public String getDdfirstDate() {
		return (m_ddfirst_date);
	}

	public String getMmfirstDate() {
		return (m_mmfirst_date);
	}

	public String getYyyyfirstDate() {
		return (m_yyyyfirst_date);
	}

	public String getDdlastDate() {
		return (m_ddlast_date);
	}

	public String getMmlastDate() {
		return (m_mmlast_date);
	}

	public String getYyyylastDate() {
		return (m_yyyylast_date);
	}

	// //////////////////////
	// Utility methods
	// //////////////////////

	public String	getVenueInfoForVenueDisplay(int p_venue_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;
		try {

			sqlString = "select venueid, venue_name, street , suburb ,states.state as state,country.countryname, "
					//+ "CONCAT_WS(', ',venue.venue_name,venue.street,venue.suburb,IF(states.state='O/S', country.countryname, states.state)) AS OUTPUT "
					+ "CONCAT_WS(', ',venue.venue_name,venue.suburb,IF(states.state='O/S', country.countryname, states.state)) AS OUTPUT "
					+ "from venue "
					+ "LEFT Join states on (venue.state = states.stateid) " + "LEFT join country on (venue.countryid = country.countryid) " 
					+ "WHERE venueid=" + p_venue_id + " "
					+ "ORDER BY venue_name DESC";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("OUTPUT");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.getVenueInfoForVenueDisplay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);
	}

	public String getVenueInfoForItemDisplay(int p_venue_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT DISTINCT concat_ws(', ', venue.venue_name, venue.street, venue.suburb, states.state) as display_info " + "FROM venue, states "
					+ "WHERE venue.venueid=" + p_venue_id + " " + "AND venue.state = states.stateid";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("display_info");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.getVenueInfoForItemDislay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public ResultSet getVenuesByItem(int p_venue_id, Statement p_stmt) {
		String sqlString = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT DISTINCT venue.venueid, venue_name " + "FROM venue, itemvenuelink " + "WHERE itemvenuelink.venueid=" + p_venue_id + " "
					+ "AND itemvenuelink.venueid = venue.venueid " + "ORDER BY venue_name DESC";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.getVenuesByItem().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	/*************************************************************************
	 * this method is used for passing in a vector containing id strings of the
	 * relevent object. i.e eventids, contributor ids etc. It then appends the
	 * appropriate display info to the id as a string. Such that when used in
	 * the displayLinkedItem method from item_addedit.jsp it has all the
	 * information as a string per element ready to be displayed.
	 **************************************************************************/
	public Vector generateDisplayInfo(Vector p_ids, String p_id_type, Statement p_stmt) {
		Vector l_display_info = new Vector();
		String l_info_to_add = "";
		String l_id = "";
		;

		for (int i = 0; i < p_ids.size(); i++) {

			if (p_id_type.equals("venue")) {
				Venue venue = new Venue(m_db);
				l_id = m_venue_venuelinks.elementAt(i) + "";
				l_info_to_add = venue.getVenueInfoForItemDisplay(Integer.parseInt(l_id), p_stmt);
				l_display_info.add(l_info_to_add);
			}

		}
		return l_display_info;
	}

	/*
	 * Name: setItemAttributes (HttpServletRequest request)
	 * 
	 * Purpose: Sets the attributes in this object from the request.
	 * 
	 * Parameters: request - The request received by the current page.
	 * 
	 * Returns: None.
	 */

	public void setVenueAttributes(HttpServletRequest request) {
		// Calendar calendar;
		// String day = "";
		// String month = "";
		// String year = "";

		this.m_venue_id = request.getParameter("f_venue_id");
		if (m_venue_id == null) m_venue_id = "0";
		this.m_venue_name = request.getParameter("f_venue_name");
		if (m_venue_name == null) m_venue_name = "";
		this.m_street = request.getParameter("f_street");
		if (m_street == null) m_street = "";
		this.m_suburb = request.getParameter("f_suburb");
		if (this.m_suburb == null) this.m_suburb = "";
		this.m_postcode = request.getParameter("f_postcode");
		if (m_postcode == null) m_postcode = "";
		this.m_state_id = request.getParameter("f_state_id");
		if (m_state_id == null) m_state_id = "";
		this.m_capacity = request.getParameter("f_capacity");
		if (m_capacity == null) m_capacity = "";
		this.m_contact = request.getParameter("f_contact");
		if (m_contact == null) m_contact = "";
		this.m_phone = request.getParameter("f_phone");
		if (m_phone == null) m_phone = "";
		this.m_fax = request.getParameter("f_fax");
		if (m_fax == null) m_fax = "";
		this.m_email = request.getParameter("f_email");
		if (m_email == null) m_email = "";
		this.m_web_links = request.getParameter("f_web_links");
		if (m_web_links == null) m_web_links = "";
		this.m_country = request.getParameter("f_country");
		if (m_country == null) m_country = "";
		this.m_longitude = request.getParameter("f_longitude");
		if (m_longitude == null) m_longitude = "";
		this.m_latitude = request.getParameter("f_latitude");
		if (m_latitude == null) m_latitude = "";
		this.m_radius = request.getParameter("f_radius");
		if (m_radius == null) m_radius = "";
		this.m_elevation = request.getParameter("f_elevation");
		if (m_elevation == null) m_elevation = "";
		this.m_notes = request.getParameter("f_notes");
		if (m_notes == null) m_notes = "";
		// this.m_error_string = request.getParameter("f_error_string");
		// if (m_error_string == null)
		// m_error_string = "";
		// this.m_entered_by_user = request.getParameter("f_entered_by_user");
		// if (m_entered_by_user == null)
		// m_entered_by_user = "";
		// this.m_entered_date = request.getParameter("f_entered_date");
		// if (m_entered_date == null)
		// m_entered_date = "";
		// this.m_updated_by_user = request.getParameter("f_updated_by_user");
		// if (m_updated_by_user == null)
		// m_updated_by_user = "";
		// this.m_updated_date = request.getParameter("m_updated_date");
		// if (m_updated_date == null)
		// m_updated_date = "";

		this.m_ddfirst_date = request.getParameter("f_first_date_day");
		if (m_ddfirst_date == null) m_ddfirst_date = "";
		this.m_mmfirst_date = request.getParameter("f_first_date_month");
		if (m_mmfirst_date == null) m_mmfirst_date = "";
		this.m_yyyyfirst_date = request.getParameter("f_first_date_year");
		if (m_yyyyfirst_date == null) m_yyyyfirst_date = "";
		this.m_ddlast_date = request.getParameter("f_last_date_day");
		if (m_ddlast_date == null) m_ddlast_date = "";
		this.m_mmlast_date = request.getParameter("f_last_date_month");
		if (m_mmlast_date == null) m_mmlast_date = "";
		this.m_yyyylast_date = request.getParameter("f_last_date_year");
		if (m_yyyylast_date == null) m_yyyylast_date = "";

		// check to see if we are copying a current venue
		if (request.getParameter("action") != null && !request.getParameter("action").equals("") && request.getParameter("action").equals("copy")) m_is_in_copy_mode = true;

	}

	/*
	 * Name: modifyVenueVenueLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyVenueVenueLinks(int modifyType) {
		try {
			VenueVenueLink temp_object = new VenueVenueLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_venue_id, m_venue_venuelinks);
				break;
			case DELETE:
				temp_object.deleteVenueVenueLinksForVenue(m_venue_id);
				break;
			case INSERT:
				for (VenueVenueLink vvl : m_venue_venuelinks){
					if (vvl.getChildId().equals("0")||vvl.getChildId().equals("")){
						vvl.setChildId(m_venue_id);
					}
					if (vvl.getVenueId().equals("0")||vvl.getVenueId().equals("")){
						vvl.setVenueId(m_venue_id);
					}
				}
				temp_object.add(m_venue_id, m_venue_venuelinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyVenueVenueLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadLinkedVenues ()
	 * 
	 * Purpose: Sets the class to a contain the Contributors information for the
	 * specified venue id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	private void loadLinkedVenues() {
		try {
			VenueVenueLink venueVenueLink = new VenueVenueLink(m_db);
			m_venue_venuelinks = venueVenueLink.getVenueVenueLinksForVenue(Integer.parseInt(m_venue_id));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedVenues().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: getAccociatedItems (int p_venue_id)
	 * 
	 * Purpose: Find any items that are associated to a venue.
	 * 
	 * Parameters: p_venue_id - The id of the venue.
	 * 
	 * Returns: A ResultSet with item information if the venue is found to be
	 * accociated.
	 */

	public ResultSet getAssociatedItems(int p_venue_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT DISTINCT item.CITATION,item.ITEMID,venue.VENUE_NAME,venue.venueid, lookup_codes.description  " + " FROM item "
					+ " LEFT JOIN lookup_codes ON (item.item_sub_type_lov_id = lookup_codes.code_lov_id)"
					+ " INNER JOIN itemvenuelink ON (item.ITEMID = itemvenuelink.ITEMID) " + " INNER JOIN venue ON (itemvenuelink.VENUEID = venue.VENUEID)"
					+ " WHERE itemvenuelink.venueid=" + p_venue_id + " " + " AND itemvenuelink.itemid = item.itemid ORDER BY lookup_codes.description, item.citation";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.getAccociatedItems().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

	}
	
public String getVenueEvtDateRange(int p_ven_id, Statement p_stmt) {
		
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT if(min(events.yyyyfirst_date) = greatest(max(events.yyyylast_date), max(events.yyyyfirst_date)),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', greatest(max(events.yyyylast_date),max(events.yyyyfirst_date)))) as OUTPUT "+ 
						"FROM venue LEFT JOIN events ON (venue.venueid = events.venueid) "+ 
						"WHERE venue.venueid = "+ p_ven_id;

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("OUTPUT");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Venue.getVenueEvtDateRange().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);
	}
	
}

/***************************************************

Company: Ignition Design
 Author: Justin Brown et al
Project: Centricminds

   File: Event.java

Purpose: Provides Event object functions.

 ***************************************************/

package

ausstage;

import java.sql.ResultSet;
import java.sql.Statement;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import sun.jdbc.rowset.CachedRowSet;

public class Event {
	private ausstage.Database m_db;
	private admin.AppConstants AppConstants = new admin.AppConstants();
	private admin.Common Common = new admin.Common();

	private final int INSERT = 0;
	private final int DELETE = 1;
	private final int UPDATE = 2;

	// All of the record information
	private boolean m_is_in_copy_mode;
	private String m_eventid;
	private String m_event_name;
	private String m_umbrella;
	private String m_venue_name;

	private String m_entered_by_user;
	private Date m_entered_date;
	private Date m_updated_date;
	private String m_updated_by_user = "";

	private String m_description;

	private boolean m_part_of_a_tour;
	private boolean m_world_premier;
	private boolean m_review;
	private boolean m_int_perf_history;
	// private boolean m_est_first_date;
	// private boolean m_est_last_date;
	// private boolean m_est_open_date;

	private String m_status;
	private String m_venueid;
	private String m_primary_genre;
	private String m_further_information;
	private String m_description_source;

	private String m_ddfirst_date;
	private String m_mmfirst_date;
	private String m_yyyyfirst_date;
	private String evDate;
	private Date m_first_date;

	private String m_ddlast_date;
	private String m_mmlast_date;
	private String m_yyyylast_date;
	private Date m_last_date;

	private String m_ddopen_date;
	private String m_mmopen_date;
	private String m_yyyyopen_date;
	private Date m_opening_night_date;

	private boolean m_estimated_dates;

	private String m_error_string;

	// Derived Objects
	private Venue m_venue;
	private Vector m_data_sources;
	private Vector m_secondary_genres;
	private Vector m_prim_content_indicator_evlinks;
	private Vector m_sec_content_indicator_evlinks;
	private Vector m_sec_genre_evlinks;
	private Vector m_con_evlinks;
	private Vector <EventEventLink> m_event_eventlinks;
	private Vector m_org_evlinks;
	private Vector m_organisations;
	private Vector m_works;
	private Vector m_play_origins;
	private Vector m_production_origins;
	private Vector m_res_evlinks;

	/**
	 * Name: Event ()
	 * 
	 * Purpose: Constructor.
	 * 
	 * Parameters: p_db : The database object
	 * 
	 * Returns: None
	 */
	public Event(ausstage.Database p_db) {
		m_db = p_db;
		initialise();
	}

	public CachedRowSet getEventsByVenue(int p_venue_id) {
		String sqlString = "";
		CachedRowSet crset = null;

		try {

			sqlString = "select eventid, event_name, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, first_date,date_format(STR_TO_DATE(CONCAT(events.ddfirst_date,' ',events.mmfirst_date,' ',events.yyyyfirst_date), '%d %m %Y'), '%e %M %Y') as evDate  "
					+ "from events where venueid=" + p_venue_id + " order by first_date desc";

			Statement stmt = m_db.m_conn.createStatement();
			crset = m_db.runSQL(sqlString, stmt);
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventsByVenue().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (crset);
	}

	public ResultSet getEventsByItem(int p_event_id, Statement p_stmt) {
		String sqlString = "";
		ResultSet l_rs = null;

		try {

			sqlString = "SELECT DISTINCT events.eventid, event_name, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, first_date"
					+ ", venue_name, suburb, states.state " + "FROM events, itemevlink, venue, states " + "WHERE itemevlink.eventid=" + p_event_id + " "
					+ "AND itemevlink.eventid = events.eventid " + "AND events.venueid=venue.venueid " + "AND venue.state=states.stateid "
					+ "ORDER BY first_date DESC, event_name ASC";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventsByItem().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);
	}

	public CachedRowSet getEventsByOrg(int p_org_id) {
		String sqlString = "";
		CachedRowSet crset = null;

		try {

			sqlString = "select distinct events.eventid, event_name, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, events.first_date, "
					+ "venue_name, suburb, states.state " + "from events, venue, states, orgevlink " + "where events.venueid=venue.venueid " + "and venue.state=states.stateid "
					+ "and events.eventid=orgevlink.eventid " + "and orgevlink.organisationid=" + p_org_id + " " + "order by events.first_date desc";

			Statement stmt = m_db.m_conn.createStatement();
			crset = m_db.runSQL(sqlString, stmt);
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventsByOrg().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (crset);
	}

	public CachedRowSet getEventsByContrib(int p_contrib_id) {
		String sqlString = "";
		CachedRowSet crset = null;

		try {

			sqlString = "select distinct events.eventid, events.event_name,  events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, events.first_date, "
					+ "venue.venue_name, venue.suburb, states.state, "
					+ "concat_ws(', ', venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state)) venue " 
					+ "from events, conevlink, contributor, states, venue " 
					+ "left join country on (venue.countryid = country.countryid) "
					+ "where contributor.contributorid=" + p_contrib_id + " " 
					+ "and contributor.contributorid=conevlink.contributorid " 
					+ "and conevlink.eventid=events.eventid " 
					+ "and events.venueid=venue.venueid "
					+ "and venue.state=states.stateid " 
					+ "order by events.first_date desc";

			Statement stmt = m_db.m_conn.createStatement();
			crset = m_db.runSQL(sqlString, stmt);
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventsByContrib().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (crset);
	}

	public CachedRowSet getEventsById(String p_event_id) {
		String sqlString = "";
		CachedRowSet crset = null;

		try {

			sqlString = "select events.*, ifnull(search_event.resource_flag, 'N') resource_flag from events left join search_event on events.eventid = search_event.eventid where events.eventid="
					+ p_event_id;

			Statement stmt = m_db.m_conn.createStatement();
			crset = m_db.runSQL(sqlString, stmt);
			stmt.close();

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventsByVenue().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (crset);
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
		m_eventid = "0";
		m_event_name = "";
		m_umbrella = "";

		m_entered_by_user = "";
		m_entered_date = new Date();
		m_updated_date = new Date();

		m_description = "";

		m_part_of_a_tour = false;
		m_world_premier = false;
		m_review = false;
		m_int_perf_history = false;

		m_is_in_copy_mode = false;

		m_status = "0";
		m_venueid = "0";
		m_primary_genre = "0";
		m_further_information = "";
		m_description_source = "0";
		m_updated_by_user = "";

		m_ddfirst_date = "";
		m_mmfirst_date = "";
		m_yyyyfirst_date = "";

		m_first_date = new Date();

		m_ddlast_date = "";
		m_mmlast_date = "";
		m_yyyylast_date = "";
		evDate = "";
		m_last_date = new Date();

		m_ddopen_date = "";
		m_mmopen_date = "";
		m_yyyyopen_date = "";
		m_opening_night_date = new Date();
		m_estimated_dates = false;

		// m_est_first_date = false;
		// m_est_last_date = false;
		// m_est_open_date = false;

		// Derived Objects
		m_venue = new Venue(m_db);
		m_data_sources = new Vector();
		m_secondary_genres = new Vector();
		m_prim_content_indicator_evlinks = new Vector();
		m_sec_content_indicator_evlinks = new Vector();
		m_sec_genre_evlinks = new Vector();
		m_con_evlinks = new Vector();
		m_event_eventlinks = new Vector<EventEventLink>();
		m_org_evlinks = new Vector();
		m_organisations = new Vector();
		m_works = new Vector();
		m_play_origins = new Vector();
		m_production_origins = new Vector();
		m_res_evlinks = new Vector();
	}

	/*
	 * Name: load ()
	 * 
	 * Purpose: Sets the class to a new event id and populates the object with
	 * the new event information.
	 * 
	 * Parameters: p_id : id of the event record
	 * 
	 * Returns: None
	 */

	public void load(int p_id) {
		CachedRowSet l_rs;
		String sqlString = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT * FROM events WHERE eventid = " + p_id;
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				m_eventid = l_rs.getString("eventid");
				m_event_name = l_rs.getString("event_name");
				m_umbrella = l_rs.getString("umbrella");

				m_entered_by_user = l_rs.getString("entered_by_user");
				m_updated_by_user = l_rs.getString("updated_by_user");
				m_entered_date = l_rs.getDate("entered_date");
				m_updated_date = l_rs.getDate("updated_date");

				m_description = l_rs.getString("description");
				m_world_premier = Common.convertYesNoToBool(l_rs.getString("world_premier"));
				m_review = Common.convertYesNoToBool(l_rs.getString("review"));
				m_int_perf_history = Common.convertYesNoToBool(l_rs.getString("interesting_perf_history"));
				m_part_of_a_tour = Common.convertYesNoToBool(l_rs.getString("part_of_a_tour"));
				m_status = l_rs.getString("status");
				m_venueid = l_rs.getString("venueid");
				m_primary_genre = l_rs.getString("primary_genre");
				m_further_information = l_rs.getString("further_information");
				m_description_source = l_rs.getString("description_source");

				m_ddfirst_date = l_rs.getString("ddfirst_date");
				m_mmfirst_date = l_rs.getString("mmfirst_date");
				m_yyyyfirst_date = l_rs.getString("yyyyfirst_date");
				m_first_date = l_rs.getDate("first_date");

				m_ddlast_date = l_rs.getString("ddlast_date");
				m_mmlast_date = l_rs.getString("mmlast_date");
				m_yyyylast_date = l_rs.getString("yyyylast_date");
				m_last_date = l_rs.getDate("last_date");

				m_ddopen_date = l_rs.getString("ddopening_night");
				m_mmopen_date = l_rs.getString("mmopening_night");
				m_yyyyopen_date = l_rs.getString("yyyyopening_night");
				m_opening_night_date = l_rs.getDate("opening_night_date");
				m_estimated_dates = Common.convertYesNoToBool(l_rs.getString("estimated_dates"));
				// m_est_first_date = Common.convertYesNoToBool (l_rs.getString
				// ("estimated_first_dates"));
				// m_est_last_date = Common.convertYesNoToBool (l_rs.getString
				// ("estimated_last_dates"));
				// m_est_open_date = Common.convertYesNoToBool (l_rs.getString
				// ("estimated_open_dates"));

				// Encode double quotes
				m_event_name = Common.formFieldEncode(m_event_name, "\"");
				m_description = Common.formFieldEncode(m_description, "\"");
				m_further_information = Common.formFieldEncode(m_further_information, "\"");
				m_umbrella = Common.formFieldEncode(m_umbrella, "\"");

				if (m_venueid.length() != 0) m_venue.load(Integer.parseInt(m_venueid));

				loadDatasources();
				loadSecGenreEvLinks();
				loadPrimContentIndicatorEvLinks();
				// loadSecContentIndicatorEvLinks ();
				loadConEvLinks();
				loadOrgEvLinks();
				loadEventEventLinks();
				loadWorkEvLinks();
				loadPlayOrigins();
				loadProductionOrigins();
				loadResourceEvLinks();

				if (m_event_name == null) m_event_name = "";
				if (m_umbrella == null) m_umbrella = "";
				if (m_entered_by_user == null) m_entered_by_user = "";
				if (m_updated_by_user == null) m_updated_by_user = "";
				if (m_description == null) m_description = "";
				if (m_status == null) m_status = "";
				if (m_venueid == null) m_venueid = "";
				if (m_primary_genre == null) m_primary_genre = "";
				if (m_further_information == null) m_further_information = "";
				if (m_description_source == null) m_description_source = "";

				if (m_ddfirst_date == null) m_ddfirst_date = "";
				if (m_mmfirst_date == null) m_mmfirst_date = "";
				if (m_yyyyfirst_date == null) m_yyyyfirst_date = "";

				if (m_ddlast_date == null) m_ddlast_date = "";
				if (m_mmlast_date == null) m_mmlast_date = "";
				if (m_yyyylast_date == null) m_yyyylast_date = "";

				if (m_ddopen_date == null) m_ddopen_date = "";
				if (m_mmopen_date == null) m_mmopen_date = "";
				if (m_yyyyopen_date == null) m_yyyyopen_date = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occurred in Event - load().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + sqlString);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	public void loadLinkedProperties(int p_event_id, String p_event_name, Date p_first_date, String p_venue_name) {
		m_eventid = "" + p_event_id;
		m_event_name = p_event_name;
		m_first_date = p_first_date;
		m_venue_name = p_venue_name;
	}

	/*
	 * Name: loadDatasources ()
	 * 
	 * Purpose: Sets the class to a contain the Datasource information for the
	 * specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadDatasources() {
		CachedRowSet l_rs;
		String sqlString;
		Datasource temp_object;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT DATASOURCEEVLINKID FROM DATASOURCEEVLINK " + "WHERE EVENTID=" + m_eventid;
			l_rs = m_db.runSQL(sqlString, stmt);

			// Reset the object
			m_data_sources.removeAllElements();

			while (l_rs.next()) {
				temp_object = new Datasource(m_db);
				temp_object.setEventId(m_eventid);
				temp_object.loadLinkedProperties(l_rs.getInt("DATASOURCEEVLINKID"));
				m_data_sources.addElement(temp_object);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadDatasources().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadSecondaryGenres ()
	 * 
	 * Purpose: Sets the class to a contain the Secondary Genre information for
	 * the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadSecondaryGenres() {
		CachedRowSet l_rs;
		String sqlString;
		SecondaryGenre temp_object;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT secgenrepreferredid FROM SECGENRECLASSLINK " + "WHERE EVENTID=" + m_eventid;
			l_rs = m_db.runSQL(sqlString, stmt);

			// Reset the object
			m_secondary_genres.removeAllElements();

			while (l_rs.next()) {
				temp_object = new SecondaryGenre(m_db);
				temp_object.loadLinkedProperties(l_rs.getInt("GENRECLASSID"));
				m_secondary_genres.addElement(temp_object);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadSecondaryGenres().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadPrimContentIndicatorEvLinks ()
	 * 
	 * Purpose: Sets the class to a contain the Primary Content Indicator
	 * information for the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadPrimContentIndicatorEvLinks() {
		PrimContentIndicatorEvLink temp_object = new PrimContentIndicatorEvLink(m_db);

		try {
			m_prim_content_indicator_evlinks = temp_object.getPrimContentIndicatorEvLinksForEvent(Integer.parseInt(m_eventid));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadPrimContentIndicatorEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private void loadSecGenreEvLinks() {
		SecGenreEvLink temp_object = new SecGenreEvLink(m_db);

		try {
			m_sec_genre_evlinks = temp_object.getSecondaryGenreEvLinksForEvent(Integer.parseInt(m_eventid));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadSecGenreEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadConEvLinks ()
	 * 
	 * Purpose: Sets the class to a contain the ConEvLink information for the
	 * specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadConEvLinks() {
		ConEvLink temp_object = new ConEvLink(m_db);

		try {
			m_con_evlinks = temp_object.getConEvLinksForEvent(Integer.parseInt(m_eventid));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadConEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadEventEventLinks ()
	 * 
	 * Purpose: Sets the class to a contain the EventEventLink information for
	 * the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */
	private void loadEventEventLinks() {
		ResultSet l_rs = null;
		String l_sql = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			l_sql = "SELECT DISTINCT eventeventlinkid  " 
					+ " FROM eventeventlink el, events e, lookup_codes lu" 
					+ " WHERE el.eventid=" + m_eventid 
					+ " AND el.childid = e.eventid "
					+ " AND lu.code_lov_id = el.function_lov_id "
					+ " ORDER BY lu.description ASC, event_name ASC";
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			// Reset the object
			m_event_eventlinks.removeAllElements();

			while (l_rs.next()) {
				EventEventLink eel = new EventEventLink(m_db);
				eel.load(l_rs.getString("EVENTEVENTLINKID"));
				m_event_eventlinks.addElement(eel);

			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadEventEventLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		
	}

	/*
	 * Name: loadOrgEvLinks ()
	 * 
	 * Purpose: Sets the class to a contain the OrgEvLink information for the
	 * specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadOrgEvLinks() {
		OrgEvLink temp_object = new OrgEvLink(m_db);

		try {
			m_org_evlinks = temp_object.getOrgEvLinksForEvent(Integer.parseInt(m_eventid));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadOrgEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadWorkEvLinks ()
	 * 
	 * Purpose: Sets the class to a contain the WorkEvLink information for the
	 * specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadWorkEvLinks() {
		WorkEvLink temp_object = new WorkEvLink(m_db);

		try {
			m_works = temp_object.getWorkEvLinks(Integer.parseInt(m_eventid));
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadOrgEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadResourceEvLinks ()
	 * 
	 * Purpose: Sets the class to a contain the ResourceEvLink information for
	 * the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadResourceEvLinks() {
		ResultSet l_rs = null;
		String l_sql = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			l_sql = "SELECT itemid " + "FROM itemevlink " + "WHERE eventid=" + m_eventid;
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			// Reset the object
			m_res_evlinks.removeAllElements();

			while (l_rs.next()) {
				m_res_evlinks.addElement(l_rs.getString("itemid"));
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadResourceEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadPlayOrigins ()
	 * 
	 * Purpose: Sets the class to a contain the PlayOrigin (ie, Country)
	 * information for the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadPlayOrigins() {
		CachedRowSet l_rs;
		String sqlString;
		Country temp_object;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT COUNTRYID FROM PLAYEVLINK " + "WHERE EVENTID=" + m_eventid;
			l_rs = m_db.runSQL(sqlString, stmt);

			// Reset the object
			m_play_origins.removeAllElements();

			while (l_rs.next()) {
				temp_object = new Country(m_db);
				temp_object.load(l_rs.getInt("COUNTRYID"));
				m_play_origins.addElement(temp_object);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadPlayOrigins().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: loadProductionOrigins ()
	 * 
	 * Purpose: Sets the class to a contain the ProductionOrigin (ie, Country)
	 * information for the specified event id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadProductionOrigins() {
		CachedRowSet l_rs;
		String sqlString;
		Country temp_object;

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = "SELECT COUNTRYID FROM PRODUCTIONEVLINK " + "WHERE EVENTID=" + m_eventid;
			l_rs = m_db.runSQL(sqlString, stmt);

			// Reset the object
			m_production_origins.removeAllElements();

			while (l_rs.next()) {
				temp_object = new Country(m_db);
				temp_object.load(l_rs.getInt("COUNTRYID"));
				m_production_origins.addElement(temp_object);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadProductionOrigins().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: update ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the update was successful.
	 */

	public boolean update() {
		String sqlString = "";
		try {
			Statement stmt = m_db.m_conn.createStatement();
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				// As the Event Name is a text area, need to limit characters
				if (m_event_name.length() > 200) m_event_name = m_event_name.substring(0, 199);

				// As the Description is a text area, need to limit characters
				if (m_description.length() > 2000) m_description = m_description.substring(0, 1999);

				// As the Further Information is a text area, need to limit
				// characters
				if (m_further_information.length() > 400) m_further_information = m_further_information.substring(0, 399);

				if (m_description_source == null || m_description_source.equals("")) m_description_source = "0";

				m_updated_date = new Date();
				String l_entered_date = null;
				String l_updated_date = null;
				String l_fisrt_date = null;
				String l_last_date = null;
				String l_openning_night_date = null;

				if (m_entered_date != null) l_entered_date = m_db.safeDateFormat(m_entered_date, false);
				if (m_updated_date != null) l_updated_date = m_db.safeDateFormat(m_updated_date, false);

				/***************************
				 * DEAL WITH FIRST DATE
				 ***************************/
				if (m_ddfirst_date.equals("") && m_mmfirst_date.equals("") && m_yyyyfirst_date.equals("")) {
					// no date specified
					l_fisrt_date = "null";
				} else if (m_ddfirst_date.equals("") && !m_mmfirst_date.equals("") && !m_yyyyfirst_date.equals("")) {
					// month and year were filled in
					l_fisrt_date = m_db.safeDateFormat("01/" + m_mmfirst_date + "/" + m_yyyyfirst_date);
				} else if (m_ddfirst_date.equals("") && m_mmfirst_date.equals("") && !m_yyyyfirst_date.equals("")) {
					// just year is filled in
					l_fisrt_date = m_db.safeDateFormat("01/01/" + m_yyyyfirst_date);
				} else {
					// all fields in the this date were filled in
					l_fisrt_date = m_db.safeDateFormat(m_first_date, false);
				}
				/***************************
				 * DEAL WITH LAST DATE
				 ***************************/
				if (m_ddlast_date.equals("") && m_mmlast_date.equals("") && m_yyyylast_date.equals("")) {
					// no date specified
					l_last_date = "null";
				} else if (m_ddlast_date.equals("") && !m_mmlast_date.equals("") && !m_yyyylast_date.equals("")) {
					// month and year were filled in
					l_last_date = m_db.safeDateFormat(getLastDayOfMonth(m_mmlast_date, m_yyyylast_date) + "/" + m_mmlast_date + "/" + m_yyyylast_date);
				} else if (m_ddlast_date.equals("") && m_mmlast_date.equals("") && !m_yyyylast_date.equals("")) {
					// just year is filled in
					l_last_date = m_db.safeDateFormat("01/01/" + m_yyyylast_date);
				} else {
					// all fields in the this date were filled in
					l_last_date = m_db.safeDateFormat(m_last_date, false);
				}
				/***************************
				 * DEAL WITH OPENNING DATE
				 ***************************/
				if (m_ddopen_date.equals("") && m_mmopen_date.equals("") && m_yyyyopen_date.equals("")) {
					// no date specified
					l_openning_night_date = "null";
				} else if (m_ddopen_date.equals("") && !m_mmopen_date.equals("") && !m_yyyyopen_date.equals("")) {
					// month and year were filled in
					l_openning_night_date = m_db.safeDateFormat("01/" + m_mmopen_date + "/" + m_yyyyopen_date);
				} else if (m_ddopen_date.equals("") && m_mmopen_date.equals("") && !m_yyyyopen_date.equals("")) {
					// just year is filled in
					l_openning_night_date = m_db.safeDateFormat("01/01/" + m_yyyyopen_date);
				} else {
					// all fields in the this date were filled in
					l_openning_night_date = m_db.safeDateFormat(m_ddopen_date + "/" + m_mmopen_date + "/" + m_yyyyopen_date);
				}

				// "', entered_by_user = '" +
				// m_db.plSqlSafeString(m_entered_by_user) +
				// "', interesting_perf_history = '" + Common.convertBoolToYesNo
				// (m_int_perf_history) +
				// ", est_first_date = '" +
				// Common.convertBoolToYesNo(m_est_first_date) +
				// ", est_open_date = '" +
				// Common.convertBoolToYesNo(m_est_last_date) +
				// ", est_open_date = '" +
				// Common.convertBoolToYesNo(m_est_open_date) +
				sqlString = "   UPDATE events SET " 
						+ "   event_name = '" + m_db.plSqlSafeString(m_event_name) 
						+ "', umbrella = '" + m_db.plSqlSafeString(m_umbrella)
						+ "', description = '" + m_db.plSqlSafeString(m_description) 
						+ "'," + " world_premier = '" + Common.convertBoolToYesNo(m_world_premier) 
						+ "', review = '" + Common.convertBoolToYesNo(m_review) 
						+ "', status =  " + m_status 
						+ " , venueid =  " + m_venueid 
						+ " , primary_genre =  " + m_primary_genre
						+ " , further_information = '" + m_db.plSqlSafeString(m_further_information) 
						+ "', description_source  =  " + m_description_source 
						+ ", ddfirst_date = '" + m_ddfirst_date 
						+ "', mmfirst_date = '" + m_mmfirst_date 
						+ "', yyyyfirst_date = '" + m_yyyyfirst_date 
						+ "', first_date = " + l_fisrt_date
						+ ", ddlast_date = '" + m_ddlast_date 
						+ "', mmlast_date = '" + m_mmlast_date 
						+ "', yyyylast_date = '" + m_yyyylast_date 
						+ "', last_date = " + l_last_date
						+ ", ddopening_night  = '" + m_ddopen_date 
						+ "', mmopening_night = '" + m_mmopen_date 
						+ "', yyyyopening_night = '" + m_yyyyopen_date 
						+ "', UPDATED_BY_USER = '" + m_db.plSqlSafeString(m_entered_by_user) 
						+ "', UPDATED_DATE = now() " 
						+ ", opening_night_date = " + l_openning_night_date
						+ ", estimated_dates = '" + Common.convertBoolToYesNo(m_estimated_dates) 
						+ "', part_of_a_tour = '" + Common.convertBoolToYesNo(m_part_of_a_tour) 
						+ "'  where eventid =  " + m_eventid;

				// lets do some uniqueness check here
				if (!existInEvents(UPDATE)) {

					m_db.runSQL(sqlString, stmt);

					m_venue.update();

					modifyDatasources(UPDATE);
					modifySecGenreEvLinks(UPDATE);
					modifyPrimContentIndicatorEvLinks(UPDATE);
					// modifySecContentIndicatorEvLinks(UPDATE);
					modifyConEvLinks(UPDATE);
					modifyOrgEvLinks(UPDATE);
					modifyEventEventLinks(UPDATE);
					modifyWorkEvLinks(UPDATE);
					modifyPlayOrigins(UPDATE);
					modifyProductionOrigins(UPDATE);

					System.out.println("Update events:" + sqlString);

					// Update the item link table
					// Delete the current links, then for each item id in the
					// vector
					// perform an insert
					String l_sql = "DELETE FROM itemevlink WHERE eventid=" + m_eventid;
					m_db.runSQLResultSet(l_sql, stmt);
					for (int i = 0; i < m_res_evlinks.size(); i++) {
						l_sql = "INSERT INTO itemevlink (EVENTID, ITEMID) " + "VALUES (" + m_eventid + "," + m_res_evlinks.elementAt(i) + ")";
						m_db.runSQLResultSet(l_sql, stmt);
					}

					l_ret = true;
				} else {
					m_error_string = "Unable to update " + m_event_name + " because this event is not unique.";
				}
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			// System.out.println(e);
			// System.out.println("sqlString = " + sqlString);
			m_error_string = "Unable to update the Event. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: add ()
	 * 
	 * Purpose: Inserts this object into the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the add was successful.
	 */

	public boolean add() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;
			Calendar l_now = Calendar.getInstance();
			Calendar x_cal = Calendar.getInstance();

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {

				// if we are in copy mode lets put a leading 'Copy of' in front
				// of the event name
				if (m_is_in_copy_mode && !m_event_name.startsWith("Copy of")) m_event_name = "Copy of " + m_event_name;

				// As the Event Name is a text area, need to limit characters
				if (m_event_name.length() > 200) m_event_name = m_event_name.substring(0, 199);

				// As the Description is a text area, need to limit characters
				if (m_description.length() > 600) m_description = m_description.substring(0, 599);

				// As the Further Information is a text area, need to limit
				// characters
				if (m_further_information.length() > 400) m_further_information = m_further_information.substring(0, 399);

				if (m_description_source == null || m_description_source.equals("")) m_description_source = "0";

				m_updated_date = new Date();

				// lets do some uniqueness check here
				if (!existInEvents(INSERT)) {

					String l_entered_date = null;
					String l_updated_date = null;
					String l_fisrt_date = null;
					String l_last_date = null;
					String l_openning_night_date = null;

					/***************************
					 * DEAL WITH FIRST DATE
					 ***************************/
					if (m_ddfirst_date.equals("") && m_mmfirst_date.equals("") && m_yyyyfirst_date.equals("")) {
						// no date specified
						l_fisrt_date = "null";
					} else if (m_ddfirst_date.equals("") && !m_mmfirst_date.equals("") && !m_yyyyfirst_date.equals("")) {
						// month and year were filled in
						l_fisrt_date = m_db.safeDateFormat("01/" + m_mmfirst_date + "/" + m_yyyyfirst_date);
					} else if (m_ddfirst_date.equals("") && m_mmfirst_date.equals("") && !m_yyyyfirst_date.equals("")) {
						// just year is filled in
						l_fisrt_date = m_db.safeDateFormat("01/01/" + m_yyyyfirst_date);
					} else {
						// all fields in the this date were filled in
						l_fisrt_date = m_db.safeDateFormat(m_first_date, false);
					}

					/***************************
					 * DEAL WITH LAST DATE
					 ***************************/
					if (m_ddlast_date.equals("") && m_mmlast_date.equals("") && m_yyyylast_date.equals("")) {
						// no date specified
						l_last_date = "null";
					} else if (m_ddlast_date.equals("") && !m_mmlast_date.equals("") && !m_yyyylast_date.equals("")) {
						// month and year were filled in
						l_last_date = m_db.safeDateFormat(getLastDayOfMonth(m_mmlast_date, m_yyyylast_date) + "/" + m_mmlast_date + "/" + m_yyyylast_date);
					} else if (m_ddlast_date.equals("") && m_mmlast_date.equals("") && !m_yyyylast_date.equals("")) {
						// just year is filled in
						l_last_date = m_db.safeDateFormat("01/01/" + m_yyyylast_date);
					} else {
						// all fields in the this date were filled in
						l_last_date = m_db.safeDateFormat(m_last_date, false);
					}

					/***************************
					 * DEAL WITH OPENNING DATE
					 ***************************/

					if (m_ddopen_date.equals("") && m_mmopen_date.equals("") && m_yyyyopen_date.equals("")) {
						// no date specified
						l_openning_night_date = "null";
					} else if (m_ddopen_date.equals("") && !m_mmopen_date.equals("") && !m_yyyyopen_date.equals("")) {
						// month and year were filled in
						l_openning_night_date = m_db.safeDateFormat("01/" + m_mmopen_date + "/" + m_yyyyopen_date);
					} else if (m_ddopen_date.equals("") && m_mmopen_date.equals("") && !m_yyyyopen_date.equals("")) {
						// just year is filled in
						l_openning_night_date = m_db.safeDateFormat("01/01/" + m_yyyyopen_date);
					} else {
						// all fields in the this date were filled in
						l_openning_night_date = m_db.safeDateFormat(m_ddopen_date + "/" + m_mmopen_date + "/" + m_yyyyopen_date);
					}

					if (m_entered_date != null) l_entered_date = m_db.safeDateFormat(m_entered_date, false);
					if (m_updated_date != null) l_updated_date = m_db.safeDateFormat(m_updated_date, false);

					// ", '" + Common.convertBoolToYesNo(m_est_first_date ) +
					// ", '" + Common.convertBoolToYesNo(m_est_last_date ) +
					// ", '" + Common.convertBoolToYesNo(m_est_open_date ) +
					sqlString = "INSERT INTO events " 
							+ "(event_name, umbrella, entered_by_user, entered_date, "
							+ " description,  world_premier, review,  interesting_perf_history, part_of_a_tour, " 
							+ " status, venueid, primary_genre, further_information, description_source, "
							+ " ddfirst_date, mmfirst_date, yyyyfirst_date, first_date, " 
							+ " ddlast_date, mmlast_date, yyyylast_date, last_date, "
							+ " ddopening_night, mmopening_night, yyyyopening_night, opening_night_date, estimated_dates) " 
							+ "VALUES ('"
							+ m_db.plSqlSafeString(m_event_name)
							+ "', '"
							+ m_db.plSqlSafeString(m_umbrella)
							+ "', '"
							+ m_db.plSqlSafeString(m_entered_by_user)
							+ "', "
							+ l_entered_date
							+ ", '"
							+ m_db.plSqlSafeString(m_description)
							+ "', '"
							+ Common.convertBoolToYesNo(m_world_premier)
							+ "', '"
							+ Common.convertBoolToYesNo(m_review)
							+ "', '"
							+ Common.convertBoolToYesNo(m_int_perf_history)
							+ "', '"
							+ Common.convertBoolToYesNo(m_part_of_a_tour)
							+ "',  "
							+ (m_status)
							+ " ,  "
							+ (m_venueid)
							+ " ,  "
							+ (m_primary_genre)
							+ " , '"
							+ m_db.plSqlSafeString(m_further_information)
							+ "',  "
							+ (m_description_source)
							+ ", '"
							+ (m_ddfirst_date)
							+ "', '"
							+ (m_mmfirst_date)
							+ "', '"
							+ (m_yyyyfirst_date)
							+ "', "
							+ l_fisrt_date
							+ ", '"
							+ (m_ddlast_date)
							+ "', '"
							+ (m_mmlast_date)
							+ "', '"
							+ (m_yyyylast_date)
							+ "', "
							+ l_last_date
							+ ", '"
							+ (m_ddopen_date)
							+ "', '"
							+ (m_mmopen_date)
							+ "', '"
							+ (m_yyyyopen_date)
							+ "', "
							+ l_openning_night_date 
							+ ", '" 
							+ Common.convertBoolToYesNo(m_estimated_dates) 
							+ "')";

					m_db.runSQL(sqlString, stmt);
					// assign the newly created id to this bean
					m_eventid = m_db.getInsertedIndexValue(stmt, "eventid_seq");

					modifyDatasources(INSERT);
					modifySecGenreEvLinks(INSERT);
					modifyPrimContentIndicatorEvLinks(INSERT);
					// modifySecContentIndicatorEvLinks(INSERT);
					modifyConEvLinks(INSERT);
					modifyOrgEvLinks(INSERT);
					modifyEventEventLinks(INSERT);
					modifyWorkEvLinks(INSERT);
					modifyPlayOrigins(INSERT);
					modifyProductionOrigins(INSERT);

					// Insert into the item link table
					for (int i = 0; i < m_res_evlinks.size(); i++) {
						String l_sql = "INSERT INTO itemevlink (EVENTID, ITEMID) " + "VALUES (" + m_eventid + "," + m_res_evlinks.elementAt(i) + ")";
						m_db.runSQLResultSet(l_sql, stmt);
					}

					l_ret = true;
				} else {
					if (m_is_in_copy_mode)
						m_error_string = "Unable to copy " + m_event_name + " because this event is not unique.";
					else
						m_error_string = "Unable to add " + m_event_name + " because this event is not unique.";
				}
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to insert the Event. The data may be invalid.";
			return (false);
		}
	}

	private String getLastDayOfMonth(String p_month, String p_year) {
		GregorianCalendar gcal = new GregorianCalendar();
		String lastdayofmonth = "0";
		if (p_month.indexOf("0") == 0) p_month = p_month.substring(p_month.indexOf("0") + 1);

		int l_month = Integer.parseInt(p_month);
		int l_year = Integer.parseInt(p_year);

		if (l_month == 1)
			lastdayofmonth = "31";
		else if (l_month == 2) {
			if (gcal.isLeapYear(l_year))
				lastdayofmonth = "29";
			else
				lastdayofmonth = "28";
		} else if (l_month == 3)
			lastdayofmonth = "31";
		else if (l_month == 4)
			lastdayofmonth = "30";
		else if (l_month == 5)
			lastdayofmonth = "31";
		else if (l_month == 6)
			lastdayofmonth = "30";
		else if (l_month == 7)
			lastdayofmonth = "31";
		else if (l_month == 8)
			lastdayofmonth = "31";
		else if (l_month == 9)
			lastdayofmonth = "30";
		else if (l_month == 10)
			lastdayofmonth = "31";
		else if (l_month == 11)
			lastdayofmonth = "30";
		else
			lastdayofmonth = "31";

		return (lastdayofmonth);
	}

	/*
	 * Name: delete ()
	 * 
	 * Purpose: Deletes this object from the database.
	 * 
	 * Parameters:
	 * 
	 * Returns: True if the delete was successful.
	 */

	public boolean delete() {
		try {
			Statement stmt = m_db.m_conn.createStatement();
			String sqlString;
			boolean l_ret = false;

			// Check to make sure that the user has entered in all of the
			// required fields
			if (validateObjectForDB()) {
				modifyDatasources(DELETE);
				modifySecGenreEvLinks(DELETE);
				modifyPrimContentIndicatorEvLinks(DELETE);
				// modifySecContentIndicatorEvLinks(DELETE);
				modifyConEvLinks(DELETE);
				modifyOrgEvLinks(DELETE);
				modifyEventEventLinks(DELETE);
				modifyWorkEvLinks(DELETE);
				modifyPlayOrigins(DELETE);
				modifyProductionOrigins(DELETE);

				// Delete from the item link table
				String l_sql = "DELETE FROM itemevlink WHERE eventid=" + m_eventid;
				m_db.runSQLResultSet(l_sql, stmt);

				sqlString = "DELETE FROM events " + "WHERE eventid = " + m_eventid;
				m_db.runSQL(sqlString, stmt);

				l_ret = true;
			}
			stmt.close();
			return (l_ret);
		} catch (Exception e) {
			m_error_string = "Unable to delete the Event. The data may be invalid.";
			return (false);
		}
	}

	/*
	 * Name: checkInUse ()
	 * 
	 * Purpose: Checks to see if the specified Event is in use in the database.
	 * 
	 * Parameters: p_id : id of the record
	 * 
	 * Returns: True if the collection is in use, else false
	 */

	public boolean checkInUse(int p_id) {
		try {
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
	 * Parameters: None
	 * 
	 * Returns: True if the object is valid, else false
	 */

	private boolean validateObjectForDB() {
		boolean l_ret = true;
		if (m_event_name.equals("")) {
			m_error_string = "Unable to add the Event. Event name is required.";
			l_ret = false;
		} else if (m_venueid.length() == 0) {
			m_error_string = "Unable to add the Event. Venue is required.";
			l_ret = false;
		} else if (m_venueid.equals("0")) {
			m_error_string = "Unable to add the Event. Venue is required.";
			l_ret = false;
		}
		return (l_ret);
	}

	/*
	 * Name: modifyDatasources ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyDatasources(int modifyType) {
		Datasource temp_object = new Datasource(m_db);

		try {

			// lets del all old links first
			temp_object.delLink(m_eventid);

			for (int i = 0; i < m_data_sources.size(); i++) {
				temp_object = (Datasource) m_data_sources.get(i);
				temp_object.setMdb(m_db);
				switch (modifyType) {
				case UPDATE:
					temp_object.addLink(m_eventid);
					break;
				case INSERT:
					temp_object.addLink(m_eventid);
					break;
				}
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyDatasources().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: modifyPrimContentIndicatorEvLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyPrimContentIndicatorEvLinks(int modifyType) {
		PrimContentIndicatorEvLink temp_object = new PrimContentIndicatorEvLink(m_db);

		try {
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_prim_content_indicator_evlinks);
				break;
			case DELETE:
				temp_object.deletePrimContentIndicatorEvLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_prim_content_indicator_evlinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyPrimContentIndicatorEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private void modifySecGenreEvLinks(int modifyType) {
		SecGenreEvLink temp_object = new SecGenreEvLink(m_db);

		try {
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_sec_genre_evlinks);
				break;
			case DELETE:
				temp_object.deleteSecondaryGenreEvLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_sec_genre_evlinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifySecGenreEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}


	/*
	 * Name: modifyEventEventLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyEventEventLinks(int modifyType) {
		try {
			EventEventLink temp_object = new EventEventLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_event_eventlinks);
				break;
			case DELETE:
				temp_object.deleteEventEventLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_event_eventlinks);
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

	/*
	 * Name: modifyConEvLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyConEvLinks(int modifyType) {
		try {
			ConEvLink temp_object = new ConEvLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_con_evlinks);
				break;
			case DELETE:
				temp_object.deleteConEvLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_con_evlinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyConEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: modifyOrgEvLinks ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyOrgEvLinks(int modifyType) {
		try {
			OrgEvLink temp_object = new OrgEvLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_org_evlinks);
				break;
			case DELETE:
				temp_object.deleteOrgEvLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_org_evlinks);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyOrgEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	private void modifyWorkEvLinks(int modifyType) {
		try {
			WorkEvLink temp_object = new WorkEvLink(m_db);
			switch (modifyType) {
			case UPDATE:
				temp_object.update(m_eventid, m_works);
				break;
			case DELETE:
				temp_object.deleteWorkEvLinksForEvent(m_eventid);
				break;
			case INSERT:
				temp_object.add(m_eventid, m_works);
				break;
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyWorkEvLinks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: modifyPlayOrigins ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyPlayOrigins(int modifyType) {
		Country temp_object = new Country(m_db);

		try {
			temp_object.delLink(m_eventid, true);
			for (int i = 0; i < m_play_origins.size(); i++) {
				temp_object = (Country) m_play_origins.get(i);
				temp_object.setMdb(m_db);
				switch (modifyType) {
				case UPDATE:
					temp_object.addLink(m_eventid, true);
					break;
				case INSERT:
					temp_object.addLink(m_eventid, true);
					break;
				}
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyPlayOrigins().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: modifyProductionOrigins ()
	 * 
	 * Purpose: Modifies this object in the database.
	 * 
	 * Parameters: modifyType - Update, Delete or Insert
	 * 
	 * Returns: None
	 */

	private void modifyProductionOrigins(int modifyType) {
		Country temp_object = new Country(m_db);

		try {
			temp_object.delLink(m_eventid, false);
			for (int i = 0; i < m_production_origins.size(); i++) {
				temp_object = (Country) m_production_origins.get(i);
				temp_object.setMdb(m_db);
				switch (modifyType) {
				case UPDATE:
					temp_object.addLink(m_eventid, false);
					break;
				case INSERT:
					temp_object.addLink(m_eventid, false);
					break;
				}
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in modifyProductionOrigins().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}

	/*
	 * Name: leadingZero ()
	 * 
	 * Purpose: Inserts a leading zero onto a one character day or month field.
	 * 
	 * Parameters: The day/month field
	 * 
	 * Returns: The day/month field with the leading zero.
	 */

	private String leadingZero(String dayMonth) {
		dayMonth = dayMonth.trim();
		if (dayMonth.length() == 1) dayMonth = "0" + dayMonth;
		return dayMonth;
	}

	public String getEventid() {
		return m_eventid;
	}

	public String getEventName() {
		return m_event_name;
	}

	public String getUmbrella() {
		return m_umbrella;
	}

	public String getEnteredByUser() {
		return m_entered_by_user;
	}

	public Date getEnteredDate() {
		return m_entered_date;
	}

	public String getUpdatedByUser() {
		return m_updated_by_user;
	}

	public Date getUpdatedDate() {
		return m_updated_date;
	}

	public String getDescription() {
		return m_description;
	}

	public boolean getWorldPremier() {
		return m_world_premier;
	}

	public boolean getReview() {
		return m_review;
	}

	public boolean getIntPerfHistory() {
		return m_int_perf_history;
	}

	public boolean getPartOfATour() {
		return m_part_of_a_tour;
	}

	public String getStatus() {
		return m_status;
	}

	public String getVenueid() {
		return m_venueid;
	}

	public String getPrimaryGenre() {
		return m_primary_genre;
	}

	public String getFurtherInformation() {
		return m_further_information;
	}

	public String getDescriptionSource() {
		return m_description_source;
	}

	public String getDdfirstDate() {
		return m_ddfirst_date;
	}

	public String getMmfirstDate() {
		return m_mmfirst_date;
	}

	public String getYyyyfirstDate() {
		return m_yyyyfirst_date;
	}

	public String evDate() {
		return evDate;
	}

	public Date getFirstDate() {
		return m_first_date;
	}

	public String getDdlastDate() {
		return m_ddlast_date;
	}

	public String getMmlastDate() {
		return m_mmlast_date;
	}

	public String getYyyylastDate() {
		return m_yyyylast_date;
	}

	public Date getLastDate() {
		return m_last_date;
	}

	public String getDdopenDate() {
		return m_ddopen_date;
	}

	public String getMmopenDate() {
		return m_mmopen_date;
	}

	public String getYyyyopenDate() {
		return m_yyyyopen_date;
	}

	public Date getOpeningNightDate() {
		return m_opening_night_date;
	}

	public boolean getEstimatedDates() {
		return m_estimated_dates;
	}
	
	public String getError() {
		return m_error_string;
	}

	public String getEventName(int eventId) {
		String event_name = "";
		CachedRowSet rset;
		try {
			Statement stmt = m_db.m_conn.createStatement();
			rset = m_db.runSQL("select EVENT_NAME from EVENTS where EVENTID=" + eventId, stmt);
			if (rset.next()) event_name = rset.getString("EVENT_NAME");
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventName(int eventId).");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (event_name);
	}

	public String getEventStatus(String status_id) {
		String status_name = "";
		CachedRowSet rset;
		try {
			if (status_id != null && !status_id.equals("")) {
				Statement stmt = m_db.m_conn.createStatement();
				rset = m_db.runSQL("select STATUS from STATUSMENU where STATUSID=" + status_id, stmt);
				if (rset.next()) status_name = rset.getString("STATUS");
				stmt.close();
			}
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventStatus().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (status_name);
	}

	public String getContributorFunct(String p_id) {
		CachedRowSet l_rs;
		String sqlString, l_functionDesc = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			sqlString = " SELECT PreferredTerm FROM ConEvLink, ContributorFunctPreferred, events" + " WHERE contributorId = " + p_id + " AND   ConEvLink.eventId = events.eventid "
					+ " AND   function      = ContributorFunctPreferredId ";
			l_rs = m_db.runSQL(sqlString, stmt);

			if (l_rs.next()) {
				l_functionDesc = l_rs.getString("PreferredTerm");

				if (l_functionDesc == null) l_functionDesc = "";
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getContributorFunct()");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}

		return (l_functionDesc);
	}

	// Derived Objects

	public Vector<Event> getAssociatedEvents() {
		Vector<Event> events = new Vector<Event>();
		for (EventEventLink eel : m_event_eventlinks) {
			Event event = new Event(m_db);
			event.load(Integer.parseInt(eel.getChildId()));
			events.add(event);
		}
		return events;
	}
	
	public Vector<EventEventLink> getEventEventLinks() {
		return m_event_eventlinks;
	}
	
	public Venue getVenue() {
		return m_venue;
	}

	public Vector getDataSources() {
		return m_data_sources;
	}

	public Vector getSecondaryGenres() {
		return m_secondary_genres;
	}

	public Vector getSecGenreEvLinks() {
		return m_sec_genre_evlinks;
	}

	public Vector getPrimContentIndicatorEvLinks() {
		return m_prim_content_indicator_evlinks;
	}

	public Vector getSecContentIndicatorEvLinks() {
		return m_sec_content_indicator_evlinks;
	}

	public Vector getWorks() {
		return m_works;
	}

	public Vector getConEvLinks() {
		return m_con_evlinks;
	}

	public Vector<Event> getEvents() {
		return getAssociatedEvents();
	}

	public Vector getOrgEvLinks() {
		return m_org_evlinks;
	}

	public Vector getPlayOrigins() {
		return m_play_origins;
	}

	public Vector getProductionOrigins() {
		return m_production_origins;
	}

	public Vector getResEvLinks() {
		return m_res_evlinks;
	}

	public void setEventid(String s) {
		m_eventid = s;
	}

	public void setEventName(String s) {
		m_event_name = s;
	}

	public void setUmbrella(String s) {
		m_umbrella = s;
	}

	public void setEnteredByUser(String s) {
		m_entered_by_user = s;
	}

	public void setEnteredDate(Date d) {
		m_entered_date = d;
	}

	public void setUpdatedDate(Date d) {
		m_updated_date = d;
	}

	public void setDescription(String s) {
		m_description = s;
	}

	public void setPartOfATour(boolean b) {
		m_part_of_a_tour = b;
	}
	
	public void setWorldPremier(boolean b) {
		m_world_premier = b;
	}

	public void setReview(boolean b) {
		m_review = b;
	}

	public void setIntPerfHistory(boolean b) {
		m_int_perf_history = b;
	}

	public void setStatus(String s) {
		m_status = s;
	}

	public void setVenueid(String s) {
		m_venueid = s;
	}

	public void setPrimaryGenre(String s) {
		m_primary_genre = s;
	}

	public void setFurtherInformation(String s) {
		m_further_information = s;
	}

	public void setDescriptionSource(String s) {
		m_description_source = s;
	}

	public void setDdfirstDate(String s) {
		m_ddfirst_date = leadingZero(s);
	}

	public void setMmfirstDate(String s) {
		m_mmfirst_date = leadingZero(s);
	}

	public void setYyyyfirstDate(String s) {
		m_yyyyfirst_date = s;
	}

	public void setFirstDate(Date d) {
		m_first_date = d;
	}

	public void setDdlastDate(String s) {
		m_ddlast_date = leadingZero(s);
	}

	public void setMmlastDate(String s) {
		m_mmlast_date = leadingZero(s);
	}

	public void setYyyylastDate(String s) {
		m_yyyylast_date = s;
	}

	public void setLastDate(Date d) {
		m_last_date = d;
	}

	public void setDdopenDate(String s) {
		m_ddopen_date = leadingZero(s);
	}

	public void setMmopenDate(String s) {
		m_mmopen_date = leadingZero(s);
	}

	public void setYyyyopenDate(String s) {
		m_yyyyopen_date = s;
	}

	public void setOpeningNightDate(Date d) {
		m_opening_night_date = d;
	}

	public void setEstimatedDates(boolean b) {
		m_estimated_dates = b;
	}

	// public void setEstimatedFirstDate (boolean b) {m_est_first_date = b;}
	// public void setEstimatedLastDate (boolean b) {m_est_last_date = b;}
	// public void setEstimatedOpenDate (boolean b) {m_est_open_date = b;}

	// Derived Objects

	public void setVenue(Venue n) {
		m_venue = n;
	}

	public void setDataSources(Vector v) {
		m_data_sources = v;
	}

	public void setSecondaryGenres(Vector v) {
		m_secondary_genres = v;
	}

	public void setSecGenreEvLinks(Vector v) {
		m_sec_genre_evlinks = v;
	}

	public void setPrimContentIndicatorEvLinks(Vector v) {
		m_prim_content_indicator_evlinks = v;
	}

	public void setSecContentIndicatorEvLinks(Vector v) {
		m_sec_content_indicator_evlinks = v;
	}

	public void setConEvLinks(Vector v) {
		m_con_evlinks = v;
	}

	public void setEventEventLinks(Vector<EventEventLink> v) {
		m_event_eventlinks = v;
	}

	public void setOrgEvLinks(Vector v) {
		m_org_evlinks = v;
	}

	public void setOrganisations(Vector v) {
		m_organisations = v;
	}

	public void setWorks(Vector v) {
		m_works = v;
	}

	public void setPlayOrigins(Vector v) {
		m_play_origins = v;
	}

	public void setProductionOrigins(Vector v) {
		m_production_origins = v;
	}

	public void setResEvLinks(Vector v) {
		m_res_evlinks = v;
	}

	// Database Object

	public void setDatabaseConnection(ausstage.Database ad) {
		m_db = ad;
	}

	public void setIsInCopyMode(boolean p_is_in_copy_mode) {
		m_is_in_copy_mode = p_is_in_copy_mode;
	}

	/*
	 * Name: setEventAttributes (HttpServletRequest request)
	 * 
	 * Purpose: Sets the attributes in this object from the request.
	 * 
	 * Parameters: request - The request received by the current page.
	 * 
	 * Returns: None.
	 */

	public void setEventAttributes(HttpServletRequest request) {
		Calendar calendar;
		String day = "";
		String month = "";
		String year = "";

		this.m_eventid = request.getParameter("f_eventid");
		this.m_event_name = request.getParameter("f_event_name");
		this.m_umbrella = request.getParameter("f_umbrella");
		this.m_description = request.getParameter("f_description");

		this.m_world_premier = Common.convertYesNoToBool(request.getParameter("f_world_premier"));
		this.m_review = Common.convertYesNoToBool(request.getParameter("f_review"));
		System.out.println("request.getParameter:" + request.getParameter("f_review"));
		// this.m_int_perf_history =
		// Common.convertYesNoToBool(request.getParameter("f_int_perf_history"));
		this.m_status = request.getParameter("f_status");
		this.m_venueid = request.getParameter("f_venueid");
		this.m_primary_genre = request.getParameter("f_primary_genre");
		this.m_further_information = request.getParameter("f_further_information");
		this.m_description_source = request.getParameter("f_description_source");
		// this.m_est_first_date =
		// Common.convertYesNoToBool(request.getParameter("f_est_first_date"));
		// this.m_est_last_date =
		// Common.convertYesNoToBool(request.getParameter("f_est_last_date"));
		// this.m_est_open_date =
		// Common.convertYesNoToBool(request.getParameter("f_est_open_date"));
		this.m_part_of_a_tour =
		Common.convertYesNoToBool(request.getParameter("f_part_of_a_tour"));

		// Set m_first_date
		day = request.getParameter("f_first_date_day");
		month = request.getParameter("f_first_date_month");
		year = request.getParameter("f_first_date_year");

		if (day == null || day.equals("")) {
			this.setDdfirstDate("");
			day = "";
		} else
			this.setDdfirstDate(day);

		if (month == null || month.equals("")) {
			this.setMmfirstDate("");
			month = "";
		} else
			this.setMmfirstDate(month);

		if (year == null || year.equals("")) {
			this.setYyyyfirstDate("");
			year = "";
		} else
			this.setYyyyfirstDate(year);

		try {
			if (!day.equals("") && !month.equals("") && !year.equals("")) {
				calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(year.trim()), Integer.parseInt(month.trim()) - 1, Integer.parseInt(day.trim()));
				this.m_first_date = calendar.getTime();
			}
		} catch (Exception e) // Should never happen due to JavaScript date
								// checking
		{
			m_error_string = "Unable to update the Event. The First Date field is invalid.";
		}

		// Set m_last_date
		day = request.getParameter("f_last_date_day");
		month = request.getParameter("f_last_date_month");
		year = request.getParameter("f_last_date_year");

		if (day == null || day.equals("")) {
			this.setDdlastDate("");
			day = "";
		} else
			this.setDdlastDate(day);

		if (month == null || month.equals("")) {
			this.setMmlastDate("");
			month = "";
		} else
			this.setMmlastDate(month);

		if (year == null || year.equals("")) {
			this.setYyyylastDate("");
			year = "";
		} else
			this.setYyyylastDate(year);

		try {
			if (!day.equals("") && !month.equals("") && !year.equals("")) {
				calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(year.trim()), Integer.parseInt(month.trim()) - 1, Integer.parseInt(day.trim()));
				this.m_last_date = calendar.getTime();
			}
		} catch (Exception e) { // Should never happen due to JavaScript date
								// checking
			m_error_string = "Unable to update the Event. The Last Date field is invalid.";
		}

		// Set m_opening_night
		day = request.getParameter("f_opening_night_date_day");
		month = request.getParameter("f_opening_night_date_month");
		year = request.getParameter("f_opening_night_date_year");

		if (day == null || day.equals("")) {
			this.setDdopenDate("");
			day = "";
		} else
			this.setDdopenDate(day);

		if (month == null || month.equals("")) {
			this.setMmopenDate("");
			month = "";
		} else
			this.setMmopenDate(month);

		if (year == null || year.equals("")) {
			this.setYyyyopenDate("");
			year = "";
		} else
			this.setYyyyopenDate(year);

		try {
			if (!day.equals("") && !month.equals("") && !year.equals("")) {
				calendar = Calendar.getInstance();
				calendar.set(Integer.parseInt(year.trim()), Integer.parseInt(month.trim()) - 1, Integer.parseInt(day.trim()));
				this.m_opening_night_date = calendar.getTime();
			}
		} catch (Exception e) { // Should never happen due to JavaScript date
								// checking
			m_error_string = "Unable to update the Event. The Opening Night field is invalid.";
		}

		this.m_estimated_dates = Common.convertYesNoToBool(request.getParameter("f_estimated_dates"));
	}

	private boolean existInEvents(int mode) {

		// boolean isEventNameExistInEvent = false;
		// boolean isVenueExistInEvent = false;
		// boolean isFirstDateExistInEvent = false;
		// String sqlString = "";
		boolean ret_val = false;
		String l_sqlStr = "";
		CachedRowSet rset;

		try {

			Statement stmt = m_db.m_conn.createStatement();
			// check for duplicate name
			if (mode == 2) {
				// rset =
				// m_db.runSQL("select EVENTID from EVENTS where EVENT_NAME='" +
				// m_db.plSqlSafeString(m_event_name) + "' and EVENTID !=" +
				// m_eventid, stmt);
				l_sqlStr = "select EVENTID from EVENTS where EVENT_NAME='" + m_db.plSqlSafeString(m_event_name) + "' and VENUEID=" + m_venueid;
			} else {
				l_sqlStr = "select EVENTID from EVENTS where EVENT_NAME='" + m_db.plSqlSafeString(m_event_name) + "' and VENUEID=" + m_venueid;

				// rset =
				// m_db.runSQL("select EVENTID from EVENTS where EVENT_NAME='" +
				// m_db.plSqlSafeString(m_event_name) + "'", stmt);
				// rset =
				// m_db.runSQL("select EVENTID from EVENTS where VENUEID=" +
				// m_venueid , stmt);
			}
			// if(rset.next())
			// isEventNameExistInEvent = true;

			/*
			 * // check for duplicate event venue if(mode == 2){ l_sqlStr +="";
			 * //rset = m_db.runSQL("select EVENTID from EVENTS where VENUEID="
			 * + m_venueid + " and EVENTID !=" + m_eventid, stmt); }else{ rset =
			 * m_db.runSQL("select EVENTID from EVENTS where VENUEID=" +
			 * m_venueid , stmt); }
			 */
			// if(rset.next())
			// isVenueExistInEvent = true;

			// check for duplicate first date
			if (mode == 2) {
				// update
				if ((m_ddfirst_date != null && !m_ddfirst_date.equals("")) && (m_mmfirst_date != null && !m_mmfirst_date.equals(""))
						&& (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals(""))) {

					l_sqlStr += " and FIRST_DATE=" + m_db.safeDateFormat(m_ddfirst_date + " " + m_db.getMonthName(Integer.parseInt(m_mmfirst_date), true) + " " + m_yyyyfirst_date);
					// sqlString =
					// "select EVENTID from EVENTS where FIRST_DATE='" +
					// m_ddfirst_date + "-" +
					// m_db.getMonthName(Integer.parseInt(m_mmfirst_date), true)
					// + "-" + m_yyyyfirst_date + "' and EVENTID !=" +
					// m_eventid;
					// rset = m_db.runSQL(sqlString, stmt);
					// if(rset.next())
					// isFirstDateExistInEvent = true;

				} else if (m_mmfirst_date != null && !m_mmfirst_date.equals("")) {
					// means year is not blank
					l_sqlStr += " and MMFIRST_DATE='" + m_mmfirst_date + "' and YYYYFIRST_DATE='" + m_yyyyfirst_date + "'";
					/*
					 * sqlString =
					 * "select EVENTID from EVENTS where DDFIRST_DATE= '' and MMFIRST_DATE='"
					 * + m_mmfirst_date + "' and YYYYFIRST_DATE='" +
					 * m_yyyyfirst_date + "' and EVENTID !=" + m_eventid; rset =
					 * m_db.runSQL(sqlString, stmt); if(rset.next())
					 * isFirstDateExistInEvent = true;
					 */
				} else if (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals("")) {
					l_sqlStr += " and YYYYFIRST_DATE='" + m_yyyyfirst_date + "'";
					/*
					 * sqlString =
					 * "select EVENTID from EVENTS where DDFIRST_DATE= '' and MMFIRST_DATE = '' and YYYYFIRST_DATE='"
					 * + m_yyyyfirst_date + "' and EVENTID !=" + m_eventid; rset
					 * = m_db.runSQL(sqlString, stmt); if(rset.next())
					 * isFirstDateExistInEvent = true;
					 */
				}
				l_sqlStr += " and EVENTID !=" + m_eventid;
			} else {
				// add

				if ((m_ddfirst_date != null && !m_ddfirst_date.equals("")) && (m_mmfirst_date != null && !m_mmfirst_date.equals(""))
						&& (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals(""))) {

					l_sqlStr += " and FIRST_DATE=" + m_db.safeDateFormat(m_ddfirst_date + " " + m_db.getMonthName(Integer.parseInt(m_mmfirst_date), true) + " " + m_yyyyfirst_date);

					// sqlString =
					// "select EVENTID from EVENTS where FIRST_DATE='" +
					// m_ddfirst_date + "-" +
					// m_db.getMonthName(Integer.parseInt(m_mmfirst_date), true)
					// + "-" + m_yyyyfirst_date + "'";
					// rset = m_db.runSQL(sqlString, stmt);
					// if(rset.next())
					// isFirstDateExistInEvent = true;

				} else if (m_mmfirst_date != null && !m_mmfirst_date.equals("")) {
					// means year is not blank
					l_sqlStr += " and MMFIRST_DATE='" + m_mmfirst_date + "' and YYYYFIRST_DATE='" + m_yyyyfirst_date + "'";

					// sqlString =
					// "select EVENTID from EVENTS where DDFIRST_DATE= '' and MMFIRST_DATE='"
					// + m_mmfirst_date + "' and YYYYFIRST_DATE='" +
					// m_yyyyfirst_date + "'";
					// rset = m_db.runSQL(sqlString, stmt);
					// if(rset.next())
					// isFirstDateExistInEvent = true;
				} else if (m_yyyyfirst_date != null && !m_yyyyfirst_date.equals("")) {
					l_sqlStr += " and YYYYFIRST_DATE='" + m_yyyyfirst_date + "'";

					// sqlString =
					// "select EVENTID from EVENTS where DDFIRST_DATE= '' and MMFIRST_DATE = '' and YYYYFIRST_DATE='"
					// + m_yyyyfirst_date + "'";
					// rset = m_db.runSQL(sqlString, stmt);
					// if(rset.next())
					// isFirstDateExistInEvent = true;
				}
			}

			rset = m_db.runSQL(l_sqlStr, stmt);
			if (rset.next())
				ret_val = true;
			else
				ret_val = false;

			stmt.close();

			// DEBUG LINE
			// System.out.println ("SQL String in Event.existInEvents() is\n" +
			// l_sqlStr);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.existInEvents().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
			return (false);
		}
		// if(isEventNameExistInEvent && isVenueExistInEvent &&
		// isFirstDateExistInEvent)

		return (ret_val);
	}

	// //////////////////////
	// Utility methods
	// //////////////////////

	public String getEventInfoForItemDisplay(int p_event_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {
			/*
			 * sqlString =
			 * "SELECT DISTINCT event_name || ', '|| first_date || ', ' || venue.venue_name || ', ' || states.STATE || ', ' || venue.SUBURB as display_info "
			 * + "FROM events, venue, states " + "WHERE eventid=" + p_event_id +
			 * " " + "AND venue.state=states.stateid " +
			 * "AND events.venueid = venue.venueid";
			 */
			// If no day then omit '/'
			// If no month then omit '/'
			sqlString = "SELECT DISTINCT concat(concat_ws(', ', events.event_name , venue.venue_name, venue.suburb, " 
					+ "states.state," 
					+ "concat_ws(' ', events.ddfirst_date, "
					+ "monthname(concat('2000-',events.mmfirst_date, '-01')), " 
					+ "events.yyyyfirst_date))) as display_info " 
					+ "FROM events, venue, states " 
					+ "WHERE eventid=" + p_event_id + " " 
					+ "AND events.venueid = venue.venueid " 
					+ "AND states.stateid = venue.state ";

			/*
			 * list_db_sql = "select eventid, event_name, venue_name, " +
			 * "ddfirst_date || DECODE(ddfirst_date,'','','/') || " + // If no
			 * day then omit '/'
			 * "mmfirst_date || DECODE(mmfirst_date,'','','/') || " + // If no
			 * month then omit '/' "yyyyfirst_date " +
			 */
			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("display_info");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventInfoForItemDislay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public String getEventInfoForCIDisplay(int p_event_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {
			sqlString = "SELECT events.event_name, contentindicator.contentindicator, events.eventid,contentindicator.contentindicatorid "
					+ "FROM events Inner JOIN contentindicator ON (events.content_indicator = contentindicator.contentindicatorid) " + "WHERE eventid=" + p_event_id + " ";

			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("contentindicator");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Contributor.getEventInfoForItemDislay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	public String getEventInfoForDisplay(int p_event_id, Statement p_stmt) {
		String sqlString = "", retStr = "";
		ResultSet l_rs = null;

		try {
			/*
			 * sqlString =
			 * "SELECT DISTINCT event_name || ', '|| first_date || ', ' || venue.venue_name || ', ' || states.STATE || ', ' || venue.SUBURB as display_info "
			 * + "FROM events, venue, states " + "WHERE eventid=" + p_event_id +
			 * " " + "AND venue.state=states.stateid " +
			 * "AND events.venueid = venue.venueid";
			 */
			// If no day then omit '/'
			// If no month then omit '/'
			sqlString = "SELECT DISTINCT concat(concat_ws(', ', events.event_name , venue.venue_name, venue.suburb, " 
					+ "states.state," 
					+ "concat_ws(' ', events.ddfirst_date, "
					+ "monthname(concat('2000-',events.mmfirst_date, '-01')), " 
					+ "events.yyyyfirst_date))) as display_info " 
					+ "FROM events, venue, states " 
					+ "WHERE eventid=" + p_event_id + " " 
					+ "AND events.venueid = venue.venueid " 
					+ "AND states.stateid = venue.state ";

			/*
			 * list_db_sql = "select eventid, event_name, venue_name, " +
			 * "ddfirst_date || DECODE(ddfirst_date,'','','/') || " + // If no
			 * day then omit '/'
			 * "mmfirst_date || DECODE(mmfirst_date,'','','/') || " + // If no
			 * month then omit '/' "yyyyfirst_date " +
			 */
			l_rs = m_db.runSQLResultSet(sqlString, p_stmt);

			if (l_rs.next()) retStr = l_rs.getString("display_info");

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getEventInfoForItemDislay().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (retStr);

	}

	/*
	 * Name: getAssociatedItems (int p_event_id)
	 * 
	 * Purpose: Find any items that are associated to a event.
	 * 
	 * Parameters: p_event_id - The id of the event.
	 * 
	 * Returns: A String with item information if the event is found to be
	 * accociated.
	 */

	public ResultSet getAssociatedItems(int p_event_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT item.itemid, item.catalogueid,  item.item_description, item.citation, ist.description item_sub_type, organisation.name,  states.state,  lookup_codes.code_lov_id,  lookup_codes.description,  lookup_codes.short_code,  `itemevlink`.`eventid` "
					+ "FROM item LEFT JOIN lookup_codes ist ON (item.item_sub_type_lov_id = ist.code_lov_id) INNER JOIN itemevlink ON (itemevlink.itemid = item.itemid)  LEFT JOIN organisation ON (item.institutionid = organisation.organisationid)  LEFT JOIN states ON (organisation.state = states.stateid)  LEFT JOIN lookup_codes ON (item.item_type_lov_id = lookup_codes.code_lov_id) "
					+ "WHERE itemevlink.eventid=" + p_event_id + " " 
					+ "ORDER BY ist.description, item.CITATION";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getAssociatedItems().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

	}

	public ResultSet getAssociatedWorks(int p_event_id, Statement p_stmt) {
		String l_sql = "";
		ResultSet l_rs = null;

		try {

			l_sql = "SELECT events.eventid, work.work_title, work.workid " 
					+ "FROM events INNER JOIN eventworklink ON (events.eventid = eventworklink.eventid) "
					+ "INNER JOIN work ON (eventworklink.workid = work.workid) " 
					+ "WHERE events.eventid=" + p_event_id + " " 
					+ "GROUP BY work.work_title";

			l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in Event.getAssociatedWorks().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
		return (l_rs);

	}
	
	 /*
   * Name: getAllAssociatedWorks ()
   * 
   * Purpose: This method will return the Work details of given Event  
   * 
   * Parameters: event id, Statement
   * 
   * Returns: ResultSet
   */
	 public ResultSet getAllAssociatedWorks(int p_event_id, Statement p_stmt) {
	    String l_sql = "";
	    ResultSet l_rs = null;

	    try {

	      l_sql = "SELECT events.eventid, work.work_title, work.workid " 
	          + "FROM events INNER JOIN eventworklink ON (events.eventid = eventworklink.eventid) "
	          + "INNER JOIN work ON (eventworklink.workid = work.workid) " 
	          + "WHERE events.eventid=" + p_event_id ;

	      l_rs = m_db.runSQLResultSet(l_sql, p_stmt);

	    } catch (Exception e) {
	      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
	      System.out.println("An Exception occured in Event.getAssociatedWorks().");
	      System.out.println("MESSAGE: " + e.getMessage());
	      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
	      System.out.println("CLASS.TOSTRING: " + e.toString());
	      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
	    }
	    return (l_rs);

	 }

	/*
	 * Name: loadLinkedEvents ()
	 * 
	 * Purpose: Sets the class to a contain the Event information for the
	 * specified item id.
	 * 
	 * Parameters: None
	 * 
	 * Returns: None
	 */

	private void loadLinkedEvents() {
		ResultSet l_rs = null;
		String l_sql = "";

		try {
			Statement stmt = m_db.m_conn.createStatement();

			l_sql = "SELECT eventeventlinkid  " 
					+ " FROM eventeventlink el, events e, lookup_codes lu" 
					+ " WHERE eventid=" + m_eventid 
					+ " AND el.childid = e.eventid "
					+ " AND lu.code_lov_id = el.function_lov_id "
					+ " ORDER BY lu.description ASC, event_name ASC";
			l_rs = m_db.runSQLResultSet(l_sql, stmt);
			// Reset the object
			m_event_eventlinks.removeAllElements();
			// System.out.println("loadLinkedEvents");
			while (l_rs.next()) {
				EventEventLink eel = new EventEventLink(m_db);
				eel.load(l_rs.getString("eventeventlinkid"));
				m_event_eventlinks.addElement(eel);
			}
			l_rs.close();
			stmt.close();
		} catch (Exception e) {
			System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
			System.out.println("An Exception occured in loadLinkedEvents().");
			System.out.println("MESSAGE: " + e.getMessage());
			System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
			System.out.println("CLASS.TOSTRING: " + e.toString());
			System.out.println("sqlString: " + l_sql);
			System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
		}
	}
}

/*
 * This file is part of the AusStage Mapping Service
 *
 * The AusStage Mapping Service is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * The AusStage Mapping Service is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the AusStage Mapping Service.  
 * If not, see <http://www.gnu.org/licenses/>.
 */
 
package au.edu.ausstage.mapping;

// import additional AusStage libraries
import au.edu.ausstage.utils.*;
import au.edu.ausstage.mapping.types.*;

// import additional java packages / classes
import java.sql.ResultSet;
import java.util.*;
import org.json.simple.*;

/**
 * A class used to compile the marker data which is used to build
 * maps on web pages
 */
public class MarkerManager {

	// declare private class variables
	DbManager database;
	
	/**
	 * Constructor for this class
	 *
	 * @param database a valid DbManager object
	 */
	public MarkerManager(DbManager database) {
		this.database = database;
	}
	
	/**
	 * A public method to build the marker data for a state
	 * includes australia wide and international markers as well
	 *
	 * @param stateId the unique identifier of the region
	 *
	 * @return        json encoded data as a string
	 */
	public String getStateMarkers(String stateId) {
	
		// check the parameters
		if(stateId.contains("-") == false ) {
			if(InputUtils.isValid(stateId, MarkerServlet.VALID_STATES) == false) {
				// no valid state id was found
				throw new IllegalArgumentException("Missing id parameter. Expected one of: " + InputUtils.arrayToString(MarkerServlet.VALID_STATES));
			}
		} else {
			String tmp[] = stateId.split("-");
			
			if(InputUtils.isValid(tmp[0], MarkerServlet.VALID_STATES) == false) {
				// no valid state id was found
				throw new IllegalArgumentException("Missing id parameter. Expected one of: " + InputUtils.arrayToString(MarkerServlet.VALID_STATES));
			}
			
			return getInternationalMarkers(tmp[1]);
		}
		
		// build the sqlParameters
		String[] sqlParameters = new String[1];
		
		if(stateId.equals("99") == true || stateId.equals("999") == true) {
			// all australian states or all international venues
			sqlParameters[0] = "9";
		} else { 
			// valid state code
			sqlParameters[0] = stateId;
		}
		
		// build the SQL
		String sql = null;
		
		if(stateId.equals("99") == true) {
			// all australian states
			sql = "SELECT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "		  vd.min_event_date, vd.max_event_date "
				+ "FROM venue v, states s , venue_min_max_event_dates vd "
				+ "WHERE v.state < ? "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND v.venueid = vd.venueid";
		} else {
			// international venues
			sql = "SELECT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "		  vd.min_event_date, vd.max_event_date "
				+ "FROM venue v, states s , venue_min_max_event_dates vd "
				+ "WHERE v.state = ? "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND v.venueid = vd.venueid";
		}
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		// build a list of venues
		ResultSet resultSet = results.getResultSet();
		VenueList venues = buildVenueList(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// check what was returned
		if(venues == null) {
			return getEmptyArray();
		}
		
		// build and return the JSON data
		return venueListToJson(venues);
	}
	
	/**
	 * A public method to build the marker data for an international country
	 *
	 * @param countryId the unique identifier for the country
	 *
	 * @return          json encoded data as a string
	 */
	public String getInternationalMarkers(String countryId) {
	
		// double check the parameters
		if(InputUtils.isValid(countryId) == false) {
			throw new IllegalArgumentException("the countryId parameter must be a valid string");
		}
	
		// build the sqlParameters
		String[] sqlParameters = new String[1];
		sqlParameters[0] = countryId;
		
		// build the SQL
		String sql = "SELECT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				   + "       vd.min_event_date, vd.max_event_date "
				   + "FROM venue v, states s , venue_min_max_event_dates vd "
				   + "WHERE v.countryid = ? "
				   + "AND v.state = s.stateid "
				   + "AND latitude IS NOT NULL "
				   + "AND v.venueid = vd.venueid";
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		// build a list of venues
		ResultSet resultSet = results.getResultSet();
		VenueList venues = buildVenueList(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// check what was returned
		if(venues == null) {
			return getEmptyArray();
		}
		
		// build and return the JSON data
		return venueListToJson(venues);
	
	
	}
	
	/**
	 * A public method to build the marker data for a suburb
	 *
	 * @param suburbId the unique identifier of the suburb
	 *
	 * @return         json encoded data as a string
	 */
	public String getSuburbMarkers(String suburbId) {
	
		// declare helper variables
		String[] sqlParameters = null;
	
		// double check the parameters
		if(suburbId.indexOf("_") == -1) {
			throw new IllegalArgumentException("The id parameter is required to have a state code followed by a suburb name separated by a \"_\" character");
		} else {
			sqlParameters = suburbId.split("_");
			if(sqlParameters.length > 2) {
				throw new IllegalArgumentException("The id parameter is required to have a state code followed by a suburb name separated by a \"_\" character");
			} else {
				if(sqlParameters[0].contains("-") == false) {				
					if(InputUtils.isValid(sqlParameters[0], LookupServlet.VALID_STATES) == false) {
						throw new IllegalArgumentException("Invalid state code. Expected one of: " + InputUtils.arrayToString(LookupServlet.VALID_STATES));
					}
				} else {
					if(sqlParameters[0].startsWith("999") == false) {
						throw new IllegalArgumentException("Invalid suburb code. Expected it to start with 999");
					} else {
						return getInternationSuburbMarkers(suburbId);
					}
				}
			}
		}
		
		// tidy up the parameters
		sqlParameters[1] = sqlParameters[1].toLowerCase();
		
		// build the SQL
		String sql = "SELECT DISTINCT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				   + "		          vd.min_event_date, vd.max_event_date "
				   + "FROM venue v, states s, events e, venue_min_max_event_dates vd "
				   + "WHERE v.state = ? "
				   + "AND LOWER(v.suburb) = ? "
				   + "AND v.state = s.stateid "
				   + "AND v.venueid = e.venueid "
				   + "AND latitude IS NOT NULL "
				   + "AND v.venueid = vd.venueid";
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		// build a list of venues
		ResultSet resultSet = results.getResultSet();
		VenueList venues = buildVenueList(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// check what was returned
		if(venues == null) {
			return getEmptyArray();
		}
		
		// build and return the JSON data
		return venueListToJson(venues);
	}
	
	/**
	 * A public method to buld marker data for an international suburb
	 *
	 * @param suburbId the suburb id used to build search criteria
	 * 
	 * @return          json encoded data as a string
	 */
	public String getInternationSuburbMarkers(String suburbId) {
	
		if(suburbId.startsWith("999") == false) {
			throw new IllegalArgumentException("Invalid suburb code. Expected it to start with 999");
		}
		
		// split the id
		String[] ids = suburbId.split("-");
		String[] sqlParameters = ids[1].split("_");
		
		if(sqlParameters.length != 2) {
			throw new IllegalArgumentException("Unable to parse the suburbId");
		}
		
		// tidy up the parameters
		sqlParameters[1] = sqlParameters[1].toLowerCase();
		
		// build the SQL
		String sql = "SELECT DISTINCT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				   + "  		      vd.min_event_date, vd.max_event_date "
				   + "FROM venue v, states s, events e, venue_min_max_event_dates vd "
				   + "WHERE v.countryid = ? "
				   + "AND LOWER(v.suburb) = ? "
				   + "AND v.state = s.stateid "
				   + "AND v.venueid = e.venueid "
				   + "AND latitude IS NOT NULL "
				   + "AND v.venueid = vd.venueid";
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		// build a list of venues
		ResultSet resultSet = results.getResultSet();
		VenueList venues = buildVenueList(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// check what was returned
		if(venues == null) {
			return getEmptyArray();
		}
		
		// build and return the JSON data
		return venueListToJson(venues);
	}
	
	/**
	 * A public method to build marker data for a venue or list of venues
	 *
	 * @param venueId the unique venue ID or a list of venue ids
	 *
	 * @return        json encoded data as a string
	 */
	public String getVenueMarkers(String venueId) {
	
		// declare helper variables
		String[] sqlParameters = null;
	
		// check the parameter
		if(InputUtils.isValid(venueId) == true) {
			if(venueId.indexOf(',') == -1) {
				// a single id
				if(InputUtils.isValidInt(venueId) == false) {
					throw new IllegalArgumentException("The id parameter must be a valid integer");
				}
			} else {
				// multiple ids
				sqlParameters = venueId.split(",");
			
				if(InputUtils.isValidArrayInt(sqlParameters) == false) {
					throw new IllegalArgumentException("The id parameter must contain a list of valid integers seperated by commas only");
				}
			}
		} else {
			throw new IllegalArgumentException("Missing id parameter.");
		}
		
		// double check the parameters
		if(sqlParameters == null) {
			sqlParameters = new String[1];
			sqlParameters[0] = venueId;
		}
		
		// build the SQL
		String sql = null;
		
		if(sqlParameters.length == 1) {
			sql = "SELECT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       vd.min_event_date, vd.max_event_date "
				+ "FROM venue v, states s, venue_min_max_event_dates vd "
				+ "WHERE v.venueid = ? "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND v.venueid = vd.venueid";
		} else {
			sql = "SELECT v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       vd.min_event_date, vd.max_event_date "
				+ "FROM venue v, states s, venue_min_max_event_dates vd "
				+ "WHERE v.venueid IN (";
					   
			// add sufficient place holders for all of the ids
			for(int i = 0; i < sqlParameters.length; i++) {
				sql += "?,";
			}
	
			// tidy up the sql
			sql = sql.substring(0, sql.length() -1);
			
			// finalise the sql string
			sql += ") "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND v.venueid = vd.venueid";
		}
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		// build a list of venues
		ResultSet resultSet = results.getResultSet();
		VenueList venues = buildVenueList(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;	
		
		// check what was returned
		if(venues == null) {
			return getEmptyArray();
		}
		
		// build and return the JSON data
		return venueListToJson(venues);		
	}
	
	/**
	 * A public method to build marker data for a venue or list of venues
	 *
	 * @param organisationId the unique venue ID or a list of venue ids
	 *
	 * @return               json encoded data as a string
	 */
	public String getOrganisationMarkers(String organisationId) {
	
		// declare helper variables
		String[] sqlParameters = null;
	
		// check the parameter
		if(InputUtils.isValid(organisationId) == true) {
			if(organisationId.indexOf(',') == -1) {
				// a single id
				if(InputUtils.isValidInt(organisationId) == false) {
					throw new IllegalArgumentException("The id parameter must be a valid integer");
				}
			} else {
				// multiple ids
				sqlParameters = organisationId.split(",");
			
				if(InputUtils.isValidArrayInt(sqlParameters) == false) {
					throw new IllegalArgumentException("The id parameter must contain a list of valid integers seperated by commas only");
				}
			}
		} else {
			throw new IllegalArgumentException("Missing id parameter.");
		}
		
		// double check the parameters
		if(sqlParameters == null) {
			sqlParameters = new String[1];
			sqlParameters[0] = organisationId;
		}
		
		// build the SQL
		String sql = null;
		
		if(sqlParameters.length == 1) {
			sql = "SELECT DISTINCT o.organisationid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       ovd.min_date, ovd.max_date "
				+ "FROM organisation o, orgevlink oel, events e, venue v, states s, org_venue_min_max_event_dates ovd "
				+ "WHERE o.organisationid = ? "
				+ "AND o.organisationid = oel.organisationid "
				+ "AND oel.eventid = e.eventid " 
				+ "AND e.venueid = v.venueid " 
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND o.organisationid = ovd.organisationid "
				+ "AND v.venueid = ovd.venueid";
		} else {
			sql = "SELECT DISTINCT o.organisationid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       ovd.min_date, ovd.max_date "
				+ "FROM organisation o, orgevlink oel, events e, venue v, states s, org_venue_min_max_event_dates ovd "
				+ "WHERE o.organisationid IN (";
					   
			// add sufficient place holders for all of the ids
			for(int i = 0; i < sqlParameters.length; i++) {
				sql += "?,";
			}
	
			// tidy up the sql
			sql = sql.substring(0, sql.length() -1);
			
			// finalise the sql string
			sql += ") "
				+ "AND o.organisationid = oel.organisationid "
				+ "AND oel.eventid = e.eventid "
				+ "AND e.venueid = v.venueid "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND o.organisationid = ovd.organisationid "
				+ "AND v.venueid = ovd.venueid "
				+ "ORDER BY o.organisationid";
		}
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		ResultSet resultSet = results.getResultSet();
		HashMap<Integer, VenueList> venueListMap = buildVenueListMap(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;	
		
		// check what was returned
		if(venueListMap.size() == 0) {
			return getEmptyArray();
		}		
		
		// return the list
		return buildVenueListMapJSONArray(venueListMap, "organisation").toString();
	}
	
	/**
	 * A public method to build marker data for a venue or list of venues
	 *
	 * @param contributorId  the unique venue ID or a list of venue ids
	 *
	 * @return               json encoded data as a string
	 */
	public String getContributorMarkers(String contributorId) {
	
		// declare helper variables
		String[] sqlParameters = null;
	
		// check the parameter
		if(InputUtils.isValid(contributorId) == true) {
			if(contributorId.indexOf(',') == -1) {
				// a single id
				if(InputUtils.isValidInt(contributorId) == false) {
					throw new IllegalArgumentException("The id parameter must be a valid integer");
				}
			} else {
				// multiple ids
				sqlParameters = contributorId.split(",");
			
				if(InputUtils.isValidArrayInt(sqlParameters) == false) {
					throw new IllegalArgumentException("The id parameter must contain a list of valid integers seperated by commas only");
				}
			}
		} else {
			throw new IllegalArgumentException("Missing id parameter.");
		}
		
		// double check the parameters
		if(sqlParameters == null) {
			sqlParameters = new String[1];
			sqlParameters[0] = contributorId;
		}
		
		// build the SQL
		String sql = null;
		
		if(sqlParameters.length == 1) {
			sql = "SELECT DISTINCT c.contributorid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "                cvd.min_date, cvd.max_date "
				+ "FROM contributor c, conevlink cel, events e, venue v, states s, con_venue_min_max_event_dates cvd "
				+ "WHERE c.contributorid = ? "
				+ "AND c.contributorid = cel.contributorid "
				+ "AND cel.eventid = e.eventid " 
				+ "AND e.venueid = v.venueid "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND c.contributorid = cvd.contributorid "
				+ "AND v.venueid = cvd.venueid";
		} else {
			sql = "SELECT DISTINCT c.contributorid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "                cvd.min_date, cvd.max_date "
				+ "FROM contributor c, conevlink cel, events e, venue v, states s, con_venue_min_max_event_dates cvd "
				+ "WHERE c.contributorid IN (";
					   
			// add sufficient place holders for all of the ids
			for(int i = 0; i < sqlParameters.length; i++) {
				sql += "?,";
			}
	
			// tidy up the sql
			sql = sql.substring(0, sql.length() -1);
			
			// finalise the sql string
			sql += ") "
				+ "AND c.contributorid = cel.contributorid "
				+ "AND cel.eventid = e.eventid "
				+ "AND e.venueid = v.venueid "
				+ "AND v.state = s.stateid "
				+ "AND latitude IS NOT NULL "
				+ "AND c.contributorid = cvd.contributorid "
				+ "AND v.venueid = cvd.venueid "
				+ "ORDER BY c.contributorid";
		}
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		ResultSet resultSet = results.getResultSet();
		HashMap<Integer, VenueList> venueListMap = buildVenueListMap(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;	
		
		// check what was returned
		if(venueListMap.size() == 0) {
			return getEmptyArray();
		}		
		
		// return the list
		return buildVenueListMapJSONArray(venueListMap, "contributor").toString();
	}
	
	/**
	 * A public method to build marker data for a venue or list of venues
	 *
	 * @param contributorId  the unique venue ID or a list of venue ids
	 *
	 * @return               json encoded data as a string
	 */
	public String getEventMarkers(String contributorId) {
	
		// declare helper variables
		String[] sqlParameters = null;
	
		// check the parameter
		if(InputUtils.isValid(contributorId) == true) {
			if(contributorId.indexOf(',') == -1) {
				// a single id
				if(InputUtils.isValidInt(contributorId) == false) {
					throw new IllegalArgumentException("The id parameter must be a valid integer");
				}
			} else {
				// multiple ids
				sqlParameters = contributorId.split(",");
			
				if(InputUtils.isValidArrayInt(sqlParameters) == false) {
					throw new IllegalArgumentException("The id parameter must contain a list of valid integers seperated by commas only");
				}
			}
		} else {
			throw new IllegalArgumentException("Missing id parameter.");
		}
		
		// double check the parameters
		if(sqlParameters == null) {
			sqlParameters = new String[1];
			sqlParameters[0] = contributorId;
		}
		
		// build the SQL
		String sql = null;
		
		if(sqlParameters.length == 1) {
			sql = "SELECT e.eventid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       concat(ifnull(e.yyyyfirst_date,''), ifnull(e.mmfirst_date,''), ifnull(e.ddfirst_date,'')) AS fdate_index, "
				+ "       concat(ifnull(e.yyyylast_date,''), ifnull(e.mmlast_date,''), ifnull(e.ddlast_date,'')) AS ldate_index "
				+ "FROM events e, venue v, states s "
				+ "WHERE e.eventid = ? "
				+ "AND e.venueid = v.venueid " 
				+ "AND v.state = s.stateid "
				+ "AND v.latitude IS NOT NULL";
		} else {
			sql = "SELECT e.eventid, v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, v.latitude, v.longitude, "
				+ "       e.yyyyfirst_date || e.mmfirst_date || e.ddfirst_date AS fdate_index, "
				+ "       e.yyyylast_date || e.mmlast_date || e.ddlast_date AS ldate_index "
				+ "FROM events e, venue v, states s "
				+ "WHERE e.eventid IN (";
					   
			// add sufficient place holders for all of the ids
			for(int i = 0; i < sqlParameters.length; i++) {
				sql += "?,";
			}
	
			// tidy up the sql
			sql = sql.substring(0, sql.length() -1);
			
			// finalise the sql string
			sql += ") "
				+ "AND e.venueid = v.venueid "
				+ "AND v.state = s.stateid "
				+ "AND v.latitude IS NOT NULL ";
		}
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			return getEmptyArray();
		}
		
		// build the dataset using internal objects
		ResultSet resultSet = results.getResultSet();
		HashMap<Integer, VenueList> venueListMap = buildVenueListMap(resultSet);
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;	
		
		// check what was returned
		if(venueListMap.size() == 0) {
			return getEmptyArray();
		}		
		
		// return the list
		return buildVenueListMapJSONArray(venueListMap, "event").toString();
	}
	
	/**
	 * A private method to build a venue list map given a resultset
	 * Assumes the first column is the index to the map
	 *
	 * @param resultSet the result set to proces
	 *
	 * @return          a completed map
	 */
	private HashMap<Integer, VenueList> buildVenueListMap(ResultSet resultSet) {
	
		// declare helper variables
		HashMap<Integer, VenueList> venueListMap = new HashMap<Integer, VenueList>();
		VenueList  venues = null;
		Venue      venue  = null;
		
		try {
			// loop through the resultset
			while (resultSet.next()) {
			
				if(venueListMap.containsKey(Integer.parseInt(resultSet.getString(1))) == true) {
					venues = venueListMap.get(Integer.parseInt(resultSet.getString(1)));
				} else {
					venues = new VenueList();
					venueListMap.put(Integer.parseInt(resultSet.getString(1)), venues);
				}
			
				// build a new venue object
				venue = new Venue(resultSet.getString(2));
				
				// add the other information
				venue.setName(resultSet.getString(3));
				venue.setStreet(resultSet.getString(4));
				venue.setSuburb(resultSet.getString(5));
				venue.setState(resultSet.getString(6));
				venue.setPostcode(resultSet.getString(7));
				venue.setLatitude(resultSet.getString(8));
				venue.setLongitude(resultSet.getString(9));
				venue.setUrl(LinksManager.getVenueLink(resultSet.getString(2)));
				venue.setMinEventDate(resultSet.getString(10));
				venue.setMaxEventDate(resultSet.getString(11));
				
				// add the venue to the list
				venues.addVenue(venue);			
			}
		
		} catch (java.sql.SQLException ex) {
			return null;
		}
		
		return venueListMap;	
	}
	
	/**
	 * A private method to take a venueListMap and convert it into a JSONArray of objects
	 *
	 * @param venueListMap the venue list map to process
	 *
	 * @return             the JSONArray representing the map
	 */
	@SuppressWarnings("unchecked") 
	private JSONArray buildVenueListMapJSONArray(HashMap<Integer, VenueList> venueListMap) {
	
		// declare helper variables
		Collection keys     = venueListMap.keySet();
		Iterator   iterator = keys.iterator();
		
		JSONArray list = new JSONArray();
		JSONObject object;
		Integer index;
		
		VenueList  venues = null;
		Venue      venue  = null;
		
		// loop through the map
		
		while(iterator.hasNext()) {
			
			// get the index
			index = (Integer)iterator.next();
			
			// get the venue list
			venues = (VenueList)venueListMap.get(index);
			
			// create a new object
			object = new JSONObject();
			
			// add the index and the venues
			object.put("id", index);
			object.put("venues", venueListToJsonArray(venues));
			
			// add this object to the list
			list.add(object);
		}
		
		return list;	
	}
	
	/**
	 * A private method to take a venueListMap and convert it into a JSONArray of objects
	 *
	 * @param venueListMap the venue list map to process
	 * @param extraData    a field to indicate the additional data is required
	 *
	 * @return             the JSONArray representing the map
	 */
	@SuppressWarnings("unchecked") 
	private JSONArray buildVenueListMapJSONArray(HashMap<Integer, VenueList> venueListMap, String extraData) {
	
		if(extraData == null) {
			return buildVenueListMapJSONArray(venueListMap);
		} else {
			// declare helper variables
			Collection keys     = venueListMap.keySet();
			Iterator   iterator = keys.iterator();
		
			JSONArray list = new JSONArray();
			JSONObject object;
			Integer index;
		
			VenueList  venues = null;
			Venue      venue  = null;
			
			LookupManager lookup     = new LookupManager(database);
			String        lookupData = null;
			Object        obj        = null;
		
			// loop through the map
		
			while(iterator.hasNext()) {
			
				// get the index
				index = (Integer)iterator.next();
			
				// get the venue list
				venues = (VenueList)venueListMap.get(index);
			
				// create a new object
				object = new JSONObject();
			
				// add the index and the venues
				object.put("id", index);
				
				// get the extra data
				if(extraData.equals("contributor") == true) {
					lookupData = lookup.getContributor(Integer.toString(index));
					obj = JSONValue.parse(lookupData);
					object.put("extra", (JSONArray)obj);
				} else if(extraData.equals("organisation") == true) {
					lookupData = lookup.getOrganisation(Integer.toString(index));
					obj = JSONValue.parse(lookupData);
					object.put("extra", (JSONArray)obj);
				} else if(extraData.equals("event") == true) {
					lookupData = lookup.getEvent(Integer.toString(index));
					obj = JSONValue.parse(lookupData);
					object.put("extra", (JSONArray)obj);
				}
				
				object.put("venues", venueListToJsonArray(venues));
			
				// add this object to the list
				list.add(object);
			}
		
			return list;
		}	
	} 
	
	/**
	 * A private method to build a venueList given a resultSet
	 *
	 * @param resultSet the result set to process
	 *
	 * @return          a completed venueList
	 */
	private VenueList buildVenueList(ResultSet resultSet) {
		
		// declare helper variables
		VenueList venues = new VenueList();
		Venue     venue  = null;
	
		try {
			// loop through the resultset
			while (resultSet.next()) {
			
				// build a new venue object
				venue = new Venue(resultSet.getString(1));
				
				// add the other information
				venue.setName(resultSet.getString(2));
				venue.setStreet(resultSet.getString(3));
				venue.setSuburb(resultSet.getString(4));
				venue.setState(resultSet.getString(5));
				venue.setPostcode(resultSet.getString(6));
				venue.setLatitude(resultSet.getString(7));
				venue.setLongitude(resultSet.getString(8));
				venue.setUrl(LinksManager.getVenueLink(resultSet.getString(1)));
				venue.setMinEventDate(resultSet.getString(9));
				venue.setMaxEventDate(resultSet.getString(10));
				
				// add the venue to the list
				venues.addVenue(venue);			
			}
		
		} catch (java.sql.SQLException ex) {
			return null;
		}
		
		// if we get this far everything worked as expected
		return venues;	
	}
	
	/**
	 * A private method to build a JSON array of venue objects using a VenueList
	 *
	 * @param venues an instance of the VenueList object
	 *
	 * @return       the JSON encoded string 
	 */
	@SuppressWarnings("unchecked") 
	private String venueListToJson(VenueList venues) {
	
		// declare helper variables
		JSONArray  list   = venueListToJsonArray(venues);
		return list.toString();
	}
	
	/**
	 * A private method to build a JSON array of venue objects using a VenueList
	 *
	 * @param venues an instance of the VenueList object
	 *
	 * @return       the JSON encoded string 
	 */
	@SuppressWarnings("unchecked") 
	private JSONArray venueListToJsonArray(VenueList venues) {
	
		// declare helper variables
		JSONArray  list   = new JSONArray();
		JSONObject object = null;
		Venue      venue  = null;
		
		// get the iterator for the list
		Set<Venue> venueSet      = venues.getVenues();
		Iterator   venueIterator = venueSet.iterator();
		
		// iterate over the venues
		while(venueIterator.hasNext()) {
		
			// get the current venue
			venue = (Venue)venueIterator.next();		
			
			// add this object to the list
			list.add(venueToJson(venue));			
		}
		
		// return the JSON encoded string
		return list;
	}
	
	
	
	/**
	 * A private method to return the JSON version of a venue object
	 *
	 * @param venue a valid venue object
	 *
	 * @return      the JSON object
	 */
	@SuppressWarnings("unchecked")
	private JSONObject venueToJson(Venue venue) {
	
		JSONObject object = new JSONObject();
		String[]   dates  = null;
		
		object.put("id", venue.getId());
		object.put("name", venue.getName());
		object.put("street", venue.getStreet());
		object.put("suburb", venue.getSuburb());
		object.put("postcode", venue.getPostcode());
		object.put("latitude", venue.getLatitude());
		object.put("longitude", venue.getLongitude());
		object.put("url", venue.getUrl());
		
		// get the dates for comparison		
		try {
			dates = DateUtils.getDatesForTimeline(venue.getMinEventDate(), venue.getMaxEventDate());
			
			object.put("minEventDate", DateUtils.getIntegerFromDate(dates[0]));
			object.put("maxEventDate", DateUtils.getIntegerFromDate(dates[1]));
		} catch (Exception e) {}
		
		return object;	
	}
	
	/**
	 * A private method to return an empty JSON array
	 *
	 * @return an empty JSON array as a string
	 */
	@SuppressWarnings("unchecked")
	private String getEmptyArray() {
		JSONArray list = new JSONArray();
		return list.toString();
	}
	
	/**
	 * A private method to return an empty JSON object
	 *
	 * @return an empty JSON object as a string
	 */
	@SuppressWarnings("unchecked")
	private String getEmptyObject() {
		JSONObject object = new JSONObject();
		return object.toString();
	}
	
} // end class definition

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
import java.util.Set;
import java.util.Iterator;
import org.json.simple.*;
import org.json.simple.parser.*;

/**
 * A class used to compile the marker data which is used to build
 * maps on web pages
 */
public class SearchManager {

	// declare private class variables
	DbManager database;
	
	/**
	 * Constructor for this class
	 *
	 * @param database a valid DbManager object
	 */
	public SearchManager(DbManager database) {
		this.database = database;
	}
	
	/*
	 * organisation searching
	 */
	
	
	/** 
	 * A method to undertake an Organisation search
	 *
	 * @param searchType the type of search to undertake
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 * @param sortType   the way in which to sort the results
	 * @param limit      the number to limit the search results
	 */
	public String doOrganisationSearch(String searchType, String query, String formatType, String sortType, Integer limit) {
	
		// check on the parameters
		if(InputUtils.isValid(searchType) == false || InputUtils.isValid(query) == false) {
			throw new IllegalArgumentException("All of the parameters to this method are required");
		}
		
		// double check the parameter
		if(searchType.equals("id") != true) {
			if(InputUtils.isValidInt(limit, SearchServlet.MIN_LIMIT, SearchServlet.MAX_LIMIT) == false) {
				throw new IllegalArgumentException("Limit parameter must be between '" + SearchServlet.MIN_LIMIT + "' and '" + SearchServlet.MAX_LIMIT + "'");
			}
		}
		
		if(InputUtils.isValid(formatType) == false) {
			formatType = "json";
		} 
		
		if(InputUtils.isValid(sortType) == false) {
			sortType = "id";
		}
		
		// get the results of the search
		String data = null;
		
		if(searchType.equals("id") == true) {
			data = doOrganisationIdSearch(query, formatType);
		} else {
			data = doOrganisationNameSearch(query, formatType, sortType, limit);
		}
	
		// return the data
		return data;
		
	} 
	
	/**
	 * A private method to undertake an organisation name search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for theresults
	 * @param sortType   the sort order for the results
	 * @param limit      the maximum number of search results
	 *
	 * @return           the search results encoded in the requested format
	 */
	private String doOrganisationNameSearch(String query, String formatType, String sortType, Integer limit) {
	
		// sanitise the search query
		query = sanitiseQuery(query);
		
		// declare the sql variables
		String sql = "SELECT DISTINCT o.organisationid, o.name, o.address, o.suburb, s.state, o.postcode, " +
			"c.countryname, COUNT(distinct e.eventid), COUNT(v.latitude) " +
			"FROM organisation o " +
			"INNER JOIN search_organisation so ON so.organisationid = o.organisationid " + 
			"INNER JOIN orgevlink oel ON o.organisationid = oel.organisationid " +
			"INNER JOIN events e ON oel.eventid = e.eventid " +
			"INNER JOIN venue v ON e.venueid = v.venueid  " +
			"INNER JOIN states s ON o.state = s.stateid " +
			"INNER JOIN country c ON o.countryid = c.countryid " +
			"WHERE MATCH(so.combined_all) AGAINST (? IN BOOLEAN MODE) " +
			"GROUP BY o.organisationid, o.name, o.address, o.suburb, s.state, o.postcode, c.countryname ";
				   
		// finalise the sql
		if(sortType.equals("name") == true) {
			sql += "ORDER BY name";
		} else {
			sql += "ORDER BY organisationid";
		}
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		OrganisationList list          = new OrganisationList();
		Organisation     organisation  = null;
		JSONArray        jsonList      = new JSONArray();
		Integer          loopCount     = 0;
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		// build the list of results
		try {
		
			// loop through the resulset
			while(resultSet.next() && loopCount < limit) {
			
				// build the organisation object
				organisation = new Organisation(resultSet.getString(1));
				organisation.setName(resultSet.getString(2));
				organisation.setUrl(LinksManager.getOrganisationLink(resultSet.getString(1)));
				organisation.setAddress(resultSet.getString(3));
				organisation.setSuburb(resultSet.getString(4));
				organisation.setState(resultSet.getString(5));
				organisation.setPostcode(resultSet.getString(6));
				organisation.setCountry(resultSet.getString(7));
				organisation.setEventCount(resultSet.getString(8));
				organisation.setMappedEventCount(resultSet.getString(9));
		
				// add the organisation to the list
				list.addOrganisation(organisation);
				
				// increment the loop count
				loopCount++;
			}
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			if(sortType.equals("name") == true) {
				data = createJSONOutput(list, OrganisationList.ORGANISATION_NAME_SORT);
			} else {
				data = createJSONOutput(list, null);
			}
		}
		
		// return the data
		return data;
	}
	
	/**
	 * A private method to undertake a Organisation id search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 *
	 * @return           the results of the search
	 */
	private String doOrganisationIdSearch(String query, String formatType) {

		// declare the SQL variables
		String sql = "SELECT DISTINCT o.organisationid, o.name, o.address, o.suburb, s.state, o.postcode, " +
			"c.countryname, COUNT(distinct e.eventid), COUNT(v.latitude) " +
			"FROM organisation o " +
			"INNER JOIN search_organisation so ON so.organisationid = o.organisationid " + 
			"INNER JOIN orgevlink oel ON o.organisationid = oel.organisationid " +
			"INNER JOIN events e ON oel.eventid = e.eventid " +
			"INNER JOIN venue v ON e.venueid = v.venueid  " +
			"INNER JOIN states s ON o.state = s.stateid " +
			"INNER JOIN country c ON o.countryid = c.countryid " +
			"WHERE o.organisationid = ? " +
			"GROUP BY o.organisationid, o.name, o.address, o.suburb, s.state, o.postcode, c.countryname ";
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		OrganisationList list          = new OrganisationList();
		Organisation     organisation  = null;
		JSONArray        jsonList      = new JSONArray();
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		try {
		
			// move to the result record
			resultSet.next();
			
			// build the organisation object
			organisation = new Organisation(resultSet.getString(1));
			organisation.setName(resultSet.getString(2));
			organisation.setUrl(LinksManager.getOrganisationLink(resultSet.getString(1)));
			organisation.setAddress(resultSet.getString(3));
			organisation.setSuburb(resultSet.getString(4));
			organisation.setState(resultSet.getString(5));
			organisation.setPostcode(resultSet.getString(6));
			organisation.setCountry(resultSet.getString(7));
			organisation.setEventCount(resultSet.getString(8));
			organisation.setMappedEventCount(resultSet.getString(9));			
		
			// add the organisation to the list
			list.addOrganisation(organisation);
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		 
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			data = createJSONOutput(list, null);
		}
		
		// return the data
		return data;
			
	} 
	
	/**
	 * A method to take a group of collaborators and output JSON encoded text
	 *
	 * @param collaborators the list of organisations
	 * @param sortOrder     the order to sort the list of organisations as defined in the OrganisationList class
	 * @return              the JSON encoded string
	 */
	@SuppressWarnings("unchecked")
	private String createJSONOutput(OrganisationList orgList, Integer sortOrder) {
	
		Set<Organisation> organisations = null;
		
		if(sortOrder != null) {
			if(InputUtils.isValidInt(sortOrder, OrganisationList.ORGANISATION_ID_SORT, OrganisationList.ORGANISATION_NAME_SORT) != false) {
				if(sortOrder == OrganisationList.ORGANISATION_ID_SORT) {
					organisations = orgList.getSortedOrganisations(OrganisationList.ORGANISATION_ID_SORT);
				} else {
					organisations = orgList.getSortedOrganisations(OrganisationList.ORGANISATION_NAME_SORT);
				}
			} else {
				organisations = orgList.getOrganisations();
			}
		} else {
			organisations = orgList.getOrganisations();
		}		
	
		// assume that all sorting and ordering has already been carried out
		// loop through the list of organisations and add them to the new JSON objects
		Iterator iterator = organisations.iterator();
		
		// declare helper variables
		JSONArray  list = new JSONArray();
		JSONObject object = null;
		Organisation organisation = null;
		
		while(iterator.hasNext()) {
		
			// get the organisation
			organisation = (Organisation)iterator.next();
			
			// start a new JSON object
			object = new JSONObject();
			
			// build the object
			object.put("id", organisation.getId());
			object.put("url", organisation.getUrl());
			object.put("name", organisation.getName());
			object.put("address", organisation.getAddress());
			object.put("suburb", organisation.getSuburb());
			object.put("state", organisation.getState());
			object.put("postcode", organisation.getPostcode());
			object.put("country", organisation.getCountry());
			object.put("totalEventCount", new Integer(organisation.getEventCount()));
			object.put("mapEventCount", new Integer(organisation.getMappedEventCount()));
			
			// add the new object to the array
			list.add(object);		
		}
		
		// return the JSON encoded string
		return list.toString();
			
	} 
	
	/*
	 * contributor searching
	 */
	
	
	/** 
	 * A method to undertake a Contributor search
	 *
	 * @param searchType the type of search to undertake
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 * @param sortType   the way in which to sort the results
	 * @param limit      the number to limit the search results
	 */
	public String doContributorSearch(String searchType, String query, String formatType, String sortType, Integer limit) {
	
		// check on the parameters
		if(InputUtils.isValid(searchType) == false || InputUtils.isValid(query) == false) {
			throw new IllegalArgumentException("All of the parameters to this method are required");
		}
		
		// double check the parameter
		if(searchType.equals("id") != true) {
			if(InputUtils.isValidInt(limit, SearchServlet.MIN_LIMIT, SearchServlet.MAX_LIMIT) == false) {
				throw new IllegalArgumentException("Limit parameter must be between '" + SearchServlet.MIN_LIMIT + "' and '" + SearchServlet.MAX_LIMIT + "'");
			}
		}
		
		if(InputUtils.isValid(formatType) == false) {
			formatType = "json";
		} 
		
		if(InputUtils.isValid(sortType) == false) {
			sortType = "id";
		}
		
		// get the results of the search
		String data = null;
		
		if(searchType.equals("id") == true) {
			data = doContributorIdSearch(query, formatType);
		} else {
			data = doContributorNameSearch(query, formatType, sortType, limit);
		}
	
		// return the data
		return data;
		
	} 
	
	/**
	 * A private method to undertake a contrubutor name search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for theresults
	 * @param sortType   the sort order for the results
	 * @param limit      the maximum number of search results
	 *
	 * @return           the search results encoded in the requested format
	 */
	private String doContributorNameSearch(String query, String formatType, String sortType, Integer limit) {
	
		// sanitise the search query
		query = sanitiseQuery(query);
		
		// declare the sql variables
		String sql = "SELECT c.contributorid, c.first_name, c.last_name, sc.event_dates, " +
			"COUNT(distinct e.eventid) AS total_events, COUNT(distinct e.eventid, v.latitude) as mapped_events,  " +
			"REPLACE(GROUP_CONCAT(distinct preferredterm),',','|') AS functions  " +
			"FROM contributor c " +
			"INNER JOIN search_contributor sc ON sc.contributorid = c.contributorid  " +
			"LEFT JOIN conevlink cel ON c.contributorid = cel.contributorid  " +
			"LEFT JOIN events e ON cel.eventid = e.eventid " +
			"LEFT JOIN venue v ON e.venueid = v.venueid " +
			"LEFT JOIN contfunctlink ON c.contributorid = contfunctlink.contributorid " +
			"LEFT JOIN contributorfunctpreferred ON contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid  " +
			"WHERE MATCH(sc.combined_all) AGAINST (? IN BOOLEAN MODE)  " +
			"GROUP BY c.contributorid, c.first_name, c.last_name, sc.event_dates ";
				   
		// finalise the sql
		if(sortType.equals("name") == true) {
			sql += "ORDER BY last_name, first_name";
		} else {
			sql += "ORDER BY contributorid";
		}
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		ContributorList list         = new ContributorList();
		Contributor     contributor  = null;
		JSONArray       jsonList     = new JSONArray();
		Integer         loopCount     = 0;
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		// build the list of results
		try {
		
			// loop through the resulset
			while(resultSet.next() && loopCount < limit) {
			
				// build the contributor object
				contributor = new Contributor(resultSet.getString(1));
				if (resultSet.getString(2) != null) contributor.setFirstName(resultSet.getString(2));
				if (resultSet.getString(3) != null) contributor.setLastName(resultSet.getString(3));
				contributor.setUrl(LinksManager.getContributorLink(resultSet.getString(1)));
				if (resultSet.getString(4) != null) contributor.setEventDates(resultSet.getString(4));
				contributor.setEventCount(resultSet.getString(5));
				contributor.setMappedEventCount(resultSet.getString(6));
				contributor.setFunctions(resultSet.getString(7));			
		
				// add the contrbutor to the list
				list.addContributor(contributor);
				
				// increment the loop count
				loopCount++;
			}
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			if(sortType.equals("name") == true) {
				data = createJSONOutput(list, ContributorList.CONTRIBUTOR_NAME_SORT);
			} else {
				data = createJSONOutput(list, null);
			}
		}
		
		// return the data
		return data;
	}
	
	/**
	 * A private method to undertake a Organisation id search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 *
	 * @return           the results of the search
	 */
	private String doContributorIdSearch(String query, String formatType) {
		
		// declare the SQL variables
		String sql = "SELECT c.contributorid, c.first_name, c.last_name, sc.event_dates, " +
			"COUNT(distinct e.eventid) AS total_events, COUNT(distinct e.eventid, v.latitude) as mapped_events,  " +
			"REPLACE(GROUP_CONCAT(distinct preferredterm),',','|') AS functions  " +
			"FROM contributor c " +
			"INNER JOIN search_contributor sc ON sc.contributorid = c.contributorid  " +
			"LEFT JOIN conevlink cel ON c.contributorid = cel.contributorid  " +
			"LEFT JOIN events e ON cel.eventid = e.eventid " +
			"LEFT JOIN venue v ON e.venueid = v.venueid " +
			"LEFT JOIN contfunctlink ON c.contributorid = contfunctlink.contributorid " +
			"LEFT JOIN contributorfunctpreferred ON contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid  " +
			"WHERE c.contributorid = ? " +
			"GROUP BY c.contributorid, c.first_name, c.last_name, sc.event_dates ";
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		ContributorList list         = new ContributorList();
		Contributor     contributor  = null;
		JSONArray       jsonList     = new JSONArray();
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		try {
		
			// move to the result record
			resultSet.next();
			
			contributor = new Contributor(resultSet.getString(1));
			if (resultSet.getString(2) != null) contributor.setFirstName(resultSet.getString(2));
			if (resultSet.getString(3) != null) contributor.setLastName(resultSet.getString(3));
			contributor.setUrl(LinksManager.getContributorLink(resultSet.getString(1)));
			if (resultSet.getString(4) != null) contributor.setEventDates(resultSet.getString(4));
			contributor.setEventCount(resultSet.getString(5));
			contributor.setMappedEventCount(resultSet.getString(6));
			contributor.setFunctions(resultSet.getString(7));		
		
			// add the contrbutor to the list
			list.addContributor(contributor);
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		 
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			data = createJSONOutput(list, null);
		}
		
		// return the data
		return data;
			
	} 
	

	/**
	 * A method to take a group of collaborators and output JSON encoded text
	 *
	 * @param contribList the list of organisations
	 * @param sortOrder     the order to sort the list of organisations as defined in the OrganisationList class
	 * @return              the JSON encoded string
	 */
	@SuppressWarnings("unchecked")
	private String createJSONOutput(ContributorList contribList, Integer sortOrder) {
	
		Set<Contributor> contributors = null;
		
		if(sortOrder != null) {
			if(InputUtils.isValidInt(sortOrder, ContributorList.CONTRIBUTOR_ID_SORT, ContributorList.CONTRIBUTOR_NAME_SORT) != false) {
				if(sortOrder == ContributorList.CONTRIBUTOR_ID_SORT) {
					contributors = contribList.getSortedContributors(ContributorList.CONTRIBUTOR_ID_SORT);
				} else {
					contributors = contribList.getSortedContributors(ContributorList.CONTRIBUTOR_NAME_SORT);
				}
			} else {
				contributors = contribList.getContributors();
			}
		} else {
			contributors = contribList.getContributors();
		}		
	
		// assume that all sorting and ordering has already been carried out
		// loop through the list of organisations and add them to the new JSON objects
		Iterator iterator = contributors.iterator();
		
		// declare helper variables
		JSONArray  list = new JSONArray();
		JSONArray  functions = new JSONArray();
		JSONObject object = null;
		Contributor contributor = null;
		
		while(iterator.hasNext()) {
		
			// get the organisation
			contributor = (Contributor)iterator.next();
			
			// start a new JSON object
			object = new JSONObject();
			
			// build the object
			object.put("id", contributor.getId());
			object.put("url", contributor.getUrl());
			object.put("firstName", contributor.getFirstName());
			object.put("lastName", contributor.getLastName());
			object.put("eventDates", contributor.getEventDates());
			object.put("totalEventCount", new Integer(contributor.getEventCount()));
			object.put("mapEventCount", new Integer(contributor.getMappedEventCount()));
			
			functions = new JSONArray();
			functions.addAll(contributor.getFunctionsAsArrayList());
			object.put("functions", functions);
			
			// add the new object to the array
			list.add(object);		
		}
		
		// return the JSON encoded string
		return list.toString();
			
	} 
	
	/*
	 * Venue Searching
	 */
	
	/** 
	 * A method to undertake a Venue search
	 *
	 * @param searchType the type of search to undertake
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 * @param sortType   the way in which to sort the results
	 * @param limit      the number to limit the search results
	 */
	public String doVenueSearch(String searchType, String query, String formatType, String sortType, Integer limit) {
	
		// check on the parameters
		if(InputUtils.isValid(searchType) == false || InputUtils.isValid(query) == false) {
			throw new IllegalArgumentException("All of the parameters to this method are required");
		}
		
		// double check the parameter
		if(searchType.equals("id") != true) {
			if(InputUtils.isValidInt(limit, SearchServlet.MIN_LIMIT, SearchServlet.MAX_LIMIT) == false) {
				throw new IllegalArgumentException("Limit parameter must be between '" + SearchServlet.MIN_LIMIT + "' and '" + SearchServlet.MAX_LIMIT + "'");
			}
		}
		
		if(InputUtils.isValid(formatType) == false) {
			formatType = "json";
		} 
		
		if(InputUtils.isValid(sortType) == false) {
			sortType = "id";
		}
		
		// get the results of the search
		String data = null;
		
		if(searchType.equals("id") == true) {
			data = doVenueIdSearch(query, formatType);
		} else {
			data = doVenueNameSearch(query, formatType, sortType, limit);
		}
	
		// return the data
		return data;
		
	} 
	
	/**
	 * A private method to undertake a venue name search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for theresults
	 * @param sortType   the sort order for the results
	 * @param limit      the maximum number of search results
	 *
	 * @return           the search results encoded in the requested format
	 */
	private String doVenueNameSearch(String query, String formatType, String sortType, Integer limit) {
	
		// sanitise the search query
		query = sanitiseQuery(query);
		
		// declare the sql variables
		String sql = "SELECT DISTINCT venue.venueid, venue.venue_name, venue.street, venue.suburb, " +
			"states.state, venue.postcode, venue.latitude, venue.longitude, COUNT(events.eventid), country.countryname " +
			"FROM VENUE " +
			"INNER JOIN SEARCH_VENUE ON venue.venueid = search_venue.venueid " +
			"INNER JOIN events ON  venue.venueid = events.venueid " +
			"INNER JOIN STATES ON venue.state = states.stateid " +
			"INNER JOIN COUNTRY ON venue.countryid = country.countryid " +
			"WHERE MATCH(search_venue.combined_all) AGAINST (? IN BOOLEAN MODE) " +
			"GROUP BY venueid, venue_name, street, suburb, state, postcode, latitude, longitude ";
				   
		// finalise the sql
		if(sortType.equals("name") == true) {
			sql += "ORDER BY venue_name";
		} else {
			sql += "ORDER BY venueid";
		}
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		VenueList  list      = new VenueList();
		Venue      venue     = null;
		JSONArray  jsonList  = new JSONArray();
		Integer    loopCount = 0;
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		// build the list of results
		try {
		
			// loop through the resulset
			while(resultSet.next() && loopCount < limit) {
			
				// build and populate a new venue object
				venue = new Venue(resultSet.getString(1));
				venue.setName(resultSet.getString(2));
				if (resultSet.getString(3) != null) venue.setStreet(resultSet.getString(3));
				if (resultSet.getString(4) != null) venue.setSuburb(resultSet.getString(4));
				if (resultSet.getString(5) != null) venue.setState(resultSet.getString(5));
				if (resultSet.getString(10) != null) venue.setCountry(resultSet.getString(10));
				if (resultSet.getString(6) != null) venue.setPostcode(resultSet.getString(6));
				if (resultSet.getString(7) != null) venue.setLatitude(resultSet.getString(7));
				if (resultSet.getString(8) != null) venue.setLongitude(resultSet.getString(8));
				venue.setEventCount(resultSet.getString(9));
				venue.setUrl(LinksManager.getVenueLink(resultSet.getString(1)));
		
				// add the venue to the list
				list.addVenue(venue);
				
				// increment the loop count
				loopCount++;
			}
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			if(sortType.equals("name") == true) {
				data = createJSONOutput(list, VenueList.VENUE_NAME_SORT);
			} else {
				data = createJSONOutput(list, null);
			}
		}
		
		// return the data
		return data;
	}
	
	
	
	/**
	 * A private method to undertake a Organisation id search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 *
	 * @return           the results of the search
	 */
	private String doVenueIdSearch(String query, String formatType) {
		
		// declare the SQL variables
		String sql = "SELECT DISTINCT venue.venueid, venue.venue_name, venue.street, venue.suburb, " +
			"states.state, venue.postcode, country.countryname, venue.latitude, venue.longitude, COUNT(events.eventid) " +
			"FROM VENUE " +
			"INNER JOIN SEARCH_VENUE ON venue.venueid = search_venue.venueid " +
			"INNER JOIN events ON  venue.venueid = events.venueid " +
			"LEFT JOIN STATES ON venue.state = states.stateid " +
			"LEFT JOIN country ON venue.countryid = country.countryid " +
			"WHERE venue.venueid = ? " +
			"GROUP BY venueid, venue_name, street, suburb, state, postcode, latitude, longitude ";
				   
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		VenueList list     = new VenueList();
		Venue     venue    = null;
		JSONArray jsonList = new JSONArray();
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		try {
		
			// move to the result record
			resultSet.next();
			
			venue = new Venue(resultSet.getString(1));
			if (resultSet.getString(2) != null) venue.setName(resultSet.getString(2));
			if (resultSet.getString(3) != null) venue.setStreet(resultSet.getString(3));
			if (resultSet.getString(4) != null) venue.setSuburb(resultSet.getString(4));
			if (resultSet.getString(5) != null) venue.setState(resultSet.getString(5));
			if (resultSet.getString(6) != null) venue.setPostcode(resultSet.getString(6));
			if (resultSet.getString(7) != null) venue.setCountry(resultSet.getString(7));
			if (resultSet.getString(8) != null) venue.setLatitude(resultSet.getString(8));
			if (resultSet.getString(9) != null) venue.setLongitude(resultSet.getString(9));
			venue.setEventCount(resultSet.getString(10));
			venue.setUrl(LinksManager.getVenueLink(resultSet.getString(1)));
		
			// add the venue to the list
			list.addVenue(venue);
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		 
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			data = createJSONOutput(list, null);
		}
		
		// return the data
		return data;
			
	} 

	/**
	 * A method to take a group of venues and output JSON encoded text
	 *
	 * @param venueList the list of organisations
	 * @param sortOrder     the order to sort the list of organisations as defined in the OrganisationList class
	 *
	 * @return              the JSON encoded string
	 */
	@SuppressWarnings("unchecked")
	private String createJSONOutput(VenueList venueList, Integer sortOrder) {
	
		Set<Venue> venues = null;
		
		if(sortOrder != null) {
			if(InputUtils.isValidInt(sortOrder, VenueList.VENUE_ID_SORT, VenueList.VENUE_NAME_SORT) != false) {
				if(sortOrder == VenueList.VENUE_ID_SORT) {
					venues = venueList.getSortedVenues(VenueList.VENUE_ID_SORT);
				} else {
					venues = venueList.getSortedVenues(VenueList.VENUE_NAME_SORT);
				}
			} else {
				venues = venueList.getVenues();
			}
		} else {
			venues = venueList.getVenues();
		}		
	
		// assume that all sorting and ordering has already been carried out
		// loop through the list of organisations and add them to the new JSON objects
		Iterator iterator = venues.iterator();
		
		// declare helper variables
		JSONArray  list   = new JSONArray();
		JSONObject object = null;
		Venue      venue  = null;
		
		while(iterator.hasNext()) {
		
			// get the organisation
			venue = (Venue)iterator.next();
			
			// start a new JSON object
			object = new JSONObject();
			
			// build the object
			object.put("id", venue.getId());
			object.put("name", venue.getName());
			object.put("street", venue.getStreet());
			object.put("state", venue.getState());
			object.put("suburb", venue.getSuburb());
			object.put("postcode", venue.getPostcode());
			object.put("country", venue.getCountry());
			object.put("latitude", venue.getLatitude());
			object.put("longitude", venue.getLongitude());
			object.put("url", venue.getUrl());
			object.put("totalEventCount", new Integer(venue.getEventCount()));
			
			// add the new object to the array
			list.add(object);		
		}
		
		// return the JSON encoded string
		return list.toString();
			
	} 
	
	/*
	 * Event Searching
	 */
	
	/** 
	 * A method to undertake an Event search
	 *
	 * @param searchType the type of search to undertake
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 * @param sortType   the way in which to sort the results
	 * @param limit      the number to limit the search results
	 */
	public String doEventSearch(String searchType, String query, String formatType, String sortType, Integer limit) {
	
		// check on the parameters
		if(InputUtils.isValid(searchType) == false || InputUtils.isValid(query) == false) {
			throw new IllegalArgumentException("All of the parameters to this method are required");
		}
		
		// double check the parameter
		if(searchType.equals("id") != true) {
			if(InputUtils.isValidInt(limit, SearchServlet.MIN_LIMIT, SearchServlet.MAX_LIMIT) == false) {
				throw new IllegalArgumentException("Limit parameter must be between '" + SearchServlet.MIN_LIMIT + "' and '" + SearchServlet.MAX_LIMIT + "'");
			}
		}
		
		if(InputUtils.isValid(formatType) == false) {
			formatType = "json";
		} 
		
		if(InputUtils.isValid(sortType) == false) {
			sortType = "id";
		}
		
		// get the results of the search
		String data = null;
		
		if(searchType.equals("id") == true) {
			data = doEventIdSearch(query, formatType);
		} else {
			data = doEventNameSearch(query, formatType, sortType, limit);
		}
	
		// return the data
		return data;		
	}
	
	/**
	 * A private method to undertake a Organisation id search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 *
	 * @return           the results of the search
	 */
	private String doEventIdSearch(String query, String formatType) {
		
		// declare the SQL variables
		String sql = "SELECT eventid, event_name, events.yyyyfirst_date, events.mmfirst_date, events.ddfirst_date, events.venueid, " +
			"       concat_ws('',events.yyyyfirst_date, events.mmfirst_date, events.ddfirst_date) as fdate, " + 
			"       concat_ws('',events.yyyylast_date, events.mmlast_date, events.ddlast_date) as ldate " + 
			"	   FROM events, venue " + 
			"WHERE eventid = ? " + 
			"AND events.venueid = venue.venueid";
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		EventList  list     = new EventList();
		Event      event    = null;
		JSONArray  jsonList = new JSONArray();
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		try {
		
			// move to the result record
			resultSet.next();
			
			// build the event object
			event = new Event(resultSet.getString(1));
			if (resultSet.getString(2) != null) event.setName(resultSet.getString(2));
			if (resultSet.getString(3) != null) event.setFirstDate(DateUtils.buildDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5)));
			if (resultSet.getString(3) != null) event.setFirstDisplayDate(DateUtils.buildDisplayDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5)));
			if (resultSet.getString(6) != null) event.setVenue(doVenueIdSearch(resultSet.getString(6), formatType));
			event.setUrl(LinksManager.getEventLink(resultSet.getString(1)));
			if (resultSet.getString(7) != null) event.setSortFirstDate(resultSet.getString(7));
			if (resultSet.getString(8) != null) event.setSortLastDate(resultSet.getString(8));
		
			// add the event to the list
			list.addEvent(event);
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			//debug code
			System.out.println("####");
			return jsonList.toString();
		}
		 
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;		
		
		// determine how to format the result
		String data = null;		
		
		if(formatType.equals("json") == true) {
			data = createJSONOutput(list, null);
		}
		
		// return the data
		return data;
			
	}
	
	/**
	 * A private method to undertake a venue name search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for theresults
	 * @param sortType   the sort order for the results
	 * @param limit      the maximum number of search results
	 *
	 * @return           the search results encoded in the requested format
	 */
	private String doEventNameSearch(String query, String formatType, String sortType, Integer limit) {
	
		// sanitise the search query
		query = sanitiseQuery(query);
		
		// declare the sql variables
		String sql = "SELECT DISTINCT events.eventid, events.event_name, events.yyyyfirst_date, events.mmfirst_date, events.ddfirst_date, events.venueid, "
				   + "       concat_ws('',venue.yyyyfirst_date, venue.mmfirst_date, venue.ddfirst_date) as fdate, " 
				   + "       concat_ws('',venue.yyyylast_date, venue.mmlast_date, venue.ddlast_date) as ldate " 
				   + "FROM events, venue, search_event "
				   + "WHERE MATCH(search_event.combined_all) AGAINST (? IN BOOLEAN MODE) "
				   + "AND search_event.eventid = events.eventid "
				   + "AND events.venueid = venue.venueid ";
				   
		// finalise the sql
		if(sortType.equals("name") == true) {
			sql += "ORDER BY event_name";
		} else {
			sql += "ORDER BY eventid";
		}
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		EventList  list      = new EventList();
		Event      event     = null;
		JSONArray  jsonList  = new JSONArray();
		Integer    loopCount = 0;
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		// build the list of results
		try {
		
			// loop through the resulset
			while(resultSet.next() && loopCount < limit) {
			
				// build the event object
				event = new Event(resultSet.getString(1));
				if (resultSet.getString(2) != null) event.setName(resultSet.getString(2));
				if (resultSet.getString(3) != null) event.setFirstDate(DateUtils.buildDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5)));
				if (resultSet.getString(3) != null) event.setFirstDisplayDate(DateUtils.buildDisplayDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5)));
				if (resultSet.getString(6) != null) event.setVenue(doVenueIdSearch(resultSet.getString(6), formatType));
				event.setUrl(LinksManager.getEventLink(resultSet.getString(1)));
				if (resultSet.getString(7) != null) event.setSortFirstDate(resultSet.getString(7));
				if (resultSet.getString(8) != null) event.setSortLastDate(resultSet.getString(8));
				// add the venue to the list
				list.addEvent(event);
				
				// increment the loop count
				loopCount++;
			}
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			if(sortType.equals("name") == true) {
				data = createJSONOutput(list, EventList.EVENT_NAME_SORT);
			} else {
				data = createJSONOutput(list, null);
			}
		}
		
		// return the data
		return data;
	} 

	/**
	 * A method to take a group of events and output JSON encoded text
	 *
	 * @param eventList the list of organisations
	 * @param sortOrder     the order to sort the list of organisations as defined in the OrganisationList class
	 *
	 * @return              the JSON encoded string
	 */
	@SuppressWarnings("unchecked")
	private String createJSONOutput(EventList eventList, Integer sortOrder) {
	
		Set<Event> events = null;
		
		if(sortOrder != null) {
			if(InputUtils.isValidInt(sortOrder, EventList.EVENT_ID_SORT, EventList.EVENT_NAME_SORT) != false) {
				if(sortOrder == EventList.EVENT_ID_SORT) {
					events = eventList.getSortedEvents(EventList.EVENT_ID_SORT);
				} else {
					events = eventList.getSortedEvents(EventList.EVENT_NAME_SORT);
				}
			} else {
				events = eventList.getEvents();
			}
		} else {
			events = eventList.getEvents();
		}		
	
		// assume that all sorting and ordering has already been carried out
		// loop through the list of organisations and add them to the new JSON objects
		Iterator iterator = events.iterator();
		
		// declare helper variables
		JSONArray  list     = new JSONArray();
		JSONObject object   = null;
		Event      event    = null;
		JSONParser parser   = new JSONParser();
		Object     obj      = null;
		JSONArray  objArray = null;
		String[]   dates    = null;
		
		while(iterator.hasNext()) {
		
			// get the organisation
			event = (Event)iterator.next();
			
			// start a new JSON object
			object = new JSONObject();
			
			// build the object
			object.put("id", event.getId());
			object.put("name", event.getName());
			object.put("firstDate", event.getFirstDate());
			object.put("firstDisplayDate", event.getFirstDisplayDate());
			
			// reconstruct the venue from the string
			try{
				obj = parser.parse(event.getVenue());
				objArray = (JSONArray)obj;
				object.put("venue", objArray.get(0));
			}
			catch(Exception pe){
				System.out.println("Event getvenue= " + event.getVenue());
				
				object.put("venue", null);
			}			
			
			object.put("url", event.getUrl());
			
			// get the dates for comparison
			dates = DateUtils.getDatesForTimeline(event.getSortFirstDate(), event.getSortLastDate());
			
			if (dates[0] != null) object.put("sortFirstDate", DateUtils.getIntegerFromDate(dates[0]));
			if (dates[1] != null) object.put("sortLastDate", DateUtils.getIntegerFromDate(dates[1]));
			
			// add the new object to the array
			list.add(object);		
		}
		
		// return the JSON encoded string
		return list.toString();
	}
	/*
	 * WORKS SEARCHING
	 * 
	 */
	
	/** 
	 * A method to undertake a Work search
	 *
	 * @param searchType the type of search to undertake
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 * @param sortType   the way in which to sort the results
	 * @param limit      the number to limit the search results
	 */
	public String doWorkSearch(String searchType, String query, String formatType, String sortType, Integer limit) {
	
		// check on the parameters
		if(InputUtils.isValid(searchType) == false || InputUtils.isValid(query) == false) {
			throw new IllegalArgumentException("All of the parameters to this method are required");
		}
		
		// double check the parameter
		if(searchType.equals("id") != true) {
			if(InputUtils.isValidInt(limit, SearchServlet.MIN_LIMIT, SearchServlet.MAX_LIMIT) == false) {
				throw new IllegalArgumentException("Limit parameter must be between '" + SearchServlet.MIN_LIMIT + "' and '" + SearchServlet.MAX_LIMIT + "'");
			}
		}
		
		if(InputUtils.isValid(formatType) == false) {
			formatType = "json";
		} 
		
		if(InputUtils.isValid(sortType) == false) {
			sortType = "id";
		}
		
		// get the results of the search
		String data = null;
		
		if(searchType.equals("id") == true) {
			data = doWorkIdSearch(query, formatType);
		} else {
			data = doWorkNameSearch(query, formatType, sortType, limit);
		}
	
		// return the data
		return data;
		
	} 
	
	/**
	 * A private method to undertake a work name search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for theresults
	 * @param sortType   the sort order for the results
	 * @param limit      the maximum number of search results
	 *
	 * @return           the search results encoded in the requested format
	 */
	private String doWorkNameSearch(String query, String formatType, String sortType, Integer limit) {
		// sanitise the search query
		query = sanitiseQuery(query);
		
		// declare the sql variables
		String sql =  " SELECT w.workid, w.work_title, " 
					+ " COUNT(distinct e.eventid) AS total_events, COUNT(distinct e.eventid, v.latitude) as mapped_events "
					+ " FROM work w "
					+ " INNER JOIN search_work sw ON sw.workid = w.workid "  
					+ " LEFT JOIN eventworklink ewl ON w.workid = ewl.workid "  
					+ " LEFT JOIN events e ON ewl.eventid = e.eventid "
					+ " LEFT JOIN venue v ON e.venueid = v.venueid " 
					+ " WHERE MATCH(sw.combined_all) AGAINST (? IN BOOLEAN MODE) "  
					+ " GROUP BY w.workid, w.work_title ";
				   
		// finalise the sql
		if(sortType.equals("name") == true) {
			sql += "ORDER BY w.work_title";
		} else {
			sql += "ORDER BY w.workid";
		}
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		WorkList list          		   = new WorkList();
		Work		     work		   = null;
		JSONArray        jsonList      = new JSONArray();
		Integer          loopCount     = 0;
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		// build the list of results
		try {
			
			// loop through the resulset
			while(resultSet.next() && loopCount < limit) {
				
				// build the work object
				work = new Work(resultSet.getString(1));
				
				work.setName(resultSet.getString(2));
				
				/*
				 * nasty little piece of hardcoding because for some reason I couldn't get the method LinksManager.getWorkLink 
				 * to be recognised at runtime.
				 * Kept getting the following error
				 * java.lang.NoSuchMethodError: au.edu.ausstage.utils.LinksManager.getWorkLink(Ljava/lang/String;)Ljava/lang/String;
				 */
				
				// double check the parameter
				if(InputUtils.isValidInt(resultSet.getString(1)) == false) {
					System.out.println("error");
					throw new IllegalArgumentException("The id parameter must be a valid integer");
				} else {
					System.out.println("success!");
					work.setUrl("http://www.ausstage.edu.au/pages/work/"+resultSet.getString(1));
				}
				//work.setUrl(LinksManager.getWorkLink(resultSet.getString(1)));
				
				work.setEventCount(resultSet.getString(3));
				work.setMappedEventCount(resultSet.getString(4));
				// add the work to the list
				list.addWork(work);
				
				// increment the loop count
				loopCount++;
			}
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			if(sortType.equals("name") == true) {
				data = createJSONOutput(list, WorkList.WORK_NAME_SORT);
			} else {
				data = createJSONOutput(list, null);
			}
		}
		
		// return the data
		return data;
	}
	
	/**
	 * A private method to undertake a Work id search
	 *
	 * @param query      the search query to use
	 * @param formatType the type of data format for the results
	 *
	 * @return           the results of the search
	 */
	private String doWorkIdSearch(String query, String formatType) {

		// declare the SQL variables
		String sql = " SELECT w.workid, w.work_title, " 
			+ " COUNT(distinct e.eventid) AS total_events, COUNT(distinct e.eventid, v.latitude) as mapped_events "
			+ " FROM work w "
			+ " INNER JOIN search_work sw ON sw.workid = w.workid "  
			+ " LEFT JOIN eventworklink ewl ON w.workid = ewl.workid "  
			+ " LEFT JOIN events e ON ewl.eventid = e.eventid "
			+ " LEFT JOIN venue v ON e.venueid = v.venueid " 
			+ " WHERE w.workid = ? "  
			+ " GROUP BY w.workid, w.work_title ";
				   
		// define the paramaters
		String[] sqlParameters = {query};
		
		// declare additional helper variables
		WorkList list          		     = new WorkList();
		Work		     		work     = null;
		JSONArray        		jsonList = new JSONArray();
		
		// get the data
		DbObjects results = database.executePreparedStatement(sql, sqlParameters);
		
		// check to see that data was returned
		if(results == null) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		
		// build the result data
		ResultSet resultSet = results.getResultSet();
		
		try {
		
			// move to the result record
			resultSet.next();
			
			// build the work object
			work = new Work(resultSet.getString(1));
			work.setName(resultSet.getString(2));
			/*
			 * nasty little piece of hardcoding because for some reason I couldn't get the method LinksManager.getWorkLink 
			 * to be recognised at runtime.
			 * Kept getting the following error
			 * java.lang.NoSuchMethodError: au.edu.ausstage.utils.LinksManager.getWorkLink(Ljava/lang/String;)Ljava/lang/String;
			 */
			
			// double check the parameter
			if(InputUtils.isValidInt(resultSet.getString(1)) == false) {
				System.out.println("error");
				throw new IllegalArgumentException("The id parameter must be a valid integer");
			} else {
				System.out.println("success!");
				work.setUrl("http://www.ausstage.edu.au/pages/work/"+resultSet.getString(1));
			}
			//work.setUrl(LinksManager.getWorkLink(resultSet.getString(1)));
			
			//work.setUrl(LinksManager.getWorkLink(resultSet.getString(1)));
			work.setEventCount(resultSet.getString(3));
			work.setMappedEventCount(resultSet.getString(4));			
		
			// add the work to the list
			list.addWork(work);
		
		} catch (java.sql.SQLException ex) {
			// return an empty JSON Array
			return jsonList.toString();
		}
		 
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		
		// determine how to format the result
		String data = null;		
		if(formatType.equals("json") == true) {
			data = createJSONOutput(list, null);
		}
		
		// return the data
		return data;
			
	} 
	
	/**
	 * A method to take a group of collaborators and output JSON encoded text
	 *
	 * @param collaborators the list of organisations
	 * @param sortOrder     the order to sort the list of organisations as defined in the OrganisationList class
	 * @return              the JSON encoded string
	 */
	@SuppressWarnings("unchecked")
	private String createJSONOutput(WorkList workList, Integer sortOrder) {
	
		Set<Work> works = null;
		
		if(sortOrder != null) {
			if(InputUtils.isValidInt(sortOrder, WorkList.WORK_ID_SORT, WorkList.WORK_NAME_SORT) != false) {
				if(sortOrder == WorkList.WORK_ID_SORT) {
					works = workList.getSortedWorks(WorkList.WORK_ID_SORT);
				} else {
					works = workList.getSortedWorks(WorkList.WORK_NAME_SORT);
				}
			} else {
				works = workList.getWorks();
			}
		} else {
			works = workList.getWorks();
		}		
	
		// assume that all sorting and ordering has already been carried out
		// loop through the list of organisations and add them to the new JSON objects
		Iterator iterator = works.iterator();
		
		// declare helper variables
		JSONArray  list = new JSONArray();
		JSONObject object = null;
		Work work = null;
		
		while(iterator.hasNext()) {
		
			// get the work
			work = (Work)iterator.next();
			
			// start a new JSON object
			object = new JSONObject();
			
			// build the object
			object.put("id", work.getId());
			object.put("url", work.getUrl());
			object.put("name", work.getName());
			object.put("totalEventCount", new Integer(work.getEventCount()));
			object.put("mapEventCount", new Integer(work.getMappedEventCount()));
			
			// add the new object to the array
			list.add(object);		
		}
		
		// return the JSON encoded string
		return list.toString();
			
	} 
	
	
	
	/**
	 * A private method to sanitise the search query by:
	 * stripping white space, search operator keywords and punctuation as well as automatically add and between each search term
	 *
	 * @param query the search query
	 *
	 * @return      the sanitised search query
	 */
	private String sanitiseQuery(String query) {
	
		// trim the query
		query = query.trim();
		
		// change search query to lower case
		query = query.toLowerCase();
		
		if(query.startsWith("\"") == false && query.endsWith("\"") == false) {
		
			// remove any existing search terms and other punctuation
			query = query.replace(" and ", "");
			query = query.replace(" or ", "");
			query = query.replace(" not ", "");
			query = query.replace("\"", "");
			query = query.replace("\'", "");
			
		
			// remove any punctuation
			//query = query.replaceAll("\\p{P}+", "");
		
		}
		
		// return the sanitised query
		return query;	
	}	
} 

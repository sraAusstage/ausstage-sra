/*
 * This file is part of the AusStage Data Exchange Service
 *
 * AusStage Data Exchange Service is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * AusStage Data Exchange Service is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with AusStage Data Exchange Service.  
 * If not, see <http://www.gnu.org/licenses/>.
*/

package au.edu.ausstage.exchange.items;

// import additional AusStage libraries
import au.edu.ausstage.utils.*;
import au.edu.ausstage.exchange.types.*;
import au.edu.ausstage.exchange.builders.*;

import java.util.ArrayList;
import java.sql.ResultSet;

/**
 * The main driving class for the collation of all event data 
 */
public class AllData extends BaseData{

	/**
	 * Constructor for this class
	 *
	 * @param database    the DbManager class used to connect to the database
	 * @param outputType  the output type
	 * @param recordLimit the record limit
	 * @param sortOrder   the order that records must be sorted in
	 *
	 * @throws IllegalArgumentException if any of the parameters are empty or do not pass validation
	 *
	 */
	public AllData(DbManager database, String outputType, String recordLimit, String sortOrder) {
		super(database, outputType, recordLimit, sortOrder);
	}
	
	@Override
	public String getEventData() {
		
		String sql;
		DbObjects results;
		Event event;
		
		String venue;
		String firstDate;
		
		ArrayList<Event> eventList = new ArrayList<Event>();
			
		sql = "SELECT DISTINCT e.eventid, e.event_name, e.yyyyfirst_date, e.mmfirst_date, e.ddfirst_date, "
			+ "       v.venueid, v.venue_name, v.street, v.suburb, s.state, v.postcode, "
			+ "       c.countryname "
			+ "FROM events e "
			+ "INNER JOIN venue v ON e.venueid = v.venueid "
			+ "LEFT join country c on v.countryid = c.countryid "
			+ "LEFT JOIN states s ON v.state = s.stateid ";
				
		// adjust the order by clause
		String sort = getSortOrder();
		if(sort.equals("firstdate") == true) {
			sql += "ORDER BY e.yyyyfirst_date DESC, e.mmfirst_date DESC, e.ddfirst_date DESC";
		} else if(sort.equals("createdate") == true) {
			sql += "ORDER BY e.entered_date DESC";
		} else if(sort.equals("updatedate") == true) {
			sql += "ORDER BY e.updated_date DESC";
		}
		
		// get the data
		results = getDatabase().executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup event data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				// get the venue and first date
				venue = buildShortVenueAddress(resultSet.getString(12), resultSet.getString(8), resultSet.getString(9), resultSet.getString(10));
				venue = resultSet.getString(7) + ", " + venue;
				
				firstDate = DateUtils.buildDisplayDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5));
				
				
				// build a new event and add it to the list
				event = new Event(resultSet.getString(1), resultSet.getString(2), venue, firstDate);
				eventList.add(event);
				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of events: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		// trim the arraylist if necessary
		if(getRecordLimit().equals("all") == false) {
			int limit = getRecordLimitAsInt();
			
			if(eventList.size() > limit) {
			
				ArrayList<Event> list = new ArrayList<Event>();
				
				for(int i = 0; i < limit; i++) {
					list.add(eventList.get(i));
				}
				
				eventList = list;
				list = null;
			}
		}
		
		String data = null;
		
		// build the output
		if(getOutputType().equals("html") == true) {
			data =  EventDataBuilder.buildHtml(eventList);
		} else if(getOutputType().equals("json")) {
			data = EventDataBuilder.buildJson(eventList);
		} else if(getOutputType().equals("xml")) {
			data = EventDataBuilder.buildXml(eventList);
		} else if(getOutputType().equals("rss") == true) {
			data = EventDataBuilder.buildRss(eventList);
		}
		
		return data;
	}
	
	@Override
	public String getResourceData() {
		
		String sql;
		DbObjects results;
		Resource resource;
		
		ArrayList<Resource> resourceList = new ArrayList<Resource>();
		
		
		
		
		
			sql = "SELECT i.itemid, i.citation, ifnull(i.title, 'Untitled') as title "
				+ "FROM item i";
			
		
		
		// adjust the order by clause
		String sort = getSortOrder();
		if(sort.equals("createdate") == true) {
			sql += "ORDER BY i.entered_date DESC";
		} else if(sort.equals("updatedate") == true) {
			sql += "ORDER BY i.updated_date DESC";
		}
		
		// get the data
		results = getDatabase().executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup resource data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
				resource = new Resource(resultSet.getString(1), resultSet.getString(2), resultSet.getString(3));
				resourceList.add(resource);
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of resources: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		// trim the arraylist if necessary
		if(getRecordLimit().equals("all") == false) {
			int limit = getRecordLimitAsInt();
			
			if(resourceList.size() > limit) {
			
				ArrayList<Resource> list = new ArrayList<Resource>();
				
				for(int i = 0; i < limit; i++) {
					list.add(resourceList.get(i));
				}
				
				resourceList = list;
				list = null;
			}
		}
		
		String data = null;
		
		// build the output
		if(getOutputType().equals("html") == true) {
			data =  ResourceDataBuilder.buildHtml(resourceList);
		} else if(getOutputType().equals("json")) {
			data = ResourceDataBuilder.buildJson(resourceList);
		} else if(getOutputType().equals("xml")) {
			data = ResourceDataBuilder.buildXml(resourceList);
		} else if(getOutputType().equals("rss") == true) {
			data = ResourceDataBuilder.buildRss(resourceList);
		}
		
		return data;
	}
}

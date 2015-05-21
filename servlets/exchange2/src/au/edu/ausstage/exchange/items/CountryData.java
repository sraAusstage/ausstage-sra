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
 * The main driving class for the collation of event data using contributor ids
 */
public class CountryData extends BaseData{

	/**
	 * Constructor for this class
	 *
	 * @param database    the DbManager class used to connect to the database
	 * @param ids         the array of unique country ids
	 * @param outputType  the output type
	 * @param recordLimit the record limit
	 * @param sortOrder   the order that records must be sorted in
	 *
	 * @throws IllegalArgumentException if any of the parameters are empty or do not pass validation
	 *
	 */
	public CountryData(DbManager database, String[] ids, String outputType, String recordLimit, String sortOrder) {
	
		super(database, ids, outputType, recordLimit, sortOrder);
	}
	
	@Override
	public String getResourceData() {
		return null;
	}
	
	@Override
		public String getEventData() {
		return null;
	}
	
	public String getVenueData() {
		
		String sql;
		DbObjects results;
		Venue venue;
		
		String address;
		//String firstDate;
		
		ArrayList<Venue> venueList = new ArrayList<Venue>();
		
		String[] ids = getIds();
		
		if(ids.length == 1) {
		
			sql = 	"SELECT v.venueid id, v.venue_name name, v.street street, v.suburb suburb, s.state state, v.postcode postcode, "+
					" c.countryname countryname"+ 
					" FROM country c "+
					" inner join venue v on v.countryid = c.countryid "+ 
					" INNER JOIN states s ON v.state = s.stateid "+ 
					" WHERE c.countryid = ? ";
			
		} else {
		
			sql = 	"SELECT v.venueid id, v.venue_name name, v.street street, v.suburb suburb, s.state state, v.postcode postcode, "+ 
					" c.countryname countryname"+ 
					" FROM country c "+
					" inner join venue v on v.countryid = c.countryid "+ 
					" INNER JOIN states s ON v.state = s.stateid "+ 
					" WHERE c.countryid IN (";
			    
			    // add sufficient place holders for all of the ids
				for(int i = 0; i < ids.length; i++) {
					sql += "?,";
				}

				// tidy up the sql
				sql = sql.substring(0, sql.length() -1);
				
				// finalise the sql string
				sql += ") ";
		}
		
		// adjust the order by clause
		String sort = getSortOrder();
		if(sort.equals("country") == true) {
			sql += "ORDER BY countryname ASC, suburb ASC, name ASC";
		} else if(sort.equals("venue") == true) {
			sql += "ORDER BY name ASC, suburb ASC, countryname ASC";
		} 
		
		// get the data
		results = getDatabase().executePreparedStatement(sql, ids);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup venue data");
		}
	
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				// get the venue and first date
				address = buildFullVenueAddress(resultSet.getString("countryname"), resultSet.getString("street"), resultSet.getString("suburb"),resultSet.getString("postcode"), resultSet.getString("state"));
				//venue = resultSet.getString(7) + ", " + venue;
				
				//firstDate = DateUtils.buildDisplayDate(resultSet.getString(3), resultSet.getString(4), resultSet.getString(5));
				
				// build a new venue and add it to the list
				venue = new Venue(resultSet.getString("id"), resultSet.getString("name"), address);
				venueList.add(venue);
				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of venues: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		// trim the arraylist if necessary
		if(getRecordLimit().equals("all") == false) {
			int limit = getRecordLimitAsInt();
			
			if(venueList.size() > limit) {
			
				ArrayList<Venue> list = new ArrayList<Venue>();
				
				for(int i = 0; i < limit; i++) {
					list.add(venueList.get(i));
				}
				
				venueList = list;
				list = null;
			}
		}
		
		String data = null;
		
		// build the output
		if(getOutputType().equals("html") == true) {
			data =  VenueDataBuilder.buildHtml(venueList);
		} else if(getOutputType().equals("json")) {
			data = VenueDataBuilder.buildJson(venueList);
		} else if(getOutputType().equals("xml")) {
			data = VenueDataBuilder.buildXml(venueList);
		} else if(getOutputType().equals("rss") == true) {
			data = VenueDataBuilder.buildRss(venueList);
		}
		
		return data;
	}
	
}

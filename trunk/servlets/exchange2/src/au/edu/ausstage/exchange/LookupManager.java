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

package au.edu.ausstage.exchange;

// import additional classes
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

// import additional AusStage libraries
import au.edu.ausstage.utils.*;
import java.sql.ResultSet;

/**
 * A class to manage the lookup of secondary genres and content indicators
 */
public class LookupManager {

	// private class level variables
	private DbManager database;

	/**
	 * Constructor for this class
	 *
	 * @param database    the DbManager class used to connect to the database
	 *
	 * @throws IllegalArgumentException if any of the parameters are empty or do not pass validation
	 *
	 */
	public LookupManager(DbManager database) {
	
		// validate the parameters
		if(database == null) {
			throw new IllegalArgumentException("all parameters to this constructor are required");
		}
		
		this.database = database;
	}
	
	/**
	 * A method to build the list of secondary genres
	 *
	 * @return a JSON string containing secondary genres
	 */
	@SuppressWarnings("unchecked")
	public String getSecondaryGenreIdentifiers() {
	
		String sql;
		DbObjects results;
		
		JSONArray list = new JSONArray();
		JSONObject obj;
		
		sql = "SELECT s.secgenrepreferredid, s.preferredterm, ifnull(event_count, 0), ifnull(item_count, 0) "
			+ "from SECGENREPREFERRED S  "
			+ "LEFT JOIN (SELECT s.secgenrepreferredid, COUNT(sl.eventid) AS event_count  "
			+ "FROM secgenrepreferred s, secgenreclasslink sl  "
			+ "where S.SECGENREPREFERREDID = SL.SECGENREPREFERREDID  "
			+ "GROUP BY s.secgenrepreferredid, s.preferredterm) a ON s.secgenrepreferredid = a.secgenrepreferredid "
			+ "LEFT JOIN (SELECT s.secgenrepreferredid, COUNT(il.itemid) AS item_count "
			+ "FROM secgenrepreferred s, itemsecgenrelink il  "
			+ "where S.SECGENREPREFERREDID = IL.SECGENREPREFERREDID  "
			+ "GROUP BY s.secgenrepreferredid, s.preferredterm) b ON S.SECGENREPREFERREDID = B.SECGENREPREFERREDID "
			+ "ORDER BY s.preferredterm ASC";
			
		// get the data
		results = database.executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup secondary genre data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				obj = new JSONObject();
				
				obj.put("id", resultSet.getString(1));
				obj.put("term", resultSet.getString(2));
				obj.put("events", resultSet.getString(3));
				obj.put("items", resultSet.getString(4));
				
				list.add(obj);				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of secondary genres: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		return list.toString();	
	}
	
	/**
	 * A method to build the list of content indicators
	 *
	 * @return a JSON string containing a list of content indicators
	 */
	@SuppressWarnings("unchecked")
	public String getContentIndicatorIdentifiers() {
		
		String sql;
		DbObjects results;
		
		JSONArray list = new JSONArray();
		JSONObject obj;
		
		sql = "SELECT c.contentindicatorid, c.contentindicator, ifnull(event_count, 0), ifnull(item_count, 0)  "
			+ "from contentindicator c  "
			+ "LEFT JOIN (SELECT c.contentindicatorid, COUNT(icl.itemid) AS item_count  "
			+ "       FROM contentindicator c, itemcontentindlink icl "
			+ "       where c.contentindicatorid = icl.contentindicatorid  "
			+ "       GROUP BY c.contentindicatorid) a ON c.contentindicatorid = a.contentindicatorid "
			+ "LEFT JOIN (SELECT c.contentindicatorid, COUNT(pcel.eventid) as event_count  "
			+ "       FROM contentindicator c, primcontentindicatorevlink pcel  "
			+ "       WHERE c.contentindicatorid = pcel.primcontentindicatorid  "
			+ "       GROUP BY c.contentindicatorid) b ON c.contentindicatorid = b.contentindicatorid  "
			+ "ORDER BY c.contentindicatorid ASC";
			
		// get the data
		results = database.executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup content indicator data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				obj = new JSONObject();
				
				obj.put("id", resultSet.getString(1));
				obj.put("term", resultSet.getString(2));
				obj.put("events", resultSet.getString(3));
				obj.put("items", resultSet.getString(4));
				
				list.add(obj);				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of content indicators: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		return list.toString();	
	}
	
	/**
	 * A method to build the list of content indicators
	 *
	 * @return a JSON string containing a list of resource sub types
	 */
	@SuppressWarnings("unchecked")
	public String getResourceSubTypeIdentifiers() {
		
		String sql;
		DbObjects results;
		
		JSONArray list = new JSONArray();
		JSONObject obj;
		sql = "SELECT lc.code_lov_id, lc.short_code, COUNT(i.itemid) "
			+ "FROM lookup_codes lc "
			+ "LEFT JOIN item i ON lc.code_lov_id = i.item_sub_type_lov_id "
			+ "WHERE code_type = 'RESOURCE_SUB_TYPE' "
			+ "GROUP BY lc.code_lov_id, lc.short_code "
			+ "ORDER BY short_code ASC";
			
		// get the data
		results = database.executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup resource sub type data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				obj = new JSONObject();
				
				obj.put("id", resultSet.getString(1));
				obj.put("description", resultSet.getString(2));
				obj.put("items", resultSet.getString(3));
				
				list.add(obj);				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of resource sub types: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		return list.toString();	
	}
	
	/**
	 * A method to build the list of countries
	 *
	 * @return a JSON string containing countries
	 */
	@SuppressWarnings("unchecked")
	public String getCountries() {
	
		String sql;
		DbObjects results;
		
		JSONArray list = new JSONArray();
		JSONObject obj;
		
		sql = 	"SELECT c.countryid, c.countryname, count(v.venueid) "+ 
				"FROM country c "+
				"LEFT JOIN venue v ON c.countryid = v.countryid "+
				"GROUP BY c.countryid ORDER BY c.countryname ASC";
			
		// get the data
		results = database.executeStatement(sql);
	
		// check to see that data was returned
		if(results == null) {
			throw new RuntimeException("unable to lookup country data");
		}
		
		// build the list of contributors
		ResultSet resultSet = results.getResultSet();
		try {
			while (resultSet.next()) {
			
				obj = new JSONObject();
				
				obj.put("id", resultSet.getString(1));
				obj.put("name", resultSet.getString(2));
				obj.put("venues", resultSet.getString(3));
				
				list.add(obj);				
			}
		} catch (java.sql.SQLException ex) {
			throw new  RuntimeException("unable to build list of secondary genres: " + ex.toString());
		}
		
		// play nice and tidy up
		resultSet = null;
		results.tidyUp();
		results = null;
		
		return list.toString();	
	}
}



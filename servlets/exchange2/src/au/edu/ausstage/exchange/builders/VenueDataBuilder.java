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

package au.edu.ausstage.exchange.builders;

import au.edu.ausstage.exchange.types.Venue;

import au.edu.ausstage.utils.DateUtils;

import java.util.ArrayList;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

/**
 * A class used to build the dataset in various formats using Event objects
 */
public class VenueDataBuilder {

	/*
	 * construct a HTML list
	 *
	 * @param list the list of event objects to use
	 *
	 * @return the constructed data
	 *
	 * @throws IllegalArgumentException if the list is null
	 */
	public static String buildHtml(ArrayList<Venue> list) {
	
		if(list == null) {
			throw new IllegalArgumentException("the list must not be null");
		}
	
		StringBuilder builder = new StringBuilder("<ul class=\"ausstage_venues\">");
		builder.append("<!-- AusStage Data Exchange Service (" + DateUtils.getCurrentDateAndTime() + ")- http://www.ausstage.edu.au/pages/exchange/ -->");
		Venue venue;
		
		for(int i = 0; i < list.size(); i++) {
			venue = (Venue)list.get(i);
			builder.append(venue.toHtml());
		}
		
		builder.append("<ul>");
		
		return builder.toString();
	}
	
	/*
	 * construct a XML list
	 *
	 * @param list the list of event objects to use
	 *
	 * @return the constructed data
	 *
	 * @throws IllegalArgumentException if the list is null
	 */
	public static String buildXml(ArrayList<Venue> list) {
	
		if(list == null) {
			throw new IllegalArgumentException("the list must not be null");
		}
	
		StringBuilder builder = new StringBuilder("<venues>");
		builder.append("<!-- AusStage Data Exchange Service (" + DateUtils.getCurrentDateAndTime() + ")- http://www.ausstage.edu.au/pages/exchange/ -->");
		
		Venue venue;
		
		for(int i = 0; i < list.size(); i++) {
			venue = (Venue)list.get(i);
			builder.append(venue.toXml());
		}
		
		builder.append("</venues>");
		
		return builder.toString();
	}
	
	/*
	 * construct a JSON list
	 *
	 * @param list the list of event objects to use
	 *
	 * @return the constructed data
	 *
	 * @throws IllegalArgumentException if the list is null
	 */
	@SuppressWarnings("unchecked")
	public static String buildJson(ArrayList<Venue> list) {
	
		if(list == null) {
			throw new IllegalArgumentException("the list must not be null");
		}
		
		JSONArray builder = new JSONArray();
		JSONObject obj = new JSONObject();
		obj.put("_generator", "<!-- AusStage Data Exchange Service (" + DateUtils.getCurrentDateAndTime() + ")- http://www.ausstage.edu.au/pages/exchange/ -->");
		builder.add(obj);
		
		Venue venue;
		
		for(int i = 0; i < list.size(); i++) {
			venue = (Venue)list.get(i);
			builder.add(venue.toJsonObject());
		}
		
		return builder.toString();
	}
	
	/*
	 * construct a RSS list
	 *
	 * @param list the list of event objects to use
	 *
	 * @return the constructed data
	 *
	 * @throws IllegalArgumentException if the list is null
	 */
	public static String buildRss(ArrayList<Venue> list) {
	
		if(list == null) {
			throw new IllegalArgumentException("the list must not be null");
		}
	
		StringBuilder builder = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		builder.append("<rss version=\"2.0\">");
		builder.append("<channel>");
		builder.append("<title>AusStage - Data Exchange Service</title>");
		builder.append("<link>http://www.ausstage.edu.au/</link>");
		builder.append("<description>Event information sourced from the AusStage website</description>");
		builder.append("<generator>AusStage Data Exchange Service (" + DateUtils.getCurrentDateAndTime() + ")- http://www.ausstage.edu.au/pages/exchange/</generator>");
		
		Venue venue;
		
		for(int i = 0; i < list.size(); i++) {
			venue = (Venue)list.get(i);
			builder.append(venue.toRss());
		}
		
		builder.append("</channel>");
		builder.append("</rss>");
		
		return builder.toString();
	}
}

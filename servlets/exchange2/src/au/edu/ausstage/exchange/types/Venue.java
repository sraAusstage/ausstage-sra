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

package au.edu.ausstage.exchange.types;

// import additional AusStage libraries
import au.edu.ausstage.utils.*;
import org.json.simple.JSONObject;
import org.apache.commons.lang.StringEscapeUtils;

/**
 * A class used to represent an Venue
 */
public class Venue implements Comparable<Venue> {

	// private class level variables
	private String id;
	private String name;
	private String address;
	
	private String url = "test";
	
	/**
	 * constructor for this class
	 *
	 * @param id the unique event id
	 * @param name the venue name
	 * @param address
	 *
	 * @throws IllegalArgumentException if any of the parameters are missing or do not pass validation
	 */
	public Venue(String id, String name, String address) {
		
		if(InputUtils.isValid(id) == false || InputUtils.isValid(name) == false || InputUtils.isValid(address) == false ) {
			throw new IllegalArgumentException("all parameters to this constructor are required");
		}
		
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("the venue id must be a valid integer");
		}
		
		this.id = id;
		this.name = name;
		this.address = address;
		
		
		url = LinksManager.getVenueLink(id);
	}
	
	public String getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
	
	public String getAddress() {
		return address;
	}
	
	public String getUrl() {
		return url;
	}
	
	/*
	 * create a representation of this event as a HTML fragment
	 */
	public String toHtml() {
	
		StringBuilder builder = new StringBuilder("<li>");
		
		builder.append("<a href=\"" + url + "\" title=\"View this record in AusStage\">" + StringEscapeUtils.escapeHtml(name) + "</a>");
		builder.append(", " + StringEscapeUtils.escapeHtml(address));
		builder.append("</li>");
		
		return builder.toString();
	}
	
	/*
	 * create a representation of this venue as an XML fragment
	 */
	public String toXml() {
		
		StringBuilder builder = new StringBuilder("<venue>");
		
		builder.append("<id>" + id + "</id>");
		builder.append("<url>" + url + "</url>");
		builder.append("<name>" + StringEscapeUtils.escapeXml(name) + "</name>");
		builder.append("<address>" + StringEscapeUtils.escapeXml(address) + "</address>");
		builder.append("</venue>");
		
		return builder.toString();
	}
	
	/*
	 * create a representation of this event as a JSON Object
	 */
	@SuppressWarnings("unchecked")
	public JSONObject toJsonObject() {
	
		JSONObject object = new JSONObject();
		
		object.put("id", id);
		object.put("url", url);
		object.put("name", name);
		object.put("address", address);
		
		return object;	
	}
	
	/*
	 * create a representation of this event as a JSON fragment
	 */
	public String toJson() {
		
		return toJsonObject().toString();
	}
	
	/*
	 * create a representation of this event as an RSS fragment
	 */
	public String toRss() {
		
		StringBuilder builder = new StringBuilder("<item>");
		
		builder.append("<link>" + url + "</link>");
		builder.append("<guid isPermaLink=\"true\">" + url + "</guid>");
		builder.append("<title>" + StringEscapeUtils.escapeXml(name) + "</title>");
		builder.append("<description>" + StringEscapeUtils.escapeXml(address) + "</description>");
		builder.append("</item>");
		
		return builder.toString();
	}

	/*
	 * methods required for ordering in collections
	 * http://java.sun.com/docs/books/tutorial/collections/interfaces/order.html
	 */

	/**
	 * A method to determine if one event is the same as another
	 *
	 * @param o the object to compare this one to
	 *
	 * @return  true if they are equal, false if they are not
	 */
	public boolean equals(Object o) {
		// check to make sure the object is an event
		if ((o instanceof Venue) == false) {
			// o is not an event object
		 	return false;
		}
		
		// compare these two events
		Venue v = (Venue)o;
		
		return id.equals(v.getId());
		
	} // end equals method
	
	/**
	 * Overide the default hashcode method
	 * 
	 * @return a hashcode for this object
	 */
	public int hashCode() {
		return 31*id.hashCode();
	}
    
    /**
     * The compareTo method compares the receiving object with the specified object and returns a 
     * negative integer, 0, or a positive integer depending on whether the receiving object is 
     * less than, equal to, or greater than the specified object.
     *
     * @param e the event to compare this one to
     *
     * @return a integer indicating comparison result
     */    
	public int compareTo(Venue v) {
		int myId   = Integer.parseInt(id);
		int yourId = Integer.parseInt(v.getId());
		
		if(myId == yourId) {
			return 0;
		} else {
			return myId - yourId;
		}
		
	} // end compareTo method
}
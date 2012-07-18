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

package au.edu.ausstage.mapping.types;

// import additional AusStage libraries
import au.edu.ausstage.utils.InputUtils;

// import additional libraries
import java.util.Set;
import java.util.HashSet;
import java.util.TreeSet;
import java.util.Iterator;
import java.util.HashMap;

/**
 * A class to represent an Organisation
 */
public class Organisation implements Comparable<Organisation> {

	// declare private variables
	private String id = null;
	private String name = null;
	private String url  = null;
	private String eventCount = null;
	private String mappedEventCount = null;
	private Set<Event> events;
	private String address = null;
	private String suburb = null;
	private String state = null;
	private String postcode = null;
	private String country = null;
	private HashMap<Integer, KmlVenue> kmlVenues = null;
	
	// declare public constants
	/**
	 * Sort events by id
	 */
	public final static int EVENT_ID_SORT = 0;
	
	/**
	 * sort events by first date
	 */
	public final static int EVENT_FIRST_DATE_SORT = 1;
	
	
	/**
	 * Constructor for this class
	 *
	 * @param id the unique identifier for this organisation
	 */
	public Organisation(String id) {
	
		// check on the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		this.id = id;
		
		events = new HashSet<Event>();
		kmlVenues = new HashMap<Integer, KmlVenue>();

	} // end constructor
	
	/**
	 * Constructor for this class
	 *
	 * @param id        the unique identifier for this organisation
	 * @param name      the name of this organisation
	 * @param url       the url for this organisation in AusStage
	 */
	public Organisation(String id, String name, String url) {
	
		// check on the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		if(InputUtils.isValid(name) == false || InputUtils.isValid(url) == false) {
			throw new IllegalArgumentException("All parameters cannot be null or empty strings");
		}
		
		this.id   = id;
		this.name = name;
		this.url  = url;
		
		events = new HashSet<Event>();
		
	} // end constructor
	
	/*
	 * Event management
	 */
	
	/**
	 * A method to add an event for this organisation
	 *
	 * @param event the new event
	 */
	public void addEvent(Event event) {
		// check on the parameter
		if(event != null) {
			events.add(event);
		} else {
			throw new IllegalArgumentException("Event cannot be null");
		}
	} // end addEvent method
	
	/**
	 * A method to check if this organisation has an event 
	 *
	 * @param id the unique identifer of this event
	 *
	 * @return       true if this organisation has this event
	 */
	public boolean hasEvent(String id) {
	
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		Event newEvent = new Event(id);
		
		return hasEvent(newEvent);
	}
	
	/**
	 * A method to check if this organisation has an event 
	 *
	 * @param event the event object to check
	 *
	 * @return      true if this organisation has this event
	 */
	public boolean hasEvent(Event event) {
		// check on the parameter
		if(event != null) {
			return events.contains(event);
		} else {
			throw new IllegalArgumentException("Event cannot be null");
		}
	}
	
	/**
	 * A method to get a specific event
	 *
	 * @param id the unique identifer of the event
	 *
	 * @return   the event if found, null if nothing is found
	 */
	public Event getEvent(String id) {
		
		// check on the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		// get an iterator for this set
		Iterator iterator = events.iterator();
		
		// loop through the list of events looking through 
		while(iterator.hasNext()) {
			// get the event at this place in the set
			Event event = (Event)iterator.next();
			
			// compare ids
			if(event.getId().equals(id) == true) {
				return event;
			}
		}
		
		// if we get here, nothing was found
		return null;
	}
	
	/**
	 * A method to get the list of events for this organisation
	 *
	 * @return the list of events
	 */
	public Set<Event> getEvents() {
		return events;
	} // end getEvents method
	
	/**
	 * A method to get the list of events for this organisation as an array
	 *
	 * @return the list of events
	 */
	public Event[] getEventsArray() {
		return events.toArray(new Event[0]);
	} // end getEvents method
	
	/**
	 * A method to get the sorted list of events for this organisation
	 *
	 * @param sortType the type of sort to use on the list of events
	 *
	 * @return the sorted list of events
	 */
	public Set<Event> getSortedEvents(int sortType) {
	
		// declare helper variables
		Set<Event> sortedEvents;
	
		// determine what type of sort to do
		if(sortType == EVENT_ID_SORT) {
			sortedEvents = new TreeSet<Event>(events);
		} else if (sortType == EVENT_FIRST_DATE_SORT) {
			sortedEvents = new TreeSet<Event>(new EventFirstDateComparator());
			sortedEvents.addAll(events);
		} else {
			throw new IllegalArgumentException("Unknown sort type specified");
		}
		
		return sortedEvents;
	
	} // end getSortedEvents method
	
	/**
	 * A method to get the sorted list of events for this organisation as an array
	 *
	 * @param sortType the type of sort to use on the list of events
	 *
	 * @return the sorted list of events
	 */
	public Event[] getSortedEventsArray(int sortType) {
	
		// get the sorted events
		Set<Event> sortedEvents = getSortedEvents(sortType);
		
		// convert to an array
		return sortedEvents.toArray(new Event[0]);
	
	} // end getSortedEvents method
	
	/**
	 * A method to get the number of events for this organisation
	 *
	 * @return the number of evens for this organisation
	 */
	public int getEventCount() {
		if(events.isEmpty() == true && eventCount != null) {
			return Integer.parseInt(eventCount);
		} else {
			return events.size();
		}
	} // end getEventCount method
	
	/*
	 * getter and setter methods
	 */
	/*
	 * getter and setter methods
	 */
	public String getId() {
		return id;
	}
	
	public void setId(String value) {
		if(InputUtils.isValidInt(value) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		id = value.trim();
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String value) {
		if(InputUtils.isValid(value) == false) {
			throw new IllegalArgumentException("The value cannot be null or empty");
		}
		
		name = value.trim();
	}
	
	public String getUrl() {
		return url;
	}
	
	public void setUrl(String value) {
		if(InputUtils.isValid(value) == false) {
			throw new IllegalArgumentException("The value cannot be null or empty");
		}
		
		url = value.trim();
	}
	
	public void setEventCount(String value) {
		if(InputUtils.isValidInt(value) == false) {
			throw new IllegalArgumentException("The value parameter must be a valid integer");
		}
		
		eventCount = value.trim();
	}
	
	public String getMappedEventCount() {
		return mappedEventCount;
	}
	
	public void setMappedEventCount(String value) {
		if(InputUtils.isValidInt(value) == false) {
			throw new IllegalArgumentException("The value parameter must be a valid integer");
		}
		
		mappedEventCount = value.trim();
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String value) {
		if(value != null) {
			address = value.trim();
		} else {
			address = null;
		}
	}
	
	public String getSuburb() {
		return suburb;
	}
	
	public void setSuburb(String value) {
		if(value != null) {
			suburb = value.trim();
		} else {
			suburb = null;
		}
	}
	
	public String getState() {
		return state;
	}
	
	public void setState(String value) {
		if(value != null) {
			state = value.trim();
		} else {
			state = null;
		}
	}
	
	public String getPostcode() {
		return postcode;
	}
	
	public void setPostcode(String value) {
		if(value != null) {
			postcode = value.trim();
		} else {
			postcode = null;
		}
	}
	
	public String getCountry() {
		return country;
	}
	
	public void setCountry(String value) {
		if(InputUtils.isValid(value) == false) {
			throw new IllegalArgumentException("The value parameter must be a valid string");
		}
		
		country = value.trim();
	}
	
	public HashMap<Integer, KmlVenue> getKmlVenues() {
		return kmlVenues;
	}
	
	public void setKmlVenues(HashMap<Integer, KmlVenue> venues) {
		kmlVenues = venues;
	}
	
	public int getKmlVenueCount() {
		if(kmlVenues != null) {
			return kmlVenues.size();
		} else {
			return 0;
		}
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
		if ((o instanceof Organisation) == false) {
			// o is not an event object
		 	return false;
		}
		
		// compare these two organisations
		Organisation org = (Organisation)o;
		
		return id.equals(org.getId());
		
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
     * @param o the organisation to compare this one to
     *
     * @return  an integer indicating comparison result
     */    
	public int compareTo(Organisation o) {
	
		int myId   = Integer.parseInt(id);
		int yourId = Integer.parseInt(o.getId());
		
		if(myId == yourId) {
			return 0;
		} else {
			return myId - yourId;
		}
		
	} // end compareTo method


} // end class definition

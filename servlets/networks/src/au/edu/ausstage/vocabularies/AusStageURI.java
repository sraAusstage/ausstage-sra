/*
 * This file is part of the AusStage RDF Vocabularies Package
 *
 * The AusStage RDF Vocabularies Package is free software: you can 
 * redistribute it and/or modify it under the terms of the GNU General 
 * Public License as published by the Free Software Foundation, either 
 * version 3 of the License, or (at your option) any later version.
 *
 * The AusStage RDF Vocabularies Package is distributed in the hope 
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the 
 * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the AusStage RDF Vocabularies Package.  
 * If not, see <http://www.gnu.org/licenses/>.
*/

package au.edu.ausstage.vocabularies;

/**
 * A class to represent a custom URI scheme for AusStage data
 */
public class AusStageURI {

	/*
	 * class level constants for URI to URL translation
	 */
	private static final String BASE_CONTRIBUTOR_URL     = "http://www.ausstage.edu.au/indexdrilldown.jsp?xcid=59&f_contrib_id=[contrib-id]";
	private static final String BASE_CONTIRBUTOR_URL_TAG = "[contrib-id]";
	
	private static final String BASE_EVENT_URL     = "http://www.ausstage.edu.au/indexdrilldown.jsp?xcid=59&f_event_id=[event-id]";
	private static final String BASE_EVENT_URL_TAG = "[event-id]";
	
	private static final String BASE_RELATIONSHIP_URL     = "http://beta.ausstage.edu.au/networks/lookup?type=rel&id=[rel-id]";
	private static final String BASE_RELATIONSHIP_URL_TAG = "[rel-id]";
	
	private static final String BASE_ORGANISATION_URL     = "http://www.ausstage.edu.au/indexdrilldown.jsp?xcid=59&f_org_id=[org-id]";
	private static final String BASE_ORGANISATION_URL_TAG = "[org-id]";
	
	private static final String AUSSTAGE_URI_PREFIX      = "ausstage";
	private static final String CONTRIBUTOR_URI          = "c";	
	private static final String EVENT_URI                = "e";
	private static final String RELATIONSHIP_URI         = "rel";
	private static final String ORGANISATION_URI         = "o";
	
	/**
	 * A method to take an AusStage URI and return an AusStage URL
	 *
	 * @param uri the AusStage URI to resolve
	 * @return    the AusStage URL
	 */
	public static String getURL(String uri) {	
	
		// check on the parameter
		uri = checkParameter(uri);
		
		// turn the URI into the component parts
		String[] elements = uri.split(":");
		
		if(elements.length != 3) {
			throw new IllegalArgumentException("Expected 3 components to the URI, found: " + elements.length);
		}
		
		// check on the first part of the URI
		if(elements[0].equals(AUSSTAGE_URI_PREFIX) == false) {
			throw new IllegalArgumentException("First component of URI expected to be '" + AUSSTAGE_URI_PREFIX + "' found: " + elements[0]);
		}
		
		// check on the second component of the URI
		if(elements[1].equals(CONTRIBUTOR_URI) == true) {
			// build the contributor URL
			return BASE_CONTRIBUTOR_URL.replace(BASE_CONTIRBUTOR_URL_TAG, elements[2]);
		} else if (elements[1].equals(EVENT_URI) == true) {
			// build the event URL
			return BASE_EVENT_URL.replace(BASE_EVENT_URL_TAG, elements[2]);
		} else if(elements[1].equals(RELATIONSHIP_URI) == true) {
			// build the relationships URL
			return BASE_RELATIONSHIP_URL.replace(BASE_RELATIONSHIP_URL_TAG, elements[2]);
		} else if(elements[1].equals(ORGANISATION_URI) == true) {
			// build the organisation URL
			return BASE_ORGANISATION_URL.replace(BASE_ORGANISATION_URL_TAG, elements[2]);
		} else {
			throw new IllegalArgumentException("Second component of URI '" + elements[1] + "' is not valid");
		}
		
	} // end getURL method
	
	/**
	 * A method to get the id number from a URI
	 * 
	 * @param uri the AusStage URI to resolve
	 * @return    the AusStage id
	 */
	public static String getId(String uri) {	
	
		// check on the parameter
		uri = checkParameter(uri);
		
		// turn the URI into the component parts
		String[] elements = uri.split(":");
		
		if(elements.length != 3) {
			throw new IllegalArgumentException("Expected 3 components to the URI, found: " + elements.length);
		}
		
		// check on the first part of the URI
		if(elements[0].equals(AUSSTAGE_URI_PREFIX) == false) {
			throw new IllegalArgumentException("First component of URI expected to be '" + AUSSTAGE_URI_PREFIX + "' found: " + elements[0]);
		}
		
		return elements[2];
			
	} // end the geId method
	
	/**
	 * A method to build an AusStage URI for a contributor
	 *
	 * @param id  the contributor id
	 * @return    the AusStage URI
	 */
	public static String getContributorURI(String id) {
		
		// check on the parameter
		id = checkParameter(id);
		
		// return the construted URI
		return AUSSTAGE_URI_PREFIX + ":" + CONTRIBUTOR_URI + ":" + id;
	}
	
	/**
	 * A method to build an AusStage URL for a contributor
	 *
	 * @param id the contributor id
	 * @return   the AusStage URL
	 */
	public static String getContributorURL(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// build the contributor URL
		return BASE_CONTRIBUTOR_URL.replace(BASE_CONTIRBUTOR_URL_TAG, id);
	
	}
	
	/**
	 * A method to build an AusStage URI for a event
	 *
	 * @param id  the event id
	 * @return    the AusStage URI
	 */
	public static String getEventURI(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// return the construted URI
		return AUSSTAGE_URI_PREFIX + ":" + EVENT_URI + ":" + id;
	}
	
	/**
	 * A method to build an AusStage URL for a event
	 *
	 * @param id the event id
	 * @return   the AusStage URL
	 */
	public static String getEventURL(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// build the contributor URL
		return BASE_EVENT_URL.replace(BASE_EVENT_URL_TAG, id);	
	}
	
	/**
	 * A method to build an AusStage URI for a relationship
	 *
	 * @param id  the relationship id
	 * @return    the AusStage URI
	 */
	public static String getRelationshipURI(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// return the construted URI
		return AUSSTAGE_URI_PREFIX + ":" + RELATIONSHIP_URI + ":" + id;
	}
	
	/**
	 * A method to build an AusStage URL for a event
	 *
	 * @param id the event id
	 * @return   the AusStage URL
	 */
	public static String getRelationshipURL(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// build the contributor URL
		return BASE_RELATIONSHIP_URL.replace(BASE_RELATIONSHIP_URL_TAG, id);
	}
	
	/**
	 * A method to build an AusStage URI for a organisation
	 *
	 * @param id  the relationship id
	 * @return    the AusStage URI
	 */
	public static String getOrganisationURI(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// return the construted URI
		return AUSSTAGE_URI_PREFIX + ":" + ORGANISATION_URI + ":" + id;
	}
	
	/**
	 * A method to build an AusStage URL for a event
	 *
	 * @param id the event id
	 * @return   the AusStage URL
	 */
	public static String getOrganisationURL(String id) {
	
		// check on the parameter
		id = checkParameter(id);
		
		// build the contributor URL
		return  BASE_ORGANISATION_URL.replace(BASE_ORGANISATION_URL_TAG, id);
	}
	
	/**
	 * A method to check on parameters
	 *
	 * @param value       the parameter valie
	 * @param nullAllowed true, if an only if, the parameter is allowed to be null or blank
	 *
	 * @return the checked parameter value
	 */
	private static String checkParameter(String value, boolean nullAllowed) {
	
		// check to see if nulls are allowed
		if(nullAllowed == true) {
			// yes
			if(value == null) {
				return value;
			} else {
				// trim the value
				value = value.trim();
				value = value.replaceAll("<", "");
				value = value.replaceAll(">", "");
				return value;
			}			
		} else {
			// no
			if(value == null) {
				throw new IllegalArgumentException("Parameter cannot be null");
			} else {
				// trim the value
				value = value.trim();
				value = value.replaceAll("<", "");
				value = value.replaceAll(">", "");
				
				if(value.equals("")) {
					throw new IllegalArgumentException("Parameter cannot be empty");
				} else {
					return value;
				}
			}
		}	
	}
	
	/**
	 * A method to check on parameters where null is not allowed by default
	 *
	 * @param value the parameter value
	 *
	 * @return the checked parameter value
	 */
	private static String checkParameter(String value) {
		return checkParameter(value, false);
	}
}

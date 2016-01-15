/*
 * This file is part of the AusStage Utilities Package
 *
 * The AusStage Utilities Package is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * The AusStage Utilities Package is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with the AusStage Utilities Package.  
 * If not, see <http://www.gnu.org/licenses/>.
*/

package au.edu.ausstage.utils;

/**
 * A class of methods useful when compiling links into the AusStage website
 */
public class LinksManager {

	// declare class level variables
	
	// event URLs
	private static final String EVENT_TEMPLATE = "http://www.ausstage.edu.au/pages/event/[event-id]";
	private static final String EVENT_TOKEN    = "[event-id]";
	
	// venue URLs
	private static final String VENUE_TEMPLATE = "http://www.ausstage.edu.au/pages/venue/[venue-id]";
	private static final String VENUE_TOKEN    = "[venue-id]";
	
	// contributor URLs
	private static final String CONTRIBUTOR_TEMPLATE = "http://www.ausstage.edu.au/pages/contributor/[contrib-id]";
	private static final String CONTRIBUTOR_TOKEN    = "[contrib-id]";
	
	// organisation URLs
	private static final String ORGANISATION_TEMPLATE = "http://www.ausstage.edu.au/pages/organisation/[org-id]";
	private static final String ORGANISATION_TOKEN    = "[org-id]";
	
	/*
	 *  work URLs
	 *  any changes to this should also be made in SearchManager.java.
	 *  I failed miserably as a programmer and hard coded the WORK url generation
	 *	into SearchManager because I couldn't work out why I kept getting the following error.
	 *  java.lang.NoSuchMethodError: au.edu.ausstage.utils.LinksManager.getWorkLink(Ljava/lang/String;)Ljava/lang/String;
	 *  ROUGHLY line 1400 in SearchManager
	 */
	private static final String WORK_TEMPLATE = "http://www.ausstage.edu.au/pages/work/[work-id]";
	private static final String WORK_TOKEN    = "[work-id]";
	
	// resource / item URLs
	private static final String RESOURCE_TEMPLATE = "http://www.ausstage.edu.au/pages/resource/[item-id]";
	private static final String RESOURCE_TOKEN    = "[item-id]";
	
	// performance feedback URLs
	private static final String PERFORMANCE_TEMPLATE = "http://www.ausstage.edu.au/pages/mobile/view/list.jsp?performance=[performance-id]";
	private static final String PERFORMANCE_TOKEN    = "[performance-id]";
	
	/**
	 * A method to build an event link
	 *
	 * @param id the event id
	 * @return   the persistent URL for this event
	 */
	public static String getEventLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return EVENT_TEMPLATE.replace(EVENT_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a venue link
	 *
	 * @param id the venue id
	 * @return   the persistent URL for this venue
	 */
	public static String getVenueLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return VENUE_TEMPLATE.replace(VENUE_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a contributor link
	 *
	 * @param id the contributor id
	 * @return   the persistent URL for this contributor
	 */
	public static String getContributorLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return CONTRIBUTOR_TEMPLATE.replace(CONTRIBUTOR_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a contributor link
	 *
	 * @param id the organisation id
	 * @return   the persistent URL for this organisation
	 */
	public static String getOrganisationLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return ORGANISATION_TEMPLATE.replace(ORGANISATION_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a work link
	 *  This Method doesn't get called. It should but due to my incompetence it wouldn't work.- see the private variable declarations
	 *  at the top of this class.
	 *   
	 * @param id the work id
	 * @return   the persistent URL for this work
	 */
	public static String getWorkLink(String id) {
		System.out.println("links manager [MAPPING] get work link id passed in :"+id);
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			System.out.println("error");
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			System.out.println("success!");
			return WORK_TEMPLATE.replace(WORK_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a resource / item link
	 *
	 * @param id the resource id
	 * @return   the persistent URL for this resource
	 */
	public static String getResourceLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return RESOURCE_TEMPLATE.replace(RESOURCE_TOKEN, id);
		}
	} // end the method
	
	/**
	 * A method to build a performance
	 *
	 * @param id the resource id
	 * @return   the persistent URL for this resource
	 */
	public static String getPerformanceLink(String id) {
		// double check the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		} else {
			return PERFORMANCE_TEMPLATE.replace(PERFORMANCE_TOKEN, id);
		}
	} // end the method
	
} // end class definition

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
import java.util.*;

/**
 * A class to represent a list of works
 */
public class WorkList {

	
	// declare public constants
	
	/**
	 * Sort Works by id
	 */
	public final static int WORK_ID_SORT = 0;
	
	/**
	 * sort Works by name
	 */
	public final static int WORK_NAME_SORT = 1;

	// declare private variables
	private Set<Work> works;
	
	/**
	 * A constructor for this class
	 */
	public WorkList() {
		works = new HashSet<Work>();
	}
	
	/*
	 * Work management
	 */
	
	/**
	 * A method to add awork to the list of works
	 *
	 * @param work the new work object
	 */
	public void addWork(Work work) {
		// check on the parameter
		if(work != null) {
			works.add(work);
		} else {
			throw new IllegalArgumentException("Work cannot be null");
		}
	} // end addWork method
	
	
	/**
	 * A method to check if this list has this work already
	 *
	 * @param id the unique identifer of this work
	 *
	 * @return       true if this list has this work
	 */
	public boolean hasWork(String id) {
	
		// check on the parameter
		if(InputUtils.isValidInt(id) == false) {
			throw new IllegalArgumentException("The id parameter must be a valid integer");
		}
		
		Work work = new Work(id);
		
		return hasWork(work);
	}
	
	/**
	 * A method to check if this list has this work already
	 *
	 * @param work the unique identifer of this work
	 *
	 * @return       true if this list has this work
	 */
	public boolean hasWork(Work work) {
		if(work != null) {
			return works.contains(work);
		} else {
			throw new IllegalArgumentException("Work cannot be null");
		}
	}
	
	/**
	 * A method to get a specific work
	 *
	 * @param id the unique identifer of the work
	 *
	 * @return   the work if found, null if nothing is found
	 */
	public Work getWork(String id) {
		
		// get an iterator for this set
		Iterator iterator = works.iterator();
		
		// loop through the list of events looking through 
		while(iterator.hasNext()) {
			// get the event at this place in the set
			Work work = (Work)iterator.next();
			
			// compare ids
			if(work.getId().equals(id) == true) {
				return work;
			}
		}
		
		// if we get here, nothing was found
		return null;
	}
	
	/**
	 * A method to get the list of works
	 *
	 * @return the list of works
	 */
	public Set<Work> getWorks() {
		return works;
	} // end getWorks method
	
	/**
	 * A method to get the list of venues as an array
	 *
	 * @return the list of contributors
	 */
	public Work[] getWorkArray() {
		return works.toArray(new Work[0]);
	} // end getWorkArray
	
	/**
	 * A method to get the sorted list of works for this venue
	 *
	 * @param sortType the type of sort to use on the list of works
	 *
	 * @return the sorted list of events
	 */
	public Set<Work> getSortedWorks(int sortType) {
	
		// declare helper variables
		Set<Work> sortedWorks;
	
		// determine what type of sort to do
		if(sortType == WORK_ID_SORT) {
			sortedWorks = new TreeSet<Work>(works);
		} else if (sortType == WORK_NAME_SORT) {
			sortedWorks = new TreeSet<Work>(new WorkNameComparator());
			sortedWorks.addAll(works);
		} else {
			throw new IllegalArgumentException("Unknown sort type specified");
		}
		
		return sortedWorks;
	
	}
	
	/**
	 * A method to get the sorted list of contributors for this venue as an array
	 *
	 * @param sortType the type of sort to use on the list of contributors
	 *
	 * @return the sorted list of events
	 */
	public Work[] getSortedWorksArray(int sortType) {
	
		// get the sorted events
		Set<Work> sortedWorks = getSortedWorks(sortType);
		
		// convert to an array
		return sortedWorks.toArray(new Work[0]);
	
	}

}

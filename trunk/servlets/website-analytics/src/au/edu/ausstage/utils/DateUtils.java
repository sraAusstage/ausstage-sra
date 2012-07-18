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

// import additional libraries
import java.util.GregorianCalendar;
import java.util.Calendar;
import java.text.DateFormat;

/**
 * A class of methods useful when processing dates in AusStage Services
 */
public class DateUtils {

/**
	 * A method used to build a date for use Marker XML and KML data
	 *
	 * @param year  the year component of the date
	 * @param month the month component of the date
	 * @param day   the day component of the month
	 *
	 * @return      a string containing the finalised date
	 */
	public static String buildDate(String year, String month, String day) {
	
		// check for at least a year
		if(year != null) {
		 
			String date = year + "-" + month + "-" + day;
		 	date = date.replace("-null","");
			date = date.replace("null","");
			
			return date;
		} else {
			return "";
		}
	 
	} // end buildDate method
	 
	/**
	 * A method used to build a date for display in line with existing formatting rules
	 *
	 * @param year  the year component of the date
	 * @param month the month component of the date
	 * @param day   the day component of the month
	 *
	 * @return      a string containing the finalised date
	 */
	public static String buildDisplayDate(String year, String month, String day) {
	
		if(year != null) {
		
			// trim leading zeros from the day
			if(day != null && day.startsWith("0") == true) {
				day = day.substring(1);
			}
		 
		 	String date = day + " " + lookupMonth(month) + " " + year;
		 	date = date.replace("null","");
		 	date = date.trim();
			return date;
		} else {
			return "";
		}
	 
	} // end buildDisplayDate method
	
	/**
	 * A method used to lookup the numeric month based on an abbreviation
	 *
	 * @param month the month abbreviation
	 *
	 * @return     a string containing the number of the month as a two digit integer
	 */
	public static String lookupMontByAbbr(String month) {
	
		if(InputUtils.isValid(month) == false) {
			return null;
		}
		
		month = month.toLowerCase();
		
		if(month.equals("jan")) {
			return "01";
		} else if(month.equals("feb")) {
			return "02";
		} else if(month.equals("mar")) {
			return "03";
		} else if(month.equals("apr")) {
			return "04";
		} else if(month.equals("may")) {
			return "05";
		} else if(month.equals("jun")) {
			return "06";
		} else if(month.equals("jul")) {
			return "07";
		} else if(month.equals("aug")) {
			return "08";
		} else if(month.equals("sept")) {
			return "09";
		} else if(month.equals("oct")) {
			return "10";
		} else if(month.equals("nov")) {
			return "11";
		} else if(month.equals("dec")) {
			return "12";
		} else {
			return null;
		}
	}
	 
	/**
	 * A method used to lookup the name of a month based on its number
	 *
	 * @param month the month as a digit
	 *
	 * @return      a string containing the name of the month
	 */
	public static String lookupMonth(String month) {
	 
		// check on the month parameter
	 	if(InputUtils.isValid(month) == false) {
	 		return null;
	 	}
	 
	 	// prepare the month
	 	month = month.trim();
	 	
	 	// double check the month parameter
	 	if(month == null || month.equals("")) {
	 		return "";
	 	}
	 
	 	// convert the string to an int
	 	int i = Integer.parseInt(month);
	 	
	 	switch (i) {
	 		case 1:  return "January";
	 		case 2:  return "February";
	 		case 3:  return "March";
	 		case 4:  return "April";
	 		case 5:  return "May";
	 		case 6:  return "June";
	 		case 7:  return "July";
	 		case 8:  return "August";
	 		case 9:  return "September";
	 		case 10: return "October";
	 		case 11: return "November";
	 		case 12: return "December";
	 		default: return "";
	 		}
	} // end lookupMonth method
	
	/**
	 * A method used to lookup the name of a month based on its number
	 *
	 * @param month the month as a digit
	 *
	 * @return      a string containing the name of the month
	 */
	public static String lookupMonth(int month) {
	 	
	 	switch (month) {
	 		case 1:  return "January";
	 		case 2:  return "February";
	 		case 3:  return "March";
	 		case 4:  return "April";
	 		case 5:  return "May";
	 		case 6:  return "June";
	 		case 7:  return "July";
	 		case 8:  return "August";
	 		case 9:  return "September";
	 		case 10: return "October";
	 		case 11: return "November";
	 		case 12: return "December";
	 		default: return "";
	 		}
	} // end lookupMonth method
	 
	/**
	 * A method to get the current date and time to use in a timestamp
	 *
	 * @return  a string containing the timestamp
	 */
	public static String getCurrentDateAndTime() {
	 
	 	GregorianCalendar calendar = new GregorianCalendar();
	 	DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.FULL);
	 	
		return formatter.format(calendar.getTime());
	 
	} // end getCurrentDateAndTime method
	
	/**
	 * A method to get the current date to use in a timestamp
	 *
	 * @return  a string containing the timestamp
	 */
	public static String getCurrentDate() {
	 
	 	GregorianCalendar calendar = new GregorianCalendar();
	 	DateFormat formatter = DateFormat.getDateInstance(DateFormat.FULL);
	 	
		return formatter.format(calendar.getTime());
	 
	} // end getCurrentDate method
	
	/**
	 * A method to get the current date as an array of components
	 * 0 = year, 1 = month, 2 = day
	 *
	 * @return an array of strings representing the current date
	 */
	public static String[] getCurrentDateAsArray() {
	
		GregorianCalendar calendar = new GregorianCalendar();
		String[] fields = new String[3];
		
		fields[0] = Integer.toString(calendar.get(Calendar.YEAR));
		fields[1] = String.format("%02d", calendar.get(Calendar.MONTH) + 1);
		fields[2] = String.format("%02d", calendar.get(Calendar.DAY_OF_MONTH));
		
		return fields;	
	}
	
	/**
	 * A method to get the current date and time as an array of components
	 * 0 = year, 1 = month, 2 = day, 3 = hour, 4 = minutes, 5 = seconds
	 *
	 * @return an array of strings representing the current date and time
	 */
	public static String[] getCurrentDateTimeAsArray() {
	
		GregorianCalendar calendar = new GregorianCalendar();
		String[] fields = new String[6];
		
		fields[0] = Integer.toString(calendar.get(Calendar.YEAR));
		fields[1] = String.format("%02d", calendar.get(Calendar.MONTH) + 1);
		fields[2] = String.format("%02d", calendar.get(Calendar.DAY_OF_MONTH));
		fields[3] = String.format("%02d", calendar.get(Calendar.HOUR_OF_DAY));
		fields[4] = String.format("%02d", calendar.get(Calendar.MINUTE));
		fields[5] = String.format("%02d", calendar.get(Calendar.SECOND));
		
		return fields;	
	}
	
	/**
	 * A method to get the last day of a month
	 *
	 * @param year  the four digit year
	 * @param month the two digit month
	 *
	 * @return      the last day of the specified month
	 */
	public static String getLastDay(String year, String month) {
	
		// get a calendar object
		GregorianCalendar calendar = new GregorianCalendar();
		
		// convert the year and month to integers
		int yearInt = Integer.parseInt(year);
		int monthInt = Integer.parseInt(month);
		
		// adjust the month for a zero based index
		monthInt = monthInt - 1;
		
		// set the date of the calendar to the date provided
		calendar.set(yearInt, monthInt, 1);
		
		int dayInt = calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH);
		
		return Integer.toString(dayInt);
	} // end getLastDay method
	
	/**
	 * A method to explode a date in 8 digit format into the three components.
	 * Where a date component can not be determined null is used
	 * Array elements are [0] - year, [1] - month, [2] - day
	 *
	 * @param date the date to explode
	 *
	 * @return     an array with three elements containing the date components
	 */
	public static String[] getExplodedDate(String date) {
	
		// declare helper variables
		String[] explodedDate = new String[3];
		
		// set initial values
		explodedDate[0] = null;
		explodedDate[1] = null;
		explodedDate[2] = null;
		
		if(date == null) {
			return explodedDate;
		}
		
		// explode the date
		if(date.length() == 4) {
			explodedDate[0] = date;
		} else if(date.length() == 6) {
			explodedDate[0] = date.substring(0, 4);
			explodedDate[1] = date.substring(4, 6);
		} else if(date.length() == 7) {
			explodedDate[0] = date.substring(0, 4);
		} else if(date.length() == 8) {
			explodedDate[0] = date.substring(0, 4);
			explodedDate[1] = date.substring(4, 6);
			explodedDate[2] = date.substring(6, 8);
		}
	
		// return the exploded Date
		return explodedDate;
	
	} // end getExplodedDate method
	
	/**
	 * A method to explode a date in 8 digit format into the three components.
	 * Where a date component can not be determined null is used
	 *
	 * Assumes the format yyyy-mm-dd where - is a delimiter
	 *
	 * Array elements are [0] - year, [1] - month, [2] - day
	 *
	 * @param date the date to explode
	 * @param delim the delimiter in the date components
	 *
	 * @return     an array with three elements containing the date components
	 */
	public static String[] getExplodedDate(String date, String delim) {
	
		// declare helper variables
		String[] explodedDate = new String[3];
		String[] tmp          = new String[3];
		
		// set initial values
		explodedDate[0] = null;
		explodedDate[1] = null;
		explodedDate[2] = null;
		
		if(date == null) {
			return explodedDate;
		}
		
		// trim the date
		date = date.trim();
		
		if(date.equals("") == true) {
			return null;
		}
		
		tmp = date.split(delim);
		
		if(tmp.length == 3) {
			return tmp;
		} else if (tmp.length == 1) {
			explodedDate[0] = tmp[0];
		} else if(tmp.length == 2) {
			explodedDate[0] = tmp[0];
			explodedDate[1] = tmp[1];
		}
		
		return explodedDate;
	
	} // end getExplodedDate method
	
	/**
	 * A method to "minify" a date by using zero in any missing values
	 * Assumes the format yyyy-mm-dd where - is a delimiter
	 *
	 * @param date the date to explode
	 * @param delim the delimiter in the date components
	 *
	 * @return     an array with three elements containing the date components
	 */
	public static String getMinifiedDate(String date, String delim) {
		// check on the parameters
		if(InputUtils.isValid(date) == false || InputUtils.isValid(delim) == false) {
			throw new IllegalArgumentException("Error: All parameters to this method are required");
		}
		
		// explode the date
		String[] explodedDate = getExplodedDate(date, delim);
		
		// check on what was returned
		if(explodedDate[0] == null) {
			explodedDate[0] = "00";
		}
		
		if(explodedDate[1] == null) {
			explodedDate[1] = "00";
		} 
		
		if(explodedDate[2] == null) {
			explodedDate[2] = "00";
		}
		
		// reassemble the date
		return explodedDate[0] + delim + explodedDate[1] + delim + explodedDate[2];
	}
	
	/**
	 * A method to convert a date string into an integer
	 * Assumes the format yyyy-mm-dd where - is a delimiter
	 * Dates are minified before conversion if required
	 *
	 * @param date the date to explode
	 * @param delim the delimiter in the date components
	 *
	 * @return     an array with three elements containing the date components
	 */
	public static int getIntegerFromDate(String date, String delim) {
		// check on the parameters
		if(InputUtils.isValid(date) == false || InputUtils.isValid(delim) == false) {
			throw new IllegalArgumentException("Error: All parameters to this method are required");
		}
		
		// minify the date
		if(date.length() != 10) {
			date = getMinifiedDate(date, delim);
		}			
		
		// replace the delimiter with nothing
		date = date.replace(delim, "");
		
		// convert the date
		int integerDate;
		
		try {
			integerDate = Integer.parseInt(date);
		} catch(java.lang.NumberFormatException ex) {
			throw new IllegalArgumentException("Error: the date parameter does not meet the requirements for conversion");
		}
		
		return integerDate;
	}
	
	/**
	 * A method to convert a date string into an integer
	 * Assumes the format yyyy-mm-dd where - is a delimiter
	 * Dates are minified before conversion if required
	 *
	 * @param date the date to explode
	 *
	 * @return     an array with three elements containing the date components
	 */
	public static int getIntegerFromDate(String date) {
	
		// check on the parameters
		if(InputUtils.isValid(date) == false) {
			throw new IllegalArgumentException("Error: All parameters to this method are required");
		}
		
		return getIntegerFromDate(date, "-");
	}
	
	/**
	 * A method to turn dates from AusStage into dates that can be used for sorting
	 * Used primarily to prepare data for use in the mapping service time slideer
	 *
	 * @param fyear  the first year
	 * @param fmonth the first month
	 * @param fday   the first day	
	 *
	 * @param lyear  the last year
	 * @param lmonth the last month
	 * @param lday   the last day
	 *
	 * @return       a two element string array, first element is the first date, the second is the last date
	 */
	public static String[] getDatesForTimeline(String fyear, String fmonth, String fday, String lyear, String lmonth, String lday) {
	
		// validate the parameters
		if(InputUtils.isValid(fyear) == false) {
			throw new IllegalArgumentException("Error: The fyear parameter is required");
		}
		
		// declare helper variables
		String[] dates = new String[2];
		
		/*
		 * process the first date
		 */
		if(InputUtils.isValid(fmonth) == false) {
			dates[0] = fyear + "-01-01";
		} else if(InputUtils.isValid(fday) == false) {
			dates[0] = fyear + "-" + fmonth + "-01";
		} else {
			dates[0] = fyear + "-" + fmonth + "-" + fday;
		}
		
		/*
		 * process the last date
		 */
		if(InputUtils.isValid(lyear) == false) {
			dates[1] = dates[0];
		} else if (InputUtils.isValid(lmonth) == false) {
			dates[1] = lyear + "-01-01";
		} else {
			dates[1] = lyear + "-" + lmonth + "-" + getLastDay(lyear, lmonth);
		}
		
		// outlier checks
		/*
		try {
			if(InputUtils.isValid(lyear) == true) {
				if(Integer.parseInt(lyear) > Integer.parseInt(fyear)) {
					dates[1] = lyear + "-01-01";
				}
			}
		
			if(getIntegerFromDate(dates[1]) < getIntegerFromDate(dates[0])) {
				dates[1] = dates[0];
			}
			
		} catch (NumberFormatException e) {}
		*/
		
		return dates;	
	}
	
	/**
	 * A method to turn dates from AusStage into dates that can be used for sorting
	 * Used primarily to prepare data for use in the mapping service time slideer
	 *
	 * @param fdate the first date
	 * @param ldate the last  date
	 *
	 * @return       a two element string array, first element is the first date, the second is the last date
	 */
	public static String[] getDatesForTimeline(String fdate, String ldate) {
	
		// explode the dates
		String[] fdates = getExplodedDate(fdate);
		String[] ldates = getExplodedDate(ldate);
		
		return getDatesForTimeline(fdates[0], fdates[1], fdates[2], ldates[0], ldates[1], ldates[2]);
	
	}
	
	/**
	 * A method to turn dates from AusStage into dates that can be used for sorting
	 * Used primarily to prepare data for use in the mapping service time slideer
	 *
	 * @param fyear  the first year
	 * @param fmonth the first month
	 * @param fday   the first day	
	 *
	 * @return       the date that can be used for sorting, especially useful in the mapping service and the time slider
	 */
	public static String getSortDate(String fyear, String fmonth, String fday) {
	
		// validate the parameters
		if(InputUtils.isValid(fyear) == false) {
			throw new IllegalArgumentException("Error: The fyear parameter is required");
		}
		
		// declare helper variables
		String[] dates = new String[2];
		
		/*
		 * process the first date
		 */
		if(InputUtils.isValid(fmonth) == false) {
			dates[0] = fyear + "-01-01";
		} else if(InputUtils.isValid(fday) == false) {
			dates[0] = fyear + "-" + fmonth + "-01";
		} else {
			dates[0] = fyear + "-" + fmonth + "-" + fday;
		}
		
		return dates[0];	
	}
		
} // end class definition

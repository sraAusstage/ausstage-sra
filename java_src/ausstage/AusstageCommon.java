/***************************************************

Company: Ignition Design
 Author: Luke Sullivan
Project: Ausstage

   File: AusstageCommon.java

Purpose: Provides Articles object functions.

21 May: BTW : added educational_institution_id variable. Relating to addition of a join 
	      table between CONTRIBUTOR and ORGANISATION

2015 : code moved to github
 ***************************************************/

package ausstage;

import java.util.*;
import java.text.*;

public class AusstageCommon {

	public static final String AUSSTAGE_DB_USER_NAME = "root";
	public static final String AUSSTAGE_DB_PASSWORD = "srasra";
	
	public static final String event_index_search_result_page = "indexsearchresults.jsp";
	public static final String search_tables_result_page = "searchtableresult.jsp";
	public static final String advanced_search_result_page = "advancedsearchresult.jsp";
	public static final String queries_search_result_page = "queries.jsp";

	public static final String collection_index_search_result_page = "directorysearchresults.jsp";
	public static final String resource_search_result_page = "resourcesearchresults.jsp";
	public static final String ausstage_main_page_link = "";
	public static final String event_index_search_result_drill_page = "indexdrilldown.jsp";
	public static final String coll_index_search_result_drill_page = "directorydrilldown.jsp";
	public static final String event_index_search_tables_result_drill_page = "indexdrilldown.jsp";
	public static final String resource_index_search_result_drill_page = "indexdrilldown.jsp";
	public static final String INSTITUTION_ID = "2";
	public static final String EDUCATIONAL_INSTITUTION_ID = "3";
	public static final String DATE_FORMAT_STRING = "dd MMM yyyy";

	public AusstageCommon() {
	}

	public String formatDate(Date p_date, java.lang.String strDateFormat) {
		if (p_date == null) {
			return "";
		}

		Format formatter;

		// The year
		formatter = new SimpleDateFormat("yy"); // 02
		formatter = new SimpleDateFormat("yyyy"); // 2002

		// The month
		formatter = new SimpleDateFormat("M"); // 1
		formatter = new SimpleDateFormat("MM"); // 01
		formatter = new SimpleDateFormat("MMM"); // Jan
		formatter = new SimpleDateFormat("MMMM"); // January

		// The day
		formatter = new SimpleDateFormat("d"); // 9
		formatter = new SimpleDateFormat("dd"); // 09

		// The day in week
		formatter = new SimpleDateFormat("E"); // Wed
		formatter = new SimpleDateFormat("EEEE"); // Wednesday

		java.util.Date l_date = p_date;

		formatter = new SimpleDateFormat(strDateFormat);

		String strDate = formatter.format(l_date);

		return strDate.replaceAll(" ", "&nbsp;");

	}
	
	public static boolean hasValue(String str) {
	  if (str != null && !str.equals("")) {
	    return true;
	  } else {
	    return false;
	  }
	}
}

<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.*, java.util.Calendar, java.util.StringTokenizer, java.text.SimpleDateFormat, java.sql.*, sun.jdbc.rowset.*, ausstage.*"%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>

<!--Script to enable sorting columns  -->
<script language="JavaScript" type="text/JavaScript">
  <!--
  /**
  * Make modifications to the sort column and sort order.
  */
  function reSortData( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.f_order_by.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value == 'ASC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.f_order_by.value = sortColumn;
  document.form_searchSort_report.order.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }

  function reSortNumbers( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.f_order_by.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value != 'DESC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.f_order_by.value = sortColumn;
  document.form_searchSort_report.order.value = 'DESC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  -->
</script>
<style>
 
  #bar {
  
    padding: 10px;
    margin: 5px;
  }
</style>
<%!
public String concatFields(Vector fields, String token) {
  String ret = "";
  for (int i=0; i<fields.size(); i++) {
    if (fields.elementAt(i) != null) {
        if (!(fields.elementAt(i)).equals("") && !ret.equals("")) {
          ret += token;
        }
        ret += fields.elementAt(i);
    }
  }
  return ret;
}

public String formatDate(String day, String month, String year) {
  if (year == null || year.equals("")){
    return "";
  }
  Calendar calendar = Calendar.getInstance();
   
  SimpleDateFormat formatter = new SimpleDateFormat();
  if (month == null || month.equals("") ){
    formatter.applyPattern("yyyy");
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  
  }
  else if(day == null || day.equals("") ){
    formatter.applyPattern("MMMMM yyyy");
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
    
  }
  else{
    formatter.applyPattern("d MMMMM yyyy");
    calendar.set(Calendar.DAY_OF_MONTH  ,new Integer(day).intValue());
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }
  java.util.Date date = calendar.getTime();
  String result = formatter.format(date);

  return result.replaceAll(" ", "&nbsp;");
}
%>

<%
  String picture_australia_search_string;
  String australia_dancing_search_string;
  String google_search_string;
  
  ausstage.Database          db_ausstage_for_result       = new ausstage.Database ();
  admin.Common            common                       = new admin.Common   ();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset                     = null;
  Search search;
  String formatted_date                  = "";
  String keyword                         = request.getParameter("f_keyword");
  String table_to_search_from            = request.getParameter("f_search_from");
  String page_num                        = request.getParameter("f_page_num");
  String recset_count                    = request.getParameter("f_recset_count");
  String search_within_search_for_result = request.getParameter("f_search_within_search");
  String inc_resources									 = request.getParameter("inc_resources");
  String f_sql_switch										 = request.getParameter("f_sql_switch");
  String f_date_clause									 = request.getParameter("f_date_clause");
  String f_sort_by											 = request.getParameter("f_sort_by");
  int l_int_page_num                     = 0;
  State state                            = new State(db_ausstage_for_result);
  SimpleDateFormat formatPattern         = new SimpleDateFormat("dd/MM/yyyy");
  String         orderBy                 = request.getParameter("f_order_by");
  String         sortOrd                 = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
 
  boolean do_print                       = false;
  // Secondary Rowset to be used in when crset is already in use i.e. when 
  CachedRowSet crset2                     = null;
  Statement stmt;
  String m_inc_resource                   = request.getParameter("inc_resources");
  String resultsPerPage                   = request.getParameter("f_limit_by");
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "20";

    ///////////////////////////////////
    //    DISPLAY SEARCH RESULTS
    //////////////////////////////////
    // set the search_within_search_for_result variable
    if(search_within_search_for_result == null){search_within_search_for_result ="";}
    if(m_inc_resource != null && m_inc_resource.equals("null")){m_inc_resource = null;}

    int counter;
    int start_trigger;
    int curr_row = 0;      
    search = new Search(db_ausstage_for_result);
    
    // Make sure that a keyword has been entered. The user may have javascript disabled.
    if (keyword == null ||
        keyword.equals("null") ||
        keyword.equals("")) {
      search.setKeyWord("xxxxNoDataEnteredxx"); // Dummy string so that an error is not generated by the database 
    } 
    else {
      search.setKeyWord(keyword.trim());
    }

    if(request.getParameter("f_sql_switch") != null){
      search.setSqlSwitch(request.getParameter("f_sql_switch").toString());
    }
    
    if(table_to_search_from != null){
      search.setSearchFor(table_to_search_from);
    }
    
    //System.out.println(orderBy);
    if(orderBy != null){
    	search.setOrderBy((orderBy.equals("venue_name")?"venue_name "+sortOrd+ ", suburb " + sortOrd +" ," + (state.equals("state")?"state":"venue_state"):orderBy) + " " + sortOrd);
      }
    
    if(request.getParameter("f_sort_by") != null){
      search.setSortBy(request.getParameter("f_sort_by").toString());
    }
    System.out.println("Order By: " + orderBy);
    System.out.println(sortOrd);
    
    // check if the search is search within a search
    if(!search_within_search_for_result.equals(""))
      search.setSearchWithinResults((String) session.getAttribute("sub_search_str"));
    
    if(page_num != null){
      if(Integer.parseInt(page_num) > 1)
        curr_row = Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage);
    }else{
      recset_count = search.getRecordCount();
    }
    
    // Either all, or events with an associated resource, or events with an associated online resource - only to be done for Search All
    // default condition is to include resources

    if (m_inc_resource != null){
      search.setResourceVisible(m_inc_resource);
    }
  
    /**********************************************
      ALL OR EVENT RESULT
    **********************************************/
   // System.out.println("Display all results");
    //if(table_to_search_from != null){
    	System.out.println("Display event results");
    	String unformattedDate = request.getParameter("f_year");
    if(table_to_search_from.equals("all") || table_to_search_from.equals("event") ){
    	if(request.getParameter("f_year") != null && !request.getParameter("f_year").equals("")){
      // Dates are only part of the all and event searches
      
      if(unformattedDate != null && !unformattedDate.equals("")){
        // Date can be in the form "1996" or "1996-2008"
        String yearFrom        = "";
        String yearTo          = "";
        if (unformattedDate.length() == 4) {
          yearTo = unformattedDate;
          yearFrom = unformattedDate;
        }
        else if (unformattedDate.length() == 9) {
          yearFrom = unformattedDate.substring(0, 4);
          yearTo = unformattedDate.substring(5);
        }
        else {
          // Invalid date, should not get here because of form submission validation
        }

        if (yearTo.length() == 4 && yearFrom.length() == 4) {
          search.setBetweenFromDate(yearFrom, "01", "01");
          search.setBetweenToDate(yearTo, "12", "31");
         }
      }    
    	}
      
      if(table_to_search_from.equals("all"))
        crset = search.getAll();
      else
        crset = search.getEvents();

      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){
        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width=\"100%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");      
        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"8\"  >");

        // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        //if(search_within_search_for_result.equals(""))
        out.print("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Event Name to view details.");
        
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
  				<input type="hidden" name="f_page_num" value="<%=page_num%>">
  				<input type="hidden" name="f_recset_count" value="<%=recset_count%>">
					<input type="hidden" name="f_sql_switch" value="<%=f_sql_switch%>">
  				<input type="hidden" name="f_sort_by" value="<%=f_sort_by%>">
  				<input type="hidden" name="f_date_clause" value="<%=f_date_clause%>">
  				<input type="hidden" name="f_search_within_search" value="<%=search_within_search_for_result%>">
					<input type="hidden" name="inc_resources" value="<%=inc_resources%>">
  			</form>
        <%

        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");  
        out.println("      <tr>");
        out.println("       <td colspan=\"8\">&nbsp;</td>");
        out.println("      </tr>");
              
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td width=\"215\" ><b><a href=\"#\" onClick=\"reSortData('event_name')\"> Event Name</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"277\" ><b><a href=\"#\" onClick=\"reSortData('venue_name')\">Venue</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"80\" align='right' ><b><a href=\"#\" onClick=\"reSortData('first_date')\">First Date</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"80\" align='right' ><b><a href=\"#\" onClick=\"reSortData('total')\">Resources</a></b></td>");
      //  out.println("       <td width=\"1\">&nbsp;</td>"); // For Resource Image
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>"); 

        counter       = 0;
        start_trigger = 0;
        do_print = false;
     
        // DISPLAY SEARCH RESULT(S)
        do{
          
          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }
          
          if(do_print){

            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";
            out.println("      <tr>");                                               
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"215\" ><a href=\"/pages/event/?id=" + crset.getString("eventid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("event_name")+  "</a></td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.print("       <td " + bgcolour +  " valign=\"top\" width=\"277\" >");

            String venDisplay = "";
            if(crset.getString("venue_name") != null) {
              venDisplay = crset.getString("venue_name");
            }
            if(crset.getString("suburb") != null) {
              if (!venDisplay.equals("")) {
                venDisplay += ", ";
              }
              venDisplay += crset.getString("suburb");
            }
            
            if(crset.getString("venue_state") != null) {
              if (!venDisplay.equals("")) {
                venDisplay += ", ";
              }
              venDisplay += crset.getString("venue_state");
            }
            out.println(venDisplay + "</td>");
                        
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.println("       <td " + bgcolour +  " valign=\"top\" align ='right' width=\"80\" >");
            formatted_date = "";
            Event eventObj = new Event(db_ausstage_for_result);            
            CachedRowSet event_crset = eventObj.getEventsById(crset.getString("eventid"));  
            event_crset.next();
          
            out.println(formatDate(event_crset.getString("DDFIRST_DATE"), event_crset.getString("MMFIRST_DATE"),event_crset.getString("YYYYFIRST_DATE") ));
            out.println("</td>");

            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            if(crset.getString("total").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("total"));   
            }
            
            /*
            // Requirement: show image if event has an associated ONLINE resource.
            // The block runs for a search on: 
            //  - ALL, has no eventid => prevent from erroring
            //  - Events => definitely run
            // only can show image if the eventid is in the result set of crset
            if (crset.findColumn("resource_flag") > -1){
              if (crset.getString("resource_flag").equals("ONLINE")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongreen.gif' alt='Related Resource'></td>"); // For Resource Image
              }
              else if (crset.getString("resource_flag").equals("Y")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongrey.gif' alt='Related Resource'></td>"); // For Resource Image
              }else {
                out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
              }
            }*/
           
            out.println(      "</tr>");
            counter++;                       
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }          
          start_trigger++;         
        }while(crset.next());

       out.println("      <tr>");
       out.println("       <td colspan=\"9\" bgcolor=\"aaaaaa\" >");      
       out.println("       </td>");
       out.println("      </tr>");

        // PAGINATION DISPLAY //

        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
                 
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){       
          out.println("      <tr>");
          out.println("       <td colspan=\"7\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"right\" colspan=\"9\" >");         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage+""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
                            
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }          
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
                        "&f_date_clause=" + request.getParameter("f_date_clause") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "&inc_resources=" + m_inc_resource +
                        "&sort_order="+ request.getParameter("order")+
                        "&f_order_by=" + request.getParameter("f_order_by") +
                   //     "&f_year=" + unformattedDate +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" +  
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
                        "&f_date_clause=" + request.getParameter("f_date_clause") +    
                        "&f_search_within_search=" + search_within_search_for_result +
                        "&inc_resources=" + m_inc_resource +
                        "&sort_order="+ request.getParameter("order")+
                        "&f_order_by=" + request.getParameter("f_order_by") +
                     //   "&f_year=" + unformattedDate +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + 
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
                          "&f_date_clause=" + request.getParameter("f_date_clause") + 
                          "&f_search_within_search=" + search_within_search_for_result +
                          "&inc_resources=" + m_inc_resource +
                          "&sort_order="+ request.getParameter("order")+
                          "&f_order_by=" + request.getParameter("f_order_by") +
                     //     "&f_year=" + unformattedDate +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" +  
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
                        "&f_date_clause=" + request.getParameter("f_date_clause") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "&inc_resources=" + m_inc_resource +
                        "&sort_order="+ request.getParameter("order")+
                        "&f_order_by=" + request.getParameter("f_order_by") +
                 //       "&f_year=" + unformattedDate +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 
        
        // External links to other sites
        out.println("      <tr>");
        out.println("       <td colspan='7' ><br><br>");
        out.println("       </td>");
        out.println("      </tr> ");
        
        
        out.println("     </table>");
     
      }else{
        out.println("<p>Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
       
    	}
    }else if (table_to_search_from.equals("venue")){

    /**********************************************
      VENUE RESULT
    **********************************************/
          
      crset = search.getVenues();

      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){

        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width='100%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");
        out.println("       <b></b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");

        // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        //if(search_within_search_for_result.equals(""))
        out.println("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Venue Name to view details.");
                
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
				</form>
        <%
        
        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");        
        out.println("      <tr>");
        out.println("       <td colspan=\"7\">&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td width=\"215\" ><b><a href=\"#\" onClick=\"reSortData('venue_name')\">Venue Name</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"277\" ><b><a href=\"#\" onClick=\"reSortData('street')\">Address</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"80\"><b><a href=\"#\" onClick=\"reSortData('dates')\">Event Dates</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"80\" align='right'><b><a href=\"#\" onClick=\"reSortData('num')\">Events</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"80\" align='right'><b><a href=\"#\" onClick=\"reSortData('total')\">Resources</a></b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>");
       
        counter       = 0;
        start_trigger = 0;
        do_print = false;
        

        // DISPLAY SEARCH RESULT(S)
        do{
          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }          
          if(do_print){
            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";                    
            out.println("      <tr>");
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"215\" ><a href=\"/pages/venue/?id=" + crset.getString("venueid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("venue_name") + "</a></td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"277\" >");

            if(crset.getString("street") != null)
              out.println(crset.getString("street") + ", ");
              
            if(crset.getString("suburb") != null)
              out.println(crset.getString("suburb")  + ", ");

            if(crset.getString("venue_state") != null)
              out.println(crset.getString("venue_state"));
            
            out.print("         </td>");
            
/*
            if(crset.getString("web_links") != null){
              out.println("<a href=\"");
              if(crset.getString("web_links").indexOf("http://") < 0)
                out.println("http://");
              out.println(crset.getString("web_links") + "\">" + crset.getString("web_links") + "</a>");
            }
            */
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.println("       <td " + bgcolour +  " align=\"left\" valign=\"top\" >" + crset.getString("dates"));   
            
            out.println(      "</td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            if(crset.getString("num").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("num"));   
            }
          
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            if(crset.getString("total").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("total"));   
            }
            
            
            
            /*
            if (crset.findColumn("resource_flag") > -1){
              if (crset.getString("resource_flag").equals("ONLINE")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongreen.gif' alt='Related Online Resource'></td>"); // For Resource Image
              }
              else if (crset.getString("resource_flag").equals("Y")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongrey.gif' alt='Related Resource'></td>"); // For Resource Image
              }else {
                out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
              }
            }*/
            out.println("</tr>");
            counter++;                       
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }         
          start_trigger++;          
        }while(crset.next());
       
	out.println("      <tr>");
   	out.println("       <td colspan=\"10\" bgcolor=\"aaaaaa\" >");      
    	out.println("       </td>");
    	out.println("      </tr>");

        // PAGINATION DISPLAY //

        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
          
        
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){
       
          out.println("      <tr>");
          out.println("       <td colspan=\"10\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"right\" colspan=\"10\" >");
         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
          
          
          
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }


          
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + 
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + request.getParameter("f_sort_by") +
                          "&f_search_within_search=" + search_within_search_for_result +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 

        // External links to other sites
        out.println("      <tr>");
        out.println("       <td colspan='7' ><br><br>");
        out.println("       </td>");
        out.println("      </tr> ");
        
        out.println("     </table>");
     
      }else{
        out.println("<p >Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
      }

   }else if (table_to_search_from.equals("work")){

    /**********************************************
      WORK RESULT
    **********************************************/
          
      crset = search.getWorks();

      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){

        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width='100%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");

        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("       <td ></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td>");
        out.println("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Work Name to view details.");
 
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
				</form>
        <%
        
        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");        
        out.println("      <tr>");
        out.println("       <td>&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('work_title')\">Work Name</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('contrib')\">Creators</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('dates')\">Event Dates</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('events')\">Events</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('resources')\">Resources</a></b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>");
        
        counter       = 0;
        start_trigger = 0;
        do_print = false;
        

        // DISPLAY SEARCH RESULT(S)
        do{

          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }
          
          if(do_print){

            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";          
          
            out.println("      <tr>");
            out.println("<td width=\"900\" " + bgcolour +  " valign=\"top\"><a href=\"/pages/work/?id=" + crset.getString("workid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("work_title") + "</a></td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.println("<td width=\"500\" " + bgcolour +  " valign=\"top\">" + crset.getString("contrib") + "</td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            out.println("<td width=\"150\" " + bgcolour +  " valign=\"top\">" + crset.getString("dates") + "</td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            if(crset.getString("events").equals("0"))
            {
            	 out.println("<td align=\"center\" width=\"80\" " + bgcolour +  " valign=\"top\"></td>");
            }else
            {
              out.println("<td align=\"center\" width=\"80\" " + bgcolour +  " valign=\"top\">" + crset.getString("events") + "</td>");
            }
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            if(crset.getString("resources").equals("0"))
            {
            	 out.println("<td align=\"center\" width=\"80\" " + bgcolour +  " valign=\"top\"></td>");
            }else
            {
            	out.println("<td align=\"center\" width=\"80\" " + bgcolour +  " valign=\"top\">" + crset.getString("resources") + "</td>");
            }
            out.println("</tr>");

            counter++;
                        
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }         
          start_trigger++;          
        }while(crset.next());       
	out.println("      <tr>");
   	out.println("       <td colspan=\"9\" bgcolor=\"aaaaaa\" >");
    	out.println("       </td>");
    	out.println("      </tr>");

        // PAGINATION DISPLAY //

        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
                 
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){       
          out.println("      <tr>");
          out.println("       <td>&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td colspan=\"9\" align=\"right\">");
         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
                        
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }
          
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + 
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + request.getParameter("f_sort_by") +
                          "&f_search_within_search=" + search_within_search_for_result +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 

        // External links to other sites
        out.println("      <tr>");
        out.println("       <td><br><br>");
        out.println("       </td>");
        out.println("      </tr> ");
        
        out.println("     </table>");
     
      }else{
        out.println("<p >Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
      }

      
    }else if (table_to_search_from.equals("contributor")){
    
    /**********************************************
      CONTRIBUTOR RESULT
    **********************************************/
    
      if(request.getParameter("f_year") != null && !request.getParameter("f_year").equals("")){
        // Date can be in the form "1996" or "1996-2008"
     //   String unformattedDate = request.getParameter("f_year");
        String yearFrom        = "";
        String yearTo          = "";
        if (unformattedDate.length() == 4) {
          yearTo = unformattedDate;
          yearFrom = unformattedDate;
        }
        else if (unformattedDate.length() == 9) {
          yearFrom = unformattedDate.substring(0, 4);
          yearTo = unformattedDate.substring(5);
        }
        else {
          // Invalid date, should not get here because of form submission validation
        }

        if (yearTo.length() == 4 && yearFrom.length() == 4) {
          search.setBetweenFromDate(yearFrom, "01", "01");
          search.setBetweenToDate(yearTo, "12", "31");
         }
      } 
      
      crset = search.getContributors();
      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){

        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width='100%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");

        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");
        out.println("       <b>Search Results</b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");

        // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        //if(search_within_search_for_result.equals(""))
          out.println("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Contributor Name to view details.");
       
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
				</form>
        <%
        
        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");        
        out.println("      <tr>");
        out.println("       <td colspan=\"7\">&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td width=\"200\" ><b><a href=\"#\" onClick=\"reSortData('contrib_name')\">Contributor Name</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"100\" ><b><a href=\"#\" onClick=\"reSortData('event_dates')\">Event Dates</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"250\" ><b><a href=\"#\" onClick=\"reSortData('function')\">Functions</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"50\" align='right'><b><a href=\"#\" onClick=\"reSortData('num')\">Events</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"50\" align='right'><b><a href=\"#\" onClick=\"reSortData('total')\">Resources</a></b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>");
        

        counter       = 0;
        start_trigger = 0;
        do_print = false;
        

        // DISPLAY SEARCH RESULT(S)
        do{

          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }
          
          if(do_print){

            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";
              
            out.println("      <tr>");
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"250\" ><a href=\"/pages/contributor/?id=" + crset.getString("contributorid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("contrib_name") + "</a></td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
   
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"100\" >");
            if(crset.getString("event_dates") != null)
              out.println(crset.getString("event_dates"));
            out.println("       </td>");
            
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\"100\" >");
            if(crset.getString("function") != null)
              out.println(crset.getString("function"));
            out.println("       </td>");
            
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            if(crset.getString("num").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("num"));   
            }
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            if(crset.getString("total").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("total"));   
            }

      
            /*
            if (crset.findColumn("resource_flag") > -1){
              if (crset.getString("resource_flag").equals("ONLINE")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongreen.gif' alt='Related Online Resource'></td>"); // For Resource Image
              }
              else if (crset.getString("resource_flag").equals("Y")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongrey.gif' alt='Related Resource'></td>"); // For Resource Image
              }else {
                out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
              }
            }*/
            out.println("</tr>");
            counter++;
                        
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }
          
          start_trigger++;
          
        }while(crset.next());
       
	out.println("      <tr>");
    	out.println("       <td colspan=\"10\" bgcolor=\"aaaaaa\" >");
      
    	out.println("       </td>");
    	out.println("      </tr>");

        // PAGINATION DISPLAY //

        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
          
        
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){
       
          out.println("      <tr>");
          out.println("       <td colspan=\"7\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"right\" colspan=\"10\" >");
         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
          
          
          
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }


          
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" +  
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + request.getParameter("f_sort_by") +
                          "&f_search_within_search=" + search_within_search_for_result +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 

        // External links to other sites
        out.println("      <tr>");
        out.println("       <td colspan='7' ><br><br>");
        out.println("      </tr> ");
        
        out.println("     </table>");
     
      }else{
        out.println("<p>Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
      }    
    }else if (table_to_search_from.equals("organisation")){
    
    /**********************************************
      ORGANISATION RESULT
    **********************************************/
          
      crset = search.getOrganisations();

      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){

        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width='100%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");

        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");
        out.println("       <b>Search Results</b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");

        // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        //if(search_within_search_for_result.equals(""))
          out.println("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Organisation Name to view details.");
        
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
				</form>
        <%
    
        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");        

        out.println("      <tr>");
        out.println("       <td colspan=\"7\">&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td width=\"250\" ><b><a href=\"#\" onClick=\"reSortData('name')\">Organisation Name</a></b></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"200\" ><b><a href=\"#\" onClick=\"reSortData('dates')\">Event Dates</b></a></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"50\" align='right'><b><a href=\"#\" onClick=\"reSortData('num')\">Events</b></a></td>");
        out.println("       <td width=\"1\">&nbsp;</td>");
        out.println("       <td width=\"50\" align='right'><b><a href=\"#\" onClick=\"reSortData('total')\">Resources</b></a></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>");

        counter       = 0;
        start_trigger = 0;
        do_print = false;
        

        // DISPLAY SEARCH RESULT(S)
        do{

          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }
          
          if(do_print){

            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";
              
            out.println("      <tr>");
            out.println("       <td " + bgcolour +  " valign=\"top\" width=\215\" ><a href=\"/pages/organisation/?id=" + crset.getString("organisationid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("name")+"</a></td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
           /* out.println("       <td " + bgcolour +  " valign=\"top\" width=\"277\" >");

            String orgDisplay = "";
            if(crset.getString("address") != null) {
              orgDisplay = crset.getString("address");
            }

            if(crset.getString("suburb") != null) {
              if (!orgDisplay.equals("")) {
                orgDisplay += ", ";
              }
              orgDisplay += crset.getString("suburb");
            }
            
            if(crset.getString("org_state") != null) {
              if (!orgDisplay.equals("")) {
                orgDisplay += ", ";
              }
              orgDisplay += crset.getString("org_state");
            }

            if (orgDisplay.equals("")) {
              orgDisplay += "&nbsp;";
            }
            out.println(orgDisplay);              
            
            out.print("         </td>");*/
            
            
            
            //Event Dates
            out.println("       <td " + bgcolour +  " align=\"left\" valign=\"top\" >" + crset.getString("dates"));   
            out.print("         </td>");
         
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            if(crset.getString("num").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("num"));   
            }
            
            out.print("         </td>");
            out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>");
            
            if(crset.getString("total").equals("0"))
            {
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
            }else{
            	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("total"));   
            }
            out.print("         </td>");
           /* out.println("       <td " + bgcolour +  " valign=\"top\" width=\"80\" >");

            if(crset.getString("web_links") != null){
              out.println("<a href=\"");
              if(crset.getString("web_links").indexOf("http://") < 0)
                out.println("http://");
              out.println(crset.getString("web_links") + "\">" + crset.getString("web_links") + "</a>");
            }
            else{
              out.println("&nbsp;");            
            }
            
            out.println(      "</td>");*/
           
						/*
            if (crset.findColumn("resource_flag") > -1){
              if (crset.getString("resource_flag").equals("ONLINE")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongreen.gif' alt='Related Online Resource'></td>"); // For Resource Image
              }
              else if (crset.getString("resource_flag").equals("Y")) {
                out.println("       <td " + bgcolour +  " width=\"1\"><img src='/custom/ausstage/images/resourceicongrey.gif' alt='Related Resource'></td>"); // For Resource Image
              }else {
                out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
              }
            }*/
            out.println("</tr>");

            counter++;
                        
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }
          
          start_trigger++;
          
        }while(crset.next());
        out.println("      <tr>");
    	out.println("       <td colspan=\"8\" bgcolor=\"aaaaaa\" >");
      
    	out.println("       </td>");
    	out.println("      </tr>");


        // PAGINATION DISPLAY //

        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
          
        
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){
       
          out.println("      <tr>");
          out.println("       <td colspan=\"7\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"right\" colspan=\"8\" >");
         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
          
          
          
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }


          
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" +  
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + 
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + request.getParameter("f_sort_by") +
                          "&f_search_within_search=" + search_within_search_for_result +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" +
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 

        // External links to other sites
        out.println("      <tr>");
        out.println("       <td colspan='7' ><br><br>");
        out.println("      </tr> ");
        out.println("     </table>");
     
      }else{
        out.println("<p >Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
       }    
      
      
      
      }else if (table_to_search_from.equals("resource")){
    
    /**********************************************
      Resource RESULT
    **********************************************/
      if(request.getParameter("f_year") != null && !request.getParameter("f_year").equals("")){
        // Date can be in the form "1996" or "1996-2008"
    //    String unformattedDate = request.getParameter("f_year");
        String yearFrom        = "";
        String yearTo          = "";
        if (unformattedDate.length() == 4) {
          yearTo = unformattedDate;
          yearFrom = unformattedDate;
        }
        else if (unformattedDate.length() == 9) {
          yearFrom = unformattedDate.substring(0, 4);
          yearTo = unformattedDate.substring(5);
        }
        else {
          // Invalid date, should not get here because of form submission validation
        }

        if (yearTo.length() == 4 && yearFrom.length() == 4) {
          search.setBetweenFromDate(yearFrom, "01", "01");
          search.setBetweenToDate(yearTo, "12", "31");
         }
      }   
      crset = search.getResources();

      // set the session here
      if(search_within_search_for_result.equals(""))
        session.setAttribute("sub_search_str", search.getSearchWithinResults());
      
      if(crset != null && crset.next()){

        // get the number of rows returned (1st time only)
        if(page_num == null){
          page_num ="1";
          crset.last(); 
          recset_count = Integer.toString(crset.getRow());
          crset.first();         
        }

        out.println("     <table width='100%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
        // DISPLAY NUMBER OF RESULTS
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");
        out.println("       <b>Search Results</b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"  >");

        // SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
        //if(search_within_search_for_result.equals(""))
        out.println("Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " result(s).");
        out.print(" Click Resource Citation to view details.");
        
        %>
        <form name="form_searchSort_report" method="POST" action="?">
          <input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
					<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
				</form>
        <%
       
        // DISPLAY HEADERS AND TITLES
        out.println("       </td>");
        out.println("      </tr>");        				
        out.println("      <tr>");
        out.println("       <td colspan=\"7\">&nbsp;</td>");
        out.println("      </tr>");
     
        
         
        out.println("      <tr>");
        out.println("       <td>&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr id=\"bar\" class =\"b-186\">");
        out.println("       <td ><b><a href=\"#\" onClick=\"reSortData('citation')\">Citation</a></b></td>");
        out.println("      </tr>");
        out.println("      <tr>");
        out.println("       <td colspan=\"7\"></td>");
        out.println("      </tr>");
       
        counter       = 0;
        start_trigger = 0;
        do_print = false;        

        // DISPLAY SEARCH RESULT(S)
        do{
          if(page_num == null){
            do_print = true;
          }else if(page_num.equals("1")){
            do_print = true;
          }else{
            if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage)) == start_trigger)
              do_print = true;
          }         
          if(do_print){
            String bgcolour = "";
            if ((counter%2) == 0 ) // is it odd or even number???
              bgcolour = "bgcolor='#e3e3e3'";
            else
              bgcolour = "bgcolor='#FFFFFF'";             
            out.println("      <tr>");
            out.println("       <td " + bgcolour +  " valign=\"top\" ><a href=\"/pages/resource/?id=" + crset.getString("itemid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("citation") + "</a></td>");            
            out.println(      "</tr>");
            counter++;                        
            if(counter == Integer.parseInt(resultsPerPage))
              break;
          }          
          start_trigger++;         
        }while(crset.next());
        out.println("      <tr>");
    	out.println("       <td colspan=\"7\" bgcolor=\"aaaaaa\" >");      
    	out.println("       </td>");
    	out.println("      </tr>");


        // PAGINATION DISPLAY //
        String unrounded_page_num = "";
        int rounded_num_pages     = 0;
        int remainder_num         = 0;
        int int_page_num          = 0;
        int i                     = 1;
                  
        if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){
       
          out.println("      <tr>");
          out.println("       <td colspan=\"7\">&nbsp;</td>");
          out.println("      </tr>");
          out.println("      <tr>");
          out.println("       <td align=\"right\" colspan=\"7\" >");
         
          unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
          rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
          remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
                   
          if(remainder_num > 0)
            rounded_num_pages++; // add another page if remainder > 0

          // convert the page_num to a useful mathematical type
          // and use it as the start number for our page numbering
          if(page_num != null){
            int_page_num = Integer.parseInt(page_num);

            // find the middle number so that if 10 is
            // hit(or the 'Next' & 'Previous' number)
            // the page number will display
            // 6 7 8 9 10 11 12 13 14 15
            if(int_page_num >= 10)
              i = int_page_num - 4;
          }         
          out.println("&nbsp;&nbsp;");
          
          // write Previous
          if(int_page_num > 1)
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num - 1) + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Previous</a>&nbsp;");

          
          // write page numbers
          counter = 0;
          for(; i < rounded_num_pages + 1; i++){
            String highlight_number_str = "";

            if(int_page_num == i)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else if(page_num == null && i == 1)
              highlight_number_str = "<b>" + Integer.toString(i) + "</b>";
            else
              highlight_number_str = Integer.toString(i);
              
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + i + 
                        "&f_recset_count=" + recset_count + 
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") + 
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">" + highlight_number_str + "</a>&nbsp;");

            counter++;
            if(counter == 10)
              break;
          }

          // write Next
          if(page_num != null){
            if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
              out.println("<a href=\"" + 
                          "?f_keyword=" + common.URLEncode(keyword) + 
                          "&f_search_from=" + table_to_search_from + 
                          "&f_page_num=" + (int_page_num + 1) + 
                          "&f_recset_count=" + recset_count + 
                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                          "&f_sort_by=" + request.getParameter("f_sort_by") +
                          "&f_search_within_search=" + search_within_search_for_result +
                          "\">Next</a>");
            }
          }else{
            out.println("<a href=\"" + 
                        "?f_keyword=" + common.URLEncode(keyword) + 
                        "&f_search_from=" + table_to_search_from + 
                        "&f_page_num=" + (int_page_num + 2) + 
                        "&f_recset_count=" + recset_count +
                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                        "&f_sort_by=" + request.getParameter("f_sort_by") +
                        "&f_search_within_search=" + search_within_search_for_result +
                        "\">Next</a>");
          }
              
          out.println("       </td>");
          out.println("      </tr>");
        } 

        // External links to other sites
        out.println("      <tr>");
        out.println("       <td colspan='7' ><br><br>");
        out.println("      </tr> ");
        
        out.println("     </table>");
     
      }else{
        out.println("<p >Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
      }
      }
  //  }
%>

<script language="javascript">
   
  function reloadList (){
    // it does not matter if the user enters any values in the search fields.
    // this submit is only to use the previous;y entered values to requery

    // set all values to '', only if the attribute.value is set do we change the value
    document.searchform.f_keyword.value = '';  
    document.searchform.f_search_from.value = '';
    //document.searchform.f_recset_count.value = '';
    document.searchform.f_sql_switch.value = '';
    document.searchform.f_sort_by.value = '';
    document.searchform.f_year.value = '';
    
    /*
    document.searchform.f_date_clause.value = '';

    document.searchform.f_yyyyfirstdate.value = '';
    document.searchform.f_mmfirstdate.value = '';
    document.searchform.f_ddfirstdate.value = '';

    document.searchform.f_yyyybetweenfromdate.value = '';
    document.searchform.f_mmbetweenfromdate.value = '';
    document.searchform.f_ddbetweenfromdate.value = '';

    document.searchform.f_yyyybetweentodate.value = '';
    document.searchform.f_mmbetweentodate.value = '';
    document.searchform.f_ddbetweentodate.value = '';
*/
    <% if (keyword != null && !keyword.equals("")) { %>
      document.searchform.f_keyword.value = <%="\"" + keyword + "\""%>;  
    <% } %>

    <% if (table_to_search_from != null && !table_to_search_from.equals("")) { %>
      document.searchform.f_search_from.value = <%="\"" +table_to_search_from + "\""%>;
    <% } %>

    //<% if (recset_count != null && !recset_count.equals("")) { %>
    //  document.searchform.f_recset_count.value = <%=recset_count%>;
    //<% } %>

    <% if (request.getParameter("f_sql_switch") != null && !request.getParameter("f_sql_switch").equals("")) { %>
      document.searchform.f_sql_switch.value = <%="\"" +request.getParameter("f_sql_switch") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_sort_by") != null && !request.getParameter("f_sort_by").equals("")) { %>
      document.searchform.f_sort_by.value = <%="\"" + request.getParameter("f_sort_by") + "\""%>;
    <% } %>
    
    
    <% if (request.getParameter("f_year") != null && !request.getParameter("f_year").equals("")) { %>
      document.searchform.f_year.value = <%="\"" + request.getParameter("f_year") + "\""%>;
    <% } %>
/*
    <% if (request.getParameter("f_date_clause") != null && !request.getParameter("f_date_clause").equals("")) { %>
      document.searchform.f_date_clause.value = <%="\"" + request.getParameter("f_date_clause") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_yyyyfirstdate") != null && !request.getParameter("f_yyyyfirstdate").equals("")) { %>
      document.searchform.f_yyyyfirstdate.value = <%="\"" + request.getParameter("f_yyyyfirstdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_mmfirstdate") != null && !request.getParameter("f_mmfirstdate").equals("")) { %>
      document.searchform.f_mmfirstdate.value = <%="\"" + request.getParameter("f_mmfirstdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_ddfirstdate") != null && !request.getParameter("f_ddfirstdate").equals("")) { %>
      document.searchform.f_ddfirstdate.value = <%="\"" + request.getParameter("f_ddfirstdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_yyyybetweenfromdate") != null && !request.getParameter("f_yyyybetweenfromdate").equals("")) { %>
      document.searchform.f_yyyybetweenfromdate.value = <%="\"" + request.getParameter("f_yyyybetweenfromdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_mmbetweenfromdate") != null && !request.getParameter("f_mmbetweenfromdate").equals("")) { %>
      document.searchform.f_mmbetweenfromdate.value = <%="\"" + request.getParameter("f_mmbetweenfromdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_ddbetweenfromdate") != null && !request.getParameter("f_ddbetweenfromdate").equals("")) { %>
      document.searchform.f_ddbetweenfromdate.value = <%="\"" + request.getParameter("f_ddbetweenfromdate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_yyyybetweentodate") != null && !request.getParameter("f_yyyybetweentodate").equals("")) { %>
      document.searchform.f_yyyybetweentodate.value = <%="\"" + request.getParameter("f_yyyybetweentodate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_mmbetweentodate") != null && !request.getParameter("f_mmbetweentodate").equals("")) { %>
      document.searchform.f_mmbetweentodate.value = <%="\"" + request.getParameter("f_mmbetweentodate") + "\""%>;
    <% } %>

    <% if (request.getParameter("f_ddbetweentodate") != null && !request.getParameter("f_ddbetweentodate").equals("")) { %>
      document.searchform.f_ddbetweentodate.value = <%="\"" + request.getParameter("f_ddbetweentodate") + "\""%>;
    <% } %>

   for(var i = 0; i < document.resource_radio.inc_resources.length; i++) {
      if(document.resource_radio.inc_resources[i].checked) {
        document.searchform.inc_resources.value = document.resource_radio.inc_resources[i].value;
      }
    }
    */
    document.searchform.submit();
  }
  
  //-->
  </script>
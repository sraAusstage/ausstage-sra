<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.*, java.util.Calendar, java.util.StringTokenizer, java.text.SimpleDateFormat, java.sql.*, sun.jdbc.rowset.*, ausstage.*"%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<!--  
Display event results. This jsp has been extracted from a bigger jsp - search_results.jsp, that originally showed search results database records depending on the search table variable. 
I split them up to make edits easier, but I have NOT changed the initial code. Where possible I have removed unneccesary code. 
Variables used here will be defined in pages/search/results/index.jsp  - 
depending on the  searchFrom parameter, index.jsp will include the appropriate jsp to display results.
Brad Williams - as part of changes for visualizing internationalisation of Ausstage - April 2015
-->
<%

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

			if (recset_count.equals("1")){resultPlaceholder = ONE_RESULT;}
			else resultPlaceholder = PLURAL_RESULT;
			int totalResultsCount = Integer.parseInt(recset_count);
			int resultsPerPageValue = Integer.parseInt(resultsPerPage);
			int pageNumber = Integer.parseInt(page_num);
			int startPagedResultsCount = ((pageNumber -1)*resultsPerPageValue + 1);
			int endPagedResultsCount = ((pageNumber-1)*resultsPerPageValue + resultsPerPageValue) > totalResultsCount ? totalResultsCount : (pageNumber-1)*resultsPerPageValue + resultsPerPageValue;
			// DISPLAY NUMBER OF RESULTS
			// SPECIFY THE MESSAGE WHETHER OR NOT THE SEARCH WITHIN RESULT WAS ACTIVATED
			
	
			//EVENT HEADER
			out.print("<div class=\"search\"><div class=\"search-bar b-90\">"
						+"<img src=\"../../../resources/images/icon-event.png\" class=\"search-icon\">"
						+"<span class=\"search-heading large\">Events</span>"
						+"<span class=\"search-index search-index-event\">Search results for \'"+keyword+"\'. "
						+ SearchCount.formatSearchCountWithCommas(startPagedResultsCount) + " to " + SearchCount.formatSearchCountWithCommas(endPagedResultsCount) + " of "
						+ SearchCount.formatSearchCountWithCommas(totalResultsCount) + " " + resultPlaceholder
						+"</span></div>");
        
        
			out.println("     <table class=\"search-table\">");
			%>
			<form name="form_searchSort_report" method="POST" action="?">
				<input type="hidden" name="f_order_by" value="<%=orderBy%>">
  				<input type="hidden" name="order" value="<%=sortOrd%>">
				<input type="hidden" name="f_keyword" value="<%=keyword%>">
  				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
  				<input type="hidden" name="f_page_num" value="<%=page_num%>">
  				<input type="hidden" name="f_recset_count" value="<%=recset_count%>">
				<input type="hidden" name="f_sql_switch" value="<%=f_sql_switch%>">
  				<!--<input type="hidden" name="f_sort_by" value="">-->
  				<input type="hidden" name="f_date_clause" value="<%=f_date_clause%>">
  				<input type="hidden" name="f_search_within_search" value="<%=search_within_search_for_result%>">
				<input type="hidden" name="inc_resources" value="<%=inc_resources%>">
  			</form>
			<%

			// DISPLAY HEADERS AND TITLES   
			out.println("      <thead>");          
			out.println("      <tr>");
			out.println("       <th width=\"215\" ><b><a href=\"#\" onClick=\"reSortData('event_name')\">Name</a></b></th>");
			out.println("       <th width=\"277\" ><b><a href=\"#\" onClick=\"reSortData('venue_name')\">Venue</a></b></th>");
			out.println("       <th width=\"80\" align='right' ><b><a href=\"#\" onClick=\"reSortData('first_date')\">First Date</a></b></th>");      
			out.println("       <th width=\"80\" align='right' ><b><a href=\"#\" onClick=\"reSortData('total')\">Resources</a></b></th>");
			out.println("      </thead>");
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
						bgcolour = "class='b-184'";
					else
						bgcolour = "class='b-185'";
					out.println("      <tr>");                                               
					out.println("       <td " + bgcolour +  " valign=\"top\" width=\"215\" ><a href=\"/pages/event/" + crset.getString("eventid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("event_name")+  "</a></td>");
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
                        
					out.println("       <td " + bgcolour +  " valign=\"top\" align ='right' width=\"80\" >");
					formatted_date = "";
            
					out.println(formatDate(crset.getString("DDFIRST_DATE"), crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE") ));
					out.println("</td>");

					if(crset.getString("total").equals("0")){
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
				out.println("      <tr width=\"100%\" class=\"search-bar b-90\" style=\"height:2.5em;\">");
				out.println("       <td align=\"right\" colspan=\"9\" >"); 
				out.println("        <div class=\"search-index search-index-event\">");        
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
          
				// write Previous
				if(int_page_num > 1){
					out.println("<a href=\"" + 
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=1" + 
							"&f_recset_count=" + recset_count + 
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") + 
							"\">First</a>&nbsp;");           
          
					out.println("<a href=\"" + 
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=" + (int_page_num - 1) + 
							"&f_recset_count=" + recset_count + 
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\">Previous</a>&nbsp;");
				}
				// write page numbers
				counter = 0;
				for(; i < rounded_num_pages + 1; i++){
					String highlight_number_str = "";

					if(int_page_num == i)
						highlight_number_str = "class='b-91 bold'>" + Integer.toString(i);
					else if(page_num == null && i == 1)
						highlight_number_str = "class='b-91 bold'>" + Integer.toString(i);
					else
						highlight_number_str = ">"+Integer.toString(i);
              
					out.println("<a href=\"" +  
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=" + i + 
							"&f_recset_count=" + recset_count + 
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") +    
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\"" + highlight_number_str + "</a>&nbsp;");

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
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\">Next</a>&nbsp;");
						out.println("<a href=\"" + 
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=" + rounded_num_pages + 
							"&f_recset_count=" + recset_count + 
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\">Last</a>");                          
                          
					}
				}
				else{
					out.println("<a href=\"" +  
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=" + (int_page_num + 2) + 
							"&f_recset_count=" + recset_count +
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\">Next </a>");
                        
					out.println("<a href=\"" + 
							"?f_keyword=" + common.URLEncode(keyword) + 
							"&f_search_from=" + table_to_search_from + 
							"&f_page_num=" + rounded_num_pages + 
							"&f_recset_count=" + recset_count + 
							"&f_sql_switch=" + request.getParameter("f_sql_switch") +
							//"&f_sort_by=" + (request.getParameter("f_sort_by")==null?orderBy:request.getParameter("f_sort_by")) +
							"&f_date_clause=" + request.getParameter("f_date_clause") + 
							"&f_search_within_search=" + search_within_search_for_result +
							"&inc_resources=" + m_inc_resource +
							"&sort_order="+ request.getParameter("order")+
							"&f_order_by=" + request.getParameter("f_order_by") +
							"\">Last</a>");                            
				}
				out.println("       </div>");    
				out.println("       </td>");
				out.println("      </tr>");
			} 
			out.println("     </table></div>");
     
		}else{
			out.println("<p>Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
    	}
%>



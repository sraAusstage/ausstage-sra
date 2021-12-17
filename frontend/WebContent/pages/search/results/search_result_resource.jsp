<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.*, java.util.Calendar, java.util.StringTokenizer, java.text.SimpleDateFormat, java.sql.*, sun.jdbc.rowset.*, ausstage.*"%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<!--  
Display resource results. This jsp has been extracted from a bigger jsp - search_results.jsp, that originally showed search results database records depending on the search table variable. 
I split them up to make edits easier, but I have NOT changed the initial code. Where possible I have removed unneccesary code. 
Variables used here will be defined in pages/search/results/index.jsp  - 
depending on the  searchFrom parameter, index.jsp will include the appropriate jsp to display results.
Brad Williams - as part of changes for visualizing internationalisation of Ausstage - April 2015
-->
<%
		/**********************************************
		Resource RESULT
		**********************************************/
		if(request.getParameter("f_year") != null && !request.getParameter("f_year").equals("")){
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

			if (recset_count.equals("1")){resultPlaceholder = ONE_RESULT;}
			else resultPlaceholder = PLURAL_RESULT;
        
			out.print("<div class=\"search\"><div class=\"search-bar b-153\">"
				+"<img src=\"../../../resources/images/icon-resource.png\" class=\"search-icon\">"
				+"<span class=\"search-heading large\">Resources</span>"
				+"<span class=\"search-index search-index-resource\">Search results for \'"+keyword+"\'. "
				//+((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " "+resultPlaceholder
				+"</span></div>");        
			
			%>
			<div class="scroll-table">
			<table class="search-table">
			<form name="form_searchSort_report" method="POST" action="?">
				<input type="hidden" name="f_order_by" value="<%=orderBy%>">
				<input type="hidden" name="order" value="<%=sortOrd%>">
				<input type="hidden" name="f_keyword" value="<%=keyword%>">
				<input type="hidden" name="f_sql_switch" value="<%=f_sql_switch%>">
				<input type="hidden" name="f_search_from" value="<%=table_to_search_from%>">
			</form>
			
            <!-- DISPLAY HEADERS AND TITLES -->
			      <thead>         
			      <tr>
			       <th min-width="5%" width="5%"><b><a href="#" onClick="reSortData('item_sub_type')">Type</a></b></th>
			       <th width="95%"><b><a href="#" onClick="reSortData('title')">Citation</a></b></th>
			      </thead>
			      </tr>
       <%
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
				%>
					<tr >
						<td min-width='5%' width='5%' <%=bgcolour%> valign="top" ><%=crset.getString("item_sub_type")%></td>
					       	<td width='95%' <%=bgcolour%> valign="top" >
					       	
					       					<!----------------------->											
				<%
				ItemArticle article = new ItemArticle(db_ausstage_for_result);
				article.load(crset.getString("itemid"));
				if (article.getBody() != null && article.getBody() != ""){
			        %>
				        <div style='width:20px; position:relative; float:left'>
					  	      	<!-- using bootstrap modal approach for this.-->
									 		<span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=crset.getString("itemid")%>'></span>
	
	      										<div id='article<%=crset.getString("itemid")%>' class="modal fade" role="dialog">
										  		<div class="modal-dialog wysiwyg" >
												    <!-- Modal content-->
												    <div class="modal-content">
													<div class="modal-header">
												          <button type="button" class="close" data-dismiss="modal">&times;</button>
												          <h4 class="modal-title"><%=crset.getString("citation")%></h4>
												        </div>		      
										 		        <div class="modal-body item-article-container">
													  <%=article.getBody()%>
										 		        </div>
												        <div class="modal-footer">
												          <button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
										 		        </div>
												   </div>	
												</div>
											</div>
												</div>
										        <%
										        }
										      %>
									      

										<!----------------------->	

					       	<a href='/pages/resource/<%=crset.getString("itemid")%>' onmouseover="this.style.cursor='hand';"><%=crset.getString("citation")%></a></td>           
					</tr>
				
				<%       
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
				%>
				<tfoot>
				<%
				out.println("      <tr>");
				out.println("       <td colspan=\"7\">&nbsp;</td>");
				out.println("      </tr>");
				out.println("      <tr width=\"100%\" class=\"search-bar b-153\" style=\"height:2.5em;\">");
				out.println("       <td align=\"right\" colspan=\"7\" >");
				out.println("        <div class=\"search-index search-index-resource\">");         
				unrounded_page_num  = Double.toString(Double.parseDouble(Integer.toString(Integer.parseInt(recset_count))) / Double.parseDouble(resultsPerPage + ""));
				rounded_num_pages   = Integer.parseInt(unrounded_page_num.substring(0, unrounded_page_num.indexOf(".")));     // ie. 5.4 will return 5    
				//remainder_num       = Integer.parseInt(unrounded_page_num.substring(unrounded_page_num.indexOf(".") + 1, unrounded_page_num.indexOf(".") + 2)); // ie. 5.4 will return 4          
				//quick fix for bug....	
				if((Double.parseDouble(unrounded_page_num)-rounded_num_pages)>0){
				  remainder_num=1;
				}
                   
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
		                        "&f_order_by=" + request.getParameter("f_order_by") +
		                        "&order=" + sortOrd +
		                        "&f_search_within_search=" + search_within_search_for_result +
		                        "\">First</a>&nbsp;");          
					out.println("<a href=\"" + 
		                        "?f_keyword=" + common.URLEncode(keyword) + 
		                        "&f_search_from=" + table_to_search_from + 
		                        "&f_page_num=" + (int_page_num - 1) + 
		                        "&f_recset_count=" + recset_count + 
		                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
		                        "&f_order_by=" + request.getParameter("f_order_by") +
		                        "&order=" + sortOrd +
		                        "&f_search_within_search=" + search_within_search_for_result +
		                        "\">Previous</a>&nbsp;");
				}
          
				// write page numbers
				counter = 0;
				for(; i < rounded_num_pages + 1; i++){
					String highlight_number_str = "";

					if(int_page_num == i)
						highlight_number_str = "class='b-154 bold'>" + Integer.toString(i);
					else if(page_num == null && i == 1)
						highlight_number_str = "class='b-154 bold'>" + Integer.toString(i);
					else
						highlight_number_str = ">"+Integer.toString(i);
              
					out.println("<a href=\"" + 
		                        "?f_keyword=" + common.URLEncode(keyword) + 
                		        "&f_search_from=" + table_to_search_from + 
		                        "&f_page_num=" + i + 
		                        "&f_recset_count=" + recset_count + 
		                        "&f_sql_switch=" + request.getParameter("f_sql_switch") +
                		        "&f_order_by=" + request.getParameter("f_order_by") +
			                "&order=" + sortOrd +
                        		"&f_search_within_search=" + search_within_search_for_result +
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
		                          "&f_order_by=" + request.getParameter("f_order_by") +
		                          "&order=" + sortOrd +
		                          "&f_search_within_search=" + search_within_search_for_result +
		                          "\">Next</a>&nbsp;");
 					  out.println("<a href=\"" + 
		                          "?f_keyword=" + common.URLEncode(keyword) + 
		                          "&f_search_from=" + table_to_search_from + 
		                          "&f_page_num=" + rounded_num_pages + 
		                          "&f_recset_count=" + recset_count + 
		                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
		                          "&f_order_by=" + request.getParameter("f_order_by") +
		                          "&order=" + sortOrd +
		                          "&f_search_within_search=" + search_within_search_for_result +
		                          "\">Last</a>");                          
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
		                        "\">Next</a>&nbsp;");
					out.println("<a href=\"" + 
		                          "?f_keyword=" + common.URLEncode(keyword) + 
		                          "&f_search_from=" + table_to_search_from + 
		                          "&f_page_num=" + rounded_num_pages + 
		                          "&f_recset_count=" + recset_count + 
		                          "&f_sql_switch=" + request.getParameter("f_sql_switch") +
		                          "&f_sort_by=" + request.getParameter("f_sort_by") +
		                          "&f_search_within_search=" + search_within_search_for_result +
		                          "\">Last</a>");                       
				}
				%>
				       </div>            
				       </td>
				      </tr>
				      </tfoot>
				<%
			} 
			%>
			    </table>
			    </div>
			    </div>
			<%
		}else{
			out.println("<p >Your search did not return any result.<br>Please refine " +
                    "your search criteria.</p>");
		}
    
		
%>
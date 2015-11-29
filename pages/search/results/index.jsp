<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../public/common.jsp"%>
<!-- Display search results. This jsp has been injected with extracts from a bigger jsp - search_results.jsp, that originally showed search results database records depending on the search table variable. 
I split them up to make edits easier, but I have NOT changed the initial code. Where possible I have removed unneccesary code and unused variables. 
Depending on the  searchFrom parameter, index.jsp will include the appropriate jsp to display results.
I know there are better ways to do this. But this seemed like the most time efficient way to make the code more managable without changing too much. 
Brad Williams - as part of changes for visualizing internationalisation of Ausstage - April 2015
--> 
 
<!--Script to enable sorting columns   -->
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
  //BW!! document.form_searchSort_report.f_sort_by.value = "";
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
  //document.form_searchSort_report.f_sort_by.value = "";
  document.form_searchSort_report.order.value = 'DESC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  -->
</script>

<%
ausstage.Database  	  db_ausstage_for_result       = new ausstage.Database ();
  admin.Common            common                       = new admin.Common   ();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset                     = null;
  String resultPlaceholder;
  String ONE_RESULT = "result.";
  String PLURAL_RESULT = "results.";
  Search search;
  String formatted_date                  = "";
  String keyword                         = request.getParameter("f_keyword");
  String table_to_search_from            = request.getParameter("f_search_from");
  String page_num                        = request.getParameter("f_page_num");
  String recset_count                    = request.getParameter("f_recset_count");
  String search_within_search_for_result = request.getParameter("f_search_within_search");
  String inc_resources			 = request.getParameter("inc_resources");
  String f_sql_switch			 = request.getParameter("f_sql_switch");
  String f_date_clause			 = request.getParameter("f_date_clause");
 // String f_sort_by			 = request.getParameter("f_sort_by");
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
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "100";
  
    
    ///////////////////////////////////
    //    DISPLAY SEARCH RESULTS
    //////////////////////////////////
    // set the search_within_search_for_result variable
  if(search_within_search_for_result == null){search_within_search_for_result ="";}
  if(m_inc_resource != null && m_inc_resource.equals("null")){m_inc_resource = null;}

  int counter;
  int start_trigger;
  int curr_row = 0;     

  //~~ CREATE NEW SEARCH OBJECT
  search = new Search(db_ausstage_for_result);
   
  //~~ SET THE SEARCH OBJECT KEYWORD 
  // Make sure that a keyword has been entered. The user may have javascript disabled. 
  if (keyword == null || keyword.equals("null") || keyword.equals("")) {
	search.setKeyWord("xxxxNoDataEnteredxx"); // Dummy string so that an error is not generated by the database 
  } 
  //~~ ELSE TRIM THE KEYWORD
  else {
      search.setKeyWord(keyword.trim());
  }
  //~~ SET SEARCH OBJECT SWITCH IF ENTERED
  if(request.getParameter("f_sql_switch") != null){
      search.setSqlSwitch(request.getParameter("f_sql_switch").toString());
  }
  //~~ SET TABLE TO SEARCH FROM IN SEARCH OBJECT
  if(table_to_search_from != null){
      search.setSearchFor(table_to_search_from);
  }

  //~~	SET ORDER BY CLAUSE
  System.out.println(" ");
  System.out.println("Sort By: "+orderBy);
  System.out.println(" ");
  if(orderBy != null){
  	if (orderBy.equals("venue_name")){
  		search.setOrderBy ("venue_name "+sortOrd+ ", suburb " + sortOrd +" ," + (state.equals("state")?"state":"venue_state") + " " +sortOrd);
  	}
  	//BW
  	else if (orderBy.equals("street")){
  		search.setOrderBy ("CASE WHEN venue_country like 'Australia%' THEN 1 ELSE 2 END, venue_country, venue_state "+sortOrd +",  suburb");	
  	}
  	//BW
  	else if (orderBy.equals("organisation_address")){
  		search.setOrderBy ("org_country "+sortOrd+", org_state "+ sortOrd + ", suburb "+ sortOrd);	
  	}else {
  		System.out.println("###################");
  		System.out.println(orderBy+" "+sortOrd);
  		System.out.println("END");
  		search.setOrderBy(orderBy+" "+sortOrd);
  	}
  }
  
  //~~ SET SEARCH OBJECTS SORT BY CLAUSE  
  //if(request.getParameter("f_sort_by") != null){
  //    search.setSortBy(request.getParameter("f_sort_by").toString());
  //}
  if(orderBy != null){
      search.setSortBy(orderBy);
  } 
   
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
  String unformattedDate = request.getParameter("f_year");
  //include appropriate results page.
  if(table_to_search_from.equals("all") || table_to_search_from.equals("event") ){
	%>
  	<%@ include file="search_result_event_all.jsp"%>
	<%
  }else if (table_to_search_from.equals("work")){
	%>
  	<%@ include file="search_result_work.jsp"%>
	<%
  }else if (table_to_search_from.equals("venue")){
	%>
  	<%@ include file="search_result_venue.jsp"%>
	<%
  }else if (table_to_search_from.equals("contributor")){
	%>
  	<%@ include file="search_result_contributor.jsp"%>
	<%
  }else if (table_to_search_from.equals("organisation")){
	%>
  	<%@ include file="search_result_organisation.jsp"%>
	<%
  }else if (table_to_search_from.equals("resource")){
  	%>
  	<%@ include file="search_result_resource.jsp"%>
	<%
  }else if (table_to_search_from.equals("international")){
  	%>
  	<%@ include file="search_result_international.jsp"%>
	<%
  }
  
  
%>

<!---->


<cms:include property="template" element="foot" />
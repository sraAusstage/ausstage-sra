<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.util.StringTokenizer,java.util.Calendar, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<%@ page import = "ausstage.Event, ausstage.State, ausstage.Search, ausstage.Contributor, admin.Common"%>
<%@ page import = "ausstage.AusstageCommon, ausstage.AdvancedSearch"%>

<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<jsp:useBean id="ausstage_db_for_result" class="ausstage.Database" scope="application">
<%ausstage_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean>
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

public String formatDate(String day, String month, String year)
{
  if (year == null || year.equals("") ){
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
  //System.out.println(result + " " + day + month + year);

  return result.replaceAll(" ", "&nbsp;");
}
%>

<%
  ausstage.Database db_ausstage_for_result          = new ausstage.Database ();
  Common         common                          = new Common();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet   crset                           = null;
  String         event_id                        = request.getParameter("f_event_id");
  String         event_name                      = request.getParameter("f_event_name");
  String         betweenfrom_dd                  = request.getParameter("f_betweenfrom_dd");
  String         betweenfrom_mm                  = request.getParameter("f_betweenfrom_mm");
  String         betweenfrom_yyyy                = request.getParameter("f_betweenfrom_yyyy");
  String         betweento_dd                    = request.getParameter("f_betweento_dd");
  String         betweento_mm                    = request.getParameter("f_betweento_mm");
  String         betweento_yyyy                  = request.getParameter("f_betweento_yyyy");
  String         venue_id                        = request.getParameter("f_venue_id");
  String         venue_name                      = request.getParameter("f_venue_name");
  String         state                           = request.getParameter("f_states");
  String         umbrella                        = request.getParameter("f_umbrella");
  String         status                          = request.getParameter("f_status");
  String         primary_genre                   = request.getParameter("f_primary_genre");
  String []      secondary_genre                 = (String [])request.getParameterValues("f_secondary_genre");
  String         prim_cont_indi                  = request.getParameter("f_prim_cont_indi");
  String         origin_of_text                  = request.getParameter("f_origin_of_text");
  String         origin_of_production            = request.getParameter("f_origin_of_production");
  String         organisation_id                 = request.getParameter("f_organisation_id");
  String         organisation_name               = request.getParameter("f_organisation_name");
  String         organisation_function           = request.getParameter("f_organisation_function");
  String         contributor_id                  = request.getParameter("f_contributor_id");
  String         contributor_name                = request.getParameter("f_contributor_name");
  String         contributor_function            = request.getParameter("f_contributor_function");
  String         orderBy                         = request.getParameter("f_order_by");
  String         sortOrd                         = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
  String         assoc_item                      = request.getParameter("f_assoc_item");

  // resource attributes
  String resource_title                          = request.getParameter("f_resource_title");
  String resource_source                         = request.getParameter("f_resource_source");
  String resource_abstract                       = request.getParameter("f_resource_abstract");
  String [] resource_subTypes                    = (String [])request.getParameterValues("f_sub_types");

  String resource_contributor_creator            = request.getParameter("f_resource_contributor_creator");
  String resource_organisation_creator           = request.getParameter("f_resource_organisation_creator");

  String         table_to_search_from            = request.getParameter("f_search_from");
  String         formatted_date                  = "";
  String         page_num                        = request.getParameter("f_page_num");
  String         recset_count                    = request.getParameter("f_recset_count");
  System.out.println("recset_count :" + recset_count);
  String         recordCount                     = request.getParameter("f_recset_count");
  System.out.println("Record COunt:" + recordCount);
  String         search_within_search_for_result = request.getParameter("f_search_within_search");
  
  boolean        do_print                        = false;
  int            result_count                    = 0;
  SimpleDateFormat formatPattern                 = new SimpleDateFormat("dd/MM/yyyy");
  AdvancedSearch   advancedSearch                = new AdvancedSearch(db_ausstage_for_result);
  String           resultsPerPage                = request.getParameter("f_limit_by");
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "20";



  ///////////////////////////////////
  //    DISPLAY SEARCH RESULTS
  //////////////////////////////////

  int counter;
  int start_trigger;
  int curr_row = 0;
  //some of the dates could be null because javascript disable == true removes the element 
  //from the form.
  if(betweenfrom_dd == null){betweenfrom_dd = "";}
  if(betweenfrom_mm == null){betweenfrom_mm = "";}
  if(betweenfrom_yyyy == null){betweenfrom_yyyy = "";}
  if(betweento_dd == null){betweento_dd = "";}
  if(betweento_mm == null){betweento_mm = "";}
  if(betweento_yyyy == null){betweento_yyyy = "";}

  /******** call all the SET methods from AdvancedSearch.java **********/
  if(event_id != null && event_name != null && betweenfrom_dd != null && betweenfrom_mm !=null
    && betweenfrom_yyyy != null && betweento_dd != null && betweento_mm != null
    && betweento_yyyy != null && umbrella != null){
    
    advancedSearch.setEventInfo(event_id, event_name, betweenfrom_dd, betweenfrom_mm,
                                betweenfrom_yyyy, betweento_dd, betweento_mm,
                                betweento_yyyy, umbrella);
  }
  if(venue_id != null || venue_name != null || state != null){
      advancedSearch.setVenueInfo(venue_id, venue_name, state);
  }
  if(primary_genre != null || secondary_genre != null){
    advancedSearch.setGenreInfo(primary_genre, secondary_genre);
  }
  if(status  != null && !status.equals("")){     
    System.out.println("status" + status + "%");
    advancedSearch.setStatus(status);
  }
  if(prim_cont_indi  != null){                   
    advancedSearch.setContentInfo(prim_cont_indi);
  }
  if(assoc_item != null){
    advancedSearch.setAssociatedItems(assoc_item);
  }
  
  if(origin_of_text != null || origin_of_production != null ){
    advancedSearch.setOriginsInfo(origin_of_text, origin_of_production);
  }
  if(organisation_id != null || organisation_name != null || organisation_function != null){
    advancedSearch.setOrganisationInfo(organisation_id, organisation_name, organisation_function);
  }
  if(contributor_id != null || contributor_name != null || contributor_function != null){
    advancedSearch.setContributorInfo(contributor_id, contributor_name, contributor_function);
  }

  if(orderBy != null){
      advancedSearch.setOrderBy((orderBy.equals("venue_name")?"venue_name "+sortOrd+ ", street " + sortOrd + ", suburb " + sortOrd + ", state":orderBy) + " " + sortOrd);
    }
    System.out.println(orderBy);
    System.out.println(sortOrd);

  // If the user has performed a search
  if (resource_title != null){

    // set null values for diabled fields to ""
    advancedSearch.setResourceInfo(resource_title, resource_source, resource_abstract, 
                                  resource_contributor_creator, resource_organisation_creator, resource_subTypes, 
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null);
  }
  advancedSearch.buildFromAndLinksSqlString();
  crset = advancedSearch.getResult();
 /*********Event******************************************************
  the result will always display event information for advanced search
 *********************************************************************/
  //if(table_to_be_displayed.equals("Event")){   
  if(crset != null && crset.next()){
    // get the number of rows returned (1st time only)
    if(page_num == null){
      page_num ="1";
      crset.last(); 
      recset_count = Integer.toString(crset.getRow());
      crset.first();         
    }    
  
    out.println("     <table width=\"100%\"  cellpadding=\"3\" cellspacing=\"0\" border=\"0\">");
    
    
    // DISPLAY NUMBER OF RESULTS
    out.println("      <tr>");
    out.println("       <td colspan=\"7\" >");
    out.println("       Search Results: Showing " + ((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " - " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " events. Click an event to see its records.");

    
    out.println("       </td>");
    out.println("      </tr>");
    out.println("      <tr>");
    out.println("       <td colspan=\"7\">&nbsp;</td>");
    out.println("      </tr>");
    
    // DISPLAY HEADERS AND TITLES
%>    
  
    <form name="form_searchSort_report" method="POST" action="?">

    <input type="hidden" name="f_order_by" value="<%=orderBy%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="f_event_id" value="<%=event_id%>">
    <input type="hidden" name="f_event_name" value="<%=event_name%>">
    <input type="hidden" name="f_betweenfrom_dd" value="<%=betweenfrom_dd%>">
    <input type="hidden" name="f_betweenfrom_mm" value="<%=betweenfrom_mm%>">
    <input type="hidden" name="f_betweenfrom_yyyy" value="<%=betweenfrom_yyyy%>">
    <input type="hidden" name="f_betweento_dd" value="<%=betweento_dd%>">
    <input type="hidden" name="f_betweento_mm" value="<%=betweento_mm%>">
    <input type="hidden" name="f_betweento_yyyy" value="<%=betweento_yyyy%>">
    <input type="hidden" name="f_venue_id" value="<%=venue_id%>">
    <input type="hidden" name="f_venue_name" value="<%=venue_name%>">
    <input type="hidden" name="f_states" value="<%=state%>">
    <input type="hidden" name="f_umbrella" value="<%=umbrella%>">
    <input type="hidden" name="f_primary_genre" value="<%=primary_genre%>">
    <input type="hidden" name="f_status" value="<%=status%>">
    <input type="hidden" name="f_prim_cont_indi" value="<%=prim_cont_indi%>">
    <input type="hidden" name="f_origin_of_text" value="<%=origin_of_text%>">
    <input type="hidden" name="f_origin_of_production" value="<%=origin_of_production%>">
    <input type="hidden" name="f_organisation_id" value="<%=organisation_id%>">
    <input type="hidden" name="f_organisation_name" value="<%=organisation_name%>">
    <input type="hidden" name="f_organisation_function" value="<%=organisation_function%>">
    <input type="hidden" name="f_contributor_id" value="<%=contributor_id%>">
    <input type="hidden" name="f_contributor_name" value="<%=contributor_name%>">
    <input type="hidden" name="f_contributor_function" value="<%=contributor_function%>">
    <input type="hidden" name="f_assoc_item" value="<%=assoc_item%>">
	<input type="hidden" name="f_limit_by" value="<%=resultsPerPage%>">

    </form>    
    
    <tr width="100%" id="bar" class="b-186" >
      <td width="35%"><b><a href="#" onClick="reSortData('event_name')">Event Name</a></b></td>
      <td width="35%" align="left"><b><a href="#" onClick="reSortData ('venue_name')">Venue</a></b></td>
      <td width="15%" align="right"><b><a href="#" onClick="reSortNumbers('first_date')">First Date</a></b></td>
      <td width="15%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Resources</a></b></td>
      
    </tr>
    <tr><td></td></tr>
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
          bgcolour = "class=\"b-195\"";
        else
          bgcolour = "class=\"b-172\"";
      
        out.println("      <tr>");
        out.println("       <td " + bgcolour +  " valign=\"top\" ><a href=\"/pages/event/?id=" + crset.getString("eventid") + "\" onmouseover=\"this.style.cursor='hand';\">" + crset.getString("event_name") + "</a></td>");
        out.println("       <td " + bgcolour +  " valign=\"top\" >" + crset.getString("venue_name") + ", ");         
      
        if(crset.getString("suburb") != null){
          out.println(crset.getString("suburb") + ", ");
        }
        out.println(crset.getString("state") + "</td>");
        out.println("       <td " + bgcolour +  " valign=\"top\" align='right' >");

        formatted_date = "";
        Event eventObj = new Event(db_ausstage_for_result);            
        CachedRowSet event_crset = eventObj.getEventsById(crset.getString("eventid")); 
        event_crset.next();
        
        out.println(formatDate(event_crset.getString("DDFIRST_DATE"), event_crset.getString("MMFIRST_DATE"),event_crset.getString("YYYYFIRST_DATE") ));
        out.println(      "</td>");
        
        if(crset.getString("total").equals("0"))
        {
        	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" );   
        }else{
        	out.println("       <td " + bgcolour +  " align=\"right\" valign=\"top\" >" + crset.getString("total"));   
        }
        
      
        /*
        
        if (crset.getString("ASSOC_ITEM")== null) {
          out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
        }
        else if (crset.getString("ASSOC_ITEM").equals("ONLINE")) {
          out.println("       <td " + bgcolour +  " width=\"1\"><img src='/resources/images/resourceicongreen.gif' alt='Related Online Resource'></td>"); // For Resource Image
        }
        else if (crset.getString("ASSOC_ITEM").equals("Y")) {
          out.println("       <td " + bgcolour +  " width=\"1\"><img src='/resources/images/resourceicongrey.gif' alt='Related Resource'></td>"); // For Resource Image
        }else {
          out.println("       <td " + bgcolour +  " width=\"1\">&nbsp;</td>"); // For no online Resource Image
        }*/
        out.println(      "</tr>");
        counter++;                    
        if(counter == Integer.parseInt(resultsPerPage))
          break;
      }      
      start_trigger++;      
    }
    while(crset.next());
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
      
      

      String url = "/pages/search/event/results" +  
                    "?f_event_id=" + common.URLEncode(event_id) + 
                    "&f_event_name=" + common.URLEncode(event_name) + 
                    "&f_betweenfrom_dd=" + betweenfrom_dd +
                    "&f_betweenfrom_mm=" + betweenfrom_mm +
                    "&f_betweenfrom_yyyy=" + betweenfrom_yyyy +
                    "&f_betweento_dd=" + betweento_dd +
                    "&f_betweento_mm=" + betweento_mm +
                    "&f_betweento_yyyy=" + betweento_yyyy +
                    "&f_venue_id=" + venue_id +
                    "&f_venue_name=" + common.URLEncode(venue_name) +
                    "&f_states=" + state +
                    "&f_umbrella=" + common.URLEncode(umbrella) +
                    "&f_primary_genre=" + common.URLEncode(primary_genre) + 
                    "&f_status=" + common.URLEncode(status) + 
                    "&f_prim_cont_indi=" + common.URLEncode(prim_cont_indi) +                         
                    "&f_origin_of_text=" + common.URLEncode(origin_of_text) +
                    "&f_origin_of_production=" + origin_of_production +
                    "&f_organisation_id=" + organisation_id + 
                    "&f_organisation_name=" + common.URLEncode(organisation_name) + 
                    "&f_organisation_function=" + common.URLEncode(organisation_function) + 
                    "&f_contributor_id=" + contributor_id + 
                    "&f_contributor_name=" + common.URLEncode(contributor_name) +  
                    "&f_contributor_function=" + common.URLEncode(contributor_function) +
                    "&f_assoc_item=" + common.URLEncode(assoc_item) +
                    "&f_order_by=" + orderBy +
                    "&order=" + sortOrd +
                    "&f_limit_by=" + resultsPerPage;
                    
                    if (secondary_genre != null && secondary_genre.length > 0 ){
                        for (int j = 0; j < secondary_genre.length; j++){
                          url += "&f_secondary_genre=" + secondary_genre[j];
                        }
                     }
                    
      // write Previous
      if(int_page_num > 1){
        out.println("<a href=\"" + url +
     		     "&f_page_num=1" + 
                    "&f_recset_count=" + recset_count + 
                    "\">First </a>&nbsp;");

        out.println("<a href=\"" + url +
                    "&f_page_num=" + (int_page_num - 1) + 
                    "&f_recset_count=" + recset_count + 
                    "\">Previous  </a>&nbsp;");
      }

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
        
        out.println("<a href=\"" + url +        
                    "&f_recset_count=" + recset_count + 
                    "&f_page_num=" + i + 
                    "\">" + highlight_number_str + "</a>&nbsp;");
        counter++;
        if(counter == 10)
          break;
      }

      // write Next
      if(page_num != null){
        if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
          out.println("<a href=\"" + url + "&f_recset_count=" + recset_count + "&f_page_num=" + (int_page_num + 1) + "\">Next</a>&nbsp;");
          out.println("<a href=\"" + url + "&f_recset_count=" + recset_count + "&f_page_num=" + rounded_num_pages + "\">Last</a>");
        }
      }else{
        out.println("<a href=\"" + url + "&f_page_num=" + (int_page_num + 2) + "&f_recset_count=" + recset_count + "\">Next</a>&nbsp;"); 
        out.println("<a href=\"" + url + "&f_recset_count=" + recset_count + "&f_page_num=" + rounded_num_pages + "\">Last</a>");
      }          
      out.println("       </td>");
      out.println("      </tr>");
    }             
    out.println("     </table>"); 
  }//end first if
  else{
    out.println("<p >Your search did not return any result.<br>Please refine " +
                "your search criteria.</p>");
  }
%>
<br><br>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%@ include file="../../../../public/common.jsp"%>
<body topmargin="0" leftmargin="0" bgproperties="fixed" bgcolor="#333333">

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<%@ page import = "ausstage.Search, ausstage.State"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "ausstage.LookupCode"%>
<%admin.AppConstants ausstage_search_appconstants_for_collection_result = new admin.AppConstants(request);%>
<!--Script to enable sorting columns  -->
<script language="JavaScript" type="text/JavaScript">
  <!--
  /**
  * Make modifications to the sort column and sort order.
  */
  function reSortData( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.f_sort_by.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value == 'ASC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.f_sort_by.value = sortColumn;
  document.form_searchSort_report.order.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }

  function reSortNumbers( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.f_sort_by.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value != 'DESC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.f_sort_by.value = sortColumn;
  document.form_searchSort_report.order.value = 'DESC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  -->
</script>
<%
  ausstage.Database          db_ausstage_for_collection_result       = new ausstage.Database ();
  admin.Common            common                                  = new admin.Common   ();
  
  db_ausstage_for_collection_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);


  String resultPlaceholder;
  String ONE_RESULT = "result.";
  String PLURAL_RESULT = "results.";
  
  CachedRowSet crsetResult    = null;
  Search search;
  String formatted_date       = "";
  String keyword              = request.getParameter("f_keywords");
  String page_num             = request.getParameter("f_page_num");
  String recset_count         = request.getParameter("f_recset_count");
   
  if(keyword == null)
      keyword="";
 
  String         sub_types []                = (String [])request.getParameterValues("f_sub_types");  
  if(sub_types == null)
	  sub_types= new String[0];

  String         firstdate_dd                = request.getParameter("f_firstdate_dd");
  String         firstdate_mm                = request.getParameter("f_firstdate_mm");
  String         firstdate_yyyy              = request.getParameter("f_firstdate_yyyy");
  String         collectingInstitution       = request.getParameter("f_collectingInstitution");
  if(collectingInstitution == null)
    collectingInstitution="";
   
  String creator                        = request.getParameter("f_creator");
  if(creator == null)
    creator="";
  String title                       = request.getParameter("f_title");
  if(title == null)
    title="";
  String source                 = request.getParameter("f_source");
  if(source == null)
    source="";    
        
  String         work                        = request.getParameter("f_work");
  if(work == null)
    work="";
  String         event                       = request.getParameter("f_event");
  if(event == null)
    event="";
  String         contributor                 = request.getParameter("f_contributor");
  if(contributor == null)
    contributor="";
  String         venue                       = request.getParameter("f_venue");
  if(venue == null)
    venue="";
  String assoc_item                          = request.getParameter("f_assoc_item");       
  if(assoc_item == null)
    assoc_item="";
    
  String         l_organisation              = request.getParameter("f_organisation");
  if(l_organisation == null)
    l_organisation="";
  String         l_boolean                   = request.getParameter("f_boolean");
  if(l_boolean == null)
    l_boolean="";
  String         sort_by                     = request.getParameter("f_sort_by");
  if(sort_by == null)
    sort_by="";
  String         sortOrd                         = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
     
  int l_int_page_num =0;
  
  State state                    = new State(db_ausstage_for_collection_result);
  SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
  
  String [] subTypes             = sub_types;
  //String [] secGenreArray = secondary_genre;
  
  boolean do_print               = false;
  String	resultsPerPage         = request.getParameter("f_limit_by");;
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "100";

    ///////////////////////////////////
    //    DISPLAY SEARCH RESULTS
    //////////////////////////////////
    int counter;
    int start_trigger;
    int curr_row = 0;      
    // never going to be a collection search from this page
    search = new Search(db_ausstage_for_collection_result);

    search.setKeyWord(keyword.trim());
    
    search.setSqlSwitch("and");
    
    String sortSql = "";
    if (!sort_by.equals("customsort")) {
    	sortSql = sort_by +" "+sortOrd+",(select last_name from contributor left join itemconlink on (contributor.contributorid = itemconlink.contributorid) where itemconlink.itemid = search_resource.itemid order by itemconlink.creator_flag desc limit 1) asc, " + 
		"title asc, citation_date desc";
    } else {
    	if (sortOrd.equals("ASC")) {
    		sortSql = "(select last_name from contributor left join itemconlink on (contributor.contributorid = itemconlink.contributorid) where itemconlink.itemid = search_resource.itemid order by itemconlink.creator_flag desc limit 1) asc, " + 
    		"title asc, citation_date desc";
    	} else {
    		sortSql = "(select last_name from contributor left join itemconlink on (contributor.contributorid = itemconlink.contributorid) where itemconlink.itemid = search_resource.itemid order by itemconlink.creator_flag desc limit 1) desc, " + 
    		"title desc, citation_date asc";
    	}
    }
    search.setOrderBy(sortSql);
      
    search.setFirstDate(firstdate_yyyy,firstdate_mm,firstdate_dd);

    search.setSubTypes(sub_types);
    
    search.setTitle(title);
    search.setSource(source);
    search.setCreator(creator);
    
    search.setContributor(contributor);
    search.setCollectionInstitution(collectingInstitution);
    search.setWork(work);
    search.setEvent(event);
    search.setVenue(venue);
    search.setResourceVisible(assoc_item);
    search.setBoolean(l_boolean);
    search.setOrganisation(l_organisation);

    if(page_num != null){

      if(Integer.parseInt(page_num) > 1)
        curr_row = Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage);
    }else{
      recset_count = search.getRecordCount();
    }

    crsetResult = search.getResources();
      
    if(crsetResult != null && crsetResult.next()){
      // get the number of rows returned (1st time only)
      if(page_num == null){
      page_num="1";
        crsetResult.last(); 
        recset_count = Integer.toString(crsetResult.getRow());
        crsetResult.first();         
      }	
      
      if(recset_count.equals("1")){resultPlaceholder = ONE_RESULT;}
      else resultPlaceholder = PLURAL_RESULT;
      
      out.print("<div class=\"search\"><div class=\"search-bar b-153\">"
    		 +"<img src=\"../../../../resources/images/icon-resource.png\" class=\"search-icon\">"
    		 +"<span class=\"search-heading large\">Resources</span>"
    		 +"<span class=\"search-index search-index-resource\">search results " + (keyword.equals("")?"":"for \'"+keyword+"\'. ")
    		 +((Integer.parseInt(page_num) -1)* Integer.parseInt(resultsPerPage)+ 1)+ " to " + (((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage)) > Integer.parseInt(recset_count)?recset_count:((Integer.parseInt(page_num)-1)*Integer.parseInt(resultsPerPage)+ Integer.parseInt(resultsPerPage))) + " of " + recset_count + " "+resultPlaceholder
    		 +"</span></div>");
      out.println("     <table class=\"search-table\">");
      %>
    <form name="form_searchSort_report" method="POST" action="?">

	<!--<input type="hidden" name="f_order_by" value="">-->
	<input type="hidden" name="order" value="<%=sortOrd%>">
	<input type="hidden" name="f_keywords" value="<%=keyword%>">
	<input type="hidden" name="f_firstdate_dd" value="<%=firstdate_dd%>">
	<input type="hidden" name="f_firstdate_mm" value="<%=firstdate_mm%>">
	<input type="hidden" name="f_firstdate_yyyy" value="<%=firstdate_yyyy%>">
	<input type="hidden" name="f_collectingInstitution" value="<%=collectingInstitution%>">
	<input type="hidden" name="f_creator" value="<%=creator%>">
	<input type="hidden" name="f_title" value="<%=title%>">
	<input type="hidden" name="f_source" value="<%=source%>">
	<input type="hidden" name="f_work" value="<%=work%>">
	<input type="hidden" name="f_event" value="<%=event%>">
	<input type="hidden" name="f_contributor" value="<%=contributor%>">
	<input type="hidden" name="f_venue" value="<%=venue%>">
	<input type="hidden" name="f_assoc_item" value="<%=assoc_item%>">
	<input type="hidden" name="f_organisation" value="<%=l_organisation%>">
	<input type="hidden" name="f_boolean" value="<%=l_boolean%>">
	<input type="hidden" name="f_sort_by" value="<%=sort_by%>">
	<input type="hidden" name="f_limit_by" value="<%=resultsPerPage%>">
	<%
	if (subTypes != null && subTypes.length >0){
		for(int i = 0; i < subTypes.length; i++){
			out.println("<input type=\"hidden\" name=\"f_sub_types\" value=\""+subTypes[i]+"\">");
		}
	}
	%>
	
      <%

      // DISPLAY NUMBER OF RESULTS
	out.println("<thead>");
    	out.println("	<tr>");
    	out.println("		<th width=\"\"><a href=\"#\" onClick=\"reSortData ('item_sub_type')\">Type</a></th>");
      	out.println("		<th width=\"\"><a href=\"#\" onClick=\"reSortData ('customsort')\">Citation</a></th> "); 
      	out.println("	</tr>	");	
    	out.println("</thead>");

      counter       = 0;
      start_trigger = 0;
      do_print = false;


      do{
          
        if(page_num == null){
          do_print = true;
        }else if(page_num.equals("1")){
          do_print = true;
        }else{
          if((Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage)- Integer.parseInt(resultsPerPage)) == start_trigger)
            do_print = true;
        }
        
        if(do_print){

          String bgcolour = "";

          if ((counter%2) == 0 ) // is it odd or even number???
            bgcolour = "class=\"b-184\"";    
          else
            bgcolour = "class=\"b-185\""; 
        
          out.println("      <tr>"); 
          out.println("       <td " + bgcolour +  " valign=\"top\" >" + crsetResult.getString("item_sub_type") + "</td>"); 
          out.println("       <td " + bgcolour +  " valign=\"top\" ><a href=\"/pages/resource/" + crsetResult.getString("itemid") + "\" >" + crsetResult.getString("citation") + "</a></td>");
          out.println("</tr>");
          counter++;                       
          if(counter == Integer.parseInt(resultsPerPage))
            break;
        }
          
        start_trigger++;
        
      }while(crsetResult.next());
        
       
      // PAGINATION DISPLAY //

      String unrounded_page_num = "";
      int rounded_num_pages     = 0;
      int remainder_num         = 0;
      int int_page_num          = 0;
      int i                     = 1;
          
        
      if(Integer.parseInt(recset_count) > Integer.parseInt(resultsPerPage)){

      
        out.println("      <tr>");
        out.println("       <td >&nbsp;</td>");
        out.println("      </tr>");
        out.println("      <tr width=\"100%\" class=\"search-bar b-153\" style=\"height:2.5em;\">");
        out.println("       <td colspan=2 align=\"right\" >");
        out.println("        <div class=\"search-index search-index-resource\">");    
       
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
      
        
        String pageURL = "/pages/search/resource/results/" + 
                      "?f_title=" + common.URLEncode(title) +
                      "&f_creator=" + common.URLEncode(creator) +
                      "&f_source=" + common.URLEncode(source) +
                      "&f_keywords=" + common.URLEncode(keyword) + 
                      "&f_recset_count=" + recset_count + 
                      "&f_sort_by=" + common.URLEncode(sort_by)+
                      "&f_firstdate_dd=" + firstdate_dd +
                      "&f_firstdate_mm=" + firstdate_mm +
                      "&f_firstdate_yyyy=" + firstdate_yyyy +
                      "&f_collectingInstitution=" + common.URLEncode(collectingInstitution) +
                      "&f_work=" + common.URLEncode(work) +
                      "&f_event=" + common.URLEncode(event) +
                      "&f_contributor=" + common.URLEncode(contributor) +
                      "&f_venue=" + common.URLEncode(venue) +
                      "&f_assoc_item=" + common.URLEncode(assoc_item) +
                      "&f_organisation=" + common.URLEncode(l_organisation) +
                      "&f_boolean=" + l_boolean+
                      "&f_limit_by=" + resultsPerPage;

                      if (subTypes != null && subTypes.length > 0 ){
                        for (int j = 0; j < subTypes.length; j++){
                          pageURL += "&f_sub_types=" + subTypes[j];
                        }
                      }
                      /*
                      if (secondary_genre != null && secondary_genre.length > 0 ){
                        for (int j = 0; j < secondary_genre.length; j++){
                          pageURL += "&f_secondary_genre=" + secondary_genre[j];
                        }
                      }*/                     
          
        // write Previous
        if(int_page_num > 1) {
          out.println("<a href=\"" +pageURL + "&f_page_num=1"  +"\">First</a>&nbsp;");
          out.println("<a href=\"" +pageURL + "&f_page_num=" + (int_page_num - 1) +"\">Previous</a>&nbsp;");
          
        }

        // write page numbers
        counter = 0;
      for(; i < rounded_num_pages + 1; i++){
        String highlight_number_str = "";

        if(int_page_num == i)
          highlight_number_str = " class='b-154 bold' >" + Integer.toString(i);
        else if(page_num == null && i == 1)
          highlight_number_str = " class='b-154 bold' >" + Integer.toString(i);
        else
          highlight_number_str = " >" +Integer.toString(i);
        
        out.println("<a href=\"" +pageURL + "&f_page_num=" + i + "\"" + highlight_number_str + "</a>&nbsp;");
        counter++;
        if(counter == 10)
          break;
        }
         // write Next
        if(page_num != null){
          if((int_page_num) < rounded_num_pages){// display Next only if its under the rounded_num_pages count
            out.println("<a href=\"" +pageURL + "&f_page_num=" + (int_page_num + 1) +"\">Next</a>&nbsp;");
            out.println("<a href=\"" +pageURL + "&f_page_num=" + rounded_num_pages +"\">Last</a>");
          }
        }else{
          out.println("<a href=\"" +pageURL + "&f_page_num=" + (int_page_num + 2) +"\">Next</a>&nbsp;");
          out.println("<a href=\"" +pageURL + "&f_page_num=" + rounded_num_pages +"\">Last</a>");
        }     
        out.println("       </div>");       
        out.println("       </td>");
        out.println("      </tr>");
      }                
      out.println("     </table></div>");     
    }else{    
      out.println("<p >Your search did not return any result.<br>Please refine " +
                  "your search criteria.</p>");
    }   
%>


<cms:include property="template" element="foot" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../../public/common.jsp"%>
<!--Script to enable sorting columns  -->
<script language="JavaScript" type="text/JavaScript">
  <!--
  /**
  * Make modifications to the sort column and sort order.
  */
  function reSortData( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.col.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value == 'ASC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.col.value = sortColumn;
  document.form_searchSort_report.order.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  function reSortNumbers( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.col.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value != 'DESC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.col.value = sortColumn;
  document.form_searchSort_report.order.value = 'DESC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  -->
</script>

<div class="search">

<%
  String keyword = request.getParameter("f_keyword");

  String pno=request.getParameter("pno"); // this will be coming from url
  int pageno=0;
  if(pno!=null)
  {
    pageno=Integer.parseInt(pno);
  }
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  int resultsPerPage = 25;
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  
  int next=pageno+1;
  int previous=pageno-1;
  String        sqlString;
  String	  sqlString1;
  String sortCol = request.getParameter("col");
   String validSql = "name year num total ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "name";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"SELECT COUNT(*) From `secgenreclass` WHERE genreclass like \"%"+keyword+"%\"";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
       
       
  out.print("<div class=\"search\"><div class=\"search-bar b-90\">"
    		 +"<img src=\"../../../../resources/images/icon-blank.png\" class=\"search-icon\">"
    		 +"<span class=\"search-heading large\">Genre</span>"
    		 +"<span class=\"search-index search-index-resource\">search results for \'"+keyword+"\'. "
    		 +((pageno)* resultsPerPage+ 1)+ " to " + (((pageno*resultsPerPage)+ resultsPerPage) > recordCount?recordCount:((pageno)*resultsPerPage+ resultsPerPage)) + " of " + recordCount + " result(s)."
    		 +"</span></div>");
  
%>

<table class="search-table">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <input type="hidden" name="f_keyword" value="<%=keyword%>">
    <thead>
    <tr>
      <th width="40%"><b><a href="#" onClick="reSortData('name')"> Name  (<%=l_rs.getString(1)%>)</a></b></th>
      <th width="20%" align="left"><b><a href="#" onClick="reSortNumbers('year')">Event Dates</a></b></th>
      <th width="20%" align="right"><b><a href="#" onClick="reSortNumbers('num')">Events</a></b></th>
      <th width="20%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Resources</a></b></th>
    </tr>
    </thead>
    <%
    sqlString = 	"SELECT secgenreclass.`genreclassid`, secgenreclass.genreclass name, min(events.yyyyfirst_date) year, max(events.yyyylast_date), "+
			"count(distinct events.eventid) num, secgenreclass.secgenrepreferredid, COUNT(distinct itemsecgenrelink.itemid) as total "+
			"FROM secgenreclass LEFT JOIN secgenreclasslink ON (secgenreclass.secgenrepreferredid = secgenreclasslink.secgenrepreferredid) "+
            		"LEFT JOIN events ON (secgenreclasslink.eventid = events.eventid) "+
			"Left Join itemsecgenrelink ON (secgenreclass.`secgenrepreferredid` = itemsecgenrelink.secgenrepreferredid) "+
			"WHERE secgenreclass.genreclass LIKE \"%"+keyword+"%\" "+
			"group by `secgenreclass`.`genreclassid` Order by " + sortCol + " " + sortOrd + " limit " + ((pageno)*25) + ",26";
    l_rs = m_db.runSQL (sqlString, stmt);
    int i = 0;
    while (l_rs.next())
    {
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
      %>
      <tr class="<%=evenOdd[evenOddValue]%>">
        <td width="40%"><a href="/pages/genre/?id=<%=l_rs.getString(6)%>"><%=l_rs.getString(2)%></a></td>
        <td width="20%" align="left"> <% if(l_rs.getString(5).equals("1") || l_rs.getString(3) != null && l_rs.getString(3).equals(l_rs.getString(4)) )
	{	    
	  if (l_rs.getString(3) != null) out.write(l_rs.getString(3)); 
    	}
    	else
    	{
          if (l_rs.getString(3) != null) out.write(l_rs.getString(3)); 
          if (l_rs.getString(3) != null && l_rs.getString(4) != null) out.write(" - ") ;
          if (l_rs.getString(4) != null) out.write(l_rs.getString(4));
        }%>
        </td>
	<td width="20%" align="right"><%if(l_rs.getString(5).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(5)); %>
	</td>
   	<td width="20%" align="right"><%if(l_rs.getString(7).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(7)); %>
   	</td>
      </tr>
      <%
  	i += 1;
  	if (i == 25) break;
    }
    if (recordCount > resultsPerPage){
    %>
    
    <tr  width="100%" class="browse-bar b-90" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class='browse-index browse-index-genre'>
        <%if (previous >= 0) 
        {
          out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&f_keyword="+keyword+"'>First</a> ");
   	  out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "&f_keyword="+keyword+"'>Previous </a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/25));
        if (max >= 1) {
	  if (start + 9 > max && max > 9) start = max-9;
	  for(int j=0;j<=9;j++) 
	  {       
	    if (j+start <= max) 
	    {
	      int k= j+start;      	 
	      String bold = ""+(k+1);
	      if (k == pageno) bold = "<b>" + (k+1) + "</b>";
	      out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"&f_keyword="+keyword+"'>"+bold+" </a>");
	    }
	  }
	  if (i == 25 && l_rs.next()) 
	  {
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" + next +"&f_keyword="+keyword+ "'>Next</a> ");
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/25 +"&f_keyword="+keyword+"'>Last</a> ");
	  }
        }
        %>  	
        </div> 
      </td>
    </tr>
    <%}%>
  </form>
</table>
<cms:include property="template" element="foot" />
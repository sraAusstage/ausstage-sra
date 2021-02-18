<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, admin.AppConstants, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../../public/common.jsp"%>
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
  String resultPlaceholder;
  String ONE_RESULT = "result.";
  String PLURAL_RESULT = "results.";
  String keyword=request.getParameter("f_keyword");
  String pno=request.getParameter("pno"); // this will be coming from url
  int pageno=0;
  if(pno!=null)
  {
    pageno =Integer.parseInt(pno);
  }
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  int resultsPerPage = 100;
  
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  int next=pageno+1;
  int previous=pageno-1;
  String        sqlString;
  String	  sqlString1;
  
  // TODO

  
  String sortCol = request.getParameter("col");
  if (sortCol == null) sortCol = "preferredterm";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;
  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"select count(*) from (SELECT COUNT(*) From `contributorfunctpreferred` "+
		"INNER JOIN contfunctlink ON (contributorfunctpreferred.contributorfunctpreferredid = contfunctlink.contributorfunctpreferredid) "+
		"WHERE lcase(`contributorfunctpreferred`.`preferredterm`) LIKE '%" + keyword + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid`) a ";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
  
  if(recordCount == 1){resultPlaceholder = ONE_RESULT;}
  else resultPlaceholder = PLURAL_RESULT;
  
  out.print("<div class=\"search\"><div class=\"search-bar b-105\">"
    		 +"<img src=\"../../../../resources/images/icon-blank.png\" class=\"search-icon\">"
    		 +"<span class=\"search-heading large\">Functions</span>"
    		 +"<span class=\"search-index search-index-resource\">Search results for \'"+keyword+"\'. "
    		 +((pageno)* resultsPerPage+ 1)+ " to " + (((pageno*resultsPerPage)+ resultsPerPage) > recordCount?recordCount:((pageno)*resultsPerPage+ resultsPerPage)) + " of " + recordCount + " "+resultPlaceholder
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
      <th width="20%"><b><a href="#" onClick="reSortData('preferredterm')">Name  (<%=l_rs.getString(1)%>)</a></b> </th>
      
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Contributors</a></b></th>
    </tr>
    </thead>
    <%
    sqlString = 	"SELECT contributorfunctpreferred.preferredterm,count(contfunctlink.contributorid) as total,`contributorfunctpreferred`.`contributorfunctpreferredid`  "+
			"FROM contfunctlink  "+
			"INNER JOIN contributorfunctpreferred ON (contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid)   "+
					"INNER JOIN contributor ON (contfunctlink.contributorid = contributor.contributorid)  "+
					"INNER JOIN (SELECT conel.contributorid, conel.function,  "+
								"min(e.yyyyfirst_date) as min_first_date, max(e.yyyylast_date) as max_last_date, max(e.yyyyfirst_date) as max_first_date  "+
								"FROM events e  "+
								"INNER JOIN conevlink conel on (e.eventid = conel.eventid)  "+
								"WHERE conel.contributorid is not null  "+
								"GROUP BY conel.contributorid, conel.function) event_dates   "+
					"on (contfunctlink.contributorid = event_dates.contributorid AND contfunctlink.contributorfunctpreferredid = event_dates.function)  "+
			"WHERE lcase(`contributorfunctpreferred`.preferredterm) LIKE '%" + keyword + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid` " +
  			"Order by " + sortCol + " " + sortOrd + " limit " + ((pageno)*25) + ",26"; 
   //sqlString = 	"SELECT contributorfunctpreferred.preferredterm,count(contfunctlink.contributorid) as total,`contributorfunctpreferred`.`contributorfunctpreferredid`  " +
//			"FROM contributorfunctpreferred "+
//			"INNER JOIN contfunctlink ON (contributorfunctpreferred.contributorfunctpreferredid = contfunctlink.contributorfunctpreferredid) "+
//			"WHERE lcase(`contributorfunctpreferred`.preferredterm) LIKE '%" + keyword + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid` " +
  //			"Order by " + sortCol + " " + sortOrd + " limit " + ((pageno)*25) + ",26";  
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
      <td width="20%"><a href="/pages/function/<%=l_rs.getString(3)%>"><%=l_rs.getString(1)%></a></td>
       
      <td width="15%" align="right"><%=l_rs.getString(2)%></td>  	 
    </tr>
  	
    <%
    
   
      i += 1;
      if (i == 25) break;
    }
    if (recordCount > resultsPerPage){
    %>
    <tr  width="100%" class="browse-bar b-105" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class="browse-index browse-index-function">
        <%if (previous >= 0) 
        {
          out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&f_keyword="+keyword+"'>First</a> ");
   	  out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "&f_keyword="+keyword+"'>Previous </a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/25));
        if (max >= 1) 
        {
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
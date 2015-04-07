<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.*, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../public/common.jsp"%>
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
    -->
</script>

<div class="browse">

<div class="browse-bar b-88">
   
    <span class="browse-heading large">International</span>

</div>
<%
  int resultsPerPage = 100;
  int recordCount;
  String pno=request.getParameter("pno"); // this will be coming from url
  int pageno=0;
  if(pno!=null)
  {
    pageno=Integer.parseInt(pno);
  }
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  
  int next=pageno+1;
  int previous=pageno-1;
  String        sqlString;
  String	  sqlString1;
  String sortCol = request.getParameter("col");
   String validSql = "countryname orgcount venuecount workcount dates ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "countryname";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
  
   

%>

<table class="cust-browse-table">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <thead>
    <tr>
      <th width="20%" align="left" class="browse-th-grey"><b><a href="#" onClick="reSortData('countryname')"> Country </a></b></th>
      <th width="20%" align="left" class="browse-th-grey"><b><a href="#" onClick="reSortData('dates')">Event Dates</a></b></th>
      <th width="20%" align="right" class="browse-th-organisation"><b><a href="#" onClick="reSortData('orgcount')">Organisations</a></b></th>
      <th width="20%" align="right" class="browse-th-venue"><b><a href="#" onClick="reSortData('venuecount')">Venues</a></b></th>
      <th width="20%" align="right" class="browse-th-work"><b><a href="#" onClick="reSortData('workcount')">Works</a></b></th>
    </tr>
    </thead>
    <%
    sqlString = "SELECT * from("+
    			"SELECT c.countryid, c.countryname as countryname, "+
    			"COALESCE(org.orgCount,0) AS orgcount, "+
    			"COALESCE(ven.venCount,0) AS venuecount, "+
    			"COALESCE(wor.workCount,0) AS workcount, "+
    			"concat_ws('-',dates.mindate, if(dates.maxdate = dates.mindate, null, dates.maxdate)) as dates "+
    			"FROM country AS c "+
			 " LEFT JOIN ( "+
            			"select count(distinct work.workid) as workCount, country.countryid AS countryid "+
            			"from events, country, playevlink, eventworklink, work "+
            			"where events.eventid = playevlink.eventid "+
            			"and playevlink.countryid = country.countryid "+
            			"and events.eventid = eventworklink.eventid "+
            			"and eventworklink.workid = work.workid "+
            			"group by country.countryid "+
        			" ) AS wor "+
        			" ON wor.countryId = c.countryid "+
    			" LEFT JOIN ( "+
            			"SELECT COUNT(*) AS orgCount, countryid AS countryId "+
            			"FROM organisation "+
           			"GROUP BY countryid "+
        			" ) AS org "+
        			" ON org.countryId = c.countryid "+
    			" LEFT JOIN ( "+
            			"SELECT COUNT(*) AS venCount, countryid AS countryId "+
           			"FROM venue "+
            			"GROUP BY countryid "+
        			") AS ven "+
        			" ON ven.countryId = c.countryid "+
        		" LEFT JOIN ( "+
            			"SELECT min(events.yyyyfirst_date) as mindate, max(events.yyyyfirst_date) as maxdate,"+
            			" playevlink.countryid AS countryId "+
            			"FROM playevlink, events "+
            			"WHERE playevlink.eventid = events.eventid "+
            			"GROUP BY countryid "+
        			") AS dates "+
        			"on dates.countryid = c.countryid "+
    			"group by c.countryid Order by " + sortCol + " " + sortOrd + ", countryname"+
    			") res WHERE countryname != 'Australia' AND(orgcount > 0 OR venuecount > 0 or workcount > 0 OR dates != '') "+
    			" limit " + ((pageno)*resultsPerPage) + ","+(resultsPerPage+1);
    l_rs = m_db.runSQL (sqlString, stmt);

    int i = 0;
    //get result count
    l_rs.last();
    recordCount = l_rs.getRow();
    l_rs.beforeFirst();
    while (l_rs.next())
    {
      if(!l_rs.getString("dates").equals("")&&!l_rs.getString("orgcount").equals("")&&!l_rs.getString("venuecount").equals("")){
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
      
      %>
      <tr class="<%=evenOdd[evenOddValue]%>">
        <td width="20%"><a href="/pages/international/index.jsp?id=<%=l_rs.getString("countryid")%>"><%=l_rs.getString("countryname")%></a></td>
        <td width="20%" align="left"><%=l_rs.getString("dates")%> </td>
	<td width="20%" align="right"><%if(l_rs.getString("orgcount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("orgcount")); %>
	</td>
   	<td width="20%" align="right"><%if(l_rs.getString("venuecount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("venuecount")); %>
   	</td>
   	<td width="20%" align="right"><%if(l_rs.getString("workcount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("workcount")); %>
   	</td>
      </tr>
      <%
  	i += 1;
  	}
  	if (i == resultsPerPage) break;
    }
    %>

    <tr  width="100%" class="browse-bar b-90" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class='browse-index browse-index-genre'>
        <%if (previous >= 0) 
        {
          out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
   	  out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous </a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/resultsPerPage));
        if (max >= 1) {
	  if (start + 9 > max && max > 9) start = max-9;
	  for(int j=0;j<=9;j++) 
	  {       
	    if (j+start <= max) 
	    {
	      int k= j+start;      	 
	      String bold = ">"+(k+1);
	      	  if (k == pageno) bold = "class='b-91 bold'>" + (k+1) + "";
	      	  out.println("<a href='?&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'"+bold+"</a>");
	    }
	  }
	  if (i == resultsPerPage && l_rs.next()) 
	  {
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/resultsPerPage+"'>Last</a> ");
	  }
        }
        %>  	
        </div> 
      </td>
    </tr>
  </form>
</table>
<cms:include property="template" element="foot" />
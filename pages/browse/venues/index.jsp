<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="_LANGUAGE" xml:lang="_LANGUAGE">
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../public/common.jsp"%>

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

<div class="browse">

<div class="browse-bar b-134">

    <img src="../../../resources/images/icon-venue.png" class="browse-icon">
    
    <span class="browse-heading large">Venues</span>
    
<%
  String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
    if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
%>

<!--<div class='letters'>-->
<div class='browse-index browse-index-venue'>
  <a href="?letter=A" <%=letter.equals("a")?"style='font-weight:bold'":""%>>A</a>
  <a href="?letter=B" <%=letter.equals("b")?"style='font-weight:bold'":""%>>B</a>
  <a href="?letter=C" <%=letter.equals("c")?"style='font-weight:bold'":""%>>C</a>
  <a href="?letter=D" <%=letter.equals("d")?"style='font-weight:bold'":""%>>D</a>
  <a href="?letter=E" <%=letter.equals("e")?"style='font-weight:bold'":""%>>E</a>
  <a href="?letter=F" <%=letter.equals("f")?"style='font-weight:bold'":""%>>F</a>
  <a href="?letter=G" <%=letter.equals("g")?"style='font-weight:bold'":""%>>G</a>
  <a href="?letter=H" <%=letter.equals("h")?"style='font-weight:bold'":""%>>H</a>
  <a href="?letter=I" <%=letter.equals("i")?"style='font-weight:bold'":""%>>I</a>
  <a href="?letter=J" <%=letter.equals("j")?"style='font-weight:bold'":""%>>J</a>
  <a href="?letter=K" <%=letter.equals("k")?"style='font-weight:bold'":""%>>K</a>
  <a href="?letter=L" <%=letter.equals("l")?"style='font-weight:bold'":""%>>L</a>
  <a href="?letter=M" <%=letter.equals("m")?"style='font-weight:bold'":""%>>M</a>
  <a href="?letter=N" <%=letter.equals("n")?"style='font-weight:bold'":""%>>N</a>
  <a href="?letter=O" <%=letter.equals("o")?"style='font-weight:bold'":""%>>O</a>
  <a href="?letter=P" <%=letter.equals("p")?"style='font-weight:bold'":""%>>P</a>
  <a href="?letter=Q" <%=letter.equals("q")?"style='font-weight:bold'":""%>>Q</a>
  <a href="?letter=R" <%=letter.equals("r")?"style='font-weight:bold'":""%>>R</a>
  <a href="?letter=S" <%=letter.equals("s")?"style='font-weight:bold'":""%>>S</a>
  <a href="?letter=T" <%=letter.equals("t")?"style='font-weight:bold'":""%>>T</a>
  <a href="?letter=U" <%=letter.equals("u")?"style='font-weight:bold'":""%>>U</a>
  <a href="?letter=V" <%=letter.equals("v")?"style='font-weight:bold'":""%>>V</a>
  <a href="?letter=W" <%=letter.equals("w")?"style='font-weight:bold'":""%>>W</a>
  <a href="?letter=X" <%=letter.equals("x")?"style='font-weight:bold'":""%>>X</a>
  <a href="?letter=Y" <%=letter.equals("y")?"style='font-weight:bold'":""%>>Y</a>
  <a href="?letter=Z" <%=letter.equals("z")?"style='font-weight:bold'":""%>>Z</a>
</div>
</div>
<%
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
  
  String sortCol = request.getParameter("col");
  String validSql = "name address year num total ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "name";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"SELECT COUNT(distinct venue.venueid) From `venue` WHERE TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(venue.venue_name)))) LIKE '" + letter + "%'";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
%>

<table class="browse-table">
  <form name="form_searchSort_report" method="POST" action=".">
    <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="letter" value="<%=letter%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <thead>
    <tr>
      <th width="25%"><b><a href="#" onClick="reSortData('name')">Name  (<%=recordCount%>)</a> </b></th>
      <th width="35%" align="left"><b><a href="#" onClick="reSortData('address')">Address</a><b></th>
      <th width="10%" align="left"><b><a href="#" onClick="reSortNumbers('year')">Event Dates</a><b></th>
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('num')">Events</a><b></th>
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Resources</a><b></th>
    </tr>
    </thead>
    <%
    
    sqlString = 	"SELECT venue.venueid,venue.venue_name name,min(events.yyyyfirst_date) year,max(events.yyyylast_date),count(distinct events.eventid) num,venue.longitude,venue.latitude, " +
			"concat_ws(', ',venue.street, venue.suburb, states.state, country.countryname) as address,count(distinct itemvenuelink.itemid) as total "+
			"FROM venue LEFT JOIN events ON (venue.venueid = events.venueid) " +
			"LEFT JOIN states ON (venue.state = states.stateid) "+
			"LEFT JOIN country ON (venue.countryid = country.countryid) "+
			"LEFT JOIN itemvenuelink ON (venue.venueid = itemvenuelink.venueid) "+
			"WHERE TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(venue.venue_name)))) LIKE '" + letter + "%' group by venue.venueid " +
  			"ORDER BY  " + ((sortCol.equals("name") || sortCol.indexOf("'") > -1)?"TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(venue.VENUE_NAME))))":sortCol) + " " + sortOrd + (sortCol.equals("year")?", ifnull(max(events.yyyylast_date),min(events.yyyyfirst_date)) " + sortOrd:"") + " limit " + ((pageno)*25) + ",26";
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
      <td width="25%"><a href="/pages/venue/?id=<%=l_rs.getString(1)%>"><%=l_rs.getString(2)%></a></td>
      <td width="35%"> <%=l_rs.getString(8)%></td>
      <td width="10%" align="left"> 
      <% 
        if(l_rs.getString(5).equals("1") || l_rs.getString(3) != null && l_rs.getString(3).equals(l_rs.getString(4)))
        {
          if (l_rs.getString(3) != null) out.write(l_rs.getString(3)); 
        }
        else
        {
          if(l_rs.getString(3) != null) out.write(l_rs.getString(3));
          if (l_rs.getString(3) != null && l_rs.getString(4) != null) out.write(" - ") ;
          if (l_rs.getString(4) != null) out.write(l_rs.getString(4));
        }
      %>
      </td>
      <td width="15%" align="right"><%if(l_rs.getString(5).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(5)); %>
      </td>
      <td width="15%" align="right"><%if(l_rs.getString(9).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(9)); %>
      </td>
    </tr>
    <%
      i += 1;
      if (i == 25) break;
    }
    %>
    <!--<tr>
      <td colspan="5" bgcolor="aaaaaa"></td>
    </tr>-->
    <tr  width="100%" class="browse-bar b-134" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class='browse-index browse-index-venue'>
          <%if (previous >= 0) 
          {
            out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
            out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous </a>  ");
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
	      	out.println("<a href='?letter=" + letter +"&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'>"+bold+" </a>");
	      }
	    }
	    if (i == 25 && l_rs.next()) 
	    {
	      out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	      out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/25 +"'>Last</a> ");
	    }
          }
          %>  	
        </div> 
      </td>
    </tr>
  </form>
</table>

<cms:include property="template" element="foot" />
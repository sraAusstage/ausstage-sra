<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="_LANGUAGE" xml:lang="_LANGUAGE">
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.*, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<!--Include the header from the OpenCMS template -->
<cms:include property="template" element="head" />
<%@ include file="../../../public/common.jsp"%>
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
<div class="browse">

<div class="browse-bar b-153">

    <img src="../../../resources/images/icon-work.png" class="browse-icon">
    
    <span class="browse-heading large">Works</span>

<%
  String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
    if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
  
     //added to account for numbers and non alphanumeric at the beginning of names
   String switchLike = "";
   if (letter.equals("0")) switchLike =  "REGEXP '^[[:digit:]]'";
   else if (letter.equals("*")) switchLike =  "REGEXP '^[^[:alnum:]]'";
   else switchLike = " LIKE '" + letter + "%' ";
%>

<div class='browse-index browse-index-work'>
 <a href="?letter=A" <%=letter.equals("a")?"class='b-154 bold'":""%>>A</a>
  <a href="?letter=B" <%=letter.equals("b")?"class='b-154 bold'":""%>>B</a>
  <a href="?letter=C" <%=letter.equals("c")?"class='b-154 bold'":""%>>C</a>
  <a href="?letter=D" <%=letter.equals("d")?"class='b-154 bold'":""%>>D</a>
  <a href="?letter=E" <%=letter.equals("e")?"class='b-154 bold'":""%>>E</a>
  <a href="?letter=F" <%=letter.equals("f")?"class='b-154 bold'":""%>>F</a>
  <a href="?letter=G" <%=letter.equals("g")?"class='b-154 bold'":""%>>G</a>
  <a href="?letter=H" <%=letter.equals("h")?"class='b-154 bold'":""%>>H</a>
  <a href="?letter=I" <%=letter.equals("i")?"class='b-154 bold'":""%>>I</a>
  <a href="?letter=J" <%=letter.equals("j")?"class='b-154 bold'":""%>>J</a>
  <a href="?letter=K" <%=letter.equals("k")?"class='b-154 bold'":""%>>K</a>
  <a href="?letter=L" <%=letter.equals("l")?"class='b-154 bold'":""%>>L</a>
  <a href="?letter=M" <%=letter.equals("m")?"class='b-154 bold'":""%>>M</a>
  <a href="?letter=N" <%=letter.equals("n")?"class='b-154 bold'":""%>>N</a>
  <a href="?letter=O" <%=letter.equals("o")?"class='b-154 bold'":""%>>O</a>
  <a href="?letter=P" <%=letter.equals("p")?"class='b-154 bold'":""%>>P</a>
  <a href="?letter=Q" <%=letter.equals("q")?"class='b-154 bold'":""%>>Q</a>
  <a href="?letter=R" <%=letter.equals("r")?"class='b-154 bold'":""%>>R</a>
  <a href="?letter=S" <%=letter.equals("s")?"class='b-154 bold'":""%>>S</a>
  <a href="?letter=T" <%=letter.equals("t")?"class='b-154 bold'":""%>>T</a>
  <a href="?letter=U" <%=letter.equals("u")?"class='b-154 bold'":""%>>U</a>
  <a href="?letter=V" <%=letter.equals("v")?"class='b-154 bold'":""%>>V</a>
  <a href="?letter=W" <%=letter.equals("w")?"class='b-154 bold'":""%>>W</a>
  <a href="?letter=X" <%=letter.equals("x")?"class='b-154 bold'":""%>>X</a>
  <a href="?letter=Y" <%=letter.equals("y")?"class='b-154 bold'":""%>>Y</a>
  <a href="?letter=Z" <%=letter.equals("z")?"class='b-154 bold'":""%>>Z</a>
  <a href="?letter=0" <%=letter.equals("0")?"class='b-154 bold'":""%>>0-9</a>
  <a href="?letter=*" <%=letter.equals("*")?"class='b-154 bold'":""%>>%</a>
</div>
</div>
<%
  int resultsPerPage = 100;
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
  String validSql = "titlesort contrib year num total ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "titlesort";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"SELECT COUNT(*) From `work` WHERE (TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(work.work_title))))) " + switchLike;
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
      <th width="40%"><b><a href="#" onClick="reSortData('titlesort')">Name (<%=SearchCount.formatSearchCountWithCommas(l_rs.getString(1))%>)</a></b></th>
      <th width="20%" align="left"><b><a href="#" onClick="reSortData('contrib')">Creators</a></b></th>
      <th width="10%" align="left"><b><a href="#" onClick="reSortNumbers('year')">Event Dates</a></b></th>    
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('num')"> Events</a></b></th>
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Resources</a></b></th>
    </tr>
    </thead>
    <%
      sqlString = 	"SELECT  work.work_title title,contributor.last_name n,contributor.first_name f,`organisation`.`name`,work.workid,min(events.yyyyfirst_date) year,if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))),count(distinct events.eventid) num,  count(distinct itemworklink.itemid) as total, " +
			"concat_ws(', ', GROUP_CONCAT(distinct if (CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME) = '', null, CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME)) SEPARATOR ', '), group_concat(distinct organisation.name separator ', ')) contrib,  "+
			"concat_ws(', ', GROUP_CONCAT(distinct if (CONCAT_WS(' ', CONTRIBUTOR.LAST_NAME ,CONTRIBUTOR.FIRST_NAME) = '', null, CONCAT_WS(' ', CONTRIBUTOR.LAST_NAME ,CONTRIBUTOR.FIRST_NAME)) SEPARATOR ', '), group_concat(distinct organisation.name separator ', ')) contribsort,  "+
			"TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(work.work_title)))) titlesort " +
			"FROM work  LEFT  JOIN eventworklink ON (work.workid = eventworklink.workid) LEFT  JOIN events ON (eventworklink.eventid = events.eventid)  LEFT  JOIN workconlink ON (work.workid = workconlink.workid) "+
			"LEFT  JOIN contributor ON (workconlink.contributorid = contributor.contributorid)  Left  Join `workorglink` ON (work.`workid`= `workorglink`.`workid`)"+
 			"Left  Join `organisation` ON (`workorglink`.`organisationid`= `organisation`.`organisationid`)" +
 			"Left join itemworklink On (work.workid = itemworklink.workid) "+
			"WHERE (TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(work.work_title))))) " + switchLike + " group by work.`workid`" +
  			"ORDER BY  " + (sortCol.equals("contrib")?"contribsort":sortCol) + " " + sortOrd + (sortCol.equals("year")?", ifnull(max(events.yyyylast_date),min(events.yyyyfirst_date)) " + sortOrd:"") + ", titlesort limit " + ((pageno)*resultsPerPage ) + ","+(resultsPerPage +1);
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
        <td width="40%"> 
    	  <a href="/pages/work/<%=l_rs.getString(5)%>"><%=l_rs.getString(1)%></a>
    	</td>
    	<td width="20%" align="left"><%=l_rs.getString("contrib")%></td>
    	<td width="10%" align="left"><% if(l_rs.getString(8).equals("1") ||l_rs.getString(6) != null && l_rs.getString(6).equals(l_rs.getString(7) ) ){
    	    					if (l_rs.getString(6) != null) out.write(l_rs.getString(6)); }
    	    					else{if (l_rs.getString(6) != null) out.write(l_rs.getString(6));
    	    				      if (l_rs.getString(6) != null && l_rs.getString(7) != null) out.write(" - ") ;
    	    				      if (l_rs.getString(7) != null) out.write(l_rs.getString(7));}%>
	</td>
   	<td width="15%" align="right"><%if(l_rs.getString(8).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(8)); %>
   	</td>
   	<td width="15%" align="right"><%if(l_rs.getString(9).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(9)); %>
   	</td>
      </tr>
      <div class='letters'>
      <%
  	i += 1;
  	if (i == resultsPerPage ) break;
      }
    %>
   
    <tr  width="100%" class="browse-bar b-153" style="height:2.5em;">
      <td align="right" colspan="5">
        <div class='browse-index browse-index-work'>
          <%
          if (previous >= 0) 
          {
            out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
   	    out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous </a>  ");
          }
          int start = pageno-4;
          if (start <= 0) start = 0;
          int max = (int)(Math.ceil((recordCount-1)/resultsPerPage ));
          if (max >= 1) {
	    if (start + 9 > max && max > 9) start = max-9;
	    for(int j=0;j<=9;j++) 
	    {       
	      if (j+start <= max) 
	      {
	        int k= j+start;      	 
	       String bold = ">"+(k+1);
	      	  if (k == pageno) bold = "class='b-154 bold'>" + (k+1) + "";
	      	  out.println("<a href='?letter=" + letter +"&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'"+bold+"</a>");
	      }
	    }
	    if (i == resultsPerPage && l_rs.next()) 
	    {
	      out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	      out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + (recordCount-1)/resultsPerPage +"'>Last</a> ");
	    }
          }
        %>  	
        </div> 
      </td>
    </tr>
  </form>
</table>
<cms:include property="template" element="foot" />
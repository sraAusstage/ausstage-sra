<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.*, admin.AppConstants, sun.jdbc.rowset.*" %>
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
  if ( document.form_searchSort_report.order.value != 'DESC' ) {
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

<div class="browse-bar b-90">

    <img src="../../../resources/images/icon-event.png" class="browse-icon">
    
    <span class="browse-heading large">Events</span>


<%
  String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
    if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
%>

<div class='browse-index browse-index-event'>
  <a href="?letter=A" <%=letter.equals("a")?"class='b-91 bold'":""%>>A</a>
  <a href="?letter=B" <%=letter.equals("b")?"class='b-91 bold'":""%>>B</a>
  <a href="?letter=C" <%=letter.equals("c")?"class='b-91 bold'":""%>>C</a>
  <a href="?letter=D" <%=letter.equals("d")?"class='b-91 bold'":""%>>D</a>
  <a href="?letter=E" <%=letter.equals("e")?"class='b-91 bold'":""%>>E</a>
  <a href="?letter=F" <%=letter.equals("f")?"class='b-91 bold'":""%>>F</a>
  <a href="?letter=G" <%=letter.equals("g")?"class='b-91 bold'":""%>>G</a>
  <a href="?letter=H" <%=letter.equals("h")?"class='b-91 bold'":""%>>H</a>
  <a href="?letter=I" <%=letter.equals("i")?"class='b-91 bold'":""%>>I</a>
  <a href="?letter=J" <%=letter.equals("j")?"class='b-91 bold'":""%>>J</a>
  <a href="?letter=K" <%=letter.equals("k")?"class='b-91 bold'":""%>>K</a>
  <a href="?letter=L" <%=letter.equals("l")?"class='b-91 bold'":""%>>L</a>
  <a href="?letter=M" <%=letter.equals("m")?"class='b-91 bold'":""%>>M</a>
  <a href="?letter=N" <%=letter.equals("n")?"class='b-91 bold'":""%>>N</a>
  <a href="?letter=O" <%=letter.equals("o")?"class='b-91 bold'":""%>>O</a>
  <a href="?letter=P" <%=letter.equals("p")?"class='b-91 bold'":""%>>P</a>
  <a href="?letter=Q" <%=letter.equals("q")?"class='b-91 bold'":""%>>Q</a>
  <a href="?letter=R" <%=letter.equals("r")?"class='b-91 bold'":""%>>R</a>
  <a href="?letter=S" <%=letter.equals("s")?"class='b-91 bold'":""%>>S</a>
  <a href="?letter=T" <%=letter.equals("t")?"class='b-91 bold'":""%>>T</a>
  <a href="?letter=U" <%=letter.equals("u")?"class='b-91 bold'":""%>>U</a>
  <a href="?letter=V" <%=letter.equals("v")?"class='b-91 bold'":""%>>V</a>
  <a href="?letter=W" <%=letter.equals("w")?"class='b-91 bold'":""%>>W</a>
  <a href="?letter=X" <%=letter.equals("x")?"class='b-91 bold'":""%>>X</a>
  <a href="?letter=Y" <%=letter.equals("y")?"class='b-91 bold'":""%>>Y</a>
  <a href="?letter=Z" <%=letter.equals("z")?"class='b-91 bold'":""%>>Z</a>
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
  String	  sqlString1;
  
  String sortCol = request.getParameter("col");
  String validSql = "name vname dat total ASC DESC street state suburb";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "name";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null || !validSql.contains(sortCol)) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();  
  CachedRowSet  l_rs     = null;
  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"SELECT COUNT(*) From `events` WHERE TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(events.EVENT_NAME)))) LIKE '" + letter + "%'";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
%>
<table class="browse-table">
  <form name="form_searchSort_report" method="POST" action="index.jsp">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="letter" value="<%=letter%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <thead>
    <tr>
      <th width="30%"><a href="#" onClick="reSortData('name')">Name (<%=SearchCount.formatSearchCountWithCommas(l_rs.getString(1))%>)</a></th>
      <th width="40%" align="left"><a href="#" onClick="reSortData('vname')">Venue</a></th>
      <th width="15%" align="right"><a href="#" onClick="reSortNumbers('dat')">First Date</a></th>
      <th width="15%" align="right"><a href="#" onClick="reSortNumbers('total')">Resources</a></th>
    </tr>
    </thead>
    <%
    
    sqlString = "SELECT events.`eventid`,events.event_name name,venue.suburb, states.state,venue.street, "+
      			"events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date,count(distinct events.eventid),venue.venue_name vname, " +
      			"CONCAT_ws('&nbsp;', TRIM(leading '0' from events.ddfirst_date), fn_get_month_as_string(events.mmfirst_date), events.yyyyfirst_date) as evDate,  "+
      			"STR_TO_DATE(CONCAT(IFNULL(events.ddfirst_date, '01'),' ',IFNULL(events.mmfirst_date,'01'),' ',IFNULL(events.yyyyfirst_date, '1800')), '%d %m %Y') as dat,count(distinct itemevlink.itemid) as total, country.countryname "+
			"FROM events INNER JOIN venue ON (events.venueid = venue.venueid)   INNER JOIN states ON (venue.state = states.stateid) Left JOIN itemevlink on (events.eventid = itemevlink.`eventid`) " +
			"INNER JOIN country ON (venue.countryid = country.countryid)"+
			"WHERE TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(events.EVENT_NAME)))) LIKE '" + letter + "%' group by events.eventid Order by " + ((sortCol.equals("name") || sortCol.indexOf("'") > -1)?"TRIM(leading 'a ' from TRIM(leading 'an ' from TRIM(leading 'the ' from LOWER(events.EVENT_NAME))))":(sortCol.equals("vname")?"vname " + sortOrd + ", suburb " + sortOrd + ", state":sortCol)) + " " + sortOrd + " limit " + ((pageno)*100) + ",101";
  			 
    l_rs = m_db.runSQL (sqlString, stmt);
    System.out.println(sqlString);
    int i = 0;  
    while (l_rs.next())
    {
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
    %>
    <!--
    1 events.`eventid`
    2 events.event_name name
    3,venue.suburb, 
    4 states.state,
    5 venue.street
    6 events.ddfirst_date
    7 events.mmfirst_date
    8 events.yyyyfirst_date
    9 ,count(distinct events.eventid)
    10,venue.venue_name vname,
    11 evDate
    12 dat,
    13 count(distinct itemevlink.itemid) as total,
    14  country.countryname 
    -->
    
    <tr class="<%=evenOdd[evenOddValue]%>">
      <td width="30%"><a href="/pages/event/<%=l_rs.getString(1)%>"><%=l_rs.getString(2)%></a></td>
      <td width="40%" align="left">  <% if (l_rs.getString(10) != null) out.write(l_rs.getString(10));
    	    					//if (l_rs.getString(10) != null && l_rs.getString(5) != null) out.write(", ") ;
    	    					
    	    					//if (l_rs.getString(5) != null && l_rs.getString(3) != null) out.write(", ") ;
    	    					if (l_rs.getString(3) != null) out.write(", " + l_rs.getString(3));  
    	    					//if (l_rs.getString(4) != null && l_rs.getString(3) != null) out.write(", ") ;
    	    					if ((l_rs.getString("state") != null)&&(!l_rs.getString("state").equals("O/S"))){
    	    					
    	    							out.write(", " + l_rs.getString("state"));
    	    					}
    	    					if ((l_rs.getString("countryname") != null)&&(l_rs.getString("state").equals("O/S"))) out.write(", " + l_rs.getString("countryname")); %>
      </td>
      <td width="15%" align="right"><%if(l_rs.getString(11) != null) out.write(l_rs.getString(11));%> 
      <td width="15%" align="right"><%if(l_rs.getString(13).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(13)); %>
    </tr>
    <div class='letters'>
    <%
      i += 1;
      if (i == 100) break;
    }
    %>
    <tr  width="100%" class="browse-bar b-90" style="height:2.5em;">
      <td align="right" colspan="5">
        <div class="browse-index browse-index-event">
          <%if (previous >= 0) 
            {
              out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"'>First</a>");
   	      out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous</a>");
            }
            int start = pageno-4;
            if (start <= 0) start = 0;
            int max = (int)(Math.ceil((recordCount-1)/100));
            if (max >= 1) 
            {
	      if (start + 19 > max && max > 19) start = max-19;
	      for(int j=0;j<=19;j++) 
	      {       
	        if (j+start <= max) 
	        {
	          int k= j+start;      	 
	      	  String bold = ">"+(k+1);
	      	  if (k == pageno) bold = "class='b-91 bold'>" + (k+1) + "";
	      	  out.println("<a href='?letter=" + letter +"&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'"+bold+"</a>");
	      	}
	      }
	      if (i == 100 && l_rs.next()) 
	      {
	        out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a>");
	   	out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/100 +"'>Last</a>");
	      }
            }
	  %>  	
	</div> 
      </td>
    </tr>
  </form>
</table>

</div>
<cms:include property="template" element="foot" />
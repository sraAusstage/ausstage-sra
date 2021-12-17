<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*, ausstage.*, sun.jdbc.rowset.*" %>

<jsp:include page="../../templates/header.jsp" /><%@ include file="../../public/common.jsp"%>

<!--<%@ page session="true" import="org.opencms.main.*,org.opencms.jsp.*,org.opencms.file.*,java.lang.String,java.util.*"%>
<%
admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%>
<%@ page import="ausstage.AusstageCommon"%>-->

<script language="JavaScript" type="text/JavaScript">
  <!--
  /**
  * Make modifications to the sort column and sort order.
  */
  function reSortDataOrg( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.orgCol.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.orgOrder.value == 'ASC' ) {
  document.form_searchSort_report.orgOrder.value = 'DESC';
  } else {
  document.form_searchSort_report.orgOrder.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.orgCol.value = sortColumn;
  document.form_searchSort_report.orgOrder.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  
  function reSortDataVen( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.venCol.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.venOrder.value == 'ASC' ) {
  document.form_searchSort_report.venOrder.value = 'DESC';
  } else {
  document.form_searchSort_report.venOrder.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.venCol.value = sortColumn;
  document.form_searchSort_report.venOrder.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  
  function reSortDataWor( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.worCol.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.worOrder.value == 'ASC' ) {
  document.form_searchSort_report.worOrder.value = 'DESC';
  } else {
  document.form_searchSort_report.worOrder.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.worCol.value = sortColumn;
  document.form_searchSort_report.worOrder.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
    -->
</script>


<%
	int rowCounter = 0;                  // counts the number of rows emitted
	int evenOddValue = 0;                // alternates between 0 and 1
	String[] evenOdd = {"b-185", "b-184"};  // two-element String array
	
	String sqlString;
	
	String countryName;
	String validSql = "name title creator suburb dates num ASC DESC";
	
	
	String orgSortCol = request.getParameter("orgCol");
   	  if (orgSortCol == null || !validSql.contains(orgSortCol)) orgSortCol = "name";
	  String orgSortOrd = request.getParameter("orgOrder");
	  if (orgSortOrd == null || !validSql.contains(orgSortOrd)) orgSortOrd = "ASC";

	String venSortCol = request.getParameter("venCol");
	  if (venSortCol == null || !validSql.contains(venSortCol)) venSortCol = "name";
	  String venSortOrd = request.getParameter("venOrder");
	  if (venSortOrd == null || !validSql.contains(venSortOrd)) venSortOrd = "ASC";

	String worSortCol = request.getParameter("worCol");
	  if (worSortCol == null || !validSql.contains(worSortCol)) worSortCol = "title";
	  String worSortOrd = request.getParameter("worOrder");
	  if (worSortOrd == null || !validSql.contains(worSortOrd)) worSortOrd = "ASC";

	
	String id=request.getParameter("id");
	ausstage.Database     m_db = new ausstage.Database ();
  	CachedRowSet  l_rs      = null;
  	CachedRowSet  org_rs    = null;
  	int orgCount		= 0;
  	String orgIds		= "";
  	CachedRowSet  ven_rs    = null;
  	int venCount		= 0;
  	String venIds		= "";
  	CachedRowSet  wor_rs    = null;  	
  	int worCount		= 0;
  	admin.AppConstants constants = new admin.AppConstants();
  	m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  	Statement stmt    = m_db.m_conn.createStatement ();
  	sqlString =	"SELECT countryname From `country` WHERE countryid = "+id;
  	l_rs = m_db.runSQL (sqlString, stmt);
  	l_rs.next();
  	countryName = l_rs.getString(1);
  	
  	///////////
	//ORGANISATION select to retrieve data associated with organisations from the selected country
	String orgSqlString =	"SELECT organisation.organisationid organisationid, organisation.name NAME , events.event_name, "+
        			"concat_ws(' - ',min(events.yyyyfirst_date), if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) ) as dates, "+
        			"min(events.yyyyfirst_date) minyear, "+
	        		"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxyear, "+
        			"count(distinct events.eventid) num, if(organisation.suburb is null, '', organisation.suburb) suburb "+
				"FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
            			"LEFT JOIN events ON (orgevlink.eventid = events.eventid) "+
				"WHERE organisation.countryid = "+id+
        	     		" group by organisation.organisationid Order by " + orgSortCol + " " + orgSortOrd ;
  	
  	org_rs = m_db.runSQL (orgSqlString, stmt);
	System.out.println("Organisation - " + orgSqlString); 
  	//collect all the organisation id's for the map link
  	//get the count of results.
  	//hold onto the result set for the display of results
  	while(org_rs.next()){
  		orgCount++;
  		orgIds += org_rs.getString("organisationid")+",";
  	}
  	org_rs.beforeFirst();
  	
   	///////////
	//VENUE select to retrieve data associated with venues from the selected country 	
  	String	venSqlString =	"SELECT venue.venueid venueid, venue.venue_name name, "+
			"concat_ws(' - ',min(events.yyyyfirst_date), if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) ) as dates, "+
			"count(distinct events.eventid) num, "+
			"if(venue.suburb is null, 'none', venue.suburb) suburb "+
			"FROM venue LEFT JOIN events ON (venue.venueid = events.venueid) "+
			"WHERE venue.countryid = "+id+
			" group by venue.venueid Order by " + venSortCol + " " + venSortOrd ; 
  	ven_rs = m_db.runSQL (venSqlString, stmt);
	System.out.println("Venue - " + venSqlString); 
  	//collect all the venue id's for the map link
  	//get the count of results.
  	//hold onto the result set for the display of results
  	while(ven_rs.next()){
  		venCount++;
  		venIds += ven_rs.getString("venueid")+",";
  	}
  	ven_rs.beforeFirst();
  
  	///////////
	//WORKselect to retrieve data associated with venues from the selected country 
  	String worSqlString = 	"select work.workid workid, work_title title, count(distinct events.eventid) num, country.countryid, "+
			"concat_ws(' - ',min(events.yyyyfirst_date), if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) ) as dates, "+
			"concat_ws(', ', GROUP_CONCAT(distinct if (CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME) = '', null, CONCAT_WS(' ', CONTRIBUTOR.FIRST_NAME ,CONTRIBUTOR.LAST_NAME)) SEPARATOR ', '), group_concat(distinct organisation.name separator ', ')) creator "+
			"from work "+
    			"left join eventworklink on(eventworklink.workid = work.workid) "+
    			"left join  events on(events.eventid = eventworklink.eventid) "+
			"left join  playevlink on(playevlink.eventid = events.eventid) "+
			"left join  country on(playevlink.countryid = country.countryid)  "+
    			"LEFT  JOIN workconlink ON (work.workid = workconlink.workid) "+
			"LEFT  JOIN contributor ON (workconlink.contributorid = contributor.contributorid)  "+
			"Left  Join workorglink ON (work.workid= workorglink.workid) "+
 			"Left  Join organisation ON (workorglink.organisationid= organisation.organisationid) "+
 			"where country.countryid = "+id+
			" group by work.workid Order by " + worSortCol + " " + worSortOrd ; 
	wor_rs = m_db.runSQL (worSqlString, stmt);
	System.out.println("Work - "+ worSqlString); 
  	//collect all the work id's for the map link
  	//get the count of results.
  	//hold onto the result set for the display of results
  	while(wor_rs.next()){
  		worCount++;
  	}
  	wor_rs.beforeFirst(); 	
  	
  	//MAP LINK
  	String mapLink = "/pages/map/?complex-map=true&c=&o="+orgIds+"&v="+venIds+"&e=";	
%>
<div class="browse record">

	<div class="browse-bar b-90"><img class="browse-icon" src="../../../resources/images/icon-international.png">
   
	    	<span class="browse-heading large"><b><%=countryName%></b></span>
	    	<span class="browse-index browse-index-international"><a href="events/index.jsp?id=<%=id%>">Events</a> | <a href="<%=mapLink%>">Map</a></span>

	</div>


<form name="form_searchSort_report" method="POST" action=".">	
    <input type="hidden" name="id" value="<%=id%>">
    <input type="hidden" name="orgCol" value="<%=orgSortCol%>">
    <input type="hidden" name="orgOrder" value="<%=orgSortOrd%>">
    <input type="hidden" name="venCol" value="<%=venSortCol%>">
    <input type="hidden" name="venOrder" value="<%=venSortOrd%>">
    <input type="hidden" name="worCol" value="<%=worSortCol%>">
    <input type="hidden" name="worOrder" value="<%=worSortOrd%>">
<!-- ORGANISATION RESULTS -->

<%if (orgCount>0){%>
<table class="sub-browse-table ">
	<thead>
    		<tr>
      		 <th width="25%" align="left" class="browse-th-organisation"><img class="browse-icon" src="../../../resources/images/icon-organisation.png">
      		 <span class="sub-browse-heading"><b><a href="#" onClick="reSortDataOrg('name')"> Organisations (<%=orgCount%>)</a></b></span></th>
     		 <th width="25%" align="left" class="browse-th-organisation"><a href="#" onClick="reSortDataOrg('suburb')">Suburb</a></th>
      		 <th width="25%" align="left" class="browse-th-organisation"><a href="#" onClick="reSortDataOrg('dates')">Event Dates</a></th>
      		 <th width="25%" align="left" class="browse-th-organisation"><a href="#" onClick="reSortDataOrg('num')">Events</a></th>
    		</tr>
    	</thead>
	<%
	while(org_rs.next()){
     		rowCounter++;
      		// set evenOddValue to 0 or 1 based on rowCounter
      		evenOddValue = 1;
      		if (rowCounter % 2 == 0) evenOddValue = 0;	
	%>
	        <tr class="<%=evenOdd[evenOddValue]%>">
	        	<td width="25%"><a href="/pages/organisation/<%=org_rs.getString("organisationid")%>"><%=org_rs.getString("name")%></a></td>
	        	<td width="25%"><%=org_rs.getString("suburb")%></td>
	        	<td width="25%"><%=org_rs.getString("dates")%></td>
        		<td width="25%" align="left"><%=org_rs.getString("num")%></td>  
        	</tr>
	<%         
	}
	%>
	</table>
<%}
if (venCount >0){
%>
	<!-- VENUE RESULTS -->
	<table class="sub-browse-table">
		<thead>
	    		<tr>
	      		 <th width="25%" align="left" class="browse-th-venue"><img class="browse-icon" src="../../../resources/images/icon-venue.png">
	      		 <span class="sub-browse-heading"><b><a href="#" onClick="reSortDataVen('name')">Venues (<%=venCount%>)</a></b></span></th>
	     		 <th width="25%" align="left" class="browse-th-venue"><a href="#" onClick="reSortDataVen('suburb')">Suburb</a></th>
	      		 <th width="25%" align="left" class="browse-th-venue"><a href="#" onClick="reSortDataVen('dates')">Event Dates</a></th>
	      		 <th width="25%" align="left" class="browse-th-venue"><a href="#" onClick="reSortDataVen('num')">Events</a></th>
	    		</tr>
	    	</thead>
<%	
		//ven_rs = m_db.runSQL (venSqlString, stmt);
		//reset rowcounter so the odd even rows are reset.
		rowCounter = 0;
		while(ven_rs.next()){
			rowCounter++;
			// set evenOddValue to 0 or 1 based on rowCounter
	      		evenOddValue = 1;
	      		if (rowCounter % 2 == 0) evenOddValue = 0;	
%>
	        <tr class="<%=evenOdd[evenOddValue]%>">
	        	<td width="25%"><a href="/pages/venue/<%=ven_rs.getString("venueid")%>"><%=ven_rs.getString("venue_name")%></a></td>
	        	<td width="25%"><%=ven_rs.getString("suburb")%></td>
	        	<td width="25%"><%=ven_rs.getString("dates")%></td>
	        	<td width="25%" align="left"><%=ven_rs.getString("num")%></td>  
	        </tr>
	<%         
		}
	%>
	</table>

<%}
	//quick fix to remove works from display temporarily
	//if (worCount>0){
	if(1==2){
%>

	<table class="sub-browse-table">
	<thead>
    		<tr>
      		 <th width="25%" align="left" class="browse-th-work" ><img class="browse-icon" src="../../../resources/images/icon-work.png">
      		 <span class="sub-browse-heading"><b><a href="#" onClick="reSortDataWor('title')">Works (<%=worCount%>)</a></b></span></th>
     		 <th width="25%" align="left" class="browse-th-work"><a href="#" onClick="reSortDataWor('creator')">Creators</a></th>
      		 <th width="25%" align="left" class="browse-th-work"><a href="#" onClick="reSortDataWor('dates')">Event Dates</a></th>
      		 <th width="25%" align="right" class="browse-th-work"><a href="#" onClick="reSortDataWor('num')">Events</a></th>
    		</tr>
    	</thead>
<%
	
	
	//reset rowcounter so the odd even rows are reset.
		
	rowCounter = 0;
	while(wor_rs.next()){
		rowCounter++;
		evenOddValue = 1;
      		if (rowCounter % 2 == 0) evenOddValue = 0;	
      	
%>
        <tr class="<%=evenOdd[evenOddValue]%>">
        	<td width="25%"><a href="/pages/work/<%=wor_rs.getString("workid")%>"><%=wor_rs.getString("title")%></a></td>
        	<td width="25%"><%=wor_rs.getString("creator")%></td>
        	<td width="25%"><%=wor_rs.getString("dates")%></td>
        	<td width="25%" align="right"><%=wor_rs.getString("num")%></td>  
        </tr>
<%         
	}
%>
</table>
<%}%>
</form>	
</div>


<jsp:include page="../../templates/footer.jsp" />
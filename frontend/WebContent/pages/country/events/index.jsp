<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*, ausstage.*, sun.jdbc.rowset.*" %>

<jsp:include page="../../../templates/header.jsp" /><%@ include file="../../../public/common.jsp"%>

<!--<%@ page session="true" import="org.opencms.main.*,org.opencms.jsp.*,org.opencms.file.*,java.lang.String,java.util.*"%>
<%
admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%>
<%@ page import="ausstage.AusstageCommon"%>-->

<script language="JavaScript" type="text/JavaScript">
  
</script>


<%
	int rowCounter = 0;                  // counts the number of rows emitted
	int evenOddValue = 0;                // alternates between 0 and 1
	String[] evenOdd = {"b-185", "b-184"};  // two-element String array
	
	String sqlString;
	
	String countryName;
	String validSql = "name venue title creator suburb dates num ASC DESC";
	
	
	ausstage.Database     m_db = new ausstage.Database ();
    String id= m_db.plSqlSafeString(request.getParameter("id"));

  	CachedRowSet  l_rs      = null;
  	CachedRowSet  org_rs    = null;
  	int orgCount		= 0;
  	String orgIds		= "";
  	CachedRowSet  ven_rs    = null;
  	int venCount		= 0;
  	String venIds		= "";
  	CachedRowSet  text_rs    = null;  	
  	int textCount		= 0;
	CachedRowSet  prod_rs    = null;  	
  	int prodCount		= 0;
  	admin.AppConstants constants = new admin.AppConstants();
  	m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  	Statement stmt    = m_db.m_conn.createStatement ();
  	sqlString =	"SELECT countryname From `country` WHERE countryid = "+id;
  	l_rs = m_db.runSQL (sqlString, stmt);
  	l_rs.next();
  	countryName = l_rs.getString(1);
  	
  	///////////
	//ORGANISATION select to retrieve data associated with organisations from the selected country
	String orgSqlString =	"SELECT DISTINCT organisation.organisationid, organisation.name as name, "+
				"events.eventid, events.event_name, events.ddfirst_date,events.mmfirst_date, events.yyyyfirst_date, "+
				"venue.venue_name, venue.venueid,venue.suburb,states.state,"+
				"concat_ws(', ', if(venue.suburb='' || venue.suburb = ' ', null, venue.suburb), "+
				"	if(states.state ='O/S',null,states.state), "+
				"	if(venuecountry.countryname='Australia', null, venuecountry.countryname)) as venueAddress  "+
				"FROM events,venue,states,orgevlink,organisation, country, country as venuecountry "+
				"WHERE country.countryid = "+id+" AND "+
				"country.countryid = organisation.countryid AND "+
				"venue.countryid = venuecountry.countryid AND "+
				"events.venueid = venue.venueid AND "+
				"venue.state = states.stateid AND "+
				"orgevlink.organisationid = organisation.organisationid AND "+
				"orgevlink.eventid = events.eventid "+
				"Order by name";
  	
  	org_rs = m_db.runSQL (orgSqlString, stmt);

  	while(org_rs.next()){
  		orgCount++;
  		orgIds += org_rs.getString("organisationid")+",";
  	}
  	org_rs.beforeFirst();
  	
   	///////////
	//VENUE select to retrieve data associated with venues from the selected country 	
  	String	venSqlString =	"SELECT DISTINCT venue.venueid, venue.venue_name, venue.suburb,states.state, "+
    				"events.eventid, events.event_name, events.ddfirst_date, events.mmfirst_date, "+
    				"events.yyyyfirst_date, country.countryname as countryname "+ 
				"FROM "+
    				"events,venue,states,country "+
				"WHERE "+
				"country.countryid = "+id+" AND "+
				"events.venueid = venue.venueid AND  "+
				"venue.state = states.stateid AND  "+
				"venue.countryid = country.countryid "+
				"ORDER BY venue.venue_name";
  	ven_rs = m_db.runSQL (venSqlString, stmt);

  	while(ven_rs.next()){
  		venCount++;
  	}
  	ven_rs.beforeFirst();
  
  	///////////
	//Select to retrieveevents with origin of text matching the country
  	String textSqlString = 	"SELECT event_name, events.eventid, "+
      				"events.yyyyfirst_date, events.mmfirst_date, events.ddfirst_date, "+
      				"venue_name, venue.venueid, "+
      				"concat_ws(', ', if(venue.suburb='' || venue.suburb = ' ', null, venue.suburb), "+
				"	if(states.state ='O/S',null,states.state), "+
				"	if(venuecountry.countryname='Australia', null, venuecountry.countryname)) as venueAddress  "+
				"FROM events, playevlink, country, venue, states, country venuecountry "+
				"WHERE "+
				"events.eventid = playevlink.eventid "+
				"AND country.countryid = "+id+" "+
				"AND country.countryid = playevlink.countryid "+
				"AND events.venueid = venue.venueid "+
				"AND venue.state = states.stateid "+
				"AND venue.countryid = venuecountry.countryid "+
				"ORDER BY events.event_name";
  	
  	text_rs = m_db.runSQL (textSqlString, stmt);
  	//collect all the work id's for the map link
  	//get the count of results.
  	//hold onto the result set for the display of results
  	while(text_rs.next()){
  		textCount++;
  	}
  	text_rs.beforeFirst(); 	
  	
  	///////////
	//Select to retrieveevents with origin of production matching the country
  	String prodSqlString = 	"SELECT event_name, events.eventid, "+
      				"events.yyyyfirst_date, events.mmfirst_date, events.ddfirst_date, "+
      				"venue_name, venue.venueid, "+
      				"concat_ws(', ', if(venue.suburb='' || venue.suburb = ' ', null, venue.suburb), "+
				"	if(states.state ='O/S',null,states.state), "+
				"	if(venuecountry.countryname='Australia', null, venuecountry.countryname)) as venueAddress  "+
				"FROM events, productionevlink, country, venue, states, country venuecountry "+
				"WHERE "+
				"events.eventid = productionevlink.eventid "+
				"AND country.countryid = "+id+" "+
				"AND country.countryid = productionevlink.countryid "+
				"AND events.venueid = venue.venueid "+
				"AND venue.state = states.stateid "+
				"AND venue.countryid = venuecountry.countryid "+
				"ORDER BY events.event_name";
  	
  	prod_rs = m_db.runSQL (prodSqlString, stmt);
  	//collect all the work id's for the map link
  	//get the count of results.
  	//hold onto the result set for the display of results
  	while(prod_rs.next()){
  		prodCount++;
  	}
  	prod_rs.beforeFirst(); 
  
%>
<div class="browse">

	<div class="browse-bar b-90"><img class="browse-icon" src="../../../../resources/images/icon-international.png">
   
	    	<span class="browse-heading large"><b>Events for <%=countryName%></b></span>
	    	<span class="browse-index browse-index-international"></span>

	</div>

<!-- ORGANISATION RESULTS -->

<%if (orgCount>0){%>
<table class="sub-browse-table ">
	<thead>
    		<tr>
      		 <th width="25%" align="left" class="browse-th-organisation"><img class="browse-icon" src="../../../../resources/images/icon-organisation.png">
      		 <span class="sub-browse-heading"><b>By Organisation </b></span></th>
     		 <th width="25%" align="left" class="browse-th-organisation">Event</th>
      		 <th width="25%" align="left" class="browse-th-organisation">Venue</th>
      		 <th width="25%" align="right" class="browse-th-organisation">First Date</th>
    		</tr>
    	</thead>
	<%
	String prevOrg = "";
	while(org_rs.next()){
     		rowCounter++;
      		// set evenOddValue to 0 or 1 based on rowCounter
      		evenOddValue = 1;
      		if (rowCounter % 2 == 0) evenOddValue = 0;	
	%>
	        <tr class="<%=evenOdd[evenOddValue]%>">
	               	<td width="25%">
	               	<%if (!prevOrg.equals(org_rs.getString("name"))) {%>
		               	<a href="/pages/organisation/<%=org_rs.getString("organisationid")%>"><%=org_rs.getString("name")%></a>
		        <%}prevOrg = org_rs.getString("name");%>
	               	</td>
	        	<td width="25%"><a href="/pages/event/<%=org_rs.getString("eventid")%>"><%=org_rs.getString("event_name")%></a></td>
        		<td width="25%" ><a href="/pages/venue/<%=org_rs.getString("venueid")%>"><%=org_rs.getString("venue_name")%></a><%=", "+org_rs.getString("venueAddress")%></td>  
	        	<td width="25%" align="right">
	        	<% if (hasValue(formatDate(org_rs.getString("DDFIRST_DATE"),org_rs.getString("MMFIRST_DATE"),org_rs.getString("YYYYFIRST_DATE"))))
				out.print( formatDate(org_rs.getString("DDFIRST_DATE"),org_rs.getString("MMFIRST_DATE"),org_rs.getString("YYYYFIRST_DATE")));%>
			</td>
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
	      		 <th width="25%%" align="left" class="browse-th-venue"><img class="browse-icon" src="../../../../resources/images/icon-venue.png">
	      		 <span class="sub-browse-heading"><b>By Venue </b></span></th>
	     		 <th width="50%" align="left" class="browse-th-venue">Event</th>
  	      		 <th width="25%" align="right" class="browse-th-venue">First Date</th>
	    		</tr>
	    	</thead>
<%	
		//ven_rs = m_db.runSQL (venSqlString, stmt);
		//reset rowcounter so the odd even rows are reset.
		rowCounter = 0;
		String prevVen = "";
		while(ven_rs.next()){
			rowCounter++;
			// set evenOddValue to 0 or 1 based on rowCounter
	      		evenOddValue = 1;
	      		if (rowCounter % 2 == 0) evenOddValue = 0;	
%>
	        <tr class="<%=evenOdd[evenOddValue]%>">
	        	<td width="25%">
	        	<%if (!prevVen.equals(ven_rs.getString("venue_name"))) {%>
		               	<a href="/pages/venue/<%=ven_rs.getString("venueid")%>"><%=ven_rs.getString("venue_name")%></a><%=", "+ven_rs.getString("suburb")%>
		        <%}prevVen = ven_rs.getString("venue_name");%>
			</td>
	        	<td width="50%"><a href="/pages/event/<%=ven_rs.getString("eventid")%>"><%=ven_rs.getString("event_name")%></a></td>
	        	<td width="25%" align="right">
	        	<% if (hasValue(formatDate(ven_rs.getString("DDFIRST_DATE"),ven_rs.getString("MMFIRST_DATE"),ven_rs.getString("YYYYFIRST_DATE"))))
				out.print( formatDate(ven_rs.getString("DDFIRST_DATE"),ven_rs.getString("MMFIRST_DATE"),ven_rs.getString("YYYYFIRST_DATE")));%>
			</td>

	        </tr>
	<%         
		}
	%>
	</table>

<%}

if (textCount>0){
%>

	<table class="sub-browse-table">
	<thead>
    		<tr>
      		 <th width="25%" align="left" class="browse-th-event" ><img class="browse-icon" src="../../../../resources/images/icon-event.png">
      		 <span class="sub-browse-heading"><b>Origin of Text</b></span></th>
     		 <th width="25%" align="left" class="browse-th-event">Event</th>
      		 <th width="25%" align="left" class="browse-th-event">Venue</th>
      		 <th width="25%" align="right" class="browse-th-event">First Date</th>
    		</tr>
    	</thead>
<%

	rowCounter = 0;
	while(text_rs.next()){
		rowCounter++;
// set evenOddValue to 0 or 1 based on rowCounter
      		evenOddValue = 1;
      		if (rowCounter % 2 == 0) evenOddValue = 0;	
%>
        <tr class="<%=evenOdd[evenOddValue]%>">
        	<td width="25%"></td>
        	<td width="25%"><a href="/pages/event/<%=text_rs.getString("eventid")%>"><%=text_rs.getString("event_name")%></a></td>
        	<td width="25%"><a href="/pages/venue/<%=text_rs.getString("venueid")%>"><%=text_rs.getString("venue_name")%></a><%=", "+text_rs.getString("venueAddress")%></td>
        	<td width="25%" align="right">
        	<% if (hasValue(formatDate(text_rs.getString("DDFIRST_DATE"),text_rs.getString("MMFIRST_DATE"),text_rs.getString("YYYYFIRST_DATE"))))
			out.print( formatDate(text_rs.getString("DDFIRST_DATE"),text_rs.getString("MMFIRST_DATE"),text_rs.getString("YYYYFIRST_DATE")));%>
        	</td>  
        </tr>
<%         
	}
%>
</table>
<%}
	
if (prodCount>0){
%>

	<table class="sub-browse-table">
	<thead>
    		<tr>
      		 <th width="25%" align="left" class="browse-th-event" ><img class="browse-icon" src="../../../../resources/images/icon-event.png">
      		 <span class="sub-browse-heading"><b>Origin of Production</b></span></th>
     		 <th width="25%" align="left" class="browse-th-event">Event</th>
      		 <th width="25%" align="left" class="browse-th-event">Venue</th>
      		 <th width="25%" align="right" class="browse-th-event">First Date</th>
    		</tr>
    	</thead>
<%

	rowCounter = 0;
	while(prod_rs.next()){
		rowCounter++;
// set evenOddValue to 0 or 1 based on rowCounter
      		evenOddValue = 1;
      		if (rowCounter % 2 == 0) evenOddValue = 0;	
%>
        <tr class="<%=evenOdd[evenOddValue]%>">
        	<td width="25%"></td>
        	<td width="25%"><a href="/pages/event/<%=prod_rs.getString("eventid")%>"><%=prod_rs.getString("event_name")%></a></td>
        	<td width="25%"><a href="/pages/venue/<%=prod_rs.getString("venueid")%>"><%=prod_rs.getString("venue_name")%></a><%=", "+prod_rs.getString("venueAddress")%></td>
        	<td width="25%" align="right">
        	<% if (hasValue(formatDate(prod_rs.getString("DDFIRST_DATE"),prod_rs.getString("MMFIRST_DATE"),prod_rs.getString("YYYYFIRST_DATE"))))
			out.print( formatDate(prod_rs.getString("DDFIRST_DATE"),prod_rs.getString("MMFIRST_DATE"),prod_rs.getString("YYYYFIRST_DATE")));%>
        	</td>  
        </tr>
<%         
	}
%>
</table>
<%}%>

</div>


<jsp:include page="../../../templates/footer.jsp" />
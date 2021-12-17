<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>


<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.VenueVenueLink, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.RelationLookup, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>

<%@ page session="true" import=" java.lang.String, java.util.*" %>


<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<%@ include file="exhibition_include.jsp" %>
<!-- js for show hide onclick of the headers. -->


<link rel="stylesheet" type="text/css" href="/resources/exhibition.css">
 <!-- libraries here        -->
		


<jsp:include page="../../templates/header.jsp" />
	<%
	String exhibitionid = request.getParameter("id");;
	
	//get event data
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	
	session.setAttribute("database-connection", m_db);
	
	Statement stmt = m_db.m_conn.createStatement();
	
	
	CachedRowSet rowSetExhibitions = null;
	String sqlExhibitions = 
	"SELECT\n" +
	"	`exhibition`.`exhibitionid`,\n" +
	"	`exhibition`.`name`,\n" +
	"	`exhibition`.`description`,\n" +
	"	`exhibition`.`published_flag`,\n" +
	"	`exhibition`.`owner`,\n" +
	"	`exhibition`.`entered_by_user`,\n" +
	"	`exhibition`.`entered_date`,\n" +
	"	`exhibition`.`updated_by_user`,\n" +
	"	`exhibition`.`updated_date`,\n" +
	"	`exhibition_section`.`exhibition_sectionid`,\n" +
	"	`exhibition_section`.`heading`,\n" +
	"	`exhibition_section`.`text`,\n" +
	"	`exhibition_section`.`sequencenumber`,\n" +
	//"	`exhibition_section`.`exhibitionid`,\n" +
	"	`exhibition_section`.`itemid`,\n" +
	"	`exhibition_section`.`organisationid`,\n" +
	"	`exhibition_section`.`eventid`,\n" +
	"	`exhibition_section`.`venueid`,\n" +
	"	`exhibition_section`.`contributorid`,\n" +
	"	`exhibition_section`.`workid`\n" +
	"FROM \n" +
	"	`exhibition` left outer join \n" +
	"	`exhibition_section` on `exhibition`.`exhibitionid` = `exhibition_section`.`exhibitionid` \n" +
	"WHERE \n" +
	"	`exhibition`.`exhibitionid` = " + exhibitionid + " \n" +
	"ORDER BY \n" +
	"	`exhibition_section`.`sequencenumber`"  ;
	

	out.println("<!-- " + sqlExhibitions  + " -->");

	rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);
	
	if (rowSetExhibitions != null && rowSetExhibitions .size() > 0) {
		if(rowSetExhibitions.next()) {
		String curatorName = rowSetExhibitions.getString("entered_by_user").replaceAll("\\(.*\\)", "");

		if (curatorName.isEmpty()){
			curatorName = rowSetExhibitions.getString("entered_by_user");	
		}
		
		%><div class='heading-bar exhibition caption'>
		  	<div class="browse-bar b-153" >
 			  	<img src="/resources/images/icon-exhibition.png" class="browse-icon">
 			  	<span class="browse-heading large"><%=rowSetExhibitions.getString("name")%></span>
		  	</div>
		  	<div style=" padding:10px;">
		  	<%if (hasValue(rowSetExhibitions.getString("description"))){%>
			<%=rowSetExhibitions.getString("description")%>
			<br>
			<%}%>
			<b>Curated By</b>  <%=curatorName%>
		  	</div>
		
		</div><%
		}
		
		do {
			String itemid = rowSetExhibitions.getString("itemid");
			String organisationid = rowSetExhibitions.getString("organisationid");
			String eventid = rowSetExhibitions.getString("eventid");
			String venueid = rowSetExhibitions.getString("venueid");
			String contributorid = rowSetExhibitions.getString("contributorid");
			String workid = rowSetExhibitions.getString("workid");
			String heading = rowSetExhibitions.getString("heading");
			String text = rowSetExhibitions.getString("text");
			
			if(itemid != null && !"".equals(itemid)) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--itemid: <%= itemid%> -->
						<cms:include page="item.jsp" >
							<cms:param name="itemid"><%= itemid%></cms:param>
						</cms:include>
					</div>
				<%
			} else if(organisationid != null && !"".equals(organisationid )) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--organisationid: <%= organisationid %> -->
						<cms:include page="organisation.jsp" >
							<cms:param name="organisationid"><%= organisationid %></cms:param>
						</cms:include>
					</div>
				<%
			} else if(eventid != null && !"".equals(eventid )) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--eventid : <%= eventid %> -->
						<cms:include page="event.jsp" >
							<cms:param name="eventid"><%= eventid %></cms:param>
						</cms:include>
					</div>
				<%
			} else if(venueid != null && !"".equals(venueid )) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--venueid : <%= venueid %> -->
						<cms:include page="venue.jsp" >
							<cms:param name="venueid"><%= venueid %></cms:param>
						</cms:include>
					</div>
				<%
			} else if(contributorid != null && !"".equals(contributorid )) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--contributorid : <%= contributorid %> -->
						<cms:include page="contributor.jsp" >
							<cms:param name="contributorid"><%= contributorid %></cms:param>
						</cms:include>
					</div>
				<%
			} else if(workid!= null && !"".equals(workid)) {
				%>
				
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--workid: <%= workid%> -->
						<cms:include page="work.jsp" >
							<cms:param name="workid"><%= workid%></cms:param>
						</cms:include>
					</div>
				<%
			} else {
				%>
					<div class="exhibition-element" style="margin: 5px 10px 0px 10px;">
						<!--heading: <%= heading%> -->
						<!--text: <%= text%> -->
						<cms:include page="text.jsp" >
							<cms:param name="heading"><%= heading%></cms:param>
							<cms:param name="text"><%= text%></cms:param>
						</cms:include>
					</div>
						<%
			}
			//out.println("<p>"+rowSetExhibitions.getString("name")+"</p>");
		} while (rowSetExhibitions .next());
	}

	
	session.setAttribute("database-connection", null);
	
  	stmt.close();
	m_db.m_conn.close();
	
	%>
	

	
	
<div style="margin: 0px;padding-bottom: 6em;"></div>
<script>
$(document).ready(function(){
 $('.show-hide').showHide({
       		 speed: 400, // speed you want the toggle to happen
		 easing: '', // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
	         changeIcon: 1
/*	         showIcon: 'glyphicon-plus',
	         hideIcon: 'glyphicon-minus'*/
	    });
});
</script>


<jsp:include page="../../templates/footer.jsp" />

<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%--@ page import = "java.util.Vector, java.text.SimpleDateFormat"--%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "java.net.URLEncoder" %>
<%--@ page import = "ausstage.State"%>
<%--@ page import = "ausstage.State"%>
<%@ page import = "admin.Common, ausstage.AusstageCommon"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.RelationLookup, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" --%>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>


<!-- Bootstrap -->
<!--        <link rel='stylesheet' href="/resources/bootstrap-4.0.0-beta.2/css/bootstrap.min.css"/>-->

 <!-- libraries here        -->
<!--        <script src="/resources/js/jquery-3.2.1.min.js"></script> 
        <script src="/resources/bootstrap-4.0.0-beta.2/js/bootstrap.min.js"></script>-->

<%@ include file="../../public/common.jsp"%>



<%

	String item_id = request.getParameter("itemid");
	String sqlStmt= "SELECT url url FROM item_url where lower(item_url.url) like '%.pdf' and item_url.itemid = " + item_id + 
		" union " +
		" SELECT item_url url FROM item i where lower(i.item_url) like '%.pdf' and i.itemid = " + item_id; 	
	int item_no = 0;
	
	try {
		ausstage.Database m_db = (ausstage.Database)session.getAttribute("database-connection");
		
		if(m_db == null) {
			m_db = new ausstage.Database();
			m_db.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
		}	
		
		Statement stmt = m_db.m_conn.createStatement();	
		CachedRowSet rowSet= null;
		
		
		//out.println("<!-- " + sqlStmt + " -->");
		
		rowSet= m_db.runSQL(sqlStmt, stmt);
%>
	<div style="width: 100%; text-align:center">
<%		
		if (rowSet!= null && rowSet.size() > 0) {
			while( rowSet.next()) {
				%>


		<div class='record item-light' style="margin: 0px; padding-top:20px; padding-bottom:20px; margin-bottom:5px">	
					  <iframe src='http://docs.google.com/viewer?url=<%=rowSet.getString("url")%>&embedded=true' style="width:90%; height:50%;" frameborder="0"></iframe>
		</div>
		

				<%	
			}
		}
		%>
	</div>
	<%
		stmt.close();
	} catch(Exception e) {
		System.out.println(e);
		System.out.println(sqlStmt);
	}
%>

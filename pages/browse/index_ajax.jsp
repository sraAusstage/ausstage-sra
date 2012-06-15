<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.util.StringTokenizer,java.util.Calendar, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%><%@ page import = "ausstage.Event, ausstage.State, ausstage.Search, ausstage.Contributor, admin.Common"%>
<%@ page import = "ausstage.AusstageCommon, ausstage.SearchCount"%>
<%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%>
<jsp:useBean id="ausstage_db_for_result" class="ausstage.Database" scope="application">
<%ausstage_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%
  	ausstage.Database db_ausstage_for_result       = new ausstage.Database ();
  	Common         common                          = new Common();
  	db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  	CachedRowSet   crset                    = null;
  	String         	keyword			= request.getParameter("f_keyword");
  	String         	search_from             = request.getParameter("f_search_from");
  	SearchCount 	search 			= new SearchCount(db_ausstage_for_result);

  	if ( keyword == null || keyword == ""){keyword = "%";}
 	search.setKeyWord(keyword);

 	if(search_from.equals("event")){crset = search.getEventCount();}
 	if(search_from.equals("contributor"))crset = search.getContributorCount();
	if(search_from.equals("venue"))crset = search.getVenueCount();
 	if(search_from.equals("organisation"))crset = search.getOrganisationCount();
 	if(search_from.equals("genre"))crset = search.getGenreCount();
 	if(search_from.equals("function"))crset = search.getFunctionCount();
 	if(search_from.equals("subject"))crset = search.getSubjectCount();
 	if(search_from.equals("resource"))crset = search.getResourceCount();
 	if(search_from.equals("works"))crset = search.getWorksCount();
 		
       	while(crset.next()){
		out.print(crset.getString(1));
	}
  

 %>
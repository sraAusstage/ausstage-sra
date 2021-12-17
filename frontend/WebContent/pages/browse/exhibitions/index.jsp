<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>


<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.SearchCount"%>
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


<%@ page session="true" import="java.lang.String, java.util.*" %>


<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../../public/common.jsp"%>

<jsp:include page="../../../templates/header.jsp" />
  
  <script language="JavaScript" type="text/JavaScript">

  /**
  * Make modifications to the sort column and sort order.
  * this can all be replaced eventually with modern approaches to data display and sorting. 
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
</script>
  
<div class="browse">

	<div class='browse-bar b-153'>
		<img src='/resources/images/icon-exhibition.png' class='browse-icon'/>					
		<span class="browse-heading large">Exhibitions</span>
	</div>

	<%	
	
	String sortCol = request.getParameter("col");
	if (sortCol == null ) sortCol = "name";
	String sortOrd = request.getParameter("order");
	if (sortOrd == null) sortOrd = "ASC";
	
	//get event data
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	Statement stmt = m_db.m_conn.createStatement();
	
	
	CachedRowSet rowSetExhibitions = null;
	CachedRowSet count = null;
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
		"	fn_get_group_concat_contributor(`exhibition`.`exhibitionid`) `curator`\n" +      
		"FROM \n" +
		"	`exhibition`\n" +
		"WHERE\n" +
		"	upper(`exhibition`.`published_flag`) = 'Y'\n" +
		"ORDER BY "+sortCol+" "+sortOrd;
	String getCount = "select count(*) from ( " + sqlExhibitions + " ) as exCount";
	count = m_db.runSQL(getCount, stmt);
	count.next();
	rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);
	
	if (rowSetExhibitions != null && rowSetExhibitions .size() > 0) {
		//just using the old way - but this can eventually become bootstrap table styling
		String[] evenOdd = {"b-185", "b-184"};
		int rowCounter = 0;

%>
		<div class="scroll-table">
			<table class="browse-table">
			<form name="form_searchSort_report" method="POST" action=".">
			  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
			    <input type="hidden" name="col" value="<%=sortCol%>">
			    <input type="hidden" name="order" value="<%=sortOrd%>">	
				<thead>
					<tr>
		      				<th width="20%"><b> <a href="#" onClick="reSortData('name')">Exhibition Name (<%=SearchCount.formatSearchCountWithCommas(count.getString(1))%>)</a></b></th>
		      				<th width="70%" ><b><a href="#" onClick="reSortData('description')">Description</a></b></th>
      						<th width="10%" ><b><a href="#" onClick="reSortData('owner')">Curator</a></b></th>
    					</tr>
    				</thead>
<%
		while (rowSetExhibitions .next()) {
			rowCounter++;	
			
			//remove the username from the curator display. 
			// unless theres no first and last name.
			String curatorName = rowSetExhibitions.getString("entered_by_user").replaceAll("\\(.*\\)", "");

			if (curatorName.isEmpty()){
				curatorName = rowSetExhibitions.getString("entered_by_user");	
			}		
%>		
				<tr class="<%=evenOdd[(rowCounter % 2)]%>" >
					<td width=20% style="vertical-align:top">
						<a href="/pages/exhibition/<%= rowSetExhibitions.getString("exhibitionid") %>">
							<%= rowSetExhibitions.getString("name") %> 
						</a>
					</td>
					<td width=70%>
						<%=rowSetExhibitions.getString("description")%>
					</td>
					<td width=10% style="vertical-align:top">
						<%=curatorName%>
					</td>
				</tr>
			<%
		}
		%>
				<tfoot>
					<tr  width="100%" class="browse-bar b-153" style="height:2.5em;">
				</tfoot>
			</form>
			</table>
		</div>
		<%
	}
	%>
	</div>
</div>			
	
<jsp:include page="../../../templates/footer.jsp" />


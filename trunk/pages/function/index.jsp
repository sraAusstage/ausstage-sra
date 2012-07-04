<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor,ausstage.ContFunctPref , ausstage.ContributorFunction"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />


<div class='record'>
			<%
			ausstage.Database db_ausstage_for_drill = new ausstage.Database ();
			db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
			
			List<String> groupNames = new ArrayList();	
			if (session.getAttribute("userName")!= null) {
				CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
				CmsObject cmsObject = cms.getCmsObject();
				List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
				for(CmsGroup group:userGroups) {
					groupNames.add(group.getName());
				}
			}
	
	
			ResultSet rset;
			Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
			String formatted_date = "";
			String contfunction_id = request.getParameter("id");	
	
			ContFunctPref function = null;
	
			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();  
			
			function = new ContFunctPref (db_ausstage_for_drill);
			function.load(contfunction_id);

			// Function Term
			%>
			<table class='record-table'>
				<tr>
					<th class='record-label b-105 bold'><img src='../../../resources/images/icon-blank.png' class='box-icon'>Function</th>
					
					<td class='record-value bold'><%=function.getPreferredTerm()%></td>
					<td rowspan=20 class='record-comment'>
					<%
					if(displayUpdateForm) {
					displayUpdateForm(contfunction_id, "Contributor Function", function.getPreferredTerm(),out,
					request, ausstage_search_appconstants_for_drill);
					}   
					%>
					</td>
				</tr>
			
			<%
			
			//Contributors
			rset = function.getAssociatedContributors(Integer.parseInt(contfunction_id), stmt);
			if(rset != null && rset.isBeforeFirst()) {
			%>
				<tr>
					<th class='record-label b-105 '>Contributors</th>
					
					<td class='record-value'>
						<table border="0" cellpadding="0" cellspacing="0">
						<%	
						while(rset.next()) {
						%>
							<tr>
								<td valign="top">
									<a href="/pages/contributor/<%=rset.getString("contributorid") %>">
										<%=rset.getString("name")%>
									</a>
								</td>
							</tr>
						<%
						}
						%>
						</table>
					</td>
				</tr>
			<%
			}
			
			//Contributor Function Identifier
			%>
			<tr>
				<th class='record-label b-105'>Contributor Function Identifier</th>
				
				<td class='record-value'><%=function.getPreferredId()%></td>
			</tr>
			
		</table>
	<%  
	// close statement
	stmt.close();
%>
<!--<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>-->
  <!-- AddThis Button BEGIN -->
<!--<div align="right" class="addthis_toolbox addthis_default_style ">
  <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
  <a class="addthis_button_tweet"></a>
  <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
  <a class="addthis_counter addthis_pill_style"></a>
</div>-->

</div>
<cms:include property="template" element="foot" />
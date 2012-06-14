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
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
	<tr>
		<td>
			<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
				<tr>
					<td bgcolor="#FFFFFF">
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
						
						CachedRowSet crset          = null;
						ResultSet    rset;
						Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
						String formatted_date       = "";
						String resource_subtype_id  =	request.getParameter("id");	
						String location             = "";
						
						SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
					
						// Table settings for main result display
						String baseTableWdth = "100%";
						String baseCol1Wdth  = "200";  // Headings
						String baseCol2Wdth  = "8";   // Spacer
						String baseCol3Wdth  = "";  // Details for Heading
						// Table settings for secondary table required under a heading in the main result display
						String secTableWdth = "100%";
						String secCol1Wdth  = "30%";
						String secCol2Wdth  = "70%";
						boolean displayUpdateForm = true;
						admin.Common Common = new admin.Common();  
						
						LookupCode lookupcode = new LookupCode(db_ausstage_for_drill);
						lookupcode.load(Integer.parseInt(resource_subtype_id));
						Event event = new Event(db_ausstage_for_drill);
						
						if (displayUpdateForm) {
							displayUpdateForm(resource_subtype_id, "Resource Type", lookupcode.getShortCode(), out,
								request, ausstage_search_appconstants_for_drill);
						}               
						
						//Resource Sub Type Name
						%>
						<table align="center" width='98%' border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td width='25%' align='right' class='general_heading_light f-186' valign='top'>Resource Sub Type</td>
								<td>&nbsp;</td>
								<td width='75%'><b><%=lookupcode.getShortCode()%></b></td>
							</tr>
							
							<%
							//Citations
							int CitationByResourceSubTypeCount = 0;
							rset = lookupcode.getCitationByResourceSubType(stmt, Integer.parseInt(resource_subtype_id));
							
							if (rset != null && rset.isBeforeFirst()) {
							%>
								<tr>
									<td align='right' class='general_heading_light f-186' valign='top'>Resources</td>
									<td>&nbsp;</td>
									<td>
										<table border="0" cellpadding="0" cellspacing="0">
										<%
										while(rset.next()) {
										%>
											<tr>
												<td valign="top">
													<a href="/pages/resource/?id=<%=rset.getString("itemid")%>">
														<%=rset.getString("citation")%>
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
							
							//Resource Sub Type Identifier
							%>
							
							<tr class="b-185">
								<td align='right' class='general_heading_light f-186' valign="top">Resource Sub Type Identifier</td>
								<td>&nbsp;</td>
								<td valign="top"><%=lookupcode.getCodeLovID()%></td>
							</tr>
						</table>
						<%
						// close statement
						stmt.close();
						%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cms:include property="template" element="foot" />
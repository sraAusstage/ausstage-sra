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
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
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
						
						List<String> groupNames = new ArrayList();	
						if (session.getAttribute("userName")!= null) {
							CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
							CmsObject cmsObject = cms.getCmsObject();
							List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
								for(CmsGroup group:userGroups) {
									groupNames.add(group.getName());
								}
						}
						
						
						db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
						
						CachedRowSet crset = null;
						ResultSet rset;
						Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
						String formatted_date = "";
						String contentindicatorid = request.getParameter("id");
						String location = "";
						
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


						ContentIndicator contentIndicator = new ContentIndicator(db_ausstage_for_drill);
						contentIndicator.load(Integer.parseInt(contentindicatorid)); 
			
						//Content Indicator
						%>
						<table class='record-table'>
							<tr>
								<th class='record-label b-90 bold'><img src='../../../resources/images/icon-blank.png' class='box-icon'>Subject</td>
								
								<td class='record-value bold'><%=contentIndicator.getName()%>
								<%
								if (groupNames.contains("Administrators") || groupNames.contains("Content Indicator Editor"))
								out.println("[<a class='editLink' target='_blank' href='/custom/primary_content_ind_addedit.jsp?mode=edit&f_primary_cont_ind_id=" + contentIndicator.getId() + "'>Edit</a>]");

								%>
								</td>
								<td rowspan=20 class='record-comment'>
								<%
								if (displayUpdateForm) {
								displayUpdateForm(contentindicatorid, "ContentIndicator", contentIndicator.getName(), out,
								request, ausstage_search_appconstants_for_drill);
								}
								%>
								</td>
								
							</tr>
							<%
							//Events
							Event event = new Event(db_ausstage_for_drill);
							rset = contentIndicator.getAssociatedEvents(Integer.parseInt(contentindicatorid), stmt);
							
							if (rset != null && rset.isBeforeFirst()) {
							%>
							<tr >
								<th class='record-label b-90'>Events</th>
								
								<td class='record-value'>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while (rset.next()) {
									%>
										<tr>
											<td valign="top">
												<a href="/pages/event/<%=rset.getString("eventid")%>">
													<%=rset.getString("event_name")%></a><%
												if (hasValue(rset.getString("venue_name"))) out.print(", " +  rset.getString("venue_name"));
												if (hasValue(rset.getString("suburb"))) out.print(", " + rset.getString("suburb"));
												if (hasValue(rset.getString("state"))) out.print(", " + rset.getString("state"));
												if (hasValue(formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE"))))
													out.print(", " + formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE")));
												%>
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
							
		    				//Items
							Item item = new Item(db_ausstage_for_drill);
							rset = contentIndicator.getAssociatedItems(Integer.parseInt(contentindicatorid), stmt);

							if(rset != null && rset.isBeforeFirst()) {
							%>
							<tr>
								<th class='record-label b-90'>Resources</th>
								
								<td class='record-value'>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while(rset.next()) {
										out.println("<tr>");
										out.println("  <td  valign=\"top\">"+rset.getString("description")+"&nbsp;<a href=\"/pages/resource/" +
										rset.getString("itemid") + "\">" +
										rset.getString("title") + "</a>");
										out.print("</td>");
										out.println("</tr>");
									}
									%>
									</table>
								</td>
							</tr>
							<%
							}

							// close statement
							stmt.close();
							
							//CI identifer
							%>
							<tr>
								<th class='record-label b-90'>Subject Identifier</th>
		    					
		    					<td class='record-value'><%=contentIndicator.getId()%></td>
							</tr>
							
						</table>
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
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
<%@ include file="../../templates/MainMenu.jsp"%>
<script type="text/javascript">
	function displayRow(name){
		document.getElementById("organisation").style.display = 'none';
		document.getElementById("organisationbtn").style.backgroundColor = '#c0c0c0';
		document.getElementById("contributor").style.display = 'none';
		document.getElementById("contributorbtn").style.backgroundColor = '#c0c0c0';
		document.getElementById("events").style.display = 'none';
		document.getElementById("eventsbtn").style.backgroundColor = '#c0c0c0';
	
		document.getElementById(name).style.display = '';
		document.getElementById(name+"btn").style.backgroundColor = '#000000';
	}
	
	function showHide(name) {
		if (document.getElementById(name).style.display != 'none') {
			document.getElementById(name).style.display = 'none';
		} else {
			document.getElementById(name).style.display = ''
		}
	}
</script>
<style type="text/css">
	#tabs {
		padding: 10px;
		padding-top:35px;
	}
	
	#tabs a {
		padding-top: 8px;
		padding-bottom: 8px;
		padding-left: 14px;
		padding-right: 10px;
		text-decoration: none;
		background-color: #c0c0c0;
		color: white;
	}   
	 
	#tabs a:hover {
		background-color: #bbbbbb;
	}
	
	#tabs .currentPage {
		background-color: #333333;
	}
	
	#tabs a:active {
		background-color: black;
	}
</style>
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
					if (session.getAttribute("userName") != null) {
						CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
						CmsObject cmsObject = cms.getCmsObject();
						List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
						for(CmsGroup group:userGroups) {
							groupNames.add(group.getName());
						}
					}	

					CachedRowSet crset = null;
					ResultSet rset;
					Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
					String formatted_date = "";
					String work_id = request.getParameter("id");
					String location = "";
					
					Work work = null;
					
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

					work = new Work(db_ausstage_for_drill);
					work.load(Integer.parseInt(work_id));
					if (displayUpdateForm) {
						displayUpdateForm(work_id, "Work", work.getName(), out,
							request, ausstage_search_appconstants_for_drill);
					}
					
					if (groupNames.contains("Administrators") || groupNames.contains("Works Editor"))
						out.println("<a class='editLink' target='_blank' href='/custom/work_addedit.jsp?action=edit&f_workid=" + work.getId() + "'>Edit</a>");

					rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
					
					//Works
					%>
					<table align="center" width='98%' border="0" cellpadding="3" cellspacing="0">
						<tr>
							<td width='25%' align='right' class='general_heading_light f-186' valign='top'>Work Name</td>
							<td>&nbsp;</td>
							<td width ='75%' ><b><%=work.getName()%></b></td>
						</tr>
						
						<%
						//Alternate Works Names
						if (work.getAlterWorkTitle() != null && !work.getAlterWorkTitle().equals("")) {
						%>
							<tr class="b-185">
								<td width='25%' align='right' class='general_heading_light f-186' valign='top'>Alternate Work Name</td>
								<td>&nbsp;</td>
								<td width='75%'><b><%=work.getAlterWorkTitle()%></b></td>
							</tr>
						<%
						}

						//Contributors
						rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
						if (rset != null && rset.isBeforeFirst()) {
						%>
							<tr>
								<td align='right' class='general_heading_light f-186' valign='top'>Creator Contributors</td>
								<td>&nbsp;</td>
								<td>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while (rset.next()) {
										if (rset.getString("contributorid") != null) {
										%>
											<tr>
												<td valign="top">
													<a href="/pages/contributor/?id=<%=rset.getString("contributorid")%>">
														<%=rset.getString("creator")%>
													</a>
												</td>
											</tr>
										<%
										}
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}

						//Organisations
						rset = work.getAssociatedOrganisations(Integer.parseInt(work_id),stmt);
						if (rset != null && rset.isBeforeFirst()) {
						%>
							<tr>
								<td align='right' class='general_heading_light f-186' valign='top'>Organisations</td>
								<td>&nbsp;</td>
								<td>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while(rset.next()) {
										if (rset.getString("organisationid") != null) {
										%>
											<tr>
												<td valign="top">
													<a href="/pages/organisation/?id=<%=rset.getString("organisationid")%>">
														<%=rset.getString("name")%>
													</a>
												</td>
											</tr>
										<%
										}
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}
						%>

						<tr>
							<td align='right' class='general_heading_light' valign='top'></td>
							<td>&nbsp;</td>
							<td id="tabs" colspan=3>
								<a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a>
								<a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a>   
								<a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a> 
							</td>
						</tr>

						<tr id='events'>
							<%
							// Events Tab
							ausstage.Database m_db = new ausstage.Database ();
							m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
							
							rset = work.getAssociatedEv(Integer.parseInt(work_id), stmt);
							
							if (rset != null && rset.isBeforeFirst()) {
							%>
								<td align='right' class='general_heading_light' valign='top'></td>
								<td>&nbsp;</td>
								<td valign="top">
									<ul>
									<%
									while (rset.next()) {
									%>
										<li>
										<a href="/pages/event/?id=<%=rset.getString("eventid")%>">
											<%=rset.getString("event_name")%>
										</a><%
										if (hasValue(rset.getString("Output"))) out.print(", " + rset.getString("Output"));
										if (hasValue(formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE"))))
											out.print(", " + formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE")));
										%>
										</li>
									<%
									}
									%>
									</ul>
								</td>
							<%
							}
							%>
						</tr>
						
						<tr id='organisation'>
						<%

						//Events by organisation type
						
						String sqlString = 
						"SELECT DISTINCT organisation.organisationid, organisation.name, "+
						"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
						"venue.venue_name,venue.suburb,states.state,evcount.num "+
						"FROM events,venue,states,eventworklink,orgevlink,organisation, "+
						"(SELECT orgevlink.organisationid, count(distinct orgevlink.eventid) num "+
						"FROM orgevlink, eventworklink where orgevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " "+
						"GROUP BY orgevlink.organisationid) evcount "+
						"WHERE eventworklink.workid = " + work_id + " AND "+
						"evcount.organisationid = organisation.organisationid AND "+
						"eventworklink.eventid = events.eventid AND "+
						"events.venueid = venue.venueid AND "+
						"venue.state = states.stateid AND "+
						"events.eventid = eventworklink.eventid AND "+
						"eventworklink.eventid=orgevlink.eventid AND "+
						"orgevlink.organisationid = organisation.organisationid "+
						"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
						crset = m_db.runSQL(sqlString, stmt);
						
						String prevOrg = "";
						if (crset.size() > 0) {
							%>
							<td align='right' class='general_heading_light' valign='top'></td>
					 		<td>&nbsp;</td>
					 		<td valign="top">
							
							<%	
							while (crset.next()){
								// If we're starting a new contributor, check if we have to finish the previous one
								if (!prevOrg.equals(crset.getString("name"))) {
									if (hasValue(prevOrg)) out.print("</ul>");
									
									// Now start the new one
									%>
								<a href="/pages/organisation/?id=<%=crset.getString("organisationid")%>">
									<%=crset.getString("name")%>
								</a>
								<br>
								<ul>
									<%
									prevOrg = crset.getString("name");
								}
								
								%>
									<li>
									<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
									<%=crset.getString("event_name")%></a><%
									if(hasValue(crset.getString("venue_name"))) 
										out.print(", " + crset.getString("venue_name"));
						  	        if(hasValue(crset.getString("suburb"))) 
										out.print(", " + crset.getString("suburb"));
						           	if(hasValue(crset.getString("state")))
										out.print(", " + crset.getString("state"));
									if (hasValue(formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE"))))
										out.print(", " + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE")));
									%>
									</li>
								<%	 
						 	 }
							%>
								</ul>
							</td>
							<%
						}
					 	
						out.flush();
						crset.close();
						%>
						</tr>
						
						<tr id='contributor'>
						<%
						//Contributors Tab
						sqlString = 
						"SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
						"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
						"venue.venue_name,venue.suburb,states.state,evcount.num " +
						"FROM events,venue,states,eventworklink,conevlink,contributor " +
						"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
						"FROM conevlink, eventworklink where conevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " " +
						"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
						"WHERE eventworklink.workid = " + work_id + " AND " +
						"eventworklink.eventid = events.eventid AND " +
						"events.venueid = venue.venueid AND " +
						"venue.state = states.stateid AND " +
						"events.eventid = eventworklink.eventid AND " +
						"eventworklink.eventid=conevlink.eventid AND " +
						"conevlink.contributorid = contributor.contributorid " +
						"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
						crset = m_db.runSQL(sqlString, stmt);
						
						String prevCont = "";
						if (crset.size() > 0) {
						%>
							<td align='right' class='general_heading_light' valign='top'></td>
					 		<td>&nbsp;</td>
					 		<td valign="top">
							
							<%	
							while (crset.next()){
								// If we're starting a new contributor, check if we have to finish the previous one
								if (!prevCont.equals(crset.getString("contributorid"))) {
									if (hasValue(prevCont)) out.print("</ul>");
					
									// Now start the new one
									%>
								<a href="/pages/contributor/?id=<%=crset.getString("contributorid")%>">
									<%=crset.getString("contributor_name")%>
								</a>
								<br>
								<ul>
									<%
									prevCont= crset.getString("contributorid");
								}
								
								%>
									<li>
									<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
										<%=crset.getString("event_name")%>
									</a><%
									if(hasValue(crset.getString("venue_name"))) out.print(", " + crset.getString("venue_name"));
									if(hasValue(crset.getString("suburb"))) out.print(", " + crset.getString("suburb"));
									if(hasValue(crset.getString("state"))) out.print(", " + crset.getString("state"));
									if(hasValue(formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE"))))
					            		out.print(", " + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE")));
									%>
									</li>
								<%	 
							}
							%>
								</ul>
							</td>
							<%
						}
						%>
						</tr>
						
						<tr class="b-185">
						<%
						//Resources
						rset = work.getAssociatedItems(Integer.parseInt(work_id), stmt);
						
  	  					if (rset != null && rset.isBeforeFirst()) {
  						%>
					 		<td align='right' class='general_heading_light f-186' valign='top'><a class='f-186' href="#" onclick="showHide('resources')">Resources</a></td>
							<td>&nbsp;</td>
							<td>
								<table id='resources' width="<%=secTableWdth%>" border="0" cellpadding="3" cellspacing="0">
	  	  						<%
	  	  						while (rset.next()) {
 	  							%>
									<tr>
										<td	valign="top">
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
						<%
						}
						rset.close();
						stmt.close();
						
						%>
						</tr>
						
						
						<%
						//Event Identifier
						if (hasValue(work.getId())) {
						%>
							<tr class="b-185">
								<td align='right' class='general_heading_light f-186' valign="top">Work Identifier</td>
								<td>&nbsp;</td>
								<td valign="top"><%=work.getId()%></td>
							</tr>
						<%
						}
						
						// close statement
						stmt.close();
						%>
						<tr>
							<td>&nbsp;</td>
						</tr>
					</table>
					
					<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>
					<!-- AddThis Button BEGIN -->
					<div align="right" class="addthis_toolbox addthis_default_style ">
						<a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
						<a class="addthis_button_tweet"></a>
						<a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
						<a class="addthis_counter addthis_pill_style"></a>
					</div>
					<script>
						displayRow("events");
						if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
						if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
						if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
					</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<cms:include property="template" element="foot" />

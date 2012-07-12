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

<script type="text/javascript">
	function displayRow(name){
		document.getElementById("organisation").style.display = 'none';
		document.getElementById("organisationbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("contributor").style.display = 'none';
		document.getElementById("contributorbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("events").style.display = 'none';
		document.getElementById("eventsbtn").style.backgroundColor = '#aaaaaa';
	
		document.getElementById(name).style.display = '';
		document.getElementById(name+"btn").style.backgroundColor = '#666666';
	}
</script>

<div class='record'>

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
					ResultSet rsetEvt = null;
					CachedRowSet crsetCon = null;
					CachedRowSet crsetOrg = null;
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
					
					rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
					
					//Works
					%>
					<table class='record-table'>
						<tr>
							<th class='record-label b-153 bold'><img src='../../../resources/images/icon-work.png' class='box-icon'>Work</th>
							
							<td class='record-value bold'><%=work.getName()%>
							<%
							if (groupNames.contains("Administrators") || groupNames.contains("Works Editor"))
							out.println("[<a class='editLink' target='_blank' href='/custom/work_addedit.jsp?action=edit&f_workid=" + work.getId() + "'>Edit</a>]");
							%>
							</td>
							<td class='record-comment'>
							<%
							if (displayUpdateForm) {
							displayUpdateForm(work_id, "Work", work.getName(), out,
							request, ausstage_search_appconstants_for_drill);
							}
							%>
							</td>
						</tr>
						
						<%
						//Alternate Works Names
						if (work.getAlterWorkTitle() != null && !work.getAlterWorkTitle().equals("")) {
						%>
							<tr>
								<th class='record-label b-153'>Alternate Work Name</th>
								
								<td class='record-value bold'><%=work.getAlterWorkTitle()%></td>
							</tr>
						<%
						}

						//Contributors
						rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
						if (rset != null && rset.isBeforeFirst()) {
						%>
							<tr>
								<th class='record-label b-153'>Creator Contributors</th>
								
								<td class='record-value' colspan='2'>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while (rset.next()) {
										if (rset.getString("contributorid") != null) {
										%>
											<tr>
												<td valign="top">
													<a href="/pages/contributor/<%=rset.getString("contributorid")%>">
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
								<th class='record-label b-153'>Organisations</th>
								
								<td class='record-value' colspan='2'>
									<table border="0" cellpadding="0" cellspacing="0">
									<%
									while(rset.next()) {
										if (rset.getString("organisationid") != null) {
										%>
											<tr>
												<td valign="top">
													<a href="/pages/organisation/<%=rset.getString("organisationid")%>">
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
						
						//get associated objects
							ausstage.Database m_db = new ausstage.Database ();
							m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
							
						//events
							
							
						//organisations
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
							crsetOrg = m_db.runSQL(sqlString, stmt);
						//contributors
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
							crsetCon = m_db.runSQL(sqlString, stmt);
							
							rsetEvt = work.getAssociatedEv(Integer.parseInt(work_id), stmt);
							
							if (crsetOrg.size() > 0 || crsetCon.size() > 0 || (rsetEvt != null && rsetEvt.isBeforeFirst())){
							
						%>

						<tr>
							<th class='record-label b-153'></th>
							
							<td class='record-value' id="tabs" colspan=2>
								<ul class='record-tabs label'>
									<li><a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a></li>
									<li><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a></li>   
									<li><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a></li>
								 </ul>
							</td>
						</tr>
						<%
							}
						%>
						<tr id='events'>
							<%
							// Events Tab
							rsetEvt = work.getAssociatedEv(Integer.parseInt(work_id), stmt);
							
							
							if (rsetEvt != null && rsetEvt.isBeforeFirst()) {
							%>
								<th class='record-label b-153'></th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									while (rsetEvt.next()) {
									%>
										<li>
										<a href="/pages/event/<%=rsetEvt.getString("eventid")%>">
											<%=rsetEvt.getString("event_name")%></a><%
										if (hasValue(rsetEvt.getString("Output"))) out.print(", " + rsetEvt.getString("Output").replace(", O/S", ""));
										if (hasValue(formatDate(rsetEvt.getString("DDFIRST_DATE"),rsetEvt.getString("MMFIRST_DATE"),rsetEvt.getString("YYYYFIRST_DATE"))))
											out.print(", " + formatDate(rsetEvt.getString("DDFIRST_DATE"),rsetEvt.getString("MMFIRST_DATE"),rsetEvt.getString("YYYYFIRST_DATE")));
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
						String prevOrg = "";
						if (crsetOrg.size() > 0) {
							%>
							<th class='record-label b-153'></td>
					 		
					 		<td class='record-value' colspan='2'>
							
							<%	
							while (crsetOrg.next()){
								// If we're starting a new contributor, check if we have to finish the previous one
								if (!prevOrg.equals(crsetOrg.getString("name"))) {
									if (hasValue(prevOrg)) out.print("</ul>");
									
									// Now start the new one
									%>
								<h3>
									<a href="/pages/organisation/<%=crsetOrg.getString("organisationid")%>">
										<%=crsetOrg.getString("name")%>
									</a>
								</h3>
								<ul>
									<%
									prevOrg = crsetOrg.getString("name");
								}
								
								%>
									<li>
									<a href="/pages/event/<%=crsetOrg.getString("eventid")%>">
									<%=crsetOrg.getString("event_name")%></a><%
									if(hasValue(crsetOrg.getString("venue_name"))) 
										out.print(", " + crsetOrg.getString("venue_name"));
						  	        if(hasValue(crsetOrg.getString("suburb"))) 
										out.print(", " + crsetOrg.getString("suburb"));
						           	if(hasValue(crsetOrg.getString("state")) && !crsetOrg.getString("state").equals("O/S"))
										out.print(", " + crsetOrg.getString("state"));
									if (hasValue(formatDate(crsetOrg.getString("DDFIRST_DATE"),crsetOrg.getString("MMFIRST_DATE"),crsetOrg.getString("YYYYFIRST_DATE"))))
										out.print(", " + formatDate(crsetOrg.getString("DDFIRST_DATE"),crsetOrg.getString("MMFIRST_DATE"),crsetOrg.getString("YYYYFIRST_DATE")));
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
						//crset.close();
						%>
						</tr>
						
						<tr id='contributor'>
						<%
						//Contributors Tab
						String prevCont = "";
						if (crsetCon.size() > 0) {
						%>
							<th class='record-label b-153'></th>
					 		
					 		<td class='record-value' colspan='2'>
							
							<%	
							while (crsetCon.next()){
								// If we're starting a new contributor, check if we have to finish the previous one
								if (!prevCont.equals(crsetCon.getString("contributorid"))) {
									if (hasValue(prevCont)) out.print("</ul>");
					
									// Now start the new one
									%>
								<h3>
									<a href="/pages/contributor/<%=crsetCon.getString("contributorid")%>">
										<%=crsetCon.getString("contributor_name")%>
									</a>
								</h3>
								<ul>
									<%
									prevCont= crsetCon.getString("contributorid");
								}
								
								%>
									<li>
									<a href="/pages/event/<%=crsetCon.getString("eventid")%>">
										<%=crsetCon.getString("event_name")%></a><%
									if(hasValue(crsetCon.getString("venue_name"))) out.print(", " + crsetCon.getString("venue_name"));
									if(hasValue(crsetCon.getString("suburb"))) out.print(", " + crsetCon.getString("suburb"));
									if(hasValue(crsetCon.getString("state")) && !crsetCon.getString("state").equals("O/S")) out.print(", " + crsetCon.getString("state"));
									if(hasValue(formatDate(crsetCon.getString("DDFIRST_DATE"),crsetCon.getString("MMFIRST_DATE"),crsetCon.getString("YYYYFIRST_DATE"))))
					            		out.print(", " + formatDate(crsetCon.getString("DDFIRST_DATE"),crsetCon.getString("MMFIRST_DATE"),crsetCon.getString("YYYYFIRST_DATE")));
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
						
						<tr>
						<%
						//Resources
						rset = work.getAssociatedItems(Integer.parseInt(work_id), stmt);
						
  	  					if (rset != null && rset.isBeforeFirst()) {
  						%>
					 		<th class='record-label b-153'><a class='record-label' href="#">Resources</a></th>
							
							<td class='record-value' colspan='2'>
								<table id='resources' width="<%=secTableWdth%>" border="0" cellpadding="3" cellspacing="0">
	  	  						<%
	  	  						while (rset.next()) {
 	  							%>
									<tr>
										<td	valign="top"><%=rset.getString("description")%>:&nbsp;
											<a href="/pages/resource/<%=rset.getString("itemid")%>">
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
							<tr >
								<th class='record-label b-153'>Work Identifier</th>
								
								<td class='record-value' colspan='2'><%=work.getId()%></td>
							</tr>
						<%
						}
						
						// close statement
						stmt.close();
						%>
						<tr>
							
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
						<script>
							displayRow("events");
							if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
							if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
							if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
						</script>
</div>
<cms:include property="template" element="foot" />
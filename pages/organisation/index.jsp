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
		document.getElementById("venue").style.display = 'none';
		document.getElementById("venuebtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("organisation").style.display = 'none';
		document.getElementById("organisationbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("contributor").style.display = 'none';
		document.getElementById("contributorbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("events").style.display = 'none';
		document.getElementById("eventsbtn").style.backgroundColor = '#aaaaaa';
	
		document.getElementById(name).style.display = '';
		document.getElementById(name+"btn").style.backgroundColor = '#666666';
	}
	
	function showHide(name) {
		if (document.getElementById(name).style.display != 'none') {
			document.getElementById(name).style.display = 'none';
		} else {
			document.getElementById(name).style.display = ''
		}
	}
</script>

<div class='record'>
						<%
						ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
						db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
						Statement    stmt = db_ausstage_for_drill.m_conn.createStatement();
						
						CachedRowSet crset          = null;
						ResultSet rset;
						String formatted_date       = "";
						String org_id               = request.getParameter("id");
						String location             = "";
				  
						List<String> groupNames = new ArrayList();	
						if (session.getAttribute("userName")!= null) {
							CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
							CmsObject cmsObject = cms.getCmsObject();
							List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
							for(CmsGroup group:userGroups) {
								groupNames.add(group.getName());
							}
						}
				
						State state = new State(db_ausstage_for_drill);
						Event event = null;
						
						Country country;
						OrgEvLink orgEvLink;
						Organisation organisation;
						Organisation organisationCreator = null;
						
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
				
				
						///////////////////////////////////
						//    DISPLAY ORGANISATION DETAILS
						//////////////////////////////////
						
						organisation = new Organisation(db_ausstage_for_drill);
						organisation.load(Integer.parseInt(org_id));
						country = new Country(db_ausstage_for_drill);

						//Name
						%>
						<table class='record-table'>
							<tr>
							<th class='record-label b-121 bold'><img src='../../../resources/images/icon-organisation.png' class='box-icon'>Organisation Name</th>
							
							<td class='record-value bold' > <%=organisation.getName()%>
							<%
								if (groupNames.contains("Administrators") || groupNames.contains("Organisation Editor"))
								out.println("[<a class='editLink' target='_blank' href='/custom/organisation_addedit.jsp?act=edit&f_selected_organisation_id=" + organisation.getId() + "'>Edit</a>]");
							%>
							</td>
							<td valign='top' rowspan=2>
							<%
								if (displayUpdateForm) {
								displayUpdateForm(org_id, "Organisation", organisation.getName(), out,
								request, ausstage_search_appconstants_for_drill);
								}
							%>
							</td>
						</tr>
						<%
						
						//Other Names
						if (hasValue(organisation.getOtherNames1()) || hasValue(organisation.getOtherNames2()) || hasValue(organisation.getOtherNames3())) {
						%>
							<tr>
								<th class='record-label b-121'>Other names</th>
								
								<td class='record-value' colspan=2>
									<div><%=organisation.getOtherNames1()%></div>
									<div><%=organisation.getOtherNames2()%></div>
									<div><%=organisation.getOtherNames3()%></div>
								</td>
							</tr>
						<%
						}
				
						//Address
						%>
						<tr>
							<th class='record-label b-121'>Address</th>
							
							<td class='record-value'><%=organisation.getAddress()%>
				    		<%
							if (hasValue(organisation.getAddress()) && (hasValue(organisation.getSuburb()) || hasValue(organisation.getStateName()) || hasValue(organisation.getPostcode())))
								out.print("<br>");
							if (hasValue(organisation.getSuburb())) 
								out.print(organisation.getSuburb() + " ");
							if (hasValue(organisation.getStateName())) 
								out.print(organisation.getStateName() + " ");
							if (hasValue(organisation.getPostcode()))
								out.print(organisation.getPostcode());
							
							if(hasValue(organisation.getCountry())){
								country.load(Integer.parseInt(organisation.getCountry()));
								out.println("   <br>" +  country.getName() + "");
							}
							%>
							</td>
						</tr>
						<%
							
						//Website
						if (hasValue(organisation.getWebLinks())) {
						%>
							<tr>
								<th class='record-label b-121'>Website</th>
								
								<td class='record-value'>
									<a href="<%=(organisation.getWebLinks().indexOf("http://") < 0)?"http://":""%><%=organisation.getWebLinks()%>">
										<%=organisation.getWebLinks()%>
									</a>
									<br>
									<script type="text/javascript" src="http://www.shrinktheweb.com/scripts/pagepix.js"></script>
									<script type="text/javascript">
										stw_pagepix('<%=(organisation.getWebLinks().indexOf("http://") < 0)?"http://":""%><%=organisation.getWebLinks()%>', 'afcb2483151d1a2', 'sm', 0);
										var anchorElements = document.getElementsByTagName('a');
										for (var i in anchorElements) {
											if (anchorElements[i].href.indexOf("shrinktheweb") != -1 || anchorElements[i].href == document.getElementById('url').href){
												anchorElements[i].onmousedown = function() {}
												anchorElements[i].href = document.getElementById('url').href;
											}
										}
									</script>
								</td>
							</tr>
						<%
						}
				   
						//Functions
						if (hasValue(organisation.getFunction(Integer.parseInt(org_id)))) {
						%>
							<tr>
								<th class='record-label b-121'>Functions</th>
								
								<td class='record-value'><%=organisation.getFunction(Integer.parseInt(org_id))%></td>
							</tr>
						<%
						}
						
						//NLA
						if(hasValue(organisation.getNLA())) {
						%>
							<tr >
								<th class='record-label b-121'>NLA</th>
								
								<td class='record-value'><%=organisation.getNLA()%></td>
							</tr>
						<%
						}
						
						//Notes
						if(hasValue(organisation.getNotes())) {
						%>
							<tr>
								<th class='record-label b-121'>Notes</th>
								
								<td class='record-value'><%=organisation.getNotes()%></td>
							</tr>
						<%
						}
					%>  
				
					<tr>
						<th class='record-label b-121'></td>
						
						<td class='record-value' id="tabs" colspan=2>
							<ul class='record-tabs label'>
								<li><a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a></li>
								<li><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a></li>   
								<li><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a></li> 	
								<li><a href="#" onclick="displayRow('venue')" id='venuebtn'>Venues</a></li>
							</ul>
						</td>
					</tr>
				    
				    <tr id='events'>
					<%
				    // Events Tab
					ausstage.Database     m_db = new ausstage.Database ();
					m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
					event = new Event(db_ausstage_for_drill);
					crset = event.getEventsByOrg(Integer.parseInt(org_id));
					
					if (crset.size() > 0) {
					%>
							<th class='record-label b-121'></th>
							
							<td class='record-value'>
								<ul>
								<%
								while(crset.next()) {
								%>
									<li>
									<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
					            		<%=crset.getString("event_name")%></a><%
										if(hasValue(crset.getString("venue_name"))) out.print(", " + crset.getString("venue_name"));
										if(hasValue(crset.getString("suburb"))) out.print(", " + crset.getString("suburb")); 
										if(hasValue(crset.getString("state"))) out.print(", " + crset.getString("state")); 
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
				    %>
				    </tr>
				    
				    <tr id='organisation'>
				    <%
					//Organisation Tab
				
					String sqlString = 
					"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
					"events.first_date,venue.venue_name,venue.suburb,states.state,organisation.organisationid,organisation.name,evcount.num "+
					"FROM events,venue,states,organisation,orgevlink oe2,orgevlink "+
					"inner join (SELECT oe.organisationid, count(distinct oe.eventid) num "+
					"FROM orgevlink oe, orgevlink oe2 where oe2.eventid=oe.eventid and oe2.organisationid=" + org_id + " "+
					"group by oe.organisationid) evcount ON (evcount.organisationid = orgevlink.organisationid) "+
					"WHERE oe2.organisationid = " + org_id + " AND "+
					"orgevlink.organisationid != " + org_id + " AND "+
					"oe2.eventid = events.eventid AND "+
					"events.venueid = venue.venueid AND "+
					"venue.state = states.stateid AND "+
					"events.eventid = orgevlink.eventid AND "+
					"orgevlink.organisationid = organisation.organisationid "+
					"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
					crset = m_db.runSQL(sqlString, stmt);
				 
					String prevOrg = "";
					if (crset.size() > 0) {
						%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%	
						while (crset.next()){
							// If we're starting a new organisation, check if we have to finish the previous one
							if (!prevOrg.equals(crset.getString("name"))) {
								if (hasValue(prevOrg)) out.print("</ul>");
								
								// Now start the new one
								%>
							<a href="/pages/organisation/?id=<%=crset.getString("organisationid")%>">
								<h3><%=crset.getString("name")%></h3>
							</a>
							<ul>
								<%
								prevOrg = crset.getString("name");
							}
							
							%>
								<li>
								<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
								<%=crset.getString("event_name")%></a><%
								if(hasValue(crset.getString("venue_name"))) out.print(", " + crset.getString("venue_name"));
								if(hasValue(crset.getString("suburb"))) out.print(", " + crset.getString("suburb"));
								if(hasValue(crset.getString("state"))) out.print(", " + crset.getString("state"));
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
					
					<tr id='venue'>
					<%
					//Venue Tab
					
					sqlString = 
					"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
					"events.first_date,venue.venueid,venue.venue_name,venue.suburb,states.state,organisation.organisationid,organisation.name,evcount.num "+
					"FROM events,venue,states,organisation,orgevlink "+
					"inner join (SELECT events.venueid, count(distinct orgevlink.eventid) num "+
					"FROM orgevlink, events where orgevlink.eventid=events.eventid and orgevlink.organisationid=" + org_id + " "+
					"GROUP BY events.venueid) evcount "+
					"WHERE orgevlink.organisationid = " + org_id + " AND "+
					"evcount.venueid = events.venueid AND "+
					"orgevlink.eventid = events.eventid AND "+
					"events.venueid = venue.venueid AND "+
					"venue.state = states.stateid AND "+
					"events.eventid = orgevlink.eventid AND "+
					"orgevlink.organisationid = organisation.organisationid "+
					"ORDER BY evcount.num desc,venue.venue_name,events.first_date DESC";
					crset = m_db.runSQL(sqlString, stmt);
				 
					String prevVen = "";
					if (crset.size() > 0) {
					%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%
						while (crset.next()) {
							// If we're starting a new venue, check if we have to finish the previous one
							if (!prevVen.equals(crset.getString("venueid"))) {
								if (hasValue(prevVen)) out.print("</ul>");
								
								// Now start the new one
								%>
								<h3>
								<a href="/pages/venue/?id=<%=crset.getString("venueid")%>">
									<%=crset.getString("venue_name")%></a><%
								if(hasValue(crset.getString("suburb"))) 
									out.print(", " + crset.getString("suburb"));
								if(hasValue(crset.getString("state")))
									out.print(", " + crset.getString("state"));
								%>
								</h3>
								<ul>
									<%
									prevVen = crset.getString("venueid");
								}
								
								%>
									<li>
									<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
										<%=crset.getString("event_name")%>
									</a><%
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
				
					%>
					</tr>
					
					<tr id='contributor'>
					<%
				    //Contributor Tab
					
					sqlString	= "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
								"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
								"venue.venue_name,venue.suburb,states.state,evcount.num " +
								"FROM events,venue,states,orgevlink,conevlink,contributor " +
								"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
								"FROM conevlink, orgevlink where orgevlink.eventid=conevlink.eventid and orgevlink.organisationid=" + org_id + " " +
								"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
								"WHERE orgevlink.organisationid = " + org_id + " AND " +
								"orgevlink.eventid = events.eventid AND " +
								"events.venueid = venue.venueid AND " +
								"venue.state = states.stateid AND " +
								"events.eventid = orgevlink.eventid AND " +
								"orgevlink.eventid=conevlink.eventid AND " +
								"conevlink.contributorid = contributor.contributorid " +
								"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
					crset = m_db.runSQL(sqlString, stmt);
					
					String prevCont = "";
					if (crset.size() > 0) {
					%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%	
						while (crset.next()){
							// If we're starting a new contributor, check if we have to finish the previous one
							if (!prevCont.equals(crset.getString("contributorid"))) {
								if (hasValue(prevCont)) out.print("</ul>");
				
								// Now start the new one
								%>
							<a href="/pages/contributor/?id=<%=crset.getString("contributorid")%>">
								<h3><%=crset.getString("contributor_name")%></h3>
							</a>
							<ul>
								<%
								prevCont= crset.getString("contributorid");
							}
							
							%>
								<li>
								<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
									<%=crset.getString("event_name")%>
								</a><%
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
					
					<%
					//Works
					rset = organisation.getAssociatedWorks(Integer.parseInt(org_id), stmt);
					if(rset != null && rset.isBeforeFirst()) {
					%>
					<tr >
						<th class='record-label b-121'>
							<a class='f-186' href="#" onclick="showHide('works')">Works</a>
							<table id='works' width="<%=secTableWdth %>" border="0" cellpadding="0" cellspacing="0">
							<%
							while(rset.next()) {
							%>
								<tr>
									<td width="<%=secCol1Wdth%>" valign="top">
										<a href="/pages/work/?id=<%=rset.getString("workid")%>">
											<%=rset.getString("work_title")%>
										</a>
									</td>
								</tr>
							<%  
							}
							%>
							</table>
						</th>
					</tr>
					<%
					}
					
					
					//Resources
					rset = organisation.getAssociatedItems(Integer.parseInt(org_id), stmt);
					if(rset != null && rset.isBeforeFirst()) {
					%>
						<tr>
					 		<th class='record-label b-121'><a class='f-186' href="#" onclick="showHide('resources')">Resources</a></th>
							
							<td class='record-value'>
								<table id='resources' width="<%=secTableWdth%>" border="0" cellpadding="3" cellspacing="0">
								<%
								while(rset.next()) {
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
						</tr>
					<%
					}		
					
					//Organisation ID
					%>
					<tr>
						<th class='record-label b-121'>Organisation Identifier</th>
						
						<td class='record-value'><%=organisation.getId()%></td>
					</tr>	
					
					<%
					// close statement
					stmt.close();
					%>
					<!--<tr>
						<td>-->
							<!--<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>-->
							<!-- AddThis Button BEGIN -->
							<!--<div align="right" class="addthis_toolbox addthis_default_style ">
								<a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
								<a class="addthis_button_tweet"></a>
								<a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
								<a class="addthis_counter addthis_pill_style"></a>
							</div>-->
							<script>displayRow("events");
								if (!document.getElementById("venue").innerHTML.match("[A-Za-z]")) document.getElementById("venuebtn").style.display = "none";
								if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
								if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
								if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
							</script>
							
</div>
<cms:include property="template" element="foot" />
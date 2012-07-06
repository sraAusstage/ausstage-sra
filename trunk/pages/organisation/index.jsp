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
						CachedRowSet crsetEvt       = null;
						CachedRowSet crsetCon       = null;
						CachedRowSet crsetOrg       = null;
						CachedRowSet crsetVen       = null;
						
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
								out.println("[<a class='editLink' target='_blank' href='/custom/organisation_addedit.jsp?action=edit&f_organisation_id=" + organisation.getId() + "'>Edit</a>]");
							%>
							</td>
							<td rowspan=20 class='record-comment'>
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
						//get associated objects
						
						//events
						ausstage.Database     m_db = new ausstage.Database ();
						m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
						event = new Event(db_ausstage_for_drill);
						crsetEvt = event.getEventsByOrg(Integer.parseInt(org_id));
						
						//Organisations
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
						crsetOrg = m_db.runSQL(sqlString, stmt);						
						
						//venues
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
						crsetVen = m_db.runSQL(sqlString, stmt);
						
						//contributors
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
						crsetCon = m_db.runSQL(sqlString, stmt);
						
						if (crsetEvt.size() > 0 || crsetOrg.size() > 0 || crsetCon.size() > 0 || crsetVen.size() > 0){												
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
				    <%
				    	}
				    %>
				    <tr id='events'>
					<%
					
				    // Events Tab	
					if (crsetEvt.size() > 0) {
					%>
							<th class='record-label b-121'></th>
							
							<td class='record-value'>
								<ul>
								<%
								while(crsetEvt.next()) {
								%>
									<li>
									<a href="/pages/event/<%=crsetEvt.getString("eventid")%>">
					            		<%=crsetEvt.getString("event_name")%></a><%
										if(hasValue(crsetEvt.getString("venue_name"))) out.print(", " + crsetEvt.getString("venue_name"));
										if(hasValue(crsetEvt.getString("suburb"))) out.print(", " + crsetEvt.getString("suburb")); 
										if(hasValue(crsetEvt.getString("state"))) out.print(", " + crsetEvt.getString("state")); 
										if (hasValue(formatDate(crsetEvt.getString("DDFIRST_DATE"),crsetEvt.getString("MMFIRST_DATE"),crsetEvt.getString("YYYYFIRST_DATE"))))
											out.print(", " + formatDate(crsetEvt.getString("DDFIRST_DATE"),crsetEvt.getString("MMFIRST_DATE"),crsetEvt.getString("YYYYFIRST_DATE")));
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
					String prevOrg = "";
					if (crsetOrg.size() > 0) {
						%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%	
						while (crsetOrg.next()){
							// If we're starting a new organisation, check if we have to finish the previous one
							if (!prevOrg.equals(crsetOrg.getString("name"))) {
								if (hasValue(prevOrg)) out.print("</ul>");
								
								// Now start the new one
								%>
							<a href="/pages/organisation/<%=crsetOrg.getString("organisationid")%>">
								<h3><%=crsetOrg.getString("name")%></h3>
							</a>
							<ul>
								<%
								prevOrg = crsetOrg.getString("name");
							}
							
							%>
								<li>
								<a href="/pages/event/<%=crsetOrg.getString("eventid")%>">
								<%=crsetOrg.getString("event_name")%></a><%
								if(hasValue(crsetOrg.getString("venue_name"))) out.print(", " + crsetOrg.getString("venue_name"));
								if(hasValue(crsetOrg.getString("suburb"))) out.print(", " + crsetOrg.getString("suburb"));
								if(hasValue(crsetOrg.getString("state"))) out.print(", " + crsetOrg.getString("state"));
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
					
					<tr id='venue'>
					<%
					//Venue Tab				 
					String prevVen = "";
					if (crsetVen.size() > 0) {
					%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%
						while (crsetVen.next()) {
							// If we're starting a new venue, check if we have to finish the previous one
							if (!prevVen.equals(crsetVen.getString("venueid"))) {
								if (hasValue(prevVen)) out.print("</ul>");
								
								// Now start the new one
								%>
								<h3>
								<a href="/pages/venue/<%=crsetVen.getString("venueid")%>">
									<%=crsetVen.getString("venue_name")%></a><%
								if(hasValue(crsetVen.getString("suburb"))) 
									out.print(", " + crsetVen.getString("suburb"));
								if(hasValue(crsetVen.getString("state")))
									out.print(", " + crsetVen.getString("state"));
								%>
								</h3>
								<ul>
									<%
									prevVen = crsetVen.getString("venueid");
								}
								
								%>
									<li>
									<a href="/pages/event/<%=crsetVen.getString("eventid")%>">
										<%=crsetVen.getString("event_name")%>
									</a><%
									if (hasValue(formatDate(crsetVen.getString("DDFIRST_DATE"),crsetVen.getString("MMFIRST_DATE"),crsetVen.getString("YYYYFIRST_DATE"))))
										out.print(", " + formatDate(crsetVen.getString("DDFIRST_DATE"),crsetVen.getString("MMFIRST_DATE"),crsetVen.getString("YYYYFIRST_DATE")));
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
					String prevCont = "";
					if (crsetCon.size() > 0) {
					%>
						<th class='record-label b-121'></td>
				 		
				 		<td class='record-value'>
						
						<%	
						while (crsetCon.next()){
							// If we're starting a new contributor, check if we have to finish the previous one
							if (!prevCont.equals(crsetCon.getString("contributorid"))) {
								if (hasValue(prevCont)) out.print("</ul>");
				
								// Now start the new one
								%>
							<a href="/pages/contributor/<%=crsetCon.getString("contributorid")%>">
								<h3><%=crsetCon.getString("contributor_name")%></h3>
							</a>
							<ul>
								<%
								prevCont= crsetCon.getString("contributorid");
							}
							
							%>
								<li>
								<a href="/pages/event/<%=crsetCon.getString("eventid")%>">
									<%=crsetCon.getString("event_name")%>
								</a><%
								if(hasValue(crsetCon.getString("suburb"))) out.print(", " + crsetCon.getString("suburb"));
								if(hasValue(crsetCon.getString("state"))) out.print(", " + crsetCon.getString("state"));
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
					
					<%
					//Works
					rset = organisation.getAssociatedWorks(Integer.parseInt(org_id), stmt);
					if(rset != null && rset.isBeforeFirst()) {
					%>
					<tr >
						<th class='record-label b-121'>
							<a class='f-186' href="#" onclick="showHide('works')">Works</a>
						</th>
						<td class='record-value'>
							<table id='works' width="<%=secTableWdth %>" border="0" cellpadding="0" cellspacing="0">
							<%
							while(rset.next()) {
							%>
								<tr>
									<td width="<%=secCol1Wdth%>" valign="top">
										<a href="/pages/work/<%=rset.getString("workid")%>">
											<%=rset.getString("work_title")%>
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
				</table>
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
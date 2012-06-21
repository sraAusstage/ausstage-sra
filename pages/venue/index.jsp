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
					ResultSet rset;
					Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
					String formatted_date = "";
					String event_id = request.getParameter("f_event_id");
					String venue_id = request.getParameter("id");
					String location = "";
					
					State state = new State(db_ausstage_for_drill);
					Event event = null;
					
					Venue venue = null;
					Country country;
					
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
					//    DISPLAY VENUE DETAILS
					//////////////////////////////////
					venue = new Venue(db_ausstage_for_drill);
					venue.load(Integer.parseInt(venue_id));
					event = new Event(db_ausstage_for_drill);
					Country venueCountry = new Country(db_ausstage_for_drill);
					if (!venue.getCountry().equals("")) {
						venueCountry.load(Integer.parseInt(venue.getCountry()));
					}
		
					//Venue
					%>
					<table class='record-table'>
						<tr>
							<th class='record-label b-134 bold'><img src='../../../resources/images/icon-venue.png' class='box-icon'>Venue Name</th>
							
							<td class='record-value bold'><%=venue.getName()%>
							<%
							 if (groupNames.contains("Administrators") || groupNames.contains("Venue Editor"))
								out.println("[<a class='editLink' target='_blank' href='/custom/venue_addedit.jsp?f_selected_venue_id=" + venue.getVenueId() + "'>Edit</a>]");
							%>
							</td>
							<td rowspan=2>
							<%
							if (displayUpdateForm) {
								displayUpdateForm(venue_id, "Venue", venue.getName(), out,
								request, ausstage_search_appconstants_for_drill);
							}
							%>
						</tr>
						
						<tr >
							<th class='record-label b-134' >Address</th>
							
							<td class='record-value'>
							<%
								Vector locationVector = new Vector();
								locationVector.addElement(venue.getStreet());
								String addressLine2 = "";
								addressLine2 = venue.getSuburb() + " " + state.getName(Integer.parseInt(venue.getState())) + " " + venue.getPostcode();
								locationVector.addElement(addressLine2);
								if (!venue.getCountry().equals("")) {
								  locationVector.addElement(venueCountry.getName());
								}
								%>
								<%=concatFields(locationVector, "<br> ")%>
							</td>
						</tr>
						
						<%
						//website
						if (hasValue(venue.getWebLinks())) {
						%>
							<tr>
								<th class='record-label b-134' >Website</th>
								
								<td class='record-value'>
									<a href="<%=(venue.getWebLinks().indexOf("http://") < 0)?"http://":""%><%=venue.getWebLinks()%>">
										<%=venue.getWebLinks()%>
									</a>
									<br>
									<script type="text/javascript" src="http://www.shrinktheweb.com/scripts/pagepix.js"></script>
									<script type="text/javascript">
										stw_pagepix('<%
										if(venue.getWebLinks().indexOf("http://") < 0)
										out.print("http://");
										%><%=venue.getWebLinks()%>', 'afcb2483151d1a2', 'sm', 0);
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
						
						//Latitude
						if (hasValue(venue.getLatitude()) && hasValue(venue.getLongitude())) {
						%>
							<tr>
								<th class='record-label b-134' >Latitude | Longitude</th>
								
								<td class='record-value'><%=venue.getLatitude()%> | <%=venue.getLongitude()%></td>
							</tr>

							<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
							<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
							<script type="text/javascript" language="javascript">
								$(document).ready(function() {
								
								function initialize() {
									var myLatlng = new google.maps.LatLng(<%=venue.getLatitude()%>,<%=venue.getLongitude()%>);
									var myOptions = {
									zoom: 14,
									center: myLatlng,
									mapTypeId: 'ausstage'
								}
								
								var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
								
								mapStyle = [ { featureType: "all", elementType: "all", stylers: [ { visibility: "off" } ]},
									{ featureType: "water", elementType: "geometry", stylers: [ { visibility: "on" }, { lightness: 40 }, { saturation: 0 } ] },
									{ featureType: "landscape", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 } ]},
									{ featureType: "road", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 }, { lightness: 40 } ] },
									{ featureType: "transit", elementType: "geometry", stylers: [ { saturation: -100 }, { lightness: 40 } ] } 
									];
								
								var styledMapOptions = {map: map, name: "AusStage",	alt: 'Show AusStage styled map' };
								var ausstageStyle    = new google.maps.StyledMapType(mapStyle, styledMapOptions);
								
								map.mapTypes.set('ausstage', ausstageStyle);
								map.setMapTypeId('ausstage');
								
								var marker = new google.maps.Marker({
									position: myLatlng,
									map: map,
									title:  '<%=venue.getName().replaceAll("'","")%>'
								});
								
								}
								
								initialize();
	
								});
 							</script>
						    
						    <tr>
								<th class='record-label b-134' >Map</th>
								
								<td class='record-value'>
									<div id="map_canvas" style="width:100%;height:300px;"></div>
								</td>
							</tr>
						<%
						}

						//Radius
						if (venue.getRadius() != null && !venue.getRadius().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Radius</th>
								
								<td class='record-value'><%=venue.getRadius()%></td>
							</tr>
						<%
						}
    
						//Elevation
						if (venue.getElevation() != null && !venue.getElevation().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Elevation</td>
								
								<td class='record-value'><%=venue.getElevation()%></td>
							</tr>
						<%
						}
						   
						//Notes
						if (venue.getNotes() != null && !venue.getNotes().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Notes</td>
								
								<td class='record-value'><%=venue.getNotes()%></td>
							</tr>
						<%
						}
						%>


						<tr>
							<th class='record-label b-134' ></th>
							
							<td class="record-value" id="tabs" colspan=3>
								<ul class="record-tabs label">
									<li><a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a></li>
									<li><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a></li>   
									<li><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a></li>
								</ul> 
							</td>
						</tr>
						
						<tr id='events'>
						<%
						//Events Tab
						ausstage.Database m_db = new ausstage.Database ();
						m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
						
						event = new Event(db_ausstage_for_drill);
						crset = event.getEventsByVenue(Integer.parseInt(venue_id));
						int orgEventCount = 0;
						
						if (crset.size() > 0) {
						%>
							<th class='b-134' ></th>
							
							<td class='record-value'>
								<ul>
								<%
								while (crset.next()) {
									%>
									<li>
									<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
										<%=crset.getString("event_name")%>
									</a><%
									if (hasValue(crset.getString("DDFIRST_DATE")) || hasValue(crset.getString("MMFIRST_DATE")) || hasValue(crset.getString("YYYYFIRST_DATE")))
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
						//Organisations Tab
						String sqlString = 
						"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
						"events.first_date,organisation.organisationid,organisation.name,evcount.num " +
						"FROM events,organisation,orgevlink " +
						"inner join (SELECT orgevlink.organisationid, count(distinct orgevlink.eventid) num " +
						"FROM orgevlink, events where orgevlink.eventid=events.eventid and events.venueid=" + venue_id + " " +
						"GROUP BY orgevlink.organisationid) evcount ON (evcount.organisationid = orgevlink.organisationid) " +
						"WHERE events.venueid = " + venue_id + " AND " +
						"orgevlink.eventid = events.eventid AND " +
						"orgevlink.organisationid = organisation.organisationid " +
						"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
						crset = m_db.runSQL(sqlString, stmt);
						
						String prevOrg = "";
						if (crset.size() > 0) {
							%>
							<th class='b-134' ></th>
					 		
					 		<td class='record-value'>
							
							<%	
							while (crset.next()){
								// If we're starting a new contributor, check if we have to finish the previous one
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
						//contributors
						sqlString = "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
						"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
						"venue.venue_name,venue.suburb,states.state,evcount.num " +
						"FROM events,venue,states,conevlink,contributor " +
						"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
						"FROM conevlink, events where events.eventid=conevlink.eventid and events.venueid=" + venue_id + " " +
						"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
						"WHERE events.venueid = " + venue_id + " AND " +
						"events.venueid = venue.venueid AND " +
						"venue.state = states.stateid AND " +
						"events.eventid=conevlink.eventid AND " +
						"conevlink.contributorid = contributor.contributorid " +
						"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
						crset = m_db.runSQL(sqlString, stmt);
						
						String prevCont = "";
						if (crset.size() > 0) {
						%>
							<th class='b-134' ></th>
					 		
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
						
						<tr class="b-185">
  	  					<%
    
						//Resources Tab
						rset = venue.getAssociatedItems(Integer.parseInt(venue_id), m_db.m_conn.createStatement());
						
  	  					if (rset != null && rset.isBeforeFirst()) {
  						%>
					 		<td align='right' class='general_heading_light f-186' valign='top'><a class='f-186' href="#" onclick="showHide('resources')">Resources</a></td>
							
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
						
						<tr>
							<th class='record-label b-134' >Venue Identifier</th>
							
							<td class='record-value'><%=venue.getVenueId()%></td>
						</tr>
						
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
					<script>displayRow("events");
						if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
						if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
						if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
					</script>
					
</div>
<cms:include property="template" element="foot" />
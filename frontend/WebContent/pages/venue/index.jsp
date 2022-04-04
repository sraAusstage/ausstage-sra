<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
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
<%@ page import = "ausstage.Exhibition"%>

<%@ page session="true" import=" java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<%
admin.AppConstants appConstants = new admin.AppConstants(request);
%>
<jsp:include page="../../templates/header.jsp" />

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
					if (session.getAttribute("userName")!= null) {
						admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
					  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
					}
					
					CachedRowSet crset          = null;
					CachedRowSet crsetEvt       = null;
					CachedRowSet crsetOrg       = null;
					CachedRowSet crsetCon       = null;
					
					ResultSet rset;
					Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
					String formatted_date = "";
					String event_id = request.getParameter("f_event_id");
					String venue_id = db_ausstage_for_drill.plSqlSafeString(request.getParameter("id"));
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
		

				    Venue assocVenue = null;
				    Vector venue_venuelinks = venue.getVenueVenueLinks();
					if(venue_venuelinks.size() > 0){assocVenue = new Venue(db_ausstage_for_drill);}
					
					
					//Venue
					%>
					<table class='record-table'>
						<tr>
							<th class='record-label b-134 bold'><img src='../../../resources/images/icon-venue.png' class='box-icon'>Venue</th>
							
							<td class='record-value bold'><%=venue.getName()%>
							<%
							 if (groupNames.contains("Administrators") || groupNames.contains("Venue Editor"))
								out.println("[<a class='editLink' target='_blank' href='/custom/venue_addedit.jsp?action=edit&f_selected_venue_id=" + venue.getVenueId() + "'>Edit</a>]");
							%>
							</td>
							<td  class='record-comment'>
							<%
							if (groupNames.contains("Administrators") || groupNames.contains("Exhibition Editor")) {%>		 		
							<jsp:include page="../exhibition/add-to-exhibition.jsp" >
								<jsp:param name="venueid" value="<%= venue_id%>"></jsp:param>
							</jsp:include>
							<%}
							if (displayUpdateForm) {
								displayUpdateForm(venue_id, "Venue", venue.getName(), out,
								request, ausstage_search_appconstants_for_drill);
							}
							%>
						</tr>
						<%

						//Other Names
						if (hasValue(venue.getOtherNames1())) {
						%>
							<tr >
								<th class='record-label b-134' >Other Names</td>
								<td class='record-value' colspan='2'>
								<%=venue.getOtherNames1()%>
								<%=hasValue(venue.getOtherNames2())?"<br>" + venue.getOtherNames2():"" %>
								<%=hasValue(venue.getOtherNames3())?"<br>" + venue.getOtherNames3():"" %>
								</td>
							</tr>
						<%
						}
						%>
						
						<tr >
							<th class='record-label b-134' >Address</th>
							
							<td class='record-value' colspan='2'>

						 	<%
								Vector locationVector = new Vector();
								locationVector.addElement(venue.getStreet());
								String addressLine2 = "";
								String addressState = "";
								if (Integer.parseInt(venue.getState()) < 9 ) addressState = state.getName(Integer.parseInt(venue.getState())); // O/S=9 [Unknown]=10
								addressLine2 = venue.getSuburb() + " " + addressState + " " + venue.getPostcode();
								if (!addressLine2.trim().equals(""))
								locationVector.addElement(addressLine2);
								if (!venue.getCountry().equals("")) {
								  locationVector.addElement(venueCountry.getName());
								}
								%>
							<%=concatFields(locationVector, "<br> ")%> 
							
												
								
							</td>
						</tr>
						<!-- first and last dates -->
						<%
						if (!formatDate(venue.getDdfirstDate(), venue.getMmfirstDate(), venue.getYyyyfirstDate()).equals("")) {
						%>
							<tr>
								<th class='record-label b-134'>First Date</th>
					
								<td class='record-value' colspan='2'><%=formatDate(venue.getDdfirstDate(), venue.getMmfirstDate(), venue.getYyyyfirstDate())%></td>
							</tr>
						<%
						}
						%>						<%
						if (!formatDate(venue.getDdlastDate(), venue.getMmlastDate(), venue.getYyyylastDate()).equals("")) {
						%>
							<tr>
								<th class='record-label b-134'>Last Date</th>
					
								<td class='record-value' colspan='2'><%=formatDate(venue.getDdlastDate(), venue.getMmlastDate(), venue.getYyyylastDate())%></td>
							</tr>
						<%
						}
						%>

						<%
						//website
						if (hasValue(venue.getWebLinks())) {
						%>
							<tr>
								<th class='record-label b-134' >Website</th>
								
								<td class='record-value' colspan='2'>
									<a href="<%=(venue.getWebLinks().indexOf("http") < 0)?"http://":""%><%=venue.getWebLinks()%>" target="_blank">
										<%=venue.getWebLinks()%>
									</a>
								</td>
							</tr>
            			<%
   						}
						
						//Notes
						if (venue.getNotes() != null && !venue.getNotes().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Notes</td>
								
								<td class='record-value' colspan='2'><%=venue.getNotes()%></td>
							</tr>
						<%
						}
						 

						 // Related Venues
						if (assocVenue != null && venue_venuelinks.size() > 0) {
							%>
							<tr>
								<th class='record-label b-134'>Related Venues</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (VenueVenueLink venueVenueLink : (Vector <VenueVenueLink>) venue_venuelinks) {
										boolean isParent = true;
										if (venue_id.equals(venueVenueLink.getChildId())){
											isParent = false;
											assocVenue.load(new Integer(venueVenueLink.getVenueId()).intValue());
										}else{
											assocVenue.load(new Integer(venueVenueLink.getChildId()).intValue());
										}
										RelationLookup lookUpCode = new RelationLookup(db_ausstage_for_drill);
										if (venueVenueLink.getRelationLookupId()!=null) lookUpCode.load(Integer.parseInt(venueVenueLink.getRelationLookupId()));
										%>
										<li>
												<%=(isParent)?lookUpCode.getParentRelation():lookUpCode.getChildRelation() %>
												<%
												out.print("<a href=\"/pages/venue/"+assocVenue.getVenueId()+"\">"+assocVenue.getName()+"</a>&nbsp;");
												//String datesRange = assocVenue.getVenueEvtDateRange(Integer.parseInt(assocVenue.getVenueId()), stmt);
												//if (datesRange!=null && !datesRange.equals("")){
												//	out.print(", "+datesRange);
												//}
												//JIRA AUS-76 out.print(". ");;
												if (isParent){
													if (!venueVenueLink.getNotes().equals("")) out.print(venueVenueLink.getNotes());
												} else {
													if (!venueVenueLink.getChildNotes().equals("")) out.print(venueVenueLink.getChildNotes());
												}
												
												%>
												
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
							<%
						}
						 
						 
						//Latitude
						if (hasValue(venue.getLatitude()) && hasValue(venue.getLongitude())) {
						%>
							


							<script type="text/javascript" src="//maps.google.com/maps/api/js?key=<%=appConstants.GOOGLE_KEY%>"></script>
							<script type="text/javascript" language="javascript">
							$(document).ready(function() {
								
								function initialize() {
									var myLatlng = new google.maps.LatLng(<%=venue.getLatitude()%>,<%=venue.getLongitude()%>);
									var myOptions = {
									zoom: 14,
									center: myLatlng,
                  							mapTypeControl: true,
							                mapTypeControlOptions: {
							                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 
				        		                             google.maps.MapTypeId.SATELLITE, 
                                						     google.maps.MapTypeId.HYBRID, 
						                                     google.maps.MapTypeId.TERRAIN, 
					             		                     'ausstage']
                  							}
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
									title:  '<%=venue.getName().replaceAll("\'","")%>',
									icon: "/pages/assets/images/iconography/venue-arch-134-pointer.png"
								});
								
								}
								try {
									initialize();
								}
								catch(err){
									$('#map_canvas').parent().append('<i>Google Maps temporarily unavailable. ERROR: '+err.message+'</i>');
									$('#map_canvas').hide();
								}
	
							});
 							</script>
						    
						    <tr>
								<th class='record-label b-134' >Map</th>
								
								<td class='record-value' colspan='2'>
									<div id="map_canvas" style="width:100%;height:300px;"></div>
								</td>
							</tr>
							<tr>
								<th class='record-label b-134' >Latitude | Longitude</th>
								
								<td class='record-value' colspan='2'><%=venue.getLatitude()%> | <%=venue.getLongitude()%></td>
							</tr>
						<%
						
						
						}

						//Radius
						if (venue.getRadius() != null && !venue.getRadius().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Radius</th>
								
								<td class='record-value' colspan='2'><%=venue.getRadius()+" metres"%></td>
							</tr>
						<%
						}
    
						//Elevation
						if (venue.getElevation() != null && !venue.getElevation().equals("")) {
						%>
							<tr >
								<th class='record-label b-134' >Elevation</td>
								
								<td class='record-value' colspan='2'><%=venue.getElevation()+" metres"%></td>
							</tr>
						<%
						}
						
						//get event data
						ausstage.Database m_db = new ausstage.Database ();
						m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
						
						event = new Event(db_ausstage_for_drill);
						crsetEvt = event.getEventsByVenue(Integer.parseInt(venue_id));
						int orgEventCount = 0;
						
						//get org data
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
						crsetOrg = m_db.runSQL(sqlString, stmt);
						
						//get contributor data
						sqlString = 
						"SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
						  "events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
						  "venue.venue_name,venue.suburb,states.state,evcount.num, functs.funct " +
						"FROM events,venue,states,conevlink,contributor " +
						"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
											  "FROM conevlink, events where events.eventid=conevlink.eventid and events.venueid=" + venue_id + " " +
											  "GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
						"inner join (  " +
									      "select conel.contributorid, count(cf.preferredterm) functcount, group_concat(distinct cf.preferredterm separator ', ') funct  " +
									      "from conevlink conel  " +
									      "inner join events e on (e.eventid=conel.eventid) " +
									      "inner join contributorfunctpreferred cf on (conel.function = cf.contributorfunctpreferredid)  " +
									      "where e.venueid = " + venue_id + 
									      " group by conel.contributorid  " +
									      " order by count(conel.function) desc) functs on (functs.contributorid = contributor.contributorid) " +											  
						"WHERE events.venueid = " + venue_id + " AND " +
							"events.venueid = venue.venueid AND " +
							"venue.state = states.stateid AND " +
							"events.eventid=conevlink.eventid AND " +
							"conevlink.contributorid = contributor.contributorid " +
						"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
						crsetCon = m_db.runSQL(sqlString, stmt);
						
						if (crsetEvt.size() > 0 || crsetOrg.size() > 0 || crsetCon.size() > 0) {
						%>

						<tr>
							<th class='record-label b-134' >Events</th>
							
							<td class="record-value" id="tabs" colspan=2>
								<ul class="record-tabs label">
									<li><a href="#" onclick="displayRow('events')" id='eventsbtn'>Date</a></li>
									<li><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributor</a></li>   
									<li><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisation</a></li>
								</ul> 
							</td>
						</tr>
						<%
						}
						%>
						<tr id='events'>
						<%
						//Events Tab
						
						if (crsetEvt.size() > 0) {
						%>
							<th class='b-134' ></th>
							
							<td class='record-value' colspan='2'>
								<ul>
								<%
								while (crsetEvt.next()) {
									%>
									<li>
									<a href="/pages/event/<%=crsetEvt.getString("eventid")%>">
										<%=crsetEvt.getString("event_name")%></a><%
									if (hasValue(crsetEvt.getString("DDFIRST_DATE")) || hasValue(crsetEvt.getString("MMFIRST_DATE")) || hasValue(crsetEvt.getString("YYYYFIRST_DATE")))
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
						//Organisations Tab
						
						
						String prevOrg = "";
						if (crsetOrg.size() > 0) {
							%>
							<th class='b-134' ></th>
					 		
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
						crsetOrg.close();
						%>
						</tr>
						
						<tr id='contributor'>
						<%
						//contributors
						
						
						String prevCont = "";
						if (crsetCon.size() > 0) {
						%>
							<th class='b-134' ></th>
					 		
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
									</a> - <%=crsetCon.getString("funct")%>
								</h3>
								<ul>
									<%
									prevCont= crsetCon.getString("contributorid");
								}
								
								%>
									<li>
									<a href="/pages/event/<%=crsetCon.getString("eventid")%>">
										<%=crsetCon.getString("event_name")%></a><%
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
						//Exhibitions
						
						if (!(venue.getExhibitions()).isEmpty()) {
							
						%>
							<tr>
								<th class='record-label b-134'>Exhibitions</th>
								
								<td class='record-value' colspan='2'>
								
									<ul>
								<%Vector<Exhibition> exhibitions = venue.getExhibitions();
								
								for (Exhibition exhibit : exhibitions){
									if((exhibit.getPublishedFlag()).equals("Y"))%>
									<li>
									<a href="/pages/exhibition/<%=exhibit.getExhibitionId()%>" target="_blank"><%=exhibit.getName()%></a>
									</li>
								<%}%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						%>
						
						<tr >
  	  					<%
    
						//Resources Tab
						rset = venue.getAssociatedItems(Integer.parseInt(venue_id), m_db.m_conn.createStatement());
						int Counter=0;
  	  					if(rset != null)
  {
  out.println("   <tr>");
    while(rset.next())
    {
      if(Counter == 0)
      {
        out.println("     <th class='record-label b-134'>Resources</th>");
        out.println("     <td class='record-value' colspan='2'>");
        out.println("       <ul>");
        Counter++;
      }

      %> <li> 
      <%
      if (rset.getString("body") != null){
      %>
      <div style='width:20px; position:relative; float:left'>
      	      <!-- using bootstrap modal approach for this.-->
	      <span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=rset.getString("itemid")%>'></span>
	
	      <div id='article<%=rset.getString("itemid")%>' class="modal fade" role="dialog">
  		<div class="modal-dialog" style="width:740px;">
		    <!-- Modal content-->
		    <div class="modal-content">
			<div class="modal-header">
		          <button type="button" class="close" data-dismiss="modal">&times;</button>
		          <h4 class="modal-title"><%=rset.getString("citation")%></h4>
		        </div>		      
		      <div class="modal-body item-article-container">
			<%=rset.getString("body")%>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
		      </div>

		    </div>
	
		  </div>
		</div>
	   </div>		
      <%
      }
      %>

       <%=rset.getString("description")%>:&nbsp <a href='/pages/resource/<%=rset.getString("itemid")%>' ><%=rset.getString("citation")%></a></li>
      <%
   
   }
  }if(Counter > 0){
    out.println("      </ul>");
    out.println("     </td>");
    out.println("   </tr>");
    }
    rset.close();
    stmt.close();
    
   %>
						
						
						<tr>
							<th class='record-label b-134' >Venue Identifier</th>
							
							<td class='record-value' colspan='2'><%=venue.getVenueId()%></td>
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
<jsp:include page="../../templates/footer.jsp" />
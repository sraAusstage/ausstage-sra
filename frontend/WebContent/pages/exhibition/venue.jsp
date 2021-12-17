<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Venue"%>
<%@ page import = "ausstage.Event"%>
<%@ page import = "ausstage.Country"%>
<%@ page import = "ausstage.LookupCode"%>
<%@ page import = "ausstage.RelationLookup"%>
<%@ page import = "ausstage.VenueVenueLink"%>


<%@ page session="true" import=" java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>

<div style="margin: 0px;" >
	<div class='b-134 browse-bar show-hide' >
	

					<%
					ausstage.Database db_ausstage = (ausstage.Database)session.getAttribute("database-connection");
					
					if(db_ausstage == null) {
						db_ausstage = new ausstage.Database();
						db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
					}
					
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
					Statement stmt = db_ausstage.m_conn.createStatement();
					String event_id = request.getParameter("f_event_id");
					String venue_id = request.getParameter("venueid");
					String location = "";
					
					State state = new State(db_ausstage);
					Event event = null;
					
					Venue venue = null;
					Country country;
					
					admin.Common Common = new admin.Common();  

					///////////////////////////////////
					//    DISPLAY VENUE DETAILS
					//////////////////////////////////
					venue = new Venue(db_ausstage);
					venue.load(Integer.parseInt(venue_id));
					event = new Event(db_ausstage);
					Country venueCountry = new Country(db_ausstage);
					if (!venue.getCountry().equals("")) {
						venueCountry.load(Integer.parseInt(venue.getCountry()));
					}
		
				    Venue assocVenue = null;
				    Vector venue_venuelinks = venue.getVenueVenueLinks();
					if(venue_venuelinks.size() > 0){assocVenue = new Venue(db_ausstage);}
					
					
					//Venue
					%>


		<img src='/resources/images/icon-venue.png' class='browse-icon'/>
		<span class='browse-heading large'><%= venue.getName()%></span>
		<span class="show-hide-icon glyphicon glyphicon-chevron-up"></span>
	</div>
	
	<!-- venue information -->	
	<div style="width: 100%; " class="toggle-div">					
		<div CLASS="record" style='margin:0; padding-bottom:0em' >			
			<table class='record-table' style='margin-top:0px;'>
			<%

						//Other Names
						if (hasValue(venue.getOtherNames1())) {
						%>
							<tr >
								<th class='record-label venue-light' >Other Names</td>
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
							<th class='record-label venue-light' >Address</th>
							
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
								<th class='record-label venue-light'>First Date</th>
					
								<td class='record-value' colspan='2'><%=formatDate(venue.getDdfirstDate(), venue.getMmfirstDate(), venue.getYyyyfirstDate())%></td>
							</tr>
						<%
						}
						%>						<%
						if (!formatDate(venue.getDdlastDate(), venue.getMmlastDate(), venue.getYyyylastDate()).equals("")) {
						%>
							<tr>
								<th class='record-label venue-light'>Last Date</th>
					
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
								<th class='record-label venue-light' >Website</th>
								
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
								<th class='record-label venue-light' >Notes</td>
								
								<td class='record-value' colspan='2'><%=venue.getNotes()%></td>
							</tr>
						<%
						}
						 // Related Venues
						if (assocVenue != null && venue_venuelinks.size() > 0) {
							%>
							<tr>
								<th class='record-label venue-light'>Related Venues</th>
								
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
										RelationLookup lookUpCode = new RelationLookup(db_ausstage);
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
												//JIRA AUS-76 out.print(". ");
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
				<tr>
					
					
					<th class='record-label venue-light' >Map</th>
					<td> 
					<% 
//TODO									
					//DISPLAY MAP SECTION - this will need to be fixed - currently importing multiple versions of the map libs. 
					//And creating multiple canvases with thew same id if there is more than one map on the page.
					//Latitude
					%>
					<script>
					$(document).ready(function(){
						try{
							loadMap( "map_canvas<%=venue.getVenueId()%>", <%=venue.getLatitude()%> , <%=venue.getLongitude()%> );
						}
						catch(err){
							$( "#map_canvas<%=venue.getVenueId()%>").parent().append("<i>Google Maps temporarily unavailable. ERROR: "+err.message+"</i>");
							$( "#map_canvas<%=venue.getVenueId()%>").hide();
						}
					});
					</script>		
					<div id="map_canvas<%=venue.getVenueId()%>" style="width:100%;height:300px;border: 1px solid white;"></div>		
					
					</td>
				</tr>
				<tr>
								<th class='record-label venue-light' >Latitude | Longitude</th>
								
								<td class='record-value' colspan='2'><%=venue.getLatitude()%> | <%=venue.getLongitude()%></td>
							</tr>
							<%
					}
					//Radius
						if (venue.getRadius() != null && !venue.getRadius().equals("")) {
						%>
							<tr >
								<th class='record-label venue-light' >Radius</th>
								
								<td class='record-value' colspan='2'><%=venue.getRadius()+" metres"%></td>
							</tr>
						<%
						}
    
						//Elevation
						if (venue.getElevation() != null && !venue.getElevation().equals("")) {
						%>
							<tr >
								<th class='record-label venue-light' >Elevation</td>
								
								<td class='record-value' colspan='2'><%=venue.getElevation()+" metres"%></td>
							</tr>
						<%
						}
					//get event data
						ausstage.Database m_db = new ausstage.Database ();
						m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
						
						event = new Event(db_ausstage);
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
							<th class='record-label venue-light' >Events</th>
							
							<td class="record-value" id="tabs" colspan=2>
								<ul class="record-tabs label">
									<li><a href="#" onclick="displayVenueRow('venue_events<%=venue.getVenueId()%>','<%=venue.getVenueId()%>')" id='venue_events<%=venue.getVenueId()%>btn'>Date</a></li>
									<li><a href="#" onclick="displayVenueRow('venue_contributor<%=venue.getVenueId()%>','<%=venue.getVenueId()%>')" id='venue_contributor<%=venue.getVenueId()%>btn'>Contributor</a></li>   
									<li><a href="#" onclick="displayVenueRow('venue_organisation<%=venue.getVenueId()%>','<%=venue.getVenueId()%>')" id='venue_organisation<%=venue.getVenueId()%>btn'>Organisation</a></li>
								</ul> 
							</td>
						</tr>
						<%
						}
						%>
						<tr id='venue_events<%=venue.getVenueId()%>' class='events-tab'>
						<%
						//Events Tab
						
						if (crsetEvt.size() > 0) {
						%>
							<th class='venue-light' ></th>
							
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
						
						<tr id='venue_organisation<%=venue.getVenueId()%>' class='events-tab'>
						<%
						//Organisations Tab
						
						
						String prevOrg = "";
						if (crsetOrg.size() > 0) {
							%>
							<th class='venue-light' ></th>
					 		
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
						
						<tr id='venue_contributor<%=venue.getVenueId()%>' class='events-tab'>
						<%
						//contributors
						
						
						String prevCont = "";
						if (crsetCon.size() > 0) {
						%>
							<th class='venue-light' ></th>
					 		
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
        out.println("     <th class='record-label venue-light'>Resources</th>");
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
	      <span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=rset.getString("itemid")%><%=venue_id%>'></span>
	
	      <div id='article<%=rset.getString("itemid")%><%=venue_id%>' class="modal fade" role="dialog">
  		<div class="modal-dialog wysiwyg" >
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
							<th class='record-label venue-light' >Venue Identifier</th>
							
							<td class='record-value' colspan='2'><%=venue.getVenueId()%></td>
						</tr>
						
						<tr>
							
						</tr>
					</table>
		</div>
		
	</div>
</div>
<script type="text/javascript">
	function displayVenueRow(name, id){
		document.getElementById("venue_events"+id).style.display = 'none';
		document.getElementById("venue_events"+id+"btn").style.backgroundColor = '#aaaaaa';
		document.getElementById("venue_organisation"+id).style.display = 'none';
		document.getElementById("venue_organisation"+id+"btn").style.backgroundColor = '#aaaaaa';
		document.getElementById("venue_contributor"+id).style.display = 'none';
		document.getElementById("venue_contributor"+id+"btn").style.backgroundColor = '#aaaaaa';
	
		document.getElementById(name).style.display = '';
		document.getElementById(name+"btn").style.backgroundColor = '#666666';
	}
	
		if (!document.getElementById("venue_organisation<%=venue.getVenueId()%>").innerHTML.match("[A-Za-z]")) document.getElementById("venue_organisation<%=venue.getVenueId()%>btn").style.display = "none";
		if (!document.getElementById("venue_contributor<%=venue.getVenueId()%>").innerHTML.match("[A-Za-z]")) document.getElementById("venue_contributor<%=venue.getVenueId()%>btn").style.display = "none";
		if (!document.getElementById("venue_events<%=venue.getVenueId()%>").innerHTML.match("[A-Za-z]")) document.getElementById("venue_events<%=venue.getVenueId()%>btn").style.display = "none";
		displayVenueRow("venue_events<%=venue.getVenueId()%>", "<%=venue.getVenueId()%>");
	</script>

<% 
 stmt.close();
%>


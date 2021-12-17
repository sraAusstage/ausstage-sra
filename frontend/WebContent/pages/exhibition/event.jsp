<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.Vector,java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*,sun.jdbc.rowset.*,java.util.Calendar,java.util.Date,java.text.SimpleDateFormat"%>
<%--@ page import="ausstage.State"--%>
<%@ page import="admin.Common"%>
<%@ page import="ausstage.Event"%>
<%@ page import="ausstage.Venue"%>
<%@ page import="ausstage.Work"%>
<%@ page import="ausstage.DescriptionSource"%>
<%@ page import="ausstage.Datasource"%>
<%@ page import="ausstage.Country"%>
<%@ page import="ausstage.EventEventLink"%>
<%@ page import="ausstage.PrimaryGenre,ausstage.SecGenreEvLink"%>
<%@ page import="ausstage.PrimContentIndicatorEvLink"%>
<%@ page import="ausstage.OrgEvLink,ausstage.Organisation"%>
<%@ page import="ausstage.ConEvLink,ausstage.Contributor"%>
<%@ page import="ausstage.Item,ausstage.LookupCode,ausstage.RelationLookup,ausstage.ContentIndicator"%>
<%@ page import="ausstage.ItemContribLink,ausstage.ItemOrganLink"%>
<%@ page import="ausstage.SecondaryGenre"%>
<%--@ page import="ausstage.WorkContribLink,ausstage.WorkEvLink,ausstage.WorkOrganLink"--%>

<%@ include file="../../public/common.jsp"%>

<%@ page session="true" import="java.lang.String,java.util.*"%>
<%
admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
DescriptionSource descriptionSource;
Datasource datasourceEvlink;
%>
<%@ page import="ausstage.AusstageCommon"%>


<div style="margin: 0px;">
	<div class="b-90 browse-bar show-hide">

			<%
			ausstage.Database db_ausstage_for_drill = (ausstage.Database)session.getAttribute("database-connection");
			descriptionSource = new DescriptionSource(db_ausstage_for_drill);
			Country country = new Country(db_ausstage_for_drill);

			List<String> groupNames = new ArrayList();	
			if (session.getAttribute("userName")!= null) {
				admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
			  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
			}
			
			
			if(db_ausstage_for_drill == null) {
				db_ausstage_for_drill = new ausstage.Database();
				db_ausstage_for_drill.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
			}
			
			CachedRowSet crset = null;
			ResultSet rset;
			Statement stmt = db_ausstage_for_drill.m_conn.createStatement();

			String event_id = request.getParameter("eventid");

			Event event = null;

			PrimaryGenre primarygenre;
			Organisation organisation;
			Organisation organisationCreator = null;
			Contributor contributor = null;
			Contributor contributorCreator = null;
			Item item;
			LookupCode item_type = null;
			LookupCode item_sub_type = null;
			LookupCode language;
			SecondaryGenre secondaryGenre = null;
			Work work = null;
			Item assocItem = null;
			ContentIndicator contentIndicator = null;

			SimpleDateFormat formatPattern = new SimpleDateFormat("dd MMMM yyyy");

			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();

			///////////////////////////////////
			//    DISPLAY EVENT DETAILS
			//////////////////////////////////

			event = new Event(db_ausstage_for_drill);
			event.load(Integer.parseInt(event_id));
			//descriptionSource = new DescriptionSource(db_ausstage_for_drill);

			Venue assocVenue = new Venue(db_ausstage_for_drill); ;
		    Event assocEvent = null;
		    Vector event_eventlinks = event.getEventEventLinks();
			if(event_eventlinks.size() > 0){assocEvent = new Event(db_ausstage_for_drill); }
			
	
			//Event Name
			%>
					<img src='/resources/images/icon-event.png' class='browse-icon'/> 
					<span class='browse-heading large' ><%=event.getEventName()%></span>
					<span class="show-hide-icon glyphicon glyphicon-chevron-up"></span>
	
	</div>
	<div style="width: 100%; " class='toggle-div'>
		<div class='record' style="margin: 0px; padding-bottom: 0em;">
			<table class='record-table' style="margin-top: 0px;">

			
			<tr>
				<th class='record-label event-light'> Venue</th>
				<td class='record-value' colspan='2'><a href="/pages/venue/<%=event.getVenueid()%>"><%=event.getVenue().getName()%></a></td>
			</tr>
			<%
			//Umbrella Event
			if(hasValue(event.getUmbrella())) {
			%>
				<tr>
					<th class='record-label event-light'>Umbrella Event</th>
					
					<td class='record-value' colspan='2'><%=event.getUmbrella()%></td>
				</tr>
			<%	
			}

			
			//First Date
			if (!formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate()).equals("")) {
			%>
				<tr>
					<th class='record-label event-light'>First Date</th>
					
					<td class='record-value' colspan='2'><%=formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate())%></td>
				</tr>
			<%
			}

			//Opening Date
			if (!formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate()).equals("")) {
			%>
				<tr>
					<th class='record-label event-light'>Opening Date</th>

					<td class='record-value' colspan='2'><%=formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate())%></td>
				</tr>
			<%
			}

			//Last Date
			if (!formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate()).equals("")) {
				%>
				<tr>
					<th class='record-label event-light'>Last Date</th>
					
					<td class='record-value' colspan='2'><%=formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate())%></td>
				</tr>
			<%
			}
					
			//Dates Estimated
			%>
			<tr>
				<th class='record-label event-light'>Dates Estimated</th>
			
				<td class='record-value' colspan='2'><%=Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()), true)%></td>
			</tr>
			
			<%
			//Status
			if (hasValue(event.getStatus())) {
			%>
				<tr>
					<th class='record-label event-light'>Status</th>
					
					<td class='record-value' colspan='2'><%=event.getEventStatus(event.getStatus())%></td>
				</tr>
			<%
			}
			//World Premier
			%>
			<tr>
				<th class='record-label event-light'>World Premiere</th>
				
				<td class='record-value' colspan='2'><%=Common.capitalise(Common.convertBoolToYesNo(event.getWorldPremier()), true)%></td>
			</tr>
			<%
			//Part of a tour -- remove me when event-event joins are done
			if (event.getPartOfATour()) {
			%>
			<tr>
				<th class='record-label event-light'>Part of a Tour</th>
				
				<td class='record-value' colspan='2'>Yes</td>
			</tr>
			<%
			}
			//Description
			if (hasValue(event.getDescription())) {
				//replace new line character with br tags 			
				String desc = event.getDescription().replace("\n", "<br>");
			%>
				<tr>
					<th class='record-label event-light'>Description</th>
  					<td class='record-value' colspan='2'><%=desc%></td>
				</tr>
			<%
			}
	
			//Description Source
			if (hasValue(event.getDescriptionSource()) && !event.getDescriptionSource().equals("0")) {
			%>
				<tr>
					<th class='record-label event-light'>Description Source</th>
					
					<td class='record-value' colspan='2'><%=descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource()))%></td>
				</tr>
			<%
			}

			// PRIMARY GENRE //
			%>
			<tr>
				<th class='record-label event-light'>Primary Genre</th>
				
				<td class='record-value' colspan='2'><%
				primarygenre = new PrimaryGenre(db_ausstage_for_drill);
				primarygenre.load(Integer.parseInt(event.getPrimaryGenre()));
				out.println(primarygenre.getName());
				%></td>
			</tr>
			
			<%
			//  SECONDARY GENRE //
			if (!event.getSecGenreEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label event-light'>Secondary Genre</th>
					
					<td class='record-value' colspan='2'>
					<%
					for (SecGenreEvLink secGenreEvLink : (Vector<SecGenreEvLink>) event.getSecGenreEvLinks()) {
						SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
						tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
						%>
						<a href="/pages/genre/<%=secGenreEvLink.getSecGenrePreferredId()%>">
							<%=tempSecGenre.getName()%></a>
						<br>
						<%
					}
					%>
					</td>
				</tr>
				<%
			}
			//  PRIMARY CONTENT INDICATOR //  
			//Subjects
			if (!event.getPrimContentIndicatorEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label event-light'>Subjects</th>
					
					<td class='record-value' colspan='2'>
					<%
					for (PrimContentIndicatorEvLink primContentIndicatorEvLink : (Vector<PrimContentIndicatorEvLink>) event.getPrimContentIndicatorEvLinks()) {
						%>
						<a href="/pages/subject/<%=primContentIndicatorEvLink.getPrimaryContentInd().getId()%>">
							<%=primContentIndicatorEvLink.getPrimaryContentInd().getName()%></a>
						<br>
						<%
					}
					%>
					</td>
				</tr>
				<%
			}

			// Related Events
			if (assocEvent != null && event_eventlinks.size() > 0) {
				%>
				<tr>
					<th class='record-label event-light'>Related Events</th>
					
					<td class='record-value' colspan='2'>
						<ul>
						<%
						for (EventEventLink eventEventLink : (Vector <EventEventLink>) event_eventlinks) {
							boolean isParent = true;
							if(event_id.equals(eventEventLink.getChildId())){
								isParent = false;
								assocEvent.load(new Integer(eventEventLink.getEventId()).intValue());
								
							}else{
								assocEvent.load(new Integer(eventEventLink.getChildId()).intValue());
								
							}
							RelationLookup relationLookup = new RelationLookup(db_ausstage_for_drill);
							String assocEventDate = "";
							assocEventDate = formatDate(assocEvent.getDdfirstDate(),assocEvent.getMmfirstDate(),assocEvent.getYyyyfirstDate());
							
							//JIRA AUS-76
							String endCharacter = "";
							if ((isParent && !eventEventLink.getNotes().isEmpty()) || (!isParent && !eventEventLink.getChildNotes().isEmpty())){
								endCharacter = ",";
							}							

							if (eventEventLink.getRelationLookupId()!=null) relationLookup.load(Integer.parseInt(eventEventLink.getRelationLookupId()));
							%>
							<li>
									<%=(isParent)?relationLookup.getParentRelation():relationLookup.getChildRelation() %>
									<%out.print("<a href=\"/pages/event/"+assocEvent.getEventid()+"\">"+assocEvent.getEventName()+"</a>");
									%><%=", "+assocVenue.getVenueInfoForVenueDisplay(new Integer(assocEvent.getVenueid()).intValue(), stmt)+", "+assocEventDate+endCharacter%> 
									<% if (isParent){
										if (!eventEventLink.getNotes().equals("")) out.print(eventEventLink.getNotes());
									   } 
									   else {
										if (!eventEventLink.getChildNotes().equals("")) out.print(eventEventLink.getChildNotes());									   
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
			
			//  ORGANISATIONS  or Companies//
			if (!event.getOrgEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label event-light'>Organisations</th>
					
					<td class='record-value' colspan='2'>
						<ul>
						<%
						for (OrgEvLink orgEvLink : (Vector<OrgEvLink>) event.getOrgEvLinks()) {
							organisation = orgEvLink.getOrganisationBean();
							%>
							<li>
							
									<a href="/pages/organisation/<%=organisation.getId()%>"><%=organisation.getName()%></a><%
									if (hasValue(orgEvLink.getFunctionDesc())) {
										out.print(", " + orgEvLink.getFunctionDesc());
									} 
									else {
										//out.print(", No Function");
									}
									if (hasValue(orgEvLink.getArtisticFunctionDesc())) {
										out.print(", " + orgEvLink.getArtisticFunctionDesc());
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



			//  CONTRIBUTORS //   
			
			if (!event.getConEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label event-light'>Contributors</th>
					
					<td class='record-value'  colspan='2'>
						<table class='record-value-table' cellspacing="0">
							<tr>
								<th  class='record-value-table light'>Name</th>
								<th  class='record-value-table light'>Function</th>
								<th  class='record-value-table light'>Notes</th>
							</tr>
						<%
						for (ConEvLink conEvLink : (Vector<ConEvLink>) event.getConEvLinks()) {
							contributor = conEvLink.getContributorBean();
							%>
							<tr>
								<td  class='record-value-table'>
									<a href="/pages/contributor/<%=contributor.getId()%>">
										<%=contributor.getName() + " " + contributor.getLastName()%>
									</a>
								</td>
								<td  class='record-value-table'>
									<%=(hasValue(conEvLink.getContributorId()) && conEvLink.getContributorId().equals(Integer.toString(contributor.getId())))?conEvLink.getFunctionDesc():"" %>
								</td>
								<td  class='record-value-table'>
									<%=hasValue(conEvLink.getNotes())?conEvLink.getNotes():"" %>
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
			int Counter = 0;
			rset = event.getAssociatedItems(Integer.parseInt(event_id), stmt);
				
			if(rset != null){
				out.println("   <tr>");
				while(rset.next()){
			      		if(Counter == 0){
					        %>
					        <th class='record-label event-light'>Resources</th>
					        <td class='record-value' colspan='2'>
					        	<ul>
					        <%	
					        Counter++;
		      			}
		      			%> <li> 
				        <%
				        if (rset.getString("body") != null){
				        %>
				        <div style='width:20px; position:relative; float:left'>
				    	<!-- using bootstrap modal approach for this.-->
			  	        <span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=rset.getString("itemid")%><%=event_id%>'></span>
	
					      <div id='article<%=rset.getString("itemid")%><%=event_id%>' class="modal fade" role="dialog">
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
			    rset.close();
  			}if(Counter > 0){
			    out.println("      </ul>");
			    out.println("     </td>");
			    out.println("   </tr>");
   
			}

			//Works
			rset = event.getAllAssociatedWorks(Integer.parseInt(event_id), stmt);
			if (rset != null && rset.isBeforeFirst()) {
				%>
					<tr>
						<th class='record-label event-light'>Works</th>
						
						<td class='record-value'  colspan='2'>
							<ul>
							<%
							while (rset.next()) {
							%>
								<li>
									
									<a href="/pages/work/<%=rset.getString("workid")%>">
											<%=rset.getString("work_title")%></a>
									
								</li>
							<%
							}
							%>
							</ul>
						</td>
					</tr>
				<%
				rset.close();
			}
			boolean first = true;
			//Text Nationality
			for (Country playOrigin : (Vector <Country>) event.getPlayOrigins()) {
				if (hasValue(playOrigin.getName())) {
					if (first){
				%>
					<tr>
						<th class='record-label event-light'>Text Nationality</th>
						
						<td class='record-value'  colspan='2'><%=playOrigin.getName()%>
					<%
						first = false;
					}else{
				%>
				
				<%="<br>"+playOrigin.getName() %>
					<%
					}
					%>
					
				<%
				}
				
			}if (!first){
				%>
					</td>
					</tr>
				<%
			}
			
			first = true;
			// Production Nationality
			for (Country prodOrigin : (Vector <Country>) event.getProductionOrigins()) {
				if (hasValue(prodOrigin.getName())) {
					if(first){
				%>
					<tr>
						<th class='record-label event-light'>Production Nationality</th>
						
						<td class='record-value' colspan='2'><%=prodOrigin.getName()%>
				<%
						first = false;
					}else{
				%>
				
				<%="<br>"+prodOrigin.getName() %>
					<%
					}
					%>
				<%
				}
			}if (!first){
				%>
					</td>
					</tr>
				<%
			}

			//Further Information
			if (hasValue(event.getFurtherInformation())) {
			%>
				<tr>
					<th class='record-label event-light'>Further Information</th>
					
					<td class='record-value' colspan='2'>
					<%=event.getFurtherInformation()%>
					</td>
				</tr>
			<%	
			}
if (!event.getDataSources().isEmpty()) {
			%>
				<tr>
					<th class='record-label event-light'>Data Source</th>
					
					<td class='record-value'  colspan='2'>
						<table  class='record-value-table' cellspacing="0">
							<tr>
								<th  class='record-value-table light nowrap'>Source</th>
								
								<th  class='record-value-table light nowrap'>Description</th>
								
								<!--<td  class='record-value-table light nowrap' >Part of Collection</td>-->
							</tr>
							<%

							for (Datasource datasource : (Vector <Datasource>) event.getDataSources()) {
								datasourceEvlink = new Datasource(db_ausstage_for_drill);
								datasourceEvlink.setEventId(event_id);
								datasourceEvlink.loadLinkedProperties(Integer.parseInt("0" + datasource.getDatasoureEvlinkId()));
								%>
								<tr>
									<td  class='record-value-table'><%=datasource.getName()%></td>
									
									<td  class='record-value-table'><%=datasourceEvlink.getDescription()%></td>
									
									<!--<td  class='record-value '></td>-->
								</tr>
							<%
							}
							%>
						</table>
					</td>
				</tr>
			<%
			}

			SimpleDateFormat dateFormat = new SimpleDateFormat("d MMMM yyyy");

			//Reviewed
			if (event.getReview() == true) {
			%>
				<tr >
					<th class='record-label event-light'>Data Reviewed By</td>
					
					<%
					if(!hasValue(event.getUpdatedByUser()) || event.getUpdatedByUser().equals("null")){
					%>
						<td class='record-value' colspan='2'><%=event.getEnteredByUser()%> on <%=dateFormat.format(event.getEnteredDate())%></td>
					<%
					} else {
					%>
						<td class='record-value' colspan='2'><%=event.getUpdatedByUser()%> on <%=dateFormat.format(event.getUpdatedDate())%></td>
					<%
					}
					%>	
				</tr>
				<%
			}

			//Event Identifier
			if (hasValue(event.getEventid())) {
			%>
				<tr>
					<th class='record-label event-light'>Event Identifier</td>
					
					<td class='record-value' colspan='2'><%=event.getEventid()%></td>
				</tr>
			<%
			}
			// close statement
			stmt.close();
			
			%>
			<tr>
				
			</tr>
			</table>
			
		</div>
	</div>
</div>




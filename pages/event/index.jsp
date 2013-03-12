<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Vector,java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*,sun.jdbc.rowset.*,java.util.Calendar,java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="ausstage.State"%>
<%@ page import="admin.Common"%>
<%@ page import="ausstage.Event,ausstage.DescriptionSource"%>
<%@ page import="ausstage.Datasource,ausstage.Venue,ausstage.EventEventLink"%>
<%@ page import="ausstage.PrimaryGenre,ausstage.SecGenreEvLink"%>
<%@ page import="ausstage.Country,ausstage.PrimContentIndicatorEvLink"%>
<%@ page import="ausstage.OrgEvLink,ausstage.Organisation,ausstage.Organisation"%>
<%@ page import="ausstage.ConEvLink,ausstage.Contributor"%>
<%@ page import="ausstage.Item,ausstage.LookupCode,ausstage.ContentIndicator"%>
<%@ page import="ausstage.ItemContribLink,ausstage.ItemOrganLink"%>
<%@ page import="ausstage.SecondaryGenre,ausstage.Work"%>
<%@ page import="ausstage.WorkContribLink,ausstage.WorkEvLink,ausstage.WorkOrganLink"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ include file="../../public/common.jsp"%>

<%@ page session="true" import="org.opencms.main.*,org.opencms.jsp.*,org.opencms.file.*,java.lang.String,java.util.*"%>
<%
admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%>
<%@ page import="ausstage.AusstageCommon"%>

<cms:include property="template" element="head" />

<div class='record'>

			<%
			ausstage.Database db_ausstage_for_drill = new ausstage.Database();

			List <String> groupNames = new ArrayList();
			if (session.getAttribute("userName") != null) {
				CmsJspActionElement cms = new CmsJspActionElement(pageContext, request, response);
				CmsObject cmsObject = cms.getCmsObject();
				List <CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
				for (CmsGroup group : userGroups) {
					groupNames.add(group.getName());
				}
			}

			db_ausstage_for_drill.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

			CachedRowSet crset = null;
			ResultSet rset;
			Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
			String formatted_date = "";
			String event_id = request.getParameter("id");
			String location = "";

			State state = new State(db_ausstage_for_drill);
			Country country = new Country(db_ausstage_for_drill);
			Event event = null;

			DescriptionSource descriptionSource;
			Datasource datasourceEvlink;

			Venue venue = null;
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

			SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");

			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();

			///////////////////////////////////
			//    DISPLAY EVENT DETAILS
			//////////////////////////////////

			event = new Event(db_ausstage_for_drill);
			event.load(Integer.parseInt(event_id));
			descriptionSource = new DescriptionSource(db_ausstage_for_drill);


		    Event assocEvent = null;
		    Vector event_eventlinks = event.getEventEventLinks();
			if(event_eventlinks.size() > 0){assocEvent = new Event(db_ausstage_for_drill);}
			
	
			//Event Name
			%>
			<table class='record-table'>
				<tr>
					<th class='record-label b-90 bold' ><img src='../../../resources/images/icon-event.png' class='box-icon'>Event</th>
					<td class='record-value bold' > <%=event.getEventName()%> 
						<%
						if (groupNames.contains("Administrators") || groupNames.contains("Event Editor"))
						out.println("[<a class='editLink' target='_blank' href='/custom/event_addedit.jsp?mode=edit&f_eventid=" + event.getEventid() + "'>Edit</a>]");

						%>
						
				 	</td>
				 	<td class='record-comment'> <%
				 		if (displayUpdateForm) {
							displayUpdateForm(event_id, "Event", event.getEventName(), out, request, ausstage_search_appconstants_for_drill);
						}
				 	%>
				 	</td>
				</tr>

			<%

			//Venue

			// Get venue location string
			String venueLocation = "";
			if (hasValue(event.getVenue().getSuburb())) venueLocation = ", " + event.getVenue().getSuburb();
			if ((hasValue(event.getVenue().getState())) && (Integer.parseInt(event.getVenue().getState())<9)) {  // Display Venue State, but not O/S=9 [Unknown]=10
				venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));
			}else if (hasValue(event.getVenue().getCountry())){  // If Venue State is O/S or [Unknown], display Country
				country.load(Integer.parseInt(event.getVenue().getCountry()));
			 	venueLocation += ", " + country.getName();
			}
			%>
			<tr>
				<th class='record-label b-90'>Venue</th>
				<td class='record-value' colspan='2'><a href="/pages/venue/<%=event.getVenueid()%>"><%=event.getVenue().getName()%></a><%=venueLocation%></td>
			</tr>
			<%

			//Umbrella Event
			if(hasValue(event.getUmbrella())) {
			%>
				<tr>
					<th class='record-label b-90'>Umbrella Event</th>
					
					<td class='record-value' colspan='2'><%=event.getUmbrella()%></td>
				</tr>
			<%	
			}
			
			//First Date
			if (!formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate()).equals("")) {
			%>
				<tr>
					<th class='record-label b-90'>First Date</th>
					
					<td class='record-value' colspan='2'><%=formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate())%></td>
				</tr>
			<%
			}

			//Opening Date
			if (!formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate()).equals("")) {
			%>
				<tr>
					<th class='record-label b-90'>Opening Date</th>

					<td class='record-value' colspan='2'><%=formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate())%></td>
				</tr>
			<%
			}

			//Last Date
			if (!formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate()).equals("")) {
				%>
				<tr>
					<th class='record-label b-90'>Last Date</th>
					
					<td class='record-value' colspan='2'><%=formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate())%></td>
				</tr>
			<%
			}
			
			//Dates Estimated
			%>
			<tr>
				<th class='record-label b-90'>Dates Estimated</th>
			
				<td class='record-value' colspan='2'><%=Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()), true)%></td>
			</tr>
			<%
					

			//Status
			if (hasValue(event.getStatus())) {
			%>
				<tr>
					<th class='record-label b-90'>Status</th>
					
					<td class='record-value' colspan='2'><%=event.getEventStatus(event.getStatus())%></td>
				</tr>
			<%
			}
			
			//World Premier
			%>
			<tr>
				<th class='record-label b-90'>World Premiere</th>
				
				<td class='record-value' colspan='2'><%=Common.capitalise(Common.convertBoolToYesNo(event.getWorldPremier()), true)%></td>
			</tr>
			
			<%
			//Part of a tour -- remove me when event-event joins are done
			if (event.getPartOfATour()) {
			%>
			<tr>
				<th class='record-label b-90'>Part of a Tour</th>
				
				<td class='record-value' colspan='2'>Yes</td>
			</tr>
			<%
			}

			//Description
			if (hasValue(event.getDescription())) {
			%>
				<tr>
					<th class='record-label b-90'>Description</th>
					
					<td class='record-value' colspan='2'><%=event.getDescription()%></td>
				</tr>
			<%
			}

			//Description Source
			if (hasValue(event.getDescriptionSource()) && !event.getDescriptionSource().equals("0")) {
			%>
				<tr>
					<th class='record-label b-90'>Description Source</th>
					
					<td class='record-value' colspan='2'><%=descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource()))%></td>
				</tr>
			<%
			}

			// PRIMARY GENRE //
			%>
			<tr>
				<th class='record-label b-90'>Primary Genre</th>
				
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
					<th class='record-label b-90'>Secondary Genre</th>
					
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
					<th class='record-label b-90'>Subjects</th>
					
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
					<th class='record-label b-90'>Related Events</th>
					
					<td class='record-value' colspan='2'>
						<table border="0" cellpadding="0" cellspacing="0">
						<%
						for (EventEventLink eventEventLink : (Vector <EventEventLink>) event_eventlinks) {
							assocEvent.load(new Integer(eventEventLink.getChildId()).intValue());
							
							LookupCode lookUpCode = new LookupCode(db_ausstage_for_drill);
							if (eventEventLink.getFunctionId()!=null) lookUpCode.load(Integer.parseInt(eventEventLink.getFunctionId()));
							%>
							<tr>
								<td valign="top">
									<%=lookUpCode.getDescription() %>
									<a href="/pages/event/<%=assocEvent.getEventid()%>">
										<%=assocEvent.getEventName()%>
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
			
			//  ORGANISATIONS  or Companies//
			if (!event.getOrgEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label b-90'>Organisations</th>
					
					<td class='record-value' colspan='2'>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						for (OrgEvLink orgEvLink : (Vector<OrgEvLink>) event.getOrgEvLinks()) {
							organisation = orgEvLink.getOrganisationBean();
							%>
							<tr>
								<td valign="top">
									<a href="/pages/organisation/<%=organisation.getId()%>"><%=organisation.getName()%></a><%
									if (hasValue(orgEvLink.getFunctionDesc())) {
										out.print(", " + orgEvLink.getFunctionDesc());
									} else {
										out.print(", No Function");
									}
									if (hasValue(orgEvLink.getArtisticFunctionDesc())) {
										out.print(", " + orgEvLink.getArtisticFunctionDesc());
									}
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



			//  CONTRIBUTORS //   
			
			if (!event.getConEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label b-90'>Contributors</th>
					
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
			rset = event.getAssociatedItems(Integer.parseInt(event_id), stmt);
				
			if (rset != null && rset.isBeforeFirst()) {
			%>
				<tr>
					<th class='record-label b-90'>Resources</th>
					
					<td class='record-value'  colspan='2'>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						while (rset.next()) {
						%>
							<tr>
								<td colspan='3' width="100%"  valign="top"><%=rset.getString("item_sub_type")%>:	
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
				rset.close();
			}

			//Works
			rset = event.getAssociatedWorks(Integer.parseInt(event_id), stmt);
			if (rset != null && rset.isBeforeFirst()) {
				%>
					<tr>
						<th class='record-label b-90'>Works</th>
						
						<td class='record-value'  colspan='2'>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<%
							while (rset.next()) {
							%>
								<tr>
									
									<td><a href="/pages/work/<%=rset.getString("workid")%>">
											<%=rset.getString("work_title")%></a>
									</td>
								</tr>
							<%
							}
							%>
							</table>
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
						<th class='record-label b-90'>Text Nationality</th>
						
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
						<th class='record-label b-90'>Production Nationality</th>
						
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
					<th class='record-label b-90'>Further Information</th>
					
					<td class='record-value' colspan='2'>
					<%=event.getFurtherInformation()%>
					</td>
				</tr>
			<%	
			}

			if (!event.getDataSources().isEmpty()) {
			%>
				<tr>
					<th class='record-label b-90'>Data Source</td>
					
					<td class=''  colspan='2'>
						<table  class='record-value' cellspacing="0">
							<tr>
								<td  class='record-value-table light nowrap'>Source</td>
								
								<td  class='record-value-table light nowrap'>Description</td>
								
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
					<th class='record-label b-90'>Data Reviewed By</td>
					
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
					<th class='record-label b-90'>Event Identifier</td>
					
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
			<!--<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>-->
			<!-- AddThis Button BEGIN -->
			<!--<div align="right" class="addthis_toolbox addthis_default_style ">
				<a class="addthis_button_facebook_like"
					fb:like:layout="button_count"></a> <a
					class="addthis_button_tweet"></a> <a
					class="addthis_button_google_plusone" g:plusone:size="medium"></a>
				<a class="addthis_counter addthis_pill_style"></a>
			</div>-->

</div>
<cms:include property="template" element="foot" />
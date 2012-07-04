<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Vector,java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*,sun.jdbc.rowset.*,java.util.Calendar,java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="ausstage.State"%>
<%@ page import="admin.Common"%>
<%@ page import="ausstage.Event,ausstage.DescriptionSource"%>
<%@ page import="ausstage.Datasource,ausstage.Venue,ausstage.ItemItemLink"%>
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


	
			//Event Name
			%>
			<table class='record-table'>
				<tr>
					<th class='record-label b-90 bold' ><img src='../../../resources/images/icon-event.png' class='box-icon'>Event Name</th>
					<td class='record-value bold' > <%=event.getEventName()%> 
						<%
						if (groupNames.contains("Administrators") || groupNames.contains("Event Editor"))
						out.println("[<a class='editLink' target='_blank' href='/custom/event_addedit.jsp?mode=edit&f_eventid=" + event.getEventid() + "'>Edit</a>]");

						%>
						
				 	</td>
				 	<td rowspan=3> <%
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
			if (hasValue(event.getVenue().getState())) venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));
			
			%>
			<tr>
				<th class='record-label b-90'>Venue</th>
				<td class='record-value'><a href="/pages/venue/<%=event.getVenueid()%>"><%=event.getVenue().getName()%></a><%=venueLocation%></td>
			</tr>
			<%

			//Umbrella Event
			if(hasValue(event.getUmbrella())) {
			%>
				<tr>
					<th class='record-label b-90'>Umbrella Event</th>
					
					<td class='record-value'><%=event.getUmbrella()%></td>
				</tr>
			<%	
			}
			
			//First Date
			if (!formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate()).equals("")) {
			%>
				<tr>
					<th class='record-label b-90'>First Date</th>
					
					<td class='record-value'><%=formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate())%></td>
				</tr>
			<%
			}

			//Opening Date
			if (!formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate()).equals("")) {
			%>
				<tr>
					<th class='record-label b-90'>Opening Date</th>

					<td class='record-value'><%=formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate())%></td>
				</tr>
			<%
			}

			//Last Date
			if (!formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate()).equals("")) {
				%>
				<tr>
					<th class='record-label b-90'>Last Date</th>
					
					<td class='record-value'><%=formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate())%></td>
				</tr>
			<%
			}
			
			//Dates Estimated
			%>
			<tr>
				<th class='record-label b-90'>Dates Estimated</th>
			
				<td class='record-value'><%=Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()), true)%></td>
			</tr>
			<%
					

			//Status
			if (hasValue(event.getStatus())) {
			%>
				<tr>
					<th class='record-label b-90'>Status</th>
					
					<td class='record-value'><%=event.getEventStatus(event.getStatus())%></td>
				</tr>
			<%
			}
			
			//World Premier
			%>
			<tr>
				<th class='record-label b-90'>World Premiere</th>
				
				<td class='record-value'><%=Common.capitalise(Common.convertBoolToYesNo(event.getWorldPremier()), true)%></td>
			</tr>
			
			<%
			//Part of a tour -- remove me when event-event joins are done
			if (event.getPartOfATour()) {
			%>
			<tr>
				<th class='record-label b-90'>Part Of A Tour</th>
				
				<td class='record-value'>Yes</td>
			</tr>
			<%
			}

			//Description
			if (hasValue(event.getDescription())) {
			%>
				<tr>
					<th class='record-label b-90'>Description</th>
					
					<td class='record-value'><%=event.getDescription()%></td>
				</tr>
			<%
			}

			//Description Source
			if (hasValue(event.getDescriptionSource()) && !event.getDescriptionSource().equals("0")) {
			%>
				<tr>
					<th class='record-label b-90'>Description Source</th>
					
					<td class='record-value'><%=descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource()))%></td>
				</tr>
			<%
			}

			// PRIMARY GENRE //
			%>
			<tr>
				<th class='record-label b-90'>Primary Genre</th>
				
				<td class='record-value'><%
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
					
					<td class='record-value'>
					<%
					for (SecGenreEvLink secGenreEvLink : (Vector<SecGenreEvLink>) event.getSecGenreEvLinks()) {
						SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
						tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
						%>
						<a href="/pages/genre/<%=secGenreEvLink.getSecGenrePreferredId()%>">
							<%=tempSecGenre.getName()%>
						</a>
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
					
					<td class='record-value'>
					<%
					for (PrimContentIndicatorEvLink primContentIndicatorEvLink : (Vector<PrimContentIndicatorEvLink>) event.getPrimContentIndicatorEvLinks()) {
						%>
						<a href="/pages/subject/<%=primContentIndicatorEvLink.getPrimaryContentInd().getId()%>">
							<%=primContentIndicatorEvLink.getPrimaryContentInd().getName()%>
						</a>
						<br>
						<%
					}
					%>
					</td>
				</tr>
				<%
			}

			//  ORGANISATIONS  or Companies//
			if (!event.getOrgEvLinks().isEmpty()) {
			%>
				<tr>
					<th class='record-label b-90'>Organisations</th>
					
					<td class='record-value'>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						for (OrgEvLink orgEvLink : (Vector<OrgEvLink>) event.getOrgEvLinks()) {
							organisation = orgEvLink.getOrganisationBean();
							%>
							<tr>
								<td valign="top">
									<a href="/pages/organisation/<%=organisation.getId()%>&f_event_id=<%=event_id%>"><%=organisation.getName()%></a><%
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
					<th class='record-label b-90'>Contributor Name</th>
					
					<td class=''>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td  class='record-value bold' width='30%' >Name</td>
								<td  class='record-value bold' width='30%' >Function</td>
								<td  class='record-value bold' width='40%' >Notes</td>
							</tr>
						<%
						for (ConEvLink conEvLink : (Vector<ConEvLink>) event.getConEvLinks()) {
							contributor = conEvLink.getContributorBean();
							%>
							<tr>
								<td width='30%' class='record-value'>
									<a href="/pages/contributor/<%=contributor.getId()%>&f_event_id=<%=event_id%>">
										<%=contributor.getName() + " " + contributor.getLastName()%>
									</a>
								</td>
								<td width='30%' class='record-value'>
									<%=(hasValue(conEvLink.getContributorId()) && conEvLink.getContributorId().equals(Integer.toString(contributor.getId())))?conEvLink.getFunctionDesc():"" %>
								</td>
								<td width='40%' class='record-value'>
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
					
					<td class='record-value'>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						while (rset.next()) {
						%>
							<tr>
								<td colspan='3' width="100%"  valign="top">
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
						
						<td class='record-value'>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<%
							while (rset.next()) {
							%>
								<tr>
									<td colspan='3' width="100%"  class='record-value'>
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
				rset.close();
			}

			//Text Nationality
			for (Country playOrigin : (Vector <Country>) event.getPlayOrigins()) {
				if (hasValue(playOrigin.getName())) {
				%>
					<tr>
						<th class='record-label b-90'>Text Nationality</th>
						
						<td class='record-value'>
						<%=playOrigin.getName() %>
						</td>
					</tr>
				<%
				}
			}

			// Production Nationality
			for (Country prodOrigin : (Vector <Country>) event.getProductionOrigins()) {
				if (hasValue(prodOrigin.getName())) {
				%>
					<tr>
						<th class='record-label b-90'>Production Nationality</th>
						
						<td class='record-value'>
						<%=prodOrigin.getName() %>
						</td>
					</tr>
				<%
				}
			}

			//Further Information
			if (hasValue(event.getFurtherInformation())) {
			%>
				<tr>
					<th class='record-label b-90'>Further Information</th>
					
					<td class='record-value'>
					<%=event.getFurtherInformation()%>
					</td>
				</tr>
			<%	
			}

			if (!event.getDataSources().isEmpty()) {
			%>
				<tr>
					<th class='record-label b-90'>Data Source</td>
					
					<td class=''>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width='30%' class='record-value bold'>Source</td>
								
								<td width='30%' class='record-value bold'>Data Source Description</td>
								
								<td width='40%' class='record-value bold' >Part of Collection</td>
							</tr>
							<%

							for (Datasource datasource : (Vector <Datasource>) event.getDataSources()) {
								datasourceEvlink = new Datasource(db_ausstage_for_drill);
								datasourceEvlink.setEventId(event_id);
								datasourceEvlink.loadLinkedProperties(Integer.parseInt("0" + datasource.getDatasoureEvlinkId()));
								%>
								<tr>
									<td width='30%' class='record-value '><%=datasource.getName()%></td>
									
									<td width='30%' class='record-value '><%=datasourceEvlink.getDescription()%></td>
									
									<td width='40%' class='record-value '><%=datasourceEvlink.isCollection()%></td>
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
						<td class='record-value'><%=event.getEnteredByUser()%> on <%=dateFormat.format(event.getEnteredDate())%></td>
					<%
					} else {
					%>
						<td class='record-value'><%=event.getUpdatedByUser()%> on <%=dateFormat.format(event.getUpdatedDate())%></td>
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
					
					<td class='record-value'><%=event.getEventid()%></td>
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
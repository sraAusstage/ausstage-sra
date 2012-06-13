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
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0"
	style="border-collapse: collapse" bordercolor="#111111">
	<tr>
		<td bgcolor="#FFFFFF">
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

			// Table settings for main result display
			String baseTableWdth = "100%";
			String baseCol1Wdth = "200"; // Headings
			String baseCol2Wdth = "8"; // Spacer
			String baseCol3Wdth = ""; // Details for Heading
			// Table settings for secondary table required under a heading in the main result display
			String secTableWdth = "100%";
			String secCol1Wdth = "30%";
			String secCol2Wdth = "70%";
			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();

			///////////////////////////////////
			//    DISPLAY EVENT DETAILS
			//////////////////////////////////

			event = new Event(db_ausstage_for_drill);
			event.load(Integer.parseInt(event_id));
			descriptionSource = new DescriptionSource(db_ausstage_for_drill);

			if (displayUpdateForm) {
				displayUpdateForm(event_id, "Event", event.getEventName(), out, request, ausstage_search_appconstants_for_drill);
			}
			if (groupNames.contains("Administrators") || groupNames.contains("Event Editor"))
				out.println("<a class='editLink' target='_blank' href='/custom/event_addedit.jsp?mode=edit&f_eventid=" + event.getEventid() + "'>Edit</a>");

			//Event Name
			%>
			<table width='98%' align='center' border='0' cellpadding='3' cellspacing='0'>
				<tr bgcolor='#eeeeee'>
					<td align='right' width ='25%'	class='general_heading_light f-186' valign='top'>Event Name</td>
					<td>&nbsp;</td>
					<td width ='75%' ><b><%=event.getEventName()%></b></td>
				</tr>

			<%

			//Venue

			// Get venue location string
			String venueLocation = "";
			if (hasValue(event.getVenue().getSuburb())) venueLocation = ", " + event.getVenue().getSuburb();
			if (hasValue(event.getVenue().getState())) venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));
			
			%>
			<tr>
				<td align='right' class='general_heading_light f-186' valign='top'>Venue</td>
				<td>&nbsp;</td>
				<td><a href="/pages/venue/?id=<%=event.getVenueid()%>"><%=event.getVenue().getName()%></a><%=venueLocation%></td>
			</tr>
			<%

			//Umbrella Event
			if(hasValue(event.getUmbrella())) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Umbrella Event</td>
					<td>&nbsp;</td>
					<td><%=event.getUmbrella()%></td>
				</tr>
			<%	
			}
			
			//First Date
			if (!formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate()).equals("")) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>First Date</td>
					<td>&nbsp;</td>
					<td><%=formatDate(event.getDdfirstDate(), event.getMmfirstDate(), event.getYyyyfirstDate())%></td>
				</tr>
			<%
			}

			//Opening Date
			if (!formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate()).equals("")) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Opening Date</td>
					<td>&nbsp;</td>
					<td><%=formatDate(event.getDdopenDate(), event.getMmopenDate(), event.getYyyyopenDate())%></td>
				</tr>
			<%
			}

			//Last Date
			if (!formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate()).equals("")) {
				%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Opening Date</td>
					<td>&nbsp;</td>
					<td><%=formatDate(event.getDdlastDate(), event.getMmlastDate(), event.getYyyylastDate())%></td>
				</tr>
			<%
			}
			
			//Dates Estimated
			%>
			<tr>
				<td align='right' class='general_heading_light f-186' valign='top'>Dates Estimated</td>
				<td>&nbsp;</td>
				<td><%=Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()), true)%></td>
			</tr>
			<%
					

			//Status
			if (hasValue(event.getStatus())) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Status</td>
					<td>&nbsp;</td>
					<td><%=event.getEventStatus(event.getStatus())%></td>
				</tr>
			<%
			}
			
			//World Premier
			%>
			<tr>
				<td align='right' class='general_heading_light f-186' valign='top'>World Premiere</td>
				<td>&nbsp;</td>
				<td><%=Common.capitalise(Common.convertBoolToYesNo(event.getWorldPremier()), true)%></td>
			</tr>
			<%
			//Part of a tour -- remove me when event-event joins are done
			/*   if (event.getPartOfATour()) {
			    out.println("   <tr>");
			    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Part Of A Tour</td>");
			    out.println("     <td>&nbsp;</td>");
			    out.println("     <td  valign=\"top\">Yes</td>");
			    out.println("   </tr>");
			   }*/

			//Description
			if (hasValue(event.getDescription())) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Description</td>
					<td>&nbsp;</td>
					<td><%=event.getDescription()%></td>
				</tr>
			<%
			}

			//Description Source
			if (hasValue(event.getDescriptionSource()) && !event.getDescriptionSource().equals("0")) {
			%>
				<tr>
					<td align='right' class='general_heading_light f-186' valign='top'>Description Source</td>
					<td>&nbsp;</td>
					<td><%=descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource()))%></td>
				</tr>
			<%
			}

			// PRIMARY GENRE //
			%>
			<tr>
				<td align='right' class='general_heading_light f-186' valign='top'>Primary Genre</td>
				<td>&nbsp;</td>
				<td><%
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
					<td align='right' class='general_heading_light f-186' valign='top'>Secondary Genre</td>
					<td>&nbsp;</td>
					<td>
					<%
					for (SecGenreEvLink secGenreEvLink : (Vector<SecGenreEvLink>) event.getSecGenreEvLinks()) {
						SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
						tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
						%>
						<a href="/pages/genre/?id=<%=secGenreEvLink.getSecGenrePreferredId()%>">
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
					<td align='right' class='general_heading_light f-186' valign='top'>Subjects</td>
					<td>&nbsp;</td>
					<td>
					<%
					for (PrimContentIndicatorEvLink primContentIndicatorEvLink : (Vector<PrimContentIndicatorEvLink>) event.getPrimContentIndicatorEvLinks()) {
						%>
						<a href="/pages/subject/?id=<%=primContentIndicatorEvLink.getPrimaryContentInd().getId()%>">
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
					<td align='right' class='general_heading_light f-186' valign='top'>Organisations</td>
					<td>&nbsp;</td>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						for (OrgEvLink orgEvLink : (Vector<OrgEvLink>) event.getOrgEvLinks()) {
							organisation = orgEvLink.getOrganisationBean();
							%>
							<tr>
								<td valign="top">
									<a href="/pages/organisation/?id=<%=organisation.getId()%>&f_event_id=<%=event_id%>"><%=organisation.getName()%></a><%
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
					<td align='right' class='general_heading_light f-186' valign='top'>Contributor Name</td>
					<td>&nbsp;</td>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width='25%' class='general_heading_light' valign="top">Name</td>
								<td>&nbsp;</td>
								<td width='25%' class='general_heading_light' valign="top">Function</td>
								<td>&nbsp;</td>
								<td width='50%' class='general_heading_light' valign="top">Notes</td>
							</tr>
						<%
						for (ConEvLink conEvLink : (Vector<ConEvLink>) event.getConEvLinks()) {
							contributor = conEvLink.getContributorBean();
							%>
							<tr>
								<td valign="top">
									<a href="/pages/contributor/?id=<%=contributor.getId()%>&f_event_id=<%=event_id%>">
										<%=contributor.getName() + " " + contributor.getLastName()%>
									</a>
								</td>
								<td></td>
								<td valign="top">
									<%=(hasValue(conEvLink.getContributorId()) && conEvLink.getContributorId().equals(Integer.toString(contributor.getId())))?conEvLink.getFunctionDesc():"" %>
								</td>
								<td></td>
								<td valign="top">
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
				<tr class="b-185">
					<td class='general_heading_light f-186' valign='top' align='right'>Resources</td>
					<td>&nbsp;</td>
					<td valign="top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<%
						while (rset.next()) {
						%>
							<tr>
								<td colspan='3' width="100%"  valign="top">
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
				rset.close();
			}

			//Works
			rset = event.getAssociatedWorks(Integer.parseInt(event_id), stmt);
			if (rset != null && rset.isBeforeFirst()) {
				%>
					<tr class="b-185">
						<td class='general_heading_light f-186' valign='top' align='right'>Works</td>
						<td>&nbsp;</td>
						<td valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<%
							while (rset.next()) {
							%>
								<tr>
									<td colspan='3' width="100%"  valign="top">
										<a href="/pages/work/?id=<%=rset.getString("workid")%>">
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
						<td align='right' class='general_heading_light f-186' valign="top">Text Nationality</td>
						<td>&nbsp;</td>
						<td valign="top">
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
						<td align='right' class='general_heading_light f-186' valign="top">Production Nationality</td>
						<td>&nbsp;</td>
						<td valign="top">
						<%=prodOrigin.getName() %>
						</td>
					</tr>
				<%
				}
			}

			//Further Information
			if (hasValue(event.getFurtherInformation())) {
			%>
				<tr class="b-185">
					<td align='right' class='general_heading_light f-186' valign="top">Further Information</td>
					<td>&nbsp;</td>
					<td valign="top">
					<%=event.getFurtherInformation()%>
					</td>
				</tr>
			<%	
			}

			if (!event.getDataSources().isEmpty()) {
			%>
				<tr>
					<td class='general_heading_light f-186' valign='top' align='right'>Data Source</td>
					<td>&nbsp;</td>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width='30%' class='general_heading_light' valign="top">Source</td>
								<td>&nbsp;</td>
								<td width='30%' class='general_heading_light' valign="top">Data Source Description</td>
								<td>&nbsp;</td>
								<td width='40%' class='general_heading_light' valign="top">Part of Collection</td>
							</tr>
							<%

							for (Datasource datasource : (Vector <Datasource>) event.getDataSources()) {
								datasourceEvlink = new Datasource(db_ausstage_for_drill);
								datasourceEvlink.setEventId(event_id);
								datasourceEvlink.loadLinkedProperties(Integer.parseInt("0" + datasource.getDatasoureEvlinkId()));
								%>
								<tr>
									<td width='30%' class='general_heading_light' valign="top"><%=datasource.getName()%></td>
									<td>&nbsp;</td>
									<td width='30%' class='general_heading_light' valign="top"><%=datasourceEvlink.getDescription()%></td>
									<td>&nbsp;</td>
									<td width='40%' class='general_heading_light' valign="top"><%=datasourceEvlink.isCollection()%></td>
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
				<tr class="b-185">
					<td class='general_heading_light f-186' valign='top' align='right'>Data Reviewed By</td>
					<td>&nbsp;</td>
					<%
					if(!hasValue(event.getUpdatedByUser()) || event.getUpdatedByUser().equals("null")){
					%>
						<td valign="top"><%=event.getEnteredByUser()%> on <%=dateFormat.format(event.getEnteredDate())%></td>
					<%
					} else {
					%>
						<td valign="top"><%=event.getUpdatedByUser()%> on <%=dateFormat.format(event.getUpdatedDate())%></td>
					<%
					}
					%>	
				</tr>
				<%
			}

			//Event Identifier
			if (hasValue(event.getEventid())) {
			%>
				<tr class="b-185">
					<td align='right' class='general_heading_light f-186' valign="top">Event Identifier</td>
					<td>&nbsp;</td>
					<td valign="top"><%=event.getEventid()%></td>
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
				<a class="addthis_button_facebook_like"
					fb:like:layout="button_count"></a> <a
					class="addthis_button_tweet"></a> <a
					class="addthis_button_google_plusone" g:plusone:size="medium"></a>
				<a class="addthis_counter addthis_pill_style"></a>
			</div>
		</td>
	</tr>
</table>
<cms:include property="template" element="foot" />
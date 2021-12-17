<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.WorkWorkLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.RelationLookup, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ page import = "ausstage.Exhibition"%>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<jsp:include page="../../templates/header.jsp" />

<script type="text/javascript">
	function displayRow(name){
		document.getElementById("organisation").style.display = 'none';
		document.getElementById("organisationbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("contributor").style.display = 'none';
		document.getElementById("contributorbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("events").style.display = 'none';
		document.getElementById("eventsbtn").style.backgroundColor = '#aaaaaa';
		document.getElementById("venue").style.display = 'none';
		document.getElementById("venuebtn").style.backgroundColor = '#aaaaaa';
	
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
					CachedRowSet crset = null;
					ResultSet rsetEvt = null;
					CachedRowSet crsetCon = null;
					CachedRowSet crsetOrg = null;
					CachedRowSet crsetVen = null;
					ResultSet rset;
					Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
					String formatted_date = "";
					String work_id = db_ausstage_for_drill.plSqlSafeString(request.getParameter("id"));
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
					
					
				    Work assocWork = null;
				    Vector work_worklinks = work.getWorkWorkLinks();
					if(work_worklinks.size() > 0){assocWork = new Work(db_ausstage_for_drill);}
					
					
					Contributor assocContributor = null;
				    	Vector work_contriblinks = work.getAssociatedContributors();
					if(work_contriblinks.size() > 0){assocContributor = new Contributor(db_ausstage_for_drill);}
					//rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
					
					//Works
					%>
					<table class='record-table'>
						<tr>
							<th class='record-label b-153 bold'><img src='../../../resources/images/icon-work.png' class='box-icon'>Work</th>
							
							<td class='record-value bold' style='padding-right:290px'><%=work.getName()%>
							<%
							if (groupNames.contains("Administrators") || groupNames.contains("Works Editor"))
							out.println("[<a class='editLink' target='_blank' href='/custom/work_addedit.jsp?action=edit&f_workid=" + work.getId() + "'>Edit</a>]");
							%>
							</td>
							<td class='record-comment'>
							<%
							
							if (groupNames.contains("Administrators") || groupNames.contains("Exhibition Editor")) {%>		 		
							<cms:include page="../exhibition/add-to-exhibition.jsp" >
								<cms:param name="workid"><%= work_id%></cms:param>
							</cms:include>
							<%}
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
						//COUNTRY OF ORIGIN
						String countryOfOriginString = work.getLinkedCountryNames();
						if (countryOfOriginString != null && !countryOfOriginString.equals("")){
						%>
							<tr>
								<th class='record-label b-153'>Country of Origin</th>
								
								<td class='record-value squash-list'>
								<ul class='squash-list'><%
									for (String country: countryOfOriginString.split(",")){
									%>
								<li><%=country%></li>
								<%
								}
								%>
								</ul>
								</td>
							</tr>
						<%
						}
						//Date First Known
						if (!formatDate(work.getDdDateFirstKnown(), work.getMmDateFirstKnown(), work.getYyyyDateFirstKnown()).equals("")) {
						
						%>
							<tr>
								<th class='record-label b-153'>Date First Known</th>
								
								<td class='record-value'><%=formatDate(work.getDdDateFirstKnown(), work.getMmDateFirstKnown(), work.getYyyyDateFirstKnown())%></td>
							</tr>
						<%
						}
						
						//Contributors
						
						if (assocContributor != null && work_contriblinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Creator Contributors</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (WorkContribLink workContribLink : (Vector <WorkContribLink>) work_contriblinks) {
										boolean isParent = work_id.equals(workContribLink.getWorkId());
										assocContributor.load(Integer.parseInt(workContribLink.getContribId()));
										%>
											<li>
													<a href="/pages/contributor/<%=assocContributor.getId()%>">
														<%=assocContributor.getDisplayName() %>
													</a>
											
											</li>
										<%
										
									}
									%>
									</ul>
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
									<ul>
									<%
									while(rset.next()) {
										if (rset.getString("organisationid") != null) {
										%>
											<li>
									
													<a href="/pages/organisation/<%=rset.getString("organisationid")%>">
														<%=rset.getString("name")%>
													</a>
									
											</li>
										<%
										}
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						

						// Related Works
						if (assocWork != null && work_worklinks.size() > 0) {
							%>
							<tr>
								<th class='record-label b-153'>Related Works</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (WorkWorkLink workWorkLink : (Vector <WorkWorkLink>) work_worklinks) {
										boolean isParent = work_id.equals(workWorkLink.getWorkId());
										assocWork.load(new Integer((isParent)?workWorkLink.getChildId(): workWorkLink.getWorkId()).intValue());
										
										RelationLookup lookUpCode = new RelationLookup(db_ausstage_for_drill);
										if (workWorkLink.getRelationLookupId()!=null) lookUpCode.load(Integer.parseInt(workWorkLink.getRelationLookupId()));
										%>
										<li>
												<%=(isParent)?lookUpCode.getParentRelation():lookUpCode.getChildRelation() %>
												<a href="/pages/work/<%=assocWork.getId()%>">
													<%=assocWork.getName()%>
												</a>
												<%if((isParent) && !workWorkLink.getNotes().equals("")) out.print(" - "+workWorkLink.getNotes());
												  if((!isParent) && !workWorkLink.getChildNotes().equals("")) out.print(" - "+workWorkLink.getChildNotes());%>
										</li>
										<%
									}
									%>
									</ul>
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
							"venue.venue_name,venue.suburb,states.state,evcount.num, country.countryname as countryname  "+
							"FROM events,venue,states,eventworklink,orgevlink,organisation, country, "+
							"(SELECT orgevlink.organisationid, count(distinct orgevlink.eventid) num "+
							"FROM orgevlink, eventworklink where orgevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " "+
							"GROUP BY orgevlink.organisationid) evcount "+
							"WHERE eventworklink.workid = " + work_id + " AND "+
							"country.countryid = venue.countryid AND "+
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
							   "venue.venue_name,venue.suburb,states.state,evcount.num , functs.funct, country.countryname as countryname " +
							"FROM events,venue,states,country,eventworklink,conevlink,contributor " +
							"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
												  "FROM conevlink, eventworklink where conevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " " +
													"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
							"inner join (  " +
										      "select conel.contributorid, count(cf.preferredterm) functcount, group_concat(distinct cf.preferredterm separator ', ') funct  " +
										      "from conevlink conel  " +
										      "inner join eventworklink ewl on (ewl.eventid=conel.eventid)  " +
										      "inner join contributorfunctpreferred cf on (conel.function = cf.contributorfunctpreferredid)  " +
										      "where ewl.workid=" + work_id + "  " +
										      "group by conel.contributorid  " +
										      "order by count(conel.function) desc) functs on (functs.contributorid = contributor.contributorid) " +
							"WHERE eventworklink.workid = " + work_id + " AND " +
							"eventworklink.eventid = events.eventid AND " +
							"events.venueid = venue.venueid AND " +
							"venue.state = states.stateid AND " +
							"venue.countryid = country.countryid AND " +
							"events.eventid = eventworklink.eventid AND " +
							"eventworklink.eventid=conevlink.eventid AND " +
							"conevlink.contributorid = contributor.contributorid " +
							"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
							crsetCon = m_db.runSQL(sqlString, stmt);
							
							//venues
							sqlString = "SELECT DISTINCT venue.venueid, venue.venue_name, venue.suburb,states.state, " + 
								"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date,evcount.num, country.countryname as countryname " + 
								"FROM events,venue,states,country,eventworklink,orgevlink,organisation, " + 
								"(SELECT events.venueid, count(distinct eventworklink.eventid) num " + 
								"FROM events, eventworklink where events.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " " + 
								"GROUP BY events.venueid) evcount " + 
								"WHERE eventworklink.workid = " + work_id + " AND " + 
								"evcount.venueid = venue.venueid AND  " + 
								"eventworklink.eventid = events.eventid AND  " + 
								"events.venueid = venue.venueid AND  " + 
								"venue.state = states.stateid AND  " + 
								"venue.countryid = country.countryid AND " +
								"events.eventid = eventworklink.eventid AND  " + 
								"eventworklink.eventid=orgevlink.eventid AND  " + 
								"orgevlink.organisationid = organisation.organisationid  " + 
								"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
							crsetVen = m_db.runSQL(sqlString, stmt);
							
							rsetEvt = work.getAssociatedEv(Integer.parseInt(work_id), stmt);
							
							if (crsetOrg.size() > 0 || crsetCon.size() > 0 || crsetVen.size() > 0 || (rsetEvt != null && rsetEvt.isBeforeFirst())){
							
						%>

						<tr>
							<th class='record-label b-153'>Events</th>
							
							<td class='record-value' id="tabs" colspan=2>
								<ul class='record-tabs label'>
									<li <%=(rsetEvt != null && rsetEvt.isBeforeFirst())?"":"style='display: none'"%>><a href="#" onclick="displayRow('events')" id='eventsbtn'>Date</a></li>
									<li <%=(crsetCon.size() > 0)?"":"style='display: none'"%>><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributor</a></li>
									<li <%=(crsetOrg.size() > 0)?"":"style='display: none'"%>><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisation</a></li>
									<li <%=(crsetVen.size() > 0)?"":"style='display: none'"%>><a href="#" onclick="displayRow('venue')" id='venuebtn'>Venue</a></li>
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
										if (hasValue(rsetEvt.getString("Output"))) out.print(", " + rsetEvt.getString("Output").replace(", O/S", ", "+rsetEvt.getString("countryname")));
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
						  	        if(hasValue(crsetOrg.getString("suburb")) && (!crsetOrg.getString("suburb").equals("")||!crsetOrg.getString("suburb").equals(" "))) 
										out.print(", " + crsetOrg.getString("suburb"));
						           	if(hasValue(crsetOrg.getString("state")) && !crsetOrg.getString("state").equals("O/S"))
										out.print(", " + crsetOrg.getString("state"));
								else out.print(", " + crsetOrg.getString("countryname"));
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
									if(hasValue(crsetCon.getString("venue_name"))) out.print(", " + crsetCon.getString("venue_name"));
									if(hasValue(crsetCon.getString("suburb")) && (!crsetCon.getString("suburb").equals("")||!crsetCon.getString("suburb").equals(" "))) 
									out.print(", " + crsetCon.getString("suburb"));
									if(hasValue(crsetCon.getString("state")) && !crsetCon.getString("state").equals("O/S")) out.print(", " + crsetCon.getString("state"));
									else out.print(", " + crsetCon.getString("countryname"));
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
						
						<tr id='venue'>
						<%

						//Events by venue
						String prevVen = "";
						if (crsetVen.size() > 0) {
							%>
							<th class='record-label b-153'></td>
					 		
					 		<td class='record-value' colspan='2'>
							
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
								if(hasValue(crsetVen.getString("state")) && (!crsetVen.getString("state").equals("O/S")))
									out.print(", " + crsetVen.getString("state"));
								else out.print(", " + crsetVen.getString("countryname"));

								%>
								</h3>
								<ul>
									<%
									prevVen = crsetVen.getString("venueid");
								}
								
								%>
									<li>
									<a href="/pages/event/<%=crsetVen.getString("eventid")%>">
										<%=crsetVen.getString("event_name")%></a><%
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
						
						out.flush();
					 	%>
						</tr>
						<%
						//Exhibitions
						
						if (!(work.getExhibitions()).isEmpty()) {
							
						%>
							<tr>
								<th class='record-label b-153'>Exhibitions</th>
								
								<td class='record-value' colspan='2'>
								
									<ul>
								<%Vector<Exhibition> exhibitions = work.getExhibitions();
								
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
						//Resources
						rset = work.getAssociatedItems(Integer.parseInt(work_id), stmt);
						
  	  					if (rset != null && rset.isBeforeFirst()) {
  						%>
					 		<th class='record-label b-153'>Resources</th>
							
							<td class='record-value' colspan='2'>
								<ul id='resources'>
	  	  						<%
	  	  						while (rset.next()) {
	  	  						%>		<!--AUS 77-->

											<li> 
      											<%
											if (rset.getString("body") != null){
										        %>
										        <div style='width:20px; position:relative; float:left'>
									       	      	<!-- using bootstrap modal approach for this.-->
									 		<span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=rset.getString("itemid")%>'></span>
	
	      										<div id='article<%=rset.getString("itemid")%>' class="modal fade" role="dialog">
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
									      
										 <%=rset.getString("description")%>: <a href='/pages/resource/<%=rset.getString("itemid")%>' ><%=rset.getString("citation")%></a></li>											
							<!-- end aus 77-->

									<!--<li>
										<%=rset.getString("description")%>:
										<a href="/pages/resource/<%=rset.getString("itemid")%>">
											<%=rset.getString("citation")%>
										</a>
										
									</li>-->
								<%
								}
								%>
								</ul>
							</td>
						<%
						}
						rset.close();
						stmt.close();
						
						%>
						</tr>
						
						
						<%
						//Work Identifier
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
<jsp:include page="../../templates/footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "sun.jdbc.rowset.*, java.text.SimpleDateFormat"%>
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
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<script type="text/javascript">
function displayRow(name){
	document.getElementById("function").style.display = 'none';
	document.getElementById("functionbtn").style.backgroundColor = '#c0c0c0';
	document.getElementById("organisation").style.display = 'none';
	document.getElementById("organisationbtn").style.backgroundColor = '#c0c0c0';
	document.getElementById("contributor").style.display = 'none';
	document.getElementById("contributorbtn").style.backgroundColor = '#c0c0c0';
	document.getElementById("events").style.display = 'none';
	document.getElementById("eventsbtn").style.backgroundColor = '#c0c0c0';

	document.getElementById(name).style.display = '';
	document.getElementById(name+"btn").style.backgroundColor = '#000000';
	
}

function showHide(name) {
	if (document.getElementById(name).style.display != 'none') {
		document.getElementById(name).style.display = 'none';
	} else {
		document.getElementById(name).style.display = ''
	}
}
</script>
<style type="text/css">
	#tabs {
		padding: 10px;
		padding-top:35px;
	}
	
	#tabs a {
		padding-top: 8px;
		padding-bottom: 8px;
		padding-left: 14px;
		padding-right: 10px;
		text-decoration: none;
		background-color: #c0c0c0;
		color: white;
	}	
	
	#tabs a:hover {
		background-color: #bbbbbb;
	}
	
	#tabs .currentPage {
		background-color: #333333;
	}
	
	#tabs a:active {
		background-color: black;
	}
</style>



<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
	<tr>
		<td bgcolor="#FFFFFF">
			<%
			ausstage.Database db_ausstage_for_drill = new ausstage.Database ();
			db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
			
			CachedRowSet crset = null;
			ResultSet rset;
			Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
			String formatted_date = "";
			String event_id = request.getParameter("f_event_id");
			String contrib_id = request.getParameter("id");
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
			
			DescriptionSource descriptionSource;
			Datasource datasource;
			Datasource datasourceEvlink;
			
			
			Contributor contributor = null;
			
			SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
			
			// Table settings for main result display
			String baseTableWdth = "100%";
			String baseCol1Wdth	= "200";	// Headings
			String baseCol2Wdth	= "8";	// Spacer
			String baseCol3Wdth	= "";	// Details for Heading
			// Table settings for secondary table required under a heading in the main result display
			String secTableWdth = "100%";
			String secCol1Wdth	= "30%";
			String secCol2Wdth	= "70%";
			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();	
			
			if(contrib_id != null){
		
				contributor = new Contributor(db_ausstage_for_drill);
				contributor.load(Integer.parseInt(contrib_id));
				
				if (displayUpdateForm) {
					displayUpdateForm(contrib_id, "Contributor", contributor.getName() + " " + contributor.getLastName(),
						out,
						request,						
						ausstage_search_appconstants_for_drill);
				}
				
			
				
				if (groupNames.contains("Administrators") || groupNames.contains("Contributor Editor")) {
						out.println("<a class='editLink' target='_blank' href='/custom/contrib_addedit.jsp?act=edit&f_contributor_id=" + contributor.getId() + "'>Edit</a>");
				}
				
				%>
				<table width='98%' align='center' border='0' cellpadding='3' cellspacing='0'>
					<tr bgcolor='#eeeeee'>
						<td align='right' width ='25%'	class='general_heading_light f-186' valign='top'>Contributor Name</td>
						<td>&nbsp;</td>
						<td width ='75%' ><b><%=contributor.getPrefix() + " " + contributor.getName() + " " + contributor.getMiddleName() + " " + contributor.getLastName() + " " + contributor.getSuffix()%></b></td>
					</tr>
				
				<%
				// other name	
				if(hasValue(contributor.getOtherNames())) {
				%>
					<tr>
						<td align='right' class='general_heading_light f-186' valign='top'>Other names</td>
						<td>&nbsp;</td>
						<td><%=contributor.getOtherNames()%></td>
					</tr>
				<%
				}
				
				//Gender	
				if(hasValue(contributor.getGender())) {
				%>
					<tr bgcolor='#eeeeee'>
						<td align='right' class='general_heading_light f-186' valign='top'>Gender</td>
						<td>&nbsp;</td>
						<td><%=contributor.getGender()%></td>
					</tr>
				<%	
				}
				
				//Nationality
				if(hasValue(contributor.getNationality())) {
				%>
					<tr>
						<td align='right' class='general_heading_light f-186' valign='top'>Nationality</td>
						<td>&nbsp;</td>
						<td><%=contributor.getNationality()%></td>
					</tr>
				<%
				}
				
				//Place of Birth
				if(hasValue(contributor.getPlaceOfBirth())) {
					Venue pob = new Venue(db_ausstage_for_drill);
					pob.load(Integer.parseInt("0"+contributor.getPlaceOfBirth()));
					%>
					<tr bgcolor='#eeeeee'>
						<td align='right' class='general_heading_light f-186' valign='top'>Place Of Birth</td>
						<td>&nbsp;</td>
						<td><a href="/pages/venue/?id=<%=contributor.getPlaceOfBirth()%>"><%=pob.getName()%></a></td>
					</tr>
					<%
				}
				
				//Place of Death
				if(hasValue(contributor.getPlaceOfDeath())) {
					Venue pod = new Venue(db_ausstage_for_drill);
					pod.load(Integer.parseInt("0"+contributor.getPlaceOfDeath()));
					%>
					<tr>
						<td align='right' class='general_heading_light f-186' valign='top'>Place Of Death</td>
						<td>&nbsp;</td>
						<td><a href="/pages/venue/?id=<%=contributor.getPlaceOfDeath()%>"><%=pod.getName()%></a></td>
					</tr>
					<%
				}
			
				//Legally can only display date of birth if the date of death is null. 
				String dateOfBirth = formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear());
				String dateOfDeath = formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear());
				
				if(!hasValue(dateOfDeath)) {
					if(hasValue(dateOfBirth)) { //Date of Birth
					%>
						<tr bgcolor='#eeeeee'>
							<td align='right' class='general_heading_light f-186' valign='top'>Date of Birth</td>
							<td>&nbsp;</td>
							<td><%=dateOfBirth%></td>
						</tr>
					<%
					} 
				} else { //Date of death
				%>
					<tr bgcolor='#eeeeee'>
						<td align='right' class='general_heading_light f-186' valign='top'>Date of Death</td>
						<td>&nbsp;</td>
						<td><%=dateOfDeath %></td>
					</tr>
				<%
				}
				
				
				//Functions
				String functions = "";
				if(!hasValue(event_id)){ // If we don't have a specific event just get the functions from contributor
					functions = contributor.getContFunctPreffTermByContributor(contrib_id);
				} else { // If we do, need to load and loop through the ConEvLink
					ConEvLink conEvLink = new ConEvLink(db_ausstage_for_drill);
					conEvLink.load(contrib_id, event_id);
					Vector <ConEvLink> eventLinks = conEvLink.getConEvLinksForEvent(Integer.parseInt(event_id));
					
					for(ConEvLink tempEvLink: eventLinks){
						if(tempEvLink.getContributorId() != null && tempEvLink.getContributorId().equals(contrib_id)){
							if(!functions.equals("")) functions += ", ";
							functions += tempEvLink.getFunctionDesc();
						}
					}
				}
				
				if(hasValue(functions)) {
				%>
					<tr>
						<td align='right' class='general_heading_light f-186' valign='top'>Functions</td>
						<td>&nbsp;</td>
						<td valign="top"><%=functions%></td>
					</tr>
				<%
				}
				
				//Notes
				if(hasValue(contributor.getNotes())) {
				%>
					<tr bgcolor='#eeeeee'>
						<td align='right' class='general_heading_light f-186' valign='top'>Notes</td>
						<td>&nbsp;</td>
						<td valign='top'><%=contributor.getNotes()%></td>
					</tr>
				<%
				}
				
				//NLA
				if(hasValue(contributor.getNLA())) {
				%>
					<tr>
						<td align='right' class='general_heading_light f-186' valign='top'>NLA</td>
						<td>&nbsp;</td>
						<td valign='top'><%=contributor.getNLA()%></td>
					</tr>
				<%
				}
				
				
				// Tab-Switching buttons
				%>
				<tr>
					<td align='right' class='general_heading_light' valign='top'></td>
					<td>&nbsp;</td>
					<td id="tabs" colspan='3'>
						<a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a>
						<a href="#" onclick="displayRow('function')" id='functionbtn'>Functions</a>
						<a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributor</a>
						<a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisation</a>
					</td>
				</tr>
				
				<tr id='events'>
				
				<%
				//Events Tab
				event = new Event(db_ausstage_for_drill);
				crset = event.getEventsByContrib(Integer.parseInt(contrib_id));
				int contribEventCount=0;
				
				if (crset.size() > 0) {
				%>
					<td align='right' class='general_heading_light' valign='top'></td>
						<td>&nbsp;</td>
						<td valign="top">
						<ul>
						<%
						while (crset.next()){
						%>
							<li><a href="/pages/event/?id=<%=crset.getString("eventid")%>"><%=crset.getString("event_name")%></a><%
							if(hasValue(crset.getString("venue_name")))	out.print(", " +	crset.getString("venue_name"));
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
				
				crset.close();
				%>
				</tr>
				
				
				<tr id='function'>
				<%
			
				//Functions Tab
				
				// Connect to the database so we can run a SQL query
				ausstage.Database m_db = new ausstage.Database ();
				m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
				stmt = db_ausstage_for_drill.m_conn.createStatement();
				int i=0;
				String sqlString = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date, "+
				 "events.yyyyfirst_date,events.first_date,venue.venue_name,venue.suburb,states.state,contributorfunctpreferred.preferredterm, evcount.num "+
				"FROM events,venue,states,conevlink,contributor,contributorfunctpreferred "+
				"left join ( "+
				"SELECT ce.contributorid, cf.contributorfunctpreferredid, count(*) num "+
				"FROM conevlink ce,contributorfunctpreferred cf "+
				"where ce.function=cf.contributorfunctpreferredid "+
				"and ce.contributorid=" + contrib_id + " "+
				"group by cf.preferredterm "+
				") evcount ON (evcount.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid) "+
				"where contributor.contributorid=" + contrib_id + " "+
				"and contributor.contributorid=conevlink.contributorid "+
				"and conevlink.eventid=events.eventid "+
				"and events.venueid=venue.venueid "+
				"and venue.state=states.stateid "+
				"AND conevlink.function=contributorfunctpreferred.contributorfunctpreferredid "+
				"order by evcount.num desc, contributorfunctpreferred.preferredterm,events.first_date desc";
				crset = m_db.runSQL(sqlString, stmt);
					 
				out.flush();
				
				String prevFunc = "";
				if (crset.size() > 0) {
				%>
					<td align='right' class='general_heading_light' valign='top'></td>
			 		<td>&nbsp;</td>
			 		<td valign="top">
					
					<%	
					while (crset.next()){
						// If we're starting a new function, check if we have to finish the previous one
						if (!prevFunc.equals(crset.getString("preferredterm"))) {
							if (hasValue(prevFunc)) out.print("</ul>");
							
							// Now start the new one
							%>
						<%=crset.getString("preferredterm")%><br>
						<ul>
							<%
							prevFunc = crset.getString("preferredterm");
						}
						%>
						<li><a href="/pages/event/?id=<%=crset.getString("eventid")%>"><%=crset.getString("event_name")%></a><%
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
				stmt.close();
				%>
				</tr>
				
				
				<tr id='contributor'>
				<%
				//Contributor Tab
				stmt = db_ausstage_for_drill.m_conn.createStatement();
				sqlString = 
				"select distinct events.event_name, events.eventid, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, " +
				"contributor.contributorid, contributor.first_name, contributor.last_name, " +
				"concat_ws(', ', venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state)) venue, " +
				"concount.counter, functs.funct " +
				"from contributor " +
				"inner join conevlink a on (contributor.contributorid = a.contributorid) " +
				"inner join events on (events.eventid = a.eventid) " +
				"inner join conevlink b on (a.eventid = b.eventid) " +
				"inner join venue on (events.venueid = venue.venueid) " +
				"left join states on (venue.state = states.stateid) " +
				"left join country on (venue.countryid = country.countryid) " +
				"left join (" +
				"select distinct c.contributorid, count(distinct d.eventid) counter " +
				"from conevlink c " +
				"inner join conevlink d on (c.eventid = d.eventid)	" +
				"where d.contributorid = " + contrib_id + " " +
				"group by c.contributorid" +
				") concount on (concount.contributorid = contributor.contributorid) " +
				"inner join ( " +
				"select e.contributorid, count(cf.preferredterm) functcount, group_concat(distinct cf.preferredterm separator ', ') funct " +
				"from conevlink e " +
				"inner join conevlink f on (e.eventid = f.eventid)	" +
				"inner join contributorfunctpreferred cf on (e.function = cf.contributorfunctpreferredid) " +
				"where f.contributorid = " + contrib_id + " " +
				"group by e.contributorid " +
				"order by count(e.function) desc " +
				") functs on (functs.contributorid = contributor.contributorid) " +
				"where b.contributorid = " + contrib_id + " " +
				"and a.contributorid != " + contrib_id + " " +
				"order by concount.counter desc, contributor.last_name, contributor.first_name, events.first_date desc";
				crset = m_db.runSQL(sqlString, stmt);
				
				String prevCont = "";
				if (crset.size() > 0) {
				%>
					<td align='right' class='general_heading_light' valign='top'></td>
			 		<td>&nbsp;</td>
			 		<td valign="top">
					
					<%	
					while (crset.next()){
						// If we're starting a new contributor, check if we have to finish the previous one
						if (!prevCont.equals(crset.getString("contributorid"))) {
							if (hasValue(prevCont)) out.print("</ul>");
							
							// Now start the new one
							%>
						<a href="/pages/contributor/?id=<%=crset.getString("contributorid")%>">
							<%=crset.getString("first_name")+" "+crset.getString("last_name")%>
						</a> - <%=crset.getString("funct")%>
						<br>
						<ul>
							<%
							prevCont = crset.getString("contributorid");
						}
						
						%>
							<li>
							<a href="/pages/event/?id=<%=crset.getString("eventid")%>">
							<%=crset.getString("event_name")%></a>, 
							<%=crset.getString("venue")%>, 
							<%=formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE"))%>
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
				stmt.close();
				%>
				</tr>
				
				
				<tr id='organisation'>
				<%
				//Organisation Tab
				stmt = db_ausstage_for_drill.m_conn.createStatement();
				sqlString = 
				"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
				"events.first_date,venue.venue_name,venue.suburb,states.state,organisation.name,organisation.organisationid,evcount.num "+
				"FROM events,venue,states,organisation,conevlink,orgevlink "+
				"left join (SELECT oe.organisationid, count(distinct oe.eventid) num "+
				"FROM orgevlink oe, conevlink ce where ce.eventid=oe.eventid and ce.contributorid=" + contrib_id + " "+
				"group by oe.organisationid) evcount ON (evcount.organisationid = orgevlink.organisationid)"+
				"WHERE conevlink.contributorid = " + contrib_id + " AND " + 
				"conevlink.eventid = events.eventid AND "+
				"events.venueid = venue.venueid AND "+
				"venue.state = states.stateid AND "+
				"events.eventid = orgevlink.eventid AND "+
				"orgevlink.organisationid = organisation.organisationid "+
				"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
				crset = m_db.runSQL(sqlString, stmt);
						
				String prevOrg = "";
				if (crset.size() > 0) {
				%>
					<td align='right' class='general_heading_light' valign='top'></td>
			 		<td>&nbsp;</td>
			 		<td valign="top">
					
					<%	
					while (crset.next()){
						// If we're starting a new contributor, check if we have to finish the previous one
						if (!prevOrg.equals(crset.getString("name"))) {
							if (hasValue(prevOrg)) out.print("</ul>");
							
							// Now start the new one
							%>
						<a href="/pages/contributor/?id=<%=crset.getString("organisationid")%>">
							<%=crset.getString("name")%>
						</a>
						<br>
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
				stmt.close();
				%>
				</tr>
			 	
			 	<%
				//Items
				stmt = db_ausstage_for_drill.m_conn.createStatement();
				rset = contributor.getAssociatedItems(Integer.parseInt(contrib_id), stmt);	
				if(rset != null && rset.isBeforeFirst()) {
				%>
					<tr>
				 		<td align='right' class='general_heading_light f-186' valign='top'><a class='f-186' href="#" onclick="showHide('resources')">Resources</a></td>
						<td>&nbsp;</td>
						<td>
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
				rset.close();
				stmt.close();
				
				
				//Works
				stmt = db_ausstage_for_drill.m_conn.createStatement();
				rset = contributor.getAssociatedWorks(Integer.parseInt(contrib_id), stmt);
				if(rset != null && rset.isBeforeFirst()) {
					%>
					<tr>
				 		<td align='right' class='general_heading_light f-186' valign='top'><a class='f-186' href="#" onclick="showHide('resources')">Resources</a></td>
						<td>&nbsp;</td>
						<td>
							<table id='works' width="<%=secTableWdth%>" border="0" cellpadding="3" cellspacing="0">
							<%
							while(rset.next()) {
							%>
								<tr>
									<td	valign="top">
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
				}
				rset.close();
				
				//Contributor ID
				%>
				<tr bgcolor='#eeeeee'>
					<td align='right' class='general_heading_light f-186' valign='top'>Contributor Identifier</td>
					<td width="<%=baseCol2Wdth%>">&nbsp;</td>
					<td width="<%=baseCol3Wdth%>"><%=contributor.getId()%></td>
				</tr>	
			</table>
		<%
		} 
		// close statement
		stmt.close();
		%>
		<script>
		if (!document.getElementById("function").innerHTML.match("[A-Za-z]")) document.getElementById("functionbtn").style.display = "none";
		if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
		if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
		if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
		displayRow("events");
		</script>
		</td>
	</tr>
	
</table>
<cms:include property="template" element="foot" />
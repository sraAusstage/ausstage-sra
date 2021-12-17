<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor, ausstage.ContributorContributorLink"%>
<%@ page import = "ausstage.Item, ausstage.RelationLookup, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>

<%@ page session="true" import=" java.lang.String, java.util.*" %>

<%@ include file="../../public/common.jsp"%>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
 

<%
ausstage.Database db_ausstage_for_drill = (ausstage.Database)session.getAttribute("database-connection");

if(db_ausstage_for_drill == null) {
	db_ausstage_for_drill = new ausstage.Database();
	db_ausstage_for_drill.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
}

CachedRowSet crsetEvt       = null;
CachedRowSet crsetFun       = null;
CachedRowSet crsetCon       = null;
CachedRowSet crsetOrg       = null;
CachedRowSet crset          = null;

ResultSet    rset;
Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
String formatted_date       = "";
String event_id             = request.getParameter("f_event_id");
String contrib_id           = request.getParameter("contributorid");
Vector item_evlinks;
Vector item_orglinks;
Vector item_creator_orglinks;
Vector item_venuelinks;
Vector item_conlinks;
Vector work_conlinks;
Vector item_creator_conlinks;
Vector item_artlinks;
Vector item_secgenrelinks;
Vector item_worklinks;
Vector item_itemlinks;
Vector item_contentindlinks;
List<String> groupNames = new ArrayList();	
if (session.getAttribute("userName")!= null) {
	admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
}

  State state = new State(db_ausstage_for_drill);
  Event event = null;
  
  DescriptionSource descriptionSource;
  Datasource datasource;
  Datasource datasourceEvlink;

  Venue venue = null;
  PrimaryGenre primarygenre;
  SecGenreEvLink secGenreEvLink;
  Country country;
  PrimContentIndicatorEvLink primContentIndicatorEvLink;
  OrgEvLink orgEvLink;
  Organisation organisation;
  Organisation organisationCreator = null;
  ConEvLink conEvLink;
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
  String baseCol1Wdth  = "200";  // Headings
  String baseCol2Wdth  = "8";   // Spacer
  String baseCol3Wdth  = "";  // Details for Heading
  // Table settings for secondary table required under a heading in the main result display
  String secTableWdth = "100%";
  String secCol1Wdth  = "30%";
  String secCol2Wdth  = "70%";
  boolean displayUpdateForm = true;
  admin.Common Common = new admin.Common();  

  if(contrib_id != null){

    ///////////////////////////////////
    //    DISPLAY CONTRIBUTOR DETAILS
    //////////////////////////////////

    contributor = new Contributor(db_ausstage_for_drill);
    contributor.load(Integer.parseInt(contrib_id));
	
    Contributor assocContrib = null;
    Vector contrib_contriblinks = contributor.getContributorContributorLinks();
    if(contrib_contriblinks.size() > 0){
    	assocContrib = new Contributor(db_ausstage_for_drill);
    }
   
%> 
<div style="margin: 0px;">
	<div class='b-105 browse-bar show-hide' >


    			<img src='/resources/images/icon-contributor.png' class='browse-icon' />
    			<span class='browse-heading large'><%=contributor.getPrefix()%> <%=contributor.getName()%> <%=contributor.getMiddleName()%> <%=contributor.getLastName()%> <%=contributor.getSuffix()%></span>
 			
 			<span class="show-hide-icon glyphicon glyphicon-chevron-up"></span>

	</div>
	<div style="width: 100%;" class="toggle-div">
   		<div class='record'  style="margin: 0px; padding-bottom: 0em;">
			<table class='record-table'  style="margin-top: 0px;">
    <%
    // Other names
    if(contributor.getOtherNames() != null && !contributor.getOtherNames().equals("")) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Other Names</th>
		<td class='record-value'><%=contributor.getOtherNames()%></td>    
	</tr>
    <%
    }
    %>     
    <%
    // Gender
    if(contributor.getGender() != null && !contributor.getGender().equals("")) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Gender</th>
		<td class='record-value'><%=contributor.getGender()%></td>    
	</tr>
    <%
    }
    %>
    <%
    // Nationality
    if(contributor.getNationality() != null && !contributor.getNationality().equals("")) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Nationality</th>
		<td class='record-value'><%=contributor.getNationality()%></td>    
	</tr>
    <%
    }
    %>
    <%
    // Date Of Birth
    if (hasValue(contributor.getDodYear()) && hasValue(contributor.getDobYear())) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Date of Birth</th>
		<td class='record-value'><%=formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear())%></td>    
	</tr>
    <%
    }
    %>
      <%
    // Place Of Birth
     if(contributor.getPlaceOfBirth() != null && !contributor.getPlaceOfBirth().equals("")) {
     	    Venue pob = new Venue(db_ausstage_for_drill);
            pob.load(Integer.parseInt("0"+contributor.getPlaceOfBirth()));
    %>
    	<tr>
    		<th class='record-label contributor-light '>Place of Birth</th>
		<td class='record-value'><a href="/pages/venue/<%=contributor.getPlaceOfBirth()%>"><%=pob.getName()%></a></td>    
	</tr>
    <%
    }
    %> 
    <%
    // Date Of Death
     if (hasValue(contributor.getDodYear()) && hasValue(contributor.getDobYear())) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Date of Death</th>
		<td class='record-value'><%=formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear())%></td>    
	</tr>
    <%
    }
    %>
    <%
    // Place Of Death
     if(contributor.getPlaceOfDeath() != null && !contributor.getPlaceOfDeath().equals("")) {
     	    Venue pod = new Venue(db_ausstage_for_drill);
            pod.load(Integer.parseInt("0"+contributor.getPlaceOfDeath()));
    %>
    	<tr>
    		<th class='record-label contributor-light '>Place of Death</th>
		<td class='record-value'><a href="/pages/venue/<%=contributor.getPlaceOfDeath()%>"><%=pod.getName()%></a></td>    
	</tr>
    <%
    }
    %>
    
    <!-- Functions -->
    <% 
    String contrib_functions = "";
    if(event_id != null && !event_id.equals("")){
      ConEvLink contribeventlink = new ConEvLink(db_ausstage_for_drill);
      contribeventlink.load(contrib_id, event_id);
      Vector contribeventlinkvec;
      contribeventlinkvec = contribeventlink.getConEvLinksForEvent(Integer.parseInt(event_id));
      for(int i =0; i < contribeventlinkvec.size(); i++){
        if(((ConEvLink)contribeventlinkvec.get(i)).getContributorId() != null
          && ((ConEvLink)contribeventlinkvec.get(i)).getContributorId().equals(contrib_id)){
          if(contrib_functions.equals(""))
            contrib_functions = ((ConEvLink)contribeventlinkvec.get(i)).getFunctionDesc();
          else
            contrib_functions += ", " + ((ConEvLink)contribeventlinkvec.get(i)).getFunctionDesc();
        }
      }
    }else{
      contrib_functions = contributor.getContFunctPreffTermByContributor(contrib_id);
    }
    if(contrib_functions != null && !contrib_functions.equals("")){
    %>
    <tr>
    		<th class='record-label contributor-light '>Functions</th>
		<td class='record-value'><%=contrib_functions%></td>    
    </tr>
    <%}
    // Notes
    if(contributor.getNotes() != null && !contributor.getNotes().equals("")) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>Notes</th>
		<td class='record-value'><%=contributor.getNotes()%></td>    
	</tr>
    <%
    }
    %>
    <%
    // NLA
    if(contributor.getNLA() != null && !contributor.getNLA().equals("")) {
    %>
    	<tr>
    		<th class='record-label contributor-light '>NLA</th>
		<td class='record-value'><%=contributor.getNLA()%></td>    
	</tr>
    <%
    }
    %> 
    <%
    //this is all old code, copied and pasted. TODO clean it up!
    // Contributors
	if (assocContrib != null && contrib_contriblinks.size() > 0) {
		%>
		<tr>
			<th class='record-label contributor-light '>Related Contributors</th>
			
			<td class='record-value' colspan='2'>
				<ul>
				<%
				for (ContributorContributorLink contribContribLink : (Vector <ContributorContributorLink>) contrib_contriblinks) {
					boolean isParent = true;
					if(contrib_id.equals(contribContribLink.getChildId())){
						isParent = false;
						assocContrib.load(new Integer(contribContribLink.getContributorId()).intValue());
					}else{
						assocContrib.load(new Integer(contribContribLink.getChildId()).intValue());
					}
					RelationLookup relationLookup = new RelationLookup(db_ausstage_for_drill);
					if (contribContribLink.getRelationLookupId() != null) relationLookup.load(Integer.parseInt(contribContribLink.getRelationLookupId()));
					%>
					<li>
							<%=(isParent)?relationLookup.getParentRelation():relationLookup.getChildRelation()%>
							<!--display name as Link 		(function1, function2. Event Dates : YYYY-YYYY). Comments-->

							<%out.print("<a href=\"/pages/contributor/"+assocContrib.getId()+"\" >"+assocContrib.getDisplayName()+"</a>");
							
							//if has functions or a date range 
							String contDateRange = assocContrib.getContributorDateRange(Integer.toString(assocContrib.getId()));
							if (contDateRange==null){
								contDateRange = "";
							}
							String contFunctions = assocContrib.getContFunctPreffTermByContributor(Integer.toString(assocContrib.getId()));
							if (contFunctions==null){
								contFunctions = "";
							}
							if (!contDateRange.equals("") || !contFunctions.equals("")){
								out.print(" (");
								if (!contFunctions.equals("")){
									out.print(contFunctions);
								}
								if (!contDateRange.equals("")){
									if(!contFunctions.equals("")){
										out.print(". ");
									}
									out.print("Event Dates: "+contDateRange );
								}
								out.print(")");
							}
							//AUS-76 out.print(". ");
							 	if (isParent){
									if(contribContribLink.getNotes().equals("") == false) out.print(". "+contribContribLink.getNotes());	
								} else 
								{
									if(contribContribLink.getChildNotes().equals("") == false) out.print(". "+contribContribLink.getChildNotes());
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
    out.flush();
   
    %>
    <!-- script for associated objects -->
    <script type="text/javascript">
    function displayRow(name, id){
    	
    
    	document.getElementById("function"+id).style.display = 'none';
    	document.getElementById("function"+id+"btn").style.backgroundColor = '#aaaaaa';
    	document.getElementById("organisation"+id).style.display = 'none';
    	document.getElementById("organisation"+id+"btn").style.backgroundColor = '#aaaaaa';
    	document.getElementById("contributor"+id).style.display = 'none';
    	document.getElementById("contributor"+id+"btn").style.backgroundColor = '#aaaaaa';
    	document.getElementById("events"+id).style.display = 'none';
    	document.getElementById("events"+id+"btn").style.backgroundColor = '#aaaaaa';
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
    
    
     
    <%
    
    //get associated objects
    //events
      	event = new Event(db_ausstage_for_drill);
	crsetEvt = event.getEventsByContrib(Integer.parseInt(contrib_id));	
	   //functions
	admin.AppConstants constants = new admin.AppConstants();
	ausstage.Database     m_db = new ausstage.Database ();
	m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
	Statement stmt1    = m_db.m_conn.createStatement ();
	String sqlString = ""; 
	int eventfunccount = 0;
	int i=0;
	sqlString = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date, "+
	     "events.yyyyfirst_date,events.first_date,venue.venue_name,venue.suburb,states.state,contributorfunctpreferred.preferredterm, evcount.num "+
	    ",concat_ws(', ', venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state)) venue " +
	    "FROM events,venue " +
	    "left join country on (venue.countryid = country.countryid) " +
	    ",states,conevlink,contributor,contributorfunctpreferred "+
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
    	
  	crsetFun = m_db.runSQL(sqlString, stmt1);
  	
    //contributor
     	Statement stmt2    = m_db.m_conn.createStatement ();
     	String sqlString2 = ""; 
	int eventconcount = 0;
	sqlString2 = 
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
		"inner join conevlink d on (c.eventid = d.eventid)  " +
		"where d.contributorid = " + contrib_id + " " +
		"group by c.contributorid" +
		") concount on (concount.contributorid = contributor.contributorid) " +
		"inner join ( " +
		"select e.contributorid, count(cf.preferredterm) functcount, group_concat(distinct cf.preferredterm separator ', ') funct " +
		"from conevlink e " +
		"inner join conevlink f on (e.eventid = f.eventid)  " +
		"inner join contributorfunctpreferred cf on (e.function = cf.contributorfunctpreferredid) " +
		"where f.contributorid = " + contrib_id + " " +
		"group by e.contributorid " +
		"order by count(e.function) desc " +
		") functs on (functs.contributorid = contributor.contributorid) " +
		"where b.contributorid = " + contrib_id + " " +
		"and a.contributorid != " + contrib_id + " " +
		"order by concount.counter desc, contributor.last_name, contributor.first_name, events.first_date desc";
	crsetCon = m_db.runSQL(sqlString2, stmt2); 
	
    //organisation
	stmt2    = m_db.m_conn.createStatement ();
     	sqlString2 = ""; 
	int eventorgcount = 0;
	sqlString2 = 
	    "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
	  	"events.first_date,venue.venue_name,venue.suburb,states.state,organisation.name,organisation.organisationid,evcount.num "+
	  	",concat_ws(', ', venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state)) venue " +
	  	"FROM events,states,organisation,conevlink,venue "+
	  	"left join country on (venue.countryid = country.countryid) "+
	  	",orgevlink "+
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
	crsetOrg = m_db.runSQL(sqlString2, stmt2); 
	
	if (crsetEvt.size() > 0 || crsetFun.size() > 0 || crsetCon.size() > 0 || crsetOrg.size() > 0) {	
    %>
 <tr><th class='record-label contributor-light '></th></tr>   
    
    <tr>
    <th class='record-label  contributor-light '>Events</th>
<td colspan=2 class="record-value">
<ul class="record-tabs label">
    	<li><a href="#" onclick="displayRow('events<%=contributor.getId()%>', '<%=contributor.getId()%>')" id='events<%=contributor.getId()%>btn'>Date</a></li>
    	<li><a href="#" onclick="displayRow('function<%=contributor.getId()%>', '<%=contributor.getId()%>')" id='function<%=contributor.getId()%>btn'>Function</a></li>
    	<li><a href="#" onclick="displayRow('contributor<%=contributor.getId()%>', '<%=contributor.getId()%>')" id='contributor<%=contributor.getId()%>btn'>Contributor</a></li>
    	<li><a href="#" onclick="displayRow('organisation<%=contributor.getId()%>', '<%=contributor.getId()%>')" id='organisation<%=contributor.getId()%>btn'>Organisation</a></li>
   </ul>
    </td>
    </tr>
    
<%
	}
   //Associated Events
  %>
  <tr id='events<%=contributor.getId()%>' class='events-tab'>
  <%
  int contribEventCount=0;
  if(crsetEvt.next()){
    do{      
      if(contribEventCount==0){
      
      %>
      <th class='record-label contributor-light '></th>
      	<td class='record-value' colspan='2'>
      		<ul>
      <%
      
      contribEventCount++;
    }
    %>
    		<li><a href='/pages/event/<%=crsetEvt.getString("eventid")%>'><%=crsetEvt.getString("event_name")%></a>
    <%          if(hasValue(crsetEvt.getString("venue"))) 
		      out.print(", " +  crsetEvt.getString("venue"));
  	        if (hasValue(crsetEvt.getString("DDFIRST_DATE")) || hasValue(crsetEvt.getString("MMFIRST_DATE")) || hasValue(crsetEvt.getString("YYYYFIRST_DATE")))
 	      	      out.print(", " + formatDate(crsetEvt.getString("DDFIRST_DATE"),crsetEvt.getString("MMFIRST_DATE"),crsetEvt.getString("YYYYFIRST_DATE")));
    %>
	        </li>
    <%         
  }while(crsetEvt.next());
	if(contribEventCount>0)
    out.println("</ul>");
  }
  out.println("   </td></tr>"); 

  //Events by function     
  out.flush();
  %><tr id='function<%=contributor.getId()%>' class='events-tab'><%
  String prevFunc = "";
  if(crsetFun.next()){
    do{
      if(eventfunccount==0){
 	out.println("     <td class='contributor-light '></td>");
 	out.println("     <td class='record-value' colspan='2'>");
     }
     eventfunccount++;

     if (!prevFunc.equals(crsetFun.getString("preferredterm"))) {
        	if (eventfunccount > 1) {
        		out.print("</ul>");
        	}
        	out.print("<h3>"+crsetFun.getString("preferredterm")+ "</h3><ul>");
        	prevFunc = crsetFun.getString("preferredterm");
        }
 	        out.print("<li><a href=\"/pages/event/" +
 	        		crsetFun.getString("eventid") + "\">"+crsetFun.getString("event_name")+"</a>, ");
          if(hasValue(crsetFun.getString("venue")))
          	out.print(" "+crsetFun.getString("venue"));
          
          if (hasValue(crsetFun.getString("DDFIRST_DATE")) || hasValue(crsetFun.getString("MMFIRST_DATE")) || hasValue(crsetFun.getString("YYYYFIRST_DATE")))
           out.print(", " + formatDate(crsetFun.getString("DDFIRST_DATE"),crsetFun.getString("MMFIRST_DATE"),crsetFun.getString("YYYYFIRST_DATE")));
       out.println("</li>"); 
    	 }while(crsetFun.next());
    	 if(eventfunccount>0)
    	 out.println("</ul>");
    	 out.println("</td>");
     }out.println("   </tr>");
     
     
   out.flush();
     
     //Associated Contributor by Events
    %>
    <tr id='contributor<%=contributor.getId()%>' class='events-tab'>
    <%
      String prevCon = "";
      if(crsetCon.next()){
     	 do{
     		 if(eventconcount==0){
  		out.println("     <td class='contributor-light '></td>");
  	        out.println("     <td class='record-value' colspan='2'>");
  	        
     		 }
     		eventconcount++;
     		 if (!prevCon.equals(crsetCon.getString("contributorid"))) {
  	        	if (eventconcount> 1) {
  	        		out.println("</ul>");
  	        	}
  	        	out.println("<h3><a href=\"/pages/contributor/" + crsetCon.getString("contributorid") + "\">" + 
  	        	crsetCon.getString("first_name")+" "+crsetCon.getString("last_name")+ "</a> - " + crsetCon.getString("funct") + "</h3><ul>");
  	        	prevCon = crsetCon.getString("contributorid");
  	        }
  	    
  	        out.print("<li><a href=\"/pages/event/" +
  	        	crsetCon.getString("eventid") + "\">"+crsetCon.getString("event_name")+"</a>, " + crsetCon.getString("venue") + ", " + formatDate(crsetCon.getString("DDFIRST_DATE"),crsetCon.getString("MMFIRST_DATE"),crsetCon.getString("YYYYFIRST_DATE")));

        out.println("</li>"); 
     	 }while(crsetCon.next());
     	 if(eventconcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
          
   out.flush();
     
     //Events by organisation          
     %>
     <tr id='organisation<%=contributor.getId()%>' class='events-tab'>
     <%
      String prevOrg = "";
      if(crsetOrg.next()){
     	 do{
     		 if(eventorgcount==0){
  		 			out.println("     <td class='contributor-light '></td>");
  	        out.println("     <td class='record-value' colspan='2'>");
  	        
     		 }
     		eventorgcount++;
     		 if (!prevOrg.equals(crsetOrg.getString("name"))) {
  	        	if (eventorgcount > 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<h3><a href=\"/pages/organisation/" + crsetOrg.getString("organisationid") + "\">" + 
  	        		crsetOrg.getString("name")+ "</a></h3><ul>");
  	        	prevOrg = crsetOrg.getString("name");
  	        }
  	    
  	        out.print("<li><a href=\"/pages/event/" +
  	        		crsetOrg.getString("eventid") + "\">"+crsetOrg.getString("event_name")+"</a>");
           if(hasValue(crsetOrg.getString("venue")))
             out.print(", " +  crsetOrg.getString("venue"));
           /*if(hasValue(crsetOrg.getString("venue_name")))
             out.print(", " +  crsetOrg.getString("venue_name"));
           if(hasValue(crsetOrg.getString("suburb"))) 
            out.print(", " + crsetOrg.getString("suburb"));
           if(hasValue(crsetOrg.getString("state")))
            out.print(", " + crsetOrg.getString("state"));*/
           if (hasValue(crsetOrg.getString("DDFIRST_DATE")) || hasValue(crsetOrg.getString("MMFIRST_DATE")) || hasValue(crsetOrg.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(crsetOrg.getString("DDFIRST_DATE"),crsetOrg.getString("MMFIRST_DATE"),crsetOrg.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(crsetOrg.next());
     	 if(eventorgcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
         
   out.flush();
	

//Items
  int Counter=0;
  rset = contributor.getAssociatedItems(Integer.parseInt(contrib_id), stmt);  
  
  if(rset != null)
  {
  out.println("   <tr>");
    while(rset.next())
    {
      if(Counter == 0)
      {
        out.println("     <th class='record-label contributor-light '>Resources</th>");
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
	      <span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=rset.getString("itemid")%><%=contributor.getId()%>'></span>
	
	      <div id='article<%=rset.getString("itemid")%><%=contributor.getId()%>' class="modal fade" role="dialog">
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
    out.println("   </tr>");}
   
  //Related Works
    
    int rowCount=0;
    rset = contributor.getAssociatedWorks(Integer.parseInt(contrib_id), stmt);
   // String description = "";
    if(rset != null)
    {
    out.println("   <tr>");
      while(rset.next())
      {
    	  if(rowCount == 0)
    	  {
    	    out.println("     <th class='record-label contributor-light '>Works</th>");
    	    out.println("     <td class='record-value' colspan='2'>");
    	    out.println("       <ul class='record-value'>");
    	    rowCount++;
    	  }    			   	  
   	out.println("<li><a href=\"/pages/work/" +
                rset.getString("workid") + "\">" +
                rset.getString("work_title") + "</a></li>");
      }
      
    if(rowCount > 0) {
    out.println("</ul>");
    out.println("     </td>");
    }
    out.println("   </tr>");
   }
   
    //Contributor ID
    out.println("   <tr>");
    out.println("     <th class='record-label contributor-light '>Identifier</th>");
    out.println("     <td class='record-value' colspan='2'>" + contributor.getId() +"</td>");
    out.println("   </tr>");    
    out.println(" </table>");
    out.println(" </div>");
    %>
    </div>
    </div><%
  } 
  // close statement
  stmt.close();
%>

<script>
$(document).ready(function(){
console.log("ready");

	displayRow("events<%=contributor.getId()%>", "<%=contributor.getId()%>");

	
	});
</script>



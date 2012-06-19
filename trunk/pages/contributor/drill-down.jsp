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
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>




<%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

CachedRowSet crset          = null;
ResultSet    rset;
Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
String formatted_date       = "";
String event_id             = request.getParameter("f_event_id");
String contrib_id           = request.getParameter("id");
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
   
	out.println("   <table class='record-table'");	
   
    //Name
    out.println("   <tr>");
    out.println("     <th class='record-label b-105 bold'><img src='../../../resources/images/icon-contributor.png' class='box-icon'>Contributor</th>");
    out.println("     <td class='record-value bold'>" + contributor.getPrefix() + " " + contributor.getName() + " " + contributor.getMiddleName() + " " + contributor.getLastName() + " " + contributor.getSuffix());
    
    if (groupNames.contains("Administrators") || groupNames.contains("Contributor Editor")) {
			out.println("[<a class='editLink' target='_blank' href='/custom/contrib_addedit.jsp?act=edit&f_contributor_id=" + contributor.getId() + "'>Edit</a>]");
    }
    
    out.println("   </td>");
    out.println("   <td rowspan=3>");
    if (displayUpdateForm) {
      displayUpdateForm(contrib_id, "Contributor", contributor.getName() + " " + contributor.getLastName(),
                        out,
                        request,                        
                        ausstage_search_appconstants_for_drill);
    }
    out.println("   </td>");
    out.println("   </tr>");
    
    
    // other name  
    if(contributor.getOtherNames() != null && !contributor.getOtherNames().equals("")) {
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Other names</th>");
	    out.println("     <td class='record-value'>");
	    if(contributor.getOtherNames() != null && !contributor.getOtherNames().equals(""))
	      out.println(contributor.getOtherNames());
	    out.println(      "</td>");
	    out.println("   </tr>");
    }
    
    //Gender    
    if(contributor.getGender() != null && !contributor.getGender().equals("")) {
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Gender</th>");
	    out.println("     <td class='record-value'>" + contributor.getGender() + "</td>");
	    out.println("   </tr>");
    }
    
    //Nationality
    if(contributor.getNationality() != null && !contributor.getNationality().equals("")) {
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Nationality</th>");
	    out.println("     <td class='record-value'>" + contributor.getNationality() + "</td>");
	    out.println("   </tr>");
    }
    //Place of Birth
    if(contributor.getPlaceOfBirth() != null && !contributor.getPlaceOfBirth().equals("")) {
            Venue pob = new Venue(db_ausstage_for_drill);
            pob.load(Integer.parseInt("0"+contributor.getPlaceOfBirth()));
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Place Of Birth</th>");
	    out.println("     <td class='record-value'><a href=\"/pages/venue/?id=" + contributor.getPlaceOfBirth() + "\">" + pob.getName() + "</a></td>");
	    out.println("   </tr>");
    }
    //Place of Death
    if(contributor.getPlaceOfDeath() != null && !contributor.getPlaceOfDeath().equals("")) {
            Venue pod = new Venue(db_ausstage_for_drill);
            pod.load(Integer.parseInt("0"+contributor.getPlaceOfDeath()));
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Place Of Death</th>");
	    out.println("     <td class='record-value'><a href=\"/pages/venue/?id=" + contributor.getPlaceOfDeath() + "\">" + pod.getName() + "</a></td>");
	    out.println("   </tr>");
    }
    //Legally can only display date of birth if the date of death is null. 

    // New rules (23/12/2008)
   
    if (!formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear()).equals("") || !formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear()).equals("")) 
    { 
      if(hasValue(contributor.getDobYear()))
      {
	      //Date of Birth  
	      out.println("   <tr>");
	      out.println("     <th class='record-label b-105'>Date of Birth</th>");
	      out.println("     <td class='record-value'>");
	      out.print(formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear()));
	      out.println("     </td>");
	      out.println("   </tr>");
      } 
      
      if(hasValue(contributor.getDodYear()))  
      {        	  
    	//Date of death
	      out.println("   <tr>");
	      out.println("     <th class='record-label b-105'>Date of Death</th>");
	      out.println("     <td class='record-value'>");
	      out.print(formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear()));
	      out.println("     </td>");
	      out.println("   </tr>");
    	}
    }
    
   /*
    if(contributor.getDodYear() == null || contributor.getDodYear().equals("") ){
      //Date of Birth
      out.println("   <tr>");
      out.println("     <th class='record-label b-105'>Date of Birth</th>");
      out.println("     <td class='record-value'>");
      out.print(formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear()));
      out.println("     </td>");
      out.println("   </tr>");
    }
    else{
      //Date of death
      out.println("   <tr>");
      out.println("     <th class='record-label b-105'>Date of Death</th>");
      out.println("     <td class='record-value'>");
      out.print(formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear()));
      out.println("     </td>");
      out.println("   </tr>");
    }
    */
    
    //Functions
    out.println("   <tr>");
    out.println("     <th class='record-label b-105'>Functions</th>");
    out.println("     <td class='record-value'>");
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
    out.println(contrib_functions);
    out.println("     </td>");
    out.println("   </tr>");

    //Notes
    if(contributor.getNotes() != null && !contributor.getNotes().equals("")) {
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>Notes</th>");
	    out.println("     <td class='record-value'>" + contributor.getNotes() + "</td>");
	    out.println("   </tr>");
    }
    //NLA
    if(contributor.getNLA() != null && !contributor.getNLA().equals("")) {
	    out.println("   <tr>");
	    out.println("     <th class='record-label b-105'>NLA</th>");
	    out.println("     <td class='record value' valign='top'>" + contributor.getNLA() + "</td>");
	    out.println("   </tr>");
    }

   out.flush();
   
   %>
   
    <script type="text/javascript">
    function displayRow(name){
    	document.getElementById("function").style.display = 'none';
    	document.getElementById("functionbtn").style.backgroundColor = '#aaaaaa';
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
    
 <tr><th class='record-label b-105'></th></tr>   
    
    <tr>
    <th class='record-label b-105'>Events</th>
<td colspan=2 class="record-value">
<ul class="record-tabs label">
    	<li><a href="#" onclick="displayRow('events')" id='eventsbtn'>Date</a></li>
    	<li><a href="#" onclick="displayRow('function')" id='functionbtn'>Function</a></li>
    	<li><a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributor</a></li>
    	<li><a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisation</a></li>
   </ul>
    </td>
    </tr>
    
<%
   //Associated Events

  out.println("   <tr id='events'>");
  event = new Event(db_ausstage_for_drill);
  crset = event.getEventsByContrib(Integer.parseInt(contrib_id));
  int contribEventCount=0;
  if(crset.next()){
    do{      
      if(contribEventCount==0){
      out.println("     <th class='b-105'></th>");
      out.println("     <td class='record-value'>");
      out.println("     <ul>");
      contribEventCount++;
    }
    out.print("<li><a href=\"/pages/event/index.jsp?id=" +
                crset.getString("eventid") + "\">"+crset.getString("event_name")+"</a>");
    if(hasValue(crset.getString("venue_name")))
      out.print(", " +  crset.getString("venue_name"));
    if(hasValue(crset.getString("suburb"))) 
      out.print(", " + crset.getString("suburb"));
    if(hasValue(crset.getString("state")))
      out.print(", " + crset.getString("state"));
    if (hasValue(crset.getString("DDFIRST_DATE")) || hasValue(crset.getString("MMFIRST_DATE")) || hasValue(crset.getString("YYYYFIRST_DATE")))
      out.print(", " + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE")));
    out.println("</li>");         
  }while(crset.next());
	if(contribEventCount>0)
    out.println("</ul>");
  }
  out.println("   </td></tr>"); 

  //Events by function
  admin.AppConstants constants = new admin.AppConstants();
  ausstage.Database     m_db = new ausstage.Database ();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt1    = m_db.m_conn.createStatement ();
  String sqlString = "";
  CachedRowSet l_rs = null; 
  int eventfunccount = 0;
  int i=0;
  sqlString = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date, "+
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
    	
  l_rs = m_db.runSQL(sqlString, stmt1);
         
  out.flush();
  out.println("<tr id='function'>");
  String prevFunc = "";
  if(l_rs.next()){
    do{
      if(eventfunccount==0){
 	out.println("     <td class='b-105'></td>");
 	out.println("     <td class='record-value'>");
     }
     eventfunccount++;

     if (!prevFunc.equals(l_rs.getString("preferredterm"))) {
        	if (eventfunccount > 1) {
        		out.print("</ul>");
        	}
        	out.print("<h3>"+l_rs.getString("preferredterm")+ "</h3><ul>");
        	prevFunc = l_rs.getString("preferredterm");
        }
 	        out.print("<li><a href=\"/pages/event/index.jsp?id=" +
 	        		l_rs.getString("eventid") + "\">"+l_rs.getString("event_name")+"</a>");
          if(hasValue(l_rs.getString("venue_name")))
            out.print(", " +  l_rs.getString("venue_name"));
          if(hasValue(l_rs.getString("suburb"))) 
           out.print(", " + l_rs.getString("suburb"));
          if(hasValue(l_rs.getString("state")))
           out.print(", " + l_rs.getString("state"));
          if (hasValue(l_rs.getString("DDFIRST_DATE")) || hasValue(l_rs.getString("MMFIRST_DATE")) || hasValue(l_rs.getString("YYYYFIRST_DATE")))
           out.print(", " + formatDate(l_rs.getString("DDFIRST_DATE"),l_rs.getString("MMFIRST_DATE"),l_rs.getString("YYYYFIRST_DATE")));
       out.println("</li>"); 
    	 }while(l_rs.next());
    	 if(eventfunccount>0)
    	 out.println("</ul>");
    	 out.println("</td>");
     }out.println("   </tr>");
     
     
   out.flush();
     
     //Associated Contributor by Events
     
     Statement stmt2    = m_db.m_conn.createStatement ();
     String sqlString2 = "";
     CachedRowSet ec_rs = null; 
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
     ec_rs = m_db.runSQL(sqlString2, stmt2);
     
     out.println("<tr id='contributor'>");
      String prevCon = "";
      if(ec_rs.next()){
     	 do{
     		 if(eventconcount==0){
  		out.println("     <td class='b-105'></td>");
  	        out.println("     <td class='record-value'>");
  	        
     		 }
     		eventconcount++;
     		 if (!prevCon.equals(ec_rs.getString("contributorid"))) {
  	        	if (eventconcount> 1) {
  	        		out.println("</ul>");
  	        	}
  	        	out.println("<h3><a href=\"/pages/contributor/index.jsp?id=" + ec_rs.getString("contributorid") + "\">" + 
  	        	ec_rs.getString("first_name")+" "+ec_rs.getString("last_name")+ "</a> - " + ec_rs.getString("funct") + "</h3><ul>");
  	        	prevCon = ec_rs.getString("contributorid");
  	        }
  	    
  	        out.print("<li><a href=\"/pages/event/index.jsp?id=" +
  	        	ec_rs.getString("eventid") + "\">"+ec_rs.getString("event_name")+"</a>, " + ec_rs.getString("venue") + ", " + formatDate(ec_rs.getString("DDFIRST_DATE"),ec_rs.getString("MMFIRST_DATE"),ec_rs.getString("YYYYFIRST_DATE")));

        out.println("</li>"); 
     	 }while(ec_rs.next());
     	 if(eventconcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
          
   out.flush();
     
     //Events by organisation
     
     stmt2    = m_db.m_conn.createStatement ();
     sqlString2 = "";
     CachedRowSet eo_rs = null; 
     int eventorgcount = 0;
     sqlString2 = 
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
     eo_rs = m_db.runSQL(sqlString2, stmt2);
          
     out.println("<tr id='organisation'>");
      String prevOrg = "";
      if(eo_rs.next()){
     	 do{
     		 if(eventorgcount==0){
  		 			out.println("     <td class='b-105'></td>");
  	        out.println("     <td class='record-value'>");
  	        
     		 }
     		eventorgcount++;
     		 if (!prevOrg.equals(eo_rs.getString("name"))) {
  	        	if (eventorgcount > 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<h3><a href=\"/pages/organisation/?id=" + eo_rs.getString("organisationid") + "\">" + 
  	        		eo_rs.getString("name")+ "</a></h3><ul>");
  	        	prevOrg = eo_rs.getString("name");
  	        }
  	    
  	        out.print("<li><a href=\"/pages/event/index.jsp?id=" +
  	        		eo_rs.getString("eventid") + "\">"+eo_rs.getString("event_name")+"</a>");
           if(hasValue(eo_rs.getString("venue_name")))
             out.print(", " +  eo_rs.getString("venue_name"));
           if(hasValue(eo_rs.getString("suburb"))) 
            out.print(", " + eo_rs.getString("suburb"));
           if(hasValue(eo_rs.getString("state")))
            out.print(", " + eo_rs.getString("state"));
           if (hasValue(eo_rs.getString("DDFIRST_DATE")) || hasValue(eo_rs.getString("MMFIRST_DATE")) || hasValue(eo_rs.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(eo_rs.next());
     	 if(eventorgcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
         
   out.flush();
 
  //Items
  int Counter=0;
  rset = contributor.getAssociatedItems(Integer.parseInt(contrib_id), stmt);  
  out.println("   <tr>");
  if(rset != null)
  {
    while(rset.next())
    {
      if(Counter == 0)
      {
        out.println("     <th class='record-label b-105'>Resources</th>");
        out.println("     <td class='record-value'>");
        out.println("       <ul>");
        Counter++;
      }
      out.println("<li><a href=\"/pages/resource/?id=" +
                    rset.getString("itemid") + "\">" +
                    rset.getString("citation") + "</a></li>");
    }
  }if(Counter > 0){
    out.println("      </ul>");
    out.println("     </td>");
    out.println("   </tr>");}
   
  //Related Works
    out.println("   <tr>");
    int rowCount=0;
    rset = contributor.getAssociatedWorks(Integer.parseInt(contrib_id), stmt);
   // String description = "";
    if(rset.next())
    {
      while(rset.next())
      {
    	  if(rowCount == 0)
    	  {
    	    out.println("     <th class='record-label b-105'>Works</th>");
    	    out.println("     <td class='record-value'>");
    	    out.println("       <ul class='record-value'>");
    	    rowCount++;
    	  }    			   	  
   	out.println("<li><a href=\"/pages/work/?id=" +
                rset.getString("workid") + "\">" +
                rset.getString("work_title") + "</a></li>");
      }
      
    if(rowCount > 0) {
    out.println("</ul>");
    }
    out.println("     </td>");
    out.println("   </tr>");
   }
   
    //Contributor ID
    out.println("   <tr>");
    out.println("     <th class='record-label b-105'>Identifier</th>");
    out.println("     <td class='record-value'>" + contributor.getId() +"</td>");
    out.println("   </tr>");    
    out.println(" </table>");
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
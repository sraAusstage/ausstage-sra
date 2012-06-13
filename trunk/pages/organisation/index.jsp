<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>

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
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
  <tr>
    <td>
      <table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
	<tr>
          <td bgcolor="#FFFFFF">


<%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String org_id               = request.getParameter("id");
  String location             = "";
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


    ///////////////////////////////////
    //    DISPLAY ORGANISATION DETAILS
    //////////////////////////////////
    
    organisation = new Organisation(db_ausstage_for_drill);
    organisation.load(Integer.parseInt(org_id));
    country = new Country(db_ausstage_for_drill);
    
    if (displayUpdateForm) {
      displayUpdateForm(org_id, "Organisation", organisation.getName(),
                        out,
                        request,
                      
                        ausstage_search_appconstants_for_drill);
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Organisation Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/organisation_addedit.jsp?act=edit&f_selected_organisation_id=" + organisation.getId() + "'>Edit</a>");

    out.println("   <table align=\"center\" width='98%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
    
    //Name
   out.println("   <tr class=\"b-185\">");
    out.println("     <td  align='right' width ='25%'   class='general_heading_light f-186' valign='top'>Organisation Name</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td width ='75%' ><b>" + organisation.getName() + "</b></td>");
    out.println("   </tr>");
    
    //Other Names
    if (organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals("") || organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals("") || organisation.getOtherNames3() != null && !organisation.getOtherNames3().equals("")) {
    out.println("   <tr>");
    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Other names</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >");
    // other name 1
    if(organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals(""))
      out.println(organisation.getOtherNames1());
    // other name 2
    if(organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals("")){
      if(organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals(""))
        out.println("<br>");
      out.println(organisation.getOtherNames2());
    }
    // other name 3
    if(organisation.getOtherNames3() != null && !organisation.getOtherNames3().equals("")){
      if(organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals(""))
        out.println("<br>");
      out.println(organisation.getOtherNames3());
    }
    out.println(      "</td>");
    out.println("   </tr>");
    }
    
    //Address
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Address</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >" + organisation.getAddress());
    
    if (hasValue(organisation.getAddress()) && (hasValue(organisation.getSuburb()) || hasValue(organisation.getStateName()) || hasValue(organisation.getPostcode())))
      out.print("<br>");
    if (hasValue(organisation.getSuburb())) 
      out.print(organisation.getSuburb() + " ");
    if (hasValue(organisation.getStateName())) 
      out.print(organisation.getStateName() + " ");
    if (hasValue(organisation.getPostcode()))
      out.print(organisation.getPostcode());
   
    if(hasValue(organisation.getCountry())){
      country.load(Integer.parseInt(organisation.getCountry()));
      out.println("   <br>" +  country.getName() + "");
    }
    out.println(      "</td>");
    out.println("   </tr>");
    
    //Website
    if (organisation.getWebLinks() != null && !organisation.getWebLinks().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Website</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td ><a href=\"");
	    if(organisation.getWebLinks().indexOf("http://") < 0)
	      out.println("http://");
	    out.println(organisation.getWebLinks() + "\">" + organisation.getWebLinks() + "</a>" );
	    %>
	    <br>
	    <script type="text/javascript" src="http://www.shrinktheweb.com/scripts/pagepix.js"></script>
	    <script type="text/javascript">
            stw_pagepix('<%
	    if(organisation.getWebLinks().indexOf("http://") < 0)
	      out.print("http://");
	    %><%=organisation.getWebLinks()%>', 'afcb2483151d1a2', 'sm', 0);
	    var anchorElements = document.getElementsByTagName('a');
            for (var i in anchorElements) {
              if (anchorElements[i].href.indexOf("shrinktheweb") != -1 || anchorElements[i].href == document.getElementById('url').href){
                anchorElements[i].onmousedown = function() {}
                anchorElements[i].href = document.getElementById('url').href;
              }
            }
            </script>
	    
	<%
	out.println("   </td>"); 
	    out.println("   </tr>");    
    }
   
    //Functions
    if (organisation.getFunction(Integer.parseInt(org_id)) != null && !organisation.getFunction(Integer.parseInt(org_id)).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Functions</b></td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >" + organisation.getFunction(Integer.parseInt(org_id)) + "</td>");
	    out.println("   </tr>");
    }
    
    //NLA
    if(organisation.getNLA() != null && !organisation.getNLA().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>NLA</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign='top'>" + organisation.getNLA() + "</td>");
	    out.println("   </tr>");
    }
   
    //Notes
    if (organisation.getNotes() != null && !organisation.getNotes().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Notes</b></td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >" + organisation.getNotes() + "</td>");
	    out.println("   </tr>");
    }
  %>  
    <script type="text/javascript">
    function displayRow(name){
    	document.getElementById("venue").style.display = 'none';
    	document.getElementById("venuebtn").style.backgroundColor = '#c0c0c0';
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
    <tr>
    <td align='right' class='general_heading_light' valign='top'></td>
    <td>&nbsp;</td>
    <td id="tabs" colspan=3>
    	<a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a>
    	<a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a>   
    	<a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a> 	
    	<a href="#" onclick="displayRow('venue')" id='venuebtn'>Venues</a>
    </td>
    </tr>
    
    
<%
    
    admin.AppConstants constants = new admin.AppConstants();
    ausstage.Database     m_db = new ausstage.Database ();
    m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
    
    //Events
    out.println("   <tr id='events'>");
    event = new Event(db_ausstage_for_drill);
    crset = event.getEventsByOrg(Integer.parseInt(org_id));
    int orgEventCount = 0;
    
   if(crset.next())
   {
     do
     {
       if(orgEventCount==0){
       out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
       out.println("     <td>&nbsp;</td>");
       out.println("     <td  valign=\"top\">");
       out.println("     <ul>");
       orgEventCount++;
     }
        out.print("<li><a href=\"/pages/event/?id=" +
                    crset.getString("eventid") + "\">" +
                    crset.getString("event_name") + "</a>");
        if(hasValue(crset.getString("venue_name")))
          out.print(", " + crset.getString("venue_name"));
        
        if(hasValue(crset.getString("suburb")))
          out.print(", " + crset.getString("suburb")); 
        
        if(hasValue(crset.getString("state")))
          out.print(", " + crset.getString("state")); 

        if (hasValue(crset.getString("DDFIRST_DATE")) || hasValue(crset.getString("MMFIRST_DATE")) || hasValue(crset.getString("YYYYFIRST_DATE")))
          out.print(", " + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE")));

        out.println("</li>");
      }while(crset.next());
      if(orgEventCount > 0)
      out.println("</ul>");
    }//else{
      //out.println("No other events to display.");
   // }
    out.println("     </td>");
    out.println("   </tr>");

    
     
     //Events by organisation type
     
     Statement stmt2    = m_db.m_conn.createStatement ();
     CachedRowSet eo_rs = null; 
     int eventorgcount = 0;
     String sqlString2 = 
    "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
  	"events.first_date,venue.venue_name,venue.suburb,states.state,organisation.organisationid,organisation.name,evcount.num "+
  	"FROM events,venue,states,organisation,orgevlink oe2,orgevlink "+
  	"inner join (SELECT oe.organisationid, count(distinct oe.eventid) num "+
  	"FROM orgevlink oe, orgevlink oe2 where oe2.eventid=oe.eventid and oe2.organisationid=" + org_id + " "+
  	"group by oe.organisationid) evcount ON (evcount.organisationid = orgevlink.organisationid) "+
  	"WHERE oe2.organisationid = " + org_id + " AND "+
  	"orgevlink.organisationid != " + org_id + " AND "+
  	"oe2.eventid = events.eventid AND "+
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
  		 			out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
  	        out.println("     <td>&nbsp;</td>");
  	        out.println("     <td  valign=\"top\">");
  	        
     		 }
     		 eventorgcount++;
     		 if (!prevOrg.equals(eo_rs.getString("name"))) {
  	        	if (eventorgcount > 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<a href=\"/pages/organisation/?id=" + eo_rs.getString("organisationid") + "\">" + eo_rs.getString("name")+ "</a><br><ul>");
  	        	prevOrg = eo_rs.getString("name");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
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
       
     //Events by organisation type
     
     stmt2    = m_db.m_conn.createStatement ();
     CachedRowSet ov_rs = null; 
     int orgvencount = 0;
      sqlString2 = 
	"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
	"events.first_date,venue.venueid,venue.venue_name,venue.suburb,states.state,organisation.organisationid,organisation.name,evcount.num "+
	"FROM events,venue,states,organisation,orgevlink "+
	"inner join (SELECT events.venueid, count(distinct orgevlink.eventid) num "+
	"FROM orgevlink, events where orgevlink.eventid=events.eventid and orgevlink.organisationid=" + org_id + " "+
	"GROUP BY events.venueid) evcount "+
	"WHERE orgevlink.organisationid = " + org_id + " AND "+
	"evcount.venueid = events.venueid AND "+
	"orgevlink.eventid = events.eventid AND "+
	"events.venueid = venue.venueid AND "+
	"venue.state = states.stateid AND "+
	"events.eventid = orgevlink.eventid AND "+
	"orgevlink.organisationid = organisation.organisationid "+
	"ORDER BY evcount.num desc,venue.venue_name,events.first_date DESC";
     ov_rs = m_db.runSQL(sqlString2, stmt2);
     
     out.println("<tr id='venue'>");
      String prevVen = "";
      if(ov_rs.next()){
     	 do{
     		if(orgvencount==0){
  		 			out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
  	        out.println("     <td>&nbsp;</td>");
  	        out.println("     <td  valign=\"top\">");
  	        
     		 }
     		 orgvencount++;
     		 if (!prevVen.equals(ov_rs.getString("venueid"))) {
  	        	if (orgvencount> 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<a href=\"/pages/venue/?id=" + ov_rs.getString("venueid") + "\">" + ov_rs.getString("venue_name")+ "</a>");
  	        	if(hasValue(ov_rs.getString("suburb"))) 
				out.print(", " + ov_rs.getString("suburb"));
           		if(hasValue(ov_rs.getString("state")))
				out.print(", " + ov_rs.getString("state"));
  	        	out.print("<br><ul>");
  	        	prevVen= ov_rs.getString("venueid");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
  	        		ov_rs.getString("eventid") + "\">"+ov_rs.getString("event_name")+"</a>");

           if (hasValue(ov_rs.getString("DDFIRST_DATE")) || hasValue(ov_rs.getString("MMFIRST_DATE")) || hasValue(ov_rs.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(ov_rs.getString("DDFIRST_DATE"),ov_rs.getString("MMFIRST_DATE"),ov_rs.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(ov_rs.next());
     	if(orgvencount> 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
      
      //Contributors by organisation
	Statement stmt3 	= m_db.m_conn.createStatement();
	String sqlString3	= "";
	CachedRowSet co_org	= null;
	int contributororgcount = 0;
	sqlString3		= "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
				"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
				"venue.venue_name,venue.suburb,states.state,evcount.num " +
				"FROM events,venue,states,orgevlink,conevlink,contributor " +
				"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
				"FROM conevlink, orgevlink where orgevlink.eventid=conevlink.eventid and orgevlink.organisationid=" + org_id + " " +
				"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
				"WHERE orgevlink.organisationid = " + org_id + " AND " +
				"orgevlink.eventid = events.eventid AND " +
				"events.venueid = venue.venueid AND " +
				"venue.state = states.stateid AND " +
				"events.eventid = orgevlink.eventid AND " +
				"orgevlink.eventid=conevlink.eventid AND " +
				"conevlink.contributorid = contributor.contributorid " +
				"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
	co_org			= m_db.runSQL(sqlString3, stmt3);
	
     out.println("<tr id='contributor'>");
      String prevCon = "";
      if(co_org.next()){
     	 do{
     		if(contributororgcount==0){
  		 out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
  	         out.println("     <td>&nbsp;</td>");
  	         out.println("     <td  valign=\"top\">");
  	        
     		}
     		 contributororgcount++;
     		 if (!prevCon.equals(co_org.getString("contributorid"))) {
  	        	if (contributororgcount> 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<a href=\"/pages/contributor/?id=" + co_org.getString("contributorid") + "\">" + co_org.getString("contributor_name")+ "</a><br><ul>");
  	        	prevCon= co_org.getString("contributorid");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
  	        		co_org.getString("eventid") + "\">"+co_org.getString("event_name")+"</a>");
  	        	if(hasValue(co_org.getString("suburb"))) 
				out.print(", " + co_org.getString("suburb"));
           		if(hasValue(co_org.getString("state")))
				out.print(", " + co_org.getString("state"));

           if (hasValue(co_org.getString("DDFIRST_DATE")) || hasValue(co_org.getString("MMFIRST_DATE")) || hasValue(co_org.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(co_org.getString("DDFIRST_DATE"),co_org.getString("MMFIRST_DATE"),co_org.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(co_org.next());
     	if(contributororgcount> 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
  	    
  	    
     
     //Works
    rset = organisation.getAssociatedWorks(Integer.parseInt(org_id), stmt);
    int rowWorksCount=0;
    out.println("   <tr class=\"b-185\">");
    
    if(rset != null)
    {
      while(rset.next())
      {
    	  if (rowWorksCount == 0) 
    	  {
	    	  out.println("     <td align='right' class='general_heading_light' valign='top'><a class='f-186' href=\"#\" onclick=\"showHide('works')\">Works</a></td>");
	    	  out.println("     <td>&nbsp;</td>");
	    	  out.println("     <td >");
	    	  out.println("<table id='works' width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    	  rowWorksCount++;
	  }
    	  
          out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/work/?id=" +
                         rset.getString("workid") + "\">" +
                         rset.getString("work_title") + "</a></td>");
          out.println("</tr>");  
      }
    }
    if(rowWorksCount > 0){
    out.println("      </table>");
    out.println("     </td>");
    out.println("   </tr>");
    }
    
   //Resources
    rset = organisation.getAssociatedItems(Integer.parseInt(org_id), stmt);
    int orgResourcesCountfalse=0;
    out.println("   <tr>");
    
    if(rset != null)
    {
      while(rset.next())
      {
    	  if(orgResourcesCountfalse==0)
    	  {
    	    out.println("     <td align='right' class='general_heading_light' valign='top'><a class='f-186' href=\"#\" onclick=\"showHide('resources')\">Resources</a></td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td >");
    	    out.println("       <table id='resources' width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
      	  orgResourcesCountfalse++;
    	  }
    	    //  Items
    	    // Display Items via the itemorglink table and via item.institutionid.
        out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/resource/?id=" +
                         rset.getString("itemid") + "\">" +
                         rset.getString("citation") + "</a> ");
        //out.println("&nbsp " + rset.getString("name") + ", " + rset.getString("state") + "</td>");
        out.print("</td>");
        out.println("</tr>");
      }
    }
    if(orgResourcesCountfalse > 0){
        out.println("      </table>");
        out.println("     </td>");
        out.println("   </tr>");
    }
    
   //Identifier   
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right' class='general_heading_light f-186' valign='top'>Organisation Identifier</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >" + organisation.getId() + "</td>");
    out.println("   </tr>");
    
     out.println("   <tr>");
    out.println("     <td>&nbsp; </td>");
    out.println("   </tr>");
    out.println(" </table>");

  
  // close statement
  stmt.close();
%>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>
  <!-- AddThis Button BEGIN -->
    <div align="right" class="addthis_toolbox addthis_default_style ">
      <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
      <a class="addthis_button_tweet"></a>
      <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
      <a class="addthis_counter addthis_pill_style"></a>
    </div>
<script>displayRow("events");
if (!document.getElementById("venue").innerHTML.match("[A-Za-z]")) document.getElementById("venuebtn").style.display = "none";
if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";

</script>

</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
<cms:include property="template" element="foot" />
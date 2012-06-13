<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar, java.util.Date, java.text.SimpleDateFormat"%>
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
<%@ include file="../../public/common.jsp"%>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

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
	
	List<String> groupNames = new ArrayList();	
	if (session.getAttribute("userName")!= null) {
		CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
		CmsObject cmsObject = cms.getCmsObject();
		List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
		for(CmsGroup group:userGroups) {
		   	groupNames.add(group.getName());
			}
	}
	

  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String event_id             = request.getParameter("id");
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
    //    DISPLAY EVENT DETAILS
    //////////////////////////////////
    
    event = new Event(db_ausstage_for_drill);
    event.load(Integer.parseInt(event_id));
    descriptionSource = new DescriptionSource(db_ausstage_for_drill);
    
    if (displayUpdateForm) {
      displayUpdateForm(event_id, "Event", event.getEventName(),
                        out,
                        request,
                      
                        ausstage_search_appconstants_for_drill);
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Event Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/event_addedit.jsp?mode=edit&f_eventid=" + event.getEventid() + "'>Edit</a>");

//Event Name
    out.println("   <table align=\"center\" width=\"98%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
    out.println("   <tr class=\"b-185\">");
    out.println("     <td width='25%' class='general_heading_light f-186' valign='top' align='right'>Event Name</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td width='75%'   valign=\"top\"><b>" + event.getEventName() + "</b></td>");
    out.println("   </tr>");
    
    
     //Venue
     
    // Get venue location string
    String venueLocation = ""; 
    if (event.getVenue().getSuburb() != null && !event.getVenue().getSuburb().equals (""))
      venueLocation = ", " + event.getVenue().getSuburb();
    if (event.getVenue().getState() != null && !event.getVenue().getState().equals (""))
     venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));
     
    out.println("   <tr>");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Venue</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">");
    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    out.println("         <tr>");
    out.println("           <td  valign=\"top\"><a href=\"/pages/venue/?id=" + event.getVenueid() + "\">" + event.getVenue().getName() + "</a>" + venueLocation + "</td>");
    out.println("         </tr>");
    out.println("       </table>");
    out.println("   </tr>");
  
    //Unbrella Event
    if (event.getUmbrella() != null && !event.getUmbrella().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Umbrella Event</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + event.getUmbrella() + "</td>");
	    out.println("   </tr>");
    }
    	
   	//First Date
   	if (!formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate()).equals("")) {
   		out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>First date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >");

	    out.println(formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate()));
	    out.println("     </td>");
	    out.println("   </tr>");
   	}
   	
    //Opening Date
    if (!formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate()).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Opening date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate()));
	    
	    out.println("     </td>");
	    out.println("   </tr>");
    }
    
    //Last Date
    if (!formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate()).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Last date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate()));
	    out.println(formatted_date);
	    out.println("     </td>");
	    out.println("   </tr>");
    }
    //Dates Estimated
    out.println("   <tr class=\"b-185\">");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Dates Estimated</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">" + Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()),true) + "</td>");
    out.println("   </tr>");

    //Status
		if (event.getStatus() != null && !event.getStatus().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Status</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    if(event.getStatus() != null)
	      out.println(event.getEventStatus(event.getStatus()));
	    out.println("     </td>");
	    out.println("   </tr>");
		}
    //World Premier
  
    out.println("   <tr>");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>World Premiere</td>");
    out.println("     <td>&nbsp;</td>");
    if(event.getWorldPremier())
      out.println("     <td  valign=\"top\">Yes</td>");
    else
      out.println("     <td  valign=\"top\">No</td>");
    out.println("   </tr>");
    

    
     //Part of a tour -- remove me when event-event joins are done
 /*   if (event.getPartOfATour()) {
	    out.println("   <tr>");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Part Of A Tour</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">Yes</td>");
	    out.println("   </tr>");
    }*/
    
    
    //Description
    if (event.getDescription() != null && !event.getDescription().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Description</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + event.getDescription() + "</td>");
	    out.println("   </tr>");
    }
    
    //Description Source
    if (event.getDescriptionSource() != null && !event.getDescriptionSource().equals("") && !event.getDescriptionSource().equals("0")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Description Source</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource())));
	    out.println("     </td>");
	    out.println("   </tr>");    
  	}
    
    // PRIMARY GENRE //
    out.println("   <tr>");
    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Primary Genre</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">");
    primarygenre = new PrimaryGenre(db_ausstage_for_drill);
    primarygenre.load(Integer.parseInt(event.getPrimaryGenre()));
    out.println(primarygenre.getName());
    out.println("     </td>");
    out.println("   </tr>");

    //  SECONDARY GENRE //
    int eventGenreCounter=0;
    out.println("   <tr>");
    for (int i=0; i < event.getSecGenreEvLinks().size(); i++)
    {
    	if(eventGenreCounter==0)
    	{
    		out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Secondary Genre</td>");
   	    out.println("     <td>&nbsp;</td>");
   	    out.println("     <td  valign=\"top\">");
   	 		eventGenreCounter++;
    	}
      secGenreEvLink = (SecGenreEvLink) event.getSecGenreEvLinks().get(i);
      SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
      tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
      out.println("<a href=\"/pages/genre/?id=" + secGenreEvLink.getSecGenrePreferredId() + "\">" + tempSecGenre.getName() + "<br>");
    }
    if(eventGenreCounter >0){
    out.println("      </td>");
    out.println("   </tr>");
    }

    //  PRIMARY CONTENT INDICATOR //  
    //Subjects
    out.println("   <tr>");
    int eventCICount=0;
    for (int i=0; i < event.getPrimContentIndicatorEvLinks().size(); i++)
    {
    	 if(eventCICount==0)
    	 {	
    		 out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Subjects</td>");
    		 out.println("     <td>&nbsp;</td>");
    		 out.println("     <td  valign=\"top\">");
    		 eventCICount++;
    	 }
      primContentIndicatorEvLink = (PrimContentIndicatorEvLink) event.getPrimContentIndicatorEvLinks().get(i);
      out.println("<a href=\"/pages/subject/?id=" + primContentIndicatorEvLink.getPrimaryContentInd().getId() + "\">" + primContentIndicatorEvLink.getPrimaryContentInd().getName() + "</a><br>");
    }    
    if(eventCICount >0){
    out.println("     </td>");
    out.println("   </tr>");    }
    
   //  ORGANISATIONS  or Companies//
    out.println("   <tr class=\"b-185\">");
   int eventACCounter=0;
    
    for (int i=0; i < event.getOrgEvLinks().size(); i++){
    	if(eventACCounter==0){
    		out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Organisations</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td  valign=\"top\">");
    	    out.println("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    	    eventACCounter++;
    	}
      orgEvLink   = (OrgEvLink) event.getOrgEvLinks().get(i);
      organisation = orgEvLink.getOrganisationBean();
      out.print("<tr><td  valign=\"top\"><a href=\"/pages/organisation/?id=" +
                  organisation.getId() + "&f_event_id=" + event_id + "\">" +
                  organisation.getName() + "</a>");
      if (orgEvLink.getFunctionDesc() != null && !orgEvLink.getFunctionDesc().equals("")){
        out.print(", " + orgEvLink.getFunctionDesc());
      } else {
        out.print(", No Function");
      }
      if (orgEvLink.getArtisticFunctionDesc() != null && !orgEvLink.getArtisticFunctionDesc().equals("")){
        out.print(", " + orgEvLink.getArtisticFunctionDesc());
      } else {
        //out.print(", No Artistic Function"); /tir 99 - do not show this any more.
      }
      out.println("</td></tr>");
    }if(eventACCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
   //  CONTRIBUTORS //    
    out.println("   <tr>");
    int eventCCounter=0;
    
    
    if (event.getConEvLinks().size()>=1) {
    	if(eventCCounter==0){
    		out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Contributor Name</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td>");
    	    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		eventCCounter++;
    	}
      out.println("       <tr><td width='25%' class='general_heading_light' valign=\"top\">Name</td><td>&nbsp;</td>" +
                             "<td width='25%' class='general_heading_light' valign=\"top\">Function</td><td>&nbsp;</td>" +
                             "<td width='50%' class='general_heading_light' valign=\"top\">Notes</td></tr>");
    }
    for (int i=0; i < event.getConEvLinks().size(); i++){
      conEvLink = (ConEvLink) event.getConEvLinks().get(i);
      contributor = conEvLink.getContributorBean();
      String contrib_str = "<tr><td  valign=\"top\"><a href=\"/pages/contributor/?id=" +
                    contributor.getId() + "&f_event_id=" + event_id + "\">" +
                    contributor.getName() + " " + contributor.getLastName() +
                    "</a></td><td></td>" +
                    "<td  valign=\"top\">";
      if(conEvLink.getContributorId() != null
       && conEvLink.getContributorId().equals(Integer.toString(contributor.getId()))) {
        contrib_str += conEvLink.getFunctionDesc();
      }
      contrib_str += "</td><td></td><td  valign=\"top\">";
     
     if(conEvLink.getNotes() != null && conEvLink.getNotes()!= "")
       contrib_str += conEvLink.getNotes();
     
      out.println(contrib_str + "</td></tr>");
    }if(eventCCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
       //Resources
    int eventResourceCount=0;
    out.println("   <tr class=\"b-185\">");  
    rset = event.getAssociatedItems(Integer.parseInt(event_id), stmt);
    if(rset != null){
      while(rset.next()){
    	  if(eventResourceCount==0){
    		    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Resources</td>");
    		    out.println("     <td>&nbsp;</td>");
    		    out.println("     <td  valign=\"top\">");
    		    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    eventResourceCount++;
    		    }
            out.println("<tr><td colspan='3' width=\"100%\"  valign=\"top\"><a href=\"/pages/resource/?id=" +
                         rset.getString("itemid") + "\">" +
                         rset.getString("citation") + "</a></td>"); //NUMBER 1
        out.println("</tr>");
      
      }
    }
    rset.close();
    if(eventResourceCount>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");
    }

//Works
	  int eventWorkCount=0;
    out.println("<tr>");
    rset = event.getAssociatedWorks(Integer.parseInt(event_id), stmt);
    if(rset != null){
    	while(rset.next()){
    		if(eventWorkCount==0){
  		      out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Works</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    eventWorkCount++;
    	  }
        out.println("<tr><td colspan='3' width=\"100%\"  valign=\"top\"><a href=\"/pages/work/?id=" +
        								rset.getString("workid") + "\">" +
        								rset.getString("work_title") + "</a></td>");
            out.println("</tr>");             
      }
      rset.close();
    } 
		if(eventWorkCount>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
   //Text Nationality
    
    out.println("   <tr>");
    for (int i=0; i < event.getPlayOrigins().size(); i++){
      country = (Country) event.getPlayOrigins().get(i);
      if (country.getName() != null && !country.getName().equals("")) {     
      out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Text Nationality</td>");
      out.println("     <td>&nbsp;</td>");
      out.println("     <td  valign=\"top\">")  ;
      out.println(country.getName() + "<br>");
      out.println("    </td>");     
    }
   
    out.println("   </tr>");}
    
    // Production Nationality
    out.println("   <tr>");   
    for (int i=0; i < event.getProductionOrigins().size(); i++){
      country = (Country) event.getProductionOrigins().get(i);
      if (country.getName() != null && !country.getName().equals("")) {
    	  out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Production Nationality</td>");
    	  out.println("     <td>&nbsp;</td>");
    	  out.println("     <td  valign=\"top\">");      
      out.println(country.getName() + "<br>");
      out.println("     </td>");
    }    
    out.println("   </tr>");}

    //Further Information
    if (event.getFurtherInformation() != null && !event.getFurtherInformation().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Further Information</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(event.getFurtherInformation());
	    out.println("     </td>");
	    out.println("   </tr>");
    }
   
//  Data source vertical //    
    out.println("   <tr>");
   int sourceCounter=0;
    
    if (event.getDataSources().size()>=1) {
    	if(sourceCounter==0){
    	 out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Data Source</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td>");
    	    out.println("     <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    	    sourceCounter++;
    	}
      out.println("       <tr><td width='30%' class='general_heading_light' valign=\"top\"> Source</td><td>&nbsp;</td>" +
                             "<td width='30%' class='general_heading_light' valign=\"top\">Data Source Description</td><td>&nbsp;</td>" +
                             "<td width='40%' class='general_heading_light' valign=\"top\">Part of Collection</td></tr>");
    }
    for(int j =0; j < event.getDataSources().size(); j++){
    	 datasource = (Datasource) event.getDataSources().elementAt(j);  
    	 datasourceEvlink = new Datasource(db_ausstage_for_drill);
       datasourceEvlink.setEventId(event_id);
       datasourceEvlink.loadLinkedProperties(Integer.parseInt("0"+datasource.getDatasoureEvlinkId()));
       out.println("       <tr><td width='30%' class='general_heading_light' valign=\"top\">"+datasource.getName()+"</td><td>&nbsp;</td>" +
               "<td width='30%' class='general_heading_light' valign=\"top\">"+datasourceEvlink.getDescription()+"</td><td>&nbsp;</td>" +
               "<td width='40%' class='general_heading_light' valign=\"top\">"+datasourceEvlink.isCollection()+ "</td></tr>");
    }if(sourceCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
    

    SimpleDateFormat dateFormat = new SimpleDateFormat("d MMMM yyyy");
    String dateString = null;
    try {
    	dateString = dateFormat.format(event.getUpdatedDate());
    } catch (Exception e) {
    	dateString = dateFormat.format(event.getEnteredDate());
    }
    System.out.println("DateString: "+dateString);
    
    
    //Reviewed
    if(event.getReview() == true)
    {
      out.println("   <tr class=\"b-185\">");
   	  out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Data Reviewed By</td>");
    	out.println("     <td>&nbsp;</td>");
    	if(event.getUpdatedByUser().equals("null") && event.getReview() == true){
    		out.println("<td valign=\"top\">" + event.getEnteredByUser() + " on " + dateFormat.format(event.getEnteredDate())+"</td>");
    	}
    	out.println("<td valign=\"top\">" + event.getUpdatedByUser() + " on " + dateFormat.format(event.getUpdatedDate()) +"</td>");
    }
    
    //Event Identifier
    if (event.getEventid() != null && !event.getEventid().equals("")) {
    	out.println("   <tr class=\"b-185\">");
    	out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Event Identifier</td>");
    	out.println("     <td>&nbsp;</td>");
    	out.println("     <td valign=\"top\">" + event.getEventid() + "</td>");
    	out.println("   </tr>");
    }

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
</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
<cms:include property="template" element="foot" />
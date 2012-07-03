<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, admin.Common, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.Status, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.PrimaryGenre"%>
<%@ page import = "ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "ausstage.Country"%>
<%@ page import = "ausstage.LookupCode"%>
<%@ page import = "ausstage.Work"%>
<%@ page import = "ausstage.PrimContentIndicatorEvLink, ausstage.SecContentIndicatorEvLink"%>
<%@ page import = "ausstage.Venue, ausstage.ConEvLink,ausstage.EventEventLink, ausstage.Contributor, ausstage.WorkWorkLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Item"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin     login                = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater         = (admin.FormatPage)    session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage          = new ausstage.Database ();
  Event              eventObj                  = new Event(db_ausstage);
  Status             statusObj                 = new Status(db_ausstage);
  DescriptionSource  descriptionSourceObj      = new DescriptionSource(db_ausstage);
  PrimaryGenre       primaryGenreObj           = new PrimaryGenre(db_ausstage);
  String             mode                      = "";
  State              state                     = new State(db_ausstage);
  Country            country                   = new Country(db_ausstage);
  AusstageCommon          ausstageCommon       = new AusstageCommon();

  String       eventid = "";
  int          eventidInt = 0;
  CachedRowSet rset;
  Common common = new Common();
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();


  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource    datasource    = new ausstage.Datasource (db_ausstage);
  
  Vector data_source_vec            = new Vector();
  Vector second_genres_link_vec     = new Vector();
  Vector second_genres_vec          = new Vector();
  Vector primary_content_link_vec   = new Vector();
  Vector primary_content_ind_vec    = new Vector();
  Vector secondary_content_link_vec = new Vector();
  Vector secondary_content_pref_vec = new Vector();
  Vector work_vec                   = new Vector();
  Vector work_name_vec              = new Vector();
  Vector work_link_vec              = new Vector();
  Vector articles_link_vec          = new Vector();
  Vector contributor_link_vec       = new Vector();
  Vector contributor_name_vec       = new Vector();
  Vector event_name_vec				= new Vector();
  Vector<EventEventLink> event_link_vec	= new Vector<EventEventLink>();
  Vector organisation_link_vec      = new Vector();
  Vector organisation_name_vec      = new Vector();
  Vector national_play_vec          = new Vector();
  Vector national_production_vec    = new Vector();
  Vector resource_link_vec          = new Vector();
  Vector resource_name_vec          = new Vector();
  
  /** 
  Hashtable
  hidden_fields : for FORM hidden field type

  use           : hidden_fields.put("name1","the value of name1");
                  hidden_fields.put("name2","the value of name2");
                
  output        : <input type='hidden' name='name1' value='the value of name1'>,
                  <input type='hidden' name='name2' value='the value of name2'>
  */
  Hashtable hidden_fields = new Hashtable();

  //pageFormater.writeHeader(out);
  //pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  // Are we editting, adding, or coming back from editting child records?
  mode = request.getParameter ("mode");
  if (mode == null) { // Have come back from editing child records
    mode     = (String)session.getAttribute("eventMode");
    eventObj = (Event)session.getAttribute("eventObj");
    eventid  = eventObj.getEventid ();
    eventObj.setEventName(common.ReplaceStrWithStr(eventObj.getEventName(),"\"","&quot;"));
  }
  else {
    // first time to this page
    eventid = request.getParameter ("f_eventid");
    // if editing
    if (eventid == null) {
      eventid = "0";
      mode = "add"; // Mode is really "add" if no event id was selected.
      eventObj = new Event(db_ausstage);
    }
    else {
      eventidInt = Integer.parseInt(eventid);
      mode = "edit";
      eventObj.load(eventidInt);
    }
  }

  // get the initial state of the object(s) associated with this event
  data_source_vec = eventObj.getDataSources ();

  second_genres_link_vec = eventObj.getSecGenreEvLinks();
  SecGenreEvLink secGenreEvLink = null;
  for (int i=0; i < second_genres_link_vec.size(); i++) {
    secGenreEvLink = (SecGenreEvLink)second_genres_link_vec.get(i);
    second_genres_vec.add(secGenreEvLink.getSecondaryGenre());
   // System.out.println("Genre:"+ second_genres_vec.add(secGenreEvLink.getSecondaryGenre()));
  }
    
  primary_content_link_vec = eventObj.getPrimContentIndicatorEvLinks();
  PrimContentIndicatorEvLink primContentIndicatorEvLink = null;
  for (int i=0; i < primary_content_link_vec.size(); i++) {
    primContentIndicatorEvLink = (PrimContentIndicatorEvLink)primary_content_link_vec.get(i);
    primary_content_ind_vec.add(primContentIndicatorEvLink.getPrimaryContentInd());
  }

  secondary_content_link_vec = eventObj.getSecContentIndicatorEvLinks();
  SecContentIndicatorEvLink secContentIndicatorEvLink = null;
  for (int i=0; i < secondary_content_link_vec.size(); i++) {
    secContentIndicatorEvLink = (SecContentIndicatorEvLink)secondary_content_link_vec.get(i);
    secondary_content_pref_vec.add(secContentIndicatorEvLink.getSecContentIndPref());
  }
  
   

  work_link_vec = eventObj.getWorks();
  for (int i=0; i < work_link_vec.size(); i++) {
    Work work = new Work(db_ausstage);
    work.load(Integer.parseInt(work_link_vec .get(i)+""));
    work_name_vec.add(work.getWorkTitle());
     // To display Contributor Last Name First Name, Notes on Contributor Link and The Contributor Preferred Description
   // work_name_vec.add(work.getWorkTitle());
  }

  LookupCode lc = new LookupCode(db_ausstage);
  event_link_vec	        = eventObj.getEventEventLinks();
  Event event 			= null;
  for(int i=0; i < event_link_vec.size(); i++ ){
	  event = new Event(db_ausstage);
	  event.load(Integer.parseInt(event_link_vec.get(i).getChildId()));
	  if (event_link_vec.get(i).getFunctionId() != null) {
		  lc.load(Integer.parseInt(event_link_vec.get(i).getFunctionId()));
		  event_name_vec.add(event.getEventName() + " (" + lc.getDescription() + ")");
	  } else {
		  event_name_vec.add(event.getEventName());
	  }
  }
  
  for (int i=0; i < resource_link_vec.size(); i++) {
    Item tempItem = new Item(db_ausstage);
    tempItem.load(Integer.parseInt(resource_link_vec.get(i)+""));
    resource_name_vec.add(tempItem.getCitation());
  }
  
  contributor_link_vec    = eventObj.getConEvLinks();
  ConEvLink conEvLink     = null;
  Contributor contributor = null;

  for (int i=0; i < contributor_link_vec.size(); i++) {
    conEvLink = (ConEvLink)contributor_link_vec.get(i);
    contributor = conEvLink.getContributorBean();
    // To display Contributor Last Name First Name, Notes on Contributor Link and The Contributor Preferred Description
    String tempString = contributor.getLastName() + " " + contributor.getName();
    if (conEvLink.getNotes() != null && !conEvLink.getNotes().equals("")) {
      tempString += ", " + conEvLink.getNotes();
    }
    if (conEvLink.getFunctionDesc() != null && !conEvLink.getFunctionDesc().equals("")) {
      tempString += ", " + conEvLink.getFunctionDesc();
    }
    contributor_name_vec.add(tempString);
  }

  organisation_link_vec     = eventObj.getOrgEvLinks();
  ausstage.OrgEvLink orgEvLink       = null;
  Organisation organisation = null;

  // organisation for the event must have either: Function or an Artistic Function
  for (int i=0; i < organisation_link_vec.size(); i++)
  {
    orgEvLink   = (ausstage.OrgEvLink)organisation_link_vec.get(i);
    organisation = orgEvLink.getOrganisationBean();
    if(!orgEvLink.getFunctionDesc().toString().equals("") || !orgEvLink.getArtisticFunctionDesc().toString().equals("")){
      if(!orgEvLink.getFunctionDesc().toString().equals("")) {
        organisation_name_vec.add(organisation.getName() + ", " + orgEvLink.getFunctionDesc() + ", No Artistic Function");
      } else if(!orgEvLink.getArtisticFunctionDesc().toString().equals("")) {
      organisation_name_vec.add(organisation.getName() + ", No Function, " + orgEvLink.getArtisticFunctionDesc());
      }
    }
    else { // Should not be possible to get this message
      organisation_name_vec.add(organisation.getName() + ", No Function, No Artistic Function");
    }
  }
  
  resource_link_vec = eventObj.getResEvLinks();

  for (int i=0; i < resource_link_vec.size(); i++) {
    Item tempItem = new Item(db_ausstage);
    tempItem.load(Integer.parseInt(resource_link_vec.get(i)+""));
    resource_name_vec.add(tempItem.getCitation());
  }

  national_play_vec        = eventObj.getPlayOrigins();
  national_production_vec  = eventObj.getProductionOrigins();
    
  out.println("<form name='event_addedit_form' id='event_addedit_form' action='event_addedit_process.jsp' method='post'  onsubmit='return checkCharacterDates();'>");
  out.println("<input type='hidden' name='f_eventid' value='" + eventid + "'>");

  pageFormater.writeHelper(out, "General Information", "helpers_no1.gif");
  pageFormater.writeTwoColTableHeader(out, "ID");
  out.println(eventid);
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Name *");
  out.println("<input type='text' name='f_event_name' size='60' class='line300' maxlength=200 value=\"" + eventObj.getEventName() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Umbrella");
  out.println("<input type='text' name='f_umbrella' size='60' class='line300' maxlength=60 value=\"" + eventObj.getUmbrella() + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "World Premiere");
  out.println("<input type='radio' name='f_world_premier' value='yes' " +
              (eventObj.getWorldPremier()?"checked":"") + ">");
  out.println("<input type='radio' name='f_world_premier' value='no' " +
              (eventObj.getWorldPremier()?"":"checked") + ">");
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Part of a Tour");
  out.println("<input type='radio' name='f_part_of_a_tour' value='yes' " +
              (eventObj.getPartOfATour()?"checked":"") + ">");
  out.println("<input type='radio' name='f_part_of_a_tour' value='no' " +
              (eventObj.getPartOfATour()?"":"checked") + ">");
  pageFormater.writeTwoColTableFooter(out);
  // Status
  pageFormater.writeTwoColTableHeader(out, "Status *");
  out.println("<select name='f_status' size='1' class='line250'>");
  rset = statusObj.getStatuses (stmt);

  // Display all of the Statuses (Stati?)
  while (rset.next())
  {
    out.print("<option value='" + rset.getString ("statusid") + "'");

    if (eventObj.getStatus().equals(rset.getString("statusid")))
      out.print(" selected");
    out.print(">" + rset.getString ("status") + "</option>");
  }
  rset.close ();
  
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeTwoColTableHeader(out, "Description");
  out.println("<textarea name='f_description' rows='5' cols='62' class='line300'>" + eventObj.getDescription() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  // Description Sources
  pageFormater.writeTwoColTableHeader(out, "Description Source");
  out.println("<select name='f_description_source' size='1' class='line250'>");
  rset = descriptionSourceObj.getDescriptionSources (stmt);

  // Display all of the Description Sources
  if(rset.next()){
    out.print("<option value=\"0\">None</option>");
    do{
      out.print("<option value='" + rset.getString ("descriptionsourceid") + "'");

      if (eventObj.getDescriptionSource().equals(rset.getString("descriptionsourceid")))
        out.print(" selected");
      out.print(">" + rset.getString ("descriptionsource") + "</option>");
    }while (rset.next());
  }
  rset.close ();
  
  // Display Dates
  pageFormater.writeTwoColTableFooter(out);
  pageFormater.writeHelper(out, "Dates", "helpers_no2.gif");
  
  pageFormater.writeTwoColTableHeader(out, "First Date *");

  out.println("<input type='text' name='f_first_date_day' size='2' class='line25' maxlength=2 value='" +
              eventObj.getDdfirstDate() + "'>");
  out.println("<input type='text' name='f_first_date_month' size='2' class='line25' maxlength=2 value='" +
              eventObj.getMmfirstDate() + "'>");
  out.println("<input type='text' name='f_first_date_year' size='4' class='line35' maxlength=4 value='" +
              eventObj.getYyyyfirstDate() + "'>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Last Date");
  out.println("<input type='text' name='f_last_date_day' size='2' class='line25' maxlength=2 value='" +
              eventObj.getDdlastDate() + "'>");
  out.println("<input type='text' name='f_last_date_month' size='2' class='line25' maxlength=2 value='" +
              eventObj.getMmlastDate() + "'>");
  out.println("<input type='text' name='f_last_date_year' size='4' class='line35' maxlength=4 value='" +
              eventObj.getYyyylastDate() + "'>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Opening Night");
  out.println("<input type='text' name='f_opening_night_date_day' size='2' class='line25' maxlength=2 value='" +
              eventObj.getDdopenDate() + "'>");
  out.println("<input type='text' name='f_opening_night_date_month' size='2' class='line25' maxlength=2 value='" +
              eventObj.getMmopenDate() + "'>");
  out.println("<input type='text' name='f_opening_night_date_year' size='4' class='line35' maxlength=4 value='" +
              eventObj.getYyyyopenDate() + "'>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "");
  out.println("Yes No");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Estimated Dates");
  out.println("<input type='radio' name='f_estimated_dates' value='yes' " +
              (eventObj.getEstimatedDates()?"checked":"") + ">");
  out.println("<input type='radio' name='f_estimated_dates' value='no' " +
              (eventObj.getEstimatedDates()?"":"checked") + ">");
  pageFormater.writeTwoColTableFooter(out);



  String f_selected_venue_id = request.getParameter("f_selected_venue_id");
  Venue  venueObj            = new Venue(db_ausstage);
  String state_name          = "";
  String suburb_name         = "";
  String country_name        = "";
  String location            = "";
  
  if (f_selected_venue_id != null)
  {
    eventObj.setVenueid(f_selected_venue_id);
    venueObj.load(Integer.parseInt(f_selected_venue_id));
    eventObj.setVenue(venueObj);
  }


  if (!eventObj.getVenue().getSuburb().equals (""))
    suburb_name = eventObj.getVenue().getSuburb();


  if (!eventObj.getVenue().getState().equals ("")){
    if(!suburb_name.equals("")) 
      location = suburb_name + ", " + state.getName(Integer.parseInt(eventObj.getVenue().getState()));
    else
      location = state.getName(Integer.parseInt(eventObj.getVenue().getState()));

  }
  // don't list state if not Australia
  if (!eventObj.getVenue().getCountry().equals ("")){
    country.load(Integer.parseInt(eventObj.getVenue().getCountry()));
    if(!suburb_name.equals("")) 
      location = suburb_name + ", " + country.getName();
    else
      location = country.getName();
  }

  pageFormater.writeHelper(out, "Venue", "helpers_no3.gif");
  pageFormater.writeTwoColTableHeader(out, "Venue *");
  out.println("<input type='hidden' name='f_venueid' value='" + eventObj.getVenueid() + "'>");
  out.println("<input type='text' name='f_venue_name' readonly size='50' class='line300' value=\"" + eventObj.getVenue().getName() + " - " + location + "\">");
  out.print("<td width=30><a style='cursor:hand' " +
            "onclick=\"Javascript:event_addedit_form.action='venue_search.jsp?mode=" + mode + "';" +
            "event_addedit_form.submit();\"><img border='0' src='/custom/images/popup_button.gif'></a></td>");
  pageFormater.writeTwoColTableFooter(out);

  //pageFormater.writeHelper(out, "Data Sources * (at least one)", "helpers_no4.gif");


  /**

  GLOBAL HIDDEN FIELDS
  
  use this only once 'cause all pages that submits
  using SELECT button (html generator) will be able to
  retreive these hidden input fields
  */
  hidden_fields.clear();
  hidden_fields.put("f_eventid", eventid);
  hidden_fields.put("fromEventPage", "true");
  

  ///////////////////////////////////
  // DATA SOURCE
  ///////////////////////////////////
  out.println("<a name='event_data_resource'></a>");
  pageFormater.writeHelper(out, "Data Sources", "helpers_no4.gif");
  out.println (htmlGenerator.displayLinkedItem("",
                                               "4",
                                               "event_data_resource.jsp",
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Information Sources",
                                               data_source_vec,
                                               1000));


  out.println("<a name='event_second_genre_link'></a>");
  pageFormater.writeHelper(out, "Genre Information", "helpers_no5.gif");

  ///////////////////////////////////
  // PRIMARY GENRE
  ///////////////////////////////////
  
  pageFormater.writeTwoColTableHeader(out, "Primary Genre *");
  out.println("<select name='f_primary_genre' size='1' class='line250'>");
  rset = primaryGenreObj.getPrimaryGenres (stmt);

  // Display all of the Primary Genres
  while (rset.next())
  {
    out.print("<option value='" + rset.getString ("genreclassid") + "'");

    if (eventObj.getPrimaryGenre().equals(rset.getString("genreclassid")))
      out.print(" selected");
    out.print(">" + rset.getString ("genreclass") + "</option>");
  }
  rset.close ();
  
  pageFormater.writeTwoColTableFooter(out);


  ///////////////////////////////////
  // SECONDARY GENRE
  ///////////////////////////////////
  

  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "5",
                                               "event_second_genre_link.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Secondary Genre (preferred)", 
                                               second_genres_vec,
                                               1000));
  

  ///////////////////////////////////
  // PRIMARY CONTENT INDICATOR
  ///////////////////////////////////
  
  out.println("<a name='event_primary_content_indicator'></a>");
  pageFormater.writeHelper(out, "Subjects", "helpers_no6.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "6",
                                               "event_primary_content_indicator.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Subjects", 
                                               primary_content_ind_vec,
                                               1000));

  

  /***************************
       EVENTS
  ****************************/
  out.println("<a name='event_events'></a>");
  pageFormater.writeHelper(out, "Events", "helpers_no7.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "7",
                                               "event_events.jsp",
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Events",
                                               event_name_vec,
                                               1000));


  ///////////////////////////////////
  // CONTRIBUTORS
  ///////////////////////////////////
  
  out.println("<a name='event_contributors'></a>");
  pageFormater.writeHelper(out, "Contributors", "helpers_no8.gif"); 
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "8",
                                               "event_contributors.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Contributors", 
                                               contributor_name_vec,
                                               1000));

  ///////////////////////////////////
  // ORGANISATIONS
  ///////////////////////////////////
  
  out.println("<a name='event_organisations'></a>");
  pageFormater.writeHelper(out, "Organisations", "helpers_no9.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "9",
                                               "event_organisations.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Organisations", 
                                               organisation_name_vec,
                                               1000));

  ///////////////////////////////////
  // NATIONAL ORIGIN
  ///////////////////////////////////
  out.println("<a name='event_country_play_select'></a>");                                             
  pageFormater.writeHelper(out, "National Origin", "helpers_no10.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "11_0",
                                               "event_country_play_select.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Play", 
                                               national_play_vec,
                                               1000));

  hidden_fields.clear();
  out.println("<a name='event_country_prod_select'></a>");  
  out.println (htmlGenerator.displayLinkedItem("",
                                               "11_1",
                                               "event_country_prod_select.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Production", 
                                               national_production_vec,
                                               1000));
           
  ///////////////////////////////////
  // WORKS
  ///////////////////////////////////                                               
  out.println("<a name='event_work_link'></a>");
  pageFormater.writeHelper(out, "Works", "helpers_no11.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "9",
                                               "event_work.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Works", 
                                               work_name_vec,
                                               1000));
  ///////////////////////////////////
  // RESOURCES
  ///////////////////////////////////                                           
  out.println("<a name='event_resource_link'></a>");
  pageFormater.writeHelper(out, "Resources", "helpers_no12.gif");
  hidden_fields.clear();
  out.println (htmlGenerator.displayLinkedItem("",
                                               "9",
                                               "event_item.jsp", 
                                               "event_addedit_form",
                                               hidden_fields,
                                               "Resources", 
                                               resource_name_vec,
                                               1000));

 ///////////////////////////////////
  // Further Information
  ///////////////////////////////////           
  pageFormater.writeHelper(out, "Further Information", "helpers_no13.gif");
  %>
  
  <table border='0' width='550' cellspacing='0' cellpadding='0'>
	<tr>
		<td width='78'>&nbsp;</td>
		<td width='450'>
  <%
  out.println("<textarea name='f_further_information' rows='5' cols='67' class='line300'>" + eventObj.getFurtherInformation() + "</textarea>");
%>

	   </td>
	</tr>
      </table>
<%

  pageFormater.writeTwoColTableFooter(out);


// Only show reviewed flag if in the Admin or Reviewer groups

CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
CmsObject cmsObject = cms.getCmsObject();
List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
List<String> groupNames = new ArrayList();
for(CmsGroup group:userGroups) {
   groupNames.add(group.getName());
}


// if (request.getRequestURI().indexOf("event_search") >=0) response.getOutputStream().print("curr "); -- to display "curr " in the list of classes 
if (groupNames.contains("Administrators") || groupNames.contains("Reviewers")) {
  //Reviewed Flag
  pageFormater.writeHelper(out, "Reviewed", "helpers_no14.gif");
  
  pageFormater.writeTwoColTableHeader(out, "Reviewed");
  out.println("<input type='checkbox' name='f_review' value='yes' " + (eventObj.getReview()?"checked":"") + ">");
  //out.println("<input type='radio' name='f_review' value='no' checked" + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no15.gif");
} else {
  out.println("<input type='hidden' name='f_review' value='" + (eventObj.getReview()?"yes":"") + "'>");

  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no14.gif");
}

  
 /***************************
       Data Entry Information
  ****************************/
  
  pageFormater.writeTwoColTableHeader(out, "Event ID:");
  out.print(eventObj.getEventid());
  pageFormater.writeTwoColTableFooter(out);
  
  if (eventObj.getEnteredByUser() != null && !eventObj.getEnteredByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Created by User:");
    out.print(eventObj.getEnteredByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Created:");
    out.print(ausstageCommon.formatDate(eventObj.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  if (eventObj.getUpdatedByUser() != null && !eventObj.getUpdatedByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Updated By User:");
    out.print(eventObj.getUpdatedByUser());
    System.out.println(" Updating User:" + eventObj.getUpdatedByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Updated:");
    out.print(ausstageCommon.formatDate(eventObj.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "welcome.jsp", "cross.gif", "submit", "next.gif");
  //pageFormater.writeFooter(out);

  // reset/set the state of the EVENT object
  session.setAttribute("eventObj",eventObj);
%>
</form>
<script language="javascript">
<!--
  function checkCharacterDates()
  {
    var ret_val = true;
    fieldName = "First Date";
    day   = document.event_addedit_form.f_first_date_day.value;
    month = document.event_addedit_form.f_first_date_month.value;
    year  = document.event_addedit_form.f_first_date_year.value;

    if (!checkDate(fieldName, day, month, year))
      return(false);

    fieldName = "Last Date";
    day   = document.event_addedit_form.f_last_date_day.value;
    month = document.event_addedit_form.f_last_date_month.value;
    year  = document.event_addedit_form.f_last_date_year.value;

    if (!checkDate(fieldName, day, month, year))
      return(false);

    fieldName = "Opening Night";
    day   = document.event_addedit_form.f_opening_night_date_day.value;
    month = document.event_addedit_form.f_opening_night_date_month.value;
    year  = document.event_addedit_form.f_opening_night_date_year.value;

    if (!checkDate(fieldName, day, month, year))
      return(false);

    if(!isFirstDateBeforeLastDate())
      return(false);

    if(document.event_addedit_form.f_first_date_year.value != ""){
      if(allowToSpanForYear())
        ret_val = true;
      else
        return(false);
    }else{
      alert("The First date field must be entered.");
      return(false);
    }
    return(ret_val);
  }

  function allowToSpanForYear(){
    var ret_val = true;
  
    // First Date
    var f_day   = document.event_addedit_form.f_first_date_day.value;
    var f_month = document.event_addedit_form.f_first_date_month.value;
    var f_year  = document.event_addedit_form.f_first_date_year.value;

    // Last Date
    var l_day   = document.event_addedit_form.f_last_date_day.value;
    var l_month = document.event_addedit_form.f_last_date_month.value;
    var l_year  = document.event_addedit_form.f_last_date_year.value;

    if(f_month != "" && f_year != "" && l_month != "" && l_year != ""){
      if(parseInt(f_year) != parseInt(l_year)){
        if((parseInt(l_year) - parseInt(f_year)) > 1){
          ret_val = confirm("Warning! This Event runs for more than 12 months.\nDo you want to continue?");
        }else if((parseInt(l_year) - parseInt(f_year)) == 1){
          if(parseInt(l_month) == parseInt(f_month)){
            if(f_day != "" && l_day != ""){
              if(parseInt(l_day) > parseInt(f_day))
                ret_val = confirm("Warning! This Event runs for more than 12 months.\nDo you want to continue?");
            }
          }else if(parseInt(l_month) > parseInt(f_month)){
            ret_val = confirm("Warning! This Event runs for more than 12 months.\nDo you want to continue?");
          }
        }
      }
    }else if(f_year != "" && l_year != ""){
      if((parseInt(l_year) - parseInt(f_year)) > 1)
          ret_val = confirm("Warning! This Event runs for more than 12 months.\nDo you want to continue?");
    }
    return(ret_val)
  }
  
  function checkDate(fieldName, day, month, year)
  {
    errorMessage = "Error in " + fieldName + " field. ";

    if (day == "  " || day == " ")
      day = "";
    if (month == "  " || month == " ")
      month = "";
    if (year == "  " || year == " ")
      year = "";
    
   if(day != "" && month == "")
    {
      alert(errorMessage + "If month is blank then day must be blank.");
      return false;
    }

    if(month != "" && year == "")
    {
      alert(errorMessage + "If year is blank then month must be blank.");
      return false;
    }

    if(day != "")
    {
      if (!checkValidDate(day, month, year))
      {
        alert(errorMessage + "Not a valid date. ");
        return false;
      }
      else
        return true;
    }
    
    if(month != "")
    {
      if (!isInteger (month))
        return false;
        
      if (month > 12 || month < 0)
      {
        alert(errorMessage + "Not a valid month.");
        return false;
      }
    }
    
    if(year != "")
    {
      if (!isInteger (year))
        return false;
        
      if (year > 3000 || year < 1700)
      {
        alert(errorMessage + "Not a valid year.");
        return false;
      }
    }
    return true;
  }

function isFirstDateBeforeLastDate(){
	
	var firstday   = document.event_addedit_form.f_first_date_day.value;
	var firstmonth = document.event_addedit_form.f_first_date_month.value;
	var firstyear  = document.event_addedit_form.f_first_date_year.value;
	
	var lastday    = document.event_addedit_form.f_last_date_day.value;
	var lastmonth  = document.event_addedit_form.f_last_date_month.value;
	var lastyear   = document.event_addedit_form.f_last_date_year.value;

	var firstdate = firstmonth + "/" + firstday + "/" + firstyear;					
	var lastdate  = lastmonth + "/" + lastday + "/" + lastyear;

	var aDate = firstdate.split("/");
	var bDate = lastdate.split("/");
		
		
	if((lastday != "" && lastmonth != "" && lastyear != "") || 
     (lastday == "" && lastmonth != "" && lastyear != "")){ // do we have a valid lastdate?
		var theLastDate  = new Date(bDate[2],bDate[0]-1,bDate[1]);
	    var theFirstDate = new Date(aDate[2],aDate[0]-1,aDate[1]);
	    
		if (theFirstDate.getTime() > theLastDate.getTime()){
		  alert("First Date can not be after the Last Date");
		  return false;
		}else{
		  return true;
		}
	}else{
	  return true;
	}
}
//-->
</script>
<cms:include property="template" element="foot" />
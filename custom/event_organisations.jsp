<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.OrgEvLink"%>
<%@ page import = "ausstage.Organisation"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
  int           MAX_RESULTS_RETURNED = 1000;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
Statement stmt = db_ausstage.m_conn.createStatement();
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  Vector filter_display_names       = new Vector ();
  Vector filter_names               = new Vector ();
  Vector order_display_names        = new Vector ();
  Vector order_names                = new Vector ();
  Vector textarea_db_display_fields = new Vector ();
  Vector buttons_names              = new Vector ();
  Vector buttons_actions            = new Vector ();
  String list_name                  = "";
  String selected_db_sql            = "";
  String list_db_sql                = "";
  String list_db_field_id_name      = "";
  OrgEvLink orgevlin;
  Vector orgevlinks;
  String selected_list_name              = "";
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();

  String filter_id;
  String filter_name;
  String filter_state;
  String filter_suburb;
  String filter_box_selected;

  String organisationName;
  String organisationId;
  Organisation organisation, org, organisa;

  Hashtable hidden_fields = new Hashtable();
  Event eventObj = (Event)session.getAttribute("eventObj");

  //we need to reset the OrgEvLink objects that sits in the 
  //m_org_evlinks vector in Event object in the session.
  //if we have updated a organisation that is already linked to the current event
  if(request.getParameter("setOrgEvLink") != null && !request.getParameter("setOrgEvLink").equals("")
     && request.getParameter("setOrgEvLink").equals("true")){
    orgevlinks = eventObj.getOrgEvLinks();
    //loop through all the OrgEvLink objects that are stored 
    //in the event objects member variable (Vector)
    for(int i = 0; i < orgevlinks.size(); i ++){
      orgevlin = (OrgEvLink)orgevlinks.get(i);
      //set the Organisation member object
      if(orgevlin.getOrganisationId().equals(request.getParameter("f_organisation_id"))){
        organisa = new Organisation(db_ausstage);
        organisa.load(Integer.parseInt(request.getParameter("f_organisation_id")));
        orgevlin.setOrganisationBean(organisa);

      }
    }
  }
  
  boolean fromEventPage     = true;
  boolean isPreviewForEvent = false;
  boolean isPartOfThisEvent = false;
  
  if(request.getParameter("isPreviewForEvent") != null){
    isPreviewForEvent = true;
    String org_id = request.getParameter("f_id");
    String name = request.getParameter("f_orgname");
    String other_name1 = request.getParameter("f_other_name1");
    String other_name2 = request.getParameter("f_other_name2");
    String other_name3 = request.getParameter("f_other_name3");
    String address = request.getParameter("f_address");
    String suburb = request.getParameter("f_suburb");
    String state = request.getParameter("f_orgstate");
    String postcode = request.getParameter("f_postcode");
    String contact = request.getParameter("f_contact");
    String contact_phone1 = request.getParameter("f_contact_phone1");
    String contact_phone2 = request.getParameter("f_contact_phone2");
    String contact_phone3 = request.getParameter("f_contact_phone3");
    String contact_fax = request.getParameter("f_contact_fax");
    String contact_email = request.getParameter("f_contact_email");
    String web_link = request.getParameter("f_web_link");
    String country = request.getParameter("f_country");
    String notes = request.getParameter("f_notes");

    if(org_id == null)        {org_id = "";}
    if(name == null)          {name = "";}
    if(other_name1 == null)   {other_name1 = "";}
    if(other_name2 == null)   {other_name2 = "";}
    if(other_name3 == null)   {other_name3 = "";}
    if(address == null)       {address = "";}
    if(suburb == null)        {suburb = "";}
    if(state == null)         {state = "";}
    if(postcode == null)      {postcode = "";}
    if(contact == null)       {contact = "";}
    if(contact_phone1 == null){contact_phone1 = "";}
    if(contact_phone2 == null){contact_phone2 = "";}
    if(contact_phone3 == null){contact_phone3 = "";}
    if(contact_fax == null)   {contact_fax = "";}
    if(contact_email == null) {contact_email = "";}
    if(web_link == null)      {web_link = "";}
    if(country == null || country.equals("")){country = "0";}
    if(notes == null)         {notes = "";}
    
    for(int i=0; i < eventObj.getOrgEvLinks().size() && !org_id.equals(""); i++){
      if(((OrgEvLink)eventObj.getOrgEvLinks().elementAt(i)).getOrganisationBean().getId() == Integer.parseInt(org_id)){
        organisation = ((OrgEvLink)eventObj.getOrgEvLinks().elementAt(i)).getOrganisationBean();
        organisation.setName(name);
        organisation.setOtherNames1(other_name1);
        organisation.setOtherNames2(other_name2);
        organisation.setOtherNames3(other_name3);
        organisation.setAddress(address);
        organisation.setSuburb(suburb);
        organisation.setState(state);
        organisation.setPostcode(postcode);
        organisation.setContact(contact);
        organisation.setPhone1(contact_phone1);
        organisation.setPhone2(contact_phone2);
        organisation.setPhone3(contact_phone3);
        organisation.setFax(contact_fax);
        organisation.setEmail(contact_email);
        organisation.setWebLinks(web_link);
        organisation.setCountry(country);
        organisation.setNotes(notes);
        
        OrgEvLink orgevlink = (OrgEvLink)eventObj.getOrgEvLinks().elementAt(i);
        orgevlink.setOrganisationBean(organisation);
        eventObj.getOrgEvLinks().setElementAt(orgevlink,i);
        isPartOfThisEvent = true;
        break;
      }
    }

    if(!isPartOfThisEvent){
      org = new Organisation(db_ausstage);
      org.setName(name);
      org.setOtherNames1(other_name1);
      org.setOtherNames2(other_name2);
      org.setOtherNames3(other_name3);
      org.setAddress(address);
      org.setSuburb(suburb);
      org.setState(state);
      org.setPostcode(postcode);
      org.setContact(contact);
      org.setPhone1(contact_phone1);
      org.setPhone2(contact_phone2);
      org.setPhone3(contact_phone3);
      org.setFax(contact_fax);
      org.setEmail(contact_email);
      org.setWebLinks(web_link);
      org.setCountry(country);
      org.setNotes(notes);

      if(!org_id.equals("")){ //  EDIT
        org.setId(Integer.parseInt(org_id));
        org.update();
      }else{                  //  ADD
        org.add();
      }
    }

    
  }

  if (request.getParameter("fromEventPage") == null)
    fromEventPage = false;

  if (fromEventPage) eventObj.setEventAttributes(request);

  String f_eventid = eventObj.getEventid();
  int    eventId   = Integer.parseInt(f_eventid);
  hidden_fields.put("f_eventid", f_eventid);

  String f_select_this_organisation_id   = request.getParameter("f_select_this_organisation_id");
  String f_unselect_this_organisation_id = request.getParameter("f_unselect_this_organisation_id");
  String orderBy = request.getParameter ("f_order_by");

  OrgEvLink orgEvLink = null;
  Vector orgEvLinks = eventObj.getOrgEvLinks();

  if (f_select_this_organisation_id != null)
  {
    orgEvLink = new OrgEvLink(db_ausstage);
    orgEvLink.load(f_select_this_organisation_id, f_eventid);
    orgEvLinks.add(orgEvLink);
  }

  if (f_unselect_this_organisation_id != null)
  {
    OrgEvLink savedEvLink = null;
    orgEvLink = new OrgEvLink(db_ausstage);
    orgEvLink.load(f_unselect_this_organisation_id, Integer.toString(eventId));

    // Can't use the remove() method as the beans won't be exactly the same (due to the database connection)
    for (int i=0; i < orgEvLinks.size(); i++)
    {
      savedEvLink = (OrgEvLink)orgEvLinks.get(i);
      if (savedEvLink.equals(orgEvLink))
      {
        orgEvLinks.remove(i);
        break;
      }
    }
  }

  eventObj.setOrgEvLinks(orgEvLinks);
  session.setAttribute("eventObj", eventObj);

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_organisation_id");
  filter_name         = request.getParameter ("f_name");
  filter_state        = request.getParameter ("f_state");
  filter_suburb       = request.getParameter ("f_suburb");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  //filter_display_names.addElement ("State");
  //filter_display_names.addElement ("Suburb");
  filter_names.addElement ("f_organisation_id");
  filter_names.addElement ("f_name");
  filter_names.addElement ("f_state");
  filter_names.addElement ("f_suburb");

  order_display_names.addElement ("Name");
  order_display_names.addElement ("State");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("name");
  order_names.addElement ("state");
  order_names.addElement ("suburb");

  list_name             = "f_select_this_organisation_id";
  list_db_field_id_name = "organisationId";
  textarea_db_display_fields.addElement ("OUTPUT");

  selected_list_name             = "f_unselect_this_organisation_id";
  selected_list_db_field_id_name = "organisationId";
  selected_list_db_display_fields.addElement ("name");
  selected_list_db_display_fields.addElement ("state");
  selected_list_db_display_fields.addElement ("suburb");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_organisations.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=Preview/EditForEvent';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=AddForEvent';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_organisation_functions.jsp';search_form.submit();");

  selected_db_sql = "";
  Vector selectedOrganisations = new Vector();

  for (int i=0; i < orgEvLinks.size(); i++)
  {
    if (i > 0) selected_db_sql += ", ";

    orgEvLink        = (OrgEvLink)orgEvLinks.get(i);
    organisationId   = orgEvLink.getOrganisationId();
    organisation     = orgEvLink.getOrganisationBean();
    organisationName = orgEvLink.getOrgDispInfo(stmt);
    selected_db_sql += organisationId;
    selectedOrganisations.add(organisationId);
    selectedOrganisations.add(organisationName);
  }

  // if first time this form has been loaded
  if (filter_id == null)
  {

     list_db_sql =   "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
"FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
"LEFT JOIN events ON (orgevlink.eventid = events.eventid)  "+
"GROUP BY organisation.organisationid ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   
	list_db_sql = "SELECT organisation.organisationid, organisation.name, "+
	"if (min(events.yyyyfirst_date) = max(events.yyyylast_date), "+
	"min(events . yyyyfirst_date), concat(min(events . yyyyfirst_date), ' - ', max(events . yyyylast_date))) dates, "+
	"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
	"FROM organisation left join orgevlink on (orgevlink.organisationid = organisation.organisationid) "+
	"left join events on orgevlink.eventid = events . eventid Where 1=1 ";
    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and organisation.organisationid=" + filter_id + " ";
    if (!filter_name.equals (""))
      list_db_sql += "and LOWER(organisation.name) like '%" + db_ausstage.plSqlSafeString(filter_name.toLowerCase()) + "%' ";
   // if (!filter_state.equals (""))
     //list_db_sql += "and LOWER(states.state) like '%" + db_ausstage.plSqlSafeString(filter_state.toLowerCase()) + "%' ";
//   if (!filter_suburb.equals (""))
  //   list_db_sql += "and LOWER(suburb) like '%" + db_ausstage.plSqlSafeString(filter_suburb.toLowerCase()) + "%' ";*/
  
    list_db_sql += "Group by organisation.organisationid ";
  }
    
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Organisations",
                  "Selected Organisations", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedOrganisations, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />
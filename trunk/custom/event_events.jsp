<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.EventEventLink"%>
<%@ page import = "ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  int           MAX_RESULTS_RETURNED = 1000;
 
  String        sqlString;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement        stmt         = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  
  Vector filter_display_names            = new Vector ();
  Vector filter_names                    = new Vector ();
  Vector order_display_names             = new Vector ();
  Vector order_names                     = new Vector ();
  Vector textarea_db_display_fields      = new Vector ();
  Vector buttons_names                   = new Vector ();
  Vector buttons_actions                 = new Vector ();
  String list_name                       = "";
  String selected_db_sql                 = "";
  String list_db_sql                     = "";
  String list_db_field_id_name           = "";
  String selected_list_name              = "";
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();
  String comeFromEventAddeditPage         = request.getParameter("f_from_event_add_edit_page");
  String filter_id;
  String filter_event_name;
  String filter_venue_name;
  String filter_day;
  String filter_month;
  String filter_year;
  String filter_box_selected;
  String organisationName;
  String organisationId;
  Event ev;

  Hashtable hidden_fields = new Hashtable();
  Event event = (Event)session.getAttribute("eventObj");
//we don't want to loose any info added to the event_addedit.jsp form.
  //only set the event attributes if we have come from the addedit page.
  if (comeFromEventAddeditPage != null && comeFromEventAddeditPage.equals("true")) 
    event.setEventAttributes(request);
  if (event == null) event = new Event(db_ausstage);
  boolean fromEventPage = true;
  boolean isPreviewForEvent = false;
  boolean isPartOfThisEvent = false;
  
  if (request.getParameter("isPreviewForEvent") == null) {
	    isPreviewForEvent = true;
	    String event_id = request.getParameter("f_eventid");
	    String name = request.getParameter("f_eventname");
	    String other_name1 = request.getParameter("f_other_name1");
	    String other_name2 = request.getParameter("f_other_name2");
	    String other_name3 = request.getParameter("f_other_name3");
	    String address = request.getParameter("f_address");
	    String suburb = request.getParameter("f_suburb");
	    String state = request.getParameter("f_evstate");
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
	  }
  
  if (request.getParameter("fromEventPage") == null)
	  fromEventPage = false;
  
  if (fromEventPage) event.setEventAttributes(request);

  String f_eventid = event.getEventid();
  int    eventId   = Integer.parseInt(f_eventid);
  hidden_fields.put("f_eventid", f_eventid);
  
  String f_select_this_event_id   = request.getParameter("f_select_this_event_id");
  String f_unselect_this_event_id = request.getParameter("f_unselect_this_event_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the events from the current item
  //object in the session.

  Vector<EventEventLink> eventEventLinks = event.getEventEventLinks();
 //System.out.println(eventeventLinks.toString());
//add the selected event to the event
  if (f_select_this_event_id != null) {
	EventEventLink eel = new EventEventLink(db_ausstage);
	eel.setEventId(f_eventid);
	eel.setChildId(f_select_this_event_id);
	eventEventLinks.add(eel);
	event.setEventEventLinks(eventEventLinks);        
    
  }
  //remove event from the event
  if (f_unselect_this_event_id != null) {
	for (EventEventLink existing : eventEventLinks) {
		if (existing.getChildId().equals(f_unselect_this_event_id)) {
			eventEventLinks.remove(existing);
			break;
		}
	}
    event.setEventEventLinks(eventEventLinks);   
  }

  session.setAttribute("eventObj", event);
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id         = request.getParameter ("f_search_id");
  filter_event_name = request.getParameter ("f_search_event_name");
  filter_venue_name = request.getParameter ("f_search_venue_name");
  filter_day        = request.getParameter ("f_search_day");
  filter_month      = request.getParameter ("f_search_month");
  filter_year       = request.getParameter ("f_search_year");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_display_names.addElement ("Venue");
  filter_display_names.addElement ("Day");
  filter_display_names.addElement ("Month");
  filter_display_names.addElement ("Year");
  filter_names.addElement ("f_search_id");
  filter_names.addElement ("f_search_event_name");
  filter_names.addElement ("f_search_venue_name");
  filter_names.addElement ("f_search_day");
  filter_names.addElement ("f_search_month");
  filter_names.addElement ("f_search_year");
  
  order_display_names.addElement ("Name");
  order_display_names.addElement ("Venue");
  order_display_names.addElement ("Day");
  order_display_names.addElement ("Month");
  order_display_names.addElement ("Year");             
  order_names.addElement ("event_name");
  order_names.addElement ("venue_name");
  order_names.addElement ("ddfirst_date");
  order_names.addElement ("mmfirst_date");
  order_names.addElement ("yyyyfirst_date");
  
  list_name             = "f_select_this_event_id";
  list_db_field_id_name = "eventid";
  //textarea_db_display_fields.addElement ("WORKID");
 // textarea_db_display_fields.addElement ("WORK_TITLE");
 
 
 
  textarea_db_display_fields.addElement ("output");

  selected_list_name             = "f_unselect_this_event_id";
  selected_list_db_field_id_name = "eventid";
  selected_list_db_display_fields.addElement ("name");
  selected_list_db_display_fields.addElement ("state");
  selected_list_db_display_fields.addElement ("suburb");

  /**********************************************************
  you can not edit/add a event through this page.
  i.e you can only link a item to an event, if and only if
  the event already exits.
  ***********************************************************/
  
  buttons_names.addElement ("Select");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_events.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_event_functions.jsp';search_form.submit();");
  
  selected_db_sql       = "";
  Vector selectedevents = new Vector();
  Vector temp_vector    = new Vector();
  String temp_string    = "";

  //because the vector that gets returned contains only linked
  //event ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a event id and the event name.
  //i.e. "4455, Luke Sullivan".

  //for each event id get name and add the id and the name to a temp vector.
  for(int i = 0; i < eventEventLinks.size(); i ++){
	temp_string = event.getEventInfoForDisplay(Integer.parseInt(eventEventLinks.get(i).getChildId()), stmt);
	
    temp_vector.add(eventEventLinks.get(i).getChildId());//add the id to the temp vector.
    temp_vector.add(temp_string);//add the event name to the temp_vector.
   
  }
  selectedevents = temp_vector;
  stmt.close();

   // if first time this form has been loaded
  if (filter_id == null)
  {  
      list_db_sql = "SELECT events.eventid, events.event_name, venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state, " +
    			"trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)) as display_first_date, "+  
    			"concat_ws(', ', events.event_name, venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state),trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)))as Output  "+                    
                        "FROM events, venue " +
                        "INNER JOIN states ON (venue.state = states.stateid) "+
                        "INNER JOIN country ON (venue.countryid = country.countryid) "+
                   	"WHERE events.venueid = venue.venueid " +
                	"ORDER BY events.event_name ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
      list_db_sql = "SELECT events.eventid, events.event_name, venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state, " +
    			"trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)) as display_first_date, "+  
    			"concat_ws(', ', events.event_name, venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state),trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)))as Output  "+ 
                        "FROM events, venue " +
                        "INNER JOIN states ON (venue.state = states.stateid) "+
                        "INNER JOIN country ON (venue.countryid = country.countryid) "+
                   	"WHERE events.venueid = venue.venueid ";

   // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and events.eventid=" + filter_id + " ";
    if (!filter_event_name.equals (""))
      list_db_sql += "and LOWER(events.event_name) like '%" +
                      db_ausstage.plSqlSafeString(filter_event_name.toLowerCase()) + "%' ";
    if (!filter_venue_name.equals (""))
      list_db_sql += "and LOWER(venue.venue_name) like '%" +
                      db_ausstage.plSqlSafeString(filter_venue_name.toLowerCase()) + "%' ";
    if (!filter_day.equals (""))
      list_db_sql += "and events.ddfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_day) + "%' ";
    if (!filter_month.equals (""))
      list_db_sql += "and events.mmfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_month) + "%' ";
    if (!filter_year.equals (""))
      list_db_sql += "and events.yyyyfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_year) + "%' ";
  
    list_db_sql += "order by " + request.getParameter ("f_order_by");
  }
  
//Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Events",
                  "Selected Events", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedevents, selected_list_db_field_id_name,
                  buttons_names, buttons_actions,
                  hidden_fields, false, MAX_RESULTS_RETURNED));
                  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
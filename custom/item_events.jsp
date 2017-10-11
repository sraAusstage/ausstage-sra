<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  int              MAX_RESULTS_RETURNED = 1000;

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
  String comeFromItemAddeditPage         = request.getParameter("f_from_item_add_edit_page");
  String filter_id;
  String filter_event_name;
  String filter_venue_name;
  String filter_day;
  String filter_month;
  String filter_year;
  String filter_box_selected;
  String organisationName;
  String organisationId;
  Event event, ev;

  Hashtable hidden_fields = new Hashtable();
  Item item = (Item)session.getAttribute("item");
  //we don't want to loose any info added to the item_addedit.jsp form.
  //only set the item attributes if we have come from the addedit page.
  if(comeFromItemAddeditPage != null && comeFromItemAddeditPage.equals("true"))
    item.setItemAttributes(request); 
  event = new Event(db_ausstage);
  boolean fromItemPage     = true;
  boolean isPreviewForItem = false;
  boolean isPartOfThisItem = false;
  
  if(request.getParameter("isPreviewForItem") != null){
    isPreviewForItem = true;
    String ev_id = request.getParameter("f_eventid");
    String name = request.getParameter("f_evname");
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

  if (request.getParameter("fromItemPage") == null)
    fromItemPage = false;

  if (fromItemPage) item.setItemAttributes(request);

  String f_itemid = item.getItemId();
  int    itemId   = Integer.parseInt(f_itemid);
  hidden_fields.put("f_itemid", f_itemid);

  String f_select_this_event_id   = request.getParameter("f_select_this_event_id");
  String f_unselect_this_event_id = request.getParameter("f_unselect_this_event_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the events from the current item
  //object in the session.
  
  Vector evItemLinks = item.getAssociatedEvents();

  //add the selected event to the item
  if (f_select_this_event_id != null)
  {
    evItemLinks.add(f_select_this_event_id);
    item.setItemEvLinks(evItemLinks, stmt, false);        
    
  }
  //remove event from the item
  if (f_unselect_this_event_id != null)
  {
    evItemLinks.remove(f_unselect_this_event_id);
    item.setItemEvLinks(evItemLinks, stmt, true);   
  }

  session.setAttribute("item", item);

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id         = request.getParameter ("f_id");
  filter_event_name = request.getParameter ("f_event_name");
  filter_venue_name = request.getParameter ("f_venue_name");
  filter_day        = request.getParameter ("f_day");
  filter_month      = request.getParameter ("f_month");
  filter_year       = request.getParameter ("f_year");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_display_names.addElement ("Venue");
  filter_display_names.addElement ("Day");
  filter_display_names.addElement ("Month");
  filter_display_names.addElement ("Year");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_event_name");
  filter_names.addElement ("f_venue_name");
  filter_names.addElement ("f_day");
  filter_names.addElement ("f_month");
  filter_names.addElement ("f_year");

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
 // textarea_db_display_fields.addElement ("event_name");
//  textarea_db_display_fields.addElement ("venue_name");
//  textarea_db_display_fields.addElement ("suburb");
//  textarea_db_display_fields.addElement ("state");
//  textarea_db_display_fields.addElement ("display_first_date");
  textarea_db_display_fields.addElement ("output");

  selected_list_name             = "f_unselect_this_event_id";
  selected_list_db_field_id_name = "eventId";
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
  buttons_actions.addElement ("Javascript:search_form.action='item_events.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp#item_events';search_form.submit();");

  selected_db_sql       = "";
  Vector selectedevents = new Vector();
  Vector temp_vector    = new Vector();
  String temp_string    = "";       
  selectedevents = item.getAssociatedEvents();

  //because the vector that gets returned contains only linked
  //event ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a event id and the event name.
  //i.e. "4455, Luke Sullivan".

  //for each event id get name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedevents.size(); i ++){
    temp_string = event.getEventInfoForItemDisplay(Integer.parseInt((String)selectedevents.get(i)), stmt);
    temp_vector.add(selectedevents.get(i));//add the id to the temp vector.
    temp_vector.add(temp_string);//add the event name to the temp_vector.
    
  }
  selectedevents = temp_vector;
  stmt.close();

  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT events.eventid, events.event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state, " +
    			"trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)) as display_first_date, "+  
    			"concat_ws(', ', event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state),trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)))as Output  "+                    
                        "FROM events, venue " +
                        "INNER JOIN states ON (venue.state = states.stateid) "+
                        "INNER JOIN country ON (venue.countryid = country.countryid) "+
                   	"WHERE events.venueid = venue.venueid " +
                	"ORDER BY event_name ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "SELECT eventid, event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state, " +
    			"trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)) as display_first_date, "+  
    			"concat_ws(', ', event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state),trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)))as Output  "+ 
                        "FROM events, venue " +
                        "INNER JOIN states ON (venue.state = states.stateid) "+
                        "INNER JOIN country ON (venue.countryid = country.countryid) "+
                   	"WHERE events.venueid = venue.venueid ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and eventid=" + filter_id + " ";
    if (!filter_event_name.equals (""))
      list_db_sql += "and LOWER(event_name) like '%" +
                      db_ausstage.plSqlSafeString(filter_event_name.toLowerCase()) + "%' ";
    if (!filter_venue_name.equals (""))
      list_db_sql += "and LOWER(venue_name) like '%" +
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
  
    if(request.getParameter("f_order_by").equals("venue_name")) {
    	list_db_sql += "order by venue." + request.getParameter ("f_order_by");
    } else {
       	list_db_sql += "order by events." + request.getParameter ("f_order_by");
    }
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select events",
                  "Selected events", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedevents, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
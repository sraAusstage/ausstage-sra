<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.Statement, java.util.*, sun.jdbc.rowset.CachedRowSet"%>
<%@ page import = "ausstage.VenueVenueLink, ausstage.Venue"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin    login         = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage       pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database         db_ausstage   = new ausstage.Database ();
 
  String                 sqlString;
  int MAX_RESULTS_RETURNED = 1000;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
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
  String comeFromVenueAddeditPage         = request.getParameter("f_from_venue_add_edit_page");
  String filter_id;
  String filter_name;
  String filter_state;
  String filter_suburb;
  String filter_box_selected;
  
  Hashtable hidden_fields = new Hashtable();
  Venue  venue   = (Venue)session.getAttribute("venueObj");
  if (venue == null) venue = new Venue(db_ausstage);
  //we don't want to loose any info added to the venue_addedit.jsp form.
  //only set the venue attributes if we have come from the addedit page.
  if(comeFromVenueAddeditPage != null && comeFromVenueAddeditPage.equals("true")){
	    venue.setVenueAttributes(request); 
	}
	
  selected_db_sql = "";
  Vector temp_vector          = new Vector();
  String temp_string          = "";         
  Vector selectedVenues       = new Vector();
  selectedVenues = venue.getAssociatedVenues();
  
  boolean fromVenuePage = true;
  boolean isPreviewForVenue = false;
  boolean isPartOfThisVenue = false;
  
  if (request.getParameter("isPreviewForVenue") == null) {
	    isPreviewForVenue = true;
	    String venue_id = request.getParameter("f_venue_id");
	    String name = request.getParameter("f_venuename");
	    String address = request.getParameter("f_address");
	    String suburb = request.getParameter("f_suburb");
	    String state = request.getParameter("f_evstate");
	    String postcode = request.getParameter("f_postcode");
	    String capacity = request.getParameter("f_capacity");
	    String contact = request.getParameter("f_contact");
	    String contact_phone1 = request.getParameter("f_contact_phone1");
	    String contact_fax = request.getParameter("f_contact_fax");
	    String contact_email = request.getParameter("f_contact_email");
	    String web_link = request.getParameter("f_web_link");
	    String country = request.getParameter("f_country");
	    String longitude = request.getParameter("f_longitude");
	    String latitude = request.getParameter("f_latitude");
	    String notes = request.getParameter("f_notes");
	  }
  if (request.getParameter("fromVenuePage") == null)
	  fromVenuePage = false;
  if (fromVenuePage) {
	  venue.setVenueAttributes(request);
  }

  String f_venueid = venue.getVenueId();
  int venueId = 0;
  try {
  	venueId   = Integer.parseInt(f_venueid);
  } catch (Exception e) {}
  hidden_fields.put("f_venueid", f_venueid);

  String f_select_this_venue_id   = request.getParameter("f_select_this_venue_id");
  //System.out.println("Selected Venue:" +f_select_this_venue_id);
  String f_unselect_this_venue_id = request.getParameter("f_unselect_this_venue_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the venues from the current venue
  //object in the session.
  Vector venuevenueLinks = venue.getAssociatedVenues();
  
  //add the selected venue to the venue
  if (f_select_this_venue_id != null)
  {
    venuevenueLinks.add(f_select_this_venue_id);
    venue.setVenueVenueLinks(venuevenueLinks);  
             
  } 
  //remove venue from the venue
  if(f_unselect_this_venue_id != null)
  {
    venuevenueLinks.remove(f_unselect_this_venue_id);
    venue.setVenueVenueLinks(venuevenueLinks);   
  }  
  session.setAttribute("venueObj", venue);
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id     = request.getParameter ("f_search_id");
  filter_name   = request.getParameter ("f_search_name");
  filter_state  = request.getParameter ("f_search_state");
  filter_suburb = request.getParameter ("f_search_suburb");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_display_names.addElement ("State");
  filter_display_names.addElement ("Suburb");
  
  filter_names.addElement ("f_search_id");
  filter_names.addElement ("f_search_name");
  filter_names.addElement ("f_search_state");
  filter_names.addElement ("f_search_suburb");

  order_display_names.addElement ("Name");
  order_display_names.addElement ("State");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("venue_name");
  order_names.addElement ("state");
  order_names.addElement ("suburb");

  list_name              = "f_select_this_venue_id";
  list_db_field_id_name  = "venueid";
  textarea_db_display_fields.addElement ("OUTPUT");
  
  selected_list_name     = "f_unselect_this_venue_id";
  selected_list_db_field_id_name = "venueid";
  selected_list_db_display_fields.addElement("OUTPUT");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='venue_venues.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='venue_venue_functions.jsp';search_form.submit();");

  //because the vector that gets returned contains only linked
  //venue ids as strings we need to create a temp vector
  //for teh display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a venue id and the venue name.
  //i.e. "4455, Luke Sullivan".

  //for each venue id get the name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedVenues.size(); i ++){
  	try{
	     // temp_string = venue.getVenueInfoForVenueDisplay(Integer.parseInt(venue.getVenueId()), stmt);
	      temp_string = venue.getVenueInfoForVenueDisplay(Integer.parseInt((String)selectedVenues.get(i)), stmt);
	}catch(Exception e){
	      temp_string = venue.getVenueInfoForVenueDisplay(Integer.parseInt((String)selectedVenues.get(i)), stmt);
	}
	    temp_vector.add(selectedVenues.get(i));//add the id to the temp vector.
	    //System.out.println("In for loop: " + selectedVenues.get(i));
	    temp_vector.add(temp_string);//add the venue name to the temp_vector.
	  }
  selectedVenues = temp_vector;
 //System.out.println("selected after " + selectedVenues);
  stmt.close();
  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "select venueid, venue_name, street , suburb ,states.state as state,country.countryname, "+
    "CONCAT_WS(', ',venue.venue_name,venue.street,venue.suburb,IF(states.state='O/S', country.countryname, states.state)) AS OUTPUT "+ 
    "from venue LEFT Join states on (venue.state = states.stateid) "+
 	" LEFT join country on (venue.countryid = country.countryid) order by venue_name";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "select venueid, venue_name, street , suburb ,states.state as state,country.countryname, "+
    "CONCAT_WS(', ',venue.venue_name,venue.street,venue.suburb,IF(states.state='O/S', country.countryname, states.state)) AS OUTPUT "+ 
    "from venue LEFT Join states on (venue.state = states.stateid) "+
    "LEFT join country on (venue.countryid = country.countryid) WHERE 1=1 ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and venueid=" + filter_id + " ";
    if (!filter_name.equals (""))
      list_db_sql += "and LOWER(venue_name) like '%" + db_ausstage.plSqlSafeString(filter_name.toLowerCase()) + "%' ";
    if (!filter_state.equals (""))
      list_db_sql += "and LOWER(states.state) like '%" + db_ausstage.plSqlSafeString(filter_state.toLowerCase()) + "%' ";
    if (!filter_suburb.equals (""))
      list_db_sql += "and LOWER(suburb) like '%" + db_ausstage.plSqlSafeString(filter_suburb.toLowerCase()) + "%' ";
  
    list_db_sql += "order by " + request.getParameter ("f_order_by");
  }

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Venues",
                  "Selected Venues", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedVenues, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
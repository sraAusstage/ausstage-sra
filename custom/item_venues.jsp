<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.Venue"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />


<%
  admin.ValidateLogin    login         = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage       pageFormater  = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database         db_ausstage   = new ausstage.Database ();
  String                 sqlString;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
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
  String filter_name;
  String filter_state;
  String filter_suburb;
  String filter_box_selected;
  Venue ven;
  String contributorName;
  String contributorId;
  
  Hashtable hidden_fields = new Hashtable();

  Item  item   = (Item)session.getAttribute("item");
  //we don't want to loose any info added to the item_addedit.jsp form.
  //only set the item attributes if we have come from the addedit page.
  if(comeFromItemAddeditPage != null && comeFromItemAddeditPage.equals("true"))
    item.setItemAttributes(request); 
  Venue venue = new Venue(db_ausstage);
  boolean isPreviewForItem = false;
  boolean fromItemPage     = true;
  boolean isPartOfThisItem = false;
  
  if(request.getParameter("isPreviewForItem") != null){
    isPreviewForItem = true;
    String process_type            = request.getParameter("process_type");
    String venue_id              = request.getParameter("f_id");
    String venue_fname           = request.getParameter("f_name");
    String venue_lname           = request.getParameter("f_l_name");
    String venue_other_names     = request.getParameter("f_venue_other_names");
    String venue_dob_d           = request.getParameter("f_venue_day");
    String venue_dob_m           = request.getParameter("f_venue_month");
    String venue_dob_y           = request.getParameter("f_venue_year");
    String venue_gender_id       = request.getParameter("f_venue_gender_id");
    String venue_nationality     = request.getParameter("f_venue_nationality");
    String venue_address         = request.getParameter("f_venue_address");
    String venue_town            = request.getParameter("f_venue_town");
    String venue_state           = request.getParameter("f_venue_state");
    String venue_postcode        = request.getParameter("f_venue_postcode");
    String venue_country_id      = request.getParameter("f_venue_country_id");
    String venue_email           = request.getParameter("f_venue_email");
    String venue_notes           = request.getParameter("f_venue_notes");
    String venue_funct_ids       = request.getParameter("delimited_venue_funct_ids");
    String warning_check           = request.getParameter("warning_check");

    if(venue_id == null)          {venue_id = "";}
    if(venue_fname == null)       {venue_fname = "";}
    if(venue_lname == null)       {venue_lname = "";}
    if(venue_other_names == null) {venue_other_names = "";}
    if(venue_gender_id == null)   {venue_gender_id = "";}
    if(venue_dob_d == null)       {venue_dob_d = "";}
    if(venue_dob_m == null)       {venue_dob_m = "";}
    if(venue_dob_y == null)       {venue_dob_y = "";}
    if(venue_nationality == null) {venue_nationality = "";}
    if(venue_address == null)     {venue_address = "";}
    if(venue_town == null)        {venue_town = "";}
    if(venue_state == null)       {venue_state = "";}
    if(venue_postcode == null)    {venue_postcode = "";}
    if(venue_country_id == null)  {venue_country_id = "";}
    if(venue_email == null)       {venue_email = "";}
    if(venue_notes == null)       {venue_notes = "";}
    if(venue_funct_ids == null || venue_funct_ids.equals("")) {venue_funct_ids = "";}
  }

  if (request.getParameter("fromItemPage") == null)
    fromItemPage = false;

  if(fromItemPage) item.setItemAttributes(request);

  String f_itemid = item.getItemId();
  int    itemId   = Integer.parseInt(f_itemid);
  hidden_fields.put("f_itemid", f_itemid);

  String f_select_this_venue_id   = request.getParameter("f_selected_venue_id");
  String f_unselect_this_venue_id = request.getParameter("f_unselect_this_venue_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the venues from the current item
  //object in the session.
  Vector itemVenueLinks = item.getAssociatedVenues();
  
  //add the selected venue to the item
  if (f_select_this_venue_id != null)
  {
    //need to add the venues id to the item.
    itemVenueLinks.add(f_select_this_venue_id);
    item.setItemVenueLinks(itemVenueLinks);                                                                                                          
  }
  //remove venue from the item
  if (f_unselect_this_venue_id != null)
  { 
    //need to remove the contributor id from the item.
    itemVenueLinks.remove(f_unselect_this_venue_id);
    item.setItemVenueLinks(itemVenueLinks);   
  }
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id     = request.getParameter ("f_id");
  filter_name   = request.getParameter ("f_name");
  filter_state  = request.getParameter ("f_state");
  filter_suburb = request.getParameter ("f_suburb");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_display_names.addElement ("State");
  filter_display_names.addElement ("Suburb");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_name");
  filter_names.addElement ("f_state");
  filter_names.addElement ("f_suburb");

  order_display_names.addElement ("Name");
  order_display_names.addElement ("State");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("venue_name");
  order_names.addElement ("state");
  order_names.addElement ("suburb");

  list_name              = "f_selected_venue_id";
  list_db_field_id_name  = "venueid";
  //textarea_db_display_fields.addElement ("venue_name");
  //textarea_db_display_fields.addElement ("suburb");
  //textarea_db_display_fields.addElement ("state");3
  textarea_db_display_fields.addElement ("OUTPUT");
  selected_list_name     = "f_unselect_this_venue_id";
  selected_list_db_field_id_name = "contributorId";

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='item_venues.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?action=EditForItem';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?action=AddForItem';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp#item_venues_link';search_form.submit();");

  selected_db_sql = "";
  Vector selectedVenues       = new Vector();
  Vector temp_vector          = new Vector();
  String temp_string          = "";         
  selectedVenues = item.getAssociatedVenues();
  
  //because the vector that gets returned contains only linked
  //venue ids as strings we need to create a temp vector
  //for teh display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a venue id and the venue name.
  //i.e. "4455, Luke Sullivan".

  //for each venue id get the name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedVenues.size(); i ++){
    temp_string = venue.getVenueInfoForItemDisplay(Integer.parseInt((String)selectedVenues.get(i)), stmt);
    temp_vector.add(selectedVenues.get(i));//add the id to the temp vector.
    temp_vector.add(temp_string);//add the venue name to the temp_vector.
    
  }
  selectedVenues = temp_vector;
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
                  buttons_names, buttons_actions, hidden_fields, false, 1000));

  session.setAttribute("item", item);
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
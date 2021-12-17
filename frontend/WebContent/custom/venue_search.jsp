<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.Contributor, ausstage.Organisation"%>

<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  
  String        sqlString;
  CachedRowSet  rset;
  int           MAX_RESULTS_RETURNED = 1000;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  Vector filter_display_names       = new Vector ();
  Vector filter_names               = new Vector ();
  Vector order_display_names        = new Vector ();
  Vector order_names                = new Vector ();
  Vector textarea_db_display_fields = new Vector ();
  Vector buttons_names              = new Vector ();
  Vector buttons_actions            = new Vector ();
  String list_name;
  String list_db_sql;
  String list_db_field_id_name;
  String filter_id, filter_name, filter_state, filter_suburb;


  String action = request.getParameter("act");
  if (action == null) action = "";
  // Have we just come from event_addedit.jsp?
  Contributor contribObj = null;
  Organisation organisationObj = null;
  Event eventObj = null;
  boolean finishButton = false;
  boolean placeOfBirthButton = false;
  boolean placeOfDeathButton = false;
  boolean placeOfOriginButton = false;
  boolean placeOfDemiseButton = false;
  
  if (request.getParameter("place_of_birth") != null) {
    placeOfBirthButton = true;
  } else if (request.getParameter("place_of_death") != null) {
    placeOfDeathButton = true;
  } else if (request.getParameter("place_of_origin") != null) {
    placeOfOriginButton = true;
  } else if (request.getParameter("place_of_demise") != null) {
    placeOfDemiseButton = true;    
  } else if (request.getParameter("f_eventid") != null || action.contains("ForEvent")) {
    	eventObj = (Event)session.getAttribute("eventObj"); // Get the Event object.
	    if (eventObj == null) {                              // Make sure it exists
	      eventObj = new Event(db_ausstage);
	    }
    	    if (request.getParameter("f_event_name") != null) {
	      eventObj.setEventAttributes(request);               // Update it with the request data if there's data in the request.
	    }
    session.setAttribute("eventObj", eventObj);         // And put it back into the session.
    finishButton = true;                                // Need a Finish Button for the user.
  } else {
    eventObj = (Event)session.getAttribute("eventObj"); // Do we need a Finish Button anyway?
    //if (eventObj != null)
    //  finishButton = true;
  }
  String contributor_id = request.getParameter("f_contrib_id");

  if (request.getParameter("f_contrib_id") != null) {
    contribObj = (Contributor)session.getAttribute("contributor"); // Get the contributor object.
    if (contribObj == null)                               // Make sure it exists
      contribObj = new Contributor(db_ausstage);
    contribObj.setContributorAttributes(request);               // Update it with the request data.
    session.setAttribute("contributor", contribObj );         // And put it back
  }
  
  String organisation_id = request.getParameter("f_org_id");
  if (request.getParameter("f_org_id") != null) {
    organisationObj = (Organisation)session.getAttribute("organisationObj"); // Get the organisation object.
    if (organisationObj == null)                               // Make sure it exists
      organisationObj = new Organisation(db_ausstage);
    organisationObj.setOrganisationAttributes(request);               // Update it with the request data.
    session.setAttribute("organisationObj", organisationObj );         // And put it back
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
  textarea_db_display_fields.addElement ("OUTPUT");
  
  if (!placeOfBirthButton&&!placeOfDeathButton&&!placeOfOriginButton&&!placeOfDemiseButton){	
  	buttons_names.addElement ("Add");
  	buttons_names.addElement ("Edit/View");
  	buttons_names.addElement ("Delete");
  }
  

  

  if (finishButton || placeOfOriginButton || placeOfDemiseButton  || placeOfBirthButton || placeOfDeathButton) buttons_names.addElement ("Finish"); // Have to go back to Event Maintenance

  

  if (finishButton){
    buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?act="+action+"&action=add'");
    buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit';search_form.submit();");  
    //buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp?act="+action+"';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp';search_form.submit();");
  }
  else if (placeOfBirthButton){
  	//buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?action=add&place_of_birth=1'");
  	//buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit&place_of_birth=1';search_form.submit();");
  	//buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp&place_of_birth=1';search_form.submit();");
    	buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act="+action+"&place_of_birth=1&isReturn=true';search_form.submit();");
  }
  else if (placeOfDeathButton){
	//buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?action=add&place_of_death=1'");
  	//buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit&place_of_death=1';search_form.submit();");
	//buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp&place_of_death=1';search_form.submit();");  
    	buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act="+action+"&place_of_death=1&isReturn=true';search_form.submit();");
  } 	
  else if (placeOfOriginButton){
  	//buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?action=add&place_of_origin=1'");
	//buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit&place_of_origin=1';search_form.submit();");  
  	//buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp';search_form.submit();");
    	buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act="+action+"&place_of_origin=1&isReturn=true';search_form.submit();");
  }
  else if (placeOfDemiseButton){
  	//buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?action=add&place_of_demise=1'");
	//buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit&place_of_demise=1';search_form.submit();");  
  	//buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp';search_form.submit();");
    	buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act="+action+"&place_of_demise=1&isReturn=true';search_form.submit();");
	
  }else {
  	buttons_actions.addElement ("Javascript:location.href='venue_addedit.jsp?act="+action+"&action=add'");
 	buttons_actions.addElement ("Javascript:search_form.action='venue_addedit.jsp?act="+action+"&action=edit';search_form.submit();");  
 	buttons_actions.addElement ("Javascript:search_form.action='venue_del_confirm.jsp?act="+action+"';search_form.submit();");
  }
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "select venueid, venue_name, street , suburb ,states.state as state,country.countryname, "+
    "CONCAT_WS(', ',venue.venue_name,venue.street,venue.suburb,IF(states.state='O/S', country.countryname, states.state)) AS OUTPUT "+ 
    "from venue LEFT Join states on (venue.state = states.stateid) "+
 	" LEFT join country on (venue.countryid = country.countryid) order by venue_name ";
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
    if (filter_id != null && !filter_id.equals (""))
      list_db_sql += "and venueid=" + filter_id + " ";
    if (filter_name!= null && !filter_name.equals (""))
      list_db_sql += "and LOWER(venue_name) like '%" + db_ausstage.plSqlSafeString(filter_name.toLowerCase()) + "%' ";
    if (filter_state!= null && !filter_state.equals (""))
      list_db_sql += "and LOWER(states.state) like '%" + db_ausstage.plSqlSafeString(filter_state.toLowerCase()) + "%' ";
    if (filter_suburb!= null && !filter_suburb.equals (""))
      list_db_sql += "and LOWER(suburb) like '%" + db_ausstage.plSqlSafeString(filter_suburb.toLowerCase()) + "%' ";
  
    list_db_sql += " order by " + request.getParameter ("f_order_by");
  }
  //pageFormater.writeHelper(out, "Venue Maintenance","helpers_no1.gif");
   list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  
   out.println (htmlGenerator.displaySearchFilter (request, "Select Venue",
                                        filter_display_names,
                                        filter_names,
                                        order_display_names,
                                        order_names,
                                        list_name,
                                        list_db_sql,
                                        list_db_field_id_name,
                                        textarea_db_display_fields,
                                        buttons_names,
                                        buttons_actions,
                                        false, 
                                        MAX_RESULTS_RETURNED));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />
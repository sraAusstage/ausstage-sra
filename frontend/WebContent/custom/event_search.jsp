<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%@ include file="../admin/content_common.jsp"%>

<%@ include file="../custom/ausstage_common.jsp"%>
<jsp:include page="../templates/admin-header.jsp" />
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

  pageFormater.writeHeader(out);
 pageFormater.writePageTableHeader (out,"", ausstage_main_page_link);

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
  String filter_id, filter_event_name, filter_venue_name, filter_day, filter_month, filter_year;

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

  list_name             = "f_eventid";
  list_db_field_id_name = "eventid";
  //textarea_db_display_fields.addElement ("event_name");
  //textarea_db_display_fields.addElement ("venue_name");
  //textarea_db_display_fields.addElement ("suburb");
  //textarea_db_display_fields.addElement ("state");
 // textarea_db_display_fields.addElement ("display_first_date");
  textarea_db_display_fields.addElement ("output");
  
  
  if (session.getAttribute("permissions").toString().contains("Event Editor") || session.getAttribute("permissions").toString().contains("Administrators")) {
  buttons_names.addElement ("Add");
  
  buttons_names.addElement ("Edit/View");
  

  buttons_names.addElement ("Copy");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='event_addedit.jsp?mode=add'");
  buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp?mode=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_copy.jsp?mode=copy';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_del_confirm.jsp?mode=delete';search_form.submit();");
  }
  //////////////////////////////////
  //build the SELECT   

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
  //build a more customized search
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "SELECT events.eventid, events.event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state) state, " +
    			"trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)) as display_first_date, "+       
    			"concat_ws(', ', event_name, venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state),trim(CONCAT_WS(' ', events.ddfirst_date, monthname(concat('2000-',events.mmfirst_date, '-01')), events.yyyyfirst_date)))as Output  "+                    
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
  	
    if(request.getParameter("f_order_by").equals("venue_name")) {
    	list_db_sql += "order by venue." + request.getParameter ("f_order_by");
    } else {
       	list_db_sql += "order by events." + request.getParameter ("f_order_by");
    }
  }
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  // pageFormater.writeHelper(out,"Event Name","helpers_no1.gif");
  
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilter (request,"Select event name ",
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
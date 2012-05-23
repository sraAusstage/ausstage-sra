<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../admin/content_common.jsp"%>
<%@ include file="../../pages/ausstage/ausstage_common.jsp"%>
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  
  String        sqlString;
  CachedRowSet  rset;
  int           MAX_RESULTS_RETURNED = 50;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

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
  textarea_db_display_fields.addElement ("event_name");
  textarea_db_display_fields.addElement ("venue_name");
  textarea_db_display_fields.addElement ("display_first_date");
  

  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Copy");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='event_addedit.jsp?mode=add'");
  buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp?mode=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_copy.jsp?mode=copy';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_del_confirm.jsp?mode=delete';search_form.submit();");
  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT eventid, event_name, venue_name, " +
                         "ddfirst_date || DECODE(ddfirst_date,'','','/') || " +  // If no day then omit '/'
                         "mmfirst_date || DECODE(mmfirst_date,'','','/') || " +  // If no month then omit '/'
                         "yyyyfirst_date AS display_first_date " +
                    "FROM events, venue " +
                   "WHERE events.venueid = venue.venueid " +
                "ORDER BY event_name ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "SELECT eventid, event_name, venue_name, " +
                         "ddfirst_date || DECODE(ddfirst_date,'','','/') || " +  // If no day then omit '/'
                         "mmfirst_date || DECODE(mmfirst_date,'','','/') || " +  // If no month then omit '/'
                         "yyyyfirst_date AS display_first_date " +
                    "FROM events, venue " +
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
      list_db_sql += "and ddfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_day) + "%' ";
    if (!filter_month.equals (""))
      list_db_sql += "and mmfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_month) + "%' ";
    if (!filter_year.equals (""))
      list_db_sql += "and yyyyfirst_date like '%" +
                      db_ausstage.plSqlSafeString(filter_year) + "%' ";
  
    list_db_sql += "order by " + request.getParameter ("f_order_by");
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql = "select * from (" + list_db_sql + ") where " +
                "rownum <= " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilter (request, "Select event_name ",
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

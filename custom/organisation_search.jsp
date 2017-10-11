<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
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
  String filter_id, filter_name, filter_state, filter_suburb;

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id     = request.getParameter ("f_id");
  filter_name   = request.getParameter ("f_name");

  // Setup the vectors for the search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_name");

  order_display_names.addElement ("Name");
  order_names.addElement ("name");

  list_name              = "f_organisation_id";
  list_db_field_id_name  = "organisationid";
  textarea_db_display_fields.addElement ("OUTPUT");
  
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='organisation_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_del_confirm.jsp';search_form.submit();");
    
  // if first time this form has been loaded
  if (filter_id == null)
  {

     list_db_sql =   "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
		"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
		"FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
		"LEFT JOIN events ON (orgevlink.eventid = events.eventid) "+
		"GROUP BY organisation.organisationid order by organisation.name  ";
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
   //   list_db_sql += "and LOWER(states.state) like '%" + db_ausstage.plSqlSafeString(filter_state.toLowerCase()) + "%' ";
   // if (!filter_suburb.equals (""))
    //  list_db_sql += "and LOWER(suburb) like '%" + db_ausstage.plSqlSafeString(filter_suburb.toLowerCase()) + "%' ";*/
  
    list_db_sql += "Group by organisation.organisationid order by " + request.getParameter ("f_order_by");
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
 // pageFormater.writeHelper(out, "Organisation Maintenance ","helpers_no1.gif");
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilter (request, "Select Organisation",
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
<cms:include property="template" element="foot" />
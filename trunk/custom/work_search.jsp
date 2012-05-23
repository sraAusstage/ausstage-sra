<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
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
  String filter_work_id, filter_work_title;

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_work_id     = request.getParameter ("f_id");
  filter_work_title   = request.getParameter ("f_work_title");


  // Setup the vectors for the search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Title");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_work_title");

  order_display_names.addElement ("Work Title");
  order_names.addElement ("work_title");


  list_name              = "f_workid";
  list_db_field_id_name  = "workid";
  textarea_db_display_fields.addElement ("output");
 // textarea_db_display_fields.addElement ("contribname");

  
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='work_addedit.jsp?action=add'");
  buttons_actions.addElement ("Javascript:search_form.action='work_addedit.jsp?action=edit';search_form.submit();");
  
/*  if (document.getElementById('f_name').selectedIndex<=0) {
  alert('Please select all functions');
  }
  */
  buttons_actions.addElement ("Javascript:search_form.action='work_del_confirm.jsp';search_form.submit();");
  
  // if first time this form has been loaded
  if (filter_work_id == null)
  {
     list_db_sql = "SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ') contribname, " +
     "concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output "+
			"FROM work  " +
			"LEFT JOIN workconlink ON work.workid = workconlink.workid " +
			"LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid " +
			"GROUP BY work.workid " +
			"ORDER BY LOWER(work_title)";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
       list_db_sql = "SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ') contribname, " +
        "concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output "+
			"FROM work  " +
			"LEFT JOIN workconlink ON work.workid = workconlink.workid " +
			"LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid " +
			"WHERE ";

    // Add the filters to the SQL
    if ( !filter_work_id.equals (""))
      list_db_sql += " work.workid=" + filter_work_id + " and ";
    if ( !filter_work_title.equals ("")) {
      list_db_sql += " LOWER(work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ";
    } else {
      list_db_sql += " 1=1 ";
    } 
    list_db_sql += "group by work_title order by LOWER(" + request.getParameter ("f_order_by") + ")";
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  
  //pageFormater.writeHelper(out, "Works Maintenance","helpers_no1.gif");
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  out.println (htmlGenerator.displaySearchFilter (request, "Select Work",
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
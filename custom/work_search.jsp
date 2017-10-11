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
  String filter_work_id, filter_work_title, filter_first_name, filter_last_name, filter_org_name;

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_work_id     = request.getParameter ("f_id");
  filter_work_title   = request.getParameter ("f_work_title");
  filter_first_name = request.getParameter ("f_first_name");
  filter_last_name = request.getParameter ("f_last_name");
  filter_org_name = request.getParameter ("f_org_name");


  // Setup the vectors for the search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Title");
  filter_display_names.addElement ("Creator First Name");
  filter_display_names.addElement ("Creator Last Name");
  filter_display_names.addElement ("Organisation name");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_work_title");
  filter_names.addElement ("f_first_name");
  filter_names.addElement ("f_last_name");
  filter_names.addElement ("f_org_name");

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
  
  //BW 
  String where_one = "";
  String where_two = "";
  String orderby = "";
  
  list_db_sql = 
  "SELECT w.workid, w.work_title, w.output FROM ( "+
  	"SELECT work.workid, work_title, "+
	  	"group_concat( concat_ws(' ',  contributor.first_name, contributor.last_name)separator ', ') as contribname, "+
   		"concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output, "+
   		"group_concat( contributor.last_name separator ', ') as last_names, "+
           	"group_concat( contributor.first_name separator ', ') as first_names "+ 
	"FROM work "+
	"LEFT JOIN workconlink ON work.workid = workconlink.workid "+
	"LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid "+
	"WHERE <WHERE_ONE> 1=1 "+ 
        "group by work.workid "+
  ") AS w "+
  "LEFT JOIN workorglink ON w.workid = workorglink.workid "+
  "LEFT JOIN organisation ON workorglink.organisationid = organisation.organisationid "+
  "WHERE <WHERE_TWO> 1=1 "+
  "group by workid order by <ORDERBY>";
  // if first time this form has been loaded
  if (filter_work_id == null)
  {
     list_db_sql = list_db_sql.replace("<WHERE_ONE>", where_one);
     list_db_sql = list_db_sql.replace("<WHERE_TWO>", where_two);
     list_db_sql = list_db_sql.replace("<ORDERBY>", "LOWER(work_title)");

  }
  else
  {
    // Add the filters to the SQL
    if ( !filter_work_id.equals (""))
      where_one += " work.workid=" + filter_work_id + " and ";
    
    if ( !filter_first_name.equals ("")) {
      where_two += " LOWER(w.first_names) like '%" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_last_name.equals ("")) {
      where_two += " LOWER(w.last_names) like '%" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_org_name.equals ("")) {
      where_two += " LOWER(organisation.name) like '%" + db_ausstage.plSqlSafeString(filter_org_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_work_title.equals ("")) {
      where_one += " ( LOWER(work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ";
      where_one += " OR LOWER(alter_work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ) AND ";
    }  
    orderby += "LOWER(" + request.getParameter ("f_order_by") + ")";
    
     list_db_sql = list_db_sql.replace("<WHERE_ONE>", where_one);
     list_db_sql = list_db_sql.replace("<WHERE_TWO>", where_two);
     list_db_sql = list_db_sql.replace("<ORDERBY>", orderby);
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  
  //pageFormater.writeHelper(out, "Works Maintenance","helpers_no1.gif");
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
	System.out.println("**********************************");
	System.out.println(list_db_sql);
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
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.Work"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
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
  Statement        stmt         = db_ausstage.m_conn.createStatement ();
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
  String selected_db_sql;
  String list_db_sql;
  String list_db_field_id_name;
  Work work;

  String  selected_list_name;
  String  selected_list_db_sql;
  String  selected_list_db_field_id_name;
  Vector  selected_list_db_display_fields = new Vector ();

  String filter_id, filter_work_title, filter_first_name, filter_last_name, filter_org_name;
  String filter_box_selected;

  Hashtable hidden_fields = new Hashtable();
  Item item = (Item)session.getAttribute("item");
  
  String comeFromItemAddeditPage         = request.getParameter("f_from_item_add_edit_page");
  if(comeFromItemAddeditPage != null && comeFromItemAddeditPage.equals("true"))
    item.setItemAttributes(request); 
  work = new Work(db_ausstage);
  
  
  String f_select_this_work_id    = request.getParameter("f_select_this_work_id");
  String f_unselect_this_work_id = request.getParameter("f_unselect_this_work_id");

  Vector itemWorkLinks = item.getAssociatedWorks();
  
  if (f_select_this_work_id != null)
  {
    itemWorkLinks.add(f_select_this_work_id);
    item.setItemWorkLinks(itemWorkLinks);        
    
  }
  //remove work from the item
  if (f_unselect_this_work_id != null)
  {
    itemWorkLinks.remove(f_unselect_this_work_id);
    item.setItemWorkLinks(itemWorkLinks);   
  }

  session.setAttribute("item", item);
  
  
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_workid");
  filter_work_title         = request.getParameter ("f_work_title");
    filter_first_name = request.getParameter ("f_first_name");
  filter_last_name = request.getParameter ("f_last_name");
  filter_org_name = request.getParameter ("f_org_name");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Title");
  filter_display_names.addElement ("Creator First Name");
  filter_display_names.addElement ("Creator Last Name");
  filter_display_names.addElement ("Organisation name");
                
  order_display_names.addElement ("Title");
  order_names.addElement ("WORK_TITLE");
             
  filter_names.addElement ("f_workid");
  filter_names.addElement ("f_work_title");
    filter_names.addElement ("f_first_name");
  filter_names.addElement ("f_last_name");
  filter_names.addElement ("f_org_name");

  list_name             = "f_select_this_work_id";
  list_db_field_id_name = "WORKID";
  //textarea_db_display_fields.addElement ("WORKID");
  //textarea_db_display_fields.addElement ("WORK_TITLE");
  textarea_db_display_fields.addElement ("output");

  selected_list_name             = "f_unselect_this_work_id";
  selected_list_db_field_id_name = "WORKID";
  selected_list_db_display_fields.addElement ("WORK_TITLE");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='item_work.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='work_addedit.jsp?action=ForItem';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='work_addedit.jsp?action=ForItem';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp#item_work_link';search_form.submit();");
  
  selected_db_sql       = "";
  Vector selectedWorks = new Vector();
  Vector temp_vector    = new Vector();
  String temp_string    = "";       
  selectedWorks = item.getAssociatedWorks();

  //because the vector that gets returned contains only linked
  //event ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a event id and the event name.
  //i.e. "4455, Luke Sullivan".

  //for each event id get name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedWorks.size(); i ++){
  
    if (i > 0) selected_db_sql += ", ";
    temp_string = work.getWorkInfoForDisplay(Integer.parseInt((String)selectedWorks.get(i)), stmt);
    temp_vector.add(selectedWorks.get(i));//add the id to the temp vector.
    temp_vector.add(temp_string);//add the event name to the temp_vector.
    selected_db_sql   += selectedWorks.get(i);
  }
  selectedWorks = temp_vector;
  stmt.close();



    
     if (filter_id== null)
  {
     list_db_sql = "SELECT work.workid, work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ') contribname, " +
     "concat_ws(', ',work.work_title, group_concat(concat_ws(' ', contributor.first_name, contributor.last_name) separator ', ')) as output "+
			"FROM work  " +
			"LEFT JOIN workconlink ON work.workid = workconlink.workid " +
			"LEFT JOIN contributor ON workconlink.contributorid = contributor.contributorid " +
			"LEFT JOIN workorglink ON work.workid = workorglink.workid "+
			"LEFT JOIN organisation ON workorglink.organisationid = organisation.organisationid "+
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
			"LEFT JOIN workorglink ON work.workid = workorglink.workid "+
			"LEFT JOIN organisation ON workorglink.organisationid = organisation.organisationid "+
			"WHERE ";

    // Add the filters to the SQL
    if ( !filter_id.equals (""))
      list_db_sql += " work.workid=" + filter_id + " and ";
    
    if ( !filter_first_name.equals ("")) {
      list_db_sql += " LOWER(contributor.first_name) like '%" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_last_name.equals ("")) {
      list_db_sql += " LOWER(contributor.last_name) like '%" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_org_name.equals ("")) {
      list_db_sql += " LOWER(organisation.name) like '%" + db_ausstage.plSqlSafeString(filter_org_name.toLowerCase()) + "%' AND ";
    } 
    
    if ( !filter_work_title.equals ("")) {
      list_db_sql += " ( LOWER(work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ";
      list_db_sql += " OR LOWER(alter_work_title) like '%" + db_ausstage.plSqlSafeString(filter_work_title.toLowerCase()) + "%' ) ";
    } else {
      list_db_sql += " 1=1 ";
    } 
    list_db_sql += "group by work.workid order by LOWER(" + request.getParameter ("f_order_by") + ")";
  }
  
  
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Work",
                  "Selected Work", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedWorks, selected_list_db_field_id_name,
                  buttons_names, buttons_actions,
                  hidden_fields, false, MAX_RESULTS_RETURNED));
                  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
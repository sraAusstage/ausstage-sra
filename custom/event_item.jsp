<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Item, ausstage.ItemItemLink, ausstage.Event"%>
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
  String filter_id;
  String filter_type; 
  String filter_title;
  String filter_contributor;
  String filter_organisation;
  String filter_source_title;
  String filter_day;
  String filter_month;
  String filter_year;
  String filter_cat_id;
  String filter_institution;  
  String list_name;
  String selected_db_sql;
  String list_db_sql;
  String list_db_field_id_name;

  String  selected_list_name;
  String  selected_list_db_sql;
  String  selected_list_db_field_id_name;
  Vector  selected_list_db_display_fields = new Vector ();

  String filter_box_selected;

  Hashtable hidden_fields = new Hashtable();
  
  // get the EVENT object from session
  ausstage.Event eventObj = new ausstage.Event(db_ausstage);
  eventObj = (ausstage.Event) session.getAttribute("eventObj");
  if (request.getParameter("fromEventPage") != null) {
    eventObj.setEventAttributes(request);
  }
  

  // reset/set the state of the EVENT object
  session.setAttribute("eventObj",eventObj);
  
  
  String f_select_this_item_id   = request.getParameter("f_select_this_item_id");
  String f_unselect_this_item_id = request.getParameter("f_unselect_this_item_id");

  Vector evItemLinks = eventObj.getResEvLinks();
  
  if (f_select_this_item_id != null) {
    evItemLinks.add(f_select_this_item_id);
    eventObj.setResEvLinks(evItemLinks);
    
  }
  //remove item from the event
  if (f_unselect_this_item_id != null) {
    for(int i=0; i < evItemLinks.size(); i++) {
      if ((evItemLinks.elementAt(i)+"").equals(f_unselect_this_item_id)) {
        evItemLinks.remove(i);
      }
    }
    eventObj.setResEvLinks(evItemLinks);   
  }

  session.setAttribute("eventObj", eventObj);
  

  
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box
  filter_id           = request.getParameter ("f_id");
  filter_cat_id       = request.getParameter ("f_search_cat_id");
  filter_institution  = request.getParameter ("f_search_institution_item_item");// was picking up institution from previous page, hence the strange name
  filter_type         = request.getParameter ("f_search_type");
  filter_title        = request.getParameter ("f_search_title");
  filter_contributor  = request.getParameter ("f_search_contributor");
  filter_organisation = request.getParameter ("f_search_organisation");
  filter_source_title = request.getParameter ("f_search_source_title");
  filter_day          = request.getParameter ("f_search_day");
  filter_month        = request.getParameter ("f_search_month");
  filter_year         = request.getParameter ("f_search_year");
  filter_institution  = request.getParameter ("f_search_institution");
  
  // Search Fields
  filter_display_names.addElement ("Resource ID");
  filter_display_names.addElement ("Sub Type");
  filter_display_names.addElement ("Title");
  filter_display_names.addElement ("Creator Contributor");
  filter_display_names.addElement ("Creator Organisation");
  filter_display_names.addElement ("Source Title");
  filter_display_names.addElement ("Date Day");
  filter_display_names.addElement ("Date Month");
  filter_display_names.addElement ("Date Year");
  filter_display_names.addElement ("Cat ID");
  filter_display_names.addElement ("Institution");
  
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_search_type");
  filter_names.addElement ("f_search_title");
  filter_names.addElement ("f_search_contributor");
  filter_names.addElement ("f_search_organisation");
  filter_names.addElement ("f_search_source_title");
  filter_names.addElement ("f_search_day");
  filter_names.addElement ("f_search_month");
  filter_names.addElement ("f_search_year");
  filter_names.addElement ("f_search_cat_id");
  filter_names.addElement ("f_search_institution");// was picking up institution from previous page, hence the strange name

  order_display_names.addElement ("Citation");
  order_names.addElement ("Citation");
             
  list_name             = "f_select_this_item_id";
  list_db_field_id_name = "itemid";
  textarea_db_display_fields.addElement ("CITATION");

  selected_list_name             = "f_unselect_this_item_id";
  selected_list_db_field_id_name = "itemid";
  selected_list_db_display_fields.addElement ("CITATION");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Preview");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_item.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp?action=preview';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp#event_resource_link';search_form.submit();");

  selected_db_sql       = "";
  Vector selectedItems = new Vector();
  Vector temp_vector    = new Vector();
  String temp_string    = "";
  selectedItems = eventObj.getResEvLinks();
  selected_db_sql       = "";
 
  for(int i = 0; i < selectedItems.size(); i ++){
    int itemId = Integer.parseInt((selectedItems.elementAt(i)+""));
    Item tempItem = new Item(db_ausstage);
    temp_string = tempItem.getItemInfoForItemDisplay(itemId, stmt);
    temp_vector.add(itemId+"");//add the id to the temp vector.
    temp_vector.add(temp_string);//add the item name to the temp_vector.
    if (i > 0) selected_db_sql += ", ";
    selected_db_sql += itemId;
  }
  selectedItems = temp_vector;
  stmt.close();
  
  
   // Build SQL based on search parameters
  list_db_sql = "SELECT item.itemid, citation " +
                "FROM ITEM item left join organisation orga on item.institutionid = orga.organisationid " +
                "Where 1=1 ";
  
  // if the user has performed a search

    
   if (filter_id != null) {
   
    
    if (!filter_institution.equals("")) {
      list_db_sql += " AND LOWER(orga.name) LIKE '%" + db_ausstage.plSqlSafeString(filter_institution).toLowerCase() + "%' ";
    }
    
    if (!filter_id.equals("")) {
      list_db_sql += " AND itemid=" + filter_id + " ";
    }
    
    if (!filter_type.equals("")) {
      list_db_sql += " AND exists (select * from lookup_codes where code_type = 'RESOURCE_SUB_TYPE' " +
                                   "AND LOWER(DESCRIPTION) LIKE '%" + filter_type.toLowerCase() + "%' and code_lov_id=item.item_sub_type_lov_id) ";
    }

    if (!filter_title.equals("")) {
      list_db_sql += " AND LOWER(item.title) LIKE '%" + db_ausstage.plSqlSafeString(filter_title).toLowerCase() + "%' ";
    }
    
    if (!filter_contributor.equals("")) {
      list_db_sql += " AND EXISTS (SELECT 'x' " +
                     "               FROM ITEMCONLINK itcl, CONTRIBUTOR cont " +
                     "              WHERE cont.contributorid = itcl.contributorid " +
                     "                AND itcl.itemid = item.itemid " +
                     "                AND LOWER(cont.last_name||' '||cont.first_name) LIKE '%" + db_ausstage.plSqlSafeString(filter_contributor).toLowerCase() + "%' " + 
                     "                AND itcl.CREATOR_FLAG='Y' )";
    }
    if (!filter_organisation.equals("")) {
      list_db_sql += " AND EXISTS (SELECT 'x' " +
                     "               FROM ITEMORGLINK itol, ORGANISATION orga " +
                     "              WHERE orga.organisationid = itol.organisationid " +
                     "                AND itol.itemid = item.itemid " +
                     "                AND LOWER(orga.name) LIKE '%" + db_ausstage.plSqlSafeString(filter_organisation).toLowerCase() + "%' " + 
                     "                AND itol.CREATOR_FLAG='Y' )";
    }
    
    if (!filter_source_title.equals("")) {
      list_db_sql += " AND EXISTS (SELECT 'x' " +
                     "               FROM ITEM source " +
                     "              WHERE source.itemid = item.sourceid " +
                     "                AND LOWER(source.title) LIKE '%" + db_ausstage.plSqlSafeString(filter_source_title).toLowerCase() + "%' )";
    }
                     
    if (!filter_day.equals ("")) {
      list_db_sql += "and (ddcreated_date like '%" +
                          db_ausstage.plSqlSafeString(filter_day) + "%' " +
                          "OR ddissued_date like '%" +
                          db_ausstage.plSqlSafeString(filter_day) + "%' " +
                          "OR ddcopyright_date like '%" +
                          db_ausstage.plSqlSafeString(filter_day) + "%') ";
    }
   
    if (!filter_month.equals ("")) {
      list_db_sql += "and (mmcreated_date like '%" +
                          db_ausstage.plSqlSafeString(filter_month) + "%' " +
                          "OR mmissued_date like '%" +
                          db_ausstage.plSqlSafeString(filter_month) + "%' " +
                          "OR mmcopyright_date like '%" +
                          db_ausstage.plSqlSafeString(filter_month) + "%') ";
    }
    
    if (!filter_year.equals ("")) {
      list_db_sql += "and (yyyycreated_date like '%" +
                          db_ausstage.plSqlSafeString(filter_year) + "%' " +
                          "OR yyyyissued_date like '%" +
                          db_ausstage.plSqlSafeString(filter_year) + "%' " +
                          "OR yyyycopyright_date like '%" +
                          db_ausstage.plSqlSafeString(filter_year) + "%') ";
    }
 }

  list_db_sql += "ORDER BY citation ";

   list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  // Output search page
  out.println (htmlGenerator.displaySearchFilterAndSelector (request,"Select Resource",
  					"Selected Resources", 
                                        filter_display_names,
                                        filter_names,
                                        order_display_names,
                                        order_names,
                                        list_name,
                                        list_db_sql,
                                        list_db_field_id_name,
                                        textarea_db_display_fields,
                                        selected_list_name,
                                        selectedItems, 
                                        selected_list_db_field_id_name,
                                        buttons_names,
                                        buttons_actions,
                                        hidden_fields,
                                        false, 
                                        MAX_RESULTS_RETURNED
                                        ));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />
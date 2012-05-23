<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*, java.sql.*"%>
<%@ page import = "ausstage.Event"%>
<%@ include file="../../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  
  String        sqlString;
  CachedRowSet  rset;
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
  String filter_id;
  String filter_institution;
  String filter_type; 
  String filter_title;
  String filter_contributor;
  String filter_organisation;
  String filter_day;
  String filter_month;
  String filter_year;

  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box
  filter_id           = request.getParameter ("f_id");
  filter_institution  = request.getParameter ("f_institution");
  filter_type         = request.getParameter ("f_type");
  filter_title        = request.getParameter ("f_title");
  filter_contributor  = request.getParameter ("f_contributor");
  filter_organisation = request.getParameter ("f_organisation");
  filter_day          = request.getParameter ("f_day");
  filter_month        = request.getParameter ("f_month");
  filter_year         = request.getParameter ("f_year");
  

  // Search Fields
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Institution");
  filter_display_names.addElement ("Resource Title");
  filter_display_names.addElement ("Creator Contributor Name");
  filter_display_names.addElement ("Creator Organisation Name");  
  filter_display_names.addElement ("Date Day");
  filter_display_names.addElement ("Date Month");
  filter_display_names.addElement ("Date Year");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_institution");
  filter_names.addElement ("f_title");
  filter_names.addElement ("f_contributor");
  filter_names.addElement ("f_organisation");
  filter_names.addElement ("f_day");
  filter_names.addElement ("f_month");
  filter_names.addElement ("f_year");


  // Search Results
  list_name              = "f_itemid";
  list_db_field_id_name  = "itemid";
  textarea_db_display_fields.addElement ("citation");
  
  
  // Add Buttons
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Copy");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='item_addedit.jsp'");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp?mode=copy';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_del_confirm.jsp';search_form.submit();");


  // Build SQL based on search parameters
  list_db_sql = "SELECT    item.itemid, item_description citation " +
                "     FROM ITEM item, ORGANISATION orga " +
                "    WHERE item.institutionid = orga.organisationid ";
  
  // if the user has performed a search
  if (filter_id != null) {
    if (!filter_id.equals(""))
      list_db_sql += " AND itemid = " + filter_id + " ";
    if (!filter_institution.equals(""))
      list_db_sql += " AND LOWER(orga.name) LIKE '%" + db_ausstage.plSqlSafeString(filter_institution).toLowerCase() + "%' ";
    if (!filter_type.equals(""))
      list_db_sql += " AND item.item_type_lov_id = " + filter_type + " ";
    if (!filter_title.equals(""))
      list_db_sql += " AND LOWER(item.title) LIKE '%" + db_ausstage.plSqlSafeString(filter_title).toLowerCase() + "%' ";
    if (!filter_contributor.equals(""))
      list_db_sql += " AND EXISTS (SELECT 'x' " +
                     "               FROM ITEMCONLINK itcl, CONTRIBUTOR cont " +
                     "              WHERE cont.contributorid = itcl.contributorid " +
                     "                AND itcl.itemid = item.itemid " +
                     "                AND LOWER(cont.last_name||' '||cont.first_name) LIKE '%" + db_ausstage.plSqlSafeString(filter_contributor).toLowerCase() + "%' ";
    if (!filter_organisation.equals(""))
      list_db_sql += " AND EXISTS (SELECT 'x' " +
                     "               FROM ITEMORGLINK itol, CONTRIBUTOR cont " +
                     "              WHERE cont.contributorid = itcl.contributorid " +
                     "                AND itol.itemid = item.itemid " +
                     "                AND LOWER(cont.last_name||' '||cont.first_name) LIKE '%" + db_ausstage.plSqlSafeString(filter_organisation).toLowerCase() + "%' ";
    if (!filter_day.equals (""))
      list_db_sql += " AND (TO_CHAR(item.ddcreated_date,'DD') = " + db_ausstage.plSqlSafeString(filter_day) + " " +
                     "  OR  TO_CHAR(item.ddissued_date,'DD') = " + db_ausstage.plSqlSafeString(filter_day) + " " + 
                     "  OR  TO_CHAR(item.mmcopyright_date,'DD') = " + db_ausstage.plSqlSafeString(filter_day) + ") ";
    if (!filter_month.equals (""))
      list_db_sql += " AND (TO_CHAR(item.ddcreated_date,'MM') = " + db_ausstage.plSqlSafeString(filter_day) + " " +
                     "  OR  TO_CHAR(item.ddissued_date,'MM') = " + db_ausstage.plSqlSafeString(filter_day) + " " + 
                     "  OR  TO_CHAR(item.mmcopyright_date,'MM') = " + db_ausstage.plSqlSafeString(filter_day) + ") ";
    if (!filter_year.equals (""))
      list_db_sql += " AND (TO_CHAR(item.ddcreated_date,'YYYY') = " + db_ausstage.plSqlSafeString(filter_day) + " " +
                     "  OR  TO_CHAR(item.ddissued_date,'YYYY') = " + db_ausstage.plSqlSafeString(filter_day) + " " + 
                     "  OR  TO_CHAR(item.mmcopyright_date,'YYYYD') = " + db_ausstage.plSqlSafeString(filter_day) + ") ";
  }

  list_db_sql += "ORDER BY 2 ";
  
  
  // Add a combo box for the resource sub type search field
  String resourceSubTypeSql   = "";
  String comboHtml = "";
  ResultSet l_rs = null;
  Statement p_stmt = db_ausstage.m_conn.createStatement();
  resourceSubTypeSql = "SELECT   code_lov_id, description " +
                       "    FROM LOOKUP_CODES looc " +
                       "   WHERE code_type = 'RESOURCE_SUB_TYPE' " + 
                       "ORDER BY sequence_no ";
  l_rs = db_ausstage.runSQLResultSet(resourceSubTypeSql, p_stmt);
  comboHtml += "<br>Resource Sub Type <select name='f_type' id='f_type'>";
  comboHtml += "<option value=''></option>";
  while (l_rs.next()) {
    comboHtml += "<option value='" + l_rs.getString("code_lov_id") + "'>" + l_rs.getString("description") + "</option>";
  }
  comboHtml += "</select>";
  

  // Output search page
  out.println (htmlGenerator.displaySearchFilter (request, "Select Resource",
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
                                        25,
                                        comboHtml));
                                        
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

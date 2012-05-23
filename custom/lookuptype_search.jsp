<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

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
  String filter_id, filter_code_type;

  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id     = request.getParameter ("f_id");
  filter_code_type   = request.getParameter ("f_code_type");
 
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("CodeType");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_code_type");


  order_display_names.addElement ("Name");
  order_display_names.addElement ("Code Type");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("code_type");

  list_name              = "f_lookuptype_id";
  list_db_field_id_name  = "id";
  textarea_db_display_fields.addElement ("code_type");

  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Delete");
  
  buttons_actions.addElement ("Javascript:location.href='lookuptype_addedit.jsp'");
  buttons_actions.addElement ("Javascript:search_form.action='lookuptype_addedit.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='lookuptype_del_confirm.jsp';search_form.submit();");

  
  //pageFormater.writeHelper(out, "Lookups","helpers_no1.gif");   
  // if first time this form has been loaded
  if (filter_code_type == null)
  {
    list_db_sql = "select id,code_type from lookup_types order by code_type";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "select id, code_type from lookup_types WHERE 1=1 ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and id=" + filter_id + " ";
    if (!filter_code_type.equals (""))
      list_db_sql += "and LOWER(code_type) like '%" + db_ausstage.plSqlSafeString(filter_code_type.toLowerCase()) + "%' ";
    list_db_sql += "order by " + request.getParameter ("f_order_by");
  }

  out.println (htmlGenerator.displaySearchFilter (request, "Select Lookup Type",
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
                                        100));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="../custom/ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
    
  String        sqlString;
  CachedRowSet  rset;

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
  String filter_id, filter_primary_ind;

  // Theses are the parameters that get posted by the page (i.e the user
  // has performed a search and theses are their inputs)
  filter_id            = request.getParameter ("f_id");
  filter_primary_ind  = request.getParameter ("f_primary_content_ind_id");

  // Setup the html filter search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Content Indicator");
  filter_names.addElement         ("f_id");
  filter_names.addElement         ("f_primary_content_ind_id");

  list_name              = "f_primary_cont_ind_id";
  list_db_field_id_name  = "CONTENTINDICATORID";
  textarea_db_display_fields.addElement ("CONTENTINDICATOR");

  buttons_names.addElement   ("Add");  
  buttons_names.addElement   ("Edit/View");
  buttons_names.addElement   ("Delete");
  buttons_actions.addElement ("Javascript:location.href='primary_content_ind_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='primary_content_ind_addedit.jsp?act=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='primary_content_ind_del_confirm.jsp';search_form.submit();");

  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "select CONTENTINDICATORID, CONTENTINDICATOR from CONTENTINDICATOR " +
                  "order by CONTENTINDICATOR";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "select CONTENTINDICATORID, CONTENTINDICATOR from CONTENTINDICATOR ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "where CONTENTINDICATORID='" + filter_id + "' ";
    if (!filter_primary_ind.equals (""))
      if (!filter_id.equals (""))
        list_db_sql += "and LOWER(CONTENTINDICATOR) like '%" + filter_primary_ind.toLowerCase() + "%' ";
      else
        list_db_sql += "where LOWER(CONTENTINDICATOR) like '%" + filter_primary_ind.toLowerCase() + "%' ";

    list_db_sql += "order by CONTENTINDICATOR";
    
  }
//pageFormater.writeHelper(out, "Content Indicator Maintenance","helpers_no1.gif");
  out.println (htmlGenerator.displaySearchFilter (request, "Select Subjects",
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
                                        1000));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />
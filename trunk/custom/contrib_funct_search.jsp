<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
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
  String filter_id, filter_contrib_funct;

  // Theses are the parameters that get posted by the page (i.e the user
  // has performed a search and theses are their inputs)
  filter_id            = request.getParameter ("f_id");
  filter_contrib_funct = request.getParameter ("f_contfunct");

  // Setup the html filter search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Contributor Function");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_contfunct");

  list_name              = "f_selected_contfunct_id";
  list_db_field_id_name  = "contfunctionid";
  //textarea_db_display_fields.addElement ("CONTFUNCTION");
  //textarea_db_display_fields.addElement ("PREFERREDTERM");
  textarea_db_display_fields.addElement ("OUTPUT");

  buttons_names.addElement ("Add");  
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='contrib_funct_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_funct_addedit.jsp?act=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_funct_del_confirm.jsp';search_form.submit();");
    
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT contributorfunctpreferred.preferredterm, contfunct.contfunction, contfunct.contfunctionid, concat_ws(', ',contributorfunctpreferred.preferredterm,contfunct.contfunction)as OUTPUT "+ 
    "FROM contfunct LEFT JOIN contributorfunctpreferred ON (contfunct.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid) order by CONTFUNCTION";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "SELECT contributorfunctpreferred.preferredterm, contfunct.contfunction, contfunct.contfunctionid, concat_ws(', ',contributorfunctpreferred.preferredterm,contfunct.contfunction)as OUTPUT "+ 
    "FROM contfunct LEFT JOIN contributorfunctpreferred ON (contfunct.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid) Where 1=1 ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and CONTFUNCTIONID=" + filter_id + " ";
    if (!filter_contrib_funct.equals (""))
      list_db_sql += "and LOWER(CONTFUNCTION) like '%" + filter_contrib_funct.toLowerCase() + "%' ";

    list_db_sql += "order by CONTFUNCTION";
  }
//pageFormater.writeHelper(out, "Contributor Function Maintenance","helpers_no1.gif");
  out.println (htmlGenerator.displaySearchFilter (request, "Select Contributor Function",
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
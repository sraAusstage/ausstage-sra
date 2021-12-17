<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%><jsp:include page="../templates/admin-header.jsp" />
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
  String filter_id, filter_secgen_class;

  // Theses are the parameters that get posted by the page (i.e the user
  // has performed a search and theses are their inputs)
  filter_id            = request.getParameter ("f_id");
  filter_secgen_class  = request.getParameter ("f_secgenclass");

  // Setup the html filter search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Secondary Genre");
  filter_names.addElement         ("f_id");
  filter_names.addElement         ("f_secgenclass");

  list_name              = "f_selected_second_genre_id";
  list_db_field_id_name  = "GENRECLASSID";
  textarea_db_display_fields.addElement ("Output");
  //textarea_db_display_fields.addElement ("PREFERREDTERM");
  
  if (session.getAttribute("permissions").toString().contains("Secondary Genre Editor") || session.getAttribute("permissions").toString().contains("Administrators")) {
  buttons_names.addElement   ("Add");  
  buttons_names.addElement   ("Edit/View");
  buttons_names.addElement   ("Delete");
  buttons_actions.addElement ("Javascript:location.href='second_genre_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='second_genre_addedit.jsp?act=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='second_genre_del_confirm.jsp';search_form.submit();");
  }
  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "select GENRECLASSID, concat_ws(', ',PREFERREDTERM, GENRECLASS) as Output from SECGENREPREFERRED, " +
                  "SECGENRECLASS where SECGENREPREFERRED.SECGENREPREFERREDID=" +
                  "SECGENRECLASS.SECGENREPREFERREDID order by GENRECLASS";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
    list_db_sql = "select GENRECLASSID, concat_ws(', ',PREFERREDTERM, GENRECLASS) as Output from SECGENREPREFERRED, " +
                  "SECGENRECLASS where SECGENREPREFERRED.SECGENREPREFERREDID=" +
                  "SECGENRECLASS.SECGENREPREFERREDID ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and GENRECLASSID=" + filter_id + " ";				// this is none preferred search!!!
       //list_db_sql += "and SECGENREPREFERRED.SECGENREPREFERREDID=" + filter_id + " "; // this is preferred search!!!!
    if (!filter_secgen_class.equals (""))
      list_db_sql += "and LOWER(GENRECLASS) like '%" + filter_secgen_class.toLowerCase() + "%' ";

    list_db_sql += "order by GENRECLASS";
  }
//pageFormater.writeHelper(out, "Secondary Genre Maintenance","helpers_no1.gif");
  out.println (htmlGenerator.displaySearchFilter (request, "Select Secondary Genre",
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
<jsp:include page="../templates/admin-footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.SecondaryGenre"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
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

  String  selected_list_name;
  String  selected_list_db_sql;
  String  selected_list_db_field_id_name;
  Vector  selected_list_db_display_fields = new Vector ();

  String filter_id;
  String filter_desc;
  String filter_box_selected;

  Hashtable hidden_fields = new Hashtable();

  Event eventObj = (Event)session.getAttribute("eventObj");
  
  boolean fromEventPage = true;
  if (request.getParameter("fromEventPage") == null)
    fromEventPage = false;
    
  String f_eventid = request.getParameter("f_eventid");
  int    eventId   = Integer.parseInt(f_eventid);
  hidden_fields.put("f_eventid", f_eventid);

  String f_select_this_sec_genre_id    = request.getParameter("f_select_this_sec_genre_id");
  String f_unselect_this_sect_genre_id = request.getParameter("f_unselect_this_sect_genre_id");

  SecGenreEvLink secGenreEvLink = null;
  Vector secGenreEvLinks = eventObj.getSecGenreEvLinks();

  if (f_select_this_sec_genre_id != null)
  {
    secGenreEvLink = new SecGenreEvLink(db_ausstage);
    secGenreEvLink.load(f_select_this_sec_genre_id, f_eventid);
    secGenreEvLinks.add(secGenreEvLink);
  }

  if (f_unselect_this_sect_genre_id != null)
  {
    SecGenreEvLink savedEvLink = null;
    secGenreEvLink = new SecGenreEvLink(db_ausstage);
    secGenreEvLink.load(f_unselect_this_sect_genre_id, Integer.toString(eventId));

    // Can't use the remove() method as the beans won't be exactly the same (due to the database connection)
    for (int i=0; i < secGenreEvLinks.size(); i++)
    {
      savedEvLink = (SecGenreEvLink)secGenreEvLinks.get(i);
      if (savedEvLink.equals(secGenreEvLink))
      {
        secGenreEvLinks.remove(i);
        break;
      }
    }
  }

  if (fromEventPage)
  {
    eventObj.setEventAttributes(request);
  }
  eventObj.setSecGenreEvLinks(secGenreEvLinks);
  session.setAttribute("eventObj", eventObj);

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_sec_genre_id");
  filter_desc         = request.getParameter ("f_genre_class");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Class");
  filter_names.addElement ("f_sec_genre_id");
  filter_names.addElement ("f_genre_class");

  list_name             = "f_select_this_sec_genre_id";
  list_db_field_id_name = "SECGENREPREFERREDID";
  textarea_db_display_fields.addElement ("Output");
  //textarea_db_display_fields.addElement ("PREFERREDTERM");

  selected_list_name             = "f_unselect_this_sect_genre_id";
  selected_list_db_field_id_name = "SECGENREPREFERREDID";
  selected_list_db_display_fields.addElement ("PREFERREDTERM");
 

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Preview");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_second_genre_link.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_second_genre_link_preview.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp#event_second_genre_link';search_form.submit();");

  selected_db_sql = "";
  Vector selectedSecGenres       = new Vector();
  String genreclassPrefId        = "";
  String genreclassPrefName      = "";
  String genreclassDispName      = "";
  SecondaryGenre secondaryGenre  = null;

  for (int i=0; i < secGenreEvLinks.size(); i++)
  {
    if (i > 0) selected_db_sql += ", ";

    secGenreEvLink     = (SecGenreEvLink)secGenreEvLinks.get(i);
    secondaryGenre     = secGenreEvLink.getSecondaryGenre();
    genreclassPrefId   = secGenreEvLink.getSecGenrePreferredId();
    genreclassPrefName = secondaryGenre.getName();
    selected_db_sql   += genreclassPrefId;
    genreclassDispName = secondaryGenre.getGenreInfoForItemDisplay(Integer.parseInt(genreclassPrefId), stmt);
    selectedSecGenres.add(genreclassPrefId);
    selectedSecGenres.add(genreclassDispName);
  }
  
  list_db_sql = "SELECT SECGENREPREFERRED.SECGENREPREFERREDID, " +
                "concat_ws(', ', SECGENRECLASS.GENRECLASS, SECGENREPREFERRED.PREFERREDTERM ) Output " +
                "FROM SECGENRECLASS, SECGENREPREFERRED ";
                
  if (selected_db_sql.length() == 0)
    list_db_sql += "WHERE SECGENREPREFERRED.SECGENREPREFERREDID NOT IN (-1) " +
                   "and SECGENREPREFERRED.SECGENREPREFERREDID=" +
                   "SECGENRECLASS.SECGENREPREFERREDID ";
  else
    list_db_sql += "WHERE SECGENREPREFERRED.SECGENREPREFERREDID NOT IN (" + selected_db_sql + ") " +
                   "and SECGENREPREFERRED.SECGENREPREFERREDID=" +
                   "SECGENRECLASS.SECGENREPREFERREDID ";

  // if not first time this form has been loaded - ie, Search
  if (filter_id != null && !filter_id.equals (""))
    list_db_sql += "AND SECGENRECLASS.GENRECLASSID =" + filter_id;

  if (filter_desc != null && !filter_desc.equals (""))
      list_db_sql += "AND LOWER(SECGENRECLASS.GENRECLASS) LIKE '" + filter_desc.toLowerCase() + "%'";

  list_db_sql += "ORDER BY SECGENRECLASS.GENRECLASS";

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Secondary Genre",
                  "Selected Secondary Genre", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedSecGenres, selected_list_db_field_id_name,
                  buttons_names, buttons_actions,
                  hidden_fields, false, 10000));
                  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />
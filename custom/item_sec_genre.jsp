<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.SecondaryGenre"%>
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
  SecondaryGenre genre;

  String  selected_list_name;
  String  selected_list_db_sql;
  String  selected_list_db_field_id_name;
  Vector  selected_list_db_display_fields = new Vector ();

  String filter_id;
  String filter_desc;
  String filter_box_selected;

  Hashtable hidden_fields = new Hashtable();
  Item item = (Item)session.getAttribute("item");
  
  String comeFromItemAddeditPage         = request.getParameter("f_from_item_add_edit_page");
  if(comeFromItemAddeditPage != null && comeFromItemAddeditPage.equals("true"))
    item.setItemAttributes(request); 
  genre = new SecondaryGenre(db_ausstage);
  
  
  String f_select_this_sec_genre_id    = request.getParameter("f_select_this_sec_genre_id");
  String f_unselect_this_sect_genre_id = request.getParameter("f_unselect_this_sec_genre_id");

  Vector secGenreItemLinks = item.getAssociatedSecGenres();
  
  if (f_select_this_sec_genre_id != null)
  {
    secGenreItemLinks.add(f_select_this_sec_genre_id);
    item.setItemSecGenreLinks(secGenreItemLinks);        
    
  }
  //remove genre from the item
  if (f_unselect_this_sect_genre_id != null)
  {
    secGenreItemLinks.remove(f_unselect_this_sect_genre_id);
    item.setItemSecGenreLinks(secGenreItemLinks);   
  }

  session.setAttribute("item", item);
  
  
  
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
 // textarea_db_display_fields.addElement ("PREFERREDTERM");

  selected_list_name             = "f_unselect_this_sec_genre_id";
  selected_list_db_field_id_name = "SECGENREPREFERREDID";
  selected_list_db_display_fields.addElement ("PREFERREDTERM");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Preview");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='item_sec_genre.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_second_genre_link_preview.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='item_addedit.jsp#item_second_genre_link';search_form.submit();");

  selected_db_sql       = "";
  Vector selectedGenre = new Vector();
  Vector temp_vector    = new Vector();
  String temp_string    = "";       
  selectedGenre = item.getAssociatedSecGenres();

  //because the vector that gets returned contains only linked
  //event ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a event id and the event name.
  //i.e. "4455, Luke Sullivan".

  //for each event id get name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedGenre.size(); i ++){
  
    if (i > 0) selected_db_sql += ", ";
    temp_string = genre.getGenreInfoForItemDisplay(Integer.parseInt((String)selectedGenre.get(i)), stmt);
    temp_vector.add(selectedGenre.get(i));//add the id to the temp vector.
    temp_vector.add(temp_string);//add the event name to the temp_vector.
    selected_db_sql   += selectedGenre.get(i);
  }
  selectedGenre = temp_vector;
  stmt.close();
  
  
  list_db_sql = "SELECT SECGENRECLASS.SECGENREPREFERREDID, " +
                "concat_ws(', ', SECGENRECLASS.GENRECLASS, SECGENREPREFERRED.PREFERREDTERM ) Output " +
                "FROM SECGENRECLASS, SECGENREPREFERRED " ;
                //"WHERE SECGENRECLASS.SECGENREPREFERREDID = SECGENREPREFERRED.SECGENREPREFERREDID ";
          
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
    list_db_sql += " AND SECGENREPREFERRED.SECGENREPREFERREDID=" + filter_id;

  if (filter_desc != null && !filter_desc.equals (""))
      list_db_sql += " AND LOWER(SECGENRECLASS.GENRECLASS) LIKE '%" + filter_desc.toLowerCase() + "%'";

  list_db_sql += " ORDER BY UPPER(SECGENRECLASS.GENRECLASS), UPPER(SECGENREPREFERRED.PREFERREDTERM)";
  
  
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Genre",
                  "Selected Genre", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedGenre, selected_list_db_field_id_name,
                  buttons_names, buttons_actions,
                  hidden_fields, false, MAX_RESULTS_RETURNED));
                  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<cms:include property="template" element="foot" />
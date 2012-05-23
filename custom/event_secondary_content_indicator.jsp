<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.SecContentIndicatorEvLink"%>
<%@ page import = "ausstage.SecondaryContentInd"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
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

  String f_select_this_content_indicator_preferred_id = request.getParameter("f_select_this_content_indicator_preferred_id");
  String f_unselect_this_content_indicator_preferred_id = request.getParameter("f_unselect_this_content_indicator_preferred_id");

  SecContentIndicatorEvLink secContentIndicatorEvLink = null;
  Vector secContentIndicatorEvLinks = eventObj.getSecContentIndicatorEvLinks();

  Statement stmt = db_ausstage.m_conn.createStatement();
  if (f_select_this_content_indicator_preferred_id != null)
  {
    secContentIndicatorEvLink = new SecContentIndicatorEvLink(db_ausstage);
    secContentIndicatorEvLink.load(f_select_this_content_indicator_preferred_id, f_eventid);
    secContentIndicatorEvLinks.add(secContentIndicatorEvLink);
  }

  if (f_unselect_this_content_indicator_preferred_id != null)
  {
    SecContentIndicatorEvLink savedEvLink = null;
    for (int i=0; i < secContentIndicatorEvLinks.size(); i++)
    {
      savedEvLink = (SecContentIndicatorEvLink)secContentIndicatorEvLinks.get(i);
      if (savedEvLink.getSecContentIndPrefId().equals(f_unselect_this_content_indicator_preferred_id))
      {
        secContentIndicatorEvLinks.remove(i);
        i--;
      }
    }
  }
  eventObj.setSecContentIndicatorEvLinks(secContentIndicatorEvLinks);

  if (fromEventPage)
  {
    eventObj.setEventAttributes(request);
  }
  session.setAttribute("eventObj", eventObj);

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_content_indicator_id");
  filter_desc         = request.getParameter ("f_secondary_content_indicator");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Secondary Subjects");
  filter_names.addElement ("f_content_indicator_id");
  filter_names.addElement ("f_secondary_content_indicator");

  list_name             = "f_select_this_content_indicator_preferred_id";
  list_db_field_id_name = "SecContentIndicatorPreferredId";
  textarea_db_display_fields.addElement ("SecContentIndicator");
  textarea_db_display_fields.addElement ("PreferredTerm");

  selected_list_name             = "f_unselect_this_content_indicator_preferred_id";
  selected_list_db_field_id_name = "SecContentIndicatorPreferredId";
  selected_list_db_display_fields.addElement ("PreferredTerm");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_secondary_content_indicator.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_addedit.jsp#event_secondary_content_indicator';search_form.submit();");

  selected_db_sql = "";
  Vector selectedSecContentIndicators      = new Vector();
  String secContentIndPrefId               = "";
  String secContentIndPrefName             = "";
  
  for (int i=0; i < secContentIndicatorEvLinks.size(); i++)
  {
    if (i > 0) selected_db_sql += ", ";

    secContentIndicatorEvLink = (SecContentIndicatorEvLink)secContentIndicatorEvLinks.get(i);
    secContentIndPrefId       = secContentIndicatorEvLink.getSecContentIndPrefId();
    secContentIndPrefName     = secContentIndicatorEvLink.getSecContentIndPref();
    selected_db_sql += secContentIndPrefId;
    selectedSecContentIndicators.add(secContentIndPrefId);
    selectedSecContentIndicators.add(secContentIndPrefName);
  }

/***
  String secContentIndicatorId = "-1";
  for (int i=0; i < secContentIndicatorEvLinks.size(); i++)
  {
    if (i > 0) selected_db_sql += ", ";
    selected_db_sql += ((SecContentIndicatorEvLink)(secContentIndicatorEvLinks.get(i))).getSecContentIndPrefId();
  }

  selected_list_db_sql = " SELECT SecContentIndicatorPreferredId, PreferredTerm" +
                         " FROM   SecContentIndicatorPreferred";
  if (selected_db_sql.length() == 0)
    selected_list_db_sql += " WHERE SecContentIndicatorPreferredId IN (-1)";
  else
     selected_list_db_sql += " WHERE SecContentIndicatorPreferredId IN (" + selected_db_sql + ")";

  selected_list_db_sql += " ORDER BY PreferredTerm";
***/

  list_db_sql = " SELECT SecContentIndicator, SCI.SecContentIndicatorPreferredId, PreferredTerm" +
                " FROM   SecContentIndicator SCI, SecContentIndicatorPreferred SCIP" +
                " WHERE SCI.SecContentIndicatorPreferredId = SCIP.SecContentIndicatorPreferredId";
  if (selected_db_sql.length() == 0)
    list_db_sql += " AND SCI.SecContentIndicatorPreferredId NOT IN (-1)";
  else
    list_db_sql += " AND SCI.SecContentIndicatorPreferredId NOT IN (" + selected_db_sql + ")";

  // if not first time this form has been loaded - ie, Search
  if (filter_id != null && !filter_id.equals (""))
    list_db_sql += " AND SecContentIndicatorId =" + filter_id;

  if (filter_desc != null && !filter_desc.equals (""))
      list_db_sql += " AND LOWER(SecContentIndicator) LIKE '" + filter_desc.toLowerCase() + "%'";

  list_db_sql += " ORDER BY SecContentIndicator";

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Secondary Subjects",
                  "Selected Secondary Subjects", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedSecContentIndicators, selected_list_db_field_id_name,
                  buttons_names, buttons_actions,
                  hidden_fields, false, 1000));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />
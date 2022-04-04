<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.Work, ausstage.WorkOrganLink"%>
<%@ page import = "ausstage.Organisation"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  int              MAX_RESULTS_RETURNED = 1000;

  String        sqlString;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement        stmt         = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  Vector filter_display_names            = new Vector ();
  Vector filter_names                    = new Vector ();
  Vector order_display_names             = new Vector ();
  Vector order_names                     = new Vector ();
  Vector textarea_db_display_fields      = new Vector ();
  Vector buttons_names                   = new Vector ();
  Vector buttons_actions                 = new Vector ();
  String list_name                       = "";
  String selected_db_sql                 = "";
  String list_db_sql                     = "";
  String list_db_field_id_name           = "";
  String selected_list_name              = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();
  String comeFromWorkAddeditPage         = request.getParameter("f_from_work_add_edit_page");
  
  String isPreviewForItemWork  = request.getParameter("isPreviewForItemWork");
  String isPreviewForEventWork  = request.getParameter("isPreviewForEventWork");
  
  if (isPreviewForItemWork == null || isPreviewForItemWork.equals("null")) {
    isPreviewForItemWork = "";
  }
  if (isPreviewForEventWork == null || isPreviewForEventWork.equals("null")) {
    isPreviewForEventWork = "";
  }

  String filter_id;
  String filter_name;
  String filter_state;
  String filter_suburb;
  String filter_box_selected;

  String organisationName;
  String organisationId;
  Organisation organisation, org1;

  Hashtable hidden_fields = new Hashtable();
  Work work = (Work)session.getAttribute("work");
  //we don't want to loose any info added to the work_addedit.jsp form.
  //only set the work attributes if we have come from the addedit page.
  if(comeFromWorkAddeditPage != null && comeFromWorkAddeditPage.equals("true"))
    work.setWorkAttributes(request); 
  organisation = new Organisation(db_ausstage);
  boolean fromWorkPage = true;


  if (request.getParameter("fromWorkPage") == null)
    fromWorkPage = false;

  if (fromWorkPage) work.setWorkAttributes(request);

  String f_workid = work.getWorkId();
  int    workId   = Integer.parseInt(f_workid);
  hidden_fields.put("f_workid", f_workid);

  String f_select_this_organisation_id   = request.getParameter("f_select_this_organisation_id");
  String f_unselect_this_organisation_id = request.getParameter("f_unselect_this_organisation_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the organisations from the current work
  //object in the session.
  
  Vector orgWorkLinks ;
  
  orgWorkLinks = work.getAssociatedOrganisations();

  if (f_select_this_organisation_id != null)
  {
    
    //need to add the contributor id to the item.

    WorkOrganLink workOrganLink = new WorkOrganLink(db_ausstage);
    workOrganLink.setWorkId(work.getWorkId());
    workOrganLink.setOrganId(f_select_this_organisation_id);
    
    orgWorkLinks.add(workOrganLink);
    work.setWorkOrgLinks(orgWorkLinks);       
  }
  //remove contributor from the item
  if (f_unselect_this_organisation_id != null)
  { 
    //remove the contributor id from the item
    for(int i=0; i < orgWorkLinks.size(); i++) {
      WorkOrganLink workOrganLink = (WorkOrganLink)orgWorkLinks.elementAt(i);
      if (workOrganLink.getOrganId().equals(f_unselect_this_organisation_id)) {
        orgWorkLinks.remove(i);
      }
    }
    
    work.setWorkOrgLinks(orgWorkLinks); 
  }
/*
  //add the selected organisation to the work
  if (f_select_this_organisation_id != null)
  {
    orgWorkLinks.add(f_select_this_organisation_id);
    work.setWorkOrgLinks(orgWorkLinks);  
 
  }
  //remove organisation from the work
  if (f_unselect_this_organisation_id != null)
  {
    orgWorkLinks.remove(f_unselect_this_organisation_id);
    work.setWorkOrgLinks(orgWorkLinks);  
  }
*/
  session.setAttribute("work", work);

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_organisation_id");
  filter_name         = request.getParameter ("f_name");
  filter_state        = request.getParameter ("f_state");
  filter_suburb       = request.getParameter ("f_suburb");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
//  filter_display_names.addElement ("State");
//  filter_display_names.addElement ("Suburb");
  filter_names.addElement ("f_organisation_id");
  filter_names.addElement ("f_name");
  filter_names.addElement ("f_state");
  filter_names.addElement ("f_suburb");

  order_display_names.addElement ("Name");
  order_display_names.addElement ("State");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("name");
  order_names.addElement ("state");
  order_names.addElement ("suburb");

  list_name             = "f_select_this_organisation_id";
  list_db_field_id_name = "organisationId";
  //textarea_db_display_fields.addElement ("name");
 // textarea_db_display_fields.addElement ("state");
  textarea_db_display_fields.addElement ("OUTPUT");

  selected_list_name             = "f_unselect_this_organisation_id";
  selected_list_db_field_id_name = "organisationId";
  selected_list_db_display_fields.addElement ("name");
  selected_list_db_display_fields.addElement ("state");
  selected_list_db_display_fields.addElement ("suburb");

  buttons_names.addElement ("Select");
  if(!(isPreviewForItemWork.equals("true") || isPreviewForItemWork.equals("true") || isPreviewForEventWork.equals("true"))){
    buttons_names.addElement ("Edit/View");
    buttons_names.addElement ("Add");
  }
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='work_organisations.jsp';search_form.submit();");
  if(!(isPreviewForItemWork.equals("true") || isPreviewForItemWork.equals("true") || isPreviewForEventWork.equals("true"))){
    buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=EditForWork';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=AddForWork';search_form.submit();");
  }
  buttons_actions.addElement ("Javascript:search_form.action='work_organ_functions.jsp';search_form.submit();");
  selected_db_sql = "";
  Vector selectedOrganisations = new Vector();
  Vector temp_vector           = new Vector();
  String temp_string           = ""; 
  
  selectedOrganisations = work.getAssociatedOrganisations();

  //because the vector that gets returned contains only linked
  //organisation ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a organisation id and the organisation name.
  //i.e. "4455, Luke Sullivan".

  //for each organisation id get name and add the id and the name to a temp vector.
  for(int i = 0; i < selectedOrganisations.size(); i ++){
    if (i > 0) selected_db_sql += ", ";
    WorkOrganLink  workOrganLink = (WorkOrganLink)selectedOrganisations.get(i);
    int temp = new Integer(workOrganLink.getOrganId()).intValue();
    
    temp_string = organisation.getOrganisationInfoForOrganisationDisplay(temp, stmt);
    temp_vector.add(temp + "" );//add the id to the temp vector.
    temp_vector.add(temp_string);//add the contributor name to the temp_vector.
    selected_db_sql += temp;
  }
    
  selectedOrganisations = temp_vector;
  stmt.close();

  // if first time this form has been loaded
  if (filter_id == null)
  {
     list_db_sql =   "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
"FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
"LEFT JOIN events ON (orgevlink.eventid = events.eventid)  "+
"GROUP BY organisation.organisationid order by organisation.name ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   
	list_db_sql = "SELECT organisation.organisationid, organisation.name, "+
	"if (min(events.yyyyfirst_date) = max(events.yyyylast_date), "+
	"min(events . yyyyfirst_date), concat(min(events . yyyyfirst_date), ' - ', max(events . yyyylast_date))) dates, "+
	"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
	"FROM organisation left join orgevlink on (orgevlink.organisationid = organisation.organisationid) "+
	"left join events on orgevlink.eventid = events . eventid Where 1=1 ";
    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and organisation.organisationid=" + filter_id + " ";
    if (!filter_name.equals (""))
      list_db_sql += "and LOWER(organisation.name) like '%" + db_ausstage.plSqlSafeString(filter_name.toLowerCase()) + "%' ";
   // if (!filter_state.equals (""))
   //   list_db_sql += "and LOWER(states.state) like '%" + db_ausstage.plSqlSafeString(filter_state.toLowerCase()) + "%' ";
   // if (!filter_suburb.equals (""))
    //  list_db_sql += "and LOWER(suburb) like '%" + db_ausstage.plSqlSafeString(filter_suburb.toLowerCase()) + "%' ";*/
      
    list_db_sql += "Group by organisation.organisationid order by organisation." + request.getParameter("f_order_by");
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql =  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
     
  String hiddenVariables = "<input type='hidden' name='isPreviewForItemWork' value='" + isPreviewForItemWork + "'>" +
                  "<input type='hidden' name='isPreviewForEventWork' value='" + isPreviewForEventWork + "'>";                 
          
  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Organisations",
                  "Selected Organisations", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedOrganisations, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED
                  , hiddenVariables));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<jsp:include page="../templates/admin-footer.jsp" />
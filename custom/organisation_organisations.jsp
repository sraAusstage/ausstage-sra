<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = " ausstage.OrganisationOrganisationLink"%>
<%@ page import = "ausstage.Organisation"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  int MAX_RESULTS_RETURNED = 1000;

  String        sqlString;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  Statement stmt = db_ausstage.m_conn.createStatement();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  Vector filter_display_names       = new Vector ();
  Vector filter_names               = new Vector ();
  Vector order_display_names        = new Vector ();
  Vector order_names                = new Vector ();
  Vector textarea_db_display_fields = new Vector ();
  Vector buttons_names              = new Vector ();
  Vector buttons_actions            = new Vector ();
  String list_name                       = "";
  String selected_db_sql                 = "";
  String list_db_sql                     = "";
  String list_db_field_id_name           = "";
  String selected_list_name              = "";
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();
  String comeFromOrganisationAddeditPage         = request.getParameter("f_from_organisation_add_edit_page");
  String filter_id;
  String filter_name;
  String filter_state;
  String filter_suburb;
  String filter_box_selected;
  
  Hashtable hidden_fields = new Hashtable();
  Organisation organisation = (Organisation)session.getAttribute("organisationObj");
  if (organisation == null) organisation = new Organisation(db_ausstage);
  //we don't want to loose any info added to the contrib_addedit.jsp form.
  //only set the contributor attributes if we have come from the addedit page.
  if(comeFromOrganisationAddeditPage != null && comeFromOrganisationAddeditPage.equals("true")){
	  organisation.setOrganisationAttributes(request); 
	}
  
  boolean fromOrgPage = true;
  boolean isPreviewForOrg = false;
  boolean isPartOfThisOrg = false;
   
  if (request.getParameter("isPreviewForOrg") == null) {
	  isPreviewForOrg = true;
	    String organisation_id = request.getParameter("f_id");
	    String name = request.getParameter("f_organisation_name");
	    String address = request.getParameter("f_address");
	    String suburb = request.getParameter("f_state_id");
	    String state = request.getParameter("f_orgstate");
	    String postcode = request.getParameter("f_postcode");
	    String contact = request.getParameter("f_contact");
	    String contact_phone1 = request.getParameter("f_phone1");
	    String contact_fax = request.getParameter("f_fax");
	    String contact_email = request.getParameter("f_email");
	    String web_link = request.getParameter("f_web_links");
	    String country = request.getParameter("f_country");
	    String organisation_type = request.getParameter("f_organisation_type");
	    String notes = request.getParameter("f_notes");
	  }
  
  if (request.getParameter("fromOrgPage") == null)
	  fromOrgPage = false;
  
  if (fromOrgPage) organisation.setOrganisationAttributes(request);
  
  
  String f_organisation_id = Integer.toString(organisation.getId());
  //System.out.println("f_organisation_id: "+f_organisation_id);
  int    organisationId   = Integer.parseInt(f_organisation_id);
  hidden_fields.put("f_organisation_id", f_organisation_id);
  
  String f_select_this_org_id   = request.getParameter("f_select_this_org_id");
  String f_unselect_this_org_id = request.getParameter("f_unselect_this_org_id");
  String orderBy = request.getParameter ("f_order_by");
  
  Vector<OrganisationOrganisationLink> OrgOrgLinks = organisation.getOrganisationOrganisationLinks();
  //System.out.println(OrgOrgLinks.toString());
  //add the selected venue to the venue
  if (f_select_this_org_id != null) {
	  OrganisationOrganisationLink ool = new OrganisationOrganisationLink(db_ausstage);
	  ool.load(f_select_this_org_id);
	  OrgOrgLinks.add(ool);
      organisation.setOrgOrgLinks(OrgOrgLinks);
  }
 //remove  venue from the venue
  if (f_unselect_this_org_id != null) {
      for (OrganisationOrganisationLink existing : OrgOrgLinks) {
    	  if (existing.getChildId().equals(f_unselect_this_org_id))
    	      OrgOrgLinks.remove(existing);  
      }
	  
      organisation.setOrgOrgLinks(OrgOrgLinks);   
  }  
  session.setAttribute("organisationObj", organisation);
  
  
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_search_organisation_id");
  filter_name         = request.getParameter ("f_search_name");
  filter_state        = request.getParameter ("f_search_state");
  filter_suburb       = request.getParameter ("f_search_suburb");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_display_names.addElement ("State");
  filter_display_names.addElement ("Suburb");
  filter_names.addElement ("f_search_organisation_id");
  filter_names.addElement ("f_search_name");
  filter_names.addElement ("f_search_state");
  filter_names.addElement ("f_search_suburb");

  order_display_names.addElement ("Name");
  order_display_names.addElement ("State");
  order_display_names.addElement ("Suburb");
  order_names.addElement ("name");
  order_names.addElement ("state");
  order_names.addElement ("suburb");

  list_name             = "f_select_this_org_id";
  list_db_field_id_name = "organisationId";
  textarea_db_display_fields.addElement ("OUTPUT");

  selected_list_name             = "f_unselect_this_org_id";
  selected_list_db_field_id_name = "organisationId";
  selected_list_db_display_fields.addElement ("name");
  selected_list_db_display_fields.addElement ("state");
  selected_list_db_display_fields.addElement ("suburb");

  buttons_names.addElement ("Select");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_organisations.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='org_org_functions.jsp';search_form.submit();");
 
  selected_db_sql = "";
  Vector<OrganisationOrganisationLink> selectedOrganisations = new Vector<OrganisationOrganisationLink>();
  Vector temp_vector          = new Vector();
  String temp_string          = "";         
  selectedOrganisations = organisation.getOrganisationOrganisationLinks();
  
  for (int i=0; i < selectedOrganisations.size(); i++){
	  temp_string = organisation.getOrganisationInfoForOrganisationDisplay(Integer.parseInt(selectedOrganisations.get(i).getChildId()), stmt);
	  temp_vector.add(selectedOrganisations.get(i).getChildId());//add the id to the temp vector.
	  temp_vector.add(temp_string);//add the venue name to the temp_vector.
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
"GROUP BY organisation.organisationid ";
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
  
    list_db_sql += "Group by organisation.organisationid ";
  }
    
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Organisations",
                  "Selected Organisations", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedOrganisations, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><cms:include property="template" element="foot" />

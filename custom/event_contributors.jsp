<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.ConEvLink"%>
<%@ page import = "ausstage.Contributor, ausstage.ContributorFunction"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>


<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();

  String        sqlString;
  CachedRowSet  rset;
  int           MAX_RESULTS_RETURNED = 1000;
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
  String list_name                  = "";
  String selected_db_sql            = "";
  String list_db_sql                = "";
  String list_db_field_id_name      = "";

  String selected_list_name              = "";
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();

  String filter_id;
  String filter_first_name;
  String filter_last_name;
  String filter_box_selected;

  String contributorName;
  String contributorId;
  Contributor contributor, contrib;
  
  Hashtable hidden_fields = new Hashtable();

  Event eventObj = (Event)session.getAttribute("eventObj");
  boolean isPreviewForEvent = false;
  boolean fromEventPage     = true;
  boolean isPartOfThisEvent = false;
  boolean addedWhereClause  = false;
  boolean exactFirstName = false;
  boolean exactLastName  = false;
  
  if (request.getParameter ("exactFirstName") != null) {
    exactFirstName = true;
  }
  if (request.getParameter ("exactLastName") != null) {
    exactLastName = true;
  }

  
  if(request.getParameter("isPreviewForEvent") != null){
    isPreviewForEvent = true;
    String process_type            = request.getParameter("process_type");
    String contrib_id              = request.getParameter("f_contrib_id");
    String contrib_fname           = request.getParameter("f_f_name");
    String contrib_lname           = request.getParameter("f_l_name");
    String contrib_other_names     = request.getParameter("f_contrib_other_names");
    String contrib_dob_d           = request.getParameter("f_contrib_day");
    String contrib_dob_m           = request.getParameter("f_contrib_month");
    String contrib_dob_y           = request.getParameter("f_contrib_year");
    String contrib_gender_id       = request.getParameter("f_contrib_gender_id");
    String contrib_nationality     = request.getParameter("f_contrib_nationality");
    String contrib_address         = request.getParameter("f_contrib_address");
    String contrib_town            = request.getParameter("f_contrib_town");
    String contrib_state           = request.getParameter("f_contrib_state");
    String contrib_postcode        = request.getParameter("f_contrib_postcode");
    String contrib_country_id      = request.getParameter("f_contrib_country_id");
    String contrib_email           = request.getParameter("f_contrib_email");
    String contrib_notes           = request.getParameter("f_contrib_notes");
    String contrib_funct_ids       = request.getParameter("delimited_contrib_funct_ids");
    String warning_check           = request.getParameter("warning_check");

    if(contrib_id == null)          {contrib_id = "";}
    if(contrib_fname == null)       {contrib_fname = "";}
    if(contrib_lname == null)       {contrib_lname = "";}
    if(contrib_other_names == null) {contrib_other_names = "";}
    if(contrib_gender_id == null)   {contrib_gender_id = "";}
    if(contrib_dob_d == null)       {contrib_dob_d = "";}
    if(contrib_dob_m == null)       {contrib_dob_m = "";}
    if(contrib_dob_y == null)       {contrib_dob_y = "";}
    if(contrib_nationality == null) {contrib_nationality = "";}
    if(contrib_address == null)     {contrib_address = "";}
    if(contrib_town == null)        {contrib_town = "";}
    if(contrib_state == null)       {contrib_state = "";}
    if(contrib_postcode == null)    {contrib_postcode = "";}
    if(contrib_country_id == null)  {contrib_country_id = "";}
    if(contrib_email == null)       {contrib_email = "";}
    if(contrib_notes == null)       {contrib_notes = "";}
    if(contrib_funct_ids == null || contrib_funct_ids.equals("")) {contrib_funct_ids = "";}
    
    for(int i=0; i < eventObj.getConEvLinks().size() && !contrib_id.equals(""); i++){
      if(((ConEvLink)eventObj.getConEvLinks().elementAt(i)).getContributorBean().getId() == Integer.parseInt(contrib_id)){
        contributor = ((ConEvLink)eventObj.getConEvLinks().elementAt(i)).getContributorBean();
        contributor.setName(contrib_fname);
        contributor.setLastName(contrib_lname);
        contributor.setOtherNames(contrib_other_names);
        contributor.setGenderId(contrib_gender_id);
        contributor.setDobDay(contrib_dob_d);
        contributor.setDobMonth(contrib_dob_m);
        contributor.setDobYear(contrib_dob_y); 
        contributor.setNationality(contrib_nationality);
        contributor.setAddress(contrib_address);
        contributor.setTown(contrib_town);
        contributor.setState(contrib_state);
        contributor.setPostCode(contrib_postcode);
        contributor.setCountryId(contrib_country_id);
        contributor.setEmail(contrib_email);
        contributor.setNotes(contrib_notes);
        contributor.setContFunctIds(contrib_funct_ids);
        ConEvLink conevlink = (ConEvLink)eventObj.getConEvLinks().elementAt(i);
        conevlink.setContributorBean(contributor);
        eventObj.getConEvLinks().setElementAt(conevlink,i);
        isPartOfThisEvent = true;
        break;
      }
    }
    if(!isPartOfThisEvent){
      contrib = new Contributor(db_ausstage);
      contrib.setName(contrib_fname);
      contrib.setLastName(contrib_lname);
      contrib.setOtherNames(contrib_other_names);
      contrib.setGenderId(contrib_gender_id);
      contrib.setDobDay(contrib_dob_d);
      contrib.setDobMonth(contrib_dob_m);
      contrib.setDobYear(contrib_dob_y); 
      contrib.setNationality(contrib_nationality);
      contrib.setAddress(contrib_address);
      contrib.setTown(contrib_town);
      contrib.setState(contrib_state);
      contrib.setPostCode(contrib_postcode);
      contrib.setCountryId(contrib_country_id);
      contrib.setEmail(contrib_email);
      contrib.setNotes(contrib_notes);
      contrib.setContFunctIds(contrib_funct_ids);
      
      // Setup the ConOrgLinks from the session
      contrib.setConOrgLinks(((Contributor)session.getAttribute("contributor")).getConOrgLinks());

      if(!contrib_id.equals("")){ //  EDIT
        contrib.setId(Integer.parseInt(contrib_id));
        contrib.update();
      }else{                      //  ADD
        contrib.add();
      }
    }
  }


  
  if (request.getParameter("fromEventPage") == null)
    fromEventPage = false;

  if (fromEventPage) eventObj.setEventAttributes(request);

  String f_eventid = eventObj.getEventid();
  int    eventId   = Integer.parseInt(f_eventid);
  hidden_fields.put("f_eventid", f_eventid);

  String f_select_this_contributor_id   = request.getParameter("f_select_this_contributor_id");
  String f_unselect_this_contributor_id = request.getParameter("f_unselect_this_contributor_id");
  String orderBy = request.getParameter ("f_order_by");

  ConEvLink conEvLink = null;
  Vector conEvLinks = eventObj.getConEvLinks();

  if (f_select_this_contributor_id != null)
  {
    conEvLink = new ConEvLink(db_ausstage);
    conEvLink.load(f_select_this_contributor_id, f_eventid);
    conEvLinks.add(conEvLink);
  }

  if (f_unselect_this_contributor_id != null)
  {
    ConEvLink savedEvLink = null;
    conEvLink = new ConEvLink(db_ausstage);
    conEvLink.load(f_unselect_this_contributor_id, Integer.toString(eventId));

    // Can't use the remove() method as the beans won't be exactly the same (due to the database connection)
    for (int i=0; i < conEvLinks.size(); i++)
    {
      savedEvLink = (ConEvLink)conEvLinks.get(i);
      if (savedEvLink.equals(conEvLink))
      {
        conEvLinks.remove(i);
        break;
      }
    }
  }

  eventObj.setConEvLinks(conEvLinks);
  session.setAttribute("eventObj", eventObj);

// Get the form parameters that are used to create the SQL that determines what
// will be displayed in the list box (as this page posts to itself
// when a user performs a search)
filter_box_selected = request.getParameter("f_box_selected");
filter_id = request.getParameter("f_id");
filter_first_name = request.getParameter("f_first_name");
filter_last_name = request.getParameter("f_last_name");

filter_display_names.addElement("ID");
filter_display_names.addElement("First Name");
filter_display_names.addElement("Last Name");
filter_names.addElement("f_id");
filter_names.addElement("f_first_name");
filter_names.addElement("f_last_name");

order_display_names.addElement("First Name");
order_display_names.addElement("Last Name");
order_names.addElement("first_name");
order_names.addElement("last_name");

list_name = "f_select_this_contributor_id";
list_db_field_id_name = "contributorId";
textarea_db_display_fields.addElement("output");

selected_list_name = "f_unselect_this_contributor_id";
selected_list_db_field_id_name = "contributorId";


  buttons_names.addElement ("Select");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='event_contributors.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=PreviewForEvent';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=AddForEvent';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='event_contributor_functions.jsp';search_form.submit();");

  selected_db_sql = "";
  Vector selectedContributors = new Vector();
  
  for (int i=0; i < conEvLinks.size(); i++)
  {
    if (i > 0) selected_db_sql += ", ";

    conEvLink        = (ConEvLink)conEvLinks.get(i);
    contributorId    = conEvLink.getContributorId();
    contributor      = conEvLink.getContributorBean();
    contributorName  = conEvLink.getConDispInfo(stmt);
    selected_db_sql += contributorId;
    selectedContributors.add(contributorId);
    selectedContributors.add(contributorName);
  }	
  
// if first time this form has been loaded
  if (filter_id == null) {
		list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ',  first_name,last_name, "
				+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))) , "
				+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "
				+ "concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyyfirst_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "
				+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
				+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
				+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "
				+ "group by `contributor`.contributorid";
	} else {
		// Not the first time this page has been loaded
		// i.e the user performed a search

		list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ', first_name,last_name, "
				+ "if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))) , "
				+ "group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "
				+ "concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyyfirst_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "
				+ "FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "
				+ "LEFT JOIN events ON (conevlink.eventid = events.eventid) "
				+ "Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) " + "Where 1=1 ";

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and contributor.contributorid=" + filter_id + " ";

    if (!filter_first_name.equals ("")) {
      if (exactFirstName) {
        
        list_db_sql += "and LOWER(first_name) = '" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and LOWER(first_name) like '%" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "%' ";
      }
    }
      
    if (!filter_last_name.equals ("")) {
      if (exactLastName) {
        list_db_sql += "and LOWER(last_name) = '" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and lower(last_name) like '%" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "%' ";
      }
    }
      
  
    list_db_sql += "Group by contributor.contributorid order by " + request.getParameter ("f_order_by");
  }
  System.out.println(list_db_sql);
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  String cbxExactHTML = "<br><br>Exact First Name <input type='checkbox' name='exactFirstName' value='true'><br>Exact Last Name<input type='checkbox' name='exactLastName' value='true'>";
  out.println (htmlGenerator.displaySearchFilterAndSelector (
                  request, "Select Contributors",
                  "Selected Contributors", filter_display_names,
                  filter_names, order_display_names, order_names, list_name,
                  list_db_sql, list_db_field_id_name, textarea_db_display_fields,
                  selected_list_name, selectedContributors, selected_list_db_field_id_name,
                  buttons_names, buttons_actions, hidden_fields, false, MAX_RESULTS_RETURNED,
                  cbxExactHTML));

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>

<script>
var exactFirstName = <%=exactFirstName%>;
var exactLastName = <%=exactLastName%>;

if (exactFirstName) {
  search_form.exactFirstName.checked = true;
}

if (exactLastName) {
  search_form.exactLastName.checked = true;
}
</script><cms:include property="template" element="foot" />
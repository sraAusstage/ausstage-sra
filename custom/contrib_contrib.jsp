<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.Contributor"%>
<%@ page import = "ausstage.ContributorContributorLink"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  int              MAX_RESULTS_RETURNED = 1000;

  String           sqlString;
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
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();
  String comeFromContribAddeditPage         = request.getParameter("f_from_contrib_add_edit_page");
  System.out.println("Previous page:" +comeFromContribAddeditPage);
  String filter_id;
  String filter_first_name;
  String filter_last_name;
  String filter_box_selected;

  Hashtable hidden_fields = new Hashtable();
  Contributor  contributor   = (Contributor)session.getAttribute("contributor");
  System.out.println("Contributor object:" +contributor);
  //System.out.println("get contributor = " + contributor);
  if (contributor == null) contributor = new Contributor(db_ausstage);
  //we don't want to loose any info added to the contrib_addedit.jsp form.
  //only set the contributor attributes if we have come from the addedit page.
  if(comeFromContribAddeditPage != null && comeFromContribAddeditPage.equals("true")){
	  contributor.setContributorAttributes(request); 
  }
  boolean fromContribPage = true;
  boolean isPreviewForContrib = false;
  boolean isPartOfThisContrib = false;
 
  if (request.getParameter("isPreviewForContrib") == null) {
	  isPreviewForContrib = true;
	    String contrib_id = request.getParameter("f_contribid");
	    String first_name = request.getParameter("f_first_name");
	    String last_name = request.getParameter("f_last_name");
	    String gender = request.getParameter("f_gender");
	    String dd_dob = request.getParameter("f_dd_dob");
	    String mm_dob = request.getParameter("f_mm_dob");
	    String yyyy_dob = request.getParameter("f_yyyy_dob");
	    String dd_dod = request.getParameter("f_dd_dod");
	    String mm_dod = request.getParameter("f_mm_dod");
	    String yyyy_dod = request.getParameter("f_yyyy_dod");
	    String nationality = request.getParameter("f_nationality");
	    String other_names = request.getParameter("f_other_names");
	    String contrib_address = request.getParameter("f_contrib_address");
	    String suburb = request.getParameter("f_suburb");
	    String state = request.getParameter("f_state");
	    String postcode = request.getParameter("f_postcode");
	    String email = request.getParameter("f_email");
	    String country = request.getParameter("f_country");
	    String notes = request.getParameter("f_notes");
  }
  
  if (request.getParameter("fromContribPage") == null)
	  fromContribPage = false;
  
  if (fromContribPage) contributor.setContributorAttributes(request);
 
  String f_contribid = Integer.toString(contributor.getId());
  System.out.println("contribid " + f_contribid );
  int    contribId   = Integer.parseInt(f_contribid);
  hidden_fields.put("f_contribid", f_contribid);
  hidden_fields.put("f_contributor_id", f_contribid);
  
  String f_select_this_contributor_id   = request.getParameter("f_select_this_contributor_id");
  String f_unselect_this_contributor_id = request.getParameter("f_unselect_this_contributor_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the contributors from the current item
  //object in the session.
  
  Vector contribContribLinks = contributor.getAssociatedContributors();
  System.out.println("Associated COntributors:" + contribContribLinks);
  //System.out.println(contribContribLinks.toString());
//add the selected contributors to the contributor
 if (f_select_this_contributor_id != null)
  {
    contribContribLinks.add(f_select_this_contributor_id);
    contributor.setContributorContributorLinks(contribContribLinks);          
  }

 //remove contributor from the contributor
 if (f_unselect_this_contributor_id != null)
 {
   contribContribLinks.remove(f_unselect_this_contributor_id);
   contributor.setContributorContributorLinks(contribContribLinks);   
 }

 
 //System.out.println("set contributor = " + contributor);

 
  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_id");
  filter_first_name   = request.getParameter ("f_first_name");
  filter_last_name    = request.getParameter ("f_last_name");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("First Name");
  filter_display_names.addElement ("Last Name");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_first_name");
  filter_names.addElement ("f_last_name");
  
  order_display_names.addElement ("First Name");
  order_display_names.addElement ("Last Name");
  order_names.addElement ("first_name");
  order_names.addElement ("last_name");

  list_name             = "f_select_this_contributor_id";
  list_db_field_id_name = "contributorId";
  textarea_db_display_fields.addElement ("output");
  
  selected_list_name             = "f_unselect_this_contributor_id";
  selected_list_db_field_id_name = "contributorId";
  
  buttons_names.addElement ("Select");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_contrib.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_contrib_functions.jsp';search_form.submit();");
  
  selected_db_sql = "";
  Vector selectedContributors = new Vector();
  Vector temp_vector          = new Vector();
  String temp_string          = "";    
  selectedContributors = contributor.getAssociatedContributors();
  
  //because the vector that gets returned contains only linked
  //contributor ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a contributor id and the contributor name.
  //i.e. "4455, Luke Sullivan".

  //for each contributor id get name and add the id and the name to a temp vector.
  
  for(int i = 0; i < selectedContributors.size(); i ++){
    try{
      temp_string = contributor.getContributorInfoForDisplay(Integer.parseInt(((ContributorContributorLink)selectedContributors.get(i)).getChildId()), stmt);
      System.out.println("Try:"+temp_string);
    }catch(Exception e){ 
      temp_string = contributor.getContributorInfoForDisplay(Integer.parseInt((String)selectedContributors.get(i)), stmt);
      System.out.println("Exception:"+temp_string);
    }
    System.out.println("Exception outside:"+temp_string);
  temp_vector.add(selectedContributors.get(i));//add the id to the temp vector.
  temp_vector.add(temp_string);//add the contributor name to the temp_vector.
   // System.out.println("Temp STring:"+temp_string);
  }
  
  selectedContributors = temp_vector;
  stmt.close();
  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ',  first_name,last_name, "+
		"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) , "+
		"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "+
		"concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
		"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
		"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
		"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
		"group by `contributor`.contributorid";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   		
	list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ', first_name,last_name, "+
		"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) , "+
		"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "+
		"concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
		"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
		"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
		"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
"Where 1=1 ";	

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and contributor.contributorid=" + filter_id + " ";

    if (!filter_first_name.equals ("")) {    
        list_db_sql += "and LOWER(first_name) = '" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "' ";   
    }
      
    if (!filter_last_name.equals ("")) {    
        list_db_sql += "and LOWER(last_name) = '" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "' ";
    }
      
  
    list_db_sql += "Group by contributor.contributorid order by " + request.getParameter ("f_order_by");
  }

    
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  String cbxExactHTML = "<br><br>Exact First Name <input type='checkbox' name='exactFirstName' value='true'><br>Exact Last Name<input type='checkbox' name='exactLastName' value='true'>";

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                                     request,
                                     "Select Contributors",
                                     "Selected Contributors",
                                     filter_display_names,
                                     filter_names,
                                     order_display_names,
                                     order_names,
                                     list_name,
                                     list_db_sql,
                                     list_db_field_id_name,
                                     textarea_db_display_fields,
                                     selected_list_name,
                                     selectedContributors,
                                     selected_list_db_field_id_name,
                                     buttons_names,
                                     buttons_actions,
                                     hidden_fields,
                                     false,
                                     MAX_RESULTS_RETURNED));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
  
  session.setAttribute("contributor", contributor);
%>
<cms:include property="template" element="foot" />
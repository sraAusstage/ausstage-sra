<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, admin.Common, java.util.*, sun.jdbc.rowset.*"%>
<%@ page import = " ausstage.Database, ausstage.Organisation,ausstage.OrganisationOrganisationLink, ausstage.Venue, ausstage.Contributor, ausstage.RelationLookup"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<script type="text/javascript" src="/pages/assets/javascript/libraries/jquery-1.6.1.min.js"></script>

<%
  //define variables and attributes for use in the page
  //	login, page attributes and database connection
  admin.ValidateLogin   login           = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  //page html helper, and area lookup helpers
  ausstage.HtmlGenerator  htmlGenerator        = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Organisation organisationObj = new ausstage.Organisation (db_ausstage);
  ausstage.State        stateObj        = new ausstage.State (db_ausstage);
  ausstage.Country      countryObj      = new ausstage.Country(db_ausstage);

  //result sets for storing database data.
  CachedRowSet          rset;
  ResultSet             l_rs;
  Vector<OrganisationOrganisationLink> m_org_orglinks;
  Vector<OrganisationOrganisationLink> org_link_vec	= new Vector<OrganisationOrganisationLink>();
  Vector org_name_vec	= new Vector();

  //all of the fun things to do with how we got to the page, and where we're going... 
  String isReturn	= request.getParameter("isReturn");
  String action         = request.getParameter("act");
  if(action == null) {action = request.getParameter("action");}
  
  String stateLeadingSubString = "", stateTrailingSubString = "";
  
  //get the ID of the current organisation
  String organisation_id = request.getParameter("f_organisation_id");

  String countryLeadingSubString = "", countryTrailingSubString = "";
  int                     counter              = 0;
  Common                  common               = new Common();
  Hashtable               hidden_fields        = new Hashtable();
  String                  currentUser_authId = session.getAttribute("authId").toString();
  
  String isPreviewForOrgOrg  = request.getParameter("isPreviewForOrgOrg");
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  
  if(isReturn!=null){
      organisationObj = (Organisation)session.getAttribute("organisationObj");
      organisation_id  = Integer.toString(organisationObj.getId());
  }
  
  if(organisation_id == null) organisation_id = "";
  //use a new Organisation object that is not from the session.
  if(action != null && (action.equals("add") || action.equals("AddForWork") ||
		  				action.equals("AddForEvent") || 
		  				action.equals("AddForItem") ||
		  				action.equals("AddForCreatorItem"))){
    organisation_id = "0";	    
  }
  else if (action != null && (action.equals("edit") ||
  							  action.equals("EditForWork") ||
			  				  action.equals("EditForItem") ||
				  			  action.equals("EditForEvent") ||
							  action.equals("EditForCreatorItem"))){ //editing existing Orgs
  	if (organisation_id == null || organisation_id.equals("")) {
    		if (request.getParameter("f_select_this_organisation_id") != null) {
    			organisation_id = request.getParameter("f_select_this_organisation_id");
	    	} else {
      			organisation_id = "";
	    	}
	}
    	if (organisation_id != null && !organisation_id.equals("") && !organisation_id.equals("null")) {  
        	organisationObj.load(Integer.parseInt(organisation_id));
    	} 
  }
  else {//use the org object from the session.
      organisationObj = (Organisation)session.getAttribute("organisationObj");
      organisation_id  = Integer.toString(organisationObj.getId());
  }
  
  if (isPreviewForOrgOrg == null || isPreviewForOrgOrg.equals("null")) 
    isPreviewForOrgOrg = "";
  if(isPreviewForOrgOrg.equals("true") || (action != null && action.equals("ForOrgForOrg")))
    action = "ForOrganisation";
		  
  // get the initial state of the object(s) associated with this venue
  org_link_vec	        = organisationObj.getOrganisationOrganisationLinks();
  Organisation orgTemp 			= null;
 
  //ORGORGLINKS 
  RelationLookup lc = new RelationLookup(db_ausstage);

  //loop through the associated relations
  for(int i=0; i < org_link_vec.size(); i++ ){
	 boolean isParent = false;   	
	 orgTemp = new Organisation(db_ausstage);
	 //before loading the related organisation - is this current organisation the parent or child in the relation?
	 if (organisation_id.equals(org_link_vec.get(i).getOrganisationId())){
	 	isParent = true;
	 }
	 //load the appropriate organisation record
	 orgTemp.load(Integer.parseInt(
	 	(isParent) ? org_link_vec.get(i).getChildId() : org_link_vec.get(i).getOrganisationId())
	 );
	 	
	 if (org_link_vec.get(i).getRelationLookupId() != null) {
		lc.load(Integer.parseInt(org_link_vec.get(i).getRelationLookupId()));
		
		org_name_vec.add(orgTemp.getName() + " (" + ((isParent) ? lc.getParentRelation() : lc.getChildRelation()) + ")");
	 } else {
		org_name_vec.add(orgTemp.getName());
	 }
  }
	
  String f_selected_venue_id = request.getParameter("f_selected_venue_id");

  if (f_selected_venue_id == null) f_selected_venue_id = "";
  if (request.getParameter("place_of_origin") != null)
    organisationObj.setPlaceOfOrigin(f_selected_venue_id);
  if (request.getParameter("place_of_demise") != null)
    organisationObj.setPlaceOfDemise(f_selected_venue_id);
  

  if (action != null && action.equals("ForOrganisation")||action.equals("EditForEvent")|| isPreviewForOrgOrg.equals("true")){
      out.println("<form name='organisation_addedit_form' id='organisation_addedit_form' action='organisation_addedit_process.jsp?act=" + action +  "' method='post' onsubmit='return checkFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForOrgOrg' value='true'>");
      out.println("<input type='hidden' name='ForOrganisation' value='true'>");
      out.println("<input type='hidden' name='f_orgid' value='" + organisation_id + "'>");
   }
   else//adding a new organisation
   {
     out.println("<form name='organisation_addedit_form' id='organisation_addedit_form' action='organisation_addedit_process.jsp' method='post' onsubmit='return checkFields();'>");
   }

  pageFormater.writeHelper(out, "Enter the Organisation Details", "helpers_no1.gif");
  out.println("<input type='hidden' name='f_org_id' value='" + organisation_id + "'>");
  out.println("<input type='hidden' name='f_from_organisation_add_edit_page' value='true'>");
  
  
  //Organisation
    
  if (organisation_id != null)
  {    
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(organisation_id);
    pageFormater.writeTwoColTableFooter(out);  
  } 
  
  pageFormater.writeTwoColTableHeader(out, "Organisation Name *");
  out.println("<input type=\"text\" name=\"f_organisation_name\" size=\"80\" class=\"line300\" maxlength=60 value=\"" + ((organisationObj.getName() == null)?"":organisationObj.getName()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Other Names");
  out.println("<input type=\"text\" name=\"f_other_names1\" size=\"20\" class=\"line300\" maxlength=70 value=\"" + ((organisationObj.getOtherNames1() == null)?"":organisationObj.getOtherNames1()) + "\">");
  out.println("<input type=\"text\" name=\"f_other_names2\" size=\"20\" class=\"line300\" maxlength=70 value=\"" + ((organisationObj.getOtherNames2() == null)?"":organisationObj.getOtherNames2()) + "\">");
  out.println("<input type=\"text\" name=\"f_other_names3\" size=\"20\" class=\"line300\" maxlength=70 value=\"" + ((organisationObj.getOtherNames3() == null)?"":organisationObj.getOtherNames3()) + "\">");
  pageFormater.writeTwoColTableFooter(out);
  
   // Display Dates
  pageFormater.writeTwoColTableFooter(out);
  //pageFormater.writeHelper(out, "Dates", "helpers_no2.gif");
  
  pageFormater.writeTwoColTableHeader(out, "First Date");
  out.println("<input type=\"text\" name=\"f_first_date_day\" size=\"2\" class =\"line25\" maxlength=2 value=  \"" + ((organisationObj.getDdfirstDate() == null)?"":organisationObj.getDdfirstDate()) + "\">");
  out.println("<input type=\"text\" name=\"f_first_date_month\" size=\"2\" class =\"line25\" maxlength=2 value=\"" + ((organisationObj.getMmfirstDate() == null)?"":organisationObj.getMmfirstDate()) + "\">");
  out.println("<input type=\"text\" name=\"f_first_date_year\" size=\"4\" class =\"line35\" maxlength=4 value= \"" + ((organisationObj.getYyyyfirstDate() == null)?"":organisationObj.getYyyyfirstDate()) + "\">");
  pageFormater.writeTwoColTableFooter(out);
  
  //Place of Origin**********************************
  pageFormater.writeTwoColTableFooter (out);
  pageFormater.writeTwoColTableHeader (out, "Place of Origin");
  out.println("<input type='hidden' name='f_place_of_origin' value='" + ((organisationObj.getPlaceOfOrigin() == null)?"":organisationObj.getPlaceOfOrigin()) + "'>");
      
  Venue pob = new Venue(db_ausstage);
  //pob.load(Integer.parseInt("0"+organisationObj.getPlaceOfOrigin()));
  pob.load(Integer.parseInt((organisationObj.getPlaceOfOrigin()!= null&&!organisationObj.getPlaceOfOrigin().equals(""))?organisationObj.getPlaceOfOrigin():"0"));
    
  out.println("<input type='text' name='f_place_of_origin_venue_name' readonly size='50' class ='line300' value=\"" + pob.getName() + "\">");
  out.print("<td width=30><a style='cursor:hand' " + " onclick=\"Javascript:organisation_addedit_form.action='venue_search.jsp?act=" + action + "&place_of_origin=1';" +
              "organisation_addedit_form.submit();\"><img border='0' src='/custom/images/popup_button.gif'></a></td>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Last Date");
  out.println("<input type=\"text\" name=\"f_last_date_day\" size=\"2\" class =\"line25\" maxlength=2 value=  \"" + ((organisationObj.getDdlastDate() == null)?"":organisationObj.getDdlastDate()) + "\">");
  out.println("<input type=\"text\" name=\"f_last_date_month\" size=\"2\" class =\"line25\" maxlength=2 value=\"" + ((organisationObj.getMmlastDate() == null)?"":organisationObj.getMmlastDate()) + "\">");
  out.println("<input type=\"text\" name=\"f_last_date_year\" size=\"4\" class =\"line35\" maxlength=4 value= \"" + ((organisationObj.getYyyylastDate() == null)?"":organisationObj.getYyyylastDate()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  //Place of Demise******************************
  pageFormater.writeTwoColTableFooter (out);
  pageFormater.writeTwoColTableHeader (out, "Place of Demise");
  out.println("<input type='hidden' name='f_place_of_demise' value='" + ((organisationObj.getPlaceOfDemise() == null)?"":organisationObj.getPlaceOfDemise()) + "'>");
  Venue pod = new Venue(db_ausstage);
  pod.load(Integer.parseInt((organisationObj.getPlaceOfDemise()!=null&&!organisationObj.getPlaceOfDemise().equals(""))?organisationObj.getPlaceOfDemise():"0"));

  out.println("<input type='text' name='f_place_of_demise_venue_name' readonly size='50' class ='line300' value=\"" + pod.getName() + "\">");
  out.print("<td width=30><a style='cursor:hand' " + " onclick=\"Javascript:organisation_addedit_form.action='venue_search.jsp?act=" + action + "&place_of_demise=1';" +
      "organisation_addedit_form.submit();\"><img border='0' src='/custom/images/popup_button.gif'></a></td>");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Address");
  out.println("<input type=\"text\" name=\"f_org_address\" size=\"20\" class =\"line300\" maxlength=130 value=\"" + ((organisationObj.getAddress() == null)?"":organisationObj.getAddress()) + "\">");        
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Suburb");
  out.println("<input type=\"text\" name=\"f_org_suburb\" size=\"20\" class =\"line300\" maxlength=40 value=\"" + ((organisationObj.getSuburb() == null)?"":organisationObj.getSuburb()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  // State
  pageFormater.writeTwoColTableHeader(out, "State");
  out.println("<select name=\"f_org_state_id\" size=\"1\" class =\"line50\">");
  rset = stateObj.getStates (stmt);

  // Display all of the states
  while (rset.next()){

  String selected = "";
    if (organisationObj.getState().equals(rset.getString("stateid")))//editing existing state
        selected = "selected";
     
    if(!rset.getString("state").toLowerCase().equals("unknown") && !rset.getString("state").toLowerCase().equals("[unknown]")){
      stateTrailingSubString += "<option " + selected + " value='" + rset.getString ("stateid") + "'" +
                                    ">" + rset.getString ("state") + "</option>\n";
    }else{
       stateLeadingSubString = "<option " + selected + " value='" + rset.getString ("stateid") + "'>" + rset.getString ("state") + "</option>\n";
    }
  }
  rset.close ();
 
  out.print(stateLeadingSubString + stateTrailingSubString);
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Postcode");
  out.println("<input type=\"text\" name=\"f_postcode\" size=\"5\" class=\"line50\" maxlength=40 value=\"" + ((organisationObj.getPostcode() == null)?"":organisationObj.getPostcode()) + "\">");
  pageFormater.writeTwoColTableFooter(out);
   // Countries
  pageFormater.writeTwoColTableHeader(out, "Country");
  out.println("<select name=\"f_country\" size=\"1\" class=\"line150\">");
  rset = countryObj.getCountries (stmt);

  // Display all of the Countries
 
  while (rset.next())
  {
    String selected = "";
    if (organisationObj.getCountry() != null && !organisationObj.getCountry().equals("") && organisationObj.getCountry().equals(rset.getString ("countryid")))
      selected = "selected";
        
    if(!rset.getString ("countryname").toLowerCase().equals("australia")){
      countryTrailingSubString += "<option " + selected + " value='" + rset.getString ("countryid") + "'" +
                                  ">" + rset.getString ("countryname") + "</option>\n";
    }else{
      countryLeadingSubString = "<option " + selected + " value='" + rset.getString ("countryid") + "'>" + rset.getString ("countryname") + "</option>\n";
    }
  }
  rset.close ();
  out.print(countryLeadingSubString + countryTrailingSubString);
  out.println("</select>");

  pageFormater.writeTwoColTableFooter(out);


  pageFormater.writeTwoColTableHeader(out, "Contact Name");
  out.println("<input type=\"text\" name=\"f_contact\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getContact() == null)?"":organisationObj.getContact()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Phone 1");
  out.println("<input type=\"text\" name=\"f_phone1\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getPhone1() == null)?"":organisationObj.getPhone1()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Phone 2");
  out.println("<input type=\"text\" name=\"f_contact_phone2\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getPhone2() == null)?"":organisationObj.getPhone2()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Phone 3");
  out.println("<input type=\"text\" name=\"f_contact_phone3\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getPhone3() == null)?"":organisationObj.getPhone3()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Fax");
  out.println("<input type=\"text\" name=\"f_fax\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getFax() == null)?"":organisationObj.getFax()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Contact Email");
  out.println("<input type=\"text\" name=\"f_email\" size=\"40\" class=\"line300\" maxlength=40 value=\"" + ((organisationObj.getEmail() == null)?"":organisationObj.getEmail()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Web Link");
  out.println("<input type=\"text\" name=\"f_web_links\" size=\"100\"  class=\"line300\" maxlength=2048 value=\"" + ((organisationObj.getWebLinks() == null)?"":organisationObj.getWebLinks()) + "\">");
  pageFormater.writeTwoColTableFooter(out);

 
   // Dislpay Organisation Types
  pageFormater.writeTwoColTableHeader(out, "Organisation Type *");
  out.println("<select name=\"f_organisation_type\" size=\"1\" class=\"line150\">");
  l_rs = organisationObj.getOrgTypes(stmt);
  String orgTypeId = organisationObj.getOrganisationType();

  while (l_rs.next())
  {  
    String selected = "";
    String l_org_type_id = l_rs.getString ("organisation_type_id");
    String l_org_type    = l_rs.getString ("type");
    
//    if(counter == 0)
//      out.print("<option value=''>--- Select Type ---</option>");
    if (orgTypeId != null && !orgTypeId.equals("") && orgTypeId.equals(l_org_type_id))
      selected = "selected";
    //if we are adding default to Other Organisation
    //if(action != null && action.equals("add") && l_org_type.equals("Other Organisation"))
    if ((orgTypeId == null || orgTypeId.equals("")) && l_org_type.equals("Other Organisation"))
      selected = "selected";

    out.print("<option " + selected + " value='" + l_org_type_id + "'" +
                                  ">" + l_org_type + "</option>\n");
    counter ++;
  }
  l_rs.close ();
  out.println("</select>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Notes");
  out.println("<textarea name=\"f_notes\" rows=\"5\" cols=\"50\" class=\"line300\">" + ((organisationObj.getNotes() == null)?"":organisationObj.getNotes()) + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "NLA");
  out.println("<input type=\"text\" name=\"f_nla\" size=\"100\" class=\"line300\" maxlength=2048 value=\"" + ((organisationObj.getNLA() == null)?"":organisationObj.getNLA()) + "\">");
  pageFormater.writeTwoColTableFooter(out);  
  
  /***************************
  Organisation Association/s
  ****************************/	
  out.println("<a name='organisation_organisation'></a>");
  pageFormater.writeHelper(out, "Organisation Association/s", "helpers_no2.gif");
  hidden_fields.clear();
  hidden_fields.put("act", action);
  out.println (htmlGenerator.displayLinkedItem("",
                                      "6",
                                      "organisation_organisations.jsp?f_from_organisation_add_edit_page=true",
                                      "organisation_addedit_form",
                                      hidden_fields,
                                      "Associated with Organisation(s):",
                                      org_name_vec,
                                      1000));
  
  /***************************
  Data Entry Information
  ****************************/
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no3.gif");
  pageFormater.writeTwoColTableHeader(out, "OrganisationID:");
  out.print(organisationObj.getId());
  pageFormater.writeTwoColTableFooter(out);
 
  if (organisationObj.getEnteredByUser() != null && !organisationObj.getEnteredByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Created by User:");
    out.print(organisationObj.getEnteredByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Created:");
    out.print(common.formatDate(organisationObj.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  if (organisationObj.getUpdatedByUser() != null && !organisationObj.getUpdatedByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Updated by User:");
    out.print(organisationObj.getUpdatedByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Updated:");
    out.print(common.formatDate(organisationObj.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  /*****************************************************/

  
  pageFormater.writePageTableFooter (out);
  if (action != null && action.equals("EditForEvent"))
    pageFormater.writeButtons(out, "back", "prev.gif", "", "", "submit", "tick.gif");
  else
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");

  pageFormater.writeFooter(out);
 
  // reset/set the state of the Organisation object 
  session.setAttribute("organisationObj", organisationObj);
%>
</form>
<script language="javascript">

//add listener to the country and state select lists
$(document).ready(function(){
	//if country selected is not australia set state to O/S
	//if Australia and state is O/S set to [Unknown]
	$("[name=f_country]").change(function(){
		if ($("[name=f_country] option:selected").text() != 'Australia'){
			//set state to O/S
			$("[name=f_org_state_id] option:contains('O/S')").prop('selected', true);
		}else {
			//set state to unknown
			$("[name=f_org_state_id] option:contains('[Unknown]')").prop('selected', true);
		}
	});
	//if state selected is not O/S make country Australia
	$("[name=f_org_state_id]").change(function(){
		if ($("[name=f_org_state_id] option:selected").text() != 'O/S'){
			//set Country to Australia
			$("[name=f_country] option:contains('Australia')").prop('selected', true);
		}	
	});
});

  function checkFields(){
    var msg = "";
    
    if(!validateUrl($('input[name=f_web_links]'))){return false;}
    if(!checkStateCountry())return false;

    if($( '[name|="f_organisation_name"]').val().length<1)
    //if(isBlank(document.org_form.f_orgname.value))
      msg += "\t-Organisation Name \n";
 
    if($( '[name|="f_organisation_type"]').val()=="") 
    //if(isBlank(document.org_form.f_organisation_type.value))
      msg += "\t-Organisation Type\n"; 
      
      
    if(msg) {		
      alert("You appear to have not entered the following information for:\n" + msg + "Please press the OK button to continue and then fill in the required fields.");
        return false;
    }
    return true;
    
  }

  function checkStateCountry(){
  console.log("checking");
	var state = $("[name=f_org_state_id] option:selected").text();
	var country = $("[name=f_country] option:selected").text();
	var returnVal = true;
	console.log(state +"|"+country);
	if ((state == "O/S") && (country =="Australia")){alert("If the State is O/S, the Country can not be Australia. Please ensure the data is entered correctly and try again."); returnVal = false;}
	if ((state != "O/S") && (country != "Australia")){alert("If the Country is not Australia, the State must be O/S. Please ensure the data is entered correctly and try again."); returnVal = false;}
	return returnVal;
}
  
</script>
<%
  stmt.close();
  db_ausstage.disconnectDatabase();  
%>
<cms:include property="template" element="foot" />
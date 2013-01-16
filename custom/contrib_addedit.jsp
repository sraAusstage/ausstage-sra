<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*, ausstage.LookupCode, ausstage.Event, ausstage.Venue, ausstage.ConEvLink, admin.Common"%>
<%@ page import = " ausstage.Database, ausstage.Work, ausstage.Contributor, ausstage.ContributorContributorLink"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin          login        = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage             pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database               db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement                    stmt          = db_ausstage.m_conn.createStatement();
  ausstage.HtmlGenerator  htmlGenerator        = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Contributor         contributor   = new ausstage.Contributor(db_ausstage);
  ausstage.ContributorFunction contfunct     = new ausstage.ContributorFunction(db_ausstage);
  ausstage.State               state         = new ausstage.State(db_ausstage);
  ausstage.Country             country       = new ausstage.Country(db_ausstage);
  Vector                       selectedItems = new Vector();
  Vector                       selectedOrgs  = new Vector();
  Vector                  temp_display_info;
  Vector<String> contributor_name_vec		= new Vector<String>();
  Vector<ContributorContributorLink> contributor_link_vec	=	new Vector<ContributorContributorLink>();
  boolean preview = false;
  Hashtable                    hidden_fields = new Hashtable();
  Common                  common               = new Common();

  String sqlString, countryLeadingSubString = "", countryTrailingSubString = "";
  String stateLeadingSubString = "", stateTrailingSubString = "";
  String delimited_sel_items = "";
  CachedRowSet  rset;
  
  String action       = request.getParameter("act");
  String process_type = request.getParameter("process_type");
  String isForItem    = request.getParameter("isForItem");
  
  if (action == null) {
    action = "";
  }
  
  String contrib_id = "";

  if (action.equals("PreviewForEvent"))
    contrib_id = request.getParameter("f_select_this_contributor_id");
  else if(action.equals("ForItem") || action.equals("ForCreatorItem"))
    contrib_id = request.getParameter("f_select_this_contributor_id");
  else if(action.equals("ForWork"))
    contrib_id = request.getParameter("f_select_this_contributor_id");
  else
    contrib_id = request.getParameter("f_contributor_id");

  String contrib_prefix          = "";
  String contrib_fname           = "";
  String contrib_mname           = "";
  String contrib_lname           = "";
  String contrib_suffix          = "";
  String place_of_birth  = "";
  String place_of_death  = "";
  String contrib_display_name    = "";
  String contrib_other_names     = "";
  String contrib_dob_d           = "";
  String contrib_dob_m           = "";
  String contrib_dob_y           = "";
  String contrib_gender_id       = "";
  String contrib_nationality     = "";
  String contrib_address         = "";
  String contrib_town            = "";
  String contrib_state           = "";
  String contrib_postcode        = "";
  String contrib_country_id      = "";
  String contrib_email           = "";
  String contrib_notes           = "";
  String contrib_nla             = "";
  String contrib_dod_d           = "";
  String contrib_dod_m           = "";
  String contrib_dod_y           = "";
  String contrib_funct_ids       = "";
  String contrib_contrib_ids	 = "";
  boolean displayContribDetails  = true;


  if(action     == null)  {action = "";}
  if(contrib_id == null)  {contrib_id = "";}
  //System.out.println("Con id:"+contrib_id);
  
  out.println("<form name='f_contributor_addedit' id='contrib_addedit_form' action='contrib_addedit_process.jsp' method='post' onsubmit='return checkManditoryFields();'>");
  out.println("<input type='hidden' name='f_contribid' value='" + contrib_id + "'>");
  out.println("<input type='hidden' name='f_from_contrib_add_edit_page' value='true'>");

  if (action.equals("PreviewForEvent"))
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='event_contributors.jsp' onsubmit='return checkFields();'>\n" +
                "<input type=hidden name='act' value='PreviewForEvent'>"); 
                //"<input type=hidden name='isPreviewForEvent' value='true'>");  
  
  else if(action.equals("ForItem"))
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action +  "'' onsubmit='return checkFields();'>\n" +
                "<input type=hidden name='isPreviewForItem' value='true'>");
  else if(action.equals("ForCreatorItem"))
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action +  "'' onsubmit='return checkFields();'>\n" +
                "<input type=hidden name='isPreviewForCreatorItem' value='true'>");           
  else if(action.equals("ForWork") )
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action +  "'' onsubmit='return checkFields();'>\n" +
                "<input type=hidden name='isPreviewForWork' value='true'>");    
  else if(action.equals("AddForEvent") )
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action +  "' onsubmit='return checkFields();'>\n" +
                "<input type=hidden name='act' value='"+action+"'>");                              
  else if ((action.equals("edit") || action.equals("add") || request.getParameter("isReturn") != null))
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action + "' onsubmit='return checkFields();'>\n"); 
  else
    out.println("<form name='f_contributor_addedit' id='f_contributor_addedit' method='post' " +
                "action='contrib_addedit_process.jsp?act=" + action + "&isForItem=true' onsubmit='return checkFields();'>");  
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  boolean isPartOfThisEvent = false;

  if (request.getParameter("isReturn") != null || action.equals("")) { //have returned from editing child records
    contributor = (Contributor)session.getAttribute("contributor");
    contrib_id = contributor.getId()+"";
   
  }

  // Edit Contribitor
  //if(contrib_id != null && !contrib_id.equals("") && !contrib_id.equals("0")){

  if(action.equals("PreviewForEvent") && !contrib_id.equals("")){
    Event eventObj = (Event)session.getAttribute("eventObj");

    for(int i=0; i < eventObj.getConEvLinks().size(); i++){
      ausstage.Contributor contrib = ((ConEvLink)eventObj.getConEvLinks().elementAt(i)).getContributorBean();
      if(contrib.getId() == Integer.parseInt(contrib_id)){
        isPartOfThisEvent = true;
        contributor = contrib;
        break;
      }
    }
  }
  //else if (action.equals("PreviewForEvent")) {
    // The user did not select the contributor
  //  displayContribDetails = false;
  //}
  
  if (displayContribDetails) {
    if (!isPartOfThisEvent &&
             request.getParameter("isReturn") == null &&
             contrib_id != null &&
             !contrib_id.equals("") &&
             !contrib_id.equals ("0") && !action.equals("")) { // means we are editing contributor that is not part of the event that is stored in the session 
      contributor.load(Integer.parseInt(contrib_id));
    }
    else if (request.getParameter("isReturn") != null || action.equals("")) {
    	//have returned from editing child records {
      contributor = (Contributor)session.getAttribute("contributor");
      //out.println("get contributor = " + contributor);

    }
    //System.out.println("set contributor = " + contributor);

    // lets set the state of the object
    selectedOrgs        = contributor.getConOrgLinks();
  
    contrib_prefix      = contributor.getPrefix();
    contrib_fname       = contributor.getName();
    contrib_mname       = contributor.getMiddleName();
    contrib_lname       = contributor.getLastName();
    contrib_suffix      = contributor.getSuffix();
    place_of_birth = contributor.getPlaceOfBirth();
    place_of_death = contributor.getPlaceOfDeath();
    contrib_other_names = contributor.getOtherNames();
    contrib_display_name = contributor.getDisplayName();
    contrib_gender_id   = contributor.getGenderId();
    contrib_dob_d       = contributor.getDobDay();
    contrib_dob_m       = contributor.getDobMonth();
    contrib_dob_y       = contributor.getDobYear(); 
    contrib_nationality = contributor.getNationality();
    contrib_address     = contributor.getAddress();
    contrib_town        = contributor.getTown();
    contrib_state       = contributor.getState();
    contrib_postcode    = contributor.getPostCode();
    contrib_country_id  = contributor.getCountryId();
    contrib_email       = contributor.getEmail();
    contrib_notes       = contributor.getNotes();
    contrib_nla         = contributor.getNLA();
    contrib_dod_d       = contributor.getDodDay();
    contrib_dod_m       = contributor.getDodMonth();
    contrib_dod_y       = contributor.getDodYear(); 
    contrib_funct_ids   = contributor.getContFunctIds();
    //contrib_contrib_ids = contributor.getAssociatedContributors();
    
    
    if(contrib_prefix == null)      {contrib_prefix = "";}
    if(contrib_fname == null)       {contrib_fname = "";}
    if(contrib_mname == null)       {contrib_mname = "";}
    if(contrib_lname == null)       {contrib_lname = "";}
    if(contrib_suffix == null)      {contrib_suffix = "";}
    if(place_of_birth == null)  	{place_of_birth = "";}
    if(place_of_death == null) {place_of_death = "";}
    if(contrib_display_name == null) {contrib_display_name = "";}
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
    if(contrib_nla == null)       {contrib_nla = "";}
    if(contrib_dod_d == null)       {contrib_dod_d = "";}
    if(contrib_dod_m == null)       {contrib_dod_m = "";}
    if(contrib_dod_y == null)       {contrib_dod_y = "";}
    if(contrib_funct_ids == null)   {contrib_funct_ids = "";}
    if(contrib_contrib_ids == null)   {contrib_contrib_ids = "";}
    
    contributor_link_vec	    = contributor.getContributorContributorLinks();
    LookupCode lc = new LookupCode(db_ausstage);
    
    for(ContributorContributorLink ccl : contributor_link_vec){
    	Contributor contributorTemp = new Contributor(db_ausstage);
    	contributorTemp.load(Integer.parseInt(ccl.getChildId()));
    	if (ccl.getFunctionId() != null) {
			lc.load(Integer.parseInt(ccl.getFunctionId()));
			contributor_name_vec.add(contributorTemp.getDisplayName() + " (" + lc.getDescription() + ")");
		} else {
			contributor_name_vec.add(contributorTemp.getDisplayName());
		}
	}
    
    String f_selected_venue_id = request.getParameter("f_selected_venue_id");

    if (f_selected_venue_id == null) f_selected_venue_id = "";

    if (request.getParameter("place_of_birth") != null)
      contributor.setPlaceOfBirth(f_selected_venue_id);
    if (request.getParameter("place_of_death") != null)
      contributor.setPlaceOfDeath(f_selected_venue_id);
    

    pageFormater.writeHelper(out, "Contributor", "helpers_no1.gif");
    
    if (contrib_id != null && !contrib_id.equals("") && !contrib_id.equals ("0")) {
      pageFormater.writeTwoColTableHeader (out, "ID");
      out.println(contrib_id);
      pageFormater.writeTwoColTableFooter (out);
    }
    
    pageFormater.writeTwoColTableHeader (out, "Prefix");
  %>
    <input class="line200" type="text" name="f_prefix" size="40" maxlength="40" value="<%=contrib_prefix%>">
  <%
    pageFormater.writeTwoColTableFooter (out); 
    

    pageFormater.writeTwoColTableHeader (out, "First Name *");
  %>
    <input type="hidden" name="f_contrib_id" value="<%=contrib_id%>">
    <input class="line200" type="text" name="f_f_name" size="40" maxlength="40" value="<%=contrib_fname%>">
  <%
    if(process_type != null && process_type.equals("add_article")){
  %>
      <input type="hidden" name="process_type" value="<%=process_type%>">
  <%
    }
    
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Middle Name");
  %>
    <input class="line200" type="text" name="f_m_name" size="40" maxlength="40" value="<%=contrib_mname%>">
  <%
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "Last Name *");
  %>
    <input class="line200" type="text" name="f_l_name" size="40" maxlength="40" value="<%=contrib_lname%>">
  <%
    pageFormater.writeTwoColTableFooter (out); 
    
    pageFormater.writeTwoColTableHeader (out, "Suffix");
  %>
    <input class="line200" type="text" name="f_suffix" size="40" maxlength="40" value="<%=contrib_suffix%>">
  <%
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "Display Name");
  %>
    <input class="line200" type="text" name="f_display_name" size="40" maxlength="40" value="<%=contrib_display_name%>">
  <%
    pageFormater.writeTwoColTableFooter (out); 
    
     
    pageFormater.writeTwoColTableHeader (out, "Gender");
  
    sqlString = "select GENDERID, GENDER from GENDERMENU";
    rset = db_ausstage.runSQL(sqlString, stmt);
    if(rset.next()){                       
      out.println("\t<select name='f_contrib_gender_id' class='line200'>\n");
      do{
        String selected = "";
        if(contrib_gender_id.equals(rset.getString("GENDERID")))
          selected = "selected";
        
        out.println("\t\t<option " + selected + " value='"+ rset.getString("GENDERID") +"'>" + rset.getString("GENDER") + "</option>\n");
      }while(rset.next());
      out.println("\t</select>\n");  
    }else{
      out.println("\t<select name='f_contrib_gender' class='line200'>\n");
      out.println("\t\t<option value=''>No Gender found.</option>\n");
      out.println("\t</select>\n"); 
    }
  
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Date of Birth");
  %>
    <input class="line50" type="text" name="f_contrib_day" size="2" maxlength="2" value="<%=contrib_dob_d%>">&nbsp;<input class="line50" type="text" name="f_contrib_month" size="2" maxlength="2" value="<%=contrib_dob_m%>">&nbsp;<input class="line50" type="text" name="f_contrib_year" size="4" maxlength="4" value="<%=contrib_dob_y%>">&nbsp;dd-mm-yyyy
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "");
    //out.println("dd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;yyyy");
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Place of Birth");
    out.println("<input type='hidden' name='f_place_of_birth' value='" + contributor.getPlaceOfBirth() + "'>");
    
    Venue pob = new Venue(db_ausstage);
    pob.load(Integer.parseInt("0"+contributor.getPlaceOfBirth()));
    
    out.println("<input type='text' name='f_place_of_birth_venue_name' readonly size='50' class='line300' value=\"" + pob.getName() + "\">");
    out.print("<td width=30><a style='cursor:hand' " +
              "onclick=\"document.f_contributor_addedit.action='venue_search.jsp?act=" + action + "&place_of_birth=1';" +
              "document.f_contributor_addedit.submit();\"><img border='0' src='/custom/images/popup_button.gif'></a></td>");
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader (out, "Date of Death");
  %>
    <input class="line50" type="text" name="f_contrib_day_death" size="2" maxlength="2" value="<%=contrib_dod_d%>">&nbsp;<input class="line50" type="text" name="f_contrib_month_death" size="2" maxlength="2" value="<%=contrib_dod_m%>">&nbsp;<input class="line50" type="text" name="f_contrib_year_death" size="4" maxlength="4" value="<%=contrib_dod_y%>">&nbsp;dd-mm-yyyy
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "");    
    //out.println("dd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;yyyy");
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Place of Death");
    out.println("<input type='hidden' name='f_place_of_death' value='" + contributor.getPlaceOfDeath() + "'>");
    
    Venue pod = new Venue(db_ausstage);
    pod.load(Integer.parseInt("0"+contributor.getPlaceOfDeath()));
    
    out.println("<input type='text' name='f_place_of_death_venue_name' readonly size='50' class='line300' value=\"" + pod.getName() + "\">");
    out.print("<td width=30><a style='cursor:hand' " +
              "onclick=\"document.f_contributor_addedit.action='venue_search.jsp?act=" + action + "&place_of_death=1';" +
              "document.f_contributor_addedit.submit();\"><img border='0' src='/custom/images/popup_button.gif'></a></td>");
    
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Nationality");
  %>
    <input class="line200" type="text" name="f_contrib_nationality" size="40" maxlength="40" value="<%=contrib_nationality%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Other Names");
  %>
    <input class="line200" type="text" name="f_contrib_other_names" size="40" maxlength="40" value="<%=contrib_other_names%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Contributor Address");
  %>
    <input class="line200" type="text" name="f_contrib_address" size="80" maxlength="80" value="<%=contrib_address%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Suburb");
  %>
    <input class="line200" type="text" name="f_contrib_town" size="40" maxlength="40" value="<%=contrib_town%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    //states
    pageFormater.writeTwoColTableHeader (out, "State");
    out.println("\t<select name='f_contrib_state' class='line200'>\n");
    rset = state.getStates(stmt);
  
      while (rset.next()){
        String selected = "";
        if (contrib_state.equals(rset.getString("STATEID")))//therefore editing existing state
          selected = "selected";
     
        if(!rset.getString("state").toLowerCase().equals("unknown")){
          stateTrailingSubString += "<option " + selected + " value='" + rset.getString ("stateid") + "'" +
                                    ">" + rset.getString ("state") + "</option>\n";
        }else{
          stateLeadingSubString = "<option " + selected + " value='" + rset.getString ("stateid") + "'>" + rset.getString ("state") + "</option>\n";
        }
      }
      rset.close ();
      out.print(stateLeadingSubString + stateTrailingSubString);
      out.println("</select>");
      
      
    pageFormater.writeTwoColTableFooter (out); 
    
    pageFormater.writeTwoColTableHeader (out, "Postcode");
  %>
    <input class="line200" type="text" name="f_contrib_postcode" size="4" maxlength="4" value="<%=contrib_postcode%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Email");
  %>
    <input class="line200" type="text" name="f_contrib_email" size="40" maxlength="40" value="<%=contrib_email%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Notes");
  %>
    <textarea name="f_contrib_notes" rows="6" cols="55"><%=contrib_notes%></textarea>
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "NLA");
  %>
    <input class="line200" type="text" name="f_contrib_nla" size="100" maxlength="100" value="<%=contrib_nla%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Country");
    
    rset = country.getCountries(stmt);
    if(rset.next()){                       
      out.println("\t<select name='f_contrib_country_id' class='line200'>\n");
      do{
        String selected = "";
        if (contrib_country_id != null && !contrib_country_id.equals("") && contrib_country_id.equals(rset.getString("COUNTRYID")))
          selected = "selected";
        
        if(!rset.getString ("countryname").toLowerCase().equals("australia")){
          countryTrailingSubString += "<option " + selected + " value='" + rset.getString ("countryid") + "'" +
                                      ">" + rset.getString ("countryname") + "</option>\n";
        }else{
          countryLeadingSubString = "<option " + selected + " value='" + rset.getString ("countryid") + "'>" + rset.getString ("countryname") + "</option>\n";
        }
      }while (rset.next());
      out.print(countryLeadingSubString + countryTrailingSubString + "\t</select>\n");
      
    }else{
      out.println("\t<select name='f_contrib_country_id' class='line200'>\n");
      out.println("\t\t<option value=''>No Country found.</option>\n");
      out.println("\t</select>\n"); 
    }
  
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "Contributor Function");
  
    rset = contfunct.getNames();
    if(rset.next()){   
      out.println("\t<select name='f_contrib_funct_id' class='line200' size='6'>\n");
      do{
        String selected = "";
        if(contrib_funct_ids.indexOf(",") != -1){
          StringTokenizer contribfunct_ids = new StringTokenizer(contrib_funct_ids, ",");
          while(contribfunct_ids.hasMoreTokens()){
            if(contribfunct_ids.nextToken().equals(rset.getString("ContributorFunctPreferredId"))){
              if(!selectedItems.contains(rset.getString("ContributorFunctPreferredId")))
                selectedItems.addElement(rset.getString("ContributorFunctPreferredId"));   //adput(rset.getString("CONTFUNCTIONID"), rset.getString("CONTFUNCTION"));
              break;
            }
          }
        }else{
          if(contrib_funct_ids.equals(rset.getString("ContributorFunctPreferredId"))){
            if(!selectedItems.contains(rset.getString("ContributorFunctPreferredId")))
              selectedItems.addElement(rset.getString("ContributorFunctPreferredId"));  
          }
        }
        out.println("\t\t<option value='"+ rset.getString("ContributorFunctPreferredId") +"'>" + rset.getString("CONTFUNCTION") + ", " + rset.getString("PreferredTerm") +"</option>\n");
      }while(rset.next());
      out.println("\t</select>\n");  
    }else{
      out.println("\t<select name='f_contrib_funct_id' class='line200'>\n");
      out.println("\t\t<option value=''>No Contributor Function found.</option>\n");
      out.println("\t</select>\n"); 
    }
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "");
  
    out.println("\t<input type='button' value='Select' onclick=\"addtoSelected();\">\n");
    pageFormater.writeTwoColTableFooter (out); 
    
    pageFormater.writeTwoColTableHeader (out, "Selected Contributor Function");
    out.println("\t<select name='f_contrib_funct_ids' class='line200' size='6'>\n");
    ausstage.Contributor cont = new ausstage.Contributor(db_ausstage);
    for( int i =0; i < selectedItems.size(); i++){
      rset = cont.getContFunctPreff(Integer.parseInt(selectedItems.elementAt(i).toString()));
      rset.next();
      out.println("\t\t<option value='" + rset.getString("ContributorFunctPreferredId") + "'>" +   rset.getString("PREFERREDTERM") +"</option>\n"); 
    }
    out.println("\t</select>\n"); 
    pageFormater.writeTwoColTableFooter (out); 
  %>
    <input type="hidden" name="delimited_contrib_funct_ids" value="<%=contrib_funct_ids%>">
  <%
   hidden_fields.put("act", action);
  //CODE ADDED FOR CONTRIBUTOR EDUCATIONAL INSTITUTION BY BTW 5-6-2006
  out.println("<a name='contrib_org'></a>");
  out.println (htmlGenerator.displayLinkedItem("",
                                                "",
                                                // "contrib_org.jsp?act=AddForEventContributor",
                                                "contrib_org.jsp",
                                                "f_contributor_addedit",
                                                hidden_fields,
                                                "Educational Organisations",
                                                selectedOrgs,
                                                1000,
                                                "if (!checkFields()) { return false; }; ",
                                                false));
  
  /***************************
   Contributor Association/s
  ****************************/
	
  out.println("<a name='contrib_contrib_link'></a>");
  pageFormater.writeHelper(out, "Contributor Association/s", "helpers_no2.gif");
  hidden_fields.clear();
  hidden_fields.put("act", action);
  
	
  out.println (htmlGenerator.displayLinkedItem("",
	        "8",
	        "contrib_contrib.jsp",
	      //  "contrib_addedit_form",
	        "f_contributor_addedit",
	        hidden_fields,
	        "Associated with Contributor(s):",
	        contributor_name_vec,
	        1000));
	       
  System.out.println("contributor_name_vec:" + contributor_name_vec);	       
    
  /***************************
       Data Entry Information
  ****************************/
  
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no3.gif");
  pageFormater.writeTwoColTableHeader(out, "Contributor ID:");
  out.print(contributor.getId());
  pageFormater.writeTwoColTableFooter(out);
  
  if (contributor.getEnteredByUser() != null && !contributor.getEnteredByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Created by User:");
    out.print(contributor.getEnteredByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Created:");
    out.print(common.formatDate(contributor.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  if (contributor.getUpdatedByUser() != null && !contributor.getUpdatedByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Updated by User:");
    out.print(contributor.getUpdatedByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Updated:");
    out.print(common.formatDate(contributor.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "/custom/welcome.jsp", "cross.gif", "submit", "next.gif");
  }
  else {
    // Dont display the contributor details for some reason, for example a contribId was not selected
    out.println("You have not selected a Contributor to view.<br>Please click the back button to return to the Contributor Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif");
  }
  pageFormater.writeFooter(out);
  
   // reset/set the state of the COntributor object 
     session.setAttribute("contributor", contributor); 
%>
  </form>

<script language="javascript">
<!--
  function addtoSelected(){
    var f_list      = document.getElementById('contrib_addedit_form').f_contrib_funct_id;
    var f_sel_list  = document.getElementById('contrib_addedit_form').f_contrib_funct_ids;
    var index       = f_list.selectedIndex;
    var sel_index   = f_sel_list.selectedIndex;
    var selected_id;
    var selected_name;
    var i = 0;
    var selected_ids = '';
    var found = false;
    
    if((index > -1 && sel_index == -1) || (index == -1 && sel_index > -1)){

      if(index > -1){                                                       
        // repository list is selected, so put it to the selected list
        selected_id   = f_list.options[index].value;
        selected_name = f_list.options[index].text;

        if(f_sel_list.options.length != 0){
          for(i= 0 ; i < f_sel_list.length; i++){
            if(f_sel_list.options[i].value == selected_id){
              found = true;
              break;
            }
          }
        }
        
        if(!found){
          selected_name = selected_name.substring(selected_name.indexOf(', ') + 2, selected_name.length);
          if(selected_name != ""){
            if(f_sel_list.options.length != 0){
              f_sel_list.options[f_sel_list.options.length] = new Option(selected_name, selected_id, false, false); // add to selected list
            }else{
              f_sel_list.options[0] = new Option(selected_name, selected_id); // add to selected list
            }
          }
        }
      }else{
        // remove from the selected list
        f_sel_list.options[sel_index] = null; 
      }
    }else{
      alert("You have not selected a Contributor Function to Add/Remove.");
    }
    
    f_list.selectedIndex     = -1;
    f_sel_list.selectedIndex = -1;
    var i =0;
    var temp_ids = '';
    var seleted_list = document.getElementById('contrib_addedit_form').f_contrib_funct_ids;
    for(i= 0; i < seleted_list.length; i++){
      if(temp_ids == '')
        temp_ids = seleted_list.options[i].value;
      else
        temp_ids += "," + seleted_list.options[i].value;
    }
    document.getElementById('contrib_addedit_form').delimited_contrib_funct_ids.value = temp_ids;
  }
  
  function checkFields(){

    var msg = "";
    if(document.f_contributor_addedit.f_f_name.value =="")
      msg += "\t- First Name\n";

    if(document.f_contributor_addedit.f_l_name.value =="")
      msg += "\t- Last Name\n";

    if(document.f_contributor_addedit.f_contrib_state.value =='')
      msg += "\t- State\n";

    if(!isBlank(document.f_contributor_addedit.f_contrib_day.value) 
      && !isInteger(document.f_contributor_addedit.f_contrib_day.value))
      msg += "\t- Date of Birth Day\n";

    if(!isBlank(document.f_contributor_addedit.f_contrib_month.value)
      && !isInteger(document.f_contributor_addedit.f_contrib_month.value))
      msg += "\t- Date of Birth Month\n";

    if(!isBlank(document.f_contributor_addedit.f_contrib_year.value)
      && !isInteger(document.f_contributor_addedit.f_contrib_year.value))
      msg += "\t- Date of Birth Year\n";

    if(!isBlank(document.f_contributor_addedit.f_contrib_postcode.value) 
      && !isInteger(document.f_contributor_addedit.f_contrib_postcode.value))
      msg += "\t- Postcode\n";
      
    if(!isBlank(document.f_contributor_addedit.f_contrib_email.value) 
      && !checkMail(document.f_contributor_addedit.f_contrib_email.value, false))
      msg += "\t- Email\n";
        
    if(msg != ""){
      alert("You have not entered the correct value(s) for\n" + msg + "Please press OK and fill in the required field(s).");
      return false;
    }else{
      var i =0;
      var temp_ids = '';
      var seleted_list = window.document.f_contributor_addedit.f_contrib_funct_ids;
    
      for(i= 0; i < seleted_list.length; i++){
        if(temp_ids == '')
          temp_ids = seleted_list.options[i].value;
        else
          temp_ids += "," + seleted_list.options[i].value;
      }

      
      return true;
    }
  }
//-->
</script>
<%
  stmt.close();
  db_ausstage.disconnectDatabase();  
%>
<cms:include property="template" element="foot" />
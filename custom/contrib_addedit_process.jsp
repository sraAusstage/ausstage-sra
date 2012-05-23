<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.*, java.util.*"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  // lets get the contfunct object that we stored in the request object on the previuos page
  //ausstage.ContributorFunction contfunct = (ausstage.ContributorFunction) request.getAttribute("f_contfunct");

  ausstage.Contributor contributor = new ausstage.Contributor(db_ausstage);
  String act       = "";
  String action    = request.getParameter("act");
  String isForItem = request.getParameter("isForItem");
  
  if (action == null) action = "";
  String process_type            = request.getParameter("process_type");
  String contrib_id              = request.getParameter("f_contrib_id");
  String contrib_prefix          = request.getParameter("f_prefix");
  String contrib_fname           = request.getParameter("f_f_name");
  String contrib_mname           = request.getParameter("f_m_name");
  String contrib_lname           = request.getParameter("f_l_name");
  String contrib_suffix          = request.getParameter("f_suffix");
  String contrib_display_name    = request.getParameter("f_display_name");
  String place_of_birth  	 = request.getParameter("f_place_of_birth");
  String place_of_death  	 = request.getParameter("f_place_of_death");
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
  String contrib_nla             = request.getParameter("f_contrib_nla");
  String contrib_dod_d           = request.getParameter("f_contrib_day_death");
  String contrib_dod_m           = request.getParameter("f_contrib_month_death");
  String contrib_dod_y           = request.getParameter("f_contrib_year_death");
  String contrib_funct_ids       = request.getParameter("delimited_contrib_funct_ids");
  String warning_check           = request.getParameter("warning_check");


  if(contrib_id == null)          {contrib_id = "";}
  if(contrib_prefix == null)      {contrib_prefix = "";}
  if(contrib_fname == null)       {contrib_fname = "";}
  if(contrib_mname == null)       {contrib_mname = "";}
  if(contrib_lname == null)       {contrib_lname = "";}
  if(contrib_suffix == null)      {contrib_suffix = "";}
  if(contrib_display_name == null) {contrib_display_name = "";}
  if(place_of_birth == null) {place_of_birth = "";}
  if(place_of_death == null) {place_of_death = "";}
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
  if(contrib_nla == null)         {contrib_nla = "";}
  if(contrib_funct_ids == null || contrib_funct_ids.equals("")) {contrib_funct_ids = "";}

  // set the members for adding or update
  contributor.setPrefix(contrib_prefix);
  contributor.setName(contrib_fname);
  contributor.setMiddleName(contrib_mname);
  contributor.setLastName(contrib_lname);
  contributor.setSuffix(contrib_suffix);
  contributor.setDisplayName(contrib_display_name);
  contributor.setPlaceOfBirth(place_of_birth);
  contributor.setPlaceOfDeath(place_of_death);
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
  contributor.setNLA(contrib_nla);
  contributor.setDodDay(contrib_dod_d);
  contributor.setDodMonth(contrib_dod_m);
  contributor.setDodYear(contrib_dod_y); 
  contributor.setContFunctIds(contrib_funct_ids);
  contributor.setEnteredByUser((String)session.getAttribute("fullUserName"));
  contributor.setUpdatedByUser((String)session.getAttribute("fullUserName"));
  //we need to post back with act=PreviewForItem attached to the
  
  
  // Setup the ConOrgLinks from the session
  contributor.setConOrgLinks(((Contributor)session.getAttribute("contributor")).getConOrgLinks());
  contributor.setContributorContributorLinks(((Contributor)session.getAttribute("contributor")).getAssociatedContributors());

  out.println("<form name='ContentForm' id='ContentForm' method='post' action='contrib_addedit_process.jsp'>");
%>
    <input type="hidden" name="act" value="<%=action%>">
    <input type="hidden" name="process_type" value="<%=process_type%>">
    <input type="hidden" name="f_contrib_id" value="<%=contrib_id%>">
    <input type="hidden" name="f_prefix" value="<%=contrib_prefix%>">
    <input type="hidden" name="f_f_name" value="<%=contrib_fname%>">
    <input type="hidden" name="f_m_name" value="<%=contrib_mname%>">
    <input type="hidden" name="f_l_name" value="<%=contrib_lname%>">
    <input type="hidden" name="f_suffix" value="<%=contrib_suffix%>">
    <input type="hidden" name="f_display_name" value="<%=contrib_display_name%>">
    <input type="hidden" name="f_place_of_birth" value="<%=place_of_birth%>">
    <input type="hidden" name="f_place_of_death" value="<%=place_of_death%>">
    <input type="hidden" name="f_contrib_other_names" value="<%=contrib_other_names%>">
    <input type="hidden" name="f_contrib_day" value="<%=contrib_dob_d%>">
    <input type="hidden" name="f_contrib_month" value="<%=contrib_dob_m%>">
    <input type="hidden" name="f_contrib_year" value="<%=contrib_dob_y%>">
    <input type="hidden" name="f_contrib_gender_id" value="<%=contrib_gender_id%>">
    <input type="hidden" name="f_contrib_nationality" value="<%=contrib_nationality%>">
    <input type="hidden" name="f_contrib_address" value="<%=contrib_address%>">
    <input type="hidden" name="f_contrib_town" value="<%=contrib_town%>">
    <input type="hidden" name="f_contrib_state" value="<%=contrib_state%>">
    <input type="hidden" name="f_contrib_postcode" value="<%=contrib_postcode%>">
    <input type="hidden" name="f_contrib_country_id" value="<%=contrib_country_id%>">
    <input type="hidden" name="f_contrib_email" value="<%=contrib_email%>">
    <input type="hidden" name="f_contrib_notes" value="<%=contrib_notes%>">
    <input type="hidden" name="f_contrib_nla" value="<%=contrib_nla%>">
    <input type="hidden" name="f_contrib_day_death" value="<%=contrib_dod_d%>">
    <input type="hidden" name="f_contrib_month_death" value="<%=contrib_dod_m%>">
    <input type="hidden" name="f_contrib_year_death" value="<%=contrib_dod_y%>">
    <input type="hidden" name="delimited_contrib_funct_ids" value="<%=contrib_funct_ids%>">
    <input type="hidden" name="warning_check" value="true"><%
    
  if(contrib_id != null && !contrib_id.equals("") && !contrib_id.equals("0"))
  {
    // set the id for update
    contributor.setId(Integer.parseInt(contrib_id));

    if(contributor.update())
      pageFormater.writeText (out,"Edit Contributor process was successful.<br>Click the tick button to continue.");
    else
      pageFormater.writeText (out,"Edit Contributor Genre process was unsuccessful.<br>Please try again later.");
      
    // Invalidate the contributor in the session
    session.setAttribute("contributor", null);

    pageFormater.writePageTableFooter (out);
    if (action.equals("AddForEvent"))
      pageFormater.writeButtons (out, "", "", "", "", "event_contributors.jsp", "tick.gif");
    else if(action.equals("ForItem"))
      pageFormater.writeButtons (out, "", "", "", "", "item_contributors.jsp?Creator=FALSE", "tick.gif");
    else if(action.equals("ForCreatorItem"))
      pageFormater.writeButtons (out, "", "", "", "", "item_contributors.jsp?Creator=TRUE", "tick.gif");
    else if(isForItem != null && !isForItem.equals("") && isForItem.equals("true"))
      pageFormater.writeButtons (out, "", "", "", "", "event_articles_add_contrib.jsp?act=PreviewForItem", "tick.gif");
    else if(process_type != null && process_type.equals("add_article"))
      pageFormater.writeButtons (out, "", "", "", "", "event_articles_add_contrib.jsp", "tick.gif");
    else if(action.equals("ForWork"))
      pageFormater.writeButtons(out, "", "", "", "", "work_contributors.jsp", "tick.gif");
    else
      pageFormater.writeButtons (out, "", "", "", "", "contrib_search.jsp", "tick.gif");
  }
  else
  {
    // add section

    // Check and give a warning if the Contributor already exists
    // If it does then a warning is given and this page is posted to itself if 
    // the user still wishes to continue.
    if (((warning_check != null && !warning_check.equals ("null") &&
        contributor.doesContributorAlreadyExist())) ||
        (((warning_check == null || warning_check.equals ("null")) &&
        !contributor.doesContributorAlreadyExist())))
    {
      // Add it
      if (contributor.add())
      {
        out.println("Add Contributor process was successful.");
        pageFormater.writePageTableFooter (out);
        if (action.equals("AddForEvent"))
          pageFormater.writeButtons (out, "", "", "", "", "event_contributors.jsp", "tick.gif");
        else if(action.equals("ForItem"))
          pageFormater.writeButtons (out, "", "", "", "", "item_contributors.jsp?Creator=FALSE", "tick.gif");
        else if(action.equals("ForCreatorItem"))
          pageFormater.writeButtons (out, "", "", "", "", "item_contributors.jsp?Creator=TRUE", "tick.gif");
        else if(isForItem != null && !isForItem.equals("") && isForItem.equals("true"))
          pageFormater.writeButtons (out, "", "", "", "", "event_articles_add_contrib.jsp?act=PreviewForItem", "tick.gif");
        else if(process_type != null && process_type.equals("add_article"))
          pageFormater.writeButtons (out, "", "", "", "", "event_articles_add_contrib.jsp?f_id=" + Integer.toString(contributor.getId()), "tick.gif");
        else if(action.equals("ForWork"))
          pageFormater.writeButtons(out, "", "", "", "", "work_contributors.jsp", "tick.gif");
        else
          pageFormater.writeButtons (out, "", "", "", "", "contrib_search.jsp", "tick.gif");
        
        // Invalidate the contributor in the session
        session.setAttribute("contributor", null);
      }
      else
      {
        pageFormater.writeText (out,"Add Contributor process was unsuccessful. There may already be a Contributor with that name.");
        pageFormater.writePageTableFooter (out);
        pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");
      }
    }
    else
    {
      // Give warning
      pageFormater.writeText (out,"A Contributor with that first and last name already exists. If you still wish to add this Contributor please press the next button.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "Javascript:ContentForm.submit();", "next.gif");
    }
  }
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
</form>
<cms:include property="template" element="foot" />
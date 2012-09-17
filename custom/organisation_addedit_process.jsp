<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, ausstage.Organisation"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin   login           = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  ausstage.Organisation organisationObj = new ausstage.Organisation (db_ausstage);
  ausstage.State        stateObj        = new ausstage.State (db_ausstage);
  String                organisation_id;
  CachedRowSet          rset;
  boolean               error_occurred = false;
  String action = request.getParameter("act");
  if (action==null)action="";
  
  String creator;
  if (action.contains("Creator")){
  	creator = "true";
  } else creator = "false";
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  
  organisation_id = request.getParameter ("f_org_id");
  
//if editing set the object to the selected record
  if (session.getAttribute("organisationObj") != null) {
	  organisationObj = (Organisation) session.getAttribute("organisationObj");
	  organisationObj.setDb(db_ausstage);
	  //System.out.println("the org's id: " + organisationObj.getId());
  } else if (organisation_id != null && !organisation_id.equals ("") && !organisation_id.equals ("null")) {
	  organisationObj = new Organisation(db_ausstage);
	  organisationObj.load (Integer.parseInt(organisation_id));
  }

  organisationObj.setName(request.getParameter("f_organisation_name"));
  organisationObj.setOtherNames1(request.getParameter("f_other_names1"));
  organisationObj.setOtherNames2(request.getParameter("f_other_names2"));
  organisationObj.setOtherNames3(request.getParameter("f_other_names3"));
  organisationObj.setAddress(request.getParameter("f_org_address"));
  organisationObj.setSuburb(request.getParameter("f_org_suburb"));
  organisationObj.setState(request.getParameter("f_org_state_id"));
  organisationObj.setPostcode(request.getParameter("f_postcode"));
  organisationObj.setContact(request.getParameter("f_contact"));
  organisationObj.setPhone1(request.getParameter("f_phone1"));
  organisationObj.setPhone2(request.getParameter("f_contact_phone2"));
  organisationObj.setPhone3(request.getParameter("f_contact_phone3"));
  organisationObj.setFax(request.getParameter("f_fax"));
  organisationObj.setEmail(request.getParameter("f_email"));
  organisationObj.setWebLinks(request.getParameter("f_web_links"));
  organisationObj.setCountry(request.getParameter("f_country"));
  organisationObj.setOrganisationType(request.getParameter("f_organisation_type"));
  organisationObj.setNotes(request.getParameter("f_notes"));
  organisationObj.setDdfirstDate(request.getParameter("f_first_date_day"));
  organisationObj.setMmfirstDate(request.getParameter("f_first_date_month"));
  organisationObj.setYyyyfirstDate(request.getParameter("f_first_date_year"));
  organisationObj.setDdlastDate(request.getParameter("f_last_date_day"));
  organisationObj.setMmlastDate(request.getParameter("f_last_date_month"));
  organisationObj.setYyyylastDate(request.getParameter("f_last_date_year"));
  organisationObj.setPlaceOfOrigin(request.getParameter("f_place_of_origin"));
  organisationObj.setPlaceOfDemise(request.getParameter("f_place_of_demise"));
  organisationObj.setNLA(request.getParameter("f_nla"));
  organisationObj.setEnteredByUser((String)session.getAttribute("fullUserName"));
  organisationObj.setUpdatedByUser((String)session.getAttribute("fullUserName"));

  
  // if editing
  if (organisation_id != null && !organisation_id.equals ("") && !organisation_id.equals ("null") && !organisation_id.equals("0"))
    error_occurred = !organisationObj.update();
  else // Adding
    error_occurred = !organisationObj.add();

  // Error
  if (error_occurred)
  {
    pageFormater.writeText (out, organisationObj.getError());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
  }
  else
  {
	    pageFormater.writeText (out, "The organisation <b>" + organisationObj.getName() + "</b> was successfully saved");
	    pageFormater.writePageTableFooter (out);
	    if(action != null && (action.equals("PreviewForItem")))
	      pageFormater.writeButtons(out, "", "", "", "", "item_organisations.jsp", "tick.gif");
	    else if (action != null && action.contains("ForEvent"))
	      pageFormater.writeButtons(out, "", "", "", "", "event_organisations.jsp", "tick.gif");
	    else if (action != null && action.contains("ForWork"))
	      pageFormater.writeButtons(out, "", "", "", "", "work_organisations.jsp", "tick.gif");
	    else if (action != null && (action.contains("ForCreatorItem")||action.contains("ForItem")))
	      pageFormater.writeButtons(out, "", "", "", "", "item_organisations.jsp?act="+action+"&f_creator="+creator, "tick.gif");
	    else
	      pageFormater.writeButtons(out, "", "", "", "", "organisation_search.jsp?act="+action, "tick.gif");
	 }

  db_ausstage.disconnectDatabase();
  pageFormater.writeFooter(out);
%>
</form>

<cms:include property="template" element="foot" />
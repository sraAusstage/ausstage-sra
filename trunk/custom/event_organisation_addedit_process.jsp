<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
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

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  
  String action = request.getParameter("act");
  if (action == null) action = "";
  
  organisation_id = request.getParameter ("f_id");
  
  // if editing set the object to the selected record
  if (organisation_id != null && !organisation_id.equals ("") && !organisation_id.equals ("null"))
    organisationObj.load (Integer.parseInt(organisation_id));

  organisationObj.setName(request.getParameter("f_orgname"));
  organisationObj.setOtherNames1(request.getParameter("f_other_name1"));
  organisationObj.setOtherNames2(request.getParameter("f_other_name2"));
  organisationObj.setOtherNames3(request.getParameter("f_other_name3"));
  organisationObj.setAddress(request.getParameter("f_address"));
  organisationObj.setSuburb(request.getParameter("f_suburb"));
  organisationObj.setState(request.getParameter("f_orgstate"));
  organisationObj.setPostcode(request.getParameter("f_postcode"));
  organisationObj.setContact(request.getParameter("f_contact"));
  organisationObj.setPhone1(request.getParameter("f_contact_phone1"));
  organisationObj.setPhone2(request.getParameter("f_contact_phone2"));
  organisationObj.setPhone3(request.getParameter("f_contact_phone3"));
  organisationObj.setFax(request.getParameter("f_contact_fax"));
  organisationObj.setEmail(request.getParameter("f_contact_email"));
  organisationObj.setWebLinks(request.getParameter("f_web_link"));
  organisationObj.setCountry(request.getParameter("f_country"));
  organisationObj.setNotes(request.getParameter("f_notes"));

  // if editing
  if (organisation_id != null && !organisation_id.equals ("") && !organisation_id.equals ("null")){
    error_occurred = !organisationObj.update();
    System.out.println("in org update. notes=" + organisationObj.getNotes());
  }
  else // Adding
    error_occurred = !organisationObj.add();

  // Error
  if (error_occurred)
    pageFormater.writeText (out,organisationObj.getError());
  else
    pageFormater.writeText (out,"The organisation <b>" + organisationObj.getName() + "</b> was successfully saved");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);

  if (error_occurred)
    pageFormater.writeButtons(out, "BACK", "prev.gif", "", "", "", "");
  else
      if (action.equals("AddForEvent"))
        pageFormater.writeButtons (out, "", "", "", "", "event_organisations.jsp", "tick.gif");
      else if (action.equals("Preview/EditForEvent")){
        pageFormater.writeButtons (out, "", "", "", "", "event_organisations.jsp?f_organisation_id=" + organisation_id + "&setOrgEvLink=true", "tick.gif");
      }
      else
        pageFormater.writeButtons(out, "", "", "", "", "organisation_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
%>
</form>
<cms:include property="template" element="foot" />
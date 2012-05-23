<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.Event, ausstage.OrgEvLink, ausstage.Organisation"%>
<%@ page import= "ausstage.ContFunctPref"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Event  eventObj    = (Event)session.getAttribute("eventObj");
  String eventid     = eventObj.getEventid();

	Vector        orgEvLinks    = eventObj.getOrgEvLinks();
  OrgEvLink     orgEvLink     = null;
  Organisation  organisation  = null;
  ContFunctPref contFunctPref = new ContFunctPref(db_ausstage);
  
	String functionId           = "";
	String functionDesc         = "";
	String conFunctionId        = "";
  String conFunctionDesc      = "";
	String artisticFunctionDesc = "";

  String warning_msg = "";
  String error_msg   = "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

// If we have returned here from this form then get the request details.

  for(int i=0; i < orgEvLinks.size(); i++)
  {
    orgEvLink    = (OrgEvLink)orgEvLinks.get(i);
    organisation = orgEvLink.getOrganisationBean();
    // get data from the request object

    // if functionId != None and conFunctionId != None as well - then error message

    functionId   = request.getParameter("f_function_id_" + i);
    functionDesc = request.getParameter("f_function_name_" + i);

    conFunctionId = request.getParameter("f_con_function_id_" + i);
    conFunctionDesc = request.getParameter("f_function_name_" + i);

    // cases that can not happen:
    // both function and con function as 0
    // both function and con function not 0
    if (functionId.equals("0") && conFunctionId.equals("0")){
      error_msg = "Each Organisation must have a Function or Artistic Function selected";
    } else if (!functionId.equals("0") && !conFunctionId.equals("0")){
      error_msg = "An Organisation cannot have a Function and Artistic Function selected";
    }
    
    if (error_msg.equals("")) {
      orgEvLink.setFunction(functionId);
      orgEvLink.setFunctionDesc(functionDesc);
      orgEvLinks.set(i, orgEvLink);

      contFunctPref.load(conFunctionId);
      artisticFunctionDesc = contFunctPref.getPreferredTerm();
      orgEvLink.setArtisticFunction(conFunctionId);
      orgEvLink.setArtisticFunctionDesc(artisticFunctionDesc);
      orgEvLinks.set(i, orgEvLink);
  
      for(int j=0; j < i; j++) // Make sure the user hasn't entered any duplicate OrgEvLinks.
      {
        if (orgEvLink.sameOrganisationAndFunction((OrgEvLink)orgEvLinks.get(j)))
          warning_msg = "Warning: Duplicate Organisation Links.";
      }
      if (error_msg.length() == 0)
        orgEvLinks.set(i, orgEvLink);
      
    }
  }

  if(error_msg.equals(""))
  {
		eventObj.setOrgEvLinks(orgEvLinks);
		session.setAttribute("eventObj", eventObj);
    if (warning_msg.length() == 0)
      pageFormater.writeText (out, "Organisation Link Properties process successful.");
    else
      pageFormater.writeText (out, warning_msg);
  }
  else
  {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  if (error_msg.equals("")) {
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "event_addedit.jsp#event_organisations", "tick.gif");
  }
  else {
    pageFormater.writeButtons (out, "BACK", "prev.gif");
  }
  

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />
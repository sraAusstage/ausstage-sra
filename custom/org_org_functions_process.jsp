<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.OrganisationOrganisationLink, ausstage.Organisation"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Organisation   organisationObj       = (Organisation)session.getAttribute("organisationObj");
  //System.out.println("Organisation Object:" + organisationObj);
  //String organisationId        =request.getParameter("f_organisation_id");
  String organisationId        = Integer.toString(organisationObj.getId());
  //System.out.println("Organisation Id:" + organisationId);
  Vector organisationOrganisationLinks = organisationObj.getAssociatedOrganisations();
  Vector tempOrganisationOrganisationLinks = new Vector();
  String error_msg   = "";
  String functionId   = "";
  String notes        = "";
  String childOrganisationId  = "";

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
    for(int i=0; i < organisationOrganisationLinks.size(); i++) {
      OrganisationOrganisationLink organisationOrganisationLink = new OrganisationOrganisationLink(db_ausstage);
      // get data from the request object
      childOrganisationId = request.getParameter("f_child_organisation_id_" + i);
      System.out.println("Child Id:" +childOrganisationId);
      functionId  = request.getParameter("f_function_lov_id_" + i);
      notes       = request.getParameter("f_notes_" + i);

      organisationOrganisationLink.setChildId(childOrganisationId);
      organisationOrganisationLink.setFunctionLovId(functionId);
      organisationOrganisationLink.setNotes(notes);

      //if (error_msg.length() == 0)
      //BW organisationOrganisationLinks.set(i, organisationOrganisationLink);
      tempOrganisationOrganisationLinks.insertElementAt(organisationOrganisationLink, i);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Organisation to organisation links process NOT successful.";
  }

  if(error_msg.equals("")) {
		//organisationObj.setOrgOrgLinks(organisationOrganisationLinks);
		//session.setAttribute("organisation", organisationObj);
     pageFormater.writeText(out, "Organisation to organisation process successful.");
  }
  else {
     pageFormater.writeText(out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "organisation_addedit.jsp#organisation_organisation_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
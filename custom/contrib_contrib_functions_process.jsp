<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.ContributorContributorLink, ausstage.Contributor"%>
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

  Contributor   contributorObj       	= (Contributor)session.getAttribute("contributor");
  System.out.println("Contributor Object:" + contributorObj);
  //String contributorId = request.getParameter("f_contributor_id");
  String contributorId        	= Integer.toString(contributorObj.getId());
  System.out.println("Contributor Id:" + contributorId);
  Vector contributorContributorLinks 	= contributorObj.getAssociatedContributors();
  Vector tempContributorContributorLinks = new Vector();
  String error_msg   		= "";
  String functionId   		= "";
  String notes        		= "";
  String childContributorId  		= "";
  //System.out.println("Child Id:" + request.getParameter("f_child_contributor_id_"));

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	for(int i=0; i < contributorContributorLinks.size(); i++) {
	    ContributorContributorLink contributorContributorLink = new ContributorContributorLink(db_ausstage);
            // get data from the request object
     	    childContributorId = request.getParameter("f_child_contributor_id_" + i);
     	    System.out.println("Child Id:" +childContributorId );
	    functionId  = request.getParameter("f_function_lov_id_" + i);
      	    notes       = request.getParameter("f_notes_" + i);

	    contributorContributorLink.setChildId(childContributorId);
	    contributorContributorLink.setFunctionLovId(functionId);
	    contributorContributorLink.setNotes(notes);

	    //if (error_msg.length() == 0)
	    // BW contributorContributorLinks.set(i, contributorContributorLink);
	   //tempContributorContributorLinks.set(i, contributorContributorLink);
	    tempContributorContributorLinks.insertElementAt(contributorContributorLink, i);
    }
  }
  catch(Exception e) {
    
    error_msg = "Error: Resource to resource links process NOT successful." +e.toString();
  }

  if(error_msg.equals("")) {
		// BW contributorObj.setContributorContributorLinks(contributorContributorLinks);
		//contributorObj.setContributorContributorLinks(tempContributorContributorLinks);
		//session.setAttribute("contributor", contributorObj);
   pageFormater.writeText (out, "Contributor to contributor process successful.");

  }
  else {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "contrib_addedit.jsp#contributor_contributor_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
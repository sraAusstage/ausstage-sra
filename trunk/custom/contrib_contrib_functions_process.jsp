<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ page import="java.sql.Statement,sun.jdbc.rowset.CachedRowSet,java.util.*"%>
<%@ page import="ausstage.ContributorContributorLink,ausstage.Contributor"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import="ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
	ausstage.Database db_ausstage = new ausstage.Database();
	db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

	Contributor contributorObj = (Contributor) session.getAttribute("contributor");
	String contributorId = Integer.toString(contributorObj.getId());
	Vector<ContributorContributorLink> contributorContributorLinks = contributorObj.getContributorContributorLinks();
	Vector<ContributorContributorLink> tempContributorContributorLinks = new Vector<ContributorContributorLink>();
	String error_msg = "";
	String functionId = "";
	String notes = "";
	String childContributorId = "";
	
	String action = request.getParameter("act");

	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	try {
		for (int i = 0; i < contributorContributorLinks.size(); i++) {
			ContributorContributorLink contributorContributorLink = new ContributorContributorLink(db_ausstage);
			// get data from the request object
			childContributorId = request.getParameter("f_child_contributor_id_" + i);
			functionId = request.getParameter("f_function_lov_id_" + i);
			notes = request.getParameter("f_notes_"+i);
			
			contributorContributorLink.setChildId(childContributorId);
			contributorContributorLink.setFunctionLovId(functionId);
			contributorContributorLink.setNotes(notes);

			tempContributorContributorLinks.insertElementAt(contributorContributorLink, i);
		}
	} catch (Exception e) {
		error_msg = "Error: Resource to resource links process NOT successful." + e.toString();
	}

	if (error_msg.equals("")) {
		contributorObj.setContributorContributorLinks(tempContributorContributorLinks);
		session.setAttribute("contributor", contributorObj);
		System.out.println("Contrib contrib functions process setting contributor object to :"+contributorObj.getId());
		pageFormater.writeText(out, "Contributor to contributor process successful.");
	
	} else {
		pageFormater.writeText(out, error_msg);
	}

	pageFormater.writePageTableFooter(out);
	if (action.equals("PreviewForEvent")){ 
	  pageFormater.writeButtons(out, "", "", "", "", "contrib_addedit.jsp?act=" + action + "&isReturn=true#contributor_contributor_link", "next.gif");
	}
	else if (action.equals("AddForEvent")){ 
	  pageFormater.writeButtons(out, "", "", "", "", "contrib_addedit.jsp?act=" + action + "&isReturn=true#contributor_contributor_link", "next.gif");
	}
	else{
	  pageFormater.writeButtons(out, "", "", "", "", "contrib_addedit.jsp?&isReturn=true&act=" + action + "#contributor_contributor_link", "next.gif");
	}
	pageFormater.writeFooter(out);
	db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />
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
	Vector<ContributorContributorLink> contribContribLinks = contributorObj.getContributorContributorLinks();
	Vector<ContributorContributorLink> tempContribContribLinks = new Vector<ContributorContributorLink>();
	String error_msg = "";
	String functionId = "";
	String notes = "";
	String childNotes = "";
	String linkContributorId = "";
	String relationLookupId = "";
	String isParent = "";
	
	String action = request.getParameter("act");

	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	try {
		for (int i = 0; i < contribContribLinks.size(); i++) {
			ContributorContributorLink contribContribLink = new ContributorContributorLink(db_ausstage);
			// get data from the request object
			functionId = request.getParameter("f_function_lov_id_" + i);
			linkContributorId = request.getParameter("f_link_contributor_id_"+ i);
			notes = request.getParameter("f_notes_"+i);
			childNotes = request.getParameter("f_child_notes_"+i);
			
			String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);
			relationLookupId = lookupAndPerspective[0];
			//System.out.println(relationLookupId);
			isParent = lookupAndPerspective[1];
			System.out.println("* is parent = "+isParent);						
			System.out.println("** linkContributorId = "+linkContributorId);
			System.out.println("** ContributorId = "+contributorId);
			if (isParent.equals("parent")){
				contribContribLink.setChildId(linkContributorId);
				contribContribLink.setContributorId(contributorId);
				contribContribLink.setNotes(notes);
				contribContribLink.setChildNotes(childNotes);

			}
			else {
				contribContribLink.setChildId(contributorId);
				contribContribLink.setContributorId(linkContributorId);
				contribContribLink.setNotes(childNotes);
				contribContribLink.setChildNotes(notes);
			}

			contribContribLink.setRelationLookupId(relationLookupId);
			//contribContribLink.setNotes(notes);

			tempContribContribLinks.insertElementAt(contribContribLink, i);
		}
	} catch (Exception e) {
		error_msg = "Error: Resource to resource links process NOT successful." + e.toString();
	}

	if (error_msg.equals("")) {
		contributorObj.setContributorContributorLinks(tempContribContribLinks);
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
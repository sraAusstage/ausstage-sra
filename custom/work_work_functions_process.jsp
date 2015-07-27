<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ page import="java.sql.Statement,sun.jdbc.rowset.CachedRowSet,java.util.*"%>
<%@ page import="ausstage.WorkWorkLink,ausstage.Work"%>
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

	Work workObj = (Work) session.getAttribute("work");
	String workId = workObj.getWorkId();
	Vector <WorkWorkLink> workWorkLinks = workObj.getWorkWorkLinks();
	Vector <WorkWorkLink> tempWorkWorkLinks = new Vector <WorkWorkLink>();
	String isPreviewForEventWork = request.getParameter("isPreviewForEventWork");
	if (isPreviewForEventWork == null){isPreviewForEventWork = "false";}
	
	String isPreviewForItemWork = request.getParameter("isPreviewForItemWork");
	if (isPreviewForItemWork == null){isPreviewForItemWork = "false";}

	String error_msg = "";
	String relationLookupId = "";
	String notes = "";
	String childNotes = "";	
	String linkWorkId = "";
	String isParent = "";

	pageFormater.writeHeader(out);
	pageFormater.writePageTableHeader(out, "", ausstage_main_page_link);

	try {
		for (int i = 0; i < workWorkLinks.size(); i++) {
			WorkWorkLink workWorkLink = new WorkWorkLink(db_ausstage);
			// get data from the request object
			linkWorkId = request.getParameter("f_link_work_id_" + i);
			notes = request.getParameter("f_notes_" + i);
			childNotes = request.getParameter("f_child_notes_" + i);			
			
			String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);
			relationLookupId = lookupAndPerspective[0];
			isParent = lookupAndPerspective[1];

			if (isParent.equals("parent")){
				workWorkLink.setChildId(linkWorkId);
				workWorkLink.setWorkId(workId);
				workWorkLink.setNotes(notes);
				workWorkLink.setChildNotes(childNotes);			
			}
			else {
				workWorkLink.setChildId(workId);
				workWorkLink.setWorkId(linkWorkId);
				workWorkLink.setNotes(childNotes);
				workWorkLink.setChildNotes(notes);			
			}
			workWorkLink.setRelationLookupId(relationLookupId);			
			tempWorkWorkLinks.insertElementAt(workWorkLink, i);
			
		}
		
	} catch (Exception e) {
		error_msg = "Error: Resource to resource links process NOT successful.";
	}

	if (error_msg.equals("")) {
		workObj.setWorkWorkLinks(tempWorkWorkLinks);
		session.setAttribute("work", workObj);
		pageFormater.writeText(out, "Work to work process successful.");
	} else {
		pageFormater.writeText(out, error_msg);
	}

	pageFormater.writePageTableFooter(out);
	if (isPreviewForItemWork.equals("true")){
		pageFormater.writeButtons(out, "", "", "", "", "work_addedit.jsp?action=isPreviewForItemWork#work_work_link", "next.gif");
	}
	else if (isPreviewForEventWork.equals("true")){
		pageFormater.writeButtons(out, "", "", "", "", "work_addedit.jsp?action=isPreviewForEventWork#work_work_link", "next.gif");
	}
	else {
		pageFormater.writeButtons(out, "", "", "", "", "work_addedit.jsp?#work_work_link", "next.gif");
		//pageFormater.writeButtons(out, "", "", "", "", "work_addedit.jsp", "next.gif");
	}
	pageFormater.writeFooter(out);
	db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
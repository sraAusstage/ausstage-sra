<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.WorkContribLink, ausstage.Contributor, ausstage.Work"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Work   workObj       = (Work)session.getAttribute("work");
  String workId        = workObj.getWorkId();
	Vector workContribLinks ;
  String creator       = request.getParameter("Creator");
  workContribLinks= workObj.getAssociatedContributors();
    
  String error_msg   = "";
	String orderBy   = "";
  String contribId  = "";
  
  String isPreviewForItemWork  = request.getParameter("isPreviewForItemWork");
  String isPreviewForEventWork  = request.getParameter("isPreviewForEventWork");
  
  if (isPreviewForItemWork == null || isPreviewForItemWork.equals("null")) {
    isPreviewForItemWork = "";
  }
  if (isPreviewForEventWork == null || isPreviewForEventWork.equals("null")) {
    isPreviewForEventWork = "";
  }

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	  for(int i=0; i < workContribLinks.size(); i++) {
	    WorkContribLink workContribLink = new WorkContribLink(db_ausstage);
      
      // get data from the request object
      contribId = request.getParameter("f_contrib_id_" + i);
      orderBy       = request.getParameter("f_orderBy_" + i);

      workContribLink.setContribId(contribId);
      workContribLink.setOrderBy(orderBy);

      /*for(int j=0; j < i; j++) // Make sure the user hasn't entered any duplicate ConEvLinks.
      {
        if (conEvLink.sameContributorAndFunction((ConEvLink)conEvLinks.get(j)))
          warning_msg = "Warning: Duplicate Contributor Links.";
      }*/
      //if (error_msg.length() == 0)
      workContribLinks.set(i, workContribLink);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Work to Contributor links process NOT successful.";
  }

  if(error_msg.equals("")) {

    workObj.setWorkConLinks(workContribLinks);

      
		session.setAttribute("work", workObj);
    pageFormater.writeText (out, "Work to Contributor process successful.");
  }
  else {
    pageFormater.writeText (out, error_msg);
  }


  pageFormater.writePageTableFooter (out);
  if(isPreviewForItemWork.equals("true")){
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp?action=ForItemForWork#work_contributors_link", "next.gif");
  }
  else if (isPreviewForEventWork.equals("true")) {
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp?action=ForEventForWork#work_contributors_link", "next.gif");  
  }else{
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp#work_contributors_link", "next.gif");
  }
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />
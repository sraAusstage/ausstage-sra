<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.WorkOrganLink, ausstage.Organisation, ausstage.Work"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Work   workObj       = (Work)session.getAttribute("work");
  String workId        = workObj.getWorkId();
  Vector workOrganLinks       = workObj.getAssociatedOrganisations();
  
  String isPreviewForItemWork  = request.getParameter("isPreviewForItemWork");
  String isPreviewForEventWork  = request.getParameter("isPreviewForEventWork");
    
  if (isPreviewForItemWork == null || isPreviewForItemWork.equals("null")) {
    isPreviewForItemWork = "";
  }
  if (isPreviewForEventWork == null || isPreviewForEventWork.equals("null")) {
    isPreviewForEventWork = "";
  }
    
  String error_msg = "";
	String orderBy   = "";
  String organId   = "";
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	  for(int i=0; i < workOrganLinks.size(); i++) {
	    WorkOrganLink workOrganLink = new WorkOrganLink(db_ausstage);
      
      // get data from the request object
      organId = request.getParameter("f_organ_id_" + i);
      orderBy       = request.getParameter("f_orderBy_" + i);

      workOrganLink.setOrganId(organId);
      workOrganLink.setOrderBy(orderBy);

      /*for(int j=0; j < i; j++) // Make sure the user hasn't entered any duplicate ConEvLinks.
      {
        if (conEvLink.sameContributorAndFunction((ConEvLink)conEvLinks.get(j)))
          warning_msg = "Warning: Duplicate Contributor Links.";
      }*/
      //if (error_msg.length() == 0)
      workOrganLinks.set(i, workOrganLink);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Work to Organisation links process NOT successful.";
  }

  if(error_msg.equals("")) {
    workObj.setWorkOrgLinks(workOrganLinks);      
		session.setAttribute("work", workObj);
    pageFormater.writeText (out, "Work to Organisation process successful.");
  }
  else {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
    
  if(isPreviewForItemWork.equals("true")){
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp?action=ForItemForWork#work_organisation_link", "next.gif");
  }
  else if (isPreviewForEventWork.equals("true")) {
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp?action=ForEventForWork#work_organisation_link", "next.gif");  
  }else{
    pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp#work_contributors_link", "next.gif");
  }
  
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><jsp:include page="../templates/admin-footer.jsp" />
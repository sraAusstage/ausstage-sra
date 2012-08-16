<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.*"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  String delimeted_data_sources_ids = request.getParameter("f_delimeted_organisations_ids");
  String description = "";
  String error_msg = "";
  String isPreviewForEvent = request.getParameter("isPreviewForEvent");
  String isPreviewForItem  = request.getParameter("isPreviewForItem");
  String isPreviewForCreatorItem  = request.getParameter("isPreviewForCreatorItem");
  String isPreviewForWork  = request.getParameter("isPreviewForWork");
  String action            = request.getParameter("act");
  
  if (isPreviewForEvent != null && !isPreviewForEvent.equals("null") && !isPreviewForEvent.equals("")) {
    action = "PreviewForEvent";
  }
  else if (isPreviewForItem != null && !isPreviewForItem.equals("null") && !isPreviewForItem.equals("")) {
    action = "ForItem";
  }
  else if (isPreviewForCreatorItem != null && !isPreviewForCreatorItem.equals("null") && !isPreviewForCreatorItem.equals("")) {
    action = "ForCreatorItem";
  }
  else if (isPreviewForWork != null && !isPreviewForWork.equals("null") && !isPreviewForWork.equals("")) {
    action = "ForWork";
  }

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);



  // get the CONTRIBUTOR object from session
  ausstage.Contributor contributor = new ausstage.Contributor(db_ausstage);
  contributor = (ausstage.Contributor) session.getAttribute("contributor");

  // use vector to handle the objects
  Vector newConOrgLinks = contributor.getConOrgLinks();
  
  try{
    for(int i = 0; i < newConOrgLinks.size(); i++){  
      // create new ConOrgLink
      ConOrgLink conOrgLink = (ConOrgLink)newConOrgLinks.elementAt(i);
      description = request.getParameter("f_organisation_desc_" + i);
      
      if (description == null) {
        description = "";
      }
      
      if (description.length() > 100) {
        description = description.substring(0, 99);
      }
      
      conOrgLink.setDescription(description);
    }
  }catch(Exception e){
    error_msg = "Organisation and Contributor linking was unsuccessful.<br>Click the tick button to continue.";
  }

  if(error_msg.equals("")){
    session.setAttribute("contributor",contributor);
    pageFormater.writeText (out,"Organisation and Contributor linking was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out,error_msg);
  }
  if (action.equals("AddForEventContributor")){
  	action = "AddForEvent";
  }
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "contrib_addedit.jsp?isReturn=true&act=" + action + "#contrib_org", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();


  

%>

<cms:include property="template" element="foot" />
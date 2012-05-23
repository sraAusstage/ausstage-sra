<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  ausstage.Contributor contributor = new ausstage.Contributor(db_ausstage);
  
  String contributorid = request.getParameter("f_contributor_id");
  String process_type  = request.getParameter("process_type");
  String action        = request.getParameter("act"); 

  if(action == null)
    action = "";
    
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // set the id state of the object here
  contributor.setId(Integer.parseInt(contributorid));

  if(contributor.delete()){
    if(contributor.isInUse())
      //out.println("Could not delete Contributor because it has an<br>association with Event!.<br>Click the tick button to continue.");
      pageFormater.writeText (out,"Could not delete Contributor because it has an<br>association with Event!.<br>Click the tick button to continue.");
    else
     // out.println("Delete Contributor process was successful.<br>Click the tick button to continue.");
     pageFormater.writeText (out,"Delete Contributor process was successful.<br>Click the tick button to continue.");
  }else{
   // out.println("Delete Contributor process was unsuccessful.<br>Please try again later.");
    pageFormater.writeText (out,"Delete Contributor process was unsuccessful.<br>Please try again later.");
  }

  pageFormater.writePageTableFooter (out);
  if(process_type != null && process_type.equals("add_article"))
    pageFormater.writeButtons (out, "", "", "", "", "event_articles_add_contrib.jsp?act="+ action, "tick.gif");
  else
    pageFormater.writeButtons (out, "", "", "", "", "contrib_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%><cms:include property="template" element="foot" />
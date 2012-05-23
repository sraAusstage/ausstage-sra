<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Work"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin   login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Work                  work            = null;            
  boolean               error_occurred  = false;
  CachedRowSet          rset;
  String                workid;
  String                action          = request.getParameter("action");

  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
    
  //get the work object out of the session.
  work = (Work)session.getAttribute("work");
  //The entered user is only set on insert and the updated user is only updated on update. This is controlled in the work.java
  work.setEnteredByUser((String)session.getAttribute("fullUserName"));
  work.setUpdatedByUser((String)session.getAttribute("fullUserName"));
  
  // Update with new data from form
  work.setWorkAttributes(request);  
  
  
  workid = request.getParameter ("f_workid");

  if (workid == null || workid.equals("0") || workid.equals("null")){
    //therefore adding a work, no id has been assigned yet.
    workid = "-1";
  }
  
  session.setAttribute("work", work);
  work.setDatabaseConnection(db_ausstage); // Refresh connection

  // adding a work
  if (workid.equals ("-1"))
  {
    error_occurred = !work.addWork();
  }
  //deleting a work
  else if(action != null && !action.equals("") && action.equals("delete")){
    error_occurred = !work.deleteWork();
  }
  else // Editing a work
  {
    if(action != null && !action.equals("") && action.equals("copy"))
      error_occurred = !work.addWork();
    else
      error_occurred = !work.updateWork();
  }

  // Error
  if (error_occurred){
    out.println (work.getErrorMessage());
  }
  else{
    if(action != null && !action.equals("") && action.equals("delete"))
      pageFormater.writeText(out,"The work with a title of <b>" + work.getWorkTitle() +
                   "</b> was successfully deleted");
    else
      pageFormater.writeText(out,"The work with a title of <b>" + work.getWorkTitle() +
                   "</b> was successfully saved");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (error_occurred)
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");  
  else if (action != null && action.equals("ForItem") )
    pageFormater.writeButtons (out, "", "", "", "", "item_work.jsp", "tick.gif");
  else if (action != null && action.equals("ForEvent") )
    pageFormater.writeButtons (out, "", "", "", "", "event_work.jsp", "tick.gif");
  else
    pageFormater.writeButtons(out, "", "", "", "", "work_search.jsp", "tick.gif");
  
  pageFormater.writeFooter(out);
%>
</form>

<cms:include property="template" element="foot" />
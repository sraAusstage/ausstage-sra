<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  String secondcontentindid = request.getParameter("f_selected_second_content_ind_id");
  
  if(secondcontentindid == null || secondcontentindid.equals("")){
    // return back to the search page
    
    out.println("You have not selected a Secondary Subject to delete.<br>Please click the back button to return to the Secondary Subjects Search page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "second_content_ind_search.jsp", "prev.gif", "", "", "", "");  

  }else{

    ausstage.AusstageInputOutput secondary_content_ind = new ausstage.SecondaryContentInd(db_ausstage);
    secondary_content_ind.load(Integer.parseInt(secondcontentindid));
    
    if(secondary_content_ind.isInUse()){
      pageFormater.writeText (out,"Can not delete <b>" + secondary_content_ind.getName() + "</b> because it has an association with the Events table!.<br>Click the back button to continue.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "second_content_ind_search.jsp", "prev.gif", "", "", "", "");
    }else{
      // write the confirmation message
      pageFormater.writeText (out,"Are you sure you want to delete the <b>" + secondary_content_ind.getName() + "</b> secondary Subject?");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "second_content_ind_search.jsp", "cross.gif", "second_content_ind_del_confirm_process.jsp?f_secondcontentindid=" + secondcontentindid , "tick.gif");
    }
  }

  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />

<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  ausstage.AusstageInputOutput primary_genre = new ausstage.PrimaryGenre(db_ausstage);
  
  String primarygenreid = request.getParameter("f_primarygenreid");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  // set the id state of the object here
  primary_genre.setId(Integer.parseInt(primarygenreid));
  
  if(primary_genre.delete()){
    if(primary_genre.isInUse())
      pageFormater.writeText (out, "Could not delete Primary Genre because it has an association with the Events table!.<br>Click the tick button to continue.");
    else
      pageFormater.writeText (out, "Delete Primary Genre process was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out, "Delete Primary Genre process was unsuccessful.<br>Please try again later.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "primary_genre_list.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%>

<cms:include property="template" element="foot" />
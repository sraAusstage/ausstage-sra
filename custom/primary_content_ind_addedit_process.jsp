<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  int primaryindid             = 0;
  String primarycontentind   = request.getParameter("f_primary_content_ind");
  String primarycontentinddesc = request.getParameter("f_primarycontentinddesc");
  
  ausstage.AusstageInputOutput primary_content_ind = new ausstage.PrimaryContentInd(db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(primarycontentinddesc == null)
    primarycontentinddesc = "";

  if(request.getParameter("f_primary_cont_ind_id") != null && !request.getParameter("f_primary_cont_ind_id").equals("")){
    primaryindid = Integer.parseInt(request.getParameter("f_primary_cont_ind_id"));

    // load some data to its members
    primary_content_ind.load(primaryindid);

    // modify the state of the obejct  
    primary_content_ind.setName(primarycontentind);
    primary_content_ind.setDescription(primarycontentinddesc);

    // edit the database
    if(primary_content_ind.update()){
      pageFormater.writeText (out, "Edit Subject was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Edit Subject process was unsuccessful.<br>Please make sure that you are not duplicating another entry.");
    }
  }else{
    // set the state of the obejct  
    primary_content_ind.setName(primarycontentind);
    primary_content_ind.setDescription(primarycontentinddesc);

    // add into the database
    if(primary_content_ind.add()){
      pageFormater.writeText (out, "Add Subject was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out, "Add Subject was unsuccessful.<br>Please make sure that you are not adding a duplicate.");
    }
  }
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "primary_content_ind_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>

<cms:include property="template" element="foot" />
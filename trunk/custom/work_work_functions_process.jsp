<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.WorkWorkLink, ausstage.Work"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Work   workObj       	= (Work)session.getAttribute("work");
  //System.out.println("Work Object:" + workObj);
  //String workId = request.getParameter("f_work_id");
  String workId        	= workObj.getWorkId();
  //System.out.println("Work Id:" + workId        	);
  Vector workWorkLinks 	= workObj.getAssociatedWorks();
  Vector tempWorkWorkLinks 	= new Vector();
  String error_msg   		= "";
  String functionId   		= "";
  String notes        		= "";
  String childWorkId  		= "";
  //System.out.println("Child Id:" + request.getParameter("f_child_work_id_"));

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  try {
	for(int i=0; i < workWorkLinks.size(); i++) {
	    WorkWorkLink workWorkLink = new WorkWorkLink(db_ausstage);
            // get data from the request object
     	    childWorkId = request.getParameter("f_child_work_id_" + i);
     	    //System.out.println("Child Id:" +childWorkId );
	    functionId  = request.getParameter("f_function_lov_id_" + i);
      	    notes       = request.getParameter("f_notes_" + i);

	    workWorkLink.setChildId(childWorkId);
	    workWorkLink.setFunctionLovId(functionId);
	    workWorkLink.setNotes(notes);

	    //if (error_msg.length() == 0)
	    // BW  workWorkLinks.set(i, workWorkLink);
	    tempWorkWorkLinks.insertElementAt(workWorkLink, i);
    }
  }
  catch(Exception e) {
    error_msg = "Error: Resource to resource links process NOT successful.";
  }

  if(error_msg.equals("")) {
		//workObj.setWorkWorkLinks(workWorkLinks);
		//session.setAttribute("work", workObj);
    pageFormater.writeText (out, "Work to work process successful.");
  }
  else {
    pageFormater.writeText (out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "work_addedit.jsp#work_work_link", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
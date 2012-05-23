<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
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

  String cont_funct         = request.getParameter("f_contrib_funct");
  String desc               = request.getParameter("f_desc");
  String exist_pref_term_id = request.getParameter("f_existing_pref_term");
  String new_pref_term      = request.getParameter("f_new_pref_term");
  String pref_term_opt      = request.getParameter("f_pref_term");
  String cont_funct_id      = request.getParameter("f_cont_funct_id");

  // lets get the contfunct object that we stored in the request object on the previuos page
  //ausstage.ContributorFunction contfunct = (ausstage.ContributorFunction) request.getAttribute("f_contfunct");

  ausstage.AusstageInputOutput contfunct = new ausstage.ContributorFunction(db_ausstage);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(cont_funct_id != null && !cont_funct_id.equals("") && !cont_funct_id.equals("null")){
    contfunct.load(Integer.parseInt(cont_funct_id));

    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      contfunct.setPrefId(Integer.parseInt(exist_pref_term_id));
      contfunct.setNewPrefName("");
    }else{
      contfunct.setPrefId(0);
      contfunct.setNewPrefName(new_pref_term);
    }
    contfunct.setName(cont_funct);
    contfunct.setDescription(desc);

    if(contfunct.update()){
      pageFormater.writeText (out,"Edit Contributor Function process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out,"Edit Contributor Function process was unsuccessful.<br>Please try again later.");
    }
  }else{
    // add section
    
    // test the option radio button & set the object state accordingly
    if(pref_term_opt != null && pref_term_opt.equals("existing") && !exist_pref_term_id.equals("0")){
      contfunct.setPrefId(Integer.parseInt(exist_pref_term_id));
      contfunct.setNewPrefName("");
    }else{
      contfunct.setPrefId(0);
      contfunct.setNewPrefName(new_pref_term);
    }
    contfunct.setName(cont_funct);
    contfunct.setDescription(desc);

    if(contfunct.add()){
      pageFormater.writeText (out,"Add Contributor Function process was successful.<br>Click the tick button to continue.");
    }else{
      pageFormater.writeText (out,"Add Contributor Function process was unsuccessful.<br>Please try again later.");
    }
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "contrib_funct_search.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%>
<cms:include property="template" element="foot" />
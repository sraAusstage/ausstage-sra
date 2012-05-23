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
  
  Statement     stmt = db_ausstage.m_conn.createStatement();
  String        sqlString;
  CachedRowSet  rset;
  
  //String exiting_pref_term_id   = request.getParameter("f_existing_pref_term_id");
  String second_genre_pref_term = request.getParameter("f_second_genre_pref_term");
  String second_genre_id        = request.getParameter("f_second_genre_id");
  String mode                   = request.getParameter("f_mode");  
  String action                 = request.getParameter("act");

  // current data from the form to preserve the
  // state of the previous form
  String second_genre_name  = request.getParameter("f_second_genre_name");
  String second_genre_desc  = request.getParameter("f_second_genre_desc");
  String exist_pref_term_id = request.getParameter("f_existing_pref_term");
  String new_pref_term      = request.getParameter("f_new_pref_term");
  String pref_term_opt      = request.getParameter("f_pref_term");

  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(mode.equals("edit")){
    // edit
%>
    <form name="f_second_genre_editdel_pref_term" id="f_second_genre_editdel_pref_term" method="post" action="sec_genre_editdel_prefterm_process.jsp" onsubmit="return checkFields();">
<%  
    pageFormater.writeTwoColTableHeader (out, "Edit Preferred Term ");
%>
      <input class="line200" type="text" name="f_second_genre_pref_term" size="40" maxlength="300" value="<%=second_genre_pref_term%>">
<%
    pageFormater.writeTwoColTableFooter (out);
  }else{
     // delete
%>
    <form name="f_second_genre_editdel_pref_term" id="f_second_genre_editdel_pref_term" method="post" action="sec_genre_editdel_prefterm_process.jsp">
      <input type="hidden" name="f_second_genre_pref_term" value="<%=second_genre_pref_term%>">
<%     
    pageFormater.writeText (out, "You are about to delete <b>" + second_genre_pref_term + "</b> preferred term.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "BACK", "cross.gif", "", "", "SUBMIT", "next.gif");
  pageFormater.writeFooter(out);
%>
    <input type="hidden" name="f_mode" value="<%=mode%>">
    <input type="hidden" name="f_second_genre_id" value="<%=second_genre_id%>">
    <input type="hidden" name="f_existing_pref_term" value="<%=exist_pref_term_id%>">
    <input type="hidden" name="f_second_genre_name" value="<%=second_genre_name%>">
    <input type="hidden" name="f_second_genre_desc" value="<%=second_genre_desc%>">    
    <input type="hidden" name="f_new_pref_term" value="<%=new_pref_term%>">
    <input type="hidden" name="f_pref_term" value="<%=pref_term_opt%>">
    <input type="hidden" name="act" value="<%=action%>">
  </form>
<%
  stmt.close();
  db_ausstage.disconnectDatabase();
%>

<script language="javascript">
<!--
  function checkFields(){
    if(f_second_genre_editdel_pref_term.f_second_genre_pref_term.value == ""){
      alert("You must first specify a Preferred Term.");
      return(false);
    }else{
      return(true);
    }
  }
//-->
</script>

<cms:include property="template" element="foot" />
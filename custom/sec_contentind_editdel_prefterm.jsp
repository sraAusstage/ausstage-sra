<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  Statement     stmt = db_ausstage.m_conn.createStatement();
  String        sqlString;
  CachedRowSet  rset;
  
  String second_contentind_pref_term = request.getParameter("f_second_contentind_pref_term");
  String second_contentind_id        = request.getParameter("f_second_content_ind_id");
  String mode                        = request.getParameter("f_mode");  
  String action                      = request.getParameter("act");

  // current data from the form to preserve the
  // state of the previous form
  String secondcontentindname = request.getParameter("f_second_content_ind_name");
  String secondcontentinddesc = request.getParameter("f_second_content_ind_desc");
  String exist_pref_term_id   = request.getParameter("f_existing_pref_term_id");
  String new_pref_term        = request.getParameter("f_new_pref_term");
  String pref_term_opt        = request.getParameter("f_pref_term");

  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  
  if(mode.equals("edit")){
    // edit
%>
    <form name="f_second_content_ind_editdel_pref_term" id="f_second_content_ind_editdel_pref_term" method="post" action="sec_contentind_editdel_prefterm_process.jsp" onsubmit="return checkFields();">
<%  
    pageFormater.writeTwoColTableHeader (out, "Edit Preferred Term");
%>
      <input class="line200" type="text" name="f_second_content_ind_pref_term" size="10" maxlength="300" value="<%=second_contentind_pref_term%>">
<%
    pageFormater.writeTwoColTableFooter (out);
  }else{
     // delete
%>
    <form name="f_second_content_ind_editdel_pref_term" id="f_second_content_ind_editdel_pref_term" method="post" action="sec_contentind_editdel_prefterm_process.jsp">
      <input type="hidden" name="f_second_content_ind_pref_term" value="<%=second_contentind_pref_term%>">
<%     
    out.println("You are about to delete <b>" + second_contentind_pref_term + "</b> preferred term.");
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "BACK", "cross.gif", "", "", "SUBMIT", "next.gif");
  pageFormater.writeFooter(out);
%>
    <input type="hidden" name="f_mode" value="<%=mode%>">
    <input type="hidden" name="f_second_content_ind_id" value="<%=second_contentind_id%>">
    <input type="hidden" name="f_existing_pref_term" value="<%=exist_pref_term_id%>">
    <input type="hidden" name="f_second_contentind_name" value="<%=secondcontentindname%>">
    <input type="hidden" name="f_second_contentind_desc" value="<%=secondcontentinddesc%>">    
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
    if(f_second_content_ind_editdel_pref_term.second_content_ind_pref_term.value == ""){
      alert("You must first specify a Preferred Term.");
      return(false);
    }else{
      return(true);
    }
  }
//-->
</script>

<cms:include property="template" element="foot" />

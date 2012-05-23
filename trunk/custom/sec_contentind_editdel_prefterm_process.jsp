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
  String        sqlString = "";
  CachedRowSet  rset;
    
  String second_content_ind_pref_term = request.getParameter("f_second_content_ind_pref_term");
  String second_contentind_id         = request.getParameter("f_second_content_ind_id");
  String mode                         = request.getParameter("f_mode");  
  String action                       = request.getParameter("act");

  // current data from the form to preserve the
  // state of the previous form
  String second_contentind_name  = request.getParameter("f_second_contentind_name");
  String second_contentind_desc  = request.getParameter("f_second_contentind_desc");
  String exist_pref_term_id      = request.getParameter("f_existing_pref_term");
  String new_pref_term           = request.getParameter("f_new_pref_term");
  String pref_term_opt           = request.getParameter("f_pref_term");
  boolean is_error_occured       = false;
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

%>
    <form name="f_second_content_ind_editdel_pref_term" id="f_second_content_ind_editdel_pref_term" method="post" action="second_content_ind_addedit.jsp">
<%  
  if(mode.equals("edit")){
    // edit
    try{
      sqlString = "update SECCONTENTINDICATORPREFERRED set PREFERREDTERM='" + second_content_ind_pref_term + "' where SECCONTENTINDICATORPREFERREDID=" + exist_pref_term_id;
      db_ausstage.runSQL(sqlString, stmt);
    }catch(Exception e){
      System.out.println ("An Exception occured in sec_contentind_editdel_prefterm_process.jsp.");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      is_error_occured = true;
    }

    if(!is_error_occured){
      pageFormater.writeText(out, "You have successfully updated <b>" + second_content_ind_pref_term + "</b>.");
    }else{
      pageFormater.writeText(out, "An error occured while updating <b>" + second_content_ind_pref_term + "</b>. Try again later.");
    }
  }else{
    // delete 
    boolean is_in_use        = false;
    try{
      int     counter;

      sqlString = "select count (*) as counter from SECCONTENTINDICATOR " +
                  "where SECCONTENTINDICATORPREFERREDID=" + exist_pref_term_id;
      rset = db_ausstage.runSQL(sqlString, stmt);
      rset.next();
      counter = rset.getInt("counter");
        
      if(counter <= 1){
        // this is the last content indicator that is related to the preferred term
        // now check if preferred term is in use
        sqlString = "select count (*) as counter from SECCONTENTINDICATOREVLINK where " +
                    "SECCONTENTINDICATORPREFERREDID =" + exist_pref_term_id;
        rset = db_ausstage.runSQL(sqlString, stmt);
        rset.next();
        counter = rset.getInt("counter");

        if((counter <= 0) != true)        
          is_in_use = true; // can't del sec content id & pref term        
      }
        
      if(!is_in_use){
        try{
          sqlString = "delete from SECCONTENTINDICATORPREFERRED where SECCONTENTINDICATORPREFERREDID=" + exist_pref_term_id;
          db_ausstage.runSQL(sqlString, stmt);
        }catch(Exception e){
          System.out.println ("An Exception occured in sec_contentind_editdel_prefterm_process.jsp.");
          System.out.println("MESSAGE: " + e.getMessage());
          System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
          System.out.println("CLASS.TOSTRING: " + e.toString());
          System.out.println("sqlString: " + sqlString);
          is_error_occured = true;
        }
      }
    }catch(Exception e){
      System.out.println ("An Exception occured in sec_contentind_editdel_prefterm_process.jsp.");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + e.toString());
      System.out.println("sqlString: " + sqlString);
      is_error_occured = true;
    }

    if(!is_error_occured){
      if(is_in_use)
        pageFormater.writeText(out, "You can not delete <b>" + second_content_ind_pref_term + "</b> because it's currently in use.");
      else
        pageFormater.writeText(out, "You have successfully deleted <b>" + second_content_ind_pref_term + "</b>.");
    }else{
      pageFormater.writeText(out, "An error occured while deleting <b>" + second_content_ind_pref_term + "</b>. Try again later.");
    }
  }

  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
  pageFormater.writeFooter(out);
%>
    <input type="hidden" name="f_mode" value="<%=mode%>">
    <input type="hidden" name="f_selected_second_content_ind_id" value="<%=second_contentind_id%>">
    <input type="hidden" name="f_existing_pref_term" value="<%=exist_pref_term_id%>">

    <input type="hidden" name="f_second_contentind_name" value="<%=second_contentind_name%>">
    <input type="hidden" name="f_second_contentind_desc" value="<%=second_contentind_desc%>">    
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

//-->
</script>
<cms:include property="template" element="foot" />

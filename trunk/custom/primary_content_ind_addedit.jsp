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

  ausstage.AusstageInputOutput primary_content_ind = new ausstage.PrimaryContentInd(db_ausstage);
  String primary_cont_ind_id = request.getParameter("f_primary_cont_ind_id");
  String action              = request.getParameter("act");
  String primarycontentind   = "",   primarycontentinddesc = "";
  int primaryindid           = 0;

  if(action == null){action = "";}
%>
  <form name="f_primary_content_ind_addedit" id="f_primary_content_ind_addedit" method="post" action="primary_content_ind_addedit_process.jsp" onsubmit="return checkFields();">
<%
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  pageFormater.writeHelper(out, "Enter the Subject Details", "helpers_no1.gif");

  pageFormater.writeTwoColTableFooter(out);

  if(primary_cont_ind_id != null && !primary_cont_ind_id.equals("")){
    // load some data to its members
    primary_content_ind.load(Integer.parseInt(primary_cont_ind_id));
    
    // lets add the contfunct object with its current state in the request object
    //request.setAttribute("f_contfunct", contfunct);

    primaryindid   = primary_content_ind.getId();
    primarycontentind = primary_content_ind.getName();
    primarycontentinddesc = primary_content_ind.getDescription();
   // int primarygenreprefid  = primary_content_ind.getPrefId();
  
    if(primaryindid   == 0)   {primaryindid   = 0;}
    if(primarycontentind == null){primarycontentind = "";} 
    if(primarycontentinddesc == null){primarycontentinddesc = "";}
    
    //pageFormater.writeHelper(out, "Enter the Subject Details", "helpers_no1.gif");
    
    pageFormater.writeTwoColTableHeader(out, "ID");
    out.println(primaryindid);

    pageFormater.writeTwoColTableFooter(out);

    pageFormater.writeTwoColTableHeader (out, "Subjects");
  %>
    <input type="hidden" name="f_primary_cont_ind_id" value="<%=primaryindid%>">
    <input class="line200" type="text" name="f_primary_content_ind" size="40" maxlength="40" value="<%=primarycontentind%>">
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writeTwoColTableHeader (out, "Subjects Description");
  %>
    <textarea name="f_primarycontentinddesc" row="6" cols="32"><%=primarycontentinddesc%></textarea>
  <%
    pageFormater.writeTwoColTableFooter (out);
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "tick.gif");
  }else{
    if(!action.equals("")){ 
      // add section
    
      pageFormater.writeTwoColTableHeader (out, "Subjects");
%>
      <input class="line200" type="text" name="f_primary_content_ind" size="40" maxlength="40" value="">
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writeTwoColTableHeader (out, "Subjects Description");
%>
      <textarea name="f_primarycontentinddesc" row="6" cols="32"></textarea>
<%
      pageFormater.writeTwoColTableFooter (out);
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_content_ind_search.jsp", "cross.gif", "", "", "SUBMIT", "tick.gif");    
    }else{
      out.println("You have not selected a Subject to edit.<br>Please click the back button to return to the Subjects search page.");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "primary_content_ind_search.jsp", "prev.gif", "", "", "", "");  
    }
  }
  pageFormater.writeFooter(out);
%>
  </form>
<%
  db_ausstage.disconnectDatabase();
%>

<script language="javascript">
<!--
  function checkFields(){

    if(document.f_primary_content_ind_addedit.f_primary_content_ind.value == ""){
      alert("You can not continue until Content Indicator is filled in!");
      return false;
    }else{
      return true;
    }
  }
//-->
</script>


<cms:include property="template" element="foot" />
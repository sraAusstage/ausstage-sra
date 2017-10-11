<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Work, ausstage.WorkContribLink,  ausstage.Contributor, admin.Common"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  admin.Common     common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Work          workObj       = (Work)session.getAttribute("work");
  String        workId        = workObj.getWorkId();


  String isPreviewForItemWork  = request.getParameter("isPreviewForItemWork");
  String isPreviewForEventWork  = request.getParameter("isPreviewForEventWork");
  
  if (isPreviewForItemWork == null || isPreviewForItemWork.equals("null")) {
    isPreviewForItemWork = "";
  }
  
  
  
  
  
  if (isPreviewForEventWork == null || isPreviewForEventWork.equals("null")) {
    isPreviewForEventWork = "";
  }
  
	String orderBy        = "";
  Vector workContribLinks;
  workContribLinks= workObj.getAssociatedContributors();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Work Link Properties", AusstageCommon.ausstage_main_page_link);

%>
  <form action='work_contrib_functions_process.jsp ' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (workContribLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No contributors selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }
  else {%>
    <tr>
      <th class="bodytext" width="355">Selected Contributor</td>
      <th width="5">&nbsp;</td>
      <th class="bodytext" width="200">Order By *</td>
    </tr><%
    	}

      for(int i=0; i < workContribLinks.size(); i++) {
        ausstage.WorkContribLink workContribLink = (ausstage.WorkContribLink)workContribLinks.elementAt(i);
            
        // Load up the child works so that we can get the title and citation for display
        Contributor tempContributor = new Contributor(db_ausstage);
        tempContributor.load(Integer.parseInt(workContribLink.getContribId()));
    %>
    <tr>
      <td class="bodytext" valign='top'><%=tempContributor.getName() + " " + tempContributor.getLastName()%></td> <%
	  // Display all of the Functions
    out.println("<td>&nbsp;</td>");
    out.println("<td valign='top'>");
    out.println("<input type='hidden' name='f_contrib_id_" + i + "' id='f_contrib_id_" + i + "' value='" + workContribLink.getContribId() + "'>");
    
    out.println("<input type='text' name='f_orderBy_" + i + "' size='10' class='line25' maxlength='10' value=" + workContribLink.getOrderBy() + ">  &nbsp;&nbsp;</td></tr>");


  }

  out.println("</table>");

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "tick.gif");
  pageFormater.writeFooter(out);
  out.println("<input type='hidden' name='isPreviewForItemWork' value='" + isPreviewForItemWork + "'>");
  out.println("<input type='hidden' name='isPreviewForEventWork' value='" + isPreviewForEventWork + "'>");
  out.println("</form>");

%>
<script>
function validateForm() {
  // All functions must be selected
  <%
  for(int i=0; i < workContribLinks.size(); i++) {
	  out.println("if(document.getElementById('f_orderBy_" + i + "').value == null || document.getElementById('f_orderBy_" + i + "').value=='' ||  !(isInteger(document.getElementById('f_orderBy_" + i + "').value)))");
    out.println("{ ");
    out.println("alert('Please enter a valid value in all order bys'); return (false);");
    out.println("} ");
  } %>
  return (true);
}
</script>
<cms:include property="template" element="foot" />
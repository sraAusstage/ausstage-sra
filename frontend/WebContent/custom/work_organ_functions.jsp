<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Work, ausstage.WorkOrganLink,  ausstage.Organisation, admin.Common"%>
<jsp:include page="../templates/admin-header.jsp" /><%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
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
  Vector workOrganLinks;
  workOrganLinks= workObj.getAssociatedOrganisations();
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Work Link Properties", AusstageCommon.ausstage_main_page_link);

%>
  <form action='work_organ_functions_process.jsp ' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (workOrganLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No organisation selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }
  else {%>
    <tr>
      <th class="bodytext" width="355">Selected Organisation</th>
      <th width="5">&nbsp;</th>
      <th class="bodytext" width="200">Order By *</th>
    </tr><%
    	}

      for(int i=0; i < workOrganLinks.size(); i++) {
        ausstage.WorkOrganLink workOrganLink = (ausstage.WorkOrganLink)workOrganLinks.elementAt(i);
            
        // Load up the child works so that we can get the title and citation for display
        Organisation tempOrganisation = new Organisation(db_ausstage);
        tempOrganisation.load(Integer.parseInt(workOrganLink.getOrganId()));
    %>
    <tr>
      <td class="bodytext" valign='top'><%=tempOrganisation.getName()%></td> <%
	  // Display all of the Functions
    out.println("<td>&nbsp;</td>");
    out.println("<td valign='top'>");
    out.println("<input type='hidden' name='f_organ_id_" + i + "' id='f_organ_id_" + i + "' value='" + workOrganLink.getOrganId() + "'>");    
    out.println("<input type='text' name='f_orderBy_" + i + "' size='10' class='line25' maxlength='10' value=" + workOrganLink.getOrderBy() + ">  &nbsp;&nbsp;</td></tr>");

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
  for(int i=0; i < workOrganLinks.size(); i++) {
	  out.println("if(document.getElementById('f_orderBy_" + i + "').value == null || document.getElementById('f_orderBy_" + i + "').value=='' ||  !(isInteger(document.getElementById('f_orderBy_" + i + "').value)))");
    out.println("{ ");
    out.println("alert('Please enter a valid value in all order bys'); return (false);");
    out.println("} ");
  } %>
  return (true);
}
</script>
<jsp:include page="../templates/admin-footer.jsp" />
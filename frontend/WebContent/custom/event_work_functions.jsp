<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event,ausstage.Work, ausstage.WorkEvLink, admin.Common, ausstage.RelationLookup"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Works Editor") && !session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  admin.Common     common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Event          eventObj       = (Event)session.getAttribute("eventObj");
  String        eventid        = eventObj.getEventid();

  Vector<WorkEvLink> eventWorkLinks = eventObj.getWorks();

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define work link order by", AusstageCommon.ausstage_main_page_link);

%>
  <form action='event_work_functions_process.jsp' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (eventWorkLinks.size()==0) {
    // There are no worka%>
    <tr>
      <td class="bodytext" width="355"><b>No works selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }

  for(int i=0; i < eventWorkLinks.size(); i++) {

    WorkEvLink eventWorkLink = eventWorkLinks.elementAt(i);

    // Load up the work so we can get the title for display
    Work tempWork = new Work(db_ausstage);
    tempWork.load(Integer.parseInt(eventWorkLink.getWorkId()));
    %>
    <tr>
      <td class="bodytext" colspan=3> <%=tempWork.getName()%><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%
      //out.println("<input type='hidden' name='f_link_event_id_" + i + "' id='f_link_event_id_" + i + "' value='" + tempEvent.getEventid() + "'>");    
      out.println("<input type='hidden' name='f_workId_" + i + "' id='f_workId_" + i + "' value='" + tempWork.getWorkId() + "'>");    
     %>

    </td>
    </tr>
    
    

    <tr>
    	<td><b>Order By :</b></td>
    	<td><input type="text" name="f_orderby_<%=i%>" size="10" value="<%=eventWorkLink.getOrderby()%>"></td>
    </tr>

    <tr>
    	<td colspan="3">
    	 <br>
    	 <hr>
    	 <br>
    	</td>
    </tr>

<%
  }
  out.println("</table>");
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "tick.gif");
  pageFormater.writeFooter(out);
  out.println("</form>");
%>
<script>
function validateForm() {
  // All functions must be selected
}
</script><jsp:include page="../templates/admin-footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.EventEventLink, admin.Common, ausstage.LookupCode"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  admin.Common     common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Event          eventObj       = (Event)session.getAttribute("eventObj");
  String        eventid        = eventObj.getEventid();
  //System.out.println("Event Id:"+eventid        );
  Vector<EventEventLink> eventEventLinks = eventObj.getEventEventLinks();
  String functionId   = "";
  String functionDesc = "";
  String notes        = "";
  LookupCode lookUps = new LookupCode(db_ausstage);
  //CachedRowSet rsetEventFuncLookUps = lookUps.getLookupCodes("ITEM_FUNCTION");
  CachedRowSet rsetEventFuncLookUps = lookUps.getLookupCodes("EVENT_FUNCTION");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);

%>
  <form action='event_event_functions_process.jsp' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (eventEventLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No functions selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }

  for(int i=0; i < eventEventLinks.size(); i++) {
    EventEventLink eventEventLink = eventEventLinks.elementAt(i);
    
    // Load up the child events so that we can get the title and citation for display
    Event tempEvent = new Event(db_ausstage);
    tempEvent.load(Integer.parseInt(eventEventLink.getChildId()));
    %>
    <tr>
      <td class="bodytext" colspan=3><b>Editing Event:</b> <%=eventObj.getEventName()%><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%
      out.println("<input type='hidden' name='f_child_event_id_" + i + "' id='f_child_event_id_" + i + "' value='" + eventEventLinks.elementAt(i).getChildId() + "'>");
      out.println("<select name='f_function_lov_id_" + i + "' id='f_function_lov_id_" + i + "' size='1' class='line150' >");

      out.print("<option value='0'>--Select new Function--</option>");
      rsetEventFuncLookUps.beforeFirst();
      while (rsetEventFuncLookUps.next()) {
        String tempFunctionId = rsetEventFuncLookUps.getString ("code_lov_id");
        out.print("<option value='" + tempFunctionId + "'");
  
        if (eventEventLink.getFunctionId().equals(tempFunctionId)) {
          out.print(" selected");
        }
        out.print(">" + rsetEventFuncLookUps.getString ("description") + "</option>");
      }%>
      </select>*<br><br>
    </td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><b>Associated Event:</b> <%=tempEvent.getEventName()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments</b><br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%=eventEventLink.getNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
    </tr>
<%
  }
  out.println("</table>");
  rsetEventFuncLookUps.close();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "tick.gif");
  pageFormater.writeFooter(out);
  out.println("</form>");
%>
<script>
function validateForm() {
  // All functions must be selected
  <%
  for(int i=0; i < eventEventLinks.size(); i++) {
	  out.println("if (document.getElementById('f_function_lov_id_" + i + "').options [document.getElementById('f_function_lov_id_" + i + "').selectedIndex].value=='0') { alert('Please select all functions'); return (false);} ");
  } %>
  return (true);
}
</script><cms:include property="template" element="foot" />
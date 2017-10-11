<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.EventEventLink, admin.Common, ausstage.RelationLookup"%>
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

  RelationLookup relLookup = new RelationLookup(db_ausstage);

  CachedRowSet rsetEventRelLookUps = relLookup.getRelationLookups("EVENT_FUNCTION");

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
    boolean isParent = true;
    // Load up the child events so that we can get the title and citation for display
    Event tempEvent = new Event(db_ausstage);
    if (eventid.equals(eventEventLink.getEventId())){
	    tempEvent.load(Integer.parseInt(eventEventLink.getChildId()));
    } else {
    	    isParent = false;
    	    tempEvent.load(Integer.parseInt(eventEventLink.getEventId()));}
    %>
    <tr>
      <td class="bodytext" colspan=3><b>Editing Event:</b> <%=eventObj.getEventName()%><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%
      out.println("<input type='hidden' name='f_link_event_id_" + i + "' id='f_link_event_id_" + i + "' value='" + tempEvent.getEventid() + "'>");    
      //SELECT RELATIONSHIP
      out.println("<select name='f_relation_lookup_id_" + i + "' id='f_relation_lookup_id_" + i + "' size='1' class='line150' >");
      out.print("<option value='0'>--Select new Relation--</option>");
      rsetEventRelLookUps.beforeFirst();
      //LOOP RELATIONSHIP TYPES
      while (rsetEventRelLookUps.next()) {
        String tempRelationId = rsetEventRelLookUps.getString ("relationlookupid");
        out.print("<option value='" + tempRelationId + "_parent'");
	if (eventEventLink.getRelationLookupId().equals(tempRelationId) && (isParent|| rsetEventRelLookUps.getString("parent_relation").equals(rsetEventRelLookUps.getString("child_relation")))) {
          out.print(" selected");
        }
        out.print(">" + rsetEventRelLookUps.getString("parent_relation")+ "</option>");  

	if(!rsetEventRelLookUps.getString("parent_relation").equals(rsetEventRelLookUps.getString("child_relation"))){
	        out.print("<option value='" + tempRelationId + "_child'");	
	        
	        if (eventEventLink.getRelationLookupId().equals(tempRelationId) && !isParent) {
          		out.print(" selected");
	        }
                out.print("> " + rsetEventRelLookUps.getString("child_relation") + "</option>");  
	}
      }
      
     %>
           </select>*<br><br>
    </td>
    </tr>
    <tr>
    <!--ASSOCIATED EVENT-->
      <td class="bodytext" colspan=3><b>Associated Event:</b> <%=tempEvent.getEventName()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments</b><br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%=(isParent)?eventEventLink.getNotes():eventEventLink.getChildNotes()%></textarea>       
         <input type='hidden' name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' value='<%=(isParent)?eventEventLink.getChildNotes():eventEventLink.getNotes()%>'></hidden>
         <br>
      </td>
    </tr>

    <tr>
    	<td><b>Order By :</b></td>
    	<td><input type="text" name="f_orderby_<%=i%>" size="10" value="<%=eventEventLink.getOrderby()%>"></td>
    </tr>

    <tr>
    	<td colspan="3">
    	 <br>
    	 <hr>
    	 <br>
    	</td>
    </tr>

    <!--<tr>
      <td class="bodytext" colspan=3><br><b>Comments for </b>'<%=tempEvent.getEventName()%>' to '<%=eventObj.getEventName()%>' relationship<br>
        <textarea name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' rows='3' cols='40'><%=(isParent)?eventEventLink.getChildNotes():eventEventLink.getNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
    </tr>-->

<%
  }
  out.println("</table>");
  rsetEventRelLookUps.close();
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
	  out.println("if (document.getElementById('f_relation_lookup_id_" + i + "').options [document.getElementById('f_relation_lookup_id_" + i + "').selectedIndex].value=='0') { alert('Please select all relations'); return (false);} ");
  } %>
  return (true);
}
</script><cms:include property="template" element="foot" />
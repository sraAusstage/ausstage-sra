<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Work, ausstage.WorkWorkLink, admin.Common, ausstage.RelationLookup"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
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
  Work		workObj        = (Work)session.getAttribute("work");
  String 	workid		= workObj.getWorkId();
  Vector<WorkWorkLink> workWorkLinks = workObj.getWorkWorkLinks();

  RelationLookup lookUps = new RelationLookup(db_ausstage);
  CachedRowSet rsetWorkFuncLookUps = lookUps.getRelationLookups("WORK_FUNCTION");

  String isPreviewForEventWork = request.getParameter("isPreviewForEventWork");
  if(isPreviewForEventWork == null){isPreviewForEventWork = "false"; }

  String isPreviewForItemWork = request.getParameter("isPreviewForItemWork");
  if(isPreviewForItemWork == null){isPreviewForItemWork = "false"; }
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);
%>
  <form action='work_work_functions_process.jsp' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <input type='hidden' name='isPreviewForEventWork' id='isPreviewForEventWork' value='<%=isPreviewForEventWork%>'>
  <input type='hidden' name='isPreviewForItemWork' id='isPreviewForItemWork' value='<%=isPreviewForItemWork%>'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (workWorkLinks.size()==0) {
     pageFormater.writeText (out,"No functions selected. Please press the tick button to continue");
    // There are no functions%>
      
    <%
  }

  for(int i=0; i < workWorkLinks.size(); i++) {
  	WorkWorkLink workWorkLink = workWorkLinks.elementAt(i);
  	
    	boolean isParent = workid.equals(workWorkLink.getWorkId());
  	// Load up the child works 
    	Work tempWork = new Work(db_ausstage);
    	tempWork.load(Integer.parseInt((isParent)? workWorkLink.getChildId() : workWorkLink.getWorkId()));
    
    %>
    <tr>
      <td class="bodytext" colspan=3><b>Editing Work:</b> <%=workObj.getName()%><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%
    	out.println("<input type='hidden' name='f_link_work_id_" + i + "' id='f_link_work_id_" + i + "' value='" + tempWork.getWorkId() + "'>");
        out.println("<select name='f_relation_lookup_id_" + i + "' id='f_relation_lookup_id_" + i + "' size='1' class='line150' >");
        
        out.print("<option value='0'>--Select new Function--</option>");
        
        rsetWorkFuncLookUps.beforeFirst();
        
        while (rsetWorkFuncLookUps.next()) {
        
        	String tempRelationId = rsetWorkFuncLookUps.getString ("relationlookupid");
        	out.print("<option value='" + tempRelationId + "_parent'");
	        
	        if (workWorkLink.getRelationLookupId().equals(tempRelationId) && ( isParent || rsetWorkFuncLookUps.getString("parent_relation").equals(rsetWorkFuncLookUps.getString("child_relation")))) 
	        {		
			out.print(" selected");
       		}
        	out.print(">" + rsetWorkFuncLookUps.getString ("parent_relation") + "</option>");
        	if(!rsetWorkFuncLookUps.getString("parent_relation").equals(rsetWorkFuncLookUps.getString("child_relation"))){
		        out.print("<option value='" + tempRelationId + "_child'");	
	        
	        	if (workWorkLink.getRelationLookupId().equals(tempRelationId) && !isParent) {
          			out.print(" selected");
		        }
                	out.print("> " + rsetWorkFuncLookUps.getString("child_relation") + "</option>");  
		}
      	}
      	%>
      	</select>*<br><br>
      </td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><b>Associated Work:</b> <%=tempWork.getName()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments for </b> <%=workObj.getName()%> to <%=tempWork.getName()%><br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%=(isParent)? workWorkLink.getNotes() : workWorkLink.getChildNotes()%></textarea>
        <input type="hidden" name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' value="<%=(isParent)? workWorkLink.getChildNotes() : workWorkLink.getNotes()%>"></input>
        <br><br><br><hr><br><br>
      </td>
    </tr>  

    
   

<%
  }
  out.println("</table>");
  rsetWorkFuncLookUps.close();
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
  for(int i=0; i < workWorkLinks.size(); i++) {
	  out.println("if (document.getElementById('f_relation_lookup_id_" + i + "').options [document.getElementById('f_relation_lookup_id_" + i + "').selectedIndex].value=='0') { alert('Please select all functions'); return (false);} ");
  } %>
  return (true);
}
</script><jsp:include page="../templates/admin-footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Organisation, ausstage.OrganisationOrganisationLink, admin.Common, ausstage.RelationLookup"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Organisation Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater 	= (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  	= new ausstage.Database ();
  admin.Common     common       	= new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  Organisation    organisationObj       = (Organisation)session.getAttribute("organisationObj");
  String       	  organisationid        = Integer.toString(organisationObj.getId());

  Vector<OrganisationOrganisationLink> organisationOrganisationLinks = organisationObj.getOrganisationOrganisationLinks();
  String notes        = "";
  String childNotes   = "";

  RelationLookup lookUps = new RelationLookup(db_ausstage);
  CachedRowSet rsetOrganisationFuncLookUps = lookUps.getRelationLookups("ORGANISATION_RELATION");
  
  String action = request.getParameter("act");
  if (action == null){action = "";}
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);
%>

  <form action='org_org_functions_process.jsp' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <input type='hidden' name='act' id='act' value='<%=action%>'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> 
  <%
  if (organisationOrganisationLinks.size()==0) {
    // There are no functions
  %>
    <tr>
      <td class="bodytext" width="355"><b>No functions selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> 
  <%
  }

  //loop through linked organisations
  for(int i=0; i < organisationOrganisationLinks.size(); i++) {
	OrganisationOrganisationLink orgOrgLink = organisationOrganisationLinks.elementAt(i);
  	boolean isParent = true;
    
    	// Load up the child organisations so that we can get the title and citation for display
	Organisation tempOrganisation = new Organisation(db_ausstage);
	if (organisationid.equals(orgOrgLink.getOrganisationId())){
		tempOrganisation.load(Integer.parseInt(orgOrgLink.getChildId()));
	} else {
		isParent = false;
		tempOrganisation.load(Integer.parseInt(orgOrgLink.getOrganisationId()));
	}
	
  %>
	<tr>
		<td class="bodytext" colspan=3><b>Editing Organisation:</b> <%=organisationObj.getName()%><br><br></td>
	</tr>
	<tr>
		<td class="bodytext" colspan=3>
	<%
		out.println("<input type='hidden' name='f_link_org_id_" + i + "' id='f_link_org_id_" + i + "' value='" + tempOrganisation.getId()+ "'>");
		out.println("<select name='f_relation_lookup_id_" + i + "' id='f_relation_lookup_id_" + i + "' size='1' class='line150' >");

		out.print("<option value='0'>--Select new Function--</option>");
		rsetOrganisationFuncLookUps.beforeFirst();

		while (rsetOrganisationFuncLookUps.next()) {

        		String tempRelationId = rsetOrganisationFuncLookUps.getString ("relationlookupid");
		        out.print("<option value='" + tempRelationId + "_parent'");
  
		        if (orgOrgLink.getRelationLookupId().equals(tempRelationId) && ( isParent || rsetOrganisationFuncLookUps.getString("parent_relation").equals(rsetOrganisationFuncLookUps.getString("child_relation")))) {		
				out.print(" selected");
		        }
		        out.print(">" + rsetOrganisationFuncLookUps.getString ("parent_relation") + "</option>");
		        
		        if(!rsetOrganisationFuncLookUps.getString("parent_relation").equals(rsetOrganisationFuncLookUps.getString("child_relation"))){
		        	out.print("<option value='" + tempRelationId + "_child'");
		        	
		        	if (orgOrgLink.getRelationLookupId().equals(tempRelationId) && !isParent){
		        		out.print("selected");
		        	}
		        	out.print("> " + rsetOrganisationFuncLookUps.getString("child_relation") + "</option>");
		        }
	      	}
	%>
      </select>*<br><br>
    </td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><b>Associated Organisation:</b> <%=tempOrganisation.getName()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments</b><br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%=(isParent) ? orgOrgLink.getNotes() : orgOrgLink.getChildNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
      <input type='hidden' name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' value='<%=(isParent)? orgOrgLink.getChildNotes() : orgOrgLink.getNotes()%>'></input>       
    </tr>
<!--    <tr>
      <td class="bodytext" colspan=3><br><b>Comments for </b> '<%=tempOrganisation.getName()%>' to '<%=organisationObj.getName()%>'<br>
        <textarea name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' rows='3' cols='40'><%=(isParent)? orgOrgLink.getChildNotes() : orgOrgLink.getNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
    </tr>
    -->
<%
  }
  out.println("</table>");
  rsetOrganisationFuncLookUps.close();
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
  for(int i=0; i < organisationOrganisationLinks.size(); i++) {
	  out.println("if (document.getElementById('f_function_lov_id_" + i + "').options [document.getElementById('f_function_lov_id_" + i + "').selectedIndex].value=='0') { alert('Please select all functions'); return (false);} ");
  } %>
  return (true);
}
</script><jsp:include page="../templates/admin-footer.jsp" />
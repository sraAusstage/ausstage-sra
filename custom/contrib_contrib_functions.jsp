<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Contributor, ausstage.ContributorContributorLink, admin.Common, ausstage.RelationLookup"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database db_ausstage  = new ausstage.Database ();
  admin.Common  common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Contributor	contributorObj        = (Contributor)session.getAttribute("contributor");
  String 	contributorid		= Integer.toString(contributorObj.getId());
  System.out.println("Contributor Id:"+contributorid);
  Vector<ContributorContributorLink> contributorContributorLinks = contributorObj.getContributorContributorLinks();
  
  String action = request.getParameter("act");
  
  String functionId   = "";
  String functionDesc = "";
  String notes        = "";
  RelationLookup relLookup = new RelationLookup(db_ausstage);
  CachedRowSet rsetContributorRelLookUps = relLookup.getRelationLookups("CONTRIBUTOR_RELATION");
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);
%>
  <form action='contrib_contrib_functions_process.jsp?act=<%=action%>' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (contributorContributorLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No functions selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }

    for(int i=0; i < contributorContributorLinks.size(); i++) {
    	ContributorContributorLink contributorContributorLink = contributorContributorLinks.elementAt(i);
    	boolean isParent = true;
    	// Load up the child Contributors
    	Contributor tempContributor = new Contributor(db_ausstage);
    	if(contributorid.equals(contributorContributorLink.getContributorId())){
      		tempContributor.load(Integer.parseInt(contributorContributorLink.getChildId()));
	} else {
      		isParent = false;
	      	tempContributor.load(Integer.parseInt(contributorContributorLink.getContributorId()));
    	}
    %>
    <tr>
      <td class="bodytext" colspan=3><b>Editing Contributor:</b> <%=contributorObj.getName() +" "+ contributorObj.getLastName() %><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%

	out.println("<input type='hidden' name='f_link_contributor_id_" + i + "' id='f_link_contributor_id_" + i + "' value='" + tempContributor.getId() + "'>");
      	out.println("<select name='f_relation_lookup_id_" + i + "' id='f_relation_lookup_id_" + i + "' size='1' class='line150' >");

     	out.print("<option value='0'>--Select new Relation--</option>");

	rsetContributorRelLookUps.beforeFirst();

	System.out.println("LOOP RELATION LOOKUPS FOR DROP DOWN");
	while (rsetContributorRelLookUps.next()) {
	
		String tempRelationId = rsetContributorRelLookUps.getString ("relationlookupid");
	
		out.print("<option value='" + tempRelationId + "_parent'");
			
		if (contributorContributorLink.getRelationLookupId().equals(tempRelationId) && ( isParent || rsetContributorRelLookUps.getString("parent_relation").equals(rsetContributorRelLookUps.getString("child_relation")))) {
		
	  	      out.print(" selected");
        	}
	        out.print(">" + rsetContributorRelLookUps.getString("parent_relation")+ "</option>");  

		if(!rsetContributorRelLookUps.getString("parent_relation").equals(rsetContributorRelLookUps.getString("child_relation"))){
		        out.print("<option value='" + tempRelationId + "_child'");	
	        
	        	if (contributorContributorLink.getRelationLookupId().equals(tempRelationId) && !isParent) {
          			out.print(" selected");
		        }
                	out.print("> " + rsetContributorRelLookUps.getString("child_relation") + "</option>");  
		}
	}
	

      %>
      </select>*<br><br>
      </td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><b>Associated Contributor:</b> <%=tempContributor.getName() +" "+ tempContributor.getLastName()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments</b>
        <br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%=(isParent)?contributorContributorLink.getNotes():contributorContributorLink.getChildNotes()%></textarea>
        <input type='hidden' name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' value='<%=(isParent)?contributorContributorLink.getChildNotes():contributorContributorLink.getNotes()%>' ></input>
         <br><br><br><hr><br><br>
      </td>
    </tr>    
<!--    <tr>
      <td class="bodytext" colspan=3><br><b>Comments for </b>'<%=tempContributor.getDisplayName()%>' to '<%=contributorObj.getDisplayName()%>'
        <br>
        <textarea name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' rows='3' cols='40'><%=(isParent)?contributorContributorLink.getChildNotes():contributorContributorLink.getNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
    </tr>
    -->
<%
  }
  out.println("</table>");
  rsetContributorRelLookUps.close();
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
  for(int i=0; i < contributorContributorLinks.size(); i++) {
	  out.println("if (document.getElementById('f_relation_lookup_id_" + i + "').options [document.getElementById('f_relation_lookup_id_" + i + "').selectedIndex].value=='0') { alert('Please select all relations'); return (false);} ");
  } %>
  return (true);
}
</script>
<cms:include property="template" element="foot" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Item, ausstage.ItemContribLink, ausstage.Contributor, admin.Common, ausstage.LookupCode"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  admin.Common     common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Item          itemObj       = (Item)session.getAttribute("item");
  String        itemid        = itemObj.getItemId();


  
  String orderBy        = "";
  String creator       = request.getParameter("Creator");
  Vector itemContribLinks;
  if(creator.equals("FALSE")) {
    itemContribLinks= itemObj.getAssociatedContributors();
  }
  else {
    itemContribLinks= itemObj.getAssociatedCreatorContributors();
  }
  
  pageFormater.writeHeader(out);
  if(creator.equals("FALSE")) {
    pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
  }
  else {
    pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);
  }
%>
  <form action='item_contrib_functions_process.jsp?Creator=<%=creator %> ' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (itemContribLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No contributors selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }
  else {%>
    <tr>
      <th class="bodytext" width="255"><%if(!creator.equals("FALSE")) {%>Selected Contributor<%}%></td>
      <th width="5">&nbsp;</td><%
      if(!creator.equals("FALSE")) {%>
        <th class="bodytext" width="200">Function</td><%
      }%>
      <th width="5">&nbsp;</td>
      <th class="bodytext" width="100"><%if(!creator.equals("FALSE")) {%>Order By *<%}%></td>
    </tr><%
  }

  for(int i=0; i < itemContribLinks.size(); i++) {
    ItemContribLink itemContribLink = (ItemContribLink)itemContribLinks.elementAt(i);
    //itemItemLink.load(itemid, itemItemLinks.elementAt(i)+"");
    
    // Load up the child items so that we can get the title and citation for display
    Contributor tempContributor = new Contributor(db_ausstage);
    tempContributor.load(Integer.parseInt(itemContribLink.getContribId()));
    %>
    <tr>
      <td class="bodytext" valign='top'><%if(!creator.equals("FALSE")) { out.print(tempContributor.getName() + " " + tempContributor.getLastName()); }%></td> <%
	  // Display all of the Functions
    out.println("<td>&nbsp;</td>");
    
    if(creator.equals("FALSE")) {
      out.println("<input type='hidden' name='f_function_id_" + i + "' value='0'>");
      // Normal
    }
    else {
      // Creator
      out.println("<td>");
      out.println("<select name='f_function_id_" + i + "' size='1' class='line150'>");
      LookupCode functions = new LookupCode(db_ausstage);
      CachedRowSet rset = functions.getLookupCodes("CREATOR_FUNCTION");
  
      out.print("<option value='0'>--Select new Function--</option>");
      while (rset.next())
      { 
        out.print("<option value='" + rset.getString ("code_lov_id") + "'");
  
        if (itemContribLink.getFunctionId().equals(rset.getString ("code_lov_id"))){
          // we have posted to itself
          out.print(" selected");
        }
        out.print(">" + rset.getString ("Description") + "</option>");
      }
  
      rset.close ();
      out.println("</select>");
      out.println("</td>");
      out.println("<td>&nbsp;</td>");
    }
    
    
    out.println("<td valign='top'>");
    out.println("<input type='hidden' name='f_contrib_id_" + i + "' id='f_contrib_id_" + i + "' value='" + itemContribLink.getContribId() + "'>");
    
    String fieldType = "text";
    if(creator.equals("FALSE")) {
      fieldType = "hidden";
    }
    out.println("<input type='" + fieldType + "' name='f_orderBy_" + i + "' size='10' class='line25' maxlength='10' value=" + itemContribLink.getOrderBy() + ">  &nbsp;&nbsp;</td></tr>");


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
  <%
  for(int i=0; i < itemContribLinks.size(); i++) {
	  out.println("if(document.getElementById('f_orderBy_" + i + "').value == null || document.getElementById('f_orderBy_" + i + "').value=='' ||  !(isInteger(document.getElementById('f_orderBy_" + i + "').value)))");
    out.println("{ ");
    out.println("alert('Please enter a valid value in all order bys'); return (false);");
    out.println("} ");
  }%>
  return (true);
}

<%
if(creator.equals("FALSE")) {
  out.println("document.functions_form.submit();");
}%>
</script>
<jsp:include page="../templates/admin-footer.jsp" />
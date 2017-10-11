<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Item, ausstage.ItemItemLink, admin.Common, ausstage.RelationLookup"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />



<%
  admin.ValidateLogin  login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage  pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database db_ausstage  = new ausstage.Database ();
  admin.Common      common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Item          itemObj       = (Item)session.getAttribute("item");
  String        itemid        = itemObj.getItemId();

  Vector<ItemItemLink> itemItemLinks = itemObj.getItemItemLinks();
  
  String functionId   = "";
  String functionDesc = "";
  String notes        = "";
  
  RelationLookup lookUps = new RelationLookup(db_ausstage);
  CachedRowSet rsetItemFuncLookUps = lookUps.getRelationLookups("ITEM_FUNCTION");

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Resource Link Properties", AusstageCommon.ausstage_main_page_link);

%>
  <form action='item_item_functions_process.jsp' name='functions_form' id='functions_form' method='post' onsubmit='return (validateForm());'>
  <table cellspacing='0' cellpadding='0' border='0' width='560'> <%
  if (itemItemLinks.size()==0) {
    // There are no functions%>
    <tr>
      <td class="bodytext" width="355"><b>No functions selected. Please press the tick button to continue</b></td>
      <td>&nbsp;</td>
      <td class="bodytext"></td>
    </tr> <%
  }

  for(int i=0; i < itemItemLinks.size(); i++) {
	ItemItemLink itemItemLink = itemItemLinks.elementAt(i);

	boolean isParent = itemid.equals(itemItemLink.getItemId());
    // Load up the child items so that we can get the title and citation for display
	Item tempItem = new Item(db_ausstage);
	tempItem.load(Integer.parseInt((isParent) ? itemItemLink.getChildId() : itemItemLink.getItemId()));
    
    %>
    <tr>
      <td class="bodytext" colspan=3><b>Editing Resource:</b> <%=itemObj.getTitle()%><br><br></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><%
      out.println("<input type='hidden' name='f_link_item_id_" + i + "' id='f_link_item_id_" + i + "' value='" + tempItem.getItemId() + "'>");
      out.println("<select name='f_relation_lookup_id_" + i + "' id='f_relation_lookup_id_" + i + "' size='1' class='line150' >");

      out.print("<option value='0'>--Select new Function--</option>");
      rsetItemFuncLookUps.beforeFirst();
      
      while (rsetItemFuncLookUps.next()) {
      
        String tempRelationId = rsetItemFuncLookUps.getString ("relationlookupid");
        out.print("<option value='" + tempRelationId + "_parent'");
  
        if (itemItemLink.getRelationLookupId().equals(tempRelationId) && ( isParent || rsetItemFuncLookUps.getString("parent_relation").equals(rsetItemFuncLookUps.getString("child_relation")))) 
	{
          out.print(" selected");
        }
        out.print(">" + rsetItemFuncLookUps.getString ("parent_relation") + "</option>");
        
        if(!rsetItemFuncLookUps.getString("parent_relation").equals(rsetItemFuncLookUps.getString("child_relation"))){
		        out.print("<option value='" + tempRelationId + "_child'");	
	        
	        	if (itemItemLink.getRelationLookupId().equals(tempRelationId) && !isParent) {
          			out.print(" selected");
		        }
                	out.print("> " + rsetItemFuncLookUps.getString("child_relation") + "</option>");  
	}
      }
      %>
      </select>*<br><br>
    </td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><b>Associated Resource:</b> <%=tempItem.getTitle()%></td>
    </tr>
    <tr>
      <td class="bodytext" colspan=3><br><b>Comments for</b> <%=itemObj.getTitle()%> to <%=tempItem.getTitle()%><br>
        <textarea name='f_notes_<%=i%>' id='f_notes_<%=i%>' rows='3' cols='40'><%= (isParent) ? itemItemLink.getNotes() : itemItemLink.getChildNotes()%></textarea>
        <input type='hidden' name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' value='<%=(isParent)?itemItemLink.getChildNotes():itemItemLink.getNotes()%>' ></input>
      </td>
    </tr>
<!--     <tr>
      <td class="bodytext" colspan=3><br><b>Comments for</b>  <%=tempItem.getCitation()%> to <%=itemObj.getCitation()%><br>
        <textarea name='f_child_notes_<%=i%>' id='f_child_notes_<%=i%>' rows='3' cols='40'><%=(isParent) ? itemItemLink.getChildNotes() : itemItemLink.getNotes()%></textarea>
        <br><br><br><hr><br><br>
      </td>
    </tr>-->
<%
  }
  out.println("</table>");
  rsetItemFuncLookUps.close();
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
  for(int i=0; i < itemItemLinks.size(); i++) {
	  out.println("if (document.getElementById('f_relation_lookup_id_" + i + "').options [document.getElementById('f_relation_lookup_id_" + i + "').selectedIndex].value=='0') { alert('Please select all functions'); return (false);} ");
  } %>
  return (true);
}
</script><cms:include property="template" element="foot" />
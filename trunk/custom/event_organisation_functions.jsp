<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.OrgEvLink, ausstage.Organisation"%>
<%@ page import = "ausstage.ContributorFunction, ausstage.ContFunctPref"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Event  eventObj = (Event)session.getAttribute("eventObj");
  String eventid  = eventObj.getEventid();

  Vector        orgEvLinks    = eventObj.getOrgEvLinks();
  OrgEvLink     orgEvLink     = null;
  Organisation  organisation  = null;
  ContFunctPref contFunctPref = new ContFunctPref(db_ausstage);
  
	String functionId           = "";
	String functionDesc         = "";
	String conFunctionId        = "";
	String artisticFunctionDesc = "";

// If we have returned here from this form then get the request details.

  for(int i=0; i < orgEvLinks.size(); i++)
  {
    orgEvLink    = (OrgEvLink)orgEvLinks.get(i);
    organisation = orgEvLink.getOrganisationBean();
    // get any data from the request object

    functionId   = request.getParameter("f_function_id_" + i);
    functionDesc = request.getParameter("f_function_name_" + i);
    if (functionId != null   )
    {
      orgEvLink.setFunction(functionId);
      orgEvLink.setFunctionDesc(functionDesc);
      orgEvLinks.set(i, orgEvLink);
    }

    conFunctionId = request.getParameter("f_con_function_id_" + i);
    if (conFunctionId != null  )
    {
      contFunctPref.load(conFunctionId);
      orgEvLink.setArtisticFunction(conFunctionId);
      // If --none-- has been selected in the combo, clear the artistic function text field. 
      if (!conFunctionId.equals("0") ){
        artisticFunctionDesc = contFunctPref.getPreferredTerm();
        orgEvLink.setArtisticFunctionDesc(artisticFunctionDesc);
      }
      else{
        orgEvLink.setArtisticFunctionDesc("");
      }
      orgEvLinks.set(i, orgEvLink);
    }
  }

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Define Organisation Link Properties", AusstageCommon.ausstage_main_page_link);

%>
  <form action='event_organisation_functions_process.jsp' name='functions_form' id='functions_form' method='post'>
    <table cellspacing='0' cellpadding='0' border='0' >
      <tr>
        <th class="bodytext" ><b>Selected Organisation</b></th>
        <th width="5">&nbsp;</th>
        <th class="bodytext" ><b>Function</b></th>
        <th width="5">&nbsp;</td>
        <th class="bodytext"><b>Artistic Function</b></th>
      </tr>
<%

 // Organisations
  ContributorFunction contFunctRset = new ContributorFunction(db_ausstage); // Needed as it has a valid db connection
  String orgFunctionId = "";
  for(int i=0; i < orgEvLinks.size(); i++)
  {
    orgEvLink    = (OrgEvLink)orgEvLinks.get(i);
    organisation = orgEvLink.getOrganisationBean();
    out.println("<tr>");
    out.println("<td class='bodytext' width='190'>" + organisation.getName() + "</td>");

	  // Display all of the OrgFunctMenus
    out.println("<td width='5'>&nbsp;</td>");
    out.println("<td>");
    out.println("<input type='hidden' name='f_function_name_" + i + "' value='" + orgEvLink.getFunctionDesc() + "'>");
	  out.println("<select name='f_function_id_" + i + "' size='1' class='line150' onchange=\"assignFunctionName(document.functions_form.f_function_name_" + i + ", this);\">");
    out.print("<option value='0'>-- None --</option>");
    CachedRowSet rset = orgEvLink.getOrgFunctMenus(db_ausstage);
	  while (rset.next())
	  {
      orgFunctionId = rset.getString ("OrgFunctionId");
	    out.print("<option value='" + orgFunctionId + "'");

	    if (orgEvLink.getFunction() != null && orgEvLink.getFunction().equals(orgFunctionId))
	      out.print(" selected");
	    out.print(">" + rset.getString ("orgFunction") + "</option>");
	  }

    rset.close ();
	  out.println("</select>");
	  out.println("</td>");

	  // Display all of the Functions to select the Artistic Function
    out.println("<td width='5'>&nbsp;</td>");
    out.println("<td>");
	  out.println("<select name='f_con_function_id_" + i + "' size='1' class='line150' " +
                "onChange='updatePreferredTerm()'>");
    out.print("<option value='0'>-- None --</option>");
    String contFunctPrefId = "";
    rset = contFunctRset.getNames();
	  while (rset.next())
	  {
      contFunctPrefId = rset.getString ("contributorFunctPreferredId");
	    out.print("<option value='" + contFunctPrefId + "'");

	    if (orgEvLink.getArtisticFunction() != null &&
          orgEvLink.getArtisticFunction().equals(contFunctPrefId))
	      out.print(" selected");
	    out.print(">" + rset.getString ("ContFunction") + ", " + rset.getString ("PreferredTerm") + "</option>");
	  }

    rset.close ();
	  out.println("</select>");
	  out.println("</td>");
%>
    <tr>
      <td width='5'>&nbsp;</td>
      <td width='5'>&nbsp;</td>
      <td width='5'>&nbsp;</td>
      <td width='5'>&nbsp;</td>
      <td>
<%    if(orgEvLink.getArtisticFunctionDesc() != null){%>
	<input type='text' name='f_artistic_function_<%=i%>' size='25' class='line150'readonly value='<%=orgEvLink.getArtisticFunctionDesc()%>'>
<%    }else{%>
	<input type='text' name='f_artistic_function_<%=i%>' size='25' class='line150'readonly value=''>
<%    }%>      
     </td>
    </tr>
    <tr><td><br></td></tr>
<%
  }
  out.println("</table>");
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif");
  pageFormater.writeFooter(out);
%>
  </form>
<script language="javascript">
<!--
  function updatePreferredTerm()
  {
    document.functions_form.action = 'event_organisation_functions.jsp';
    document.functions_form.submit();
  }
 function assignFunctionName(p_function_name, p_select_list){
  if(p_select_list.selectedIndex != 0)
    p_function_name.value = p_select_list.options[p_select_list.selectedIndex].text;
  else
    p_function_name.value = "No Function";
 }
//-->
</script>
<cms:include property="template" element="foot" />
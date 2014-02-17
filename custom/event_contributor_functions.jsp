<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import = "ausstage.Event, ausstage.ConEvLink, ausstage.Contributor, admin.Common"%>
<%@ page import = "ausstage.ContributorFunction, ausstage.ContFunctPref"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" >

<%
	admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  admin.Common     common       = new Common();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Event  eventObj = (Event)session.getAttribute("eventObj");
  String eventid  = eventObj.getEventid();

	Vector conEvLinks  = eventObj.getConEvLinks();
  ConEvLink           conEvLink     = null;
  Contributor         contributor   = null;
  ContributorFunction contFunct     = null;
  ausstage.ContFunctPref       contFunctPref = new ausstage.ContFunctPref(db_ausstage);
  
	String functionId   = "";
	String functionDesc = "";
	String notes        = "";

  String f_anchor_vame = request.getParameter("f_anchor_vame");
  if(f_anchor_vame == null) {
	  f_anchor_vame = "";
  } else {
	  f_anchor_vame = f_anchor_vame.substring(1);
  }
	
// If we have returned here from this form then get the request details.

  for(int i=0; i < conEvLinks.size(); i++)
  {
    conEvLink   = (ConEvLink)conEvLinks.get(i);
    contributor = conEvLink.getContributorBean();
    contFunct   = conEvLink.getContFunctBean();
    // get any data from the request object
    functionId  = request.getParameter("f_non_pref_function_id_" + i);
    notes       = request.getParameter("f_notes_" + i);

    if (notes != null)
      conEvLink.setNotes(notes);

    if (functionId != null && !functionId.equals("0")){
      //contFunctPref.load(functionId);
      contFunctPref.loadPreferredWithNonPreferredId(functionId);
      functionDesc = contFunctPref.getPreferredTerm();
      //conEvLink.setFunction(functionId);
      conEvLink.setFunction(contFunctPref.getPreferredId());
      //conEvLink.setFunctionDescId(contFunctPref.getPreferredId());
      conEvLink.setFunctionDesc(functionDesc);
      conEvLinks.set(i, conEvLink);
    }
  }

  pageFormater.writeHeader(out);
  //pageFormater.writePageTableHeader (out, "Define Contributor Link Properties", AusstageCommon.ausstage_main_page_link);
%>
  <form action='event_contributor_functions_process.jsp' name='functions_form' id='functions_form' method='post'>
  <input type='hidden' name='f_anchor_vame'>
    <table cellspacing='0' cellpadding='0' border='0' >
      <tr>
        <th class="bodytext"> Selected Contributor</th>
        <td width="5">&nbsp;</td>
        <td class="bodytext" width="200"><b>Function *</b></td>
        <td width="5">&nbsp;</td>
        <td class="bodytext"><b>Preferred Term</b></td>
      </tr>
<%
  ContributorFunction contFunctRset = new ContributorFunction(db_ausstage); // Needed as it has a valid db connection
  //out.println("<input type='hidden' name='f_anchor_vame'>");
 // Contributors
  for(int i=0; i < conEvLinks.size(); i++)
  {
    conEvLink   = (ConEvLink)conEvLinks.get(i);
    contributor = conEvLink.getContributorBean();
    contFunct   = conEvLink.getContFunctBean();

    String anchor_name = contributor.getName() + " " + contributor.getLastName();
    anchor_name = common.ReplaceStrWithStr(anchor_name, "'", "");
    anchor_name = common.ReplaceStrWithStr(anchor_name, " ", "");

	if(f_anchor_vame.equals(anchor_name)) {
%>
	  <tr class="b-196">
<% } else  { %>
      <tr>
<% } %>
        <td class="bodytext" width="190">
          <a name="<%=anchor_name%>"></a>
          <%=contributor.getName() + " " + contributor.getLastName()%>
        </td>
<%
	  // Display all of the Functions
    //out.println("<a name=\""+ anchor_name + "\">");
    out.println("<td width='5'>&nbsp;</td>");
    out.println("<td>");
	  out.println("<select name='f_non_pref_function_id_" + i + "' size='1' class='line150' " +
                "onChange='updatePreferredTerm(\"" + anchor_name + "\");'>");
    String contributorFunctionId = "";
    CachedRowSet rset = contFunctRset.getNames();
    String seleted_pref_term    = "";
    String seleted_pref_term_id = "";

    out.print("<option value='0'>--Select new Function--</option>");
	  while (rset.next())
	  { 
      contributorFunctionId = rset.getString ("contfunctionid");
	    out.print("<option value='" + contributorFunctionId + "'");

	    if (request.getParameter("f_non_pref_function_id_" + i) != null && request.getParameter("f_non_pref_function_id_" + i).equals(contributorFunctionId)){
        // we have posted to itself
	      out.print(" selected");
        seleted_pref_term    = rset.getString ("PreferredTerm");
        seleted_pref_term_id = rset.getString ("ContributorFunctPreferredId");
      }
	    out.print(">" + rset.getString ("ContFunction") + ", " + rset.getString ("PreferredTerm") + "</option>");
	  }

    rset.close ();
	  out.println("</select>");
	  out.println("</td>");

%>
      <td width='5'>&nbsp;</td>
      <td><input type='text' name='f_preferred_term_<%=i%>' size='25' class='line150' readonly value='<%=conEvLink.getFunctionDesc()%>'>
        <input type="hidden" name="f_function_id_<%=i%>" value="<%=conEvLink.getFunction()%>">
      </td>
          
<%
    if(request.getParameter("f_preferred_term_" + i) != null 
     && request.getParameter("f_non_pref_function_id_" + i).equals("0")){
      // none was selected before we posted back (post to itself) to this page
      // so lets preserve the preferredTerm and preferredTermId
%>  
       <script language="javascript"><!--
        document.functions_form.f_preferred_term_<%=i%>.value="<%=request.getParameter("f_preferred_term_" + i)%>"; 
        document.functions_form.f_function_id_<%=i%>.value="<%=request.getParameter("f_function_id_" + i)%>";
       //--></script> 
<%
    }
%>
      </tr>
<%      
	if(f_anchor_vame.equals(anchor_name)) {
%>
	  <tr class="b-196">
<% } else  { %>
      <tr>
<% } %>
        <td width='5'>&nbsp;</td>
        <td width='5'>&nbsp;</td>
        <td colspan='3' class='bodytext' width='340'><textarea name='f_notes_<%=i%>' rows='5' cols='40'><%=conEvLink.getNotes()%></textarea></td>
      </tr>
<%      
	if(f_anchor_vame.equals(anchor_name)) {
%>
	  <tr class="b-196">
<% } else  { %>
      <tr>
<% } %>
		<td colspan="5"><br></td></tr>
<%
  }
  out.println("</table>");
  db_ausstage.disconnectDatabase();
  //pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "tick.gif");
  pageFormater.writeFooter(out);
%>
  </form>
<script type="text/javascript">
<!--
  function updatePreferredTerm(p_anchor_name)
  {
    p_anchor_name = "#" + p_anchor_name;
    document.functions_form.f_anchor_vame.value = p_anchor_name;
    document.functions_form.action = 'event_contributor_functions.jsp' + p_anchor_name ;
    document.functions_form.submit();
  }
//-->
</script>

<cms:include property="template" element="foot" />
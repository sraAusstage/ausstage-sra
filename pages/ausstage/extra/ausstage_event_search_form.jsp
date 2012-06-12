<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>

<%@ page import= "ausstage.AusstageCommon"%>

<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>
<jsp:useBean id="admin_db_for_form" class="ausstage.Database" scope="application">
<%admin_db_for_form.connDatabase(ausstage_search_appconstants_for_form.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_form.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean>


  
<%  
  String search_within_search_for_form = request.getParameter("f_search_within_search");
 
  String m_sql_switch                  = request.getParameter("f_sql_switch");
  String m_table_to_search_from        = request.getParameter("f_search_from");
  String m_sort_by                     = request.getParameter("f_sort_by");

  // set variables
  if(search_within_search_for_form == null){search_within_search_for_form = "";}
  if(m_sql_switch == null){m_sql_switch = "";}
  if(m_table_to_search_from == null){m_table_to_search_from = "";}
  if(m_sort_by == null){m_sort_by = "";}

  ///////////////////////////////////
  //    DISPLAY SEARCH PAGE
  //////////////////////////////////
%>

<form name="searchform" id="searchform" method="post" action ="<%= AusstageCommon.event_index_search_result_page%>" onsubmit="return checkFields();">
   
<%
  if(!search_within_search_for_form.equals(""))
    out.println("<input type='hidden' name='f_search_within_search' value='"+ search_within_search_for_form + "'>");  
%>

<style>
.search_text
{
  font-family:Verdana;
  font-size:11px;
  color:#FFFFFF;
  font-weight:normal;
  text-decoration:none;
  font-style:normal;
}
.search_11text { font-family:Verdana; font-size:11px; color:#666666; font-weight:normal; text-decoration:none; font-style:normal; }

.fsearch {
	padding:0px;
	padding-left:0px;
	font-size: 10px;
	color: #000;
	border-left: 1px solid #5D9149;
	border-right: 1px solid #629047;
	border-bottom: 1px solid #648F48;
	border-top: 1px solid #639148;
}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="550">
<tbody>
  <tr height="150" align="right">
    <td colspan="2" align="right" background="../resources/images/ausstage_home_3.jpg"></td>
  </tr>

  <tr>
    <td colspan="2" background="/custom/files/tabbackground.gif">
      <a href="/default.jsp"><img src="../resources/images/tabeventon.gif" alt="default" border="0"></a>
      <a href="/advancedsearch.jsp?"><img src="../resources/images/tabadvsearchoff.gif" alt="default" border="0"></a>
      <a href="/resourcesearch.jsp?"><img src="../resources/images/tabresourceoff.gif" alt="default" border="0"></a>
      <a href="/queries.jsp?"><img src="../resources/images/tabqueriesoff.gif" alt="default" border="0"></a></td>
</tr>

  <tr>
    <td align="left" valign="top" bgcolor="#A0CA75">
<%
  if(!search_within_search_for_form.equals(""))
    out.println("<br><p style='font-family:verdana;color:#FFFFFF;font-size:11'>Note: You are now performing search within the previous result(s)</p>");
%>        
        </font></b></td>
      </tr>
      <tr>
        <td align="left">       
	  <table border="0" cellpadding="3" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
	    <tr>
	      <td>&nbsp;</td>
	    </tr>
	    <tr>
	      <td>&nbsp;</td>
	      <td>
		<input type="text" size="40" name='f_keyword' id='f_keyword'  <%if(request.getParameter("f_keyword") != null) { out.print("value=\"" + request.getParameter("f_keyword") + "\"");}%>>&nbsp;
	      </td>
	      <td>
		<select name="f_search_from" id='f_search_from' onchange='javascript:enableDisableSorts()'>
		  <option value="all">All Records</option>
		  <option value="event"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("event")) { out.print(" selected ");}%> >Events</option>
		  <option value="contributor"  <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("contributor")) { out.print(" selected ");}%>>Contributors</option>
		  <option value="organisation" <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("organisation")) { out.print(" selected ");}%>>Organisations</option>
		  <option value="venue"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("venue")) { out.print(" selected ");}%>>Venues</option>
		  <option value="resource"     <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("resource")) { out.print(" selected ");}%>>Resources</option>
		</select>
	      </td>
	      <td align="center"><input type="submit" value="Search"></td>
	   </tr>
	<tr>
<td>
&nbsp;</td>
</tr>
<tr>
<td>
&nbsp;</td>
<td class="general_heading_white" align="right">
Search words using &nbsp;</td>
<td>
<select name="f_sql_switch" id ="f_sql_switch">
<option value="and"   <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("and")) { out.print(" selected ");}%> >And</option>
<option value="or"    <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("or")) { out.print(" selected ");}%> >Or</option>
<option value="exact" <%if(request.getParameter("f_sql_switch") != null && request.getParameter("f_sql_switch").equals("exact")) { out.print(" selected ");}%> >Exact Phrase</option>
</select></td>
</tr>
<tr>
<td>
&nbsp;</td>
<td class="general_heading_white" align="right">
Sort results by &nbsp;</td>
<td>
<select name="f_sort_by" id="f_sort_by">
<option value="alphab_frwd" <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("alphab_frwd")) { out.print(" selected ");}%> >Name</option>
<option value="date"        <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("date"))        { out.print(" selected ");}%> >Date</option>
<option value="venue"       <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("venue"))       { out.print(" selected ");}%> >Venue</option>
<option value="state"       <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("state"))       { out.print(" selected ");}%> >State</option>
</select></td>
</tr>
<tr>
<td>
&nbsp;</td>
<td align="right" class="general_heading_white">
Restrict by year &nbsp;</td>
<td class="general_heading_white" colspan="2">
<input type="text" size="9" maxlength="9" name='f_year' id='f_year' <%if(request.getParameter("f_year") != null) { out.print("value=\"" + request.getParameter("f_year") + "\"");}%> >
(1999, 1876-2006)</td>
</tr>
<tr>
<td>
&nbsp;</td>
</tr>
<tr>
<td>
&nbsp;</td>
<td class="general_heading_white" align="left">
<a target='_blank' href="ausstage.jsp"><font class="general_heading_white"><b>Help</b></font></a></td>
<td>
&nbsp;</td>
</tr>
</table>



    </td>
    <td align="left" valign="top" bgcolor="#A0CA75">
    </td>
  </tr>
</table>
</td>
</tr>
</table></td>


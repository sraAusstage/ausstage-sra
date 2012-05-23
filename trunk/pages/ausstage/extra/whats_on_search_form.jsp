<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import = "java.sql.*, admin.Common, java.util.*, ausstage.State, ausstage.Database"%>
<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>

<form name="searchform" id="searchform" method="post" action ="<%= AusstageCommon.queries_search_result_page%>" onsubmit="return checkFileds();">

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
  <tr>
    <td align="left" valign="top" bgcolor="#FFFFFF">
     <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
      <tr>
        <td rowspan="2" align="left" valign="top">
        <img border="0" src="../resources/images/spacer.gif" width="20" height="20"></td>
        <td align="left"  valign='top'  colspan="2">
        Select State:      
        </td>
        <td class='general_heading_white' valign='centre'  >
        <%
       
  ausstage.Database db_ausstage = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement stmt = db_ausstage.m_conn.createStatement ();
  out.println("<select name='f_state' id='f_state' size='1' onchange=\"document.searchform.submit()\">");
  
  State     stateObj = new State(db_ausstage);
  String    stateStr = request.getParameter("f_state");
  ResultSet rset;
  
  rset = stateObj.getStates(stmt);
  int l_counter =0;
  String l_state;
  while (rset.next()) {
    l_state = rset.getString ("state");
    if(l_counter == 0)
      out.print("<option value=\"\">--- Select State ---</option>");
    out.print("<option value=\"" + l_state + "\" ");
    if (stateStr != null && stateStr.equals(l_state)) {
      out.print("selected");
    }
    out.print(">" + rset.getString ("state") + "</option>");
    l_counter ++;
  }
  out.println("</select><br><br>");
  
  %>
        </td>
      </tr>
    </table>
    </td>

    <td align="left" valign="top" bgcolor="#FFFFFF">
    </td>
  </tr>
</table>

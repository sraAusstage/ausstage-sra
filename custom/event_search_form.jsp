<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "ausstage.AusstageCommon"%>
<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>

<cms:include property="template" element="head" />
<jsp:useBean id="admin_db_for_form" class="ausstage.Database" scope="application">
<%admin_db_for_form.connDatabase(ausstage_search_appconstants_for_form.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_form.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%content.ContentOutput ausstage_search_page_output_for_form = new content.ContentOutput(request, request.getParameter("xcid"), admin_db_for_form);%>

<%
  
  String search_within_search_for_form = request.getParameter("f_search_within_search");
  String xcid_for_form                 = request.getParameter("xcid");
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
   <input type="hidden" name="xcid" value="<%=AusstageCommon.xcid_for_form%>">
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
<td>
&nbsp;</td>
<td>
<input type="text" size="40" name='f_keyword' id='f_keyword'  <%if(request.getParameter("f_keyword") != null) { out.print("value=\"" + request.getParameter("f_keyword") + "\"");}%>>
&nbsp;</td>
<td>
<select name="f_search_from" id='f_search_from' onchange='javascript:enableDisableSorts()'>
<option value="all">All Records</option>
<option value="event"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("event")) { out.print(" selected ");}%> >Events</option>
<option value="contributor"  <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("contributor")) { out.print(" selected ");}%>>Contributors</option>
<option value="organisation" <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("organisation")) { out.print(" selected ");}%>>Organisations</option>
<option value="venue"        <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("venue")) { out.print(" selected ");}%>>Venues</option>
<option value="resource"     <%if(request.getParameter("f_search_from") != null && request.getParameter("f_search_from").equals("resource")) { out.print(" selected ");}%>>Resources</option>
</select></td>
<td align="center">
<input type="submit" value="Search"></td>
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
<a target='_blank' href="ausstage.jsp?xcid=66"><font class="general_heading_white"><b>Help</b></font></a></td>
<td>
&nbsp;</td>
</tr>
</table>


    </td>
    <td align="left" valign="top" bgcolor="#A0CA75">
    </td>
  </tr>
</table>
<script language="javascript">
  <!--

    function checkFields(){

      var msg = "";
      var f_year = "";
      if(isBlank(document.searchform.f_keyword.value)){
        msg += "\tKeyword\n";
      }

      // Check date
      // Has to be of length 4 or 9 eg "1996", or "1996-2008"
      if(!isBlank(document.searchform.f_year.value)){
        f_year = document.searchform.f_year.value;
        if (f_year.length != 4 && f_year.length != 9) {
          msg += "\Year\n";
        }
        else if (f_year.length == 4 && !isInteger(f_year)) {
          msg += "\Year\n";
        }
        else if (f_year.length == 9) {
          if (f_year.indexOf('-') != 4) {
            msg += "\Year\n";
          }
          else if (!isInteger(f_year.substring(0,4)) || !isInteger(f_year.substring(5,9))) {
            msg += "\Year\n";
          }
          
        }
      }

      if(msg != ""){
        alert("You have not entered the correct value(s) for\n" + msg + "Please press OK and fill in the required field(s).");
        return(false);
      }else{
        return(true);
      }
    }
   
   function enableDisableDates(){
      if(document.searchform.f_search_from.value == 'event' ||
         document.searchform.f_search_from.value == 'resource' ||
         document.searchform.f_search_from.value == 'all'){
         document.searchform.f_year.disabled=false;
      }
      else{
         document.searchform.f_year.disabled=true;
      }
 
    }

    function enableDisableSorts(){
      enableDisableDates();
      if(document.searchform.f_search_from.value == 'event' ||
         document.searchform.f_search_from.value == 'all'){
         
        // Clear them all
        document.searchform.f_sort_by.options.length = 0;

        
        var optnTitle = document.createElement("OPTION");
        optnTitle.text = "Name";
        optnTitle.value = "alphab_frwd";
        document.searchform.f_sort_by.options.add(optnTitle);
        
        var optnDate = document.createElement("OPTION");
        optnDate.text = "Date";
        optnDate.value = "date";
        document.searchform.f_sort_by.options.add(optnDate);
        
        var optnVenue = document.createElement("OPTION");
        optnVenue.text = "Venue";
        optnVenue.value = "venue";
        document.searchform.f_sort_by.options.add(optnVenue);
        
        var optnState = document.createElement("OPTION");
        optnState.text = "State";
        optnState.value = "state";
        document.searchform.f_sort_by.options.add(optnState);
      }
      else if(document.searchform.f_search_from.value == 'resource'){
        document.searchform.f_sort_by.options.length = 0;
        
        var optnTitle = document.createElement("OPTION");
        optnTitle.text = "Citation";
        optnTitle.value = "citation";
        document.searchform.f_sort_by.options.add(optnTitle);
      }
      else if(document.searchform.f_search_from.value == 'contributor'){
        // disable Date & Venue Sort bys
        // Clear them all
        document.searchform.f_sort_by.options.length = 0;
        
        var optnTitle = document.createElement("OPTION");
        optnTitle.text = "Name";
        optnTitle.value = "alphab_frwd";
        document.searchform.f_sort_by.options.add(optnTitle);

        var optnState = document.createElement("OPTION");
        optnState.text = "Date";
        optnState.value = "date";
        document.searchform.f_sort_by.options.add(optnState);
      }
      else{
        // disable Date & Venue Sort bys
        // Clear them all
        document.searchform.f_sort_by.options.length = 0;
        
        var optnTitle = document.createElement("OPTION");
        optnTitle.text = "Name";
        optnTitle.value = "alphab_frwd";
        document.searchform.f_sort_by.options.add(optnTitle);

        var optnState = document.createElement("OPTION");
        optnState.text = "State";
        optnState.value = "state";
        document.searchform.f_sort_by.options.add(optnState);
      }
    }
    
   function isBlank(s) {
     if((s == null)||(s == "")) 
      return true;
     for(var i=0;i<s.length;i++) {
      var c=s.charAt(i);
      if((c != ' ') && (c !='\n') && (c != '\t')) return false;
     }
     return true;
   }

  function isInteger (s){
    var i;
    var c;


      // Search through string's characters one by one
      // until we find a non-numeric character.
      // When we do, return false; if we don't, return true.

      for (i = 0; i < s.length; i++){   
          // Check that current character is number.
          c = s.charAt(i);
          if (!isDigit(c)) 
            return false;
      }
      // All characters are numbers.
      return true;
  }

  function isDigit (c){
    return ((c >= "0") && (c <= "9"))
  }
  
  MM_preloadImages('/custom/ausstage/images/ausstage_home_searchon.gif');

  function MM_preloadImages() { 
   var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
     var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
     if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
  }

  function MM_swapImgRestore() { 
   var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
  }

  function MM_findObj(n, d) { 
   var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
     d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
   if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
   for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
  }

  function MM_swapImage() {

   var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
  }
  
  enableDisableSorts();
  
  <%
  // Need to ensure that the option that the user selected, if any, is selected again
  if(request.getParameter("f_sort_by") != null) {
    out.println("for (var i=0;i<document.getElementById('f_sort_by').options.length;i++) {");
    if (request.getParameter("f_sort_by").equals("alphab_frwd")) {
      out.println("if (document.searchform.f_sort_by.options[i].value=='alphab_frwd') { document.searchform.f_sort_by.options[i].selected=true; ");
      out.println("break; }");
    }
    else if (request.getParameter("f_sort_by").equals("date")) {
      out.println("if (document.searchform.f_sort_by.options[i].value=='date') { document.searchform.f_sort_by.options[i].selected=true; ");
      out.println("break; }");
    }
    else if (request.getParameter("f_sort_by").equals("venue")) {
      out.println("if (document.searchform.f_sort_by.options[i].value=='venue') { document.searchform.f_sort_by.options[i].selected=true; ");
      out.println("break; }");
    }
    else if (request.getParameter("f_sort_by").equals("state")) {
      out.println("if (document.searchform.f_sort_by.options[i].value=='state') { document.searchform.f_sort_by.options[i].selected=true; ");
      out.println("break;}");
    }
    else if (request.getParameter("f_sort_by").equals("citation")) {
      out.println("if (document.searchform.f_sort_by.options[i].value=='citation') { document.searchform.f_sort_by.options[i].selected=true; ");
      out.println("break; }");
    }
    out.println("}");
  }%>
  //-->
  </script>


<cms:include property="template" element="foot" />
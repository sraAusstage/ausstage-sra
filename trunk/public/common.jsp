<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat, java.util.Calendar"%>

<%!
public String concatFields(Vector fields, String token) {
  String ret = "";
  for (int i=0; i<fields.size(); i++) {
    if (fields.elementAt(i) != null) {
        if (!(fields.elementAt(i)).equals("") && !ret.equals("")) {
          ret += token;
        }
        ret += fields.elementAt(i);
    }
  }
  return (ret);
}

public String formatDate(String day, String month, String year)
{
  if (year == null || year.equals("") ){
    return "";
}
Calendar calendar = Calendar.getInstance();
  
  SimpleDateFormat formatter = new SimpleDateFormat();
  if (month == null || month.equals("") ){
    formatter.applyPattern("yyyy");
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
   }
  else if(day == null || day.equals("") ){
    formatter.applyPattern("MMMMM yyyy");
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
   }
  else{
    formatter.applyPattern("d MMMMM yyyy");
    calendar.set(Calendar.DAY_OF_MONTH  ,new Integer(day).intValue());
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }

  java.util.Date date = calendar.getTime();
  
  
  String result = formatter.format(date);
  //System.out.println(result + " " + day + month + year);

  return result;

}

public boolean hasValue(String str) {
  if (str != null && !str.equals("")) {
    return true;
  } else {
    return false;
  }
}


public void displayUpdateForm(String                p_id,
                              String                p_type,
                              String                p_object_name,
                              JspWriter             p_out,
                              HttpServletRequest    p_request,
                             
                              admin.AppConstants    p_ausstage_search_appconstants_for_drill) {
  try {	  
	  p_out.println("<script language=\"Javascript\">");
	  p_out.println("<!--");
	  p_out.println("//make the feedback form a dialog");
	  p_out.println("$(document).ready(function(){ ");
	  p_out.println("    	$('#UpdateFormDiv').dialog({ ");
    	  p_out.println("		open:function(event, ui) {");
    	  p_out.println("			$(\".ui-widget-overlay\").click(");
	  p_out.println("				function(e) {"); 
	  p_out.println("	        			$(\"#UpdateFormDiv\").dialog(\"close\");");
	  p_out.println("				});");
    	  p_out.println("			},");
    	  p_out.println("		dialogClass: \"noTitle noPadding\",");
	  p_out.println("		autoOpen: false,");
	  p_out.println("		resizable: true,");
	  p_out.println("		closeOnEscape: true,");
	  p_out.println("	        height: 390,");
          p_out.println("		width: 630,");
	  p_out.println("		modal: true,");
	  p_out.println("		position: 'center'");
	  p_out.println("	 });");
	  p_out.println(" });");
	  
	  p_out.println("function isIE(){");
	  p_out.println("  // do some browser detection");
	  p_out.println("  var isIE = false;");

	  p_out.println("  if (navigator.appVersion.indexOf(\"MSIE\") != -1)");
	  p_out.println("    isIE = true;");
	  p_out.println("  return(isIE);");
	  p_out.println("}");

	  p_out.println("// This function shows or hide the div at the start of each drill down page, that");
	  p_out.println("// can be used by a user to submit changes to the Ausstage administrators");
	  p_out.println("function toggleUpdateForm() {");
	  p_out.println("  var updateFormImg = document.getElementById(\"UpdateFormImg\");");
	  p_out.println("  var updateFormDiv = document.getElementById(\"UpdateFormDiv\");");
	  p_out.println("  var newDivState   = \"none\";");

	  p_out.println("  if (updateFormImg.src.indexOf(\"add.gif\") >= 1) {");
	  p_out.println("    // Must not be showing the div, so show it");
	  p_out.println("    // Use \"\" for firefox and 'block' for IE");
	  p_out.println("    if (!isIE()) {");
	  p_out.println("      newDivState = \"\";");
	  p_out.println("    }");
	  p_out.println("    else {");
	  p_out.println("      newDivState = \"block\";");
	  p_out.println("    }");
	  p_out.println("    // Replace the image");
	  p_out.println("    updateFormImg.src = updateFormImg.src.replace(\"add.gif\",\"delete.gif\");");
	  p_out.println("  }");
	  p_out.println("  else {");
	  p_out.println("    // Replace the image");
	  p_out.println("    updateFormImg.src = updateFormImg.src.replace(\"delete.gif\",\"add.gif\");");
	  p_out.println("  }");

	  p_out.println("  // Show or hide the div");
	  p_out.println("  updateFormDiv.style.display = newDivState;");
	  p_out.println("}");

	  p_out.println("function validateUpdateForm() {");
	 // p_out.println("  var tag					=	document.getElementById(\"f_tag\");");
	  p_out.println("  var userName     = document.getElementById(\"f_public_users_name\");");
	  p_out.println("  var userEmail    = document.getElementById(\"f_public_users_email\");");
	  p_out.println("  var userComments = document.getElementById(\"f_public_users_comments\");");
	  p_out.println("  var ret          = true;");
	
	  p_out.println("  //TIR 61 - A.Keatley 13/05/2008 username and email address arnt mandatory, still validate email address if entered");
	  p_out.println("  if (userEmail.value != '' && (userEmail.value.indexOf(\".\") < 0 || userEmail.value.length < 7 || userEmail.value.indexOf(\"@\") < 0)) {");
	  p_out.println("    ret = false;");
	  p_out.println("    alert('Please enter a valid email address before submitting the comments');");
	  p_out.println("  }");
	  p_out.println("  else if (userComments.value == '') {");
	  p_out.println("    ret = false;");
	  p_out.println("    alert('Please enter your comments');");
	  p_out.println("  }");

	  p_out.println("  if (ret) {");
	  p_out.println("    window.open(\"about:blank\", \"public_comments\", \"status=false,toolbar=false,location=false,menubar=false,height=120px,width=320px\");");
	  p_out.println("    $('#UpdateFormDiv').dialog('close');");	  
	  p_out.println("    document.UpdateForm.submit();");
	  p_out.println("  }");
	  p_out.println("}");
	  p_out.println("-->");
	  p_out.println("</script>");
	  

    p_out.println("<table style=\"float: right;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    p_out.println("  <tr align='left' ><td align='left' nowrap ><a href='csv.jsp?id=" + p_request.getParameter("id") + "' align='left' >Export</a> | <a style=\"cursor:pointer\" onclick=\"$('#UpdateFormDiv').dialog('open');\">Feedback</a> | ");
   
    if (p_type != null && (p_type.equals("Event"))){
    	p_out.println("<a href='/pages/map/?complex-map=true&c=&o=&v=&e=" + p_request.getParameter("id") + "' align='left' >Map</a> | <a href='/pages/network/?task=event-centric&rs=3&id=" + p_request.getParameter("id") + "' align='left' >Network</a> | ");
    	
    }
    if (p_type != null && (p_type.equals("Contributor"))){
    	p_out.println("<a href='/pages/map/?complex-map=true&c=" + p_request.getParameter("id") + "&o=&v=&e=' align='left' >Map</a> | <a href='/pages/network/?task=ego-centric&id=" + p_request.getParameter("id") + "' align='left' >Network</a> | ");
    	
    }
    if (p_type != null && (p_type.equals("Organisation"))){
    	p_out.println("<a href='/pages/map/?complex-map=true&c=&o=" + p_request.getParameter("id") + "&v=&e=' align='left' >Map</a> | ");
    	
    }
    if (p_type != null && (p_type.equals("Venue"))){
    	p_out.println("<a href='/pages/map/?complex-map=true&c=&o=&v=" + p_request.getParameter("id") + "&e=' align='left' >Map</a> | ");
    	
    }
    p_out.println("<a href='#' align='left' onclick='window.print();return false;'>Print</a></td></tr>");
    
    p_out.println("</table>");
    
    /**p_out.println("<DIV style=\"float:right; padding-top: 15px;\">");
    p_out.println("<input type=\"button\" id=\"browse_add_btn\" value=\"Add To Map\"/>  ");
    p_out.println("<span id=\"show_browse_help\" class=\"helpIcon clickable\"></span>");
    p_out.println("</div>");*/
    p_out.println("<DIV id='UpdateFormDiv' style=\"display:none;\">");
    p_out.println("<form name=\"UpdateForm\" id=\"UpdateForm\" method=\"POST\" action=\"/pages/ausstage/public_comments.jsp\" target=\"public_comments\">");
   // p_out.println("   <table align=\"center\" cellpadding=\"0\" cellspacing=\"0\">");
   // p_out.println("   <tr>");
   // p_out.println("   <td>");
    p_out.println("     <table width='100%' border='0' cellpadding='2' cellspacing='0'>");

    if (p_type != null && p_type.equals("Resource")) {
     // p_type += "&nbsp;Title";
    }
    else {
     // p_type += "&nbsp;Name";
    }
    p_out.println("     <tr>");
    p_out.println("       <td  align='right'  class='general_heading_light' valign='top'>&nbsp;" + p_type + "</td>");
    p_out.println("       <td width='0%'>&nbsp;</td>");
    p_out.println("       <td  align='left' valign='top'><b>" + p_object_name + "</b><input type='hidden' name='f_object_name' id='f_object_name' value='" + p_object_name + "'></td>");
    p_out.println("     </tr>");
      
    p_out.println("     <tr>");
    p_out.println("       <td width=\"25%\" align='right'  class='general_heading_light nowrap' valign='top'>&nbsp;" + p_type + "&nbsp;Identifier</td>");
    p_out.println("       <td width=\"0%\">&nbsp;</td>");
    p_out.println("       <td width=\"75%\"  valign='top'>" + p_id + "<input type='hidden' name='f_object_id' id='f_object_id' value='" + p_id + "'><input type='hidden' name='f_object_type' id='f_object_type' value='" + p_type + "'></td>");
    p_out.println("     </tr>");

   // p_out.println("     <tr>");
   // p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Tag</td>");
   // p_out.println("       <td>&nbsp;</td>");
   // p_out.println("       <td  valign='top'><input type='text' name='f_tag' id='f_tag' class='line350' maxlength=20></td>");
   // p_out.println("     </tr>");
    //TIR 61 - A.Keatley 13/05/2008 - Display comments field above the name and email fields
    p_out.println("     <tr>");
    p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Comments</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><textarea rows=6 cols=50 name='f_public_users_comments' id='f_public_users_comments'></textarea></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Name</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><input type='text' name='f_public_users_name' id='f_public_users_name' maxlength=30 size='50'></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'>&nbsp;Email</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><input type='text' name='f_public_users_email' id='f_public_users_email' maxlength=80 size='50'></td>");
    p_out.println("     </tr>");
    
	p_out.println("     <tr class='text-veri'>");
	p_out.println("       <td  align='right'  class='general_heading_light' valign='top'><label for='f_text_veri'>Leave this field blank</lable></td>");
	p_out.println("       <td width='0%'>&nbsp;</td>");
	p_out.println("       <td  align='left' valign='top'><input type='text' name='f_text_veri' id='f_text_veri' /></td>");
	p_out.println("     </tr>");
	    
    p_out.println("     <tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'></td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td align='right' valign='top'><table><tr><td align=\"left\">Please include your name and email address with your contribution. We will respect the <a href='../learn/contact/privacy.html'>privacy</a> of your information.</td></tr></table></td>");
    p_out.println("     </tr><br><tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'></td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td align=\"left\" valign='top'><table><tr><td align=\"left\"><i>Contributions are reviewed for accuracy and relevance before they are added to AusStage.</i></td></td></table></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td align='right' colspan='3'><a href=\"#\" onclick=\"javascript:validateUpdateForm();\"><img src='/resources/images/ok.gif' border='0' alt='Provide feedback on this record'></td>");
    p_out.println("     </tr>");
    
    p_out.println("     </table>");
   // p_out.println("   </td>");
   // p_out.println("   </tr>");
   // p_out.println("   </table><br>");
    p_out.println("</form>");
    p_out.println("</DIV>");

    
  }
  catch (java.io.IOException e) {
  }  
}

%>
<%
admin.AppConstants AppConstants = new admin.AppConstants(request);
%>
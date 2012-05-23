<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

<script type="text/javascript">

function CreateExcelSheet()
{
var x=myTable.rows
var xls = new ActiveXObject("Excel.Application")
xls.visible = true
xls.Workbooks.Add
for (i = 0; i < x.length; i++)
{
var y = x[i].cells

for (j = 0; j < y.length; j++)
{
xls.Cells( i+1, j+1).Value = y[j].innerText
}
}
}
</script>
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

  return result.replaceAll(" ","&nbsp;");

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
	  p_out.println("  var tag					=	document.getElementById(\"f_tag\");");
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
	  p_out.println("    window.open(\"about:blank\", \"public_comments\", \"status=false,toolbar=false,location=false,menubar=false,height=120px,width=300px\");");
	  p_out.println("    document.UpdateForm.submit();");
	  p_out.println("    toggleUpdateForm();");
	  p_out.println("  }");
	  p_out.println("}");
	  p_out.println("-->");
	  p_out.println("</script>");
	  
    p_out.println("<form name=\"UpdateForm\" id=\"UpdateForm\" method=\"POST\" action=\"/pages/ausstage/public_comments.jsp\" target=\"public_comments\">");
    p_out.println("<table width=\"98%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    p_out.println("  <tr><td align='right' >Comment on/Tag this record&nbsp;&nbsp;&nbsp;<a style=\"cursor:pointer\" onclick=\"javascript:toggleUpdateForm();\"><img id=\"UpdateFormImg\" border=\"0\" src='/resources/images/add.gif'></a></td></tr>");
    p_out.println("</table>");
   
   /*p_out.println("<DIV style=\"float:right; padding-top: 15px;\">");
    p_out.println("<input type=\"button\" id=\"browse_add_btn\" value=\"Add To Map\"/>  ");
    p_out.println("<span id=\"show_browse_help\" class=\"helpIcon clickable\"></span>");
    p_out.println("</div>");*/ 
    p_out.println("<DIV id='UpdateFormDiv' style=\"display:none;\">");
    p_out.println("   <table align=\"center\" width=\"98%\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#EFFFEF;border-color:#7EBA5E\">");
    p_out.println("   <tr>");
    p_out.println("   <td>");
    p_out.println("     <table width='100%' border='0' cellpadding='3' cellspacing='0'>");

    if (p_type != null && p_type.equals("Resource")) {
      p_type += "&nbsp;Title";
    }
    else {
      p_type += "&nbsp;Name";
    }
    p_out.println("     <tr>");
    p_out.println("       <td width=\'25%' align='right'  class='general_heading_light' valign='top'>&nbsp;" + p_type + "</td>");
    p_out.println("       <td width='0%'>&nbsp;</td>");
    p_out.println("       <td width='75%'  valign='top'><b>" + p_object_name + "</b><input type='hidden' name='f_object_name' id='f_object_name' value='" + p_object_name + "'></td>");
    p_out.println("     </tr>");
    
  
    
    p_out.println("     <tr>");
    p_out.println("       <td width=\"25%\" align='right'  class='general_heading_light' valign='top'>&nbsp;" + p_type + "&nbsp;Identifier</td>");
    p_out.println("       <td width=\"0%\">&nbsp;</td>");
    p_out.println("       <td width=\"75%\"  valign='top'>" + p_id + "<input type='hidden' name='f_object_id' id='f_object_id' value='" + p_id + "'><input type='hidden' name='f_object_type' id='f_object_type' value='" + p_type + "'></td>");
    p_out.println("     </tr>");

    p_out.println("     <tr>");
    p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Tag</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><input type='text' name='f_tag' id='f_tag' class='line350' maxlength=20></td>");
    p_out.println("     </tr>");
    //TIR 61 - A.Keatley 13/05/2008 - Display comments field above the name and email fields
    p_out.println("     <tr>");
    p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Comments</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><textarea rows=6 name='f_public_users_comments' id='f_public_users_comments' class='line350'></textarea></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td align='right' class='general_heading_light' valign='top'>&nbsp;Name</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><input type='text' name='f_public_users_name' id='f_public_users_name' class='line350' maxlength=30></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'>&nbsp;Email</td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td  valign='top'><input type='text' name='f_public_users_email' id='f_public_users_email' class='line350' maxlength=80></td>");
    p_out.println("     </tr>");
    
    p_out.println("     <tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'></td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td align='right' valign='top'><table><tr><td align=\"left\">Please include your name and email address with your contribution. We will not provide your personal information to any other person or organisation.</td></tr></table></td>");
    p_out.println("     </tr><br><tr>");
    p_out.println("       <td  align='right' class='general_heading_light' valign='top'></td>");
    p_out.println("       <td>&nbsp;</td>");
    p_out.println("       <td align=\"left\" valign='top'><table><tr><td align=\"left\"><i>Contributions are reviewed for accuracy and relevance before they are added to AusStage.</i></td></td></table></td>");
    p_out.println("     </tr>");

    
    p_out.println("     <tr>");
    p_out.println("       <td align='right' colspan='3'><a href=\"#\" onclick=\"javascript:validateUpdateForm();\"><img src='/resources/images/ok.gif' border='0' alt='Comment on this record'></td>");
    p_out.println("     </tr>");
    
    p_out.println("     </table>");
    p_out.println("   </td>");
    p_out.println("   </tr>");
    p_out.println("   </table><br>");

    p_out.println("</DIV>");
    p_out.println("</form>");
    
    if (p_request.getParameter("") != null && !p_request.getParameter("").equals("")) {
    }
  }
  catch (java.io.IOException e) {
  }  
}
%>


<%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String org_id               = request.getParameter("id");
  String location             = "";
  Vector item_evlinks;
  Vector item_orglinks;
  Vector item_creator_orglinks;
  Vector item_venuelinks;
  Vector item_conlinks;
  Vector work_conlinks;
  Vector item_creator_conlinks;
  Vector item_artlinks;
  Vector item_secgenrelinks;
  Vector item_worklinks;
  Vector item_itemlinks;
  Vector item_contentindlinks;
    List<String> groupNames = new ArrayList();	
	if (session.getAttribute("userName")!= null) {
		CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
		CmsObject cmsObject = cms.getCmsObject();
		List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
		for(CmsGroup group:userGroups) {
		   	groupNames.add(group.getName());
			}
	}

  State state = new State(db_ausstage_for_drill);
  Event event = null;
  
  DescriptionSource descriptionSource;
  Datasource datasource;
  Datasource datasourceEvlink;

  Venue venue = null;
  PrimaryGenre primarygenre;
  SecGenreEvLink secGenreEvLink;
  Country country;
  PrimContentIndicatorEvLink primContentIndicatorEvLink;
  OrgEvLink orgEvLink;
  Organisation organisation;
  Organisation organisationCreator = null;
  ConEvLink conEvLink;
  Contributor contributor = null;
  Contributor contributorCreator = null;
  Item item;
  LookupCode item_type = null;
  LookupCode item_sub_type = null;
  LookupCode language;
  SecondaryGenre secondaryGenre = null;
  Work work = null;
  Item assocItem = null;
  ContentIndicator contentIndicator = null; 
  
  SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
  
  // Table settings for main result display
  String baseTableWdth = "100%";
  String baseCol1Wdth  = "200";  // Headings
  String baseCol2Wdth  = "8";   // Spacer
  String baseCol3Wdth  = "";  // Details for Heading
  // Table settings for secondary table required under a heading in the main result display
  String secTableWdth = "100%";
  String secCol1Wdth  = "30%";
  String secCol2Wdth  = "70%";
  boolean displayUpdateForm = true;
  admin.Common Common = new admin.Common();  


    ///////////////////////////////////
    //    DISPLAY ORGANISATION DETAILS
    //////////////////////////////////
    
    organisation = new Organisation(db_ausstage_for_drill);
    organisation.load(Integer.parseInt(org_id));
    country = new Country(db_ausstage_for_drill);
    
    if (displayUpdateForm) {
      displayUpdateForm(org_id, "Organisation", organisation.getName(),
                        out,
                        request,
                      
                        ausstage_search_appconstants_for_drill);
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Organisation Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/organisation_addedit.jsp?act=edit&f_selected_organisation_id=" + organisation.getId() + "'>Edit</a>");

    out.println("   <table align=\"center\" width='98%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
    
    //Name
   out.println("   <tr class=\"b-185\">");
    out.println("     <td  align='right' width ='25%'   class='general_heading_light' valign='top'>Organisation Name</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td width ='75%' ><b>" + organisation.getName() + "</b></td>");
    out.println("   </tr>");
    
    //Other Names
    if (organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals("") || organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals("") || organisation.getOtherNames3() != null && !organisation.getOtherNames3().equals("")) {
    out.println("   <tr>");
    out.println("     <td align='right' class='general_heading_light' valign='top'>Other names</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >");
    // other name 1
    if(organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals(""))
      out.println(organisation.getOtherNames1());
    // other name 2
    if(organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals("")){
      if(organisation.getOtherNames1() != null && !organisation.getOtherNames1().equals(""))
        out.println("<br>");
      out.println(organisation.getOtherNames2());
    }
    // other name 3
    if(organisation.getOtherNames3() != null && !organisation.getOtherNames3().equals("")){
      if(organisation.getOtherNames2() != null && !organisation.getOtherNames2().equals(""))
        out.println("<br>");
      out.println(organisation.getOtherNames3());
    }
    out.println(      "</td>");
    out.println("   </tr>");
    }
    
    //Address
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right' class='general_heading_light' valign='top'>Address</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >" + organisation.getAddress());
    
    if (hasValue(organisation.getAddress()) && (hasValue(organisation.getSuburb()) || hasValue(organisation.getStateName()) || hasValue(organisation.getPostcode())))
      out.print("<br>");
    if (hasValue(organisation.getSuburb())) 
      out.print(organisation.getSuburb() + " ");
    if (hasValue(organisation.getStateName())) 
      out.print(organisation.getStateName() + " ");
    if (hasValue(organisation.getPostcode()))
      out.print(organisation.getPostcode());
   
    if(hasValue(organisation.getCountry())){
      country.load(Integer.parseInt(organisation.getCountry()));
      out.println("   <br>" +  country.getName() + "");
    }
    out.println(      "</td>");
    out.println("   </tr>");
    
    //Website
    if (organisation.getWebLinks() != null && !organisation.getWebLinks().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td align='right' class='general_heading_light' valign='top'>Website</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td ><a href=\"");
	    if(organisation.getWebLinks().indexOf("http://") < 0)
	      out.println("http://");
	    out.println(organisation.getWebLinks() + "\">" + organisation.getWebLinks() + "</a>" );
	    %>
	    
		<script type="text/javascript">
		if (typeof Thumboo == 'undefined'){
			var thumboo_init_options= {
					"api_url":"counter15.goingup.com/thumboo/api.php",
					"uid":"e188aad0fdbef59810e4b66c1430a856",
					"url":"<%=organisation.getWebLinks()%>",
					"size":"150x100",
					"imgpath":"counter15.goingup.com/thumboo",
					"link":1
			};
			document.write(unescape('%3Cscript type="text/javascript" src="'+
			document.location.protocol+'//counter15.goingup.com/thumboo/thumboo_original.js"%3E%3C/script%3E')); }else{ Thumboo.add('<%=organisation.getWebLinks()%>',1);}
		</script>
	<%
	out.println("   </td>"); 
	    out.println("   </tr>");    
    }
   
    //Functions
    if (organisation.getFunction(Integer.parseInt(org_id)) != null && !organisation.getFunction(Integer.parseInt(org_id)).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right' class='general_heading_light' valign='top'>Functions</b></td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >" + organisation.getFunction(Integer.parseInt(org_id)) + "</td>");
	    out.println("   </tr>");
    }
   
    //Notes
    if (organisation.getNotes() != null && !organisation.getNotes().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right' class='general_heading_light' valign='top'>Notes</b></td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >" + organisation.getNotes() + "</td>");
	    out.println("   </tr>");
    }
  %>  
    <script type="text/javascript">
    function displayRow(name){
    	document.getElementById("function").style.display = 'none';
    	document.getElementById("functionbtn").style.backgroundColor = '#c0c0c0';
    	document.getElementById("organisation").style.display = 'none';
    	document.getElementById("organisationbtn").style.backgroundColor = '#c0c0c0';
    	document.getElementById("contributor").style.display = 'none';
    	document.getElementById("contributorbtn").style.backgroundColor = '#c0c0c0';
    	document.getElementById("events").style.display = 'none';
    	document.getElementById("eventsbtn").style.backgroundColor = '#c0c0c0';

    	document.getElementById(name).style.display = '';
    	document.getElementById(name+"btn").style.backgroundColor = '#000000';
    	
    }
    
    function showHide(name) {
    	if (document.getElementById(name).style.display != 'none') {
    		document.getElementById(name).style.display = 'none';
    	} else {
    		document.getElementById(name).style.display = ''
    	}

    }
    </script>
    <style type="text/css">
 
 #tabs {
 padding: 10px;
 padding-top:35px;
 }
 #tabs a {
   padding-top: 8px;
   padding-bottom: 8px;
   padding-left: 14px;
   padding-right: 10px;
   text-decoration: none;
   background-color: #c0c0c0;
    color: white;
    }   
 
    #tabs a:hover {
    background-color: #bbbbbb;
    }
    
    #tabs .currentPage {
    background-color: #333333;
    }
    
    #tabs a:active {
    background-color: black;
    }
    </style>
    <tr>
    <td align='right' class='general_heading_light' valign='top'></td>
    <td>&nbsp;</td>
    <td id="tabs" colspan=3>
    	<a href="#" onclick="displayRow('events')" id='eventsbtn'>Events</a>
    	<a href="#" onclick="displayRow('function')" id='functionbtn'>Functions</a>
    	<a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisation</a>
    	<a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributor</a>    	
    </td>
    </tr>
    
    
<%
    
    
    //Associated Events
    out.println("   <tr id='events'>");
    event = new Event(db_ausstage_for_drill);
    crset = event.getEventsByOrg(Integer.parseInt(org_id));
    int orgEventCount = 0;
    
   if(crset.next())
   {
     do
     {
       if(orgEventCount==0){
       out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
       out.println("     <td>&nbsp;</td>");
       out.println("     <td  valign=\"top\">");
       out.println("     <ul>");
       orgEventCount++;
     }
        out.print("<li><a href=\"/pages/event/?id=" +
                    crset.getString("eventid") + "\">" +
                    crset.getString("event_name") + "</a>");
        if(hasValue(crset.getString("venue_name")))
          out.print(", " + crset.getString("venue_name"));
        
        if(hasValue(crset.getString("suburb")))
          out.print(", " + crset.getString("suburb")); 
        
        if(hasValue(crset.getString("state")))
          out.print(", " + crset.getString("state")); 

        if (hasValue(crset.getString("DDFIRST_DATE")) || hasValue(crset.getString("MMFIRST_DATE")) || hasValue(crset.getString("YYYYFIRST_DATE")))
          out.print(", " + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE")));

        out.println("</li>");
      }while(crset.next());
      if(orgEventCount > 0)
      out.println("</ul>");
    }//else{
      //out.println("No other events to display.");
   // }
    out.println("     </td>");
    out.println("   </tr>");

    
    
    //Events by function
    admin.AppConstants constants = new admin.AppConstants();
    ausstage.Database     m_db = new ausstage.Database ();
    m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
    Statement stmt1    = m_db.m_conn.createStatement ();
    String sqlString = "";
    CachedRowSet l_rs = null; 
    int eventfunccount = 0;
    int i=0;
    sqlString = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date, "+
    "events.yyyyfirst_date,events.first_date,venue.venue_name,venue.suburb,states.state,`orgfunctmenu`.`orgfunction` "+
    "FROM events,venue,states,orgevlink,`organisation`,`orgfunctmenu` "+
    "inner join ( "+
    "SELECT ce.organisationid, cf.orgfunctionid, count(*) num  "+
    "FROM orgevlink ce,orgfunctmenu cf "+
    "where ce.function=cf.orgfunctionid  "+
    "and ce.organisationid=" + org_id + " "+
    "group by cf.orgfunction"+
    " ) evcount ON (evcount.orgfunctionid = orgfunctmenu.orgfunctionid)  "+
    " where organisation.organisationid=" + org_id  + " "+
    "and organisation.organisationid=orgevlink.organisationid "+
    "and orgevlink.eventid=events.eventid "+
    "and events.venueid=venue.venueid "+
    "and venue.state=states.stateid "+
    "AND orgevlink.function=orgfunctmenu.orgfunctionid "+
    "order by evcount.num desc, orgfunctmenu.orgfunction,events.first_date desc";
    
    l_rs = m_db.runSQL(sqlString, stmt1);
    
    out.println("<tr id='function'>");
     String prevFunc = "";
     if(l_rs.next()){
    	 do{
    		 if(eventfunccount==0){
 		 			out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
 	        out.println("     <td>&nbsp;</td>");
 	        out.println("     <td  valign=\"top\">");
    		 }
  	     eventfunccount++;
  	     
  	     if (!prevFunc.equals(l_rs.getString("orgfunction"))) {
 	        	if (eventfunccount > 1) {
 	        		out.print("</ul>");
 	        	}
 	        	out.print(l_rs.getString("orgfunction")+ "<br><ul>");
 	        	prevFunc = l_rs.getString("orgfunction");
 	        }
 	        out.print("<li><a href=\"/pages/event/?id=" +
 	        		l_rs.getString("eventid") + "\">"+l_rs.getString("event_name")+"</a>");
          if(hasValue(l_rs.getString("venue_name")))
            out.print(", " +  l_rs.getString("venue_name"));
          if(hasValue(l_rs.getString("suburb"))) 
           out.print(", " + l_rs.getString("suburb"));
          if(hasValue(l_rs.getString("state")))
           out.print(", " + l_rs.getString("state"));
          if (hasValue(l_rs.getString("DDFIRST_DATE")) || hasValue(l_rs.getString("MMFIRST_DATE")) || hasValue(l_rs.getString("YYYYFIRST_DATE")))
           out.print(", " + formatDate(l_rs.getString("DDFIRST_DATE"),l_rs.getString("MMFIRST_DATE"),l_rs.getString("YYYYFIRST_DATE")));
       out.println("</li>"); 
    	 }while(l_rs.next());
    	 if(eventfunccount>0)
    	 out.println("</ul>");
    	 out.println("</td>");
     }out.println("   </tr>");
     
     
     //Events by organisation type
     
     Statement stmt2    = m_db.m_conn.createStatement ();
     String sqlString2 = "";
     CachedRowSet eo_rs = null; 
     int eventorgcount = 0;
      sqlString2 = 
    "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
  	" events.yyyyfirst_date,events.first_date,venue.venue_name,venue.suburb,states.state,`organisation_type`.`type`, evcount.num  "+
  	"   FROM events,venue,states,orgevlink,`organisation`,`organisation_type`  "+
  	"inner join (SELECT ce.organisationid, cf.organisation_type_id, count(*) num "+
  	"FROM organisation ce,organisation_type cf  where ce.organisation_type_id=cf.organisation_type_id  and ce.organisationid=" + org_id + " "+
  	"group by cf.type)evcount ON (evcount.organisation_type_id = `organisation_type`.`organisation_type_id`) "+
  	"where organisation.organisationid=" + org_id + " AND " + 
  	" organisation.organisationid=orgevlink.organisationid AND "+
  	" orgevlink.eventid=events.eventid and "+
  	"events.venueid = venue.venueid AND "+
  	"venue.state = states.stateid AND "+
  	"organisation.organisation_type_id = organisation_type.organisation_type_id "+
	"order by evcount.num desc, organisation_type.type,events.first_date desc ";
     eo_rs = m_db.runSQL(sqlString2, stmt2);
     
     out.println("<tr id='organisation'>");
      String prevOrg = "";
      if(eo_rs.next()){
     	 do{
     		if(eventorgcount==0){
  		 			out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
  	        out.println("     <td>&nbsp;</td>");
  	        out.println("     <td  valign=\"top\">");
  	        
     		 }
     		 eventorgcount++;
     		 if (!prevOrg.equals(eo_rs.getString("type"))) {
  	        	if (eventorgcount > 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print(eo_rs.getString("type")+ "<br><ul>");
  	        	prevOrg = eo_rs.getString("type");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
  	        		eo_rs.getString("eventid") + "\">"+eo_rs.getString("event_name")+"</a>");
           if(hasValue(eo_rs.getString("venue_name")))
             out.print(", " +  eo_rs.getString("venue_name"));
           if(hasValue(eo_rs.getString("suburb"))) 
            out.print(", " + eo_rs.getString("suburb"));
           if(hasValue(eo_rs.getString("state")))
            out.print(", " + eo_rs.getString("state"));
           if (hasValue(eo_rs.getString("DDFIRST_DATE")) || hasValue(eo_rs.getString("MMFIRST_DATE")) || hasValue(eo_rs.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(eo_rs.next());
     	if(eventorgcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
      
      //Contributors by organisation
	Statement stmt3 	= m_db.m_conn.createStatement();
	String sqlString3	= "";
	CachedRowSet co_org	= null;
	int contributororgcount = 0;
	sqlString3		= "SELECT Distinct contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) as name,contributor.last_name, contributor.first_name, organisation.name, organisation.organisationid "+
				  "FROM contributor "+
				  "Inner JOIN conorglink ON (contributor.contributorid = conorglink.contributorid) "+
				  "Inner JOIN organisation ON (conorglink.organisationid = organisation.organisationid) "+
				  "where organisation.organisationid= "+ org_id;
	co_org			= m_db.runSQL(sqlString3, stmt3);
	
	out.println("<tr id='contributor'>");
	if(co_org.next())	
	{
	  do
	  {
	    if(contributororgcount==0)
	    {
	      out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
	      out.println("     <td>&nbsp;</td>");
  	      out.println("     <td  valign=\"top\">");		
  	    }
  	    contributororgcount++;	
  	    out.print("<li><a href=\"/pages/event/?id=" +
  	        		co_org.getString("contributorid") + "\">"+co_org.getString("name")+"</a>");  
  	    out.println("</li>");
  	  }while(co_org.next());
  	  if(contributororgcount > 0)
  	  out.println("</ul>");
     	  out.println("</td>");
        }out.println("   </tr>");
  	    
  	    
     
     //Works
    rset = organisation.getAssociatedWorks(Integer.parseInt(org_id), stmt);
    int rowWorksCount=0;
    out.println("   <tr class=\"b-185\">");
    
    if(rset != null)
    {
      while(rset.next())
      {
    	  if (rowWorksCount == 0) 
    	  {
	    	  out.println("     <td align='right' class='general_heading_light' valign='top'>Works</td>");
	    	  out.println("     <td>&nbsp;</td>");
	    	  out.println("     <td >");
	    	  out.println("<table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    	  rowWorksCount++;
	    	}
    	  
        out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/work/?id=" +
                         rset.getString("workid") + "\">" +
                         rset.getString("work_title") + "</a></td>");
         out.println("</tr>");  
      }
    }if(rowWorksCount > 0){
    out.println("      </table>");
    out.println("     </td>");
    out.println("   </tr>");
    }
    
   //Resources
    rset = organisation.getAssociatedItems(Integer.parseInt(org_id), stmt);
    int orgResourcesCountfalse=0;
    out.println("   <tr>");
    
    if(rset != null)
    {
      while(rset.next())
      {
    	  if(orgResourcesCountfalse==0)
    	  {
    	    out.println("     <td align='right' class='general_heading_light' valign='top'>Resources</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td >");
    	    out.println("       <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
      	  orgResourcesCountfalse++;
    	  }
    	    //  Items
    	    // Display Items via the itemorglink table and via item.institutionid.
        out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/resource/?id=" +
                         rset.getString("itemid") + "\">" +
                         rset.getString("citation") + "</a> ");
        //out.println("&nbsp " + rset.getString("name") + ", " + rset.getString("state") + "</td>");
        out.print("</td>");
        out.println("</tr>");
      }
    }
    if(orgResourcesCountfalse > 0){
        out.println("      </table>");
        out.println("     </td>");
        out.println("   </tr>");
    }
    
   //Identifier   
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right' class='general_heading_light' valign='top'>Organisation Identifier</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >" + organisation.getId() + "</td>");
    out.println("   </tr>");
    
     out.println("   <tr>");
    out.println("     <td>&nbsp; </td>");
    out.println("   </tr>");
    out.println(" </table>");

  
  // close statement
  stmt.close();
%>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>
  <!-- AddThis Button BEGIN -->
    <div align="right" class="addthis_toolbox addthis_default_style ">
      <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
      <a class="addthis_button_tweet"></a>
      <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
      <a class="addthis_counter addthis_pill_style"></a>
    </div>
<script>displayRow("events");</script>
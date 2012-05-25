<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar, java.util.Date, java.text.SimpleDateFormat"%>
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
    p_out.println("<table style=\"float: right;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    p_out.println("  <tr><td align='right' >Comment on/Tag this record&nbsp;&nbsp;&nbsp;<a style=\"cursor:pointer\" onclick=\"javascript:toggleUpdateForm();\"><img id=\"UpdateFormImg\" border=\"0\" src='/resources/images/add.gif'></a></td></tr>");
    p_out.println("<tr><td><a href='#' align='right' onclick='window.print();return false;'>Print</a></td></tr>");
    p_out.println("<tr><td><a href='csv.jsp?id=" + p_request.getParameter("id") + "' align='right' >Export to excel</a></td></tr>");
    p_out.println("<tr><td><a href='/pages/network/?task=event-centric&id=" + p_request.getParameter("id") + "&rs=1' align='right' >Network</a> | <a href='/pages/map/?complex-map=true&c=&o=&v=&e=" + p_request.getParameter("id") + "' align='left' >Map</a></td></tr>");
    p_out.println("</table>");
    
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
	
	List<String> groupNames = new ArrayList();	
	if (session.getAttribute("userName")!= null) {
		CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
		CmsObject cmsObject = cms.getCmsObject();
		List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
		for(CmsGroup group:userGroups) {
		   	groupNames.add(group.getName());
			}
	}
	

  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String event_id             = request.getParameter("id");
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
    //    DISPLAY EVENT DETAILS
    //////////////////////////////////
    
    event = new Event(db_ausstage_for_drill);
    event.load(Integer.parseInt(event_id));
    descriptionSource = new DescriptionSource(db_ausstage_for_drill);
    
    if (displayUpdateForm) {
      displayUpdateForm(event_id, "Event", event.getEventName(),
                        out,
                        request,
                      
                        ausstage_search_appconstants_for_drill);
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Event Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/event_addedit.jsp?mode=edit&f_eventid=" + event.getEventid() + "'>Edit</a>");

//Event Name
    out.println("   <table align=\"center\" width=\"98%\" border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
    out.println("   <tr class=\"b-185\">");
    out.println("     <td width='25%' class='general_heading_light f-186' valign='top' align='right'>Event Name</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td width='75%'   valign=\"top\"><b>" + event.getEventName() + "</b></td>");
    out.println("   </tr>");
    
  // Not sure if this is needed but dont thing so.
  /*
      // Load up the Country object
    Country venueCountry = new Country(db_ausstage_for_drill);
    if (!event.getVenue().getCountry().equals("")) {
      venueCountry.load(Integer.parseInt(event.getVenue().getCountry()));
    }
    
    // build the venue location
    Vector venueVector = new Vector();
    venueVector.addElement(event.getVenue().getSuburb());
    venueVector.addElement(state.getName(Integer.parseInt(event.getVenue().getState())));
    if (!event.getVenue().getCountry().equals("") && !venueCountry.getName().toUpperCase().equals("AUSTRALIA")) {
      venueVector.addElement(venueCountry.getName());
    }
    location = concatFields(venueVector, ", ");
    */
    
    
     //Venue
     
    // Get venue location string
    String venueLocation = ""; 
    if (event.getVenue().getSuburb() != null && !event.getVenue().getSuburb().equals (""))
      venueLocation = ", " + event.getVenue().getSuburb();
    if (event.getVenue().getState() != null && !event.getVenue().getState().equals (""))
     venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));
     
    out.println("   <tr>");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Venue</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">");
    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    out.println("         <tr>");
    out.println("           <td  valign=\"top\"><a href=\"/pages/venue/?id=" + event.getVenueid() + "\">" + event.getVenue().getName() + "</a>" + venueLocation + "</td>");
    out.println("         </tr>");
    out.println("       </table>");
    out.println("   </tr>");
  
    //Unbrella Event
    if (event.getUmbrella() != null && !event.getUmbrella().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Umbrella Event</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + event.getUmbrella() + "</td>");
	    out.println("   </tr>");
    }
    
    
    	
   	//First Date
   	if (!formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate()).equals("")) {
   		out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>First date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >");

	    out.println(formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate()));
	    out.println("     </td>");
	    out.println("   </tr>");
   	}
   	
    //Opening Date
    if (!formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate()).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Opening date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate()));
	    
	    out.println("     </td>");
	    out.println("   </tr>");
    }
    
    //Last Date
    if (!formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate()).equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Last date</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate()));
	    out.println(formatted_date);
	    out.println("     </td>");
	    out.println("   </tr>");
    }
    //Dates Estimated
    out.println("   <tr class=\"b-185\">");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Dates Estimated</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">" + Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()),true) + "</td>");
    out.println("   </tr>");

    //Status
		if (event.getStatus() != null && !event.getStatus().equals("")) {
	    out.println("   <tr>");
	    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Status</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    if(event.getStatus() != null)
	      out.println(event.getEventStatus(event.getStatus()));
	    out.println("     </td>");
	    out.println("   </tr>");
		}
    //World Premier
  
    out.println("   <tr>");
    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>World Premiere</td>");
    out.println("     <td>&nbsp;</td>");
    if(event.getWorldPremier())
      out.println("     <td  valign=\"top\">Yes</td>");
    else
      out.println("     <td  valign=\"top\">No</td>");
    out.println("   </tr>");
    

    
    
    
    //Description
    if (event.getDescription() != null && !event.getDescription().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Description</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + event.getDescription() + "</td>");
	    out.println("   </tr>");
    }
    
    //Description Source
    if (event.getDescriptionSource() != null && !event.getDescriptionSource().equals("") && !event.getDescriptionSource().equals("0")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Description Source</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource())));
	    out.println("     </td>");
	    out.println("   </tr>");    
  	}
    
    // PRIMARY GENRE //
    out.println("   <tr>");
    out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Primary Genre</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td  valign=\"top\">");
    primarygenre = new PrimaryGenre(db_ausstage_for_drill);
    primarygenre.load(Integer.parseInt(event.getPrimaryGenre()));
    out.println(primarygenre.getName());
    out.println("     </td>");
    out.println("   </tr>");

    //  SECONDARY GENRE //
    int eventGenreCounter=0;
    out.println("   <tr>");
    for (int i=0; i < event.getSecGenreEvLinks().size(); i++)
    {
    	if(eventGenreCounter==0)
    	{
    		out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Secondary Genre</td>");
   	    out.println("     <td>&nbsp;</td>");
   	    out.println("     <td  valign=\"top\">");
   	 		eventGenreCounter++;
    	}
      secGenreEvLink = (SecGenreEvLink) event.getSecGenreEvLinks().get(i);
      SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
      tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
      out.println("<a href=\"/pages/genre/?id=" + secGenreEvLink.getSecGenrePreferredId() + "\">" + tempSecGenre.getName() + "<br>");
    }
    if(eventGenreCounter >0){
    out.println("      </td>");
    out.println("   </tr>");
    }

    //  PRIMARY CONTENT INDICATOR //  
    //Subjects
    out.println("   <tr>");
    int eventCICount=0;
    for (int i=0; i < event.getPrimContentIndicatorEvLinks().size(); i++)
    {
    	 if(eventCICount==0)
    	 {	
    		 out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Subjects</td>");
    		 out.println("     <td>&nbsp;</td>");
    		 out.println("     <td  valign=\"top\">");
    		 eventCICount++;
    	 }
      primContentIndicatorEvLink = (PrimContentIndicatorEvLink) event.getPrimContentIndicatorEvLinks().get(i);
      out.println("<a href=\"/pages/subject/?id=" + primContentIndicatorEvLink.getPrimaryContentInd().getId() + "\">" + primContentIndicatorEvLink.getPrimaryContentInd().getName() + "</a><br>");
    }    
    if(eventCICount >0){
    out.println("     </td>");
    out.println("   </tr>");    }
    
   //  ORGANISATIONS  or Companies//
    out.println("   <tr class=\"b-185\">");
   int eventACCounter=0;
    
    for (int i=0; i < event.getOrgEvLinks().size(); i++){
    	if(eventACCounter==0){
    		out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Organisations</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td  valign=\"top\">");
    	    out.println("<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    	    eventACCounter++;
    	}
      orgEvLink   = (OrgEvLink) event.getOrgEvLinks().get(i);
      organisation = orgEvLink.getOrganisationBean();
      out.print("<tr><td  valign=\"top\"><a href=\"/pages/organisation/?id=" +
                  organisation.getId() + "&f_event_id=" + event_id + "\">" +
                  organisation.getName() + "</a>");
      if (orgEvLink.getFunctionDesc() != null && !orgEvLink.getFunctionDesc().equals("")){
        out.print(", " + orgEvLink.getFunctionDesc());
      } else {
        out.print(", No Function");
      }
      if (orgEvLink.getArtisticFunctionDesc() != null && !orgEvLink.getArtisticFunctionDesc().equals("")){
        out.print(", " + orgEvLink.getArtisticFunctionDesc());
      } else {
        //out.print(", No Artistic Function"); /tir 99 - do not show this any more.
      }
      out.println("</td></tr>");
    }if(eventACCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
   //  CONTRIBUTORS //    
    out.println("   <tr>");
    int eventCCounter=0;
    
    
    if (event.getConEvLinks().size()>=1) {
    	if(eventCCounter==0){
    		out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Contributor Name</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td>");
    	    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		eventCCounter++;
    	}
      out.println("       <tr><td width='25%' class='general_heading_light' valign=\"top\">Name</td><td>&nbsp;</td>" +
                             "<td width='25%' class='general_heading_light' valign=\"top\">Function</td><td>&nbsp;</td>" +
                             "<td width='50%' class='general_heading_light' valign=\"top\">Notes</td></tr>");
    }
    for (int i=0; i < event.getConEvLinks().size(); i++){
      conEvLink = (ConEvLink) event.getConEvLinks().get(i);
      contributor = conEvLink.getContributorBean();
      String contrib_str = "<tr><td  valign=\"top\"><a href=\"/pages/contributor/?id=" +
                    contributor.getId() + "&f_event_id=" + event_id + "\">" +
                    contributor.getName() + " " + contributor.getLastName() +
                    "</a></td><td></td>" +
                    "<td  valign=\"top\">";
      if(conEvLink.getContributorId() != null
       && conEvLink.getContributorId().equals(Integer.toString(contributor.getId()))) {
        contrib_str += conEvLink.getFunctionDesc();
      }
      contrib_str += "</td><td></td><td  valign=\"top\">";
     
     if(conEvLink.getNotes() != null && conEvLink.getNotes()!= "")
       contrib_str += conEvLink.getNotes();
     
      out.println(contrib_str + "</td></tr>");
    }if(eventCCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
       //Resources
    int eventResourceCount=0;
    out.println("   <tr class=\"b-185\">");  
    rset = event.getAssociatedItems(Integer.parseInt(event_id), stmt);
    if(rset != null){
      while(rset.next()){
    	  if(eventResourceCount==0){
    		    out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Resources</td>");
    		    out.println("     <td>&nbsp;</td>");
    		    out.println("     <td  valign=\"top\">");
    		    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    eventResourceCount++;
    		    }
            out.println("<tr><td colspan='3' width=\"100%\"  valign=\"top\"><a href=\"/pages/resource/?id=" +
                         rset.getString("itemid") + "\">" +
                         rset.getString("citation") + "</a></td>"); //NUMBER 1
        out.println("</tr>");
      
      }
    }
    rset.close();
    if(eventResourceCount>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");
    }

//Works
	  int eventWorkCount=0;
    out.println("<tr>");
    rset = event.getAssociatedWorks(Integer.parseInt(event_id), stmt);
    if(rset != null){
    	while(rset.next()){
    		if(eventWorkCount==0){
  		      out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Works</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    eventWorkCount++;
    	  }
        out.println("<tr><td colspan='3' width=\"100%\"  valign=\"top\"><a href=\"/pages/work/?id=" +
        								rset.getString("workid") + "\">" +
        								rset.getString("work_title") + "</a></td>");
            out.println("</tr>");             
      }
      rset.close();
    } 
		if(eventWorkCount>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
   //Text Nationality
    
    out.println("   <tr>");
    for (int i=0; i < event.getPlayOrigins().size(); i++){
      country = (Country) event.getPlayOrigins().get(i);
      if (country.getName() != null && !country.getName().equals("")) {     
      out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Text Nationality</td>");
      out.println("     <td>&nbsp;</td>");
      out.println("     <td  valign=\"top\">")  ;
      out.println(country.getName() + "<br>");
      out.println("    </td>");     
    }
   
    out.println("   </tr>");}
    
    // Production Nationality
    out.println("   <tr>");   
    for (int i=0; i < event.getProductionOrigins().size(); i++){
      country = (Country) event.getProductionOrigins().get(i);
      if (country.getName() != null && !country.getName().equals("")) {
    	  out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Production Nationality</td>");
    	  out.println("     <td>&nbsp;</td>");
    	  out.println("     <td  valign=\"top\">");      
      out.println(country.getName() + "<br>");
      out.println("     </td>");
    }    
    out.println("   </tr>");}

    //Further Information
    if (event.getFurtherInformation() != null && !event.getFurtherInformation().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Further Information</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">");
	    out.println(event.getFurtherInformation());
	    out.println("     </td>");
	    out.println("   </tr>");
    }
   
//  Data source vertical //    
    out.println("   <tr>");
   int sourceCounter=0;
    
    if (event.getDataSources().size()>=1) {
    	if(sourceCounter==0){
    	 out.println("     <td class='general_heading_light f-186' valign='top' align='right'>Data Source</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td>");
    	    out.println("     <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    	    sourceCounter++;
    	}
      out.println("       <tr><td width='30%' class='general_heading_light' valign=\"top\"> Source</td><td>&nbsp;</td>" +
                             "<td width='30%' class='general_heading_light' valign=\"top\">Data Source Description</td><td>&nbsp;</td>" +
                             "<td width='40%' class='general_heading_light' valign=\"top\">Part of Collection</td></tr>");
    }
    for(int j =0; j < event.getDataSources().size(); j++){
    	 datasource = (Datasource) event.getDataSources().elementAt(j);  
    	 datasourceEvlink = new Datasource(db_ausstage_for_drill);
       datasourceEvlink.setEventId(event_id);
       datasourceEvlink.loadLinkedProperties(Integer.parseInt("0"+datasource.getDatasoureEvlinkId()));
       out.println("       <tr><td width='30%' class='general_heading_light' valign=\"top\">"+datasource.getName()+"</td><td>&nbsp;</td>" +
               "<td width='30%' class='general_heading_light' valign=\"top\">"+datasourceEvlink.getDescription()+"</td><td>&nbsp;</td>" +
               "<td width='40%' class='general_heading_light' valign=\"top\">"+datasourceEvlink.isCollection()+ "</td></tr>");
    }if(sourceCounter>0){
    out.println("       </table>");
    out.println("     </td>");
    out.println("   </tr>");}
    
    
  /*  // DATASOURCE //
    out.println("   <tr>");
   int eventDSCounter=0;
    for(int j =0; j < event.getDataSources().size(); j++)
    {
  	  if(eventDSCounter==0)
  	  {
  	  	out.println("     <td align='right' class='general_heading_light f-186' valign='top' align='right'>Data Source</td>");
  	    out.println("     <td>&nbsp;</td>");
  	    out.println("     <td  valign=\"top\">");
  	    eventDSCounter++;
  	  }
      datasource = (Datasource) event.getDataSources().elementAt(j);  
      out.println(datasource.getName() + "<br>");
      }
      if(eventDSCounter>0){
    out.println("     </td>");    
    out.println("   </tr>");
    }
    
    // DATASOURCE DESCRIPTION //
    int eventDSDcount=0;
    out.println("   <tr>");
   
    for(int l =0; l < event.getDataSources().size(); l++){
    	if(eventDSDcount==0){
    		 out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Data Source Description</td>");
    		    out.println("     <td>&nbsp;</td>");
    		    out.println("     <td  valign=\"top\">");
    		    eventDSDcount++;
        }
      datasource = (Datasource) event.getDataSources().elementAt(l);
      datasourceEvlink = new Datasource(db_ausstage_for_drill);
      datasourceEvlink.setEventId(event_id);
      datasourceEvlink.loadLinkedProperties(Integer.parseInt("0"+datasource.getDatasoureEvlinkId()));
      out.println(datasourceEvlink.getDescription() + "<br>");
     
    }if(eventDSDcount>0){
    out.println("     </td>");
    out.println("   </tr>");}

    // PART OF COLLECTION //
   out.println("   <tr>");
    int eventPOCCounter = 0;
    for(int m =0; m < event.getDataSources().size(); m++){
    	if(eventPOCCounter==0){
    		out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Part of Collection</td>");
    	    out.println("     <td>&nbsp;</td>");
    	    out.println("     <td  valign=\"top\">");
    	    eventPOCCounter++;
    	}
      datasource = (Datasource) event.getDataSources().elementAt(m);
      datasourceEvlink = new Datasource(db_ausstage_for_drill);
      datasourceEvlink.setEventId(event_id);
      datasourceEvlink.loadLinkedProperties(Integer.parseInt("0"+datasource.getDatasoureEvlinkId()));
      
      out.println(datasourceEvlink.isCollection() + "<br>");
    }if(eventPOCCounter>0){
    out.println("     </td>");
    out.println("   </tr>");}*/

    SimpleDateFormat dateFormat = new SimpleDateFormat("d-MMMM-yyyy");
    String dateString = dateFormat.format(event.getUpdatedDate());
    System.out.println("DateString: "+dateString);
    
    
    //Reviewed
    if(event.getReview() == true)
    {
      out.println("   <tr class=\"b-185\">");
   	  out.println("     <td  class='general_heading_light f-186' valign='top' align='right'>Data Reviewed By</td>");
    	out.println("     <td>&nbsp;</td>");
    	if(event.getUpdatedByUser().equals("null") && event.getReview() == true){
    		out.println("<td valign=\"top\">" + event.getEnteredByUser() + " on " + dateFormat.format(event.getEnteredDate())+"</td>");
    	}
    	out.println("<td valign=\"top\">" + event.getUpdatedByUser() + " on " + dateFormat.format(event.getUpdatedDate()) +"</td>");
    }
    
    //Event Identifier
    if (event.getEventid() != null && !event.getEventid().equals("")) {
    	out.println("   <tr class=\"b-185\">");
    	out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Event Identifier</td>");
    	out.println("     <td>&nbsp;</td>");
    	out.println("     <td valign=\"top\">" + event.getEventid() + "</td>");
    	out.println("   </tr>");
    }

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
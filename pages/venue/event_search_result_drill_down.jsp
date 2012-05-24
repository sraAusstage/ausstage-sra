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

<%!
public String concatFields(Vector fields, String token) 
{
  String ret = "";
  for (int i=0; i<fields.size(); i++) 
  {
    if (fields.elementAt(i) != null) 
    {
      if (!(fields.elementAt(i)).equals("") && !ret.equals("")) 
      {
        ret += token;
      }
      ret += fields.elementAt(i);
    }
  }
  return (ret);
}

public String formatDate(String day, String month, String year)
{
  if (year == null || year.equals("") )
  {
    return "";
  }
  Calendar calendar = Calendar.getInstance();
  
  SimpleDateFormat formatter = new SimpleDateFormat();
  if (month == null || month.equals("") )
  {
    formatter.applyPattern("yyyy");
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }
  else if(day == null || day.equals("") )
  {
    formatter.applyPattern("MMMMM yyyy");
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }
  else
  {
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

public boolean hasValue(String str) 
{
  if (str != null && !str.equals("")) 
  {
    return true;
  } 
  else 
  {
    return false;
  }
}

public void displayUpdateForm(String                p_id,
                              String                p_type,
                              String                p_object_name,
                              JspWriter             p_out,
                              HttpServletRequest    p_request,
                             
                              admin.AppConstants    p_ausstage_search_appconstants_for_drill) 
  {
  try 
    {
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
      p_out.println("<tr><td><a href='/pages/map/?complex-map=true&c=&o=&v=" + p_request.getParameter("id") + "&e=' align='left' >Map</a></td></tr>");
      p_out.println("</table>");
    
      p_out.println("<DIV id='UpdateFormDiv' style=\"display:none;\">");
      p_out.println("   <table align=\"center\" width=\"98%\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#EFEFFF;border-color:#7E5EBA\">");
      p_out.println("   <tr>");
      p_out.println("   <td>");
      p_out.println("     <table width='100%' border='0' cellpadding='3' cellspacing='0'>");

      if (p_type != null && p_type.equals("Resource")) 
      {
        p_type += "&nbsp;Title";
      }
      else 
      {
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
      p_out.println("       <td align='right' valign='top'><table><tr><td align=\"left\">Please include your name and email address with your contribution. We will not provide your personal information to any other person or organisation.</td></tr></table></td  >")  ;
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
    
      if (p_request.getParameter("") != null && !p_request.getParameter("").equals("")) 
      {
      }
    }
    catch (java.io.IOException e) 
    {
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
  String event_id             = request.getParameter("f_event_id");
  String venue_id             = request.getParameter("id");
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
    //    DISPLAY VENUE DETAILS
    //////////////////////////////////
    venue = new Venue(db_ausstage_for_drill);
    venue.load(Integer.parseInt(venue_id));
    event = new Event(db_ausstage_for_drill);
    Country venueCountry = new Country(db_ausstage_for_drill);
    if (!venue.getCountry().equals("")) {
      venueCountry.load(Integer.parseInt(venue.getCountry()));
    }
    
    if (displayUpdateForm) {
      displayUpdateForm(venue_id, "Venue", venue.getName(),
                        out,
                        request,
                       
                        ausstage_search_appconstants_for_drill);
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Venue Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/venue_addedit.jsp?f_selected_venue_id=" + venue.getVenueId() + "'>Edit</a>");

    out.println("     <table align=\"center\" width='98%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");

    //Venue
    out.println("   <tr class=\"b-185\">");
    out.println("    <td width = '25%' align='right'  class='general_heading_light f-186' valign='top'>Venue Name</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td width ='75%' ><b>" + venue.getName() + "</b></td>");
    out.println("   </tr>");
    
   
    //Address 
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right'  class='general_heading_light f-186' valign='top'>Address</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >");
    Vector locationVector = new Vector();
    locationVector.addElement(venue.getStreet());
    String addressLine2 = "";
    addressLine2 = venue.getSuburb() + " " + state.getName(Integer.parseInt(venue.getState())) + " " + venue.getPostcode();
    locationVector.addElement(addressLine2);
    if (!venue.getCountry().equals("")) {
      locationVector.addElement(venueCountry.getName());
    }
    out.println(concatFields(locationVector, "<br> "));
    out.print ("     </td>");
    out.println("   </tr>");
    
	  //website
    if (venue.getWebLinks() != null && !venue.getWebLinks().equals("")) {
	    out.println("   <tr>");
	    out.println("    <td align='right'  class='general_heading_light f-186' valign='top'>Website</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td ><a href=\"");
	    if(venue.getWebLinks().indexOf("http://") < 0)
	      out.print("http://");
	    out.println(venue.getWebLinks() + "\">" + venue.getWebLinks() + "</a>");
	    %>
	    <br>
	    <script type="text/javascript" src="http://www.shrinktheweb.com/scripts/pagepix.js"></script>
	    <script type="text/javascript">
            stw_pagepix('<%
	    if(venue.getWebLinks().indexOf("http://") < 0)
	      out.print("http://");
	    %><%=venue.getWebLinks()%>', 'afcb2483151d1a2', 'sm', 0);
	    var anchorElements = document.getElementsByTagName('a');
            for (var i in anchorElements) {
              if (anchorElements[i].href.indexOf("shrinktheweb") != -1 || anchorElements[i].href == document.getElementById('url').href){
                anchorElements[i].onmousedown = function() {}
                anchorElements[i].href = document.getElementById('url').href;
              }
            }
            </script>
	    
            <%
            out.println("   </td>"); 
	    out.println("   </tr>");  
   	}
	  
    //Latitude
    if (venue.getLatitude() != null && !venue.getLatitude().equals("") && venue.getLongitude() != null && !venue.getLongitude().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("    <td align='right'  class='general_heading_light f-186' valign='top'>Latitude | Longitude</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td >" + venue.getLatitude() + " | " + venue.getLongitude() +"</td>");
	    out.println("   </tr>");
    }
  
	if (venue.getLatitude() != null && !venue.getLatitude().equals("") && venue.getLongitude() != null && !venue.getLongitude().equals("")) {
 %>
 <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
   <script type="text/javascript" language="javascript">
    
    $(document).ready(function() {

        
      function initialize() {
        var myLatlng = new google.maps.LatLng(<%=venue.getLatitude()%>,<%=venue.getLongitude()%>);
        var myOptions = {
          zoom: 14,
          center: myLatlng,
          mapTypeId: 'ausstage'
        }

        var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
        
        mapStyle = [ { featureType: "all", elementType: "all", stylers: [ { visibility: "off" } ]},
          { featureType: "water", elementType: "geometry", stylers: [ { visibility: "on" }, { lightness: 40 }, { saturation: 0 } ] },
          { featureType: "landscape", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 } ]},
          { featureType: "road", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 }, { lightness: 40 } ] },
          { featureType: "transit", elementType: "geometry", stylers: [ { saturation: -100 }, { lightness: 40 } ] } 
        ];

        var styledMapOptions = {map: map, name: "AusStage",	alt: 'Show AusStage styled map' };
        var ausstageStyle    = new google.maps.StyledMapType(mapStyle, styledMapOptions);
			
        map.mapTypes.set('ausstage', ausstageStyle);
        map.setMapTypeId('ausstage');
		
        var marker = new google.maps.Marker({
            position: myLatlng,
            map: map,
            title: '<%=venue.getName().replaceAll("'", "")%>'
        });

      }

     initialize(); 

    });
    
 </script>
    <tr bgcolor='#eeeeee'>
		<td align='right'  class='general_heading_light f-186' valign='top'>Map</td>
		<td>&nbsp;</td>
		<td>
			<div id="map_canvas" style="width:100%;height:300px;"></div>
		</td>
	</tr>
 <%
 }

   //Radius
    if (venue.getRadius() != null && !venue.getRadius().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("    <td align='right'  class='general_heading_light f-186' valign='top'>Radius</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + venue.getRadius() + "</td>");
	    out.println("   </tr>");
    }
    
   //Elevation
   if (venue.getElevation() != null && !venue.getElevation().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("    <td align='right'  class='general_heading_light f-186' valign='top'>Elevation</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + venue.getElevation() + "</td>");
	    out.println("   </tr>");
    }
   
    //Notes
    if (venue.getNotes() != null && !venue.getNotes().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("    <td align='right'  class='general_heading_light f-186' valign='top'>Notes</td>");
	    out.println("     <td>&nbsp;</td>");
	    out.println("     <td  valign=\"top\">" + venue.getNotes() + "</td>");
	    out.println("   </tr>");
    }

    
    %>
        <script type="text/javascript">
    function displayRow(name){
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
    	<a href="#" onclick="displayRow('contributor')" id='contributorbtn'>Contributors</a>   
    	<a href="#" onclick="displayRow('organisation')" id='organisationbtn'>Organisations</a> 
    </td>
    </tr>
    
    
<%
    
    admin.AppConstants constants = new admin.AppConstants();
    ausstage.Database     m_db = new ausstage.Database ();
    m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
    
    //Events
    out.println("   <tr id='events'>");
    event = new Event(db_ausstage_for_drill);
    crset = event.getEventsByVenue(Integer.parseInt(venue_id));
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

    
     
     //organisations
     
     Statement stmt2    = m_db.m_conn.createStatement ();
     CachedRowSet eo_rs = null; 
     int eventorgcount = 0;
     String sqlString2 = 
	"SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
	"events.first_date,organisation.organisationid,organisation.name,evcount.num " +
	"FROM events,organisation,orgevlink " +
	"inner join (SELECT orgevlink.organisationid, count(distinct orgevlink.eventid) num " +
	"FROM orgevlink, events where orgevlink.eventid=events.eventid and events.venueid=" + venue_id + " " +
	"GROUP BY orgevlink.organisationid) evcount ON (evcount.organisationid = orgevlink.organisationid) " +
	"WHERE events.venueid = " + venue_id + " AND " +
	"orgevlink.eventid = events.eventid AND " +
	"orgevlink.organisationid = organisation.organisationid " +
	"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
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
     		 if (!prevOrg.equals(eo_rs.getString("name"))) {
  	        	if (eventorgcount > 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<a href=\"/pages/organisation/?id=" + eo_rs.getString("organisationid") + "\">" + eo_rs.getString("name")+ "</a><br><ul>");
  	        	prevOrg = eo_rs.getString("name");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
  	        		eo_rs.getString("eventid") + "\">"+eo_rs.getString("event_name")+"</a>");
           if (hasValue(eo_rs.getString("DDFIRST_DATE")) || hasValue(eo_rs.getString("MMFIRST_DATE")) || hasValue(eo_rs.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(eo_rs.next());
     	if(eventorgcount > 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
      
      //contributors
	Statement stmt3 	= m_db.m_conn.createStatement();
	String sqlString3	= "";
	CachedRowSet co_org	= null;
	int contributororgcount = 0;
	sqlString3		= "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
				"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
				"venue.venue_name,venue.suburb,states.state,evcount.num " +
				"FROM events,venue,states,conevlink,contributor " +
				"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
				"FROM conevlink, events where events.eventid=conevlink.eventid and events.venueid=" + venue_id + " " +
				"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
				"WHERE events.venueid = " + venue_id + " AND " +
				"events.venueid = venue.venueid AND " +
				"venue.state = states.stateid AND " +
				"events.eventid=conevlink.eventid AND " +
				"conevlink.contributorid = contributor.contributorid " +
				"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
	co_org			= m_db.runSQL(sqlString3, stmt3);
	
     out.println("<tr id='contributor'>");
      String prevCon = "";
      if(co_org.next()){
     	 do{
     		if(contributororgcount==0){
  		 out.println("     <td align='right' class='general_heading_light' valign='top'></td>");
  	         out.println("     <td>&nbsp;</td>");
  	         out.println("     <td  valign=\"top\">");
  	        
     		}
     		 contributororgcount++;
     		 if (!prevCon.equals(co_org.getString("contributorid"))) {
  	        	if (contributororgcount> 1) {
  	        		out.print("</ul>");
  	        	}
  	        	out.print("<a href=\"/pages/contributor/?id=" + co_org.getString("contributorid") + "\">" + co_org.getString("contributor_name")+ "</a><br><ul>");
  	        	prevCon= co_org.getString("contributorid");
  	        }
  	        out.print("<li><a href=\"/pages/event/?id=" +
  	        		co_org.getString("eventid") + "\">"+co_org.getString("event_name")+"</a>");
  	        	if(hasValue(co_org.getString("suburb"))) 
				out.print(", " + co_org.getString("suburb"));
           		if(hasValue(co_org.getString("state")))
				out.print(", " + co_org.getString("state"));

           if (hasValue(co_org.getString("DDFIRST_DATE")) || hasValue(co_org.getString("MMFIRST_DATE")) || hasValue(co_org.getString("YYYYFIRST_DATE")))
            out.print(", " + formatDate(co_org.getString("DDFIRST_DATE"),co_org.getString("MMFIRST_DATE"),co_org.getString("YYYYFIRST_DATE")));
        out.println("</li>"); 
     	 }while(co_org.next());
     	if(contributororgcount> 0)
     	 out.println("</ul>");
     	 out.println("</td>");
      }out.println("   </tr>");
  	  
    
     //  Items
     //Resources
    rset = venue.getAssociatedItems(Integer.parseInt(venue_id), m_db.m_conn.createStatement());
    int rowVenueCount = 0;
   
    out.println("   <tr class=\"b-185\">");
    if(rset != null)
    {
      while(rset.next())
      {
        if (rowVenueCount == 0) 
        {
          out.println("     <td align='right'  class='general_heading_light' valign='top'><a class='f-186' href=\"#\" onclick=\"showHide('resources')\">Resources</a></td>");
			    out.println("     <td>&nbsp;</td>");
			    out.println("     <td >");
			    rowVenueCount++;
      				out.println("       <table id='resources' border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
        }
    
        out.println("<tr>");
        out.println("  <td  valign=\"top\"><a href=\"/pages/resource/?id=" +
                         rset.getString("itemid") + "\">" +
                         rset.getString("citation") + "</a>");
        //out.println(", "  + rset.getString("name") + ", " + rset.getString("state") + "</td>");
        out.print("</td>");
        //out.println("  <td width=\"222\"  valign=\"top\"></td>");
        out.println("</tr>");      
      }
    
      if(rowVenueCount > 0){
        out.println("      </table>");
        out.println("     </td>");
        out.println("   </tr>");
      }
    }
//Resource identifer

    out.println("   <tr>");
    out.println("     <td align='right'  class='general_heading_light f-186' valign='top'>Venue Identifier</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td >" + venue.getVenueId() + "</td>");
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
<script>displayRow("events");
if (!document.getElementById("organisation").innerHTML.match("[A-Za-z]")) document.getElementById("organisationbtn").style.display = "none";
if (!document.getElementById("contributor").innerHTML.match("[A-Za-z]")) document.getElementById("contributorbtn").style.display = "none";
if (!document.getElementById("events").innerHTML.match("[A-Za-z]")) document.getElementById("eventsbtn").style.display = "none";
</script>
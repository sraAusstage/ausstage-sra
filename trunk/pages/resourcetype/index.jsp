<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor,ausstage.ContFunctPref , ausstage.ContributorFunction"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
  <tr>
    <td>
      <table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
	<tr>
          <td bgcolor="#FFFFFF">




<%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  List<String> groupNames = new ArrayList();	
  if (session.getAttribute("userName")!= null) 
  {
    CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
    CmsObject cmsObject = cms.getCmsObject();
    List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
    for(CmsGroup group:userGroups) 
    {
      groupNames.add(group.getName());
    } 
  }
	
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String resource_subtype_id  =	request.getParameter("id");	
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
  ContFunctPref function = null;
  Contributor contributor = null;
  Contributor contributorCreator = null;
  Item item;
  LookupCode lookupcode = null;
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
  
  lookupcode = new LookupCode(db_ausstage_for_drill);
  lookupcode.load(Integer.parseInt(resource_subtype_id));
  event = new Event(db_ausstage_for_drill);
   
   if(displayUpdateForm)
  {
    displayUpdateForm(resource_subtype_id, "Resource Type", lookupcode.getShortCode(),out,
	                        request,			                       
	                        ausstage_search_appconstants_for_drill);
  }               
  
//  if (groupNames.contains("Administrators") || groupNames.contains("Resource Sub Type Editor"))
//    out.println("<a class='editLink' target='_blank' href='/custom/work_addedit.jsp?action=edit&f_workid=" + work.getId() + "'>Edit</a>"); 

  out.println("     <table align=\"center\" width='98%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");
  
  out.println("  <tr>");
  out.println("     <td>&nbsp;</td>");
  out.println("   </tr>");

  //Resource Sub Type Name
  out.println("  <tr>");
  out.println("    <td width = '25%' align='right'  class='general_heading_light f-186' valign='top'>Resource Sub Type</td>");
  out.println("     <td>&nbsp;</td>");
  out.println("     <td width ='75%' ><b>" + lookupcode.getShortCode() + "</b></td>");
  out.println("   </tr>");
	    	 	
 //Citations
  int CitationByResourceSubTypeCount = 0;
  rset = lookupcode.getCitationByResourceSubType(stmt, Integer.parseInt(resource_subtype_id));
  out.println("   <tr >");
  if(rset != null)
  {
    while(rset.next())
    {
     
   	if (CitationByResourceSubTypeCount == 0) 
	{
	  out.println("     <td align='right'  class='general_heading_light f-186' valign='top'>Resources</td>");
	  out.println("     <td>&nbsp;</td>");
	  out.println("     <td >");
	  out.println("       <table  border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	  CitationByResourceSubTypeCount++;
	}
	out.println("<tr>");
    	out.println("  <td  valign=\"top\"><a href=\"/pages/resource/?id="  +
        rset.getString("itemid") + "\">" +
        rset.getString("citation") +"</a>");
    	out.print("</td>");
    	out.println("</tr>");
     
    }
  } 
if(CitationByResourceSubTypeCount > 0)
  {
    out.println("      </table>");
    out.println("     </td>");
    out.println("   </tr>");
  }	  
	    	 	
	    	 		   
  //Resource Sub Type Identifier
 
    out.println("   <tr class=\"b-185\">");
    out.println("     <td align='right'  class='general_heading_light f-186' valign=\"top\">Resource Sub Type Identifier</td>");
    out.println("     <td>&nbsp;</td>");
    out.println("     <td valign=\"top\">" + lookupcode.getCodeLovID()+ "</td>");
    out.println("   </tr>");
  
  out.println(" </table>");
 
  // close statement
  stmt.close();
%>
</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
<cms:include property="template" element="foot" />
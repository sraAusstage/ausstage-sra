<%@ page pageEncoding="UTF-8"
%><%@ page contentType="text/html; charset=UTF-8"
%><%@ page import = "java.util.Vector, java.text.SimpleDateFormat"
%><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"
%><%@ page import = "ausstage.State"
%><%@ page import = "admin.Common"
%><%@ page import = "ausstage.Event, ausstage.DescriptionSource"
%><%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"
%><%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"
%><%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"
%><%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"
%><%@ page import = "ausstage.ConEvLink, ausstage.Contributor,ausstage.ContFunctPref , ausstage.ContributorFunction"
%><%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"
%><%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"
%><%@ page import = "ausstage.SecondaryGenre, ausstage.Work"
%><%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" 
%><%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" 
%><%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" 
%><%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%><%@ page import = "ausstage.AusstageCommon"
%><%response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=ausstage.csv");
%><%! 
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

public String formatDate(String day, String month, String year){
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
  return result.replaceAll(" ","&nbsp;");
}

public boolean hasValue(String str) {
  if (str != null && !str.equals("")) {
    return true;
  } else {
    return false;
  }
}
%><%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
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
  
   ///////////////////////////////////
   //    DISPLAY Resource Type
   //////////////////////////////////
  lookupcode = new LookupCode(db_ausstage_for_drill);
  lookupcode.load(Integer.parseInt(resource_subtype_id));
  event = new Event(db_ausstage_for_drill);
   
  //Name
  out.println("\"Resource Sub Type\",\"" + lookupcode.getShortCode() + "\"");
    
  //Resource Sub Type Identifier
  out.println("");
  out.println("\"Resource Sub Type Identifier\",\"" + lookupcode.getCodeLovID() + "\"");

  //Citations
  int CitationByResourceSubTypeCount = 0;
  rset = lookupcode.getCitationByResourceSubType(stmt, Integer.parseInt(resource_subtype_id));
  out.println("");
  if(rset != null)
  {
    out.println("\"Resources\"");
    while(rset.next())
    {
      out.println("\"" + rset.getString("citation") + "\"");
    }
  } 
  // close statement
  stmt.close();
%>
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
%><%@ page import = "ausstage.ConEvLink, ausstage.Contributor"
%><%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"
%><%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"
%><%@ page import = "ausstage.SecondaryGenre, ausstage.Work"
%><%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" 
%><%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" 
%><%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*"
%><%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%><%response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=ausstage.csv");
%><%@ page import = "ausstage.AusstageCommon"
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
  
  
 return formatter.format(date);
  
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

  //Event Name
  out.println("\"Event Name\",\"" + event.getEventName()+ "\"");
  
  //Event Identifier
  out.println("");
  out.println("\"Event Identifier\",\"" + event.getEventid()+ "\"");
   
  //Venue
  // Get venue location string
  out.println("");
  String venueLocation = ""; 
  if (event.getVenue().getSuburb() != null && !event.getVenue().getSuburb().equals (""))
    venueLocation = ", " + event.getVenue().getSuburb();
  if (event.getVenue().getState() != null && !event.getVenue().getState().equals (""))
    venueLocation += ", " + state.getName(Integer.parseInt(event.getVenue().getState()));  
  out.println("\"Venue\",\""+ event.getVenue().getName()+ " " + venueLocation + "\"");
     
  //Unbrella Event
  if (event.getUmbrella() != null && !event.getUmbrella().equals("")) {
    out.println("");
    out.println("\"Umbrella Event\",\""+ event.getUmbrella() + "\"");
  }
    
  //First Date
  if (!formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate()).equals("")) {
  out.println("");
    out.println("\"First date\",\"" + formatDate(event.getDdfirstDate(),event.getMmfirstDate(),event.getYyyyfirstDate())+ "\"");
  }
   	
  //Opening Date
  if (!formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate()).equals("")) {
    out.println("");
    out.println("\"Opening date\",\"" +formatDate(event.getDdopenDate(),event.getMmopenDate(),event.getYyyyopenDate())+ "\"");
  }
    
  //Last Date
  if (!formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate()).equals("")) {
    out.println("");
    out.println("\"Last date\",\"" + formatDate(event.getDdlastDate(),event.getMmlastDate(),event.getYyyylastDate())+ "\"");
    out.println(formatted_date);
  }

  //Dates Estimated
  out.println("\"Dates Estimated\",\"" + Common.capitalise(Common.convertBoolToYesNo(event.getEstimatedDates()),true)+ "\"");

  //Status
  if (event.getStatus() != null && !event.getStatus().equals("")) {
  out.println("");
    out.println("\"Status\",\"" + event.getEventStatus(event.getStatus())+ "\"");
  }
    
  //World Premier
  out.println("");
  out.print("\"World Premiere\",\"");
  if(event.getWorldPremier()){
  //out.println("\"Yes\",\"");
  out.println("Yes\",");
  }
  else{
    out.println("No\",");
  }
  out.println("");
   
  //Description
  if (event.getDescription() != null && !event.getDescription().equals("")) {
    out.println("\"Description\",\"" + event.getDescription()+ "\"");
  }
    
  //Description Source
  if (event.getDescriptionSource() != null && !event.getDescriptionSource().equals("") && !event.getDescriptionSource().equals("0")) {
    out.println("");
    out.println("\"Description Source\",\""+ descriptionSource.getDescriptionSource(Integer.parseInt(event.getDescriptionSource()))+ "\"");
  }
    
  // PRIMARY GENRE //
  out.println("");
  primarygenre = new PrimaryGenre(db_ausstage_for_drill);
  primarygenre.load(Integer.parseInt(event.getPrimaryGenre()));
  out.println("\"Primary Genre\",\""+primarygenre.getName()+ "\"");

  //  SECONDARY GENRE //
  int eventGenreCounter=0;
  out.println("");
  out.println("\"Secondary Genre\"");
  for (int i=0; i < event.getSecGenreEvLinks().size(); i++)
  { 
    secGenreEvLink = (SecGenreEvLink) event.getSecGenreEvLinks().get(i);
    SecondaryGenre tempSecGenre = new SecondaryGenre(db_ausstage_for_drill);
    tempSecGenre.loadFromPrefId(Integer.parseInt(secGenreEvLink.getSecGenrePreferredId()));
    out.println("\"" + tempSecGenre.getName() + "\"");
  }

  //  PRIMARY CONTENT INDICATOR //  
  out.println("");
  int eventCICount=0;
  out.println("\"Subjects\"");
  for (int i=0; i < event.getPrimContentIndicatorEvLinks().size(); i++)
  { 
	 primContentIndicatorEvLink = (PrimContentIndicatorEvLink) event.getPrimContentIndicatorEvLinks().get(i);
	 out.println("\"" + primContentIndicatorEvLink.getPrimaryContentInd().getName()+ "\"");
  }    
    
  //  ORGANISATIONS  or Companies//
  out.println("");
  int eventACCounter=0;
  for (int i=0; i < event.getOrgEvLinks().size(); i++){
    if(eventACCounter==0){
 	out.println("\"Organisations\"");
    eventACCounter++;
    }
    orgEvLink   = (OrgEvLink) event.getOrgEvLinks().get(i);
    organisation = orgEvLink.getOrganisationBean();
    out.print("\"" + organisation.getName()+ "\",");
    if (orgEvLink.getFunctionDesc() != null && !orgEvLink.getFunctionDesc().equals("")){
      out.print("\"" + orgEvLink.getFunctionDesc()+ "\",");
    } 
    else {
      out.println("\" No Function\",");
    }
    if (orgEvLink.getArtisticFunctionDesc() != null && !orgEvLink.getArtisticFunctionDesc().equals("")){
      out.print("\"" + orgEvLink.getArtisticFunctionDesc()+"\","); 
    } 
    out.println("");
  }
  
  //  CONTRIBUTORS //    
  out.println("");
  int eventCCounter=0;
  if (event.getConEvLinks().size()>=1) {
    if(eventCCounter==0){
	out.println("\"Contributors\"");
	eventCCounter++;
    } 
  }
  for (int i=0; i < event.getConEvLinks().size(); i++){
    conEvLink = (ConEvLink) event.getConEvLinks().get(i);
    contributor = conEvLink.getContributorBean();
    String contrib_str = contributor.getName() + " " + contributor.getLastName();
    if(conEvLink.getContributorId() != null&& conEvLink.getContributorId().equals(Integer.toString(contributor.getId()))) {
      contrib_str += "\",\"" + conEvLink.getFunctionDesc();
    }
    contrib_str += "";

    if(conEvLink.getNotes() != null && conEvLink.getNotes()!= "")
    contrib_str += "\",\""+conEvLink.getNotes();
    out.println("\"" +contrib_str + "\"");
  }
    
  //Resources
  int eventResourceCount=0;
    
  rset = event.getAssociatedItems(Integer.parseInt(event_id), stmt);
  if(rset != null){
    out.println("");
    while(rset.next()){
      if(eventResourceCount==0){
	    out.println("\"Resources\"");
	    eventResourceCount++;
      }
    out.println("\"" + rset.getString("citation").replaceAll("\\\"", "\\\"\\\"") + "\""); //NUMBER 1
    }
  }
  rset.close();

  //Works
  int eventWorkCount=0;
  
  rset = event.getAssociatedWorks(Integer.parseInt(event_id), stmt);
  if(rset != null){
    out.println("");
    while(rset.next()){
      if(eventWorkCount==0){
        out.println("\"Related Works\"");
        eventWorkCount++;
      }
      out.println("\"" + rset.getString("work_title").replaceAll("\\\"", "\\\"\\\"") + "\"");
    }
    rset.close();
  } 
    
  //Text Nationality

  out.println("");
  for (int i=0; i < event.getPlayOrigins().size(); i++){
    country = (Country) event.getPlayOrigins().get(i);
    if (country.getName() != null && !country.getName().equals("")) {     
      out.println("\"Text Nationality\",\"" + country.getName()+ "\"");
    }
  }
   
  // Production Nationality
  out.println("");   
  for (int a=0; a < event.getProductionOrigins().size(); a++){
    country = (Country) event.getProductionOrigins().get(a);
    if (country.getName() != null && !country.getName().equals("")) {
        out.println("\"Production Nationality\",\"" +country.getName()+ "\"");
    }    
  }
  
  //Further Information
  if (event.getFurtherInformation() != null && !event.getFurtherInformation().equals("")) {
    out.println("");
    out.println("\"Further Information\",\"" + event.getFurtherInformation()+ "\"");
  }
   
  //  Data source vertical //    
  out.println("\"Data Source\"");
 // out.println("\" Source\",\" Data Source Description \",\"Part of Collection");
  for(int j =0; j < event.getDataSources().size(); j++){
    datasource = (Datasource) event.getDataSources().elementAt(j);  
    datasourceEvlink = new Datasource(db_ausstage_for_drill);
    datasourceEvlink.setEventId(event_id);
    datasourceEvlink.loadLinkedProperties(Integer.parseInt("0"+datasource.getDatasoureEvlinkId()));
    out.println("\"" + datasource.getName()+"\",\""+ datasourceEvlink.getDescription()+"\",\""+datasourceEvlink.isCollection()+ "\"");
  }  
  
  // close statement
  stmt.close();
%>
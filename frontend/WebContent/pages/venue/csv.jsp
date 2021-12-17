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
%><%@ page session="true" import="java.lang.String, java.util.*" 
%><%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%><%@ page import = "ausstage.AusstageCommon"
%><%//response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=ausstage.csv");
%><%!
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

  return formatter.format(date);
  
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
%><%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String event_id             = request.getParameter("f_event_id");
  String venue_id             = db_ausstage_for_drill.plSqlSafeString(request.getParameter("id"));
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
  
  //Venue Name
  out.println("\"Venue Name\",\"" + venue.getName()+ "\"");
  
  //Venue identifer
  out.println("");
  out.println("\"Venue Identifier\",\"" + venue.getVenueId()+ "\"");
    
  //Address 
  out.println("");
  Vector locationVector = new Vector();
  locationVector.addElement(venue.getStreet());
  String addressLine2 = "";
  addressLine2 = venue.getSuburb() + " " + state.getName(Integer.parseInt(venue.getState())) + " " + venue.getPostcode();
  locationVector.addElement(addressLine2);
  if (!venue.getCountry().equals("")) {
    locationVector.addElement(venueCountry.getName());
  }
  out.println("\"Address\",\""+ concatFields(locationVector, " ")+ "\"");
   
  //website
  if (venue.getWebLinks() != null && !venue.getWebLinks().equals("")) {
    out.println("\"Website\",\"" + venue.getWebLinks()+ "\"");	   
  }
 
  //Latitude
  if (venue.getLatitude() != null && !venue.getLatitude().equals("") && venue.getLongitude() != null && !venue.getLongitude().equals("")) {
    out.println("\"Latitude | Longitude\",\"" +  venue.getLatitude() + " | " + venue.getLongitude()+ "\"");    	
  }
  
  //Notes
  if (venue.getNotes() != null && !venue.getNotes().equals("")) {
    out.println("\"Notes\",\"" +   venue.getNotes()+ "\"");    	
  }

  admin.AppConstants constants = new admin.AppConstants();
  ausstage.Database     m_db = new ausstage.Database ();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
    
  //Associated Events
  
  event = new Event(db_ausstage_for_drill);
  crset = event.getEventsByVenue(Integer.parseInt(venue_id));
  int orgEventCount = 0;
    
  if(crset.next()){
  out.println("\"Associated Events\"");
  do{
     out.print("\"" + crset.getString("event_name")+ "\",");
     out.print("\"" + formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE"))+ "\",");
     out.println("");
  }while(crset.next());
      
  //Associated organisations
  out.println(""); 
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
     
  String prevOrg = "";
  if(eo_rs.next()){
    out.println("\"Associated Organisations\"");
    do{
	out.print("\"" + eo_rs.getString("name") + "\",");
	out.print("\"" + eo_rs.getString("name") + "\",");
        out.print("\"" + formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE"))+ "\",");
	out.println(""); 
    }while(eo_rs.next());
  }
      
  //Associated contributors
  out.println(""); 
  Statement stmt3 	= m_db.m_conn.createStatement();
  String sqlString3	= "";
  CachedRowSet co_org	= null;
  int contributororgcount = 0;
  sqlString3		= "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
				"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
				"venue.venue_name,venue.suburb,states.state,evcount.num " +
				"FROM events,venue,states,orgevlink,conevlink,contributor " +
				"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
				"FROM conevlink, orgevlink where orgevlink.eventid=conevlink.eventid and orgevlink.organisationid=" + venue_id + " " +
				"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
				"WHERE orgevlink.organisationid = " + venue_id + " AND " +
				"orgevlink.eventid = events.eventid AND " +
				"events.venueid = venue.venueid AND " +
				"venue.state = states.stateid AND " +
				"events.eventid = orgevlink.eventid AND " +
				"orgevlink.eventid=conevlink.eventid AND " +
				"conevlink.contributorid = contributor.contributorid " +
				"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
  co_org			= m_db.runSQL(sqlString3, stmt3);
	
  String prevCon = "";
  if(co_org.next()){
    out.println("\"Associated Contributors\"");
    do{
      out.print("\"" + co_org.getString("contributor_name")+ "\",");
      out.print("\"" + co_org.getString("event_name")+ "\",");
      out.print("\"" + co_org.getString("suburb")+ "\",");
      out.print("\"" + co_org.getString("state")+ "\",");
      out.print("\"" + formatDate(co_org.getString("DDFIRST_DATE"),co_org.getString("MMFIRST_DATE"),co_org.getString("YYYYFIRST_DATE"))+ "\",");
      out.println(""); 
    }while(co_org.next());
  }
    
  //  Items
  //Related Resources
  out.println("");
  rset = venue.getAssociatedItems(Integer.parseInt(venue_id), stmt);
  int rowVenueCount = 0;
  if(rset != null){
    out.println("\"Resources\"");
    while(rset.next()){
        out.println("\"" +rset.getString("citation").replaceAll("\\\"", "\\\"\\\"") + "\"");
      }
    }
} 
  // close statement
  stmt.close();
%>
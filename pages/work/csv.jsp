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
%><%@ page import = "ausstage.AusstageCommon"
%><%response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
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
%><%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String work_id	      = request.getParameter("id");
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
  //    DISPLAY Work DETAILS
  //////////////////////////////////
  work = new Work(db_ausstage_for_drill);
  work.load(Integer.parseInt(work_id));
  event = new Event(db_ausstage_for_drill);
  rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);

  //Name
  out.println("\"Work Name\",\"" + work.getName() + "\"");
    
  //Alternate Works Names
  if (work.getAlterWorkTitle() != null && !work.getAlterWorkTitle().equals(""))
  {
    out.println("\"Alternate Works Name\",\"" + work.getAlterWorkTitle() + "\"");
  } 

  //Event Identifier
  if (work.getId() != null && !work.getId().equals("")) {
    out.println("");
    out.println("\"Work Identifier\",\""+ work.getId() + "\"");
  }
  
  //Contributors
  int rowWorkConCount=0;
  rset = work.getAssociatedEvents(Integer.parseInt(work_id), stmt);
  out.println("");
  if(rset != null)
  {
    while(rset.next())
    {
      out.println("\"Creator Contributors\",\"" + rset.getString("creator") + "\"");
    }
  } 
    
%><%  
  admin.AppConstants constants = new admin.AppConstants();
  ausstage.Database     m_db = new ausstage.Database ();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
   
  //Associated Events
  out.println("");
  rset = work.getAssociatedEv(Integer.parseInt(work_id), stmt);
  int orgEventCount = 0;
  
  if(rset.next())
  {
    out.println("\"Associated Events\"");
    do
    {
       out.print("\"" + rset.getString("event_name") + "\",");
       out.print("\"" + rset.getString("Output") + "\",");       	
       out.print("\"" + formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE"))+ "\",");
       out.println("");
    }while(rset.next());
  }
    
     
  //Events by organisation type
  out.println("");    
  Statement stmt2    = m_db.m_conn.createStatement ();
  CachedRowSet eo_rs = null; 
  int eventorgcount = 0;
  String sqlString2 = "SELECT DISTINCT organisation.organisationid, organisation.name, "+
	"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
	"venue.venue_name,venue.suburb,states.state,evcount.num "+
	"FROM events,venue,states,eventworklink,orgevlink,organisation, "+
	"(SELECT orgevlink.organisationid, count(distinct orgevlink.eventid) num "+
	"FROM orgevlink, eventworklink where orgevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " "+
	"GROUP BY orgevlink.organisationid) evcount "+
	"WHERE eventworklink.workid = " + work_id + " AND "+
	"evcount.organisationid = organisation.organisationid AND "+
	"eventworklink.eventid = events.eventid AND "+
	"events.venueid = venue.venueid AND "+
	"venue.state = states.stateid AND "+
	"events.eventid = eventworklink.eventid AND "+
	"eventworklink.eventid=orgevlink.eventid AND "+
	"orgevlink.organisationid = organisation.organisationid "+
	"ORDER BY evcount.num desc,organisation.name,events.first_date DESC";
  eo_rs = m_db.runSQL(sqlString2, stmt2);
     
  if(eo_rs.next()){
    out.println("");
    out.println("\"Associated Organisations\"");
      
    do{    	
      out.print("\"" + eo_rs.getString("event_name")+ "\",");
      out.print("\"" + eo_rs.getString("venue_name")+ "\",");
      out.print("\"" + eo_rs.getString("suburb")+ "\",");
      out.print("\"" + eo_rs.getString("state")+ "\",");
      out.print("\"" + formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE"))+ "\",");
      out.println("");
    }while(eo_rs.next());    	
  }
      
  //Contributors
  Statement stmt3 	= m_db.m_conn.createStatement();
  String sqlString3	= "";
  CachedRowSet co_org	= null;
  int contributororgcount = 0;
  sqlString3		= "SELECT DISTINCT contributor.contributorid, concat_ws(' ', contributor.first_name, contributor.last_name) contributor_name, " +
		"events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, " +
		"venue.venue_name,venue.suburb,states.state,evcount.num " +
		"FROM events,venue,states,eventworklink,conevlink,contributor " +
		"inner join (SELECT conevlink.contributorid, count(distinct conevlink.eventid) num " +
		"FROM conevlink, eventworklink where conevlink.eventid=eventworklink.eventid and eventworklink.workid=" + work_id + " " +
		"GROUP BY conevlink.contributorid) evcount ON (evcount.contributorid = contributor.contributorid) " +
		"WHERE eventworklink.workid = " + work_id + " AND " +
		"eventworklink.eventid = events.eventid AND " +
		"events.venueid = venue.venueid AND " +
		"venue.state = states.stateid AND " +
		"events.eventid = eventworklink.eventid AND " +
		"eventworklink.eventid=conevlink.eventid AND " +
		"conevlink.contributorid = contributor.contributorid " +
 		"ORDER BY evcount.num desc,contributor.last_name,contributor.first_name,events.first_date DESC";
  co_org			= m_db.runSQL(sqlString3, stmt3);
  
  String prevCon = "";
  if(co_org.next()){
    out.println("");
    out.println("\"Associated Contributors\"");
    do{
 	out.print("\"" + co_org.getString("contributor_name")+ "\",");
	out.print("\"" + co_org.getString("event_name")+ "\",");
	out.print("\"" + co_org.getString("venue_name")+ "\",");
	out.print("\"" + (co_org.getString("suburb")==null?"":co_org.getString("suburb"))+ "\",");
	out.print("\"" + (co_org.getString("state")==null?"":co_org.getString("state"))+ "\",");
   	out.print("\"" + formatDate(co_org.getString("DDFIRST_DATE"),co_org.getString("MMFIRST_DATE"),co_org.getString("YYYYFIRST_DATE"))+ "\",");
	out.println(""); 
    }while(co_org.next());
  }
  
  //Items
  rset = work.getAssociatedItems(Integer.parseInt(work_id), stmt);
  out.println("");
  if(rset != null){
    out.println("\"Resources\"");
    while(rset.next()){
      out.println("\"" +rset.getString("citation")+ "\"");
    }
  }
   
  // close statement
  stmt.close();
%>
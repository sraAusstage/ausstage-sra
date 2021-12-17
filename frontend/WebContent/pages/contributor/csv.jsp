<%@ page pageEncoding="UTF-8"
%><%@ page contentType="text/csv; charset=UTF-8"
%><%@ page import = "java.util.Vector, java.text.SimpleDateFormat"
%><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"
%><%@ page import = "ausstage.State"%><%@ page import = "admin.Common"
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
%><%//response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=ausstage.csv");
admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
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
%><%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String event_id             = request.getParameter("f_event_id");
  String contrib_id           = db_ausstage_for_drill.plSqlSafeString(request.getParameter("id"));
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
  admin.Common Common = new admin.Common();  

 

  ///////////////////////////////////
  //    DISPLAY CONTRIBUTOR DETAILS
  //////////////////////////////////

  contributor = new Contributor(db_ausstage_for_drill);
  contributor.load(Integer.parseInt(contrib_id));

  //Name
  out.println("\"Contributor Name\",\"" + contributor.getName() + " " + contributor.getLastName()+ "\"");
    
  // other name  
  if(contributor.getOtherNames() != null && !contributor.getOtherNames().equals("")) {
	  if(contributor.getOtherNames() != null && !contributor.getOtherNames().equals(""))
	    out.println("\"Other Names\",\"" + contributor.getOtherNames() + "\"");
  }
    
  //Contributor ID
  out.println("\"Contributor Identifier\",\"" + contributor.getId() + "\"");
  
  //Gender    
  if(contributor.getGender() != null && !contributor.getGender().equals("")) {
    out.println("\"Gender\",\"" + contributor.getGender() + "\"");
  }
  
  //Nationality
  if(contributor.getNationality() != null && !contributor.getNationality().equals("")) {
    out.println("\"Nationality\",\"" + contributor.getNationality() + "\"");
  }
  
  //Legally can only display date of birth if the date of death is null. 
  // New rules (23/12/2008)
  if (!formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear()).equals("") || !formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear()).equals("")) { 
    if(hasValue(contributor.getDobYear())){
      //Date of Birth  
      out.println("\"Date of Birth\",\"" +formatDate(contributor.getDobDay(),contributor.getDobMonth(),contributor.getDobYear())+ "\"");
    } 
    if(hasValue(contributor.getDodYear()))  
    {
      //Date of death
      out.println("\"Date of Death\",\"" +formatDate(contributor.getDodDay(),contributor.getDodMonth(),contributor.getDodYear())+ "\"");	      
    }
  }
      
  //Functions
  String contrib_functions = "";
  if(event_id != null && !event_id.equals("")){
    ConEvLink contribeventlink = new ConEvLink(db_ausstage_for_drill);
    contribeventlink.load(contrib_id, event_id);
    Vector contribeventlinkvec;
    contribeventlinkvec = contribeventlink.getConEvLinksForEvent(Integer.parseInt(event_id));
    for(int i =0; i < contribeventlinkvec.size(); i++){
      if(((ConEvLink)contribeventlinkvec.get(i)).getContributorId() != null
        && ((ConEvLink)contribeventlinkvec.get(i)).getContributorId().equals(contrib_id)){
      if(contrib_functions.equals(""))
        contrib_functions = ((ConEvLink)contribeventlinkvec.get(i)).getFunctionDesc();
        else
          contrib_functions += "," + ((ConEvLink)contribeventlinkvec.get(i)).getFunctionDesc().trim();
      }
    }
  }
  else{
      contrib_functions = contributor.getContFunctPreffTermByContributor(contrib_id).replaceAll(", ", ",");
  }
  out.println("\"Functions\",\""  +contrib_functions+ "\"");	
    
  //Notes
  if(contributor.getNotes() != null && !contributor.getNotes().equals("")) {
    out.println("\"Notes\",\""+contributor.getNotes()+ "\"");	
  }
  
  //Associated Events
  out.println("");
  event = new Event(db_ausstage_for_drill);
  crset = event.getEventsByContrib(Integer.parseInt(contrib_id));
  int contribEventCount=0;
  if(crset.next()){
    out.println("\"Associated Events\"");
    //out.println("Event Name,Venue Name,Suburb,State,First Date");
    do{   
      out.print("\""+crset.getString("event_name") + "\",");
      out.print("\""+crset.getString("venue_name")+ "\",");
      out.print("\""+crset.getString("suburb")+ "\",");
      out.print("\""+crset.getString("state")+ "\",");
      out.print("\""+formatDate(crset.getString("DDFIRST_DATE"),crset.getString("MMFIRST_DATE"),crset.getString("YYYYFIRST_DATE"))+ "\",");
      out.println("");      
    }while(crset.next());
  }

  //Events by function
  out.println("");
  admin.AppConstants constants = new admin.AppConstants();
  ausstage.Database     m_db = new ausstage.Database ();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt1    = m_db.m_conn.createStatement ();
  String sqlString = "";
  CachedRowSet l_rs = null; 
  int eventfunccount = 0;
  int i=0;
  sqlString = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date, " + 
             "events.yyyyfirst_date,events.first_date,venue.venue_name,venue.suburb,states.state,contributorfunctpreferred.preferredterm " + 
             "FROM events,venue,states,conevlink,contributor,contributorfunctpreferred " + 
             "where contributor.contributorid=" + contrib_id + " " + 
             "and contributor.contributorid=conevlink.contributorid " + 
             "and conevlink.eventid=events.eventid " + 
             "and events.venueid=venue.venueid " + 
             "and venue.state=states.stateid " + 
             "AND conevlink.function=contributorfunctpreferred.contributorfunctpreferredid "+
             "order by contributorfunctpreferred.preferredterm,events.first_date desc";
         l_rs = m_db.runSQL(sqlString, stmt1);
         
  if(l_rs.next()){
    out.println("\"Events By Function\"");
    // out.println("Function,Event Name,Venue Name,Suburb,State,First Date");
    do{
 	   out.print("\""+ l_rs.getString("preferredterm")+ "\",");
 	   out.print("\""+ l_rs.getString("event_name")+ "\",");
 	   out.print("\""+ l_rs.getString("venue_name")+ "\",");
           out.print("\""+ l_rs.getString("suburb")+ "\",");
           out.print("\""+ l_rs.getString("state")+ "\",");
           out.print("\""+ formatDate(l_rs.getString("DDFIRST_DATE"),l_rs.getString("MMFIRST_DATE"),l_rs.getString("YYYYFIRST_DATE"))+ "\",");
           out.println(""); 
    }while(l_rs.next());
  }
     
   //Contributor by Events
   out.println("");  
   Statement stmt3    = m_db.m_conn.createStatement ();
   String sqlString3 = "";
   CachedRowSet ec_rs = null; 
   int eventconcount = 0;
   sqlString3 = "select distinct events.event_name, events.eventid, events.ddfirst_date, events.mmfirst_date, events.yyyyfirst_date, " +
	"contributor.contributorid, contributor.first_name, contributor.last_name, " +
	"concat_ws(', ', venue.venue_name, venue.suburb, if(states.state='O/S', country.countryname, states.state)) venue, " +
	"concount.counter, functs.funct " +
	"from contributor " +
	"inner join conevlink a on (contributor.contributorid = a.contributorid) " +
	"inner join events on (events.eventid = a.eventid) " +
	"inner join conevlink b on (a.eventid = b.eventid) " +
	"inner join venue on (events.venueid = venue.venueid) " +
	"left join states on (venue.state = states.stateid) " +
	"left join country on (venue.countryid = country.countryid) " +
	"inner join (" +
	"select distinct c.contributorid, count(distinct d.eventid) counter " +
	"from conevlink c " +
	"inner join conevlink d on (c.eventid = d.eventid)  " +
	"where d.contributorid = " + contrib_id + " " +
	"group by c.contributorid" +
	") concount on (concount.contributorid = contributor.contributorid) " +
	"inner join ( " +
	"select e.contributorid, count(cf.preferredterm) functcount, group_concat(distinct cf.preferredterm separator ', ') funct " +
	"from conevlink e " +
	"inner join conevlink f on (e.eventid = f.eventid)  " +
	"inner join contributorfunctpreferred cf on (e.function = cf.contributorfunctpreferredid) " +
	"where f.contributorid = " + contrib_id + " " +
	"group by e.contributorid " +
	"order by count(e.function) desc " +
	") functs on (functs.contributorid = contributor.contributorid) " +
	"where b.contributorid = " + contrib_id + " " +
	"and a.contributorid != " + contrib_id + " " +
	"order by concount.counter desc, contributor.last_name, contributor.first_name, events.first_date desc";
   ec_rs = m_db.runSQL(sqlString3, stmt3);
     
   out.println("\"Contributor\"");
   String prevCon = "";
   if(ec_rs.next()){
     do{
           if (!prevCon.equals(ec_rs.getString("contributorid"))) {
             out.print("\""+ ec_rs.getString("first_name")+" "+  ec_rs.getString("last_name")+ "\",");
             out.print("\""+ ec_rs.getString("funct")+ "\",");           
 	   }
 	   out.print("\""+ ec_rs.getString("event_name")+ "\",");
           out.print("\""+ ec_rs.getString("venue")+ "\",");
           out.print("\""+ formatDate(ec_rs.getString("DDFIRST_DATE"),ec_rs.getString("MMFIRST_DATE"),ec_rs.getString("YYYYFIRST_DATE"))+ "\",");
           out.println("");
     }while(ec_rs.next());
   }
    
  //Events by organisation
  out.println("");
  Statement stmt2    = m_db.m_conn.createStatement ();
  String sqlString2 = "";
  CachedRowSet eo_rs = null; 
  int eventorgcount = 0;
  sqlString2 = "SELECT DISTINCT events.eventid,events.event_name,events.ddfirst_date,events.mmfirst_date,events.yyyyfirst_date, "+
  	"events.first_date,venue.venue_name,venue.suburb,states.state,organisation.name "+
  	"FROM events,venue,states,organisation,conevlink,orgevlink "+
  	"WHERE conevlink.contributorid = " + contrib_id + " AND " + 
  	"conevlink.eventid = events.eventid AND "+
  	"events.venueid = venue.venueid AND "+
  	"venue.state = states.stateid AND "+
  	"events.eventid = orgevlink.eventid AND "+
  	"orgevlink.organisationid = organisation.organisationid "+
	"ORDER BY organisation.name,events.first_date DESC";
  eo_rs = m_db.runSQL(sqlString2, stmt2);
  
  if(eo_rs.next()){
    out.println("\"Events By Organisation\"");
    do{
           out.print("\""+ eo_rs.getString("event_name")+ "\",");
           out.print("\""+  eo_rs.getString("venue_name")+ "\",");
           out.print("\""+ eo_rs.getString("suburb")+ "\",");
           out.print("\""+ eo_rs.getString("state")+ "\",");
           out.print("\""+ formatDate(eo_rs.getString("DDFIRST_DATE"),eo_rs.getString("MMFIRST_DATE"),eo_rs.getString("YYYYFIRST_DATE"))+ "\",");
	   out.println("");
     	 } while(eo_rs.next());
    }
     	 
  //Works
  out.println("");
  int rowCount=0;
  rset = contributor.getAssociatedWorks(Integer.parseInt(contrib_id), stmt);
  String description = "";
  if(rset != null){
     out.println("\"Works\"");
      while(rset.next()){		   	  
   	out.println("\""+rset.getString("work_title")+ "\"");
      }
    }
    
  //Items
  int Counter=0;
  out.println("");
  rset = contributor.getAssociatedItems(Integer.parseInt(contrib_id), stmt);  
  if(rset != null){
      out.println("\"Resources\"");
      while(rset.next()){
    	   out.println("\""+ rset.getString("citation")+ "\"");
      }
    }
  // close statement
%>
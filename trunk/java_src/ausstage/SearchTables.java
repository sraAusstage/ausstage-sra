package ausstage;
import java.util.*;
import ausstage.Database;
import java.sql.*;
import sun.jdbc.rowset.*;
import java.lang.Character;


public class SearchTables 
{
  private Database m_db;
  private Connection m_conn;
  private String m_Table_List1 = "";
  private String m_Table_List2 = "";
  private String m_Table_List3 = "";
  private String m_keyword_textbox1 = "";
  private String m_keyword_textbox2 = "";
  private String m_keyword_textbox3 = "";
  private String m_FirstDate_dd = "";
  private String m_FirstDate_mm = "";
  private String m_FirstDate_yyyy = "";
  private String m_Between1_dd = "";
  private String m_Between1_mm = "";
  private String m_Between1_yyyy = "";
  private String m_Between2_dd = "";
  private String m_Between2_mm = "";
  private String m_Between2_yyyy = "";
  private CachedRowSet m_crset;
  private String m_sql_string = "";
  private String m_result_type = "";
  private String m_clause = "";
  private String m_dateClause = "";
  private String l_tables_used = "";
  
 
  public SearchTables(Database p_db)
  {
  m_db = p_db;
  }
 
  /*******************************
  Set methods to assign values to member varibles
  ********************************/

  public void setTableList1(String p_Table_List1, String p_keyword_textbox1){
    if(p_Table_List1 == null || p_Table_List1.equals("")){
       m_Table_List1 = "";
    }else{
       m_Table_List1 = p_Table_List1;
    }
    if(m_Table_List1.equals("") || m_Table_List1.equals(null)){
       m_keyword_textbox1 = "";
    }else{//make the string safe with no white space either side of the string
       m_keyword_textbox1 = m_db.plSqlSafeString(p_keyword_textbox1.toUpperCase()).trim();
    }
  }
  public void setTableList2(String p_Table_List2, String p_keyword_textbox2){
    if(p_Table_List2 == null || p_Table_List2.equals("")){
       m_Table_List2 = "";
    }else{
       m_Table_List2 = p_Table_List2;
    }
    if(m_Table_List2.equals("") || m_Table_List2.equals(null)){
       m_keyword_textbox2 = "";
    }else{//make the string safe with no white space either side of the string
       m_keyword_textbox2 = m_db.plSqlSafeString(p_keyword_textbox2.toUpperCase()).trim();
    }
  }
  public void setTableList3(String p_Table_List3, String p_keyword_textbox3){
    if(p_Table_List3 == null || p_Table_List3.equals("")){
       m_Table_List3 = "";
    }else{
       m_Table_List3 = p_Table_List3;
    }
    if(m_Table_List3.equals("") || m_Table_List3 == null){
       m_keyword_textbox3 = "";
    }else{//make the string safe with no white space either side of the string
       m_keyword_textbox3 = m_db.plSqlSafeString(p_keyword_textbox3.toUpperCase()).trim();
    }
  }
  public void setFirstDate(String p_FirstDate_dd, String p_FirstDate_mm, String p_FirstDate_yyyy){
    if(p_FirstDate_yyyy != null){m_FirstDate_yyyy = p_FirstDate_yyyy;};
    if(p_FirstDate_mm != null)  {m_FirstDate_mm   = p_FirstDate_mm;};
    if(p_FirstDate_dd != null)  {m_FirstDate_dd   = p_FirstDate_dd;}

  }
  public void setBetweenFromDate(String p_Between1_dd, String p_Between1_mm, String p_Between1_yyyy){
    if(p_Between1_yyyy != null){m_Between1_yyyy = p_Between1_yyyy;};
    if(p_Between1_mm != null)  {m_Between1_mm   = p_Between1_mm;};
    if(p_Between1_dd != null)  {m_Between1_dd   = p_Between1_dd;}

  }
  public void setBetweenToDate(String p_Between2_dd, String p_Between2_mm, String p_Between2_yyyy){
    if(p_Between2_yyyy != null){m_Between2_yyyy = p_Between2_yyyy;};
    if(p_Between2_mm != null)  {m_Between2_mm   = p_Between2_mm;};
    if(p_Between2_dd != null)  {m_Between2_dd   = p_Between2_dd;}

  }

 /*******************************
  end of set functions
  *******************************/
  /******************************
  start of get functions
  *******************************/
   public CachedRowSet getResult(){
    m_sql_string = null;
    m_sql_string = "select " + getSelectString() + " from " + getTables() + " where " + getClause() + m_dateClause;
    try{
      Statement l_stmt = m_db.m_conn.createStatement();     
      m_crset = m_db.runSQL(new String(m_sql_string.toString()), l_stmt);
      l_stmt.close();
      
    }catch(Exception e){
        
      System.out.println(">>>>>>>> EXCEPTION <<<<<<<<");
      System.out.println ("An Exception occured in SearchTables.getResult()");
      System.out.println("MESSAGE: " + e.getMessage());
      System.out.println("LOCALIZED MESSAGE: " + e.getLocalizedMessage());
      System.out.println("CLASS.TOSTRING: " + m_sql_string.toString());
      System.out.println(">>>>>>>>>>>>>-<<<<<<<<<<<<<");
      System.out.println(m_sql_string);
      System.out.println("It should be noted the user may have entered incorrect search keywords, such as *, &, $, + etc.. symbols");
      
    }
    return(m_crset);   
  }//end getResult
  public String returnQuery(){
   return m_sql_string ;
  }
  //the uppermost table selected will determine which results are returned to the user
  private String getSelectString(){
   String m_selectString = "";
    if(m_Table_List1 != "" && m_Table_List1 !=null){
       m_result_type = m_Table_List1;
    }
    else if(m_Table_List2 != "" && m_Table_List1 == ""){
        m_result_type = m_Table_List2;   
    }   
    else if(m_Table_List3 != "" && m_Table_List1 == "" && m_Table_List2 == ""){
        m_result_type = m_Table_List3;
    }
    else{}
    
    if (m_result_type.equals("Event")){ 
        m_selectString = "distinct search_event.eventid, search_event.event_name, search_event.venue_name, search_event.suburb, search_event.venue_state, search_event.first_date";
        setDateClause();//if event is result type we need to include the dates entered as part of the select clause.
    }                  //only event object have dates in them.
    else if(m_result_type.equals("Contributor")){
        m_selectString = "distinct search_contributor.contributorid, search_contributor.last_name, search_contributor.first_name, search_contributor.contrib_gender, search_contributor.nationality, search_contributor.date_of_birth";
    }
    else if(m_result_type.equals("Organisation")){      
        m_selectString = "distinct search_organisation.organisationid, search_organisation.name, search_organisation.address, search_organisation.suburb, search_organisation.org_state, search_organisation.web_links";    
    }
    else if(m_result_type.equals("Venue")){     
        m_selectString = "distinct search_venue.venueid, search_venue.venue_name, search_venue.street, search_venue.suburb, search_venue.venue_state, search_venue.web_links";
    }
    else if(m_result_type.equals("Publication")){
        m_selectString = "distinct search_publication.publicationid, search_publication.publication_name, search_publication.public_state";
    }
    
    return m_selectString;
    
  }//end getSelectString()

  public String getTables(){
 // String l_tables_used;
    /***************************************************************************************************
     It should be noted that in the setClause method when there are 2 or 3 table lists selectd 
     i.e. contributor, event and organisation that the contains database text search function
     is not used.  It was found by Luke, Jim, and Justin that the contains search function works very 
     inefficientlt with multiple conditions in the where clause. I.e. contributor.contribid = conevlink.contribid etc..
     For this reason when we link over miltiple tables including using link tables we have to use LIKE 
     pattern matching instead of the contains funciton.
     Contains is best and very fast if you use it with minimal or no conditions in the where clause.
     What is the fastest type of text query?
     For more information go to this link: http://otn.oracle.com/products/text/x/faqs/imt_perf_faq.html#q07
     The fastest type of query will meet the following conditions: 

     Single CONTAINS clause 
     No other conditions in the WHERE clause 
     EITHER: No "ORDER BY" clause at all, OR just "ORDER BY SCORE(n) DESCEND" together with the "FIRST_ROWS" hint 
     Only the first page of results is returned (eg. the first 10 or 20 hits). 

    ****************************************************************************************************/
  
    /*******************************************************
                        Event
    ********************************************************/
    if(m_Table_List1.equals("Event") && m_Table_List2.equals("") && m_Table_List3.equals("")){
       setClause("contains(search_event.combined_all, '" + m_keyword_textbox1 + "',0)>0 ");
       l_tables_used = "search_event";
    }
     else if(m_Table_List1.equals("") && m_Table_List2.equals("Event") && m_Table_List3.equals("")){
       setClause("contains(search_event.combined_all, '" + m_keyword_textbox2 + "',0)>0 ");
       l_tables_used = "search_event";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("") && m_Table_List3.equals("Event")){
       setClause("contains(search_event.combined_all, '" + m_keyword_textbox3 + "',0)>0 ");
       l_tables_used = "search_event";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid");
       l_tables_used = "search_event, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid");
       l_tables_used = "search_event, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Venue") && m_Table_List3.equals("")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.event_venueid = search_venue.venueid");
       l_tables_used = "search_event, search_venue";
    }
    /*else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Publication") && m_Table_List3.equals("")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_publication, artevlink, articles";
    }*/
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid");
       l_tables_used = "search_event, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid");
       l_tables_used = "search_event, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("") && m_Table_List3.equals("Venue")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid");
       l_tables_used = "search_event, search_venue";
    }
    /*
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("") && m_Table_List3.equals("Publication")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_publication, artevlink, articles";
    }*/
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Event") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid");
       l_tables_used = "search_event, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Event") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid");
       l_tables_used = "search_event, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Event") && m_Table_List3.equals("Venue")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "% and search_event.event_venueid = search_venue.venueid");
       l_tables_used = "search_event, search_venue";
    }/*
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Event") && m_Table_List3.equals("Publication")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "% and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_publication, artevlink, articles";
    }*/
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid");
       l_tables_used = "search_event, search_contributor, search_organisation, conevlink, orgevlink";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid");
       l_tables_used = "search_event, search_contributor, search_organisation, conevlink, orgevlink";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Venue")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid");
       l_tables_used = "search_event, search_contributor, search_venue, conevlink";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid");
       l_tables_used = "search_event, search_contributor, search_venue, conevlink";
    }/*
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Publication")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = artevlink.eventid and" + 
       " artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_contributor, search_publication, conevlink, artevlink, articles";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = artevlink.eventid and" + 
       " artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_contributor, search_publication, conevlink, artevlink, articles";
    }*/
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Venue")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.event_venueid = search_venue.venueid");
       l_tables_used = "search_event, search_organisation, orgevlink, search_venue";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.event_venueid = search_venue.venueid");
       l_tables_used = "search_event, search_organisation, orgevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Publication")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_organisation, orgevlink, artevlink, articles, search_publication";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, search_organisation, orgevlink, artevlink, articles, search_publication";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Publication")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, artevlink, articles, search_publication, search_venue";
    }
    else if(m_Table_List1.equals("Event") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Venue")){
       setClause("upper(search_event.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used = "search_event, artevlink, articles, search_publication, search_venue";
    } */
    /*******************************************************
                        Contributor
    ********************************************************/
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("") && m_Table_List3.equals("")){
       setClause("contains(search_contributor.combined_all, '" + m_keyword_textbox1 + "',0)>0 order by last_name, first_name asc");
       l_tables_used =  "search_contributor";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("")){
       setClause("contains(search_contributor.combined_all, '" + m_keyword_textbox2 + "',0)>0 order by last_name, first_name asc");
       l_tables_used =  "search_contributor";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("") && m_Table_List3.equals("Contributor")){
       setClause("contains(search_contributor.combined_all, '" + m_keyword_textbox3 + "',0)>0 order by last_name, first_name asc");
       l_tables_used =  "search_contributor";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Event") && m_Table_List3.equals("")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, orgevlink, contfunctlink, contfunct, search_organisation";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Venue") && m_Table_List3.equals("")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, search_venue";
    }
    /*
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Publication") && m_Table_List3.equals("")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, artevlink, articles, search_publication ";
    }*/
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("") && m_Table_List3.equals("Event")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, orgevlink, contfunctlink, contfunct, search_organisation";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("") && m_Table_List3.equals("Venue")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("") && m_Table_List3.equals("Publication")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, artevlink, articles, search_publication ";
    }*/
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Event")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, orgevlink, contfunctlink, contfunct, search_organisation";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Venue")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Publication")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, artevlink, articles, search_publication ";
    }*/
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Event") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Event")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Event") && m_Table_List3.equals("Venue")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, search_venue";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Event")){
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, search_event, conevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Event") && m_Table_List3.equals("Publication")){
       String clause = " artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc";
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and" + clause);
       l_tables_used =  "search_contributor, search_event, conevlink, artevlink, articles, search_publication";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Event")){
       String clause = " artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc";
       setClause("upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and" + clause);
       l_tables_used =  "search_contributor, search_event, conevlink, artevlink, articles, search_publication";
    }*/
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Venue")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%'";
       String clause1 = " order by last_name, first_name asc";
       setClause(clause + "  and search_contributor.contributorid  = contfunctlink.contributorid and contfunctlink.contributorfunctpreferredid = contfunct.contributorfunctpreferredid and contfunct.contributorfunctpreferredid = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid" + clause1);
       l_tables_used =  "search_contributor, orgevlink, search_organisation, search_venue, conevlink, search_event, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Organisation")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%'";
       String clause1 = " order by last_name, first_name asc";
       setClause(clause + "  and search_contributor.contributorid  = contfunctlink.contributorid and contfunctlink.contributorfunctpreferredid = contfunct.contributorfunctpreferredid and contfunct.contributorfunctpreferredid = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid" + clause1);
       l_tables_used =  "search_contributor, orgevlink, search_organisation, search_venue, conevlink, search_event, contfunct, contfunctlink";
    }/*
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Publication")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%'"; 
       String clause2 = " and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc";
       setClause(clause + " and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.contributorfunctpreferredid = contfunct.contributorfunctpreferredid and contfunct.contributorfunctpreferredid = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid" + clause2 );
       l_tables_used =  "search_contributor, orgevlink, search_organisation, search_venue, artevlink, articles, search_publication, search_event, conevlink, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Organisation")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%'"; 
       String clause2 = " and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc";
       setClause(clause + " and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.contributorfunctpreferredid = contfunct.contributorfunctpreferredid and contfunct.contributorfunctpreferredid = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid" + clause2 );
       l_tables_used =  "search_contributor, orgevlink, search_organisation, search_venue, artevlink, articles, search_publication, search_event, conevlink, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Publication")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%'";  
       setClause(clause + " and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, conevlink, search_event, search_venue, artevlink, articles, search_publication";
    }
    else if(m_Table_List1.equals("Contributor") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Venue")){
       String clause = "upper(search_contributor.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%'";  
       setClause(clause + " and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by last_name, first_name asc");
       l_tables_used =  "search_contributor, conevlink, search_event, search_venue, artevlink, articles, search_publication";
    }*/
    /*******************************************************
                        Organisation
    ********************************************************/
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("") && m_Table_List3.equals("")){
       setClause("contains(search_organisation.combined_all, '" + m_keyword_textbox1 + "',0)>0 order by name asc");
       l_tables_used =  "search_organisation";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("")){
       setClause("contains(search_organisation.combined_all, '" + m_keyword_textbox2 + "',0)>0 order by name asc");
       l_tables_used =  "search_organisation";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("") && m_Table_List3.equals("Organisation")){
       setClause("contains(search_organisation.combined_all, '" + m_keyword_textbox3 + "',0)>0 order by name asc");
       l_tables_used =  "search_organisation";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Event") && m_Table_List3.equals("")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_contributor, orgevlink, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Venue") && m_Table_List3.equals("")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Publication") && m_Table_List3.equals("")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid order by name asc" +
                 " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid");
       l_tables_used =  "search_organisation, search_event, search_publication, orgevlink, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("") && m_Table_List3.equals("Event")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_contributor, orgevlink, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("") && m_Table_List3.equals("Venue")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("") && m_Table_List3.equals("Publication")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid order by name asc" +
                 " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, search_publication, orgevlink, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Event")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_contributor, orgevlink, contfunct, contfunctlink";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Venue")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Publication")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, search_publication, orgevlink, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Event") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Event")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Event") &&  m_Table_List3.equals("Venue")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.event_venueid = search_venue.venueid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_venue";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Venue") &&  m_Table_List3.equals("Event")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.event_venueid = search_venue.venueid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_venue";
    }/*
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Event") && m_Table_List3.equals("Publication")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_publication, articles, artevlink";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Event")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_publication, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Venue")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID" +
                 " and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, contfunctlink, contfunct, search_contributor, search_venue";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID" +
                 " and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid and search_event.event_venueid = search_venue.venueid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, contfunctlink, contfunct, search_contributor, search_venue";
    }/*
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Publication")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID" +
                 " and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid" + 
                 " and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, contfunctlink, contfunct, search_contributor, articles, artevlink, search_publication";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid  = contfunctlink.contributorid  and contfunctlink.CONTRIBUTORFUNCTPREFERREDID = contfunct.CONTRIBUTORFUNCTPREFERREDID" +
                 " and contfunct.CONTRIBUTORFUNCTPREFERREDID = orgevlink.artistic_function and orgevlink.organisationid = search_organisation.organisationid and search_contributor.contributorid  = conevlink.contributorid  and conevlink.eventid = search_event.eventid" + 
                 " and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, conevlink, contfunctlink, contfunct, search_contributor, articles, artevlink, search_publication";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Publication")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_publication, articles, artevlink, search_venue";
    }
    else if(m_Table_List1.equals("Organisation") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Venue")){
       setClause("upper(search_organisation.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid" +
                 " and search_event.event_venueid = search_venue.venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by name asc");
       l_tables_used =  "search_organisation, search_event, orgevlink, search_publication, articles, artevlink, search_venue";
    }*/
    /*******************************************************
                        Venue
    ********************************************************/
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("") && m_Table_List3.equals("")){
       setClause("contains(search_venue.combined_all, '" + m_keyword_textbox1 + "',0)>0 order by venue_name asc");
       l_tables_used = "search_venue";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Venue") && m_Table_List3.equals("")){
       setClause("contains(search_venue.combined_all, '" + m_keyword_textbox2 + "',0)>0 order by venue_name asc");
       l_tables_used = "search_venue";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("") && m_Table_List3.equals("Venue")){
       setClause("contains(search_venue.combined_all, '" + m_keyword_textbox3 + "',0)>0 order by venue_name asc");
       l_tables_used = "search_venue";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Event") && m_Table_List3.equals("")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.event_venueid = search_venue.venueid order by venue_name asc");
       l_tables_used = "search_event, search_venue";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, conevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_organisation, orgevlink";
    }/*
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Publication") && m_Table_List3.equals("")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("") && m_Table_List3.equals("Event")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid order by venue_name asc");
       l_tables_used = "search_event, search_venue";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, conevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_organisation, orgevlink";
    }/*
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("") && m_Table_List3.equals("Publication")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, articles, artevlink";
    }*/
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Event")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.event_venueid = search_venue.venueid order by venue_name asc");
       l_tables_used = "search_event, search_venue";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, conevlink";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_organisation, orgevlink";
    }/*
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Publication")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, articles, artevlink";
    }  */  
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Event") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, conevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Event")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%'and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, conevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Event") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_organisation, orgevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Event")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "',0)>0 and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_organisation, orgevlink";
    }/*
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Event") && m_Table_List3.equals("Publication")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, artevlink, articles";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Event")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, artevlink, articles";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Publication")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and" +
                " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, search_contributor, conevlink, artevlink, articles";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and" +
                " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, search_contributor, conevlink, artevlink, articles";
    }*/
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and" +
                " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, orgevlink conevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and" +
                " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_contributor, orgevlink conevlink";
    }/*
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Publication")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and" +
                " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, search_organisation, orgevlink, articles, artevlink";
    }
    else if(m_Table_List1.equals("Venue") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_venue.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and" +
                " search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by venue_name asc");
       l_tables_used = "search_event, search_venue, search_publication, search_organisation, orgevlink, articles, artevlink";
    }*/
    /*******************************************************
                        Publication
    ********************************************************/
    /*
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("") && m_Table_List3.equals("")){
       setClause("contains(search_publication.combined_all, '" + m_keyword_textbox1 + "',0)>0 order by publication_name asc");
       l_tables_used = "search_publication";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Publication") && m_Table_List3.equals("")){
       setClause("contains(search_publication.combined_all, '" + m_keyword_textbox2 + "',0)>0 order by publication_name asc");
       l_tables_used = "search_publication";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("") && m_Table_List3.equals("Publication")){
       setClause("contains(search_publication.combined_all, '" + m_keyword_textbox3 + "',0)>0 order by publication_name asc");
       l_tables_used = "search_publication";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Event") && m_Table_List3.equals("")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc");
       l_tables_used = "search_publication, search_event, artevlink, articles";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and search_contributor.contributorid = conevlink.contributorid and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Venue") && m_Table_List3.equals("")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("") && m_Table_List3.equals("Event")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc");
       l_tables_used = "search_publication, search_event, artevlink, articles";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid = conevlink.contributorid and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("") && m_Table_List3.equals("Venue")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Event")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc");
       l_tables_used = "search_publication, search_event, artevlink, articles";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_contributor.contributorid = conevlink.contributorid and conevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_organisation.organisationid = orgevlink.organisationid and orgevlink.eventid = search_event.eventid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("") && m_Table_List2.equals("Publication") && m_Table_List3.equals("Venue")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_venue.venueid = search_event.event_venueid and search_event.eventid = artevlink.eventid and artevlink.articleid = articles.articleid and articles.public_id = search_publication.publicationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles";
    } 
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Event") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorsid = search_contributor.contributorid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Event")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorsid = search_contributor.contributorid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles conevlink, search_contributor";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Event") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Event")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Event") && m_Table_List3.equals("Venue")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Event")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_event.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, search_venue, artevlink, articles";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = orgvlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.eventid = orgvlink.eventid and orgevlink.organisationid = search_organisation.organisationid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor, orgevlink, search_organisation";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Contributor") && m_Table_List3.equals("Venue")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor, search_venue";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Contributor")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_contributor.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = conevlink.eventid and conevlink.contributorid = search_contributor.contributorid and search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, conevlink, search_contributor, search_venue";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Organisation") && m_Table_List3.equals("Venue")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, orgevlink, search_organisation, search_venue";
    }
    else if(m_Table_List1.equals("Publication") && m_Table_List2.equals("Venue") && m_Table_List3.equals("Organisation")){
       setClause("upper(search_publication.combined_all) like '%" + m_keyword_textbox1 + "%' and upper(search_venue.combined_all) like '%" + m_keyword_textbox2 + "%' and upper(search_organisation.combined_all) like '%" + m_keyword_textbox3 + "%' and search_publication.publicationid = articles.public_id and articles.articleid = articles.articleid and articles.articleid = artevlink.articleid and artevlink.eventid = search_event.eventid and" + 
                 " search_event.eventid = orgevlink.eventid and orgevlink.organisationid = search_organisation.organisationid and search_event.event_venueid = search_venue.venueid order by publication_name asc"); 
       l_tables_used = "search_publication, search_event, artevlink, articles, orgevlink, search_organisation, search_venue";
    }
    */
    return l_tables_used;
  }
  
  private void setClause(String p_clause){
    m_clause = "";
    m_clause = p_clause;
  
  }

  private String getClause(){
    return (m_clause);
  }

  private void setDateClause(){
    m_dateClause = "";
    Search search = new Search(m_db);
    /***********************************************
    *  DATES: only called if result type is event  *
    *  NOTE: all dates MUST be in yyyy-mm-dd format*
    ************************************************/
        ///set the order by to first_date if the user doesn't enter a date
    if(m_FirstDate_dd.equals("") && m_FirstDate_mm.equals("") && m_FirstDate_yyyy.equals("")){
          m_dateClause = " order by first_date desc";
      }
    else if(m_Between1_dd.equals("") && m_Between1_mm.equals("") && m_Between1_yyyy.equals("") 
              && m_Between2_dd.equals("") && m_Between2_mm.equals("") && m_Between2_yyyy.equals("")){
          m_dateClause = " order by first_date desc";
      }
    
    if(m_FirstDate_yyyy != null && !m_FirstDate_yyyy.equals("")){

      ////////////////////////////
      // FIRST DATE ON
      ////////////////////////////
  
      if(!m_FirstDate_dd.equals("")){
        m_dateClause = "";
        m_dateClause = " and first_date=to_date('" + m_FirstDate_yyyy + "-" + m_FirstDate_mm + "-" + m_FirstDate_dd + "','yyyy-mm-dd') order by first_date desc";

      }else if(!m_FirstDate_mm.equals("") && !m_FirstDate_yyyy.equals("")){

        if(m_FirstDate_mm.equals("02")){

          // do some leap year testing
          GregorianCalendar cal = new GregorianCalendar();
          if(cal.isLeapYear(Integer.parseInt(m_FirstDate_yyyy))){
            m_dateClause  = (" and (first_date between to_date('" + m_FirstDate_yyyy + "-02-01','yyyy-mm-dd') and ");
            m_dateClause += ("to_date('" + m_FirstDate_yyyy + "-02-29','yyyy-mm-dd')) order by first_date desc");
          }else{
            m_dateClause  = (" and (first_date between to_date('" + m_FirstDate_yyyy + "-02-01','yyyy-mm-dd') and ");
            m_dateClause += ("to_date('" + m_FirstDate_yyyy + "-02-28','yyyy-mm-dd')) order by first_date desc");
          }

        }else{
          // lets get the last date of the given month & year
          String num_of_days = Integer.toString(search.getNumberOfDays(m_FirstDate_mm, Integer.parseInt(m_FirstDate_yyyy)));

          m_dateClause  = (" and (first_date between to_date('" + m_FirstDate_yyyy + "-" + m_FirstDate_mm + "-01','yyyy-mm-dd') and ");
          m_dateClause += ("to_date('" + m_FirstDate_yyyy + "-" + m_FirstDate_mm + "-" + num_of_days + "','yyyy-mm-dd')) order by first_date desc");
        }

      }else{ // only YEAR is specified
          m_dateClause  = (" and (first_date between to_date('" + m_FirstDate_yyyy + "-01-01','yyyy-mm-dd') and ");
          m_dateClause += ("to_date('" + m_FirstDate_yyyy + "-12-31','yyyy-mm-dd')) order by first_date desc");
      }
    
    }else if((m_Between1_yyyy != null && !m_Between1_yyyy.equals("")) 
          && (m_Between2_yyyy != null && !m_Between2_yyyy.equals(""))){

      ////////////////////////////
      // BETWEEN DATES
      ////////////////////////////          
          
      //  From Date
      if(!m_Between1_dd.equals("")){
        m_dateClause = (" and (first_date between to_date('" + m_Between1_yyyy + "-" + m_Between1_mm + "-" + m_Between1_dd + "','yyyy-mm-dd') and ");
      }else if(!m_Between1_mm.equals("") && !m_Between1_yyyy.equals("")){
        m_dateClause = (" and (first_date between to_date('" + m_Between1_yyyy + "-" + m_Between1_mm + "-01','yyyy-mm-dd') and ");
      }else{ // only YEAR is specified
        m_dateClause = (" and (first_date between to_date('" + m_Between1_yyyy + "-01-01','yyyy-mm-dd') and ");
      } 

      // To Date
      if(!m_Between2_dd.equals("")){
        m_dateClause += ("to_date('" + m_Between2_yyyy + "-" + m_Between2_mm + "-" + m_Between2_dd + "','yyyy-mm-dd')) order by first_date desc");
      }else if(!m_Between2_mm.equals("") && !m_Between2_yyyy.equals("")){

        if(m_Between2_mm.equals("02")){
          // do some leap year testing
          GregorianCalendar cal = new GregorianCalendar();
          if(cal.isLeapYear(Integer.parseInt(m_Between2_yyyy))){
            m_dateClause += ("to_date('" + m_Between2_yyyy + "-02-29','yyyy-mm-dd')) order by first_date desc");
          }else{
            m_dateClause += ("to_date('" + m_Between2_yyyy + "-02-28','yyyy-mm-dd')) order by first_date desc");
          }

        }else{
          // lets get the last date of the given month & year
          String num_of_days = Integer.toString(search.getNumberOfDays(m_Between2_mm, Integer.parseInt(m_Between2_yyyy)));
          m_dateClause += ("to_date('" + m_Between2_yyyy + "-" + m_Between2_mm + "-" + num_of_days + "','yyyy-mm-dd')) order by first_date desc");
        }

      }else{ // only YEAR is specified
        m_dateClause += ("to_date('" + m_Between2_yyyy + "-12-31','yyyy-mm-dd')) order by first_date desc");
      }      
    }

  }

 public String getTableToBeDisplayed(){
    return m_result_type;
 }

  
}//end SearchTables
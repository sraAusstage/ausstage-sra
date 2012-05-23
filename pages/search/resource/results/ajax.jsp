<%@ page pageEncoding="UTF-8"%><%@ page contentType="text/html; charset=UTF-8"%><%@ page import = "java.util.Vector, java.util.StringTokenizer,java.util.Calendar, java.text.SimpleDateFormat"%><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%><%@ page import = "ausstage.Event, ausstage.State, ausstage.Search, ausstage.Contributor, admin.Common"%><%@ page import = "ausstage.AusstageCommon, ausstage.AdvancedSearch"%><%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%><jsp:useBean id="ausstage_db_for_result" class="ausstage.Database" scope="application"><%ausstage_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%
  ausstage.Database          db_ausstage_for_collection_result       = new ausstage.Database ();
  admin.Common            common                                  = new admin.Common   ();
  
  db_ausstage_for_collection_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crsetResult    = null;
  Search search;
  String formatted_date       = "";
  String keyword              = request.getParameter("f_keywords");
  String page_num             = request.getParameter("f_page_num");
  String recset_count         = request.getParameter("f_recset_count");
   
  if(keyword == null)
      keyword="";
 
  String         sub_types []                = (String [])request.getParameterValues("f_sub_types");  
  String         firstdate_dd                = request.getParameter("f_firstdate_dd");
  String         firstdate_mm                = request.getParameter("f_firstdate_mm");
  String         firstdate_yyyy              = request.getParameter("f_firstdate_yyyy");
  String         collectingInstitution       = request.getParameter("f_collectingInstitution");
  if(collectingInstitution == null)
    collectingInstitution="";  
  String creator                             = request.getParameter("f_creator");
  if(creator == null)    creator="";
  String title                   	     = request.getParameter("f_title");
  if(title == null)    title="";
  String source            		     = request.getParameter("f_source");
  if(source == null)    source="";           
  String work 		                     = request.getParameter("f_work");
  if(work == null)    work="";
  String         event                       = request.getParameter("f_event");
  if(event == null)    event="";
  String         contributor                 = request.getParameter("f_contributor");
  if(contributor == null)    contributor="";
  String         venue                       = request.getParameter("f_venue");
  if(venue == null)    venue="";
  String assoc_item                          = request.getParameter("f_assoc_item");       
  if(assoc_item == null)    assoc_item="";    
  String         l_organisation              = request.getParameter("f_organisation");
  if(l_organisation == null)    l_organisation="";
  //String         secondary_genre []          = (String [])request.getParameterValues("f_secondary_genre"); 
  //if(secondary_genre == null)
  //  secondary_genre="";
  String         l_boolean                   = request.getParameter("f_boolean");
  if(l_boolean == null)    l_boolean="";
  String         sort_by                     = request.getParameter("f_sort_by");
  if(sort_by == null)    sort_by="";
      
  int l_int_page_num =0;
  
  State state                    = new State(db_ausstage_for_collection_result);
  SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
  
  String [] subTypes             = sub_types;
  //String [] secGenreArray = secondary_genre;
  
  boolean do_print               = false;
  String	resultsPerPage         = request.getParameter("f_limit_by");;
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "20";

    ///////////////////////////////////
    //    DISPLAY SEARCH RESULTS
    //////////////////////////////////
    int counter;
    int start_trigger;
    int curr_row = 0;      
    // never going to be a collection search from this page
    search = new Search(db_ausstage_for_collection_result);

    search.setKeyWord(keyword.trim());
    
    search.setSqlSwitch("and");
    
    search.setSortBy(sort_by);
      
    // set the search sub types array
    search.setSubTypes(subTypes);
    search.setFirstDate(firstdate_yyyy,firstdate_mm,firstdate_dd);

    //search.setSecondaryGenre(secGenreArray);
    
    search.setTitle(title);
    search.setSource(source);
    search.setCreator(creator);
    
    search.setContributor(contributor);
    search.setCollectionInstitution(collectingInstitution);
    search.setWork(work);
    search.setEvent(event);
    search.setVenue(venue);
    search.setResourceVisible(assoc_item);
    search.setBoolean(l_boolean);
    search.setOrganisation(l_organisation);

    if(page_num != null){

      if(Integer.parseInt(page_num) > 1)
        curr_row = Integer.parseInt(page_num) * Integer.parseInt(resultsPerPage) - Integer.parseInt(resultsPerPage);
    }else{
      recset_count = search.getRecordCount();
    }

    crsetResult = search.getResources();
      
    if(crsetResult != null && crsetResult.next()){
      // get the number of rows returned (1st time only)
      if(page_num == null){
      page_num="1";
        crsetResult.last(); 
        recset_count = Integer.toString(crsetResult.getRow());
        crsetResult.first();         
      }

     }
    out.print(recset_count==null?"0":recset_count); 

    
%>
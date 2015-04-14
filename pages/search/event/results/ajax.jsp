<%@ page pageEncoding="UTF-8"%><%@ page contentType="text/html; charset=UTF-8"%><%@ page import = "java.util.Vector, java.util.StringTokenizer,java.util.Calendar, java.text.SimpleDateFormat"%><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%><%@ page import = "ausstage.Event, ausstage.State, ausstage.Search, ausstage.Contributor, admin.Common"%><%@ page import = "ausstage.AusstageCommon, ausstage.AdvancedSearch"%><%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%><jsp:useBean id="ausstage_db_for_result" class="ausstage.Database" scope="application"><%ausstage_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%
  ausstage.Database db_ausstage_for_result          = new ausstage.Database ();
  Common         common                          = new Common();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet   crset                           = null;
  String         event_id                        = request.getParameter("f_event_id");
  String         event_name                      = request.getParameter("f_event_name");
  String         betweenfrom_dd                  = request.getParameter("f_betweenfrom_dd");
  String         betweenfrom_mm                  = request.getParameter("f_betweenfrom_mm");
  String         betweenfrom_yyyy                = request.getParameter("f_betweenfrom_yyyy");
  String         betweento_dd                    = request.getParameter("f_betweento_dd");
  String         betweento_mm                    = request.getParameter("f_betweento_mm");
  String         betweento_yyyy                  = request.getParameter("f_betweento_yyyy");
  String         venue_id                        = request.getParameter("f_venue_id");
  String         venue_name                      = request.getParameter("f_venue_name");
  String         state                           = request.getParameter("f_states");
  String         country                         = request.getParameter("f_countries");
  String         umbrella                        = request.getParameter("f_umbrella");
  String         status                          = request.getParameter("f_status");
  String         primary_genre                   = request.getParameter("f_primary_genre");
  String []      secondary_genre                 = (String [])request.getParameterValues("f_secondary_genre");
  String         prim_cont_indi                  = request.getParameter("f_prim_cont_indi");
  String         origin_of_text                  = request.getParameter("f_origin_of_text");
  String         origin_of_production            = request.getParameter("f_origin_of_production");
  String         organisation_id                 = request.getParameter("f_organisation_id");
  String         organisation_name               = request.getParameter("f_organisation_name");
  String         organisation_function           = request.getParameter("f_organisation_function");
  String         contributor_id                  = request.getParameter("f_contributor_id");
  String         contributor_name                = request.getParameter("f_contributor_name");
  String         contributor_function            = request.getParameter("f_contributor_function");
  String         orderBy                         = request.getParameter("f_order_by");
  String         sortOrd                         = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
  String         assoc_item                      = request.getParameter("f_assoc_item");

  // resource attributes
  String resource_title                          = request.getParameter("f_resource_title");
  String resource_source                         = request.getParameter("f_resource_source");
  String resource_abstract                       = request.getParameter("f_resource_abstract");
  String [] resource_subTypes                    = (String [])request.getParameterValues("f_sub_types");

  String resource_contributor_creator            = request.getParameter("f_resource_contributor_creator");
  String resource_organisation_creator           = request.getParameter("f_resource_organisation_creator");

  String         table_to_search_from            = request.getParameter("f_search_from");
  String         formatted_date                  = "";
  String         page_num                        = request.getParameter("f_page_num");
  String         recset_count                    = request.getParameter("f_recset_count");
  String         search_within_search_for_result = request.getParameter("f_search_within_search");
  
  boolean        do_print                        = false;
  int            result_count                    = 0;
  SimpleDateFormat formatPattern                 = new SimpleDateFormat("dd/MM/yyyy");
  AdvancedSearch   advancedSearch                = new AdvancedSearch(db_ausstage_for_result);
  String           resultsPerPage                = request.getParameter("f_limit_by");
  if (resultsPerPage == null || !"20 50 75 100".contains(resultsPerPage)) resultsPerPage = "20";

  ///////////////////////////////////
  //    DISPLAY SEARCH RESULTS
  //////////////////////////////////

  int counter;
  int start_trigger;
  int curr_row = 0;
  //some of the dates could be null because javascript disable == true removes the element 
  //from the form.
  if(betweenfrom_dd == null){betweenfrom_dd = "";}
  if(betweenfrom_mm == null){betweenfrom_mm = "";}
  if(betweenfrom_yyyy == null){betweenfrom_yyyy = "";}
  if(betweento_dd == null){betweento_dd = "";}
  if(betweento_mm == null){betweento_mm = "";}
  if(betweento_yyyy == null){betweento_yyyy = "";}

  /******** call all the SET methods from AdvancedSearch.java **********/
  if(event_id != null && event_name != null && betweenfrom_dd != null && betweenfrom_mm !=null
    && betweenfrom_yyyy != null && betweento_dd != null && betweento_mm != null
    && betweento_yyyy != null && umbrella != null){
    
    advancedSearch.setEventInfo(event_id, event_name, betweenfrom_dd, betweenfrom_mm,
                                betweenfrom_yyyy, betweento_dd, betweento_mm,
                                betweento_yyyy, umbrella);
  }
  if(venue_id != null || venue_name != null || state != null ){
      advancedSearch.setVenueInfo(venue_id, venue_name, state);
      //advancedSearch.setVenueInfo(venue_id, venue_name, state, country);
  }
  if(primary_genre != null || secondary_genre != null){
    advancedSearch.setGenreInfo(primary_genre, secondary_genre);
  }
  if(status  != null && !status.equals("")){     
    System.out.println("status" + status + "%");
    advancedSearch.setStatus(status);
  }
  if(prim_cont_indi  != null){                   
    advancedSearch.setContentInfo(prim_cont_indi);
  }
  if(assoc_item != null){
    advancedSearch.setAssociatedItems(assoc_item);
  }
  
  if(origin_of_text != null || origin_of_production != null ){
    advancedSearch.setOriginsInfo(origin_of_text, origin_of_production);
  }
  if(organisation_id != null || organisation_name != null || organisation_function != null){
    advancedSearch.setOrganisationInfo(organisation_id, organisation_name, organisation_function);
  }
  if(contributor_id != null || contributor_name != null || contributor_function != null){
    advancedSearch.setContributorInfo(contributor_id, contributor_name, contributor_function);
  }

  if(orderBy != null){
    advancedSearch.setOrderBy(orderBy + " " + sortOrd);
  }

  // If the user has performed a search
  if (resource_title != null){

    // set null values for diabled fields to ""
    advancedSearch.setResourceInfo(resource_title, resource_source, resource_abstract, 
                                  resource_contributor_creator, resource_organisation_creator, resource_subTypes, 
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null, null);
  }
  advancedSearch.buildFromAndLinksSqlString();
  crset = advancedSearch.getResult();
 /*********Event******************************************************
  the result will always display event information for advanced search
 *********************************************************************/
  //if(table_to_be_displayed.equals("Event")){   
  if(crset != null && crset.next()){
    // get the number of rows returned (1st time only)
    if(page_num == null){
      page_num="1";
      crset.last(); 
      recset_count = Integer.toString(crset.getRow());
      crset.first();         
    }   
  
  }
    out.print(recset_count==null?"0":recset_count);
  

 %>
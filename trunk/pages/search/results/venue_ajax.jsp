<%@ page pageEncoding="UTF-8"%><%@ page contentType="text/html; charset=UTF-8"%><%@ page import = "java.util.Vector, java.util.StringTokenizer,java.util.Calendar, java.text.SimpleDateFormat"%><%@ page import = "java.sql.*, sun.jdbc.rowset.*"%><%@ page import = "ausstage.Event, ausstage.State, ausstage.Search, ausstage.Contributor, admin.Common"%><%@ page import = "ausstage.AusstageCommon, ausstage.AdvancedSearch"%><%admin.AppConstants ausstage_search_appconstants_for_result = new admin.AppConstants(request);%><jsp:useBean id="ausstage_db_for_result" class="ausstage.Database" scope="application"><%ausstage_db_for_result.connDatabase(ausstage_search_appconstants_for_result.DB_PUBLIC_USER_NAME, ausstage_search_appconstants_for_result.DB_PUBLIC_USER_PASSWORD);%>
</jsp:useBean><%
  //created by BW
  //it is just another search to determine from the basic search page if there are results returned or not. 
  
  ausstage.Database db_ausstage_for_result       = new ausstage.Database ();
  Common         common                          = new Common();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet   crset                  = null;
  String         recset_count		= "0";
  
  String         keyword		= request.getParameter("f_keyword");
  String         search_from            = request.getParameter("f_search_from");
  String         sql_switch	        = request.getParameter("f_sql_switch");
  String         year			= request.getParameter("f_year");
 
  Search 	search 			= new Search(db_ausstage_for_result);

 
  ///////////////////////////////////
  //    DISPLAY SEARCH RESULTS
  //////////////////////////////////

  int counter;
  int start_trigger;
  int curr_row = 0;
 

  /******** call all the SET methods from Search.java **********/
  // Make sure that a keyword has been entered. The user may have javascript disabled.
  if (keyword == null || keyword.equals("null") || keyword.equals("")) {
      	search.setKeyWord("xxxxNoDataEnteredxx"); // Dummy string so that an error is not generated by the database 
  } 
  else {
  	search.setKeyWord(keyword.trim());
  }

  if( sql_switch != null){ search.setSqlSwitch(sql_switch); }

  if( search_from != null){ search.setSearchFor(search_from); }


  
  crset = search.getVenues();
  

  

  
 /*********************************************************************/
  //if(table_to_be_displayed.equals("Event")){   
  if(crset != null && crset.next()){
    // get the number of rows returned (1st time only)

      crset.last(); 
      recset_count = Integer.toString(crset.getRow());
      crset.first();         
       
  
  }
    
    out.print (recset_count==null?"0":recset_count);
  

 %>
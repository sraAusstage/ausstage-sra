<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  
  String        sqlString;
  CachedRowSet  rset;
  int           MAX_RESULTS_RETURNED = 1000;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);

  Vector filter_display_names       = new Vector ();
  Vector filter_names               = new Vector ();
  Vector order_display_names        = new Vector ();
  Vector order_names                = new Vector ();
  Vector textarea_db_display_fields = new Vector ();
  Vector buttons_names              = new Vector ();
  Vector buttons_actions            = new Vector ();
  String list_name;
  String list_db_sql;
  String list_db_field_id_name;
  String filter_id, filter_name, filter_state, filter_suburb;

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id     = request.getParameter ("f_id");
  filter_name   = request.getParameter ("f_name");

  // Setup the vectors for the search
  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("Name");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_name");

  order_display_names.addElement ("Name");
  order_names.addElement ("name");

  list_name              = "f_organisation_id";
  list_db_field_id_name  = "organisationid";
  textarea_db_display_fields.addElement ("OUTPUT");
  
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Delete");
  buttons_actions.addElement ("Javascript:location.href='organisation_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_addedit.jsp?act=edit';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='organisation_del_confirm.jsp';search_form.submit();");
    
  // if first time this form has been loaded
  if (filter_id == null)
  {

     list_db_sql =   "SELECT organisation.organisationid, name, if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) dates, "+
		"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
		"FROM organisation LEFT JOIN orgevlink ON (orgevlink.organisationid = organisation.organisationid) "+
		"LEFT JOIN events ON (orgevlink.eventid = events.eventid) "+
		"GROUP BY organisation.organisationid order by organisation.name  ";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   
        list_db_sql = "SELECT organisation.organisationid, organisation.name, "+
		"if (min(events.yyyyfirst_date) = max(events.yyyylast_date), "+
		"min(events . yyyyfirst_date), concat(min(events . yyyyfirst_date), ' - ', max(events . yyyylast_date))) dates, "+
		"CONCAT_WS(', ',name,if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date)))) as OUTPUT "+
		"FROM organisation left join orgevlink on (orgevlink.organisationid = organisation.organisationid) "+
		"left join events on orgevlink.eventid = events . eventid Where 1=1 ";
		
		
	//SPECIAL HANDLING FOR THE EVENT_NAME FIELD. 
    	    String orgNameWhere = "";
	    String orgOrderBy = "";
	    String remove = "a,and,the,an,i,it,if";
	    List<String> removeWords = new ArrayList<String>(Arrays.asList(remove.split(",")));
	    //if event_name is entered 
	    if (!filter_name.equals ("")){
	        List<String> terms = new ArrayList<String>(); // TO HOLD THE SEARCH TERMS - WILL BE BUILT WITHOUT removeWords
		List<String> shortTerms = new ArrayList<String>();
	
    	// - remove [a, and, the, an, I, it, if] 
	// - then split it.- [term111, term222, term333] etc
	    	for(String term : db_ausstage.plSqlSafeString(filter_name.toLowerCase()).split(" ") ){
			if (term.length() > 2 && !removeWords.contains(term)){
				terms.add(term);    	
				if(term.length() > 4){
					shortTerms.add(term.substring(0,5));
				}
				else shortTerms.add(term);
			}
	    	}
    	// - create a where clause where event name contains 
    	//   term1% OR term2% OR term3%
		int i = 0;
		orgNameWhere += "and ( ";
	    	for (String term : shortTerms){
	    		if (i != 0 ){ 
	    			orgNameWhere +=" OR ";
    			}
    			orgNameWhere +=" LOWER(organisation.name) like '%" + term + "%' ";
	    		i++;
    		}
	    	orgNameWhere += ")";
    	
	//    	System.out.println("*******");
	//    	System.out.println(eventNameWhere);
    	
    	//then create an order by case - 	original string
	    	int relevance = 1;
    		orgOrderBy = " CASE WHEN lower(organisation.name) like '"+db_ausstage.plSqlSafeString(filter_name.toLowerCase())+"' THEN "+relevance+" ELSE 1000 END, ";
	    	relevance++;
    	//					%term111%term222%term333%
		orgOrderBy += " CASE WHEN lower(organisation.name) like '"+db_ausstage.plSqlSafeString(filter_name.toLowerCase()).replace(' ', '%')+"%' THEN "+relevance+" ELSE 1000 END, ";
	    	relevance++;
    		orgOrderBy += " CASE WHEN lower(organisation.name) like '%"+db_ausstage.plSqlSafeString(filter_name.toLowerCase()).replace(' ', '%')+"%' THEN "+relevance+" ELSE 1000 END, ";
	    	relevance++;
    	// 					term1%term2%term3%
    		orgOrderBy += " CASE WHEN lower(organisation.name) like '";
	    	for (String term : shortTerms){
   			orgOrderBy += term + "%";
	    	}
    		orgOrderBy += "' THEN "+relevance+" ELSE 1000 END, "; 
	    	relevance++;
 	// 					%term1%term2%term3%
    		orgOrderBy += " CASE WHEN lower(organisation.name) like '%";
	    	for (String term : shortTerms){
	   		orgOrderBy += term + "%";
    		}
	    	orgOrderBy += "' THEN "+relevance+" ELSE 1000 END, "; 
    		relevance++;
	//					term111%
	//					term222%
	//					term333%
	    	for (String term : terms){
   			orgOrderBy += " CASE WHEN lower(organisation.name) like '"+term+"%' THEN "+relevance+" ELSE 1000 END, ";
   			relevance++;
	    	}
	//					%term111%
	//					%term222%
	//					%term333%
    		for (String term : terms){
	   		orgOrderBy += " CASE WHEN lower(organisation.name) like '%"+term+"%' THEN "+relevance+" ELSE 1000 END, ";
   			relevance++;
	    	}
    	// 					term1%
    	// 					term2%
    	// 					term3%
    		for (String term : shortTerms){
	   		orgOrderBy += " CASE WHEN lower(organisation.name) like '"+term+"%' THEN "+relevance+" ELSE 1000 END, ";
   			relevance++;
	    	}    	
    	// 					%term1%
    	// 					%term2%
    	// 					%term3%
    		for (String term : shortTerms){
   			orgOrderBy += " CASE WHEN lower(organisation.name) like '%"+term+"%' THEN "+relevance+" ELSE 1000 END, ";
	   		relevance++;
    		}
	//    	System.out.println("ORDER BY --------------");
    	//    	System.out.println(eventOrderBy);
	    }
	    // Add the filters to the SQL
	    if (!filter_id.equals (""))
	      list_db_sql += "and organisation.organisationid=" + filter_id + " ";
	    if (!filter_name.equals ("")){
	      list_db_sql += orgNameWhere;
	    }
  
    list_db_sql += "Group by organisation.organisationid order by " 
    		+ orgOrderBy
    		+ request.getParameter ("f_order_by");
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
 // pageFormater.writeHelper(out, "Organisation Maintenance ","helpers_no1.gif");
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.
  //System.out.println(list_db_sql);
  out.println (htmlGenerator.displaySearchFilter (request, "Select Organisation",
                                        filter_display_names,
                                        filter_names,
                                        order_display_names,
                                        order_names,
                                        list_name,
                                        list_db_sql,
                                        list_db_field_id_name,
                                        textarea_db_display_fields,
                                        buttons_names,
                                        buttons_actions,
                                        false, 
                                        MAX_RESULTS_RETURNED));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<cms:include property="template" element="foot" />
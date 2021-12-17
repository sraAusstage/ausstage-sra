<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
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
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

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
  String filter_id, filter_f_name, filter_l_name, filter_state, filter_suburb;

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_id     = request.getParameter ("f_id");
  filter_f_name = request.getParameter ("f_first_name");
  filter_l_name = request.getParameter ("f_last_name");
 // filter_state  = request.getParameter ("f_state");
  //filter_suburb = request.getParameter ("f_suburb");
  
  boolean exactFirstName = false;
  boolean exactLastName  = false;

//out.println(request.getParameter ("exactFirstName"));

  if (request.getParameter ("exactFirstName") != null) {
    exactFirstName = true;
  }
  if (request.getParameter ("exactLastName") != null) {
    exactLastName = true;
  }


  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("First Name");
  filter_display_names.addElement ("Last Name");
//  filter_display_names.addElement ("State");
 // filter_display_names.addElement ("Suburb");
  
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_first_name");
  filter_names.addElement ("f_last_name");
//  filter_names.addElement ("f_state");
//  filter_names.addElement ("f_suburb");

  if(request.getParameter ("f_order_by") != null && request.getParameter ("f_order_by").equals("first_name")){
    order_names.addElement ("first_name");
    order_names.addElement ("last_name");
    order_display_names.addElement ("First Name");
    order_display_names.addElement ("Last Name");
   // textarea_db_display_fields.addElement ("first_name");
   // textarea_db_display_fields.addElement ("last_name");
    //textarea_db_display_fields.addElement ("name");
   // textarea_db_display_fields.addElement ("dates");
   // textarea_db_display_fields.addElement ("first_year");
   // textarea_db_display_fields.addElement ("last_year");
   // textarea_db_display_fields.addElement ("preferredterm");
 textarea_db_display_fields.addElement ("output");
    
    
  }else if(request.getParameter ("f_order_by") != null && request.getParameter ("f_order_by").equals("last_name")){
    order_names.addElement ("last_name");
    order_names.addElement ("first_name");
    order_display_names.addElement ("Last Name");
    order_display_names.addElement ("First Name");
  //  textarea_db_display_fields.addElement ("name");
   // textarea_db_display_fields.addElement ("last_name");
   // textarea_db_display_fields.addElement ("first_name");
   // textarea_db_display_fields.addElement ("dates");
   // textarea_db_display_fields.addElement ("preferredterm");
     textarea_db_display_fields.addElement ("output");
  }else{
    order_names.addElement ("first_name");
    order_names.addElement ("last_name");
    order_display_names.addElement ("First Name");
    order_display_names.addElement ("Last Name");
   // textarea_db_display_fields.addElement ("name");
   // textarea_db_display_fields.addElement ("first_name");
   // textarea_db_display_fields.addElement ("last_name");
   // textarea_db_display_fields.addElement ("dates");
    //textarea_db_display_fields.addElement ("preferredterm");
     textarea_db_display_fields.addElement ("output");
  }
  list_name              = "f_contributor_id";
  list_db_field_id_name  = "contributorid";
  
  if (session.getAttribute("permissions").toString().contains("Contributor Editor") || session.getAttribute("permissions").toString().contains("Administrators")) {
  buttons_names.addElement   ("Add");
  buttons_names.addElement   ("Edit/View");
  //buttons_names.addElement   ("Preview");
  buttons_names.addElement   ("Delete");
  buttons_actions.addElement ("Javascript:location.href='contrib_addedit.jsp?act=add'");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=edit';search_form.submit();");
  //buttons_actions.addElement ("Javascript:search_form.action='contrib_preview.jsp';search_form.submit();");
  buttons_actions.addElement ("Javascript:search_form.action='contrib_del_confirm.jsp';search_form.submit();");
  }
	
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT contributor.`contributorid`, concat_ws(' ', contributor.first_name, contributor.last_name) name, "+
		"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))) dates, "+
		"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') preferredterm, "+
		"concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyyfirst_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
		"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
		"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
		"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
		"group by `contributor`.contributorid  ";
		//System.out.println(list_db_sql);
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   		
	list_db_sql = "SELECT contributor.`contributorid`,concat_ws(' ', contributor.first_name, contributor.last_name) name, "+
"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))) dates, "+
"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') preferredterm, "+
"concat_ws(', ',concat_ws(' ',contributor.first_name,contributor.last_name),if(min(events.yyyyfirst_date) = max(events.yyyyfirst_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyyfirst_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+ 
"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
"Where 1=1 ";	

    //System.out.println(list_db_sql);
    //handle the expansive search
    //String fNameHolder = db_ausstage.plSqlSafeString(filter_f_name.toLowerCase());
    //String lNameHolder = db_ausstage.plSqlSafeString(filter_l_name.toLowerCase());
    //String shortfNameHolder = fNameHolder; 
    //String shortlNameHolder = lNameHolder;
    //if (fNameHolder.length()>2){shortfNameHolder = fNameHolder.substring(0,2);}
    //if (lNameHolder.length()>2){shortlNameHolder = lNameHolder.substring(0,2);}

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and contributor.contributorid=" + filter_id + " ";

    if (!filter_f_name.equals ("")) {
      if (exactFirstName) {
        list_db_sql += "and LOWER(first_name) = '" + db_ausstage.plSqlSafeString(filter_f_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and LOWER(first_name) like '%" + db_ausstage.plSqlSafeString(filter_f_name.toLowerCase()) + "%' ";
      }
    }
      
    if (!filter_l_name.equals ("")) {
      if (exactLastName) {
        list_db_sql += "and LOWER(last_name) = '" + db_ausstage.plSqlSafeString(filter_l_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and lower(last_name) like '%" + db_ausstage.plSqlSafeString(filter_l_name.toLowerCase()) + "%' ";
      }
    }
      
    list_db_sql += "Group by contributor.contributorid order by " + request.getParameter ("f_order_by") + ", last_name" ;
    
    //list_db_sql += "Group by contributor.contributorid order by " 
		// first - John Smith
    //		+"CASE WHEN lower(first_name) LIKE '"+fNameHolder+"' "
    //		+	"AND lower(last_name) like '"+lNameHolder+"' THEN 1 ELSE 5 END, ";
    		
    		//then Jo% Smith
    //list_db_sql += "CASE WHEN lower(first_name) LIKE '" + shortfNameHolder + "%' "
    //		+	"AND lower(last_name) like '" + lNameHolder + "' then 2 ELSE 5 END, ";
		//then John Sm%
    //list_db_sql +="CASE WHEN lower(first_name) LIKE '" + fNameHolder + "' "
    //		+	"AND lower(last_name) like '" + shortlNameHolder + "%' then 3 ELSE 5 END, ";
		//then jo% sm%
    //list_db_sql +="CASE WHEN lower(first_name) LIKE '" + shortfNameHolder + "%' "
    //		+	"AND lower(last_name) like '" + shortlNameHolder + "%' then 4 ELSE 5 END, " ;
    //list_db_sql +=request.getParameter ("f_order_by");
  }

  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  //pageFormater.writeHelper(out, "Contributor Maintenance","helpers_no1.gif");
  //System.out.println(list_db_sql);
  list_db_sql = list_db_sql + " limit " + (MAX_RESULTS_RETURNED + 5) + ""; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  String cbxExactHTML = "<br><br>Exact First Name <input type='checkbox' name='exactFirstName' value='true'><br>Exact Last Name<input type='checkbox' name='exactLastName' value='true'>";
  out.println (htmlGenerator.displaySearchFilter (request, "Select Contributor",
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
                                        MAX_RESULTS_RETURNED,
                                        cbxExactHTML));
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%><script>
var exactFirstName = <%=exactFirstName%>;
var exactLastName = <%=exactLastName%>;
// reset both check boxes
if (exactFirstName) {
  search_form.exactFirstName.checked = false;
}

if (exactLastName) {
  search_form.exactLastName.checked = false;
}
</script>


<jsp:include page="../templates/admin-footer.jsp" />
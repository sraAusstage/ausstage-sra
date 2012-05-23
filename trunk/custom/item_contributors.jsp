<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, java.util.*"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.Contributor"%>
<%@ page import = "ausstage.ItemContribLink"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login     = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  String           sqlString;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement        stmt         = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
  int              MAX_RESULTS_RETURNED = 1000;

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);

  Vector filter_display_names            = new Vector ();
  Vector filter_names                    = new Vector ();
  Vector order_display_names             = new Vector ();
  Vector order_names                     = new Vector ();
  Vector textarea_db_display_fields      = new Vector ();
  Vector buttons_names                   = new Vector ();
  Vector buttons_actions                 = new Vector ();
  String list_name                       = "";
  String selected_db_sql                 = "";
  String list_db_sql                     = "";
  String list_db_field_id_name           = "";
  String selected_list_name              = "";
  String selected_list_db_sql            = "";
  String selected_list_db_field_id_name  = "";
  Vector selected_list_db_display_fields = new Vector ();
  String comeFromItemAddeditPage         = request.getParameter("f_from_item_add_edit_page");
  
  String creator       = request.getParameter("Creator");
  if(creator == null || creator =="")
    creator = request.getParameter("f_creator");
  

  String filter_id;
  String filter_first_name;
  String filter_last_name;
  String filter_box_selected;
  
  boolean exactFirstName = false;
  boolean exactLastName  = false;

  String contributorName;
  String contributorId;
  Contributor contributor, contrib;
  
  Hashtable hidden_fields = new Hashtable();

  Item item   = (Item)session.getAttribute("item");
  //we don't want to loose any info added to the item_addedit.jsp form.
  //only set the item attributes if we have come from the addedit page.
  if(comeFromItemAddeditPage != null && comeFromItemAddeditPage.equals("true"))
    item.setItemAttributes(request); 
  contributor = new Contributor(db_ausstage);
  boolean fromItemPage     = true;
  
  if (request.getParameter("fromItemPage") == null)
    fromItemPage = false;

  if (fromItemPage) item.setItemAttributes(request);

  String f_itemid = item.getItemId();
  int    itemId   = Integer.parseInt(f_itemid);
  hidden_fields.put("f_itemid", f_itemid);

  String f_select_this_contributor_id   = request.getParameter("f_select_this_contributor_id");
  String f_unselect_this_contributor_id = request.getParameter("f_unselect_this_contributor_id");
  String orderBy = request.getParameter ("f_order_by");
  //get me all the contributors from the current item
  //object in the session.
  Vector itemConLinks;
  if(creator.equals("FALSE"))
    itemConLinks = item.getAssociatedContributors();
  else
    itemConLinks = item.getAssociatedCreatorContributors();
  
  //add the selected contributor to the item
  


  
  
  
  if (f_select_this_contributor_id != null)
  {
    
    //need to add the contributor id to the item.
    if(creator.equals("FALSE")){
      ItemContribLink itemContribLink = new ItemContribLink(db_ausstage);
      itemContribLink.setItemId(item.getItemId());
      itemContribLink.setContribId(f_select_this_contributor_id);
      itemContribLink.setCreatorFlag("N");
      
      itemConLinks.add(itemContribLink);
      item.setItemConLinks(itemConLinks); 
    }
    else{
      ItemContribLink itemContribLink = new ItemContribLink(db_ausstage);
      itemContribLink.setItemId(item.getItemId());
      itemContribLink.setContribId(f_select_this_contributor_id);
      itemContribLink.setCreatorFlag("Y");
      
      itemConLinks.add(itemContribLink);
      item.setItemCreatorConLinks(itemConLinks);  
   }  
      
  }
  //remove contributor from the item
  if (f_unselect_this_contributor_id != null)
  { 
    //remove the contributor id from the item
    for(int i=0; i < itemConLinks.size(); i++) {
      ItemContribLink itemContribLink = (ItemContribLink)itemConLinks.elementAt(i);
      if (itemContribLink.getContribId().equals(f_unselect_this_contributor_id)) {
        itemConLinks.remove(i);
      }
    }
    
    if(creator.equals("FALSE"))
      item.setItemConLinks(itemConLinks); 
    else
      item.setItemCreatorConLinks(itemConLinks);  
  }
  

  
  

  // Get the form parameters that are used to create the SQL that determines what
  // will be displayed in the list box (as this page posts to itself
  // when a user performs a search)
  filter_box_selected = request.getParameter ("f_box_selected");
  filter_id           = request.getParameter ("f_id");
  filter_first_name   = request.getParameter ("f_first_name");
  filter_last_name    = request.getParameter ("f_last_name");

  filter_display_names.addElement ("ID");
  filter_display_names.addElement ("First Name");
  filter_display_names.addElement ("Last Name");
  filter_names.addElement ("f_id");
  filter_names.addElement ("f_first_name");
  filter_names.addElement ("f_last_name");
  
  if (request.getParameter ("exactFirstName") != null) {
    exactFirstName = true;
  }
  if (request.getParameter ("exactLastName") != null) {
    exactLastName = true;
  }

  order_display_names.addElement ("First Name");
  order_display_names.addElement ("Last Name");
  order_names.addElement ("first_name");
  order_names.addElement ("last_name");

  list_name             = "f_select_this_contributor_id";
  list_db_field_id_name = "contributorId";
  if (orderBy != null && orderBy.equals("last_name"))
  {
    //textarea_db_display_fields.addElement ("last_name");
   // textarea_db_display_fields.addElement ("first_name");
   // textarea_db_display_fields.addElement ("dates");
    //textarea_db_display_fields.addElement ("preferredterm");
    textarea_db_display_fields.addElement ("output");
  }
  else
  {
  //  textarea_db_display_fields.addElement ("first_name");
  //  textarea_db_display_fields.addElement ("last_name");
  //  textarea_db_display_fields.addElement ("dates");
  //  textarea_db_display_fields.addElement ("preferredterm");
  textarea_db_display_fields.addElement ("output");
  }
  
  selected_list_name             = "f_unselect_this_contributor_id";
  selected_list_db_field_id_name = "contributorId";
  if (orderBy != null && orderBy.equals("last_name"))
  {
    selected_list_db_display_fields.addElement ("last_name");
    selected_list_db_display_fields.addElement ("first_name");
  }
  else
  {
    selected_list_db_display_fields.addElement ("first_name");
    selected_list_db_display_fields.addElement ("last_name");
  }
  



  buttons_names.addElement ("Select");
  buttons_names.addElement ("Edit/View");
  buttons_names.addElement ("Add");
  buttons_names.addElement ("Finish");
  buttons_actions.addElement ("Javascript:search_form.action='item_contributors.jsp';search_form.submit();");

  if(creator.equals("TRUE")){
    buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=ForCreatorItem';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=ForCreatorItem';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='item_contrib_functions.jsp?Creator=TRUE';search_form.submit();");
  }
  else{
    buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=ForItem';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='contrib_addedit.jsp?act=ForItem';search_form.submit();");
    buttons_actions.addElement ("Javascript:search_form.action='item_contrib_functions.jsp?Creator=FALSE';search_form.submit();");
  }
  

  
  selected_db_sql = "";
  Vector selectedContributors = new Vector();
  Vector temp_vector          = new Vector();
  String temp_string          = "";    
  
  if(creator.equals("FALSE"))
    selectedContributors = item.getAssociatedContributors();
  else
    selectedContributors = item.getAssociatedCreatorContributors();
  
  //because the vector that gets returned contains only linked
  //contributor ids as strings we need to create a temp vector
  //for display method displaySearchFilterAndSelector as used below.
  //it expects a vector with a contributor id and the contributor name.
  //i.e. "4455, Luke Sullivan".

  //for each contributor id get name and add the id and the name to a temp vector.
  
 selected_db_sql       = "";
  for(int i = 0; i < selectedContributors.size(); i ++){
    ItemContribLink itemContribLink = (ItemContribLink)selectedContributors.elementAt(i);
    int temp = new Integer(itemContribLink.getContribId()).intValue();
    temp_string = contributor.getContributorInfoForItemDisplay(temp, stmt);
    temp_vector.add(temp + "" );//add the id to the temp vector.
    temp_vector.add(temp_string);//add the contributor name to the temp_vector.
    if (i > 0) selected_db_sql += ", ";
    selected_db_sql   += temp;
  }
  selectedContributors = temp_vector;
  stmt.close();
  
  // if first time this form has been loaded
  if (filter_id == null)
  {
    list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ', last_name, first_name, "+
		"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) , "+
		"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "+
		"concat_ws(', ',concat_ws(' ',contributor.last_name ,contributor.first_name),if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
		"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
		"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
		"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
		"group by `contributor`.contributorid";
  }
  else
  {
    // Not the first time this page has been loaded
    // i.e the user performed a search
   		
	list_db_sql = "SELECT contributor.`contributorid`,concat_ws(', ', last_name, first_name, "+
		"if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))) , "+
		"group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) preferredterm, "+
		"concat_ws(', ',concat_ws(' ',contributor.last_name ,contributor.first_name),if(min(events.yyyyfirst_date) = max(events.yyyylast_date),min(events.yyyyfirst_date),concat(min(events.yyyyfirst_date),' - ', max(events.yyyylast_date))),group_concat(distinct contributorfunctpreferred.preferredterm separator ', ')) as output "+
		"FROM contributor LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
		"LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
		"Left JOIN contributorfunctpreferred ON (conevlink.`function` = contributorfunctpreferred.contributorfunctpreferredid) "+
"Where 1=1 ";	

    // Add the filters to the SQL
    if (!filter_id.equals (""))
      list_db_sql += "and contributor.contributorid=" + filter_id + " ";

    if (!filter_first_name.equals ("")) {
      if (exactFirstName) {
        list_db_sql += "and LOWER(first_name) = '" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and LOWER(first_name) like '%" + db_ausstage.plSqlSafeString(filter_first_name.toLowerCase()) + "%' ";
      }
    }
      
    if (!filter_last_name.equals ("")) {
      if (exactLastName) {
        list_db_sql += "and LOWER(last_name) = '" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "' ";
      }
      else {
        list_db_sql += "and lower(last_name) like '%" + db_ausstage.plSqlSafeString(filter_last_name.toLowerCase()) + "%' ";
      }
    }
      
  
    list_db_sql += "Group by contributor.contributorid order by " + request.getParameter ("f_order_by");
  }

    
  // Need to do the following type of select of Oracle will not return the rows
  // in the correct order.
  list_db_sql += " limit " + (MAX_RESULTS_RETURNED + 5) + " "; // Make sure we are able to return more than what we can display so that we will know to display a waring to the user.

  String cbxExactHTML = "<br><br>Exact First Name <input type='checkbox' name='exactFirstName' value='true'><br>Exact Last Name<input type='checkbox' name='exactLastName' value='true'>";

  out.println (htmlGenerator.displaySearchFilterAndSelector (
                                     request,
                                     "Select Contributors",
                                     "Selected Contributors",
                                     filter_display_names,
                                     filter_names,
                                     order_display_names,
                                     order_names,
                                     list_name,
                                     list_db_sql,
                                     list_db_field_id_name,
                                     textarea_db_display_fields,
                                     selected_list_name,
                                     selectedContributors,
                                     selected_list_db_field_id_name,
                                     buttons_names,
                                     buttons_actions,
                                     hidden_fields,
                                     false,
                                     MAX_RESULTS_RETURNED,
                                    "<input type='hidden' name='f_creator' value='" + creator + "'>" + cbxExactHTML));

  session.setAttribute("item", item);

  
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeFooter(out);
%>
<script>
var exactFirstName = <%=exactFirstName%>;
var exactLastName = <%=exactLastName%>;

if (exactFirstName) {
  search_form.exactFirstName.checked = true;
}

if (exactLastName) {
  search_form.exactLastName.checked = true;
}
</script>
<cms:include property="template" element="foot" />
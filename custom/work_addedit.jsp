<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, admin.Common, java.util.*, org.opencms.jsp.*, org.opencms.file.*"%>
<%@ page import = " ausstage.Database, ausstage.Work,ausstage.WorkWorkLink, ausstage.WorkCountryLink, ausstage.Contributor, ausstage.RelationLookup"%>

<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin     login                = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater         = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database       db_ausstage          = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  //get the group names associated with this user. Existing Work records are to be locked unless user is able to edit works. 
  List <String> groupNames = new ArrayList();
  if (session.getAttribute("userName") != null) {
	CmsJspActionElement cms = new CmsJspActionElement(pageContext, request, response);
  	CmsObject cmsObject = cms.getCmsObject();
  	List <CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
  	for (CmsGroup group : userGroups) {
  		groupNames.add(group.getName());
  	}
  }
  
  Statement               stmt                 	= db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator        	= new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource     datasource           	= new ausstage.Datasource (db_ausstage);
  ausstage.Country	  country     		= new ausstage.Country(db_ausstage);

  Work		work 	= new Work(db_ausstage);
  Work          workObj = new Work(db_ausstage);
  String        workid  = request.getParameter("f_workid");
  
  Vector        temp_display_info;
  Vector        m_work_orglinks;
  Vector        m_work_conlinks;
  
  Vector<WorkWorkLink> work_link_vec = new Vector();
  Vector work_name_vec		= new Vector();
  String   work_title           = "";
  String   alter_work_title     = "0";
  String   dddate_first_known	= "";
  String   mmdate_first_known	= "";
  String   yyyydate_first_known	= "";
  Vector <WorkCountryLink>country_ids       	= new Vector();
  Vector   selectedItems 	= new Vector();
  String   action               = request.getParameter("action");

  if (action == null) action = "";

  int                     counter              = 0;
  ResultSet               rset;
  Common                  common               = new Common();
  Hashtable               hidden_fields        = new Hashtable();
  String                  currentUser_authId = session.getAttribute("authId").toString();
  
  String isPreviewForItemWork  = request.getParameter("isPreviewForItemWork");
  String isPreviewForEventWork  = request.getParameter("isPreviewForEventWork");
  String isPreviewForWorkWork  = request.getParameter("isPreviewForWorkWork");
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  if(workid == null) workid = "";
  // use a new Item object that is not from the session.
  if(action != null && action.equals("add")){
    action = "add";
    workid = "0";
  }
  else if(action != null && action.equals("ForItem")){
    workid = request.getParameter("f_select_this_work_id");
    if (workid != null && !workid.equals("") && !workid.equals("null") ) {  
      work.load(Integer.parseInt(workid));
    }
    else {
      workid = "0";
    }    
  }
  else if(action != null && action.equals("ForEvent")){
    workid = request.getParameter("f_select_this_work_id");
    if (workid != null && !workid.equals("") && !workid.equals("null") ) {  
      work.load(Integer.parseInt(workid));
    }
    else {
      workid = "0";
    }
  }
  else if (action != null && action.equals("edit")){ //editing existing Item
    if (workid == null) {
      workid = "";
    }
    if (workid != null && !workid.equals("") && !workid.equals("null")) {  
      work.load(Integer.parseInt(workid));
    }
  }
  else if (action != null && action.equals("copy")){
    work.load(workid);
  }
  else{ //use the item object from the session.
    work = (Work)session.getAttribute("work");
    workid  = work.getWorkId();
  }
  
  if (isPreviewForItemWork == null || isPreviewForItemWork.equals("null")) 
    isPreviewForItemWork = "";
  if(isPreviewForItemWork.equals("true") || (action != null && action.equals("ForItemForWork")))
    action = "ForItem";
  
  if (isPreviewForEventWork == null || isPreviewForEventWork.equals("null")) 
    isPreviewForEventWork = "";
  if(isPreviewForEventWork.equals("true") || (action != null && action.equals("ForEventForWork")) || (action != null && action.equals("isPreviewForEventWork")))
    action = "ForEvent";
  
  if (isPreviewForWorkWork == null || isPreviewForWorkWork.equals("null")) 
	  isPreviewForWorkWork = "";
	  if(isPreviewForWorkWork.equals("true") || (action != null && action.equals("ForWorkForWork")))
	    action = "ForWork";

  //now we'll have established if this is a new work or not. If it isn't new then make all fields disabled unless user is a work admin. 
  boolean canEditWorks = false;	
  String readonly = "readonly";
  String disabled = "disabled";
  
  if ((groupNames.contains("Works Editor") || groupNames.contains("Administrators")) || (workid.equals("0"))) {
  //if (groupNames.contains("Works Editor")  || (workid.equals("0"))) {
	canEditWorks = true;
	readonly = "";
	disabled = "";
  }


  // get the initial state of the object(s) associated with this work
  m_work_orglinks      = work.getAssociatedOrganisations();
  m_work_conlinks      = work.getAssociatedContributors();
  work_link_vec        = work.getWorkWorkLinks();
  country_ids	       = work.getAssociatedCountries();


  //**if(country_ids == null)   {country_ids = "";}
  
  Work workTemp 			= null;
  WorkWorkLink workWorkLink     = null;
  
  RelationLookup lc = new RelationLookup(db_ausstage);

	//Loop through the related works  
  for(int i=0; i < work_link_vec.size(); i++ ){
  	boolean isParent = true;
  	//check - if current objects work id != associated objects work id then it is not parent
  	if (!workid.equals(work_link_vec.get(i).getWorkId())) isParent = false;
  	
	workTemp = new Work(db_ausstage);
	//load work object depending on parent condition
	workTemp.load(Integer.parseInt((isParent) ? work_link_vec.get(i).getChildId() : work_link_vec.get(i).getWorkId()));
	  
	  if (work_link_vec.get(i).getRelationLookupId() != null) {
		lc.load(Integer.parseInt(work_link_vec.get(i).getRelationLookupId()));
		work_name_vec.add(workTemp.getWorkTitle() + " (" + ((isParent) ? lc.getParentRelation() : lc.getChildRelation()) + ")");
	  } else {
		work_name_vec.add(workTemp.getWorkTitle());
	  }
   }
 
  if (action != null && action.equals("ForItem") || isPreviewForItemWork.equals("true") || action.equals("isPreviewForItemWork")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForItemWork' value='true'>");
      out.println("<input type='hidden' name='ForItem' value='true'>");
      out.println("<input type='hidden' name='act' value='"+action+"'>");
  }
  else if (action != null && action.equals("ForWork") || isPreviewForWorkWork.equals("true")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForWorkWork' value='true'>");
      out.println("<input type='hidden' name='ForWork' value='true'>");
  }
  else if (action != null && action.equals("ForEvent") || isPreviewForEventWork.equals("true")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForEventWork' value='true'>");
      out.println("<input type='hidden' name='ForEvent' value='true'>");
  }
  else{
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp' method='post' onsubmit='return checkFields();'>"); 
  }
  
  out.println("<input type='hidden' name='f_workid' value='" + workid + "'>");
  out.println("<input type='hidden' name='f_from_work_add_edit_page' value='true'>");
  pageFormater.writeHelper(out, "General Information", "helpers_no1.gif");

  pageFormater.writeTwoColTableHeader(out, "ID");
  out.println(workid);
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Title *");
  out.println("<input type='text' name='f_work_title' size='65' class='line175' maxlength='60' value=\"" + work.getWorkTitle().replaceAll("\"", "&quot;") + "\" "+readonly+"> &nbsp;&nbsp;");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Alternative Title/s");
  out.println("<input type='text' name='f_alter_work_title' size='65' class='line350' maxlength='60' value=\"" + work.getAlterWorkTitle().replaceAll("\"", "&quot;") + "\" "+readonly+"> &nbsp;&nbsp;");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date First Known");
  out.println("<input type='text' name='f_dddate_first_known' size='2' class='line25' maxlength=2 value='" +
              work.getDdDateFirstKnown()+"' "+readonly+">");
  out.println("<input type='text' name='f_mmdate_first_known' size='2' class='line25' maxlength=2 value='" +
              work.getMmDateFirstKnown() + "' "+readonly+">");
  out.println("<input type='text' name='f_yyyydate_first_known' size='4' class='line35' maxlength=4 value='" +
              work.getYyyyDateFirstKnown() + "' "+readonly+">");
  pageFormater.writeTwoColTableFooter(out);
  /////////////////////////////////////
  // Country of Origin
  ////////////////////////////////////
  pageFormater.writeTwoColTableFooter (out);
  //if you can edit works
  if(canEditWorks){
    pageFormater.writeTwoColTableHeader (out, "Country Of Origin");
  
    rset = country.getCountries(stmt);
    if(rset.next()){   
      out.println("\t<select name='f_country_id' class='line200' size='6' "+disabled+">\n");
      do{
        String selected = "";
        
        if(country_ids.size() >0){
         
	    for (WorkCountryLink countryid : country_ids){//while(t_country_ids.hasMoreTokens())
            	if(countryid.getCountryId().equals(rset.getString("CountryId"))){//if(t_country_ids.nextToken().equals(rset.getString("CountryId")))
              		if(!selectedItems.contains(rset.getString("CountryId")))
                		selectedItems.addElement(rset.getString("CountryId"));   //adput(rset.getString("CONTFUNCTIONID"), rset.getString("CONTFUNCTION"));
              			break;
            	}
            }
        }
        
        out.println("\t\t<option value='"+ rset.getString("CountryId") +"'>" + rset.getString("COUNTRYNAME")+"</option>\n");
      }while(rset.next());
      out.println("\t</select>\n");  
    }else{
      out.println("\t<select name='f_country_id' class='line200' "+disabled+">\n");
      out.println("\t\t<option value=''>No Country found.</option>\n");
      out.println("\t</select>\n"); 
    }
    pageFormater.writeTwoColTableFooter (out); 
    pageFormater.writeTwoColTableHeader (out, "");
    
    out.println("\t<input type='button' value='Select' onclick=\"addtoSelected();\">\n");
    pageFormater.writeTwoColTableFooter (out); 
  }
    
    pageFormater.writeTwoColTableHeader (out, "Selected Country of Origin");
    out.println("\t<select name='f_country_ids' class='line200' size='6' "+disabled+">\n");
    ausstage.Country count = new ausstage.Country(db_ausstage);
    String country_ids_string = "";
    for (WorkCountryLink countryId : country_ids){
        count.load(Integer.parseInt(countryId.getCountryId()));
	country_ids_string += country_ids_string.equals("")? countryId.getCountryId():","+countryId.getCountryId();
        out.println("\t\t<option value='" + count.getId() + "'>" +   count.getName() +"</option>\n");     	
    }

    out.println("\t</select>\n"); 
    pageFormater.writeTwoColTableFooter (out); 
  %>
    <input type="hidden" name="delimited_country_ids" value="<%=country_ids_string%>">
    <%
  ///////////////////////////////////
  // Contributor Association(s)
  ///////////////////////////////////
  out.println("<a name='work_contributors_link'></a>");
  pageFormater.writeHelper(out, "Contributor Association(s)", "helpers_no2.gif");
  hidden_fields.clear();
  temp_display_info = work.generateBasicDisplayInfo(m_work_conlinks, "contributor", stmt);
  
  out.println (htmlGenerator.displayLinkedItem("",
                                               "2",
                                               "work_contributors.jsp",
                                               "work_addedit_form",
                                               hidden_fields,
                                               "Associated with Contributor(s):",
                                               temp_display_info,
                                               1000, 
                                               canEditWorks?false:true));

 
  ///////////////////////////////////
  // ORGANISATIONS Association(s)
  ///////////////////////////////////
  out.println("<a name='work_organisations_link'></a>");
  pageFormater.writeHelper(out, "Organisation Association(s)", "helpers_no3.gif");
  hidden_fields.clear();
  temp_display_info = work.generateDisplayInfo(m_work_orglinks, "organisation", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "3",
                                               "work_organisations.jsp",
                                               "work_addedit_form",
                                               hidden_fields,
                                               "Associated with Organisation(s):",
                                               temp_display_info,
                                               1000,
                                               canEditWorks?false:true));
   
  /***************************
  Work Association/s
  ****************************/	
  out.println("<a name='work_work'></a>");
  pageFormater.writeHelper(out, "Work Association/s", "helpers_no4.gif");
  hidden_fields.clear();

  out.println (htmlGenerator.displayLinkedItem("",
                                  "6",
                                  "work_work.jsp",
                                  "work_addedit_form",
                                  hidden_fields,
                                  "Associated with Work(s):",
                                  work_name_vec,
                                  1000,
                                  canEditWorks?false:true));
                                  
  
  /***************************
       Data Entry Information
  ****************************/
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no5.gif");
  pageFormater.writeTwoColTableHeader(out, "WorkID:");
  out.print(work.getWorkId());
  pageFormater.writeTwoColTableFooter(out);
  
  if (work.getEnteredByUser() != null && !work.getEnteredByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Created By User:");
    out.print(work.getEnteredByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Created:");
    out.print(common.formatDate(work.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  if (work.getUpdatedByUser() != null && !work.getUpdatedByUser().equals("")) {
    pageFormater.writeTwoColTableHeader(out, "Updated By User:");
    out.print(work.getUpdatedByUser());
    pageFormater.writeTwoColTableFooter(out);
    
    pageFormater.writeTwoColTableHeader(out, "Date Updated:");
    out.print(common.formatDate(work.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
    pageFormater.writeTwoColTableFooter(out);
  }
  
  out.print("<br><br><br><br>");
  pageFormater.writePageTableFooter (out);
  if(canEditWorks){
	  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  }
  else{
	  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif");
  }
  
  pageFormater.writeFooter(out);

  // reset/set the state of the work object
  session.setAttribute("work",work);
%>

</form>

<script language="javascript">
<!--
  function addtoSelected(){
    var f_list      = document.getElementById('work_addedit_form').f_country_id;
    var f_sel_list  = document.getElementById('work_addedit_form').f_country_ids;
    var index       = f_list.selectedIndex;
    var sel_index   = f_sel_list.selectedIndex;
    var selected_id;
    var selected_name;
    var i = 0;
    var selected_ids = '';
    var found = false;
console.log('1');
    if((index > -1 && sel_index == -1) || (index == -1 && sel_index > -1)){

      if(index > -1){                                                       
        // repository list is selected, so put it to the selected list
        selected_id   = f_list.options[index].value;
        selected_name = f_list.options[index].text;
console.log('2');
        if(f_sel_list.options.length != 0){
        console.log('3');
          for(i= 0 ; i < f_sel_list.options.length; i++){
          console.log('4');
            if(f_sel_list.options[i].value == selected_id){
              found = true;
              break;
            }
          }
        }
        console.log('5');
        if(!found){
          //selected_name = selected_name.substring(selected_name.indexOf(', ') + 2, selected_name.length);
          console.log('6');
          if(selected_name != ""){
          
            if(f_sel_list.options.length != 0){
            console.log('7');
              f_sel_list.options[f_sel_list.options.length] = new Option(selected_name, selected_id, false, false); // add to selected list
            }else{
              f_sel_list.options[0] = new Option(selected_name, selected_id); // add to selected list
              console.log('8');
            }
          }
        }
      }else{
        // remove from the selected list
        f_sel_list.options[sel_index] = null; 
      }
    }else{
      alert("You have not selected a Country to Add/Remove.");
    }
    
    f_list.selectedIndex     = -1;
    f_sel_list.selectedIndex = -1;
    var i =0;
    var temp_ids = '';
    var seleted_list = document.getElementById('work_addedit_form').f_country_ids;
    for(i= 0; i < seleted_list.options.length; i++){
      if(temp_ids == '')
        temp_ids = seleted_list.options[i].value;
      else
        temp_ids += "," + seleted_list.options[i].value;
    }
    document.getElementById('work_addedit_form').delimited_country_ids.value = temp_ids;
  }


  function checkCharacterDates()
  {

    var ret_val = true;
    fieldName = "Date First Known";
    day   = document.work_addedit_form.f_dddate_first_known.value;
    month = document.work_addedit_form.f_mmdate_first_known.value;
    year  = document.work_addedit_form.f_yyyydate_first_known.value;


    if (!checkDate(fieldName, day, month, year))
      return(false);
    return(ret_val);
  }

  function checkDate(fieldName, day, month, year)
  {
    errorMessage = "Error in " + fieldName + " field. ";

    if (day == "  " || day == " ")
      day = "";
    if (month == "  " || month == " ")
      month = "";
    if (year == "  " || year == " ")
      year = "";
    
   if(day != "" && month == "")
    {
      alert(errorMessage + "If month is blank then day must be blank.");
      return false;
    }

    if(month != "" && year == "")
    {
      alert(errorMessage + "If year is blank then month must be blank.");
      return false;
    }
    
    if(month != "")
    {
      if (!isInteger (month))
        return false;
        
      if (month > 12 || month < 0)
      {
        alert(errorMessage + "Not a valid month.");
        return false;
      }
    }
   
     if(year != "")
    {

      if (!isInteger (year))
        return false;
        
      if (year > 3000 || year < 1300)
      {
        alert(errorMessage + "Not a valid year.");
        return false;
      }
    }
    
    if(day != "")
    {
      if (!checkValidDate(day, month, year))
      {
        alert(errorMessage + "Not a valid date. ");
        return false;
      }
      else
        return true;
    }
    return true;
  }

  function checkMandatoryFields(){
    
    if(document.work_addedit_form.f_work_title.value == null ||
       document.work_addedit_form.f_work_title.value== "" ){     
      alert("Please make sure all mandatory fields (*) are filled in");
      return false;
    }
    return true 

  }

  function checkFields(){
  	if (checkCharacterDates() && checkMandatoryFields()){
  		return true;
  	}
	else return false;
  }

  
  
 
//-->
</script>
<%
stmt.close();
db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
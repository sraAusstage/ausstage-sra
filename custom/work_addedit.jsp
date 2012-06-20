<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, admin.Common, java.util.*"%>
<%@ page import = " ausstage.Database, ausstage.Work,ausstage.WorkWorkLink, ausstage.Contributor, ausstage.LookupCode"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin     login                = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater         = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage          = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement               stmt                 = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator        = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource     datasource           = new ausstage.Datasource (db_ausstage);
  Work                    work                 = new Work(db_ausstage);
  Work             workObj                  = new Work(db_ausstage);
  String                  workid               = request.getParameter("f_workid");
  Vector                  temp_display_info;
  Vector                  m_work_orglinks;
  Vector                  m_work_conlinks;
  Vector<WorkWorkLink> work_link_vec = new Vector();
  Vector work_name_vec				 = new Vector();
  String                  work_title           = "";
  String                  alter_work_title     = "0";
  String                  action               = request.getParameter("action");
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
  if(isPreviewForEventWork.equals("true") || (action != null && action.equals("ForEventForWork")))
    action = "ForEvent";
  
  if (isPreviewForWorkWork == null || isPreviewForWorkWork.equals("null")) 
	  isPreviewForWorkWork = "";
	  if(isPreviewForWorkWork.equals("true") || (action != null && action.equals("ForWorkForWork")))
	    action = "ForWork";

  // get the initial state of the object(s) associated with this work
  m_work_orglinks      = work.getAssociatedOrganisations();
  m_work_conlinks      = work.getAssociatedContributors();
  work_link_vec        = work.getWorkWorkLinks();
  
  Work workTemp 			= null;
  WorkWorkLink workWorkLink     = null;

  for(int i=0; i < work_link_vec.size(); i++ ){
	  workTemp = new Work(db_ausstage);
	  workTemp.load(Integer.parseInt(work_link_vec.get(i).getChildId()));
	      
	  work_name_vec.add(workTemp.getWorkInfoForDisplay(Integer.parseInt(workTemp.getWorkId()), stmt));	
   }
 
  if (action != null && action.equals("ForItem") || isPreviewForItemWork.equals("true")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkMandatoryFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForItemWork' value='true'>");
      out.println("<input type='hidden' name='ForItem' value='true'>");
  }
  else if (action != null && action.equals("ForWork") || isPreviewForWorkWork.equals("true")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkMandatoryFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForWorkWork' value='true'>");
      out.println("<input type='hidden' name='ForWork' value='true'>");
  }
  else if (action != null && action.equals("ForEvent") || isPreviewForEventWork.equals("true")){
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp?action=" + action +  "' method='post' onsubmit='return checkMandatoryFields();'>\n");
      out.println("<input type='hidden' name='isPreviewForEventWork' value='true'>");
      out.println("<input type='hidden' name='ForEvent' value='true'>");
  }
  else{
      out.println("<form name='work_addedit_form' id='work_addedit_form' action='work_addedit_process.jsp' method='post' onsubmit='return checkMandatoryFields();'>"); 
  }
  
  out.println("<input type='hidden' name='f_workid' value='" + workid + "'>");
  out.println("<input type='hidden' name='f_from_work_add_edit_page' value='true'>");
  pageFormater.writeHelper(out, "General Information", "helpers_no1.gif");

  pageFormater.writeTwoColTableHeader(out, "ID");
  out.println(workid);
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Title *");
  out.println("<input type='text' name='f_work_title' size='65' class='line175' maxlength='60' value=\"" + work.getWorkTitle().replaceAll("\"", "&quot;") + "\"> &nbsp;&nbsp;");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Alternative Title/s");
  out.println("<input type='text' name='f_alter_work_title' size='65' class='line350' maxlength='60' value=\"" + work.getAlterWorkTitle().replaceAll("\"", "&quot;") + "\"> &nbsp;&nbsp;");
  pageFormater.writeTwoColTableFooter(out);

 
  ///////////////////////////////////
  // Contributor Association(s)
  ///////////////////////////////////
  out.println("<a name='work_contributors_link'></a>");
  pageFormater.writeHelper(out, "Contributor Association(s)", "helpers_no2.gif");
  hidden_fields.clear();
  temp_display_info = work.generateDisplayInfo(m_work_conlinks, "contributor", stmt);
  
  out.println (htmlGenerator.displayLinkedItem("",
                                               "2",
                                               "work_contributors.jsp",
                                               "work_addedit_form",
                                               hidden_fields,
                                               "Associated with Contributor(s):",
                                               temp_display_info,
                                               1000));

 
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
                                               1000));
   
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
                                  1000));
                                  
  
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
  pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);

  // reset/set the state of the work object
  session.setAttribute("work",work);
%>

</form>
<script language="javascript">
<!--

  function checkMandatoryFields(){
    if(document.work_addedit_form.f_work_title.value == null ||
       document.work_addedit_form.f_work_title.value== "" ){     
      alert("Please make sure all mandatory fields (*) are filled in");
      return false;
    }
    return true 

  }
 
//-->
</script>
<%
stmt.close();
db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
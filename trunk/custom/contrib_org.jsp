<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.*"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%  
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  String contrib_id = request.getParameter("f_contrib_id");
  String isPreviewForEvent = request.getParameter("isPreviewForEvent");
  String isPreviewForItem  = request.getParameter("isPreviewForItem");
  String isPreviewForCreatorItem  = request.getParameter("isPreviewForCreatorItem");
  String isPreviewForWork  = request.getParameter("isPreviewForWork");

  CachedRowSet  rset;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.Organisation  organisation  = new ausstage.Organisation (db_ausstage);

  // get the CONTRIBUTOR object from session
  ausstage.Contributor contributor;
  
  if (isPreviewForEvent == null || isPreviewForEvent.equals("null")) {
    isPreviewForEvent = "";
  }
  if (isPreviewForCreatorItem == null || isPreviewForCreatorItem.equals("null")) {
    isPreviewForCreatorItem = "";
  }
  if (isPreviewForItem == null || isPreviewForItem.equals("null")) {
    isPreviewForItem = "";
  }
  if (isPreviewForWork == null || isPreviewForWork.equals("null")) {
    isPreviewForWork = "";
  }
  
  
  if (session.getAttribute("contributor") == null) {
    contributor = new ausstage.Contributor(db_ausstage);
  }
  else {
    contributor = (ausstage.Contributor) session.getAttribute("contributor");
  }
  contributor.setContributorAttributes(request);

  // reset/set the state of the CONTRIBUTOR object
  session.setAttribute("contributor",contributor);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Select Educational Organisation(s)", AusstageCommon.ausstage_main_page_link);


%>
  <form action='contrib_org_link.jsp' name='content_form' id='content_form' method='post' onsubmit="finalise();">
    <input type="hidden" name="isPreviewForItem" value="<%=isPreviewForItem%>">
    <input type="hidden" name="isPreviewForCreatorItem" value="<%=isPreviewForCreatorItem%>">
    <input type="hidden" name="isPreviewForEvent" value="<%=isPreviewForEvent%>">
    <input type="hidden" name="isPreviewForWork" value="<%=isPreviewForWork%>">
    <input type="hidden" name="f_contrib_id" value="<%=request.getParameter("f_contrib_id")%>">
<%
  rset = organisation.getOrganisations (stmt, AusstageCommon.EDUCATIONAL_INSTITUTION_ID);
  if (rset.next())
  {
%>
    <p class="bodyhead">Select Organisation</p> 
    <select name='f_id_list' class='line300' size='15'><%
    // We have at least one Organisation
    do
    {
%>
      <option value='<%=rset.getString ("ORGANISATIONID")%>'><%=rset.getString ("NAME")%></option>
<%
    }
    while (rset.next ());

%>
    </select>
<%
  }
  out.println("<br><br><input type='button' value='Select' onclick=\"addtoSelected();\"><br><br>");
  out.println("Selected Educational Organisation");
  out.println("<br><br><select name='f_id' class='line300' size='10' multiple>\n");
  Vector conOrgLinks = contributor.getConOrgLinks();
  for(int x=0; x < conOrgLinks.size(); x++){
    organisation = new Organisation(db_ausstage);
    organisation.load(Integer.parseInt(((ConOrgLink)conOrgLinks.elementAt(x)).getOrganisationId()));
    
%>
  <option value='<%=organisation.getId()%>'><%=organisation.getName()%></option>
<%
  }
  
  out.println("\t</select>\n"); 
  
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif");
  pageFormater.writeFooter(out);
%>
  </form>
  <script language="javascript"><!--
  
    function finalise(){
      var f_sel_list  = window.document.content_form.f_id;
      var i;
      for(i =0; i < f_sel_list.length; i++)
        f_sel_list.options[i].selected = true;
        
      window.document.content_form.submit();
    }
    
    function addtoSelected(){
      var f_list      = window.document.content_form.f_id_list;
      var f_sel_list  = window.document.content_form.f_id;
      
      var index       = f_list.selectedIndex;
      var sel_index   = f_sel_list.selectedIndex;
      var selected_id;
      var selected_name;
      var i = 0;
      //var found = false;
    
      if((index > -1 && sel_index == -1) || (index == -1 && sel_index > -1)){

        if(index > -1){                                                       
          // repository list is selected, so put it to the selected list
          selected_id   = f_list.options[index].value;
          selected_name = f_list.options[index].text;
         
          if(selected_name != ""){
            if(f_sel_list.options.length != 0){
              f_sel_list.options[f_sel_list.options.length] = new Option(selected_name, selected_id, false, false); // add to selected list
            }else{
              f_sel_list.options[0] = new Option(selected_name, selected_id); // add to selected list
            }
          }
        }else{
          // remove from the selected list
          f_sel_list.options[sel_index] = null; 
        }
      }else{
        alert("You have not selected an Organisation to Add/Remove.");
      }
      f_list.selectedIndex     = -1;
      f_sel_list.selectedIndex = -1;
    }
  //--></script>
<cms:include property="template" element="foot" />
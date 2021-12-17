<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*, ausstage.Datasource"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.*"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Contributor Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  String delimeted_organisations_ids = "";
  String[] organisation_ids         = request.getParameterValues("f_id");
  String contributorId              = request.getParameter("f_contrib_id");
  String isPreviewForEvent = request.getParameter("isPreviewForEvent");
  String isPreviewForItem  = request.getParameter("isPreviewForItem");
  String isPreviewForCreatorItem  = request.getParameter("isPreviewForCreatorItem");
  String isPreviewForWork  = request.getParameter("isPreviewForWork");
  
  String action  = request.getParameter("act");
  
  
  if (isPreviewForEvent == null || isPreviewForEvent.equals("null")) {
    isPreviewForEvent = "";
  }
  if (isPreviewForItem == null || isPreviewForItem.equals("null")) {
    isPreviewForItem = "";
  }
  if (isPreviewForCreatorItem == null || isPreviewForCreatorItem.equals("null")) {
    isPreviewForCreatorItem = "";
  }
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Select Organisation(s)", AusstageCommon.ausstage_main_page_link);
  %>
  <form action='contrib_org_link_process.jsp' name='content_form' id='content_form' method='post'>
  <input type="hidden" name="isPreviewForEvent" value="<%=isPreviewForEvent%>">
  <input type="hidden" name="isPreviewForItem" value="<%=isPreviewForItem%>">
  <input type="hidden" name="isPreviewForCreatorItem" value="<%=isPreviewForCreatorItem%>">
  <input type="hidden" name="isPreviewForWork" value="<%=isPreviewForWork%>">
  <input type="hidden" name="f_contrib_id" value="<%=request.getParameter("f_contrib_id")%>">
  <input type="hidden" name="act" value="<%=action%>">
  <%
  // get the CONTRIBUTOR object from session
  ausstage.Contributor contributor = (ausstage.Contributor) session.getAttribute("contributor");
  if(organisation_ids != null && !organisation_ids.equals("")){

    Vector newConOrgLinks      = new Vector();
    Vector originalConOrgLinks;
    
    
    // We need to display the contrib org links. The user may have left the existing
    // links, in this case we must go to the database and load these up to display
    // the description.
    // Any new links must also be displayed.

    originalConOrgLinks = contributor.getConOrgLinks();
    // store the selected ones from the previous page's list
    String orgcontriblinkids = "";
    for(int i= 0; i < organisation_ids.length; i++){
      ConOrgLink conOrgLink = new ConOrgLink(db_ausstage); 
      conOrgLink.setContributorId(contributorId);
      conOrgLink.setOrganisationId(organisation_ids[i]);
      
      // See if we can match it in the original ConOrgLinks list
      for (int j= 0; j < originalConOrgLinks.size(); j++) {
        if (((ConOrgLink)originalConOrgLinks.elementAt(j)).getOrganisationId().equals(organisation_ids[i])) {
          conOrgLink.setDescription(((ConOrgLink)originalConOrgLinks.elementAt(j)).getDescription());
          break;
        }
        else {
          conOrgLink.setDescription("");
        }
      }
      newConOrgLinks.addElement(conOrgLink);
    }

    // set the vector Organisations CONTRIBUTOR member
    contributor.setConOrgLinks(newConOrgLinks);
    session.setAttribute("contributor",contributor);%>
    
    <table cellspacing='0' cellpadding='0' border='0'>
      <tr>
        <th class="bodytext" >Selected Educational Organisation</th>
        <th width="20">&nbsp;</th>
        <th class="bodytext" >Description</th>
        <th width="5">&nbsp;</th>
        </tr><%
        
    // We have at least one datasource
    for(int i= 0; i < newConOrgLinks.size(); i++){
      ConOrgLink   conOrgLink   = (ConOrgLink) newConOrgLinks.elementAt(i);
      Organisation organisation = new Organisation(db_ausstage);
      organisation.load(Integer.parseInt(conOrgLink.getOrganisationId())); %>
    <tr>
      <td class="bodytext"><%=organisation.getName()%></td>
      <td width="20">&nbsp;</td>
      <td class="bodytext" ><input type='text' name="f_organisation_desc_<%=i%>" size='50' maxlength='100' value="<%=conOrgLink.getDescription()%>"></td>
      <td width="1">&nbsp;</td>
    </tr><%
    
      // build the organisations ids
      if(delimeted_organisations_ids.equals(""))
        delimeted_organisations_ids = Integer.toString(organisation.getId());
      else
        delimeted_organisations_ids += "," + Integer.toString(organisation.getId());
    } %>
    </table><%

    db_ausstage.disconnectDatabase();
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif"); 
  }else{
    out.println("You have chosen not to selected any Organisations.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif");
    contributor.clearConOrgLinks();
  }
  pageFormater.writeFooter(out);
  %>
  <input type="hidden" name="f_delimeted_organisations_ids" value="<%=delimeted_organisations_ids%>">
  </form>

<jsp:include page="../templates/admin-footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import= "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*"%>
<%@ page import= "ausstage.OrganisationOrganisationLink, ausstage.Organisation"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Organisation Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  Organisation   organisationObj       = (Organisation)session.getAttribute("organisationObj");
  //String organisationId        =request.getParameter("f_organisation_id");
  String organisationId        = Integer.toString(organisationObj.getId());
  Vector<OrganisationOrganisationLink> organisationOrganisationLinks = organisationObj.getOrganisationOrganisationLinks();
  Vector<OrganisationOrganisationLink> tempOrganisationOrganisationLinks = new Vector<OrganisationOrganisationLink>();
  String error_msg   		= "";
  String relationLookupId 	= "";
  String notes        		= "";
  String childNotes        	= "";
  String linkOrganisationId  	= "";
  String isParent		= "";
  String action = request.getParameter("act");
  if (action == null ) {action = "";}

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);


  try {
	for(int i=0; i < organisationOrganisationLinks.size(); i++) {
        	
        	OrganisationOrganisationLink orgOrgLink = new OrganisationOrganisationLink(db_ausstage);
		// get data from the request object
	        
	        linkOrganisationId = request.getParameter("f_link_org_id_" + i);    
	        notes       = request.getParameter("f_notes_" + i);
	        childNotes  = request.getParameter("f_child_notes_" + i);      

		//get the relation lookup id and the perspective (ie parent or child) 
		String [] lookupAndPerspective = request.getParameter("f_relation_lookup_id_" + i).split("_", 2);
		relationLookupId = lookupAndPerspective[0];
		isParent = lookupAndPerspective[1];
		
		if(isParent.equals("parent")){
		        orgOrgLink.setChildId(linkOrganisationId);
		        orgOrgLink.setOrganisationId(organisationId);
	        	orgOrgLink.setNotes(notes);
	        	orgOrgLink.setChildNotes(childNotes);
		} else {
		        orgOrgLink.setChildId(organisationId);
		        orgOrgLink.setOrganisationId(linkOrganisationId);
	        	orgOrgLink.setNotes(childNotes);
	        	orgOrgLink.setChildNotes(notes);
		}
	

	        orgOrgLink.setRelationLookupId(relationLookupId);
	        
	        tempOrganisationOrganisationLinks.insertElementAt(orgOrgLink, i);
    	}
  }
  catch(Exception e) {
    error_msg = "Error: Organisation to organisation links process NOT successful.";
  }

  if(error_msg.equals("")) {
		organisationObj.setOrgOrgLinks(tempOrganisationOrganisationLinks);
		session.setAttribute("organisationObj", organisationObj);
     pageFormater.writeText(out, "Organisation to organisation process successful.");
  }
  else {
     pageFormater.writeText(out, error_msg);
  }

  pageFormater.writePageTableFooter (out);
//  pageFormater.writeButtons (out, "", "", "", "", "organisation_addedit.jsp?act="+action+"&isReturn=true#organisation_organisation_link", "next.gif");
  pageFormater.writeButtons (out, "", "", "", "", "organisation_addedit.jsp?act="+action+"&isReturn=true", "next.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><jsp:include page="../templates/admin-footer.jsp" />
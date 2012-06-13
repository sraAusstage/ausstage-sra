<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page session="true" import="org.opencms.main.*, org.opencms.jsp.*,org.opencms.file.*, java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
  <tr>
    <td>
      <table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
	<tr>
          <td bgcolor="#FFFFFF">



<%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
	
	List<String> groupNames = new ArrayList();	
	if (session.getAttribute("userName")!= null) {
		CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
		CmsObject cmsObject = cms.getCmsObject();
		List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
		for(CmsGroup group:userGroups) {
		   	groupNames.add(group.getName());
			}
	}
	

  db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  CachedRowSet crset          = null;
  ResultSet    rset;
  Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
  String formatted_date       = "";
  String item_id              = request.getParameter("id");
  String location             = "";
  Vector item_evlinks;
  Vector item_orglinks;
  Vector item_creator_orglinks;
  Vector item_venuelinks;
  Vector item_conlinks;
  Vector work_conlinks;
  Vector item_creator_conlinks;
  Vector item_artlinks;
  Vector item_secgenrelinks;
  Vector item_worklinks;
  Vector item_itemlinks;
  Vector item_contentindlinks;

  State state = new State(db_ausstage_for_drill);
  Event event = null;
  
  DescriptionSource descriptionSource;
  Datasource datasource;
  Datasource datasourceEvlink;

  Venue venue = null;
  PrimaryGenre primarygenre;
  SecGenreEvLink secGenreEvLink;
  Country country;
  PrimContentIndicatorEvLink primContentIndicatorEvLink;
  OrgEvLink orgEvLink;
  Organisation organisation;
  Organisation organisationCreator = null;
  ConEvLink conEvLink;
  Contributor contributor = null;
  Contributor contributorCreator = null;
  Item item;
  LookupCode item_type = null;
  LookupCode item_sub_type = null;
  LookupCode language;
  SecondaryGenre secondaryGenre = null;
  Work work = null;
  Item assocItem = null;
  ContentIndicator contentIndicator = null; 
  
  SimpleDateFormat formatPattern = new SimpleDateFormat("dd/MM/yyyy");
  
  // Table settings for main result display
  String baseTableWdth = "100%";
  String baseCol1Wdth  = "200";  // Headings
  String baseCol2Wdth  = "8";   // Spacer
  String baseCol3Wdth  = "";  // Details for Heading
  // Table settings for secondary table required under a heading in the main result display
  String secTableWdth = "100%";
  String secCol1Wdth  = "30%";
  String secCol2Wdth  = "70%";
  boolean displayUpdateForm = true;
  admin.Common Common = new admin.Common();  



    ///////////////////////////////////
    //    DISPLAY RESOURCE DETAILS
    //////////////////////////////////
    item = new Item(db_ausstage_for_drill);
    int x = Integer.parseInt(item_id);
    item.load(x);
    
    //load up the item type for the item
    if (item.getItemType() != null) {
      item_type = new LookupCode(db_ausstage_for_drill);
      item_type.load(Integer.parseInt("0" + item.getItemType()));
    }
    
    // load the item sub type
    if (item.getItemSubType() != null) {
      item_sub_type = new LookupCode(db_ausstage_for_drill);
      item_sub_type.load(Integer.parseInt("0" + item.getItemSubType()));
    }
        
    if (displayUpdateForm) {
      displayUpdateForm(item_id, "Resource", item.getTitle(),
                        out,
                        request,
                        
                        ausstage_search_appconstants_for_drill);
    }
    // get me all the item associations
    // events
    item_evlinks    = item.getAssociatedEvents();
    // not creator organisations
    item_orglinks   = item.getAssociatedOrganisations();
    // creator organisations
    item_creator_orglinks   = item.getAssociatedCreatorOrganisations();
    // venues
    item_venuelinks = item.getAssociatedVenues();
    // not creator contributors
    item_conlinks   = item.getAssociatedContributors();
    // creator contributors
    item_creator_conlinks   = item.getAssociatedCreatorContributors();
    // genre
    item_secgenrelinks      = item.getAssociatedSecGenres();
    // work
    item_worklinks  = item.getAssociatedWorks();
    item_itemlinks  = item.getAssociatedItems();
    // content indicator
    item_contentindlinks = item.getAssociatedContentIndicators();
    
    //load up all the associated object if there are any.
    // i.e check the siz of the vector
    if(item_evlinks.size() > 0){event = new Event(db_ausstage_for_drill);}
    if(item_orglinks.size() > 0){organisation = new Organisation(db_ausstage_for_drill);}
    if(item_creator_orglinks.size() > 0){organisationCreator = new Organisation(db_ausstage_for_drill);}
    if(item_orglinks.size() > 0){organisation = new Organisation(db_ausstage_for_drill);}
    if(item_venuelinks.size() > 0){venue = new Venue(db_ausstage_for_drill);}
    if(item_conlinks.size() > 0){contributor = new Contributor(db_ausstage_for_drill);}
    if(item_creator_conlinks.size() > 0){contributorCreator = new Contributor(db_ausstage_for_drill);}
    if(item_secgenrelinks.size() > 0){secondaryGenre = new SecondaryGenre(db_ausstage_for_drill);}
    if(item_worklinks.size() > 0){work = new Work(db_ausstage_for_drill);}
    if(item_contentindlinks.size() > 0){contentIndicator = new ContentIndicator(db_ausstage_for_drill);}
    
    if(item_itemlinks.size() > 0){assocItem = new Item(db_ausstage_for_drill);}
    

    
    // load the language
    language = new LookupCode(db_ausstage_for_drill);
    if (!item.getItemLanguage().equals("")) {
      language.load(Integer.parseInt(item.getItemLanguage()));
    } 
    
    organisation = new Organisation(db_ausstage_for_drill);

    if (!item.getInstitutionId().equals("")) {
      organisation.load(Integer.parseInt(item.getInstitutionId()));
    }
    if (groupNames.contains("Administrators") || groupNames.contains("Resource Editor"))
			out.println("<a class='editLink' target='_blank' href='/custom/item_addedit.jsp?action=edit&f_itemid=" + item.getItemId() + "'>Edit</a>");

    out.println("<table align=\"center\" width=\'98%' border=\"0\" cellpadding=\"3\" cellspacing=\"0\">");

    //Resource Sub Type (Label is Resouce Type)
    if (item_type != null) {
	    out.println("<tr>");
	    out.println("  <td width='25%' align='right'  class='general_heading_light f-186' valign=\"top\">Type</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.print  ("  <td width='75%'  class='general_body' valign=\"top\">");
	    out.print  ("  " + item_type.getShortCode());
	    if (item_sub_type != null) {
	      out.print  (": " + item_sub_type.getShortCode());
	    }
	    out.println("  </td>");
	    out.println("</tr>");
    }
    
    //Title
    if (item.getTitle() != null && !item.getTitle().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Title</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\"><b>" + item.getTitle() + "</b></td>");
	    out.println("</tr>");   
    }
    
    //Alternative Title
    if (item.getTitleAlternative() != null && !item.getTitleAlternative().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Alternative Title</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">" + item.getTitleAlternative() + "</td>");
	    out.println("</tr>");   
    }
     // Creator Contributor
    out.println("<tr>");
    int itemCCCounter=0;
    
    if(contributorCreator != null){
      for(int i = 0; i < item_creator_conlinks.size(); i ++){
    	  if(itemCCCounter==0){
    		  out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Creator Contributors</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("    <table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		  itemCCCounter++;
    	  }
          String name = "";
          String contribId;
          String functionId;
          String functionDesc = "";
          LookupCode lookups = new LookupCode(db_ausstage_for_drill);

          contribId  = ((ItemContribLink)item_creator_conlinks.elementAt(i)).getContribId();

          // use the contribId to load a new contributor each time:
          contributorCreator.load(new Integer(contribId).intValue());
          contribId = "" + contributorCreator.getId();
          name = contributorCreator.getName() + " " + contributorCreator.getLastName();
          
          out.print("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/contributor/?id=" +
                     contribId + "\">" +
                     name + "</a>");
          if (contributorCreator.getContFunctPreffTermByContributor(contribId) != null && !contributorCreator.getContFunctPreffTermByContributor(contribId).equals("")) 
        	  out.print(", " +  contributorCreator.getContFunctPreffTermByContributor(contribId));
          
          out.print("</td></tr>");

      }
    }if(itemCCCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
    // Creator Organisation
    out.println("<tr>");
    int creatorOrgCounter=0;
    
    if(organisationCreator != null){
      // this link is wierd the Item Org Link is in the Vector
      for(int i = 0; i < item_creator_orglinks.size(); i ++){
    	  if(creatorOrgCounter==0){
    		  out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Creator Organisations</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  class='general_body' valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    creatorOrgCounter++;
    	  }
        String orgaId = ((ItemOrganLink)item_creator_orglinks.elementAt(i)).getOrganisationId();        
        // use the orgaId to load a new organisation each time:
        organisationCreator.load(new Integer(orgaId).intValue());
        
        out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/organisation/?id=" +
                   organisationCreator.getId() + "\">" +
                   organisationCreator.getName() + "</a></td>");
        out.println("</tr>");       
      }
    }
		if(creatorOrgCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
    //Abstract/Description
    if (item.getDescriptionAbstract() != null && !item.getDescriptionAbstract().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Abstract/Description</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td width=\"" + baseCol3Wdth + "\"  valign=\"top\">" + item.getDescriptionAbstract() + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("</td>");
	    out.println("</tr>");
    }

    //  SECONDARY GENRE //    
    
    int itemSGCounter=0;
    out.println("<tr>");   
    if(secondaryGenre != null){
      // 
      for (int i=0; i < item_secgenrelinks.size(); i++){
    	  if(itemSGCounter==0){
    		  out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Genre</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  class='general_body' valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemSGCounter++;
    	  }
        String secGenreId = (String) item_secgenrelinks.elementAt(i);
        // use the secondary genre Id to load a new secondary genre each time:
        secondaryGenre.loadLinkedProperties(new Integer(secGenreId).intValue());       
        out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/genre/?id=" +
        					secondaryGenre.getId()+ "\">" +
                   secondaryGenre.getName() + "</td>");
        out.println("</tr>");       
      }
    }
		if(itemSGCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
    // Content Indicator
    int itemCICounter=0;
    out.println("<tr>");
  
    if(contentIndicator != null){
      // in the item_contentindlinks vector we only have the content indicator id 
      // to get the content indicator name -> load a content indicator object
      for(int i = 0; i < item_contentindlinks.size(); i ++){
    	  if(itemCICounter==0){
    		  out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Subjects</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  class='general_body' valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemCICounter++;
    	  }
        // get content ind id
        String contentIndId = (String)item_contentindlinks.elementAt(i);
        // load content indicator from id
        contentIndicator.load(new Integer(contentIndId).intValue());

            out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/subject/?id=" +
                contentIndicator.getId()+ "\">" +       
            		contentIndicator.getName() + "</a></td>");
                out.println("</tr>");        
      }
    } 
		if(itemCICounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
    // Work
    out.println("   <tr class=\"b-185\">");
    int itemWorkCounter=0;
   
    if(work != null){
      // in the item_worklinks vector we only have the work id 
      // to get the work name -> load a work object
      for(int i = 0; i < item_worklinks.size(); i ++){
    	  if(itemWorkCounter==0){
    		    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Related Works</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemWorkCounter++;
    	  }
        // get work id
        String workId = (String)item_worklinks.elementAt(i);
        // load work from id
        work.load(new Integer(workId).intValue());
            out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/work/?id=" +
                    work.getId()+ "\">" +       
                    work.getWorkTitle() + "</a></td>");
            out.println("</tr>");        
      }
    } 
		if(itemWorkCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
        
    // Resource
    out.println("<tr>");
    int itemRRCounter=0;
    if(assocItem != null){    	
      // in the item_worklinks vector we only have the work id 
      // to get the work name -> load a work object
      for(int i = 0; i < item_itemlinks.size(); i ++){
    	  if(itemRRCounter==0){
    		  out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Related Resources</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemRRCounter++;
    	  }
        // get work id
        ItemItemLink itemItemLink = (ItemItemLink)item_itemlinks.elementAt(i);
        // load work from id
        assocItem.load(new Integer(itemItemLink.getChildId()).intValue());
        
        LookupCode lookUpCode = new LookupCode(db_ausstage_for_drill);
        lookUpCode.load(Integer.parseInt(itemItemLink.getFunctionId()));
        out.println("<tr><td  valign=\"top\">" +
                    lookUpCode.getDescription() + " " + 
                   "<a href=\"/pages/resource/?id=" +
                   assocItem.getItemId() + "\">" +
                   assocItem.getCitation() + "</a></td>");
                   out.println("</tr>");   
      }
    } 
    if(itemRRCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    
    //Events
   out.println("   <tr class=\"b-185\">");
    int itemRECounter=0;
    if(event != null){
      // we have the event 
      for(int i = 0; i < item_evlinks.size(); i ++){
    	  if(itemRECounter==0){
    		  out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Related Events</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemRECounter++;
    	  }
        rset = event.getEventsByItem(Integer.parseInt((String)item_evlinks.elementAt(i)), stmt);
        if(rset != null){
          while(rset.next()){
            out.print("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/event/?id=" +
                       rset.getString("eventid") + "\">" +
                       rset.getString("event_name") + "</a>, ");

            out.print(rset.getString("venue_name") + ", " + rset.getString("suburb") + ", " + rset.getString("state") + ", ");
            out.print(formatDate(rset.getString("Ddfirst_date"),rset.getString("Mmfirst_date"),rset.getString("Yyyyfirst_date")));
            out.println("</td></tr>");
          }
        }
      }
    }if(itemRECounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}


    // Other Contributor
    out.println("<tr>");
    int itemRCCounter=0;
    if(contributor != null)
    {
      for(int i = 0; i < item_conlinks.size(); i ++)
      {
    	  if(itemRCCounter==0)
    	  {
    		  out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Related Contributors</td>");
    	    out.println("  <td>&nbsp;</td>");
    	    out.println("  <td  valign=\"top\">");
    	    out.println("    <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    	    itemRCCounter++;
    	  }
          String name = "";
          String contribId;
          contribId = ((ItemContribLink)item_conlinks.elementAt(i)).getContribId();
          // use the contribId to load a new organisation each time:
          contributor.load(new Integer(contribId).intValue());
          contribId = "" + contributor.getId();
          name = contributor.getName() + " " + contributor.getLastName();
          out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/contributor/?id=" +
                     contribId + "\">" +
                     name + "</a></td>");
          out.println("</tr>");
      }
    }if(itemRCCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}
    // Other Organisation
    
   out.println("   <tr class=\"b-185\">");
    int itemROCounter=0;
    if(organisation != null){
      // this link is wierd the Item Org Link is in the Vector
      for(int i = 0; i < item_orglinks.size(); i ++)
      {
    	  if(itemROCounter==0)
    	  {
    		  out.println("  <td align='right'  class='general_heading_light' valign=\"top\">Related Organisations</td>");
    		    out.println("  <td>&nbsp;</td>");
    		    out.println("  <td  valign=\"top\">");
    		    out.println("       <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    		    itemROCounter++;
    	  }
          String orgaId = ((ItemOrganLink)item_orglinks.elementAt(i)).getOrganisationId();
          // use the orgaId to load a new organisation each time:
          organisation.load(new Integer(orgaId).intValue());
          out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/organisation/?id=" +
                   organisation.getId() + "\">" +
                   organisation.getName() + "</a></td>");
        out.println("</tr>");
       
      }
    }if(itemROCounter>0){
    out.println("  </table>");
    out.println("</td>");
    out.println("</tr>");}

    //Venues
      int itemRVCounter=0;
	    out.println("<tr>");
	   
	    if(venue != null){
	      // in the item_venuelinks vector we only have the venue id 
	      // to get the venue name -> load a venue object
	      for(int i = 0; i < item_venuelinks.size(); i ++){
	    	  if(itemRVCounter==0){
	    		  out.println("<td align='right'  class='general_heading_light f-186' valign=\"top\">Related Venues</td>");
	    		    out.println("<td>&nbsp;</td>");
	    		    out.println("<td  valign=\"top\">");
	    		    out.println("    <table width=\"" + baseCol3Wdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    		    itemRVCounter++;
	    	  }
	        // 
	        String venueId = (String)item_venuelinks.elementAt(i);
	        //rset = venue.getVenuesByItem(Integer.parseInt((String)item_venuelinks.elementAt(i)), stmt);
	        
	        venue.load(new Integer(venueId).intValue());
	
	            out.println("<tr><td width=\"" + secCol1Wdth + "\"  valign=\"top\"><a href=\"/pages/venue/?id=" +
	                       venue.getVenueId() + "\">" +
	                       venue.getName() + "</a>, " + venue.getSuburb() + ", " + state.getName(Integer.parseInt(venue.getState())) + "</td>");
	            out.println("</tr>");        
	      	}
	      }
	    if(itemRVCounter >0){
	    out.println("  </table>");
	    out.println("</td>");
	    out.println("</tr>");}
    
    //Source
     if (item.getSourceCitation() != null && !item.getSourceCitation().equals("")) {
    	 out.println("   <tr class=\"b-185\">");
    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Source</td>");
    out.println("  <td>&nbsp;</td>");
    out.println("  <td  class='general_body' valign=\"top\">");
    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
    out.println("      <tr>");
    out.println("        <td  valign=\"top\"><a href=\"/pages/resource/?id=" + item.getSourceId() + "\">" + item.getSourceCitation() + "</a></td>");
    out.println("      </tr>");
    out.println("     </table>");
    out.println("  </td>");
    out.println("</tr>");
     }
    //added extra table row for item url 21-02-06.
    if (item.getItemUrl() != null && !item.getItemUrl().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light' valign=\"top\">Item URL</td>");
	    out.println("  <td >&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.print  ("        <td  valign=\"top\"> <a target='_blank' href=\"");
	    if (!item.getItemUrl().toLowerCase().startsWith("http://")) {
	      out.print  ("http://");
	    }
	    out.println(item.getItemUrl() + "\">" + item.getItemUrl() + "</a><br>");
	    %>
	    <br>
	    <script type="text/javascript" src="http://www.shrinktheweb.com/scripts/pagepix.js"></script>
	    <script type="text/javascript">
            stw_pagepix('<%
	    if(item.getItemUrl().indexOf("http://") < 0)
	      out.print("http://");
	    %><%=item.getItemUrl()%>', 'afcb2483151d1a2', 'sm', 0);
	    var anchorElements = document.getElementsByTagName('a');
            for (var i in anchorElements) {
              if (anchorElements[i].href.indexOf("shrinktheweb") != -1 || anchorElements[i].href == document.getElementById('url').href){
                anchorElements[i].onmousedown = function() {}
                anchorElements[i].href = document.getElementById('url').href;
              }
            }
            </script>
	    
	    <%
	    out.println("</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
    
    //Publisher
    if (item.getPublisher() != null && !item.getPublisher().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Publisher</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" + item.getPublisher() + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
    
    //  publication location
    if (item.getPublisherLocation() != null && !item.getPublisherLocation().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Publisher Location</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" + item.getPublisherLocation() + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");   
    }
    
     //Volume
    if (item.getVolume() != null && !item.getVolume().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Volume</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">" + item.getVolume() + "</td>");
	    out.println("</tr>");   
    }
     
    //Issue
    if (item.getIssue() != null && !item.getIssue().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Issue</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">" + item.getIssue() + "</td>");
	    out.println("</tr>");   
    }
    
    //Page
    if (item.getPage() != null && !item.getPage().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Page</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">" + item.getPage() + "</td>");
	    out.println("</tr>");   
    }
    
    //Date Issued
    if (!formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()).equals("")) { 
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Date Issued</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" +     formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()) + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
    
    // Date Created
    if (!formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()).equals("")) { 
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Date Created</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" +     formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()) + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");    
    }
    
    //Date of Copyright
    if (!formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()).equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Date of Copyright</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" +     formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()) + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
    
    //Date Accessioned
    if (!formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()).equals("")) {
		  out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Date Accessioned</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" +     formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()) + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
    //Date Notes
    if (item.getDateNotes() != null && !item.getDateNotes().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Date Notes</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  class='general_body' class='general_body' valign=\"top\">" + item.getDateNotes() + "</td>");
	    out.println("</tr>"); 
    }
    
    //Catologue Id
    if (item.getCatalogueId() != null && !item.getCatalogueId().equals("")) {
    	out.println("   <tr class=\"b-185\">");
    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Catalogue ID</td>");
    out.println("  <td>&nbsp;</td>");
    out.println("  <td  class='general_body' valign=\"top\">" + item.getCatalogueId() + "</td>");
    out.println("</tr>");
     }
    
    //Holding Institution
    String institutionName = "";
    
    if (item.getInstitutionId() != null && !item.getInstitutionId().equals("")) {
      Organisation holdingOrgan = new Organisation(db_ausstage_for_drill);
      holdingOrgan.load(Integer.parseInt(item.getInstitutionId()));
      institutionName = holdingOrgan.getName();
    }
  	if(institutionName != null && !institutionName.equals("")){
  		out.println("   <tr class=\"b-185\">");
    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Holding Institution</td>");
    out.println("  <td>&nbsp;</td>");
    out.println("  <td  class='general_body' valign=\"top\">");
    out.print("    <a href=\"/pages/organisation/?id=" + item.getInstitutionId() + "\" valign=\"top\">" + institutionName + "</a>");
    out.println("</td>");
    out.println("</tr>");
  	}
    //Rights
    if (item.getRights() != null && !item.getRights().equals("")) {
	    out.println("<tr>");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Rights</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getRights() + "</td>");
	    out.println("</tr>"); 
    }
    
   //Rights Holder
    if (item.getRightsHolder() != null && !item.getRightsHolder().equals("")) {
	    out.println("<tr>");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Rights Holder</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getRightsHolder() + "</td>");
	    out.println("</tr>");
    }  
   
   //Access Rights
    if (item.getRightsAccessRights() != null && !item.getRightsAccessRights().equals("")) {
	    out.println("<tr>");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Access Rights</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td    valign=\"top\">" + item.getRightsAccessRights() + "</td>");
	    out.println("</tr>");   
    }
   
    //Language
    if (item.getItemLanguage() != null && !item.getItemLanguage().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Language</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td    valign=\"top\">" + language.getDescription() + "</td>");
	    out.println("</tr>");
    }
    
    //Medium
 		if (item.getFormatMedium() != null && !item.getFormatMedium().equals("")) {
 			out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Medium</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getFormatMedium() + "</td>");
	    out.println("</tr>");
 		}
    
    //Extent
    if (item.getFormatExtent() != null && !item.getFormatExtent().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Extent</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getFormatExtent() + "</td>");
	    out.println("</tr>");
    }
    
    //Mimetype
    if (item.getFormatMimetype() != null && !item.getFormatMimetype().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Mimetype</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getFormatMimetype() + "</td>");
	    out.println("</tr>");
    }
    
    //Format
    if (item.getFormat() != null && !item.getFormat().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td  align='right'  class='general_heading_light f-186' valign=\"top\">Format</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getFormat() + "</td>");
	    out.println("</tr>");
    }
    
    //ISBN
    if (item.getIdentIsbn() != null && !item.getIdentIsbn().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">ISBN</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getIdentIsbn() + "</td>");
	    out.println("</tr>"); 
    }
    
    //ISMN
    if (item.getIdentIsmn() != null && !item.getIdentIsmn().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">ISMN</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td   valign=\"top\">" + item.getIdentIsmn() + "</td>");
	    out.println("</tr>"); 
    }
    
    //ISSN
    if (item.getIdentIssn() != null && !item.getIdentIssn().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">ISSN</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  valign=\"top\">" + item.getIdentIssn() + "</td>");
	    out.println("</tr>"); 
    }
    
    //SRCN
    if (item.getIdentSici() != null && !item.getIdentSici().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">SRCN</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  valign=\"top\">" + item.getIdentSici() + "</td>");
	    out.println("</tr>"); 
    }
    
    //Comments
    if (item.getComments() != null && !item.getComments().equals("")) {
    	out.println("   <tr class=\"b-185\">");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Comments</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" + item.getComments() + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }
        //Citation
    if (item.getCitation() != null && !item.getCitation().equals("")) {
	    out.println("<tr>");
	    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Citation</td>");
	    out.println("  <td>&nbsp;</td>");
	    out.println("  <td  valign=\"top\">");
	    out.println("     <table width=\"" + secTableWdth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
	    out.println("      <tr>");
	    out.println("        <td  valign=\"top\">" + item.getCitation() + "</td>");
	    out.println("      </tr>");
	    out.println("     </table>");
	    out.println("  </td>");
	    out.println("</tr>");
    }

    //Resource Identifier
    if (item.getItemId() != null && !item.getItemId().equals("")) {
    	out.println("   <tr class=\"b-185\">");
    out.println("  <td align='right'  class='general_heading_light f-186' valign=\"top\">Resource Identifier</td>");
    out.println("  <td>&nbsp;</td>");
    out.println("  <td  valign=\"top\">" + item.getItemId() + "</td>");
    out.println("</tr>"); 
    }
    out.println("   <tr>");
    out.println("     <td>&nbsp; </td>");
    out.println("   </tr>");
    out.println(" </table>");

  
  // close statement
  stmt.close();
%>
<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>
  <!-- AddThis Button BEGIN -->
    <div align="right" class="addthis_toolbox addthis_default_style ">
      <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
      <a class="addthis_button_tweet"></a>
      <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
      <a class="addthis_counter addthis_pill_style"></a>
    </div>

</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
<cms:include property="template" element="foot" />
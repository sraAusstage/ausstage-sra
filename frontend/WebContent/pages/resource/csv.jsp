<%@ page pageEncoding="UTF-8"
%><%@ page contentType="text/html; charset=UTF-8"
%><%@ page import = "java.util.Vector, java.text.SimpleDateFormat"
%><%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"
%><%@ page import = "ausstage.State"
%><%@ page import = "admin.Common"
%><%@ page import = "ausstage.Event, ausstage.DescriptionSource"
%><%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"
%><%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"
%><%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"
%><%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"
%><%@ page import = "ausstage.ConEvLink, ausstage.Contributor"
%><%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"
%><%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"
%><%@ page import = "ausstage.SecondaryGenre, ausstage.Work, ausstage.RelationLookup"
%><%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" 
%><%@ page session="true" import="java.lang.String, java.util.*" 
%><%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);
%><%//response = org.opencms.flex.CmsFlexController.getController (request).getTopResponse();
response.setContentType("text/csv");
response.setHeader("Content-Disposition", "attachment; filename=ausstage.csv");
%><%@ page import = "ausstage.AusstageCommon"
%><%!
public String concatFields(Vector fields, String token) {
  String ret = "";
  for (int i=0; i<fields.size(); i++) {
    if (fields.elementAt(i) != null) {
        if (!(fields.elementAt(i)).equals("") && !ret.equals("")) {
          ret += token;
        }
        ret += fields.elementAt(i);
    }
  }
  return (ret);
}

public String formatDate(String day, String month, String year)
{
  if (year == null || year.equals("") ){
    return "";
}
Calendar calendar = Calendar.getInstance();
  
  SimpleDateFormat formatter = new SimpleDateFormat();
  if (month == null || month.equals("") ){
    formatter.applyPattern("yyyy");
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
   }
  else if(day == null || day.equals("") ){
    formatter.applyPattern("MMMMM yyyy");
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
   }
  else{
    formatter.applyPattern("d MMMMM yyyy");
    calendar.set(Calendar.DAY_OF_MONTH  ,new Integer(day).intValue());
    calendar.set(Calendar.MONTH  ,new Integer(month).intValue() -1);
    calendar.set(Calendar.YEAR , new Integer(year).intValue());
  }

  java.util.Date date = calendar.getTime();
  
  
  String result = formatter.format(date);
  //System.out.println(result + " " + day + month + year);

  return result;

}

public boolean hasValue(String str) {
  if (str != null && !str.equals("")) {
    return true;
  } else {
    return false;
  }
}
%><%
  ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
	
List<String> groupNames = new ArrayList();	
if (session.getAttribute("userName")!= null) {
	admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
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
    //item_itemlinks  = item.getAssociatedItems();
    item_itemlinks = item.getItemItemLinks();
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
   
    

    //Resource Sub Type (Label is Resouce Type)
    
    if (item_type != null) {	   
	    out.print("\"Type\""); 	 	  
	    out.print  (",\"" + item_type.getShortCode());
	    if (item_sub_type != null) {
	      out.print  (": " + item_sub_type.getShortCode()+ "\",");
	    }	  
    }
    out.println("");
    
    //Title
    
    if (item.getTitle() != null && !item.getTitle().equals("")) {
      out.println("\"Title\",\"" + item.getTitle() + "\"");
   }
    
    //Alternative Title
    
    if (item.getTitleAlternative() != null && !item.getTitleAlternative().equals("")) {   	
	   out.println("\"Alternative Title\",\"" + item.getTitleAlternative() + "\"");
    }
     
     // Creator Contributor
    out.println("");
    int itemCCCounter=0;
    
    if(contributorCreator != null){
      for(int i = 0; i < item_creator_conlinks.size(); i ++){
    	  if(itemCCCounter==0){
    	    out.println("\"Creator Contributors\",");  
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
          
          String functionid = ((ItemContribLink)item_creator_conlinks.elementAt(i)).getFunctionId();
          lookups.load(Integer.parseInt(functionid));
          
          name = contributorCreator.getName() + " " + contributorCreator.getLastName();
          
          out.print("\"" + name + "\"");
          if (lookups.getShortCode() != null && !lookups.getShortCode().equals("") ){
	          out.print(",\"" +  lookups.getShortCode()+ "\",");               
          }
          else if (contributorCreator.getContFunctPreffTermByContributor(contribId) != null && !contributorCreator.getContFunctPreffTermByContributor(contribId).equals("")) {
        	  out.print(",\"" +  contributorCreator.getContFunctPreffTermByContributor(contribId)+ "\",");               
       	  }
       	  out.println("");
        	 
      }
    }
    out.println("");
    
    // Creator Organisation
    
    int creatorOrgCounter=0;
    if(organisationCreator != null){
      // this link is wierd the Item Org Link is in the Vector
    for(int i = 0; i < item_creator_orglinks.size(); i ++){
      if(creatorOrgCounter==0){
	  out.println("\"Creator Organisations\"");
	  creatorOrgCounter++;
        }
        String orgaId = ((ItemOrganLink)item_creator_orglinks.elementAt(i)).getOrganisationId();        
        // use the orgaId to load a new organisation each time:
        organisationCreator.load(new Integer(orgaId).intValue());
        out.println("\"" + organisationCreator.getName() + "\""); 
      }
    }
    
    //Abstract/Description
    if (item.getDescriptionAbstract() != null && !item.getDescriptionAbstract().equals("")) {   	
      out.println("\" Abstract/Description\",\"");      
      out.println("\"" + item.getDescriptionAbstract() + "\"");
    }

    //  SECONDARY GENRE //    
    
    int itemSGCounter=0;
    if(secondaryGenre != null){
      // 
      for (int i=0; i < item_secgenrelinks.size(); i++){
    	  if(itemSGCounter==0){
    		  out.println("\"Genre\"");
    		  itemSGCounter++;
    	  }
        String secGenreId = (String) item_secgenrelinks.elementAt(i);
        // use the secondary genre Id to load a new secondary genre each time:
        secondaryGenre.loadLinkedProperties(new Integer(secGenreId).intValue());       
        out.println("\"" + secondaryGenre.getName() + "\"");    
      }
    }
		    
    // Content Indicator
    
    int itemCICounter=0;
    if(contentIndicator != null){
      out.println("");
      // in the item_contentindlinks vector we only have the content indicator id 
      // to get the content indicator name -> load a content indicator object
      for(int i = 0; i < item_contentindlinks.size(); i ++){
    	  if(itemCICounter==0){
    		  out.println("\"Subjects\"");
    		  itemCICounter++;
    	  }
        // get content ind id
        String contentIndId = (String)item_contentindlinks.elementAt(i);
        // load content indicator from id
        contentIndicator.load(new Integer(contentIndId).intValue());
            out.println("\"" +  contentIndicator.getName() + "\"");    
         }
    } 
	    
    // Work   
    int itemWorkCounter=0;
   
    if(work != null){
      out.println("");
      // in the item_worklinks vector we only have the work id 
      // to get the work name -> load a work object
      for(int i = 0; i < item_worklinks.size(); i ++){
    	  if(itemWorkCounter==0){
	    out.println("\"Related Works\"");
	    itemWorkCounter++;
    	  }
        // get work id
        String workId = (String)item_worklinks.elementAt(i);
        // load work from id
        work.load(new Integer(workId).intValue());
        out.println("\"" +  work.getWorkTitle() + "\"");    
      }
    } 	
        
    // Resource
    out.println("");    
    int itemRRCounter=0;
    if(assocItem != null){   
      out.println(""); 	
      // in the item_worklinks vector we only have the work id 
      // to get the work name -> load a work object
      for(int i = 0; i < item_itemlinks.size(); i ++){
    	  if(itemRRCounter==0){
    		  out.println("\"Related Resources\"");
    		  itemRRCounter++;
    	  }
        // get work id
        ItemItemLink itemItemLink = (ItemItemLink)item_itemlinks.elementAt(i);
        // load item from id
         String relationship = "";

        //AUS-56 fix for a bug that was introduced when we created reciprocal relationships
        RelationLookup relationLookup = new RelationLookup(db_ausstage_for_drill);
        relationLookup.load(Integer.parseInt(itemItemLink.getRelationLookupId())); 
        
        if (itemItemLink.getItemId().equals(item.getItemId())){
        	relationship = relationLookup.getParentRelation();
        	assocItem.load(new Integer(itemItemLink.getChildId()).intValue());
        }
        if (itemItemLink.getChildId().equals(item.getItemId())){
        	relationship = relationLookup.getChildRelation();
        	assocItem.load(new Integer(itemItemLink.getItemId()).intValue());
        }
               
      //  out.println("\"" +  assocItem.getCitation() + "\"");    
        out.print("\""  +relationship + "\"");    
        out.println(",\"" + assocItem.getCitation() +"\"");
      }
   } 
    
    //Events 
    
    int itemRECounter=0;
    if(event != null){
      out.println("");
      // we have the event 
      for(int i = 0; i < item_evlinks.size(); i ++){
    	  if(itemRECounter==0){
    		  out.println("\"Related Events\"");
    		  itemRECounter++;
    	  }
        rset = event.getEventsByItem(Integer.parseInt((String)item_evlinks.elementAt(i)), stmt);
        if(rset != null){
          while(rset.next()){
            out.print("\"" + rset.getString("event_name") + "\",");
            out.print("\"" + rset.getString("venue_name") + ", " + rset.getString("suburb") + ", " + rset.getString("state") +"\",");
            out.print("\"" + formatDate(rset.getString("Ddfirst_date"),rset.getString("Mmfirst_date"),rset.getString("Yyyyfirst_date"))+ "\",");
          }
        }
      }
    }

    // Other Contributor  
      
    int itemRCCounter=0;
    if(contributor != null)
    {
      out.println("");
      for(int i = 0; i < item_conlinks.size(); i ++)
      {
    	  if(itemRCCounter==0)
    	  {
    	    out.println("\"Related Contributors\"");
    	    itemRCCounter++;
    	  }
          String name = "";
          String contribId;
          contribId = ((ItemContribLink)item_conlinks.elementAt(i)).getContribId();
          // use the contribId to load a new organisation each time:
          contributor.load(new Integer(contribId).intValue());
          contribId = "" + contributor.getId();
          name = contributor.getName() + " " + contributor.getLastName();
          out.println("\"" + name + "\"");  
      }
    }
   
    // Other Organisation
    
    int itemROCounter=0;
    if(organisation != null){
      // this link is wierd the Item Org Link is in the Vector
      for(int i = 0; i < item_orglinks.size(); i ++)
      {
    	  if(itemROCounter==0)
    	  {
    		  out.println("\"Related Organisations\"");
    		  itemROCounter++;
    	  }
          String orgaId = ((ItemOrganLink)item_orglinks.elementAt(i)).getOrganisationId();
          // use the orgaId to load a new organisation each time:
          organisation.load(new Integer(orgaId).intValue());
          out.println("\""+ organisation.getName() + "\"");   
        }
    }

    //Venues
    
    int itemRVCounter=0;
    if(venue != null){
      // in the item_venuelinks vector we only have the venue id 
      // to get the venue name -> load a venue object
      for(int i = 0; i < item_venuelinks.size(); i ++){
    	  if(itemRVCounter==0){
	    out.println("\"Related Venues\"");  	
	    itemRVCounter++;
    	  }
          String venueId = (String)item_venuelinks.elementAt(i);
          //rset = venue.getVenuesByItem(Integer.parseInt((String)item_venuelinks.elementAt(i)), stmt);	        
          venue.load(new Integer(venueId).intValue());	
          out.println("\"" + venue.getName() + ", " + venue.getSuburb() + ", " + state.getName(Integer.parseInt(venue.getState())) + "\"");   
        }
      }
	    
    //Source
     
     if (item.getSourceCitation() != null && !item.getSourceCitation().equals("")) {   
       out.println(""); 	
       out.println("\"Source\",\"" + item.getSourceCitation() + "\"");
     }
    
    //added extra table row for item url 21-02-06.
    
    if (item.getItemUrl() != null && !item.getItemUrl().equals("")) {   
      out.println("\"Item URL\",\"" + item.getItemUrl() + "\"");
    }
    
    //Publisher
    
    if (item.getPublisher() != null && !item.getPublisher().equals("")) { 
      out.println("\"Publisher\",\"" + item.getPublisher() + "\"");   	
    }
    
    //  publication location
    
    if (item.getPublisherLocation() != null && !item.getPublisherLocation().equals("")) {
      out.println("\"Publisher Location\",\"" + item.getPublisherLocation() + "\"");  
    }
    
     //Volume
     
    if (item.getVolume() != null && !item.getVolume().equals("")) {   	
      out.println("\"Volume\",\"" + item.getVolume() + "\"");  
    }
     
    //Issue
    
    if (item.getIssue() != null && !item.getIssue().equals("")) {    
      out.println("\"Issue\",\"" + item.getIssue() + "\"");	
    }
    
    //Page
    
    if (item.getPage() != null && !item.getPage().equals("")) {
      out.println("\"Page\",\"" + item.getPage() + "\"");	
    }
    
    //Date Issued
    
    if (!formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()).equals("")) { 	
      out.println("\"Date Issued\",\"" + formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()) + "\"");	  
    }
    
    // Date Created
    
    if (!formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()).equals("")) { 	
      out.println("\"Date Created\",\"" + formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()) + "\"");	  
    }
    
    //Date of Copyright
    
    if (!formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()).equals("")) {
      out.println("\"Date of Copyright\",\"" + formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()) + "\"");	
    }
    
    //Date Accessioned
    
    if (!formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()).equals("")) {	
      out.println("\"Date Accessioned\",\"" + formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()) + "\"");		
    }
    
    //Date Notes
    
    if (item.getDateNotes() != null && !item.getDateNotes().equals("")) {
      out.println("\"Date Notes\",\"" + item.getDateNotes()  + "\"");
    }
    
    //Catologue Id
    
    if (item.getCatalogueId() != null && !item.getCatalogueId().equals("")) {   	
      out.println("");
      out.println("\"Catalogue ID\",\"" + item.getCatalogueId()  + "\"");
    }
    
    //Holding Institution
    
    String institutionName = "";
    
    if (item.getInstitutionId() != null && !item.getInstitutionId().equals("")) {
      Organisation holdingOrgan = new Organisation(db_ausstage_for_drill);
      holdingOrgan.load(Integer.parseInt(item.getInstitutionId()));
      institutionName = holdingOrgan.getName();
    }
      if(institutionName != null && !institutionName.equals("")){
    	out.println("");
    	out.println("\"Holding Institution\",\"" + institutionName  + "\"");
    }
      
    //Rights
    
    if (item.getRights() != null && !item.getRights().equals("")) {	   
	    out.println("");
	    out.println("\"Rights\",\"" + item.getRights() + "\"");
    }
    
   //Rights Holder
   
    if (item.getRightsHolder() != null && !item.getRightsHolder().equals("")) {
	    out.println("");
	    out.println("\"Rights Holder\",\"" + item.getRightsHolder() + "\"");
    }  
   
   //Access Rights
   
    if (item.getRightsAccessRights() != null && !item.getRightsAccessRights().equals("")) {
    	out.println("");
        out.println("\"Access Rights\",\"" + item.getRightsAccessRights() + "\"");
    }
   
    //Language    
    if (item.getItemLanguage() != null && !item.getItemLanguage().equals("")) {
	    out.println("");
	    out.println("\"Language\",\"" + item.getItemLanguage() + "\"");
    }
    
    //Medium    
    if (item.getFormatMedium() != null && !item.getFormatMedium().equals("")) {
	    out.println("\"Medium\",\"" + item.getFormatMedium() + "\"");
     }
    
    //Extent
    
    if (item.getFormatExtent() != null && !item.getFormatExtent().equals("")) {
	    out.println("");
	    out.println("\"Extent\",\"" + item.getFormatExtent() + "\"");
    }
    
    //Mimetype    
    if (item.getFormatMimetype() != null && !item.getFormatMimetype().equals("")) {
	    out.println("");
	    out.println("\"Mimetype\",\"" + item.getFormatMimetype() + "\"");
    }
    
    //Format    
    if (item.getFormat() != null && !item.getFormat().equals("")) {
	    out.println("");
	    out.println("\"Format\",\"" + item.getFormat() + "\"");
    }
    
    //ISBN    
    if (item.getIdentIsbn() != null && !item.getIdentIsbn().equals("")) {
	    out.println("");
	    out.println("\"ISBN\",\"" + item.getIdentIsbn() + "\"");
    }
    
    //ISMN   
    if (item.getIdentIsmn() != null && !item.getIdentIsmn().equals("")) {
	    out.println("");
	    out.println("\"ISMN\",\"" + item.getIdentIsmn() + "\"");
    }
    
    //ISSN    
    if (item.getIdentIssn() != null && !item.getIdentIssn().equals("")) {	   
	    out.println("");
	    out.println("\"ISSN\",\"" + item.getIdentIssn() + "\"");
    }
    
    //SRCN
    if (item.getIdentSici() != null && !item.getIdentSici().equals("")) {	 
	    out.println("");
	    out.println("\"SRCN\",\"" + item.getIdentSici() + "\"");
    }
    
    //Comments    
    if (item.getComments() != null && !item.getComments().equals("")) {
      out.println("");
      out.println("\"Comments\",\"" + item.getComments() + "\"");
    }
 
    //Citation    
    if (item.getCitation() != null && !item.getCitation().equals("")) {
      out.println("");
      out.println("\"Citation\",\"" + item.getCitation() + "\"");
    }

    //Resource Identifier    
    out.println("\"Resource Identifier\",\"" + item.getItemId() + "\"");
        
  // close statement
  stmt.close();
%>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, admin.Common, java.util.*"%>
<%@ page import = " ausstage.Database, ausstage.Item, ausstage.Contributor, ausstage.ItemItemLink, ausstage.RelationLookup"%>

<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>


 <!-- include libraries(jQuery, bootstrap) -->
<link rel="stylesheet" type="text/css" href="../resources/bootstrap-3.3.7/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="../pages/assets/styles/bootstrap-override.css" />
<!-- include summernote css/js-->
<link href="../pages/assets/summernote/summernote.css" rel="stylesheet">
<script src="../pages/assets/summernote/summernote.min.js"></script>
<!-- this is an unfortunate side effect of all the stylesheets involved. 
including bootstrap threw table layouts out, and then the fix threw this layout out, so given we will hopefully rework all of this,
my solution is to just blanket this page in a div with a class to fix the style issues. -->
<div class="no-padding-fix">
<%
  //declare all the variables we use 
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Resource Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage        pageFormater         = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage          = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement               stmt                 = db_ausstage.m_conn.createStatement ();
  ausstage.HtmlGenerator  htmlGenerator        = new ausstage.HtmlGenerator (db_ausstage);
  ausstage.Datasource     datasource           = new ausstage.Datasource (db_ausstage);
  Item                    item                 = new Item(db_ausstage);
  Contributor             contributor          = new Contributor(db_ausstage);
  String                  itemid               = request.getParameter("f_itemid");
  String                  catalogueID          = request.getParameter("f_catalogue_id");
  String		  m_item_article;
  Vector                  temp_display_info;
  Vector                  m_item_evlinks;
  Vector<ItemItemLink>    m_item_itemlinks;
  Vector                  m_item_secgenrelinks;
  Vector                  m_item_orglinks;
  Vector                  m_item_creator_orglinks;
  Vector                  m_item_venuelinks;
  Vector                  m_item_conlinks;
  Vector                  m_item_creator_conlinks;
  Vector                  m_item_contentindlinks;
  Vector                  m_item_worklinks;
  Vector 		  m_additional_urls; // BW additional Urls
  String                  institution_id       = "0";
  String                  item_type_id         = "0";
  String                  item_sub_type_id     = "0";
  String                  item_language        = "0";
  String                  item_condition_id    = "0";
  String                  donated_purchased_id = "";
  String                  action               = request.getParameter("action");
  int                     counter              = 0;
  ResultSet               rset;
  Common                  common               = new Common();
  Hashtable               hidden_fields        = new Hashtable();
  String                  currentUser_authId = session.getAttribute("authId").toString();
 
  String readOnly = "";
  String disabled = "";
  boolean preview = false;
 
  //check the action
  if(action != null && action.equals("preview")){
    readOnly = "readonly";
    disabled = "disabled";
    preview = true;
  }
  
  //header
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
  if(catalogueID == null) catalogueID = "";
  // use a new Item object that is not from the session.
  if(action != null && action.equals("add")){
    action = "add";
    itemid = "0";
  }
  else if (action != null && action.equals("edit")){ //editing existing Item
    if (itemid != null && !itemid.equals("")) {  // try the item id first
      item.load(Integer.parseInt(itemid));
    }
    else { //try the catalogue ID next
      item.load(catalogueID);
      itemid  = item.getItemId();
      //if someone selects a catalogue  id that doesn't exist
      //we still want this to be displayed so that they do not have to type it in again
      //when creating the new item
      if(item.getCatalogueId().equals(""))
        item.setItemCatalogueId(catalogueID);
      }
  }
  else if (action != null && action.equals("copy")){
    item.load(catalogueID);
    itemid  = item.getItemId();
  }
  else if (action != null && action.equals("preview")){
    if (request.getParameter("f_select_this_child_id") != null) {
      item.load(Integer.parseInt(request.getParameter("f_select_this_child_id")));
    }
    else {
      item.load(Integer.parseInt(request.getParameter("f_select_this_item_id")));
    }
    itemid  = item.getItemId();
  }
  else{ //use the item object from the session.
    item = (Item)session.getAttribute("item");
    itemid  = item.getItemId();
  }
  
  if(action == null)
    action = "";

  // get the initial state of the object(s) associated with this event
  m_item_evlinks            = item.getAssociatedEvents();
  m_item_secgenrelinks      = item.getAssociatedSecGenres();
  m_item_itemlinks          = item.getItemItemLinks();
  m_item_orglinks           = item.getAssociatedOrganisations();
  m_item_creator_orglinks   = item.getAssociatedCreatorOrganisations();
  m_item_venuelinks         = item.getAssociatedVenues();
  m_item_conlinks           = item.getAssociatedContributors();
  m_item_creator_conlinks   = item.getAssociatedCreatorContributors();
  m_item_contentindlinks    = item.getAssociatedContentIndicators();
  m_item_worklinks          = item.getAssociatedWorks();
  m_additional_urls	    = item.getAdditionalUrls();
  m_item_article	    = item.getItemArticle();
  %>
	<form name='item_addedit_form' id='item_addedit_form' action='item_addedit_process.jsp' method='post' onsubmit='return beforeSubmit();'>
	<input type='hidden' name='f_itemid' value='<%=itemid%>'>
  	<input type='hidden' name='f_from_item_add_edit_page' value='true'>
  <%  
  /***************************
        Type
  ****************************/

  pageFormater.writeHelper(out, "Type", "helpers_no1.gif");
  pageFormater.writeTwoColTableHeader(out, "Resource Type *");
  %>
    <select name='f_item_type' id='f_item_type' size='1' class='line250' onchange="refreshChildCodeTypeList(this.value,'f_item_sub_type', 'ajaxLoadingImageResType');resourceChanged(); '<%=disabled%>'"  >
    <%
  rset = item.getItemType(stmt);
  while (rset.next()) {
    item_type_id = rset.getString ("item_type_id");
    if(counter == 0)
      out.print("<option value=''>--- Select Resource Type ---</option>");
    out.print("<option value='" + item_type_id + "'");
    if (item.getItemType() != null && item.getItemType().equals(item_type_id))
      out.print(" selected");
    out.print(">" + rset.getString ("item_type") + "</option>");
    counter ++;
  }
  out.println("</select>");
  out.println("<span id='ajaxLoadingImageResType'></span>");
  counter = 0;
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Resource Sub Type *");
  out.println("<select name='f_item_sub_type' id='f_item_sub_type' size='1' class='line250' onchange='resourceChanged()' " + disabled + ">");
  
  if (!item.getItemType().equals("")) { // If we already have a item type selected
    rset = item.getItemSubTypes(stmt, Integer.parseInt(item.getItemType()));
    while (rset.next()) {
      item_sub_type_id = rset.getString ("item_sub_type_id");
      if(counter == 0)
        out.print("<option value=''>--- Select Resource Sub Type ---</option>");
      out.print("<option value='" + item_sub_type_id + "'");
      if (item.getItemSubType() != null && item.getItemSubType().equals(item_sub_type_id))
        out.print(" selected");
      out.print(">" + rset.getString ("item_sub_type") + "</option>");
      counter ++;
    }
  }
  else { // No item Type selected
    out.print("<option value=''>--- Select Resource Type First ---</option>");
  }
  out.println("</select>");
  counter = 0;
  pageFormater.writeTwoColTableFooter(out); 
 
  
  //full text articles
  %>
 <input type="hidden" id="f_item_article" name="f_item_article" value='<%=(m_item_article != null)?m_item_article:""%>'>
 <div id='item_article_container'  >
	 <div id='item_article'><%=(m_item_article != null)?m_item_article:"Enter article text here"%></div>
  </div>
  <%
  /***************************
       Designation
  ****************************/
  pageFormater.writeHelper(out, "Designation", "helpers_no2.gif");
  pageFormater.writeTwoColTableHeader(out, "Title *");
  out.println("<input type='text' name='f_title' size='60' class='line250' maxlength=300 value=\"" + item.getTitle().replaceAll("\"", "&quot;") + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Title Alternative");
  out.println("<input type='text' name='f_title_alternative' size='60' class='line250' maxlength=300 value=\"" + item.getTitleAlternative().replaceAll("\"", "&quot;") + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  ///////////////////////////////////
  // Creator Contributor Association(s)
  ///////////////////////////////////
  out.println("<a name='item_creator_contributors_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_creator_conlinks, "creator contributor", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "8",
                                               "item_contributors.jsp?Creator=TRUE",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Creator Contributor(s):",
                                               temp_display_info,
                                               1000,
                                               preview));

  ///////////////////////////////////
  // Creator ORGANISATIONS Association(s)
  ///////////////////////////////////
  out.println("<a name='item_creator_organisations_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_creator_orglinks, "creator organisation", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "9",
                                               "item_organisations.jsp?Creator=TRUE",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Creator Organisations(s):",
                                               temp_display_info,
                                               1000,
                                               preview));
  out.println("<BR>");
  
  pageFormater.writeTwoColTableHeader(out, "Abstract/Description");
  out.println("<textarea name='f_description_abstract' rows='5' cols='62' maxlength='4000' class='line250'" + readOnly + ">" + item.getDescriptionAbstract() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  /***************************
       Source
  ****************************/

  String refererPage = request.getHeader("referer");
  
  pageFormater.writeHelper(out, "Source", "helpers_no3.gif");
  String f_select_this_source_id = request.getParameter("f_select_this_source_id");
  // Only set to empty if coming from item_source page, not if coming back from an association page.
  if(action.equals("") && refererPage.indexOf("item_source.jsp") > -1){ // As source is not mandatory, we could be coming from the item_source page.
    if (f_select_this_source_id == null) {
      item.setSource("", "");
    }
    else {
      Item sourceItem = new Item(db_ausstage);
      sourceItem.load(Integer.parseInt(f_select_this_source_id));
      item.setSource(f_select_this_source_id, sourceItem.getCitation());
      
    }
  }
 // out.println("<a name='item_source' />");
  pageFormater.writeTwoColTableHeader(out, "Source");
  out.println("<input type='hidden' name='f_sourceid' value='" + item.getSourceId() + "'>");
  out.println("<input type='text' name='f_source_citation' readonly size='50' class='line300' value=\"" + 
                   item.getSourceCitation() + "\">");
  if (readOnly.equals("")) {
    out.print("<td width=30><a style='cursor:hand' " +
              "onclick=\"Javascript:item_addedit_form.action='item_source.jsp';" +
              "item_addedit_form.submit();\"><img border='0' src='" +
              AppConstants.IMAGE_DIRECTORY + "/popup_button.gif'></a></td>");
  }
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Publisher");
  out.println("<textarea name='f_publisher' rows='2' cols='62' maxlength='300' class='line250'" + readOnly + ">" + item.getPublisher() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Publisher Location");
  out.println("<input type='text' name='f_publisher_location' size='60' class='line250' maxlength=300 value=\"" + item.getPublisherLocation() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Volume");
  out.println("<input type='text' name='f_volume' size='60' class='line250' maxlength=60 value=\"" + item.getVolume() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Issue");
  out.println("<input type='text' name='f_issue' size='60' class='line250' maxlength=60 value=\"" + item.getIssue() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Page");
  out.println("<input type='text' name='f_page' size='60' class='line250' maxlength=60 value=\"" + item.getPage() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Citation");
  out.println("<textarea name='f_citation' readonly rows='5' cols='62' maxlength='300' class='line250'" + readOnly + ">" + item.getCitation() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
   
  /***************************
       Date
  ****************************/
  pageFormater.writeHelper(out, "Date", "helpers_no4.gif");
  pageFormater.writeTwoColTableHeader(out, "Date of Issue");
  out.println("<input type='text' name='f_issued_date_day' size='2' class='line15' maxlength=2 value='" +
              item.getDdIssuedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_issued_date_month' size='2' class='line15' maxlength=2 value='" +
              item.getMmIssuedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_issued_date_year' size='4' class='line35' maxlength=4 value='" +
              item.getYyyyIssuedDate() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Date Created");
  out.println("<input type='text' name='f_create_date_day' size='2' class='line15' maxlength=2 value='" +
              item.getDdCreateDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_create_date_month' size='2' class='line15' maxlength=2 value='" +
              item.getMmCreateDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_create_date_year' size='4' class='line35' maxlength=4 value='" +
              item.getYyyyCreateDate() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out); 

  pageFormater.writeTwoColTableHeader(out, "Date of Copyright");
  out.println("<input type='text' name='f_copyright_date_day' size='2' class='line15' maxlength=2 value='" +
              item.getDdCopyrightDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_copyright_date_month' size='2' class='line15' maxlength=2 value='" +
              item.getMmCopyrightDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_copyright_date_year' size='4' class='line35' maxlength=4 value='" +
              item.getYyyyCopyrightDate() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Accessioned");
  out.println("<input type='text' name='f_accessioned_date_day' size='2' class='line15' maxlength=2 value='" +
              item.getDdAccessionedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_accessioned_date_month' size='2' class='line15' maxlength=2 value='" +
              item.getMmAccessionedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_accessioned_date_year' size='4' class='line35' maxlength=4 value='" +
              item.getYyyyAccessionedDate() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Date Terminated");
  out.println("<input type='text' name='f_terminated_date_day' size='2' class='line15' maxlength=2 value='" +
              item.getDdTerminatedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_terminated_date_month' size='2' class='line15' maxlength=2 value='" +
              item.getMmTerminatedDate() + "'" + readOnly + ">");
  out.println("<input type='text' name='f_terminated_date_year' size='4' class='line35' maxlength=4 value='" +
              item.getYyyyTerminatedDate() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Notes");
  out.println("<textarea name='f_date_notes' rows='5' cols='62' maxlength='300' class='line250'" + readOnly + ">" + item.getDateNotes() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
   /***************************
       Acquisition
  ****************************/
  pageFormater.writeHelper(out, "Acquisition", "helpers_no5.gif");
  pageFormater.writeTwoColTableHeader(out, "Catalogue ID");
  out.println("<input type='text' name='f_catalogue_id' size='60' class='line175' maxlength='60' value=\"" + item.getCatalogueId() + "\"" + readOnly + ">  &nbsp;&nbsp;");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Holding Institution");
  out.println("<select name='f_institution' size='1' class='line250' " + disabled +  ">");
  rset = item.getInstitutions(stmt);
  while (rset.next()) {
    institution_id = rset.getString ("organisationid");
    if(counter == 0)
      out.print("<option value=''>--- Select Institution ---</option>");
    out.print("<option value='" + institution_id + "'");
    if (item.getInstitutionId() != null && item.getInstitutionId().equals(institution_id))
      out.print(" selected");
    out.print(">" + rset.getString ("name") + "</option>");
    counter ++;
  }
  out.println("</select>");
  counter = 0;
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Storage");
  out.println("<textarea name='f_storage' rows='5' cols='62' maxlength='250' class='line300'" + readOnly + ">" + item.getItemStorage() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Donated/Purchased");
  out.println("<select name='f_donated_purchased' size='1' class='line250'" + disabled + ">");
  rset = item.getItemDonatedPurchased(stmt);
  while (rset.next())
  {
    donated_purchased_id = rset.getString ("donated_purchased_id");
    if(counter == 0)
      out.print("<option value=''>--- Select ---</option>");
    out.print("<option value='" + donated_purchased_id + "'");
    if (item.getItemDonatedPurchasedId() != null && item.getItemDonatedPurchasedId().equals(donated_purchased_id))
      out.print(" selected");
    out.print(">" + rset.getString ("donated_purchased") + "</option>");
    counter ++;
  }
  out.println("</select>");
  rset.close();
  counter = 0;
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "From");
  out.println("<input type='text' name='f_aquired_from' size='60' maxlength='100' class='line250' value='" + item.getAquiredFrom() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Provenance");
  out.println("<textarea name='f_provenance' rows='5' cols='62' maxlength='100' class='line250'" + readOnly + ">" + item.getProvenance() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Significance");
  out.println("<textarea name='f_significance' rows='5' cols='62' maxlength='250' class='line250'" + readOnly + ">" + item.getSignificance() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Resource Condition");
  out.println("<select name='f_item_condition' size='1' class='line250'" + disabled + ">");
  rset = item.getItemConditions(stmt);
  while (rset.next()) {
    item_condition_id = rset.getString ("condition_id");
    if(counter == 0)
      out.print("<option value=''>--- Select Condition ---</option>");
    out.print("<option value='" + item_condition_id + "'");
    if (item.getItemConditionId() != null && item.getItemConditionId().equals(item_condition_id))
      out.print(" selected");
    out.print(">" + rset.getString ("condition") + "</option>");
    counter ++;
  }
  out.println("</select>");
  counter = 0;
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Condition Comments");
  out.println("<textarea name='f_detail_comments' rows='5' cols='62' maxlength='300' class='line250'" + readOnly + ">" + item.getDetailComments() + "</textarea>");
  pageFormater.writeTwoColTableFooter(out);
  
  /***************************
       Rights
  ****************************/
  pageFormater.writeHelper(out, "Rights", "helpers_no6.gif");
  pageFormater.writeTwoColTableHeader(out, "Rights");
  out.println("<input type='text' name='f_rights' size='60' class='line250' maxlength=300 value=\"" + item.getRights() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Rights Holder");
  out.println("<input type='text' name='f_rights_holder' size='60' class='line250' maxlength=60 value=\"" + item.getRightsHolder() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Access Rights");
  out.println("<input type='text' name='f_rights_access_rights' size='60' class='line250' maxlength=60 value=\"" + item.getRightsAccessRights() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
   
  /***************************
       Format
  ****************************/
  pageFormater.writeHelper(out, "Format", "helpers_no7.gif");
  pageFormater.writeTwoColTableHeader(out, "Resource Language");
  out.println("<select name='f_item_language' size='1' class='line250'" + disabled + ">");
  rset = item.getItemLanguage(stmt," ORDER BY sequence_no, description ");
  while (rset.next()) {
    item_language = rset.getString ("item_language_id");
    if(counter == 0)
      out.print("<option value=''>--- Select Resource Language ---</option>");
    out.print("<option value='" + item_language + "'");

    if (action.equals("add") && (item.getItemLanguage() == null || item.getItemLanguage().equals("")) &&
        rset.getString ("default_flag") != null && rset.getString ("default_flag").equals("Y")) {
      out.print(" selected");
    }
    else if (item.getItemLanguage() != null && item.getItemLanguage().equals(item_language)) {
      out.print(" selected");
    }
    out.print(">" + rset.getString ("item_language") + "</option>");
    counter ++;
  }
  out.println("</select>");
  counter = 0;
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Medium");
  out.println("<input type='text' name='f_format_medium' size='60' class='line250' maxlength=60 value=\"" + item.getFormatMedium() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Extent");
  out.println("<input type='text' name='f_format_extent' size='60' class='line250' maxlength=60 value=\"" + item.getFormatExtent() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Mimetype");
  out.println("<input type='text' name='f_format_mimetype' size='60' class='line250' maxlength=60 value=\"" + item.getFormatMimetype() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Format");
  out.println("<input type='text' name='f_format' size='60' class='line250' maxlength=60 value=\"" + item.getFormat() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
   /***************************
       Identifiers
  ****************************/
  pageFormater.writeHelper(out, "Identifiers", "helpers_no8.gif");
  pageFormater.writeTwoColTableHeader(out, "Resource URL");
  out.println("<input type='text' id='f_item_url' name='f_item_url' size='60' maxlength='2048' class='line250' value='" + item.getItemUrl() + "'" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  //BW additional URLs
/****************************************************************************
    pageFormater.writeTwoColTableHeader(out, "Additional URLs", 600); 
    //hidden field to store and pass urls between pages (comma delimited. Updated via javascript functions on the add remove links and onblur events)
  out.println("<input type='hidden' name='f_additional_urls' size='60' value=''>");  
  out.println("<span width='100%' name='additional_url_span'><input type='text' name='f_enter_additional_url' size='50' maxlength='2048' class='line250' onblur='addUrl($(this));' value=''" + readOnly + "><a href='#additional_url' onclick='addUrl($(\"input[name=f_enter_additional_url]\"))'> Add</a></span>");
  for (int i = 0; i < m_additional_urls.size(); i++){
  	out.println("<span name='url_line_"+i+"'><input type='text' name='f_additional_url_"+i+"' size='50' maxlength='2048' class='line250' onblur='' value='" + m_additional_urls.elementAt(i) + "'" + readOnly + "><a href='#additional_url' onclick='removeUrl("+i+")'> Remove</a>  </span>");
  }
  pageFormater.writeTwoColTableFooter(out);
**********************************************/  

  pageFormater.writeTwoColTableHeader(out, "Additional URLs", 600); 
  
  out.println("<input type='hidden' name='f_additional_urls' size='60' value=''>");    
  out.println("<table id='additional_url_span'>");
  out.println("<tr><td width='100%' > URL to additional websites or images - full URL must be provided</td></tr>");
  out.println("<tr><td width='100%' ><input type='text' name='f_enter_additional_url' size='50' maxlength='2048' class='line250' onblur='addUrl($(this));' value=''" + readOnly + "></td><td><a href='#additional_url' onclick='addUrl($(\"input[name=f_enter_additional_url]\"))'> Add</a></td></tr>");
  for (int i = 0; i < m_additional_urls.size(); i++){
  	out.println("<tr><td name='url_line_"+i+"'>"+
  	"<input type='text' id='f_additional_url_"+i+"' name='f_additional_url_"+i+"' size='50' maxlength='2048' class='line250 additional-urls' onblur='updateUrlList()' value='" + m_additional_urls.elementAt(i).toString().replaceAll("'", "&apos;") + "'" + readOnly + "></td>"+
  	"<td><a href='#additional_url' onclick='removeUrl("+i+")'> Remove</a> </td>"+
  	"</tr>");
  }
  out.println("</table>");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "ISBN 10");
  out.println("<input type='text' name='f_ident_isbn' size='60' class='line250' maxlength=60 value=\"" + item.getIdentIsbn() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "ISBN 13");
  out.println("<input type='text' name='f_ident_isbn_13' size='60' class='line250' maxlength=60 value=\"" + item.getIdentIsbn13() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  
  pageFormater.writeTwoColTableHeader(out, "International Standard Music Number");
  out.println("<input type='text' name='f_ident_ismn' size='60' class='line250' maxlength=60 value=\"" + item.getIdentIsmn() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "International Standard Serial Number");
  out.println("<input type='text' name='f_ident_issn' size='60' class='line250' maxlength=60 value=\"" + item.getIdentIssn() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Serial Resource and Contribution Number");
  out.println("<input type='text' name='f_ident_sici' size='60' class='line250' maxlength=60 value=\"" + item.getIdentSici() + "\"" + readOnly + ">");
  pageFormater.writeTwoColTableFooter(out);
  
  
  /***************************
       Event Association/s
  ****************************/
  pageFormater.writeHelper(out, "Event Association/s", "helpers_no9.gif");
  out.println("<a name='item_events' /></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_evlinks, "event", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "6",
                                               "item_events.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Event(s):",
                                               temp_display_info,
                                               1000,
                                               preview));


  /***************************
       Contributor Association/s
  ****************************/
  pageFormater.writeHelper(out, "Contributor Association/s", "helpers_no10.gif");
  out.println("<a name='item_contributors_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_conlinks, "contributor", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "8",
                                               "item_contributors.jsp?Creator=FALSE",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Contributor(s):",
                                               temp_display_info,
                                               1000,
                                               preview));

  /***************************
       Organisation Association/s
  ****************************/
  pageFormater.writeHelper(out, "Organisation Association/s", "helpers_no11.gif");
  out.println("<a name='item_organisations_link' /></a>");
  hidden_fields.clear(); 
  temp_display_info = item.generateDisplayInfo(m_item_orglinks, "organisation", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "9",
                                               "item_organisations.jsp?Creator=FALSE",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Organisations(s):",
                                               temp_display_info,
                                               1000,
                                               preview));

  /***************************
       Venue Association/s
  ****************************/
  pageFormater.writeHelper(out, "Venue Association/s", "helpers_no12.gif");
  out.println("<a name='item_venues_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_venuelinks, "venue", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "7",
                                               "item_venues.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Venue(s):",
                                               temp_display_info,
                                               1000,
                                               preview));

 /***************************
       Work Association/s
  ****************************/
  pageFormater.writeHelper(out, "Work Association/s", "helpers_no13.gif");
  out.println("<a name='item_work_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_worklinks, "work", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "12",
                                               "item_work.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Work(s):",
                                               temp_display_info,
                                               1000,
                                               preview));


  /***************************
       Genre Association/s
  ****************************/
  pageFormater.writeHelper(out, "Genre Association/s", "helpers_no14.gif");
  out.println("<a name='item_second_genre_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_secgenrelinks, "genre", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "7",
                                               "item_sec_genre.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Genre(s):",
                                               temp_display_info,
                                               1000,
                                               preview));
 
  /***************************
       Content Indicator Association/s
  ****************************/
  pageFormater.writeHelper(out, "Subjects Association/s", "helpers_no15.gif");
  out.println("<a name='item_content_indicator_link'/></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_contentindlinks, "contentInd", stmt);
  out.println (htmlGenerator.displayLinkedItem("",
                                               "12",
                                               "item_content_indicator.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Subjects:",
                                               temp_display_info,
                                               1000,
                                               preview));


  /***************************
       Resource Association/s
  ****************************/
  pageFormater.writeHelper(out, "Resource Association/s", "helpers_no16.gif");
  out.println("<a name='item_item_link' ></a>");
  hidden_fields.clear();
  temp_display_info = item.generateDisplayInfo(m_item_itemlinks, "item", stmt);
  
  for(int i=0; i < m_item_itemlinks.size(); i++) {
    
    ItemItemLink itemItemLink = m_item_itemlinks.elementAt(i);
    RelationLookup lookUpCode = new RelationLookup(db_ausstage);
    
    boolean isParent = itemid.equals(itemItemLink.getItemId());
    
    lookUpCode.load(Integer.parseInt(itemItemLink.getRelationLookupId()));
    String tempString = (String)temp_display_info.elementAt(i);
    tempString = ((isParent)? lookUpCode.getParentRelation() : lookUpCode.getChildRelation()) + ": " + tempString;
    temp_display_info.removeElementAt(i);
    temp_display_info.insertElementAt(tempString, i);
  }
  
  
  out.println (htmlGenerator.displayLinkedItem("",
                                               "6",
                                               "item_item.jsp",
                                               "item_addedit_form",
                                               hidden_fields,
                                               "Associated with Resource(s):",
                                               temp_display_info,
                                               1000,
                                               preview));
 
  
  /***************************
       Data Entry Information
  ****************************/
  pageFormater.writeHelper(out, "Data Entry Information", "helpers_no17.gif");
  pageFormater.writeTwoColTableHeader(out, "Resource ID:");
  out.print(item.getItemId());
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Created By User:");
  out.print(item.getEnteredByUser());
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Date Created:");
  out.print(common.formatDate(item.getEnteredDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);

  pageFormater.writeTwoColTableHeader(out, "Updated By User:");
  out.print(item.getUpdatedByUser());
  pageFormater.writeTwoColTableFooter(out);
  
  pageFormater.writeTwoColTableHeader(out, "Date Updated:");
  out.print(common.formatDate(item.getUpdatedDate(), AusstageCommon.DATE_FORMAT_STRING));
  pageFormater.writeTwoColTableFooter(out);

 

  out.print("<br><br><br><br>");
  pageFormater.writePageTableFooter (out);
  if(!action.equals("") && action.equals("preview"))
    pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "", "", "", "");
  else 
    pageFormater.writeButtons(out, "back", "prev.gif", "welcome.jsp", "cross.gif", "submit", "next.gif");
  pageFormater.writeFooter(out);

  // reset/set the state of the ITEM object
  if (action.equals("") || !(action.equals("preview"))){
    session.setAttribute("item",item);
  }

%>

</form>
</div>
<script language="javascript">

  var url_count = 0;
   
  $(document).ready(function(){
    $("input[name*='f_additional_url_']").each(function(index){
      url_count++;
    });
    updateUrlList();
    if(!showItemArticle()){
	 $('#item_article_container').hide();
    }
    //https://summernote.org/
    //set up the WYSIWYG editor
    // create Editor from textarea HTML element with default set of tools
    $("#item_article").summernote({width:900, height:400, 
    				  // toolbar
				      toolbar: [
				        ['style', ['style']],
				        ['font', ['bold', 'italic', 'underline','strikethrough', 'superscript', 'subscript', 'clear']],
				        //['fontname', ['fontname']],
				        //['fontsize', ['fontsize']],
				        //['color', ['color']],
				        ['para', ['ul', 'ol', 'paragraph']],
				        //['height', ['height']],
	   			        ['insert',['link','table','picture','video','hr']],
  				        ['misc',['undo', 'redo', 'help']]
      					],	
    			          callbacks: {
        				 onPaste: function (e) {
            					var bufferText = ((e.originalEvent || e).clipboardData || window.clipboardData).getData('Text');
           					 e.preventDefault();
            					 document.execCommand('insertText', false, bufferText);
				        },
   					 onBlur: function() {
						setItemArticle();}
				  }/**,
   				  toolbar: [*/
	  			  // [groupName, [list of button]]
				    /**['style', ['style','bold', 'italic', 'underline','strikethrough', 'clear']],
				    ['font', ['superscript', 'subscript']],
				    ['fontsize', ['fontsize']],
				    ['color', ['color']],
				    ['para', ['ul', 'ol', 'paragraph']],
				    ['height', ['height']],
				    ['insert',['link','table','picture','video','hr']],
				    ['misc',['undo', 'redo', 'help']]*/
/**	  	]*/
	  });	
  });
  $('.dropdown-toggle').dropdown();
  
  
  	 

  function addUrl(field_to_check){
    if (field_to_check.val()!=""){
      if (validateUrl(field_to_check)){
        $('#additional_url_span tr:last').after("<tr><td name='url_line_"+url_count+"'><input type='text' id='f_additional_url_"+url_count+"' name='f_additional_url_"+url_count+"' size='50' maxlength='2048' class='line250 additional-urls' value="
        					+field_to_check.val()+" ></td><td><a href='#additional_url' onclick='removeUrl("+url_count+")'> Remove</a></td>");
        field_to_check.val("");
        url_count++;
        updateUrlList();
      }
    }
    return false;
  }
  
  function removeUrl(i){
    console.log("remove the current text field and link. using id."+i);
    $("[name=url_line_"+i+"]").parent('tr').remove();
    updateUrlList();
  }  

  
  function updateUrlList(){
  console.log("updating url list");
    var delimited_list = "";
    $("input[name*='f_additional_url_']").each(function(index){ 
      if($(this).val()!="") {delimited_list += $(this).val()+",";} 
    });
    $("input[name='f_additional_urls']").val(delimited_list);
    console.log(delimited_list);

  }

  /* Function : beforeSubmit() calls all required functions - data validation etc before submitting*/
  function beforeSubmit(){
  	setItemArticle();
  	return checkManditoryFields();
  }

  function setItemArticle(){
  	if(showItemArticle()&& ($('#item_article').summernote('isEmpty')== false)){
  		//here we need to check that the user has entered anything.
  		//Summer note even when empty will contain html tags. So we need to remove them to check if there is any other data.  - if there is then set otherwise dont set. 
  		
	  	$('#f_item_article').val($('#item_article').summernote('code'));
  	}else{
  	  	$('#f_item_article').val("");
  	}

  }

  function checkManditoryFields(){
  	var validated = true;
  	
    if(document.item_addedit_form.f_item_type.value == null ||
       document.item_addedit_form.f_item_type.value == "" || 
       document.item_addedit_form.f_item_sub_type.value == null ||
       document.item_addedit_form.f_item_sub_type.value == "" ||
       document.item_addedit_form.f_item_sub_type.value == "0" ||
       //If the value is zero it means the subtype has been reset by the user changing the type and havent specified a subtype.
       document.item_addedit_form.f_title.value == null ||
       document.item_addedit_form.f_title.value == "") {

       alert("Please make sure all mandatory fields (*) are filled in");
       validated = false;
    }
    // adding or editing
    if (!checkCharacterDates ()) {
       validated = false;
      }
    if (!validateUrl($('#f_item_url'))){
       validated = false;
    }  
    var additionalUrls = $('.additional-urls');
    for (var i = 0; i < additionalUrls.length; i++){
      var urlId = additionalUrls[i].id;
      if (!validateUrl($('#'+urlId))){
       validated = false;
      }    
    }
    return validated;
  }

  

  
  function checkCharacterDates() {
    var ret_val = true;

    if (!checkDate("Date Created",
                   document.item_addedit_form.f_create_date_day.value,
                   document.item_addedit_form.f_create_date_month.value,
                   document.item_addedit_form.f_create_date_year.value)) {
      return(false);
    }
    
    if (!checkDate("Date of Copyright",
                   document.item_addedit_form.f_copyright_date_day.value,
                   document.item_addedit_form.f_copyright_date_month.value,
                   document.item_addedit_form.f_copyright_date_year.value)) {
      return(false);
    }
      
    if (!checkDate("Date of Issued",
                   document.item_addedit_form.f_issued_date_day.value,
                   document.item_addedit_form.f_issued_date_month.value,
                   document.item_addedit_form.f_issued_date_year.value)) {
      return(false);
    }
    
    if (!checkDate("Date Accessioned",
                   document.item_addedit_form.f_accessioned_date_day.value,
                   document.item_addedit_form.f_accessioned_date_month.value,
                   document.item_addedit_form.f_accessioned_date_year.value)) {
      return(false);
    }
    if (!checkDate("Date Terminated",
                   document.item_addedit_form.f_terminated_date_day.value,
                   document.item_addedit_form.f_terminated_date_month.value,
                   document.item_addedit_form.f_terminated_date_year.value)) {
      return(false);
    }
    return(ret_val);
  }
  
  function checkDate(fieldName, day, month, year) {
    errorMessage = "Error in " + fieldName + " field. ";

    if (day == "  " || day == " ")
      day = "";
    if (month == "  " || month == " ")
      month = "";
    if (year == "  " || year == " ")
      year = "";
    
   if(day != "" && month == "") {
      alert(errorMessage + "If month is blank then day must be blank.");
      return false;
    }

    if(month != "" && year == "") {
      alert(errorMessage + "If year is blank then month must be blank.");
      return false;
    }

    if(day != "") {
      if (!checkValidDate(day, month, year)) {
        alert(errorMessage + "Not a valid date. ");
        return false;
      }
      else
        return true;
    }
    
    if(month != "") {
      if (!isInteger (month))
        return false;
        
      if (month > 12 || month < 0) {
        alert(errorMessage + "Not a valid month.");
        return false;
      }
    }
    
    if(year != "") {
      if (!isInteger (year))
        return false;
        
      if (year > 3000 || year < 1700) {
        alert(errorMessage + "Not a valid year.");
        return false;
      }
    }
    return true;
  }
  
  //when resource types change, check - 
  function resourceChanged(){
  	if(showItemArticle()){
  	  $('#item_article_container').slideDown();
	  //then show full text article field.  	
  	} else {
	  //ELSE clear and hide full text article field.  
	  $('#item_article_container').slideUp();	
  	}
  }
  
  // should we display full text article field?
  function showItemArticle(){
	var resourceType = $('#f_item_type option:selected').text();
  	var resourceSubType = $('#f_item_sub_type option:selected').text();
	//if resource type = TEXT and resource subtype == ARTICLE
  	if(resourceType.toUpperCase() == 'TEXT' && resourceSubType.toUpperCase() == 'ARTICLE'){
  		return true;	
  	}
  	//if resource type = MOVINGIMAGE
  	else if (resourceType.toUpperCase() == 'MOVINGIMAGE'){
  		return true;
  	}
  	else{
  		return false;
  	}
  }


</script>


<%
stmt.close();
db_ausstage.disconnectDatabase();
%><jsp:include page="../templates/admin-footer.jsp" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Item"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.RelationLookup, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

<%@ include file="../../public/common.jsp"%>

<div class='record' style="margin: 0px; padding-bottom: 0em;">

						<%
						ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
						db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
						ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage_for_drill);
						
						List<String> groupNames = new ArrayList();	
						if (session.getAttribute("userName")!= null) {
							admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
						  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
						}

						CachedRowSet crset          = null;
						ResultSet    rset;
						Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
						String formatted_date       = "";
						String item_id              = request.getParameter("itemid");
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
						item_itemlinks  = item.getItemItemLinks();
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
						
						%>
						<table class='record-table' style="margin-top: 0px;margin-bottom: 0px;">
						
						<%//Resource Sub Type (Label is Resouce)
						if (item_type != null) {
						%>
							<tr>
								<th class='record-label item-light  bold'>Resource</th>
								
								<td class='record-value' colspan='2'><%=item_type.getShortCode()%><%=(item_sub_type != null)?": " + item_sub_type.getShortCode():"" %></td>
							</tr>  
	
						<%
						}
						
						
						
	
						//Alternative Title
						if (hasValue(item.getTitleAlternative())) {
						%>
							<tr>
								<th class='record-label item-light  bold'>Alternative Title</th>
								
								<td class='record-value bold' colspan='2'><%=item.getTitleAlternative()%></td>
							</tr>  
						<%
						}
						
						// Creator Contributor
						%>

						<%
						if (contributorCreator != null) {
						%>
						<tr>
							<th class='record-label item-light '>Creator Contributors</th>
							
							<td class='record-value'  colspan='2'>
								<ul>
									<%
									for (ItemContribLink itemContribLink : (Vector <ItemContribLink>) item_creator_conlinks) {
										
										String name = "";
										String contribId;
										String functionId;
										String functionDesc = "";
										LookupCode lookups = new LookupCode(db_ausstage_for_drill);
										lookups.load(Integer.parseInt(itemContribLink.getFunctionId()));
										contribId  = itemContribLink.getContribId();
						
										// use the contribId to load a new contributor each time:
										contributorCreator.load(new Integer(contribId).intValue());
										contribId = "" + contributorCreator.getId();
										name = contributorCreator.getName() + " " + contributorCreator.getLastName();
										
										%>	
										<li>
												<a href="/pages/contributor/<%=contribId%>"><%=name%></a><%=hasValue(lookups.getDescription())?", " +  lookups.getDescription():"" %>
										</li>
										<%
									}
								%>
								</ul>
							</td>
						</tr>
						<%
						}
						%>
						
						
						<%
						// Creator Organisation
						if (organisationCreator != null && item_creator_orglinks.size() > 0) {
						%>
							<tr>
								<th class='record-label item-light '>Creator Organisations</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%	
									// this link is weird the Item Org Link is in the Vector
									for (ItemOrganLink itemOrganLink : (Vector <ItemOrganLink>) item_creator_orglinks) {
										String orgaId = itemOrganLink.getOrganisationId();        
										// use the orgaId to load a new organisation each time:
										organisationCreator.load(new Integer(orgaId).intValue());
										%>
										<li>
										
												<a href="/pages/organisation/<%=organisationCreator.getId()%>">
													<%=organisationCreator.getName()%>
												</a>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						%>
						
						<%
						//Abstract/Description
						if (hasValue(item.getDescriptionAbstract())) {
						%>
							<tr >
								<th class='record-label item-light '>Abstract/Description</th>
								
								<td class='record-value' colspan='2' valign="top">
								<%=item.getDescriptionAbstract()%>
									
								</td>
							</tr>
						<%
						}
						
						//  SECONDARY GENRE //    
						if (secondaryGenre != null && item_secgenrelinks.size() > 0) {
						%>
							<tr>
								<th class='record-label item-light '>Genre</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (String secGenreId : (Vector<String>) item_secgenrelinks) {
										secondaryGenre.loadLinkedProperties(new Integer(secGenreId).intValue());
										%>
										<li>
										
												<a href="/pages/genre/<%=secondaryGenre.getId()%>">
													<%=secondaryGenre.getName()%>
												</a>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						// Content Indicator
						if (contentIndicator != null && item_contentindlinks.size() > 0) {
							// in the item_contentindlinks vector we only have the content indicator id 
							// to get the content indicator name -> load a content indicator object
							%>
							<tr>
								<th class='record-label item-light '>Subjects</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (String contentIndId : (Vector<String>) item_contentindlinks) {
										// load content indicator from id
										contentIndicator.load(new Integer(contentIndId).intValue());
										%>
										<li>
										
												<a href="/pages/subject/<%=contentIndicator.getId()%>">       
													<%=contentIndicator.getName()%>
												</a>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
							<%
						}

						// Work
						if (work != null && item_worklinks.size() > 0) {
							// in the item_worklinks vector we only have the work id 
							// to get the work name -> load a work object
							%>
							<tr >
								<th class='record-label item-light '>Related Works</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (String workId : (Vector<String>) item_worklinks) {
										// load work from id
										work.load(new Integer(workId).intValue());
										%>
										<li>
										
												<a href="/pages/work/<%=work.getId()%>">       
													<%=work.getWorkTitle()%>
												</a>
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
							<%
						}
						
						// Resource
						if (assocItem != null && item_itemlinks.size() > 0) {
							// in the item_itemlinks vector we only have the work id 
							// to get the item name -> load an item object
							%>
							<tr>
								<th class='record-label item-light '>Related Resources</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (ItemItemLink itemItemLink : (Vector <ItemItemLink>) item_itemlinks) {
										boolean isParent = item_id.equals(itemItemLink.getItemId());
										
										assocItem.load(new Integer((isParent) ? itemItemLink.getChildId() : itemItemLink.getItemId()).intValue());
										
										RelationLookup lookUpCode = new RelationLookup(db_ausstage_for_drill);
										lookUpCode.load(Integer.parseInt(itemItemLink.getRelationLookupId()));
										%>
										<li>
										
											<%if (assocItem.getItemArticle() != null && !assocItem.getItemArticle().equals("")){%>
											<div style='width:20px; position:relative; float:left'>
											<!-- using bootstrap modal approach for this.-->
											
										      	<span class='glyphicon glyphicon-eye-open clickable' data-toggle="modal" data-target='#article<%=assocItem.getItemId()%><%=item.getItemId()%>'></span>
	 										<div id='article<%=assocItem.getItemId()%><%=item.getItemId()%>' class="modal fade" role="dialog">
										  		<div class="modal-dialog wysiwyg" >
												    <!-- Modal content-->
												    <div class="modal-content">
													<div class="modal-header">
												          <button type="button" class="close" data-dismiss="modal">&times;</button>
												          <h4 class="modal-title"><%=assocItem.getCitation()%></h4>
												        </div>		      
												        <div class="modal-body item-article-container">
														<%=assocItem.getItemArticle()%>
		      											</div>
		      											<div class="modal-footer">
													        <button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
										 		        </div>

												    </div>	
	
												  </div>
												</div>
												</div>
											<%}
											%>
											
												<%=(isParent)? lookUpCode.getParentRelation() : lookUpCode.getChildRelation() %>
												<a href="/pages/resource/<%=assocItem.getItemId()%>">       
													<%=assocItem.getCitation()%>
												</a>
												<%
													if((isParent) && !itemItemLink.getNotes().equals("")) out.print(" - "+itemItemLink.getNotes());
												  	if((!isParent) && !itemItemLink.getChildNotes().equals("")) out.print(" - "+itemItemLink.getChildNotes());
												  %>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
							<%
						}
						
						
						//Events
						if (event != null && item_evlinks.size() > 0) {
						%>
							<tr>
								<th class='record-label item-light '>Related Events</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (String itemEvLink : (Vector<String>) item_evlinks) {
										rset = event.getEventsByItem(Integer.parseInt(itemEvLink), stmt);
										if (rset != null) {
											while(rset.next()){
												%>
												<li>
												
														<a href="/pages/event/<%=rset.getString("eventid")%>">
															<%=rset.getString("event_name")%></a><%if(hasValue(rset.getString("venue_name"))) out.print(", " + rset.getString("venue_name"));
															if(hasValue(rset.getString("suburb"))) out.print(", " + rset.getString("suburb"));
															if(hasValue(rset.getString("state")) && (!rset.getString("state").equals("O/S"))) out.print(", " + rset.getString("state"));
															if (hasValue(formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE"))))
											out.print(", " + formatDate(rset.getString("DDFIRST_DATE"),rset.getString("MMFIRST_DATE"),rset.getString("YYYYFIRST_DATE")));
											
														%>
												
												</li>
												<%
											}
										}
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						
						// Other Contributor
						if(contributor != null && item_conlinks.size() > 0) {
						%>
							<tr>
								<th class='record-label item-light '>Related Contributors</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (ItemContribLink itemContribLink : (Vector<ItemContribLink>) item_conlinks) {
										String contribId = itemContribLink.getContribId();
										String name = "";
										// use the contribId to load a new organisation each time:
										contributor.load(new Integer(contribId).intValue());
										contribId = "" + contributor.getId();
										name = contributor.getName() + " " + contributor.getLastName();
										%>
										<li>
										
												<a href="/pages/contributor/<%=contribId%>">
													<%=name%>
												</a>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						// Other Organisation
						if (organisation != null && item_orglinks.size() > 0) {
						%>
							<tr>
								<th class='record-label item-light '>Related Organisation</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									for (ItemOrganLink itemOrganLink : (Vector <ItemOrganLink>) item_orglinks) {
										String orgaId = itemOrganLink.getOrganisationId();
										// use the orgaId to load a new organisation each time:
										organisation.load(new Integer(orgaId).intValue());
										%>
										<li>
										
												<a href="/pages/organisation/<%=organisation.getId()%>">
													<%=organisation.getName()%>
												</a>
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						
						//Venues
						if (venue != null && item_venuelinks.size() > 0) {
							%>
							<tr>
								<th class='record-label item-light '>Related Venues</th>
								
								<td class='record-value' colspan='2'>
									<ul>
									<%
									// in the item_venuelinks vector we only have the venue id 
									// to get the venue name -> load a venue object
									for (String venueId : (Vector<String>) item_venuelinks) {
										venue.load(new Integer(venueId).intValue());
										%>
										<li>
										
												<a href="/pages/venue/<%=venue.getVenueId()%>"><%=venue.getName()%></a>, <%=venue.getSuburb()%>, <%=state.getName(Integer.parseInt(venue.getState()))%> 
										
										</li>
										<%
									}
									%>
									</ul>
								</td>
							</tr>
						<%
						}
						//Source
						if (hasValue(item.getSourceCitation())) {
						%>
							<tr>
								<th class='record-label item-light '>Source</th>
								
								<td class='record-value' colspan='2'>
									
												<a href="/pages/resource/<%=item.getSourceId()%>">
													<%=item.getSourceCitation()%>
												</a>
								</td>
							</tr>
						<%
						}
						// Item URL
						if (hasValue(item.getItemUrl())){
						%>
							<tr>
								<th class='record-label item-light '>Item URL</th>
								<td class='record-value' colspan='2'>
								<a href="<%=item.getItemUrl()%>" >
									<%=item.getItemUrl()%>
									</a>	
								</td>
							</tr>
						<%
						}
						
						//Publisher
						if (hasValue(item.getPublisher())) {
						%>
							<tr >
								<th class='record-label item-light '>Publisher</th>
								
								<td class='record-value' colspan='2'>
									
												<%=item.getPublisher()%>
									
								</td>
							</tr>
						<%
						}
						
						// publication location
						if (hasValue(item.getPublisherLocation())) {
						%>
							<tr >
								<th class='record-label item-light '>Publisher Location</th>
								
								<td class='record-value' colspan='2'>
									
												<%=item.getPublisherLocation()%>
									
								</td>
							</tr>
						<%
						}
						//Volume
						if (hasValue(item.getVolume())) {
						%>
							<tr >
								<th class='record-label item-light '>Volume</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getVolume()%>
								</td>
							</tr>
						<%
						}
						
						//Issue
						if (hasValue(item.getIssue())) {
						%>
							<tr >
								<th class='record-label item-light '>Issue</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIssue()%>
								</td>
							</tr>
						<%
						}
						
						//Page
						if (hasValue(item.getPage())) {
						%>
							<tr >
								<th class='record-label item-light '>Page</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getPage()%>
								</td>
							</tr>
						<%
						}
						//Date Issued
						if (!formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()).equals("")) {
						%>
							<tr>
								<th class='record-label item-light '>Date Issued</th>
								
								<td class='record-value' colspan='2'>
									
												<%=formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate())%>
									
								</td>
							</tr>
						<%
						}
						
						// Date Created
						if (!formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()).equals("")) { 
							%>
							<tr>
								<th class='record-label item-light '>Date Created</th>
								
								<td class='record-value' colspan='2'>
									
												<%=formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate())%>
									
								</td>
							</tr>
						<%
						}
						
						//Date of Copyright
						if (!formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()).equals("")) {
						%>
							<tr>
								<th class='record-label item-light '>Date Of Copyright</th>
								
								<td class='record-value' colspan='2'>
									
												<%=formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate())%>
									
								</td>
							</tr>
						<%
						}
						//Date Accessioned
						if (!formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()).equals("")) {
							%>
							<tr>
								<th class='record-label item-light '>Date Accessioned</th>
								
								<td class='record-value' colspan='2'>
									
												<%=formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate())%>
									
								</td>
							</tr>
						<%
						}
						
						//Date Terminated
						if (!formatDate(item.getDdTerminatedDate(), item.getMmTerminatedDate(), item.getYyyyTerminatedDate()).equals("")) {
						%>
							<tr>
								<th class='record-label item-light '>Date Terminated</th>
								
								<td class='record-value' colspan='2'>
									
												<%=formatDate(item.getDdTerminatedDate(), item.getMmTerminatedDate(), item.getYyyyTerminatedDate())%>
									
								</td>
							</tr>
						<%
						}
						//Date Notes
						if (hasValue(item.getDateNotes())) {
						%>
							<tr>
								<th class='record-label item-light '>Date Notes</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getDateNotes()%>
								</td>
							</tr>
						<%
						}
						//Catologue Id
						if (hasValue(item.getCatalogueId())) {
						%>
							<tr>
								<th class='record-label item-light '>Catalogue ID</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getCatalogueId()%>
								</td>
							</tr>
						<%
						}
						//Holding Institution
						String institutionName = "";
						
						if (hasValue(item.getInstitutionId())) {
							Organisation holdingOrgan = new Organisation(db_ausstage_for_drill);
							holdingOrgan.load(Integer.parseInt(item.getInstitutionId()));
							institutionName = holdingOrgan.getName();
						}
						
						if (hasValue(institutionName)) {
						%>
							<tr>
								<th class='record-label item-light '>Holding Institution</th>
								
								<td class='record-value' colspan='2'>
									<a href="/pages/organisation/<%=item.getInstitutionId()%>" valign="top"><%=institutionName%></a>
								</td>
							</tr>
						<%
						}
						
						//Rights
						if (hasValue(item.getRights())) {
						%>
							<tr>
								<th class='record-label item-light '>Rights</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getRights()%>
								</td>
							</tr>
						<% 
						}
						
						//Rights Holder
						if (hasValue(item.getRightsHolder())) {
						%>
							<tr>
								<th class='record-label item-light '>Rights Holder</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getRightsHolder()%>
								</td>
							</tr>
						<% 
						}
						
						//Access Rights
						if (hasValue(item.getRightsAccessRights())) {
						%>
							<tr>
								<th class='record-label item-light '>Access Rights</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getRightsAccessRights()%>
								</td>
							</tr>
						<% 
						}
						
						//Language
						if (hasValue(item.getItemLanguage())) {
						%>
							<tr>
								<th class='record-label item-light '>Language</th>
								
								<td class='record-value' colspan='2'>
									<%=language.getDescription()%>
								</td>
							</tr>
						<% 
						}
						
						//Medium
						if (hasValue(item.getFormatMedium())) {
						%>
							<tr>
								<th class='record-label item-light '>Medium</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getFormatMedium()%>
								</td>
							</tr>
						<% 
						}
						
						//Extent
						if (hasValue(item.getFormatExtent())) {
						%>
							<tr>
								<th class='record-label item-light '>Extent</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getFormatExtent()%>
								</td>
							</tr>
						<% 
						}
						
						//Mimetype
						if (hasValue(item.getFormatMimetype())) {
						%>
							<tr>
								<th class='record-label item-light '>Mimetype</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getFormatMimetype()%>
								</td>
							</tr>
						<% 
						}
						
						//Format
						if (hasValue(item.getFormat())) {
						%>
							<tr>
								<th class='record-label item-light '>Format</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getFormat()%>
								</td>
							</tr>
						<% 
						}
						
						//ISBN
						if (hasValue(item.getIdentIsbn())) {
						%>
							<tr>
								<th class='record-label item-light '>ISBN 10</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIdentIsbn()%>
								</td>
							</tr>
						<% 
						}
						//ISBN 13
						if (hasValue(item.getIdentIsbn13())) {
						%>
							<tr>
								<th class='record-label item-light '>ISBN 13</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIdentIsbn13()%>
								</td>
							</tr>
						<% 
						}
						
						//ISMN
						if (hasValue(item.getIdentIsmn())) {
						%>
							<tr>
								<th class='record-label item-light '>ISMN</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIdentIsmn()%>
								</td>
							</tr>
						<% 
						}
						
						//ISSN
						if (hasValue(item.getIdentIssn())) {
						%>
							<tr>
								<th class='record-label item-light '>ISSN</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIdentIssn()%>
								</td>
							</tr>
						<% 
						}
						
						//SRCN
						if (hasValue(item.getIdentSici())) {
						%>
							<tr>
								<th class='record-label item-light '>SRCN</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getIdentSici()%>
								</td>
							</tr>
						<% 
						}
						
						//Comments
						if (hasValue(item.getComments())) {
						%>
							<tr>
								<th class='record-label item-light '>Comments</th>
								
								<td class='record-value' colspan='2'>
									
												<%=item.getComments()%>
									
								</td>
							</tr>
						<%
						}
						
						//Citation
						if (hasValue(item.getCitation())) {
						%>
							<tr>
								<th class='record-label item-light '>Citation</th>
								
								<td class='record-value' colspan='2'>
												<%=item.getCitation()%>
								</td>
							</tr>
						<%
						}
						
						//Resource Identifier
						if (hasValue(item.getItemId())) {
						%>
							<tr>
								<th class='record-label item-light '>Resource Identifier</th>
								
								<td class='record-value' colspan='2'>
									<%=item.getItemId()%>
								</td>
							</tr>
						<%
						}
						
						// close statement
						stmt.close();
						%>
						
					</table>

</div>


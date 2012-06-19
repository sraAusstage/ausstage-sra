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

<div class='record'>

						<%
						ausstage.Database          db_ausstage_for_drill       = new ausstage.Database ();
						db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
						
						List<String> groupNames = new ArrayList();	
						if (session.getAttribute("userName")!= null) {
							CmsJspActionElement cms = new CmsJspActionElement(pageContext,request,response);
							CmsObject cmsObject = cms.getCmsObject();
							List<CmsGroup> userGroups = cmsObject.getGroupsOfUser(session.getAttribute("userName").toString(), true);
							for(CmsGroup group:userGroups) {
								groupNames.add(group.getName());
							}
						}

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
						
						%>
						<table class='record-table'>
						<%
						//Resource Sub Type (Label is Resouce Type)
						if (item_type != null) {
						%>
							<tr>
								<th class='record-label b-153'><img src='../../../resources/images/icon-resource.png' class='box-icon'>Type</th>
								
								<td class='record-value'>
									<%=item_type.getShortCode()%><%=(item_sub_type != null)?": " + item_sub_type.getShortCode():"" %>
									<%
									if (groupNames.contains("Administrators") || groupNames.contains("Resource Editor"))
									out.println("[<a class='editLink' target='_blank' href='/custom/item_addedit.jsp?action=edit&f_itemid=" + item.getItemId() + "'>Edit</a>]");
									%>
								</td>
								<td rowspan=3 valign='top>
								<%
								if (displayUpdateForm) {
								displayUpdateForm(item_id, "Resource", item.getTitle(), out,
								request, ausstage_search_appconstants_for_drill);
								}
								%>
								</td>
							</tr>
						<%
						}
	
						//Title
						if (hasValue(item.getTitle())) {
						%>
							<tr>
								<th class='record-label b-153 bold' valign="top">Title</th>
								
								<td class='record-value bold'><%=item.getTitle()%></td>
							</tr>
						<%
						}
	
						//Alternative Title
						if (hasValue(item.getTitleAlternative())) {
						%>
							<tr>
								<th class='record-label b-153 bold'>Alternative Title</th>
								
								<td class='record-value bold'><%=item.getTitleAlternative()%></td>
							</tr>  
						<%
						}
						
						// Creator Contributor
						%>
						<tr>
						<%
						if (contributorCreator != null) {
						%>
							<th class='record-label b-153'>Creator Contributors</th>
							
							<td class='record-value'>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<%
									for (ItemContribLink itemContribLink : (Vector <ItemContribLink>) item_creator_conlinks) {
										String name = "";
										String contribId;
										String functionId;
										String functionDesc = "";
										LookupCode lookups = new LookupCode(db_ausstage_for_drill);
						
										contribId  = itemContribLink.getContribId();
						
										// use the contribId to load a new contributor each time:
										contributorCreator.load(new Integer(contribId).intValue());
										contribId = "" + contributorCreator.getId();
										name = contributorCreator.getName() + " " + contributorCreator.getLastName();
										
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/contributor/?id=<%=contribId%>">
													<%=name%>
												</a><%=hasValue(contributorCreator.getContFunctPreffTermByContributor(contribId))?", " +  contributorCreator.getContFunctPreffTermByContributor(contribId):"" %>
											</td>
										</tr>
										<%
									}
								%>
								</table>
							</td>
						<%
						}
						%>
						</tr>
						
						<%
						// Creator Organisation
						if (organisationCreator != null && item_creator_orglinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Creator Organisations</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%	
									// this link is weird the Item Org Link is in the Vector
									for (ItemOrganLink itemOrganLink : (Vector <ItemOrganLink>) item_creator_orglinks) {
										String orgaId = itemOrganLink.getOrganisationId();        
										// use the orgaId to load a new organisation each time:
										organisationCreator.load(new Integer(orgaId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>"  valign="top">
												<a href="/pages/organisation/?id=<%=organisationCreator.getId()%>">
													<%=organisationCreator.getName()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
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
								<th class='record-label b-153'>Abstract/Description</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="<%=baseCol3Wdth%>" valign="top"><%=item.getDescriptionAbstract()%></td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//  SECONDARY GENRE //    
						if (secondaryGenre != null && item_secgenrelinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Genre</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (String secGenreId : (Vector<String>) item_secgenrelinks) {
										secondaryGenre.loadLinkedProperties(new Integer(secGenreId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/genre/?id=<%=secondaryGenre.getId()%>">
													<%=secondaryGenre.getName()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
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
								<th class='record-label b-153'>Subjects</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (String contentIndId : (Vector<String>) item_contentindlinks) {
										// load content indicator from id
										contentIndicator.load(new Integer(contentIndId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/subject/?id=<%=contentIndicator.getId()%>">       
													<%=contentIndicator.getName()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
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
								<th class='record-label b-153'>Related Works</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (String workId : (Vector<String>) item_worklinks) {
										// load work from id
										work.load(new Integer(workId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/work/?id=<%=work.getId()%>">       
													<%=work.getWorkTitle()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
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
								<th class='record-label b-153'>Related Resources</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (ItemItemLink itemItemLink : (Vector <ItemItemLink>) item_itemlinks) {
										assocItem.load(new Integer(itemItemLink.getChildId()).intValue());
										
										LookupCode lookUpCode = new LookupCode(db_ausstage_for_drill);
										lookUpCode.load(Integer.parseInt(itemItemLink.getFunctionId()));
										%>
										<tr>
											<td valign="top">
												<%=lookUpCode.getDescription() %>
												<a href="/pages/resource/?id=<%=assocItem.getItemId()%>">       
													<%=assocItem.getCitation()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
								</td>
							</tr>
							<%
						}
						
						//Events
						if (event != null && item_evlinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Related Events</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (String itemEvLink : (Vector<String>) item_evlinks) {
										rset = event.getEventsByItem(Integer.parseInt(itemEvLink), stmt);
										if (rset != null) {
											while(rset.next()){
												%>
												<tr>
													<td width="<%=secCol1Wdth%>" valign="top">
														<a href="/pages/event/?id=<%=rset.getString("eventid")%>">
															<%=rset.getString("event_name")%>
														</a><%
														out.print(rset.getString("venue_name") + ", " + rset.getString("suburb") + ", " + rset.getString("state") + ", ");
														out.print(formatDate(rset.getString("Ddfirst_date"),rset.getString("Mmfirst_date"),rset.getString("Yyyyfirst_date")));
														%>
													</td>
												</tr>
												<%
											}
										}
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}
						
						// Other Contributor
						if(contributor != null && item_conlinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Related Contributors</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (ItemContribLink itemContribLink : (Vector<ItemContribLink>) item_conlinks) {
										String contribId = itemContribLink.getContribId();
										String name = "";
										// use the contribId to load a new organisation each time:
										contributor.load(new Integer(contribId).intValue());
										contribId = "" + contributor.getId();
										name = contributor.getName() + " " + contributor.getLastName();
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/contributor/?id=<%=contribId%>">
													<%=name%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}
						
						// Other Organisation
						if (organisation != null && item_orglinks.size() > 0) {
						%>
							<tr>
								<th class='record-label b-153'>Related Organisation</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									for (ItemOrganLink itemOrganLink : (Vector <ItemOrganLink>) item_orglinks) {
										String orgaId = itemOrganLink.getOrganisationId();
										// use the orgaId to load a new organisation each time:
										organisation.load(new Integer(orgaId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/organisation/?id=<%=organisation.getId()%>">
													<%=organisation.getName()%>
												</a>
											</td>
										</tr>
										<%
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Venues
						if (venue != null && item_venuelinks.size() > 0) {
							%>
							<tr>
								<th class='record-label b-153'>Related Venues</th>
								
								<td class='record-value'>
									<table width="<%=baseCol3Wdth%>" border="0" cellpadding="0" cellspacing="0">
									<%
									// in the item_venuelinks vector we only have the venue id 
									// to get the venue name -> load a venue object
									for (String venueId : (Vector<String>) item_venuelinks) {
										venue.load(new Integer(venueId).intValue());
										%>
										<tr>
											<td width="<%=secCol1Wdth%>" valign="top">
												<a href="/pages/venue/?id=<%=venue.getVenueId()%>"><%=venue.getName()%></a>, <%=venue.getSuburb()%>, <%=state.getName(Integer.parseInt(venue.getState()))%> 
											</td>
										</tr>
										<%
									}
									%>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Source
						if (hasValue(item.getSourceCitation())) {
						%>
							<tr>
								<th class='record-label b-153'>Source</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<a href="/pages/resource/?id=<%=item.getSourceId()%>">
													<%=item.getSourceCitation()%>
												</a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//added extra table row for item url 21-02-06.
						if (hasValue(item.getItemUrl())) {
						%>
							<tr >
								<th class='record-label b-153'>Item URL</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<a target='_blank' href="<%=(!item.getItemUrl().toLowerCase().startsWith("http://"))?"http://":""%>item.getItemUrl()">
													<%=item.getItemUrl()%>
												</a>
												<br>
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
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Publisher
						if (hasValue(item.getPublisher())) {
						%>
							<tr >
								<th class='record-label b-153'>Publisher</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=item.getPublisher()%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						// publication location
						if (hasValue(item.getPublisherLocation())) {
						%>
							<tr >
								<th class='record-label b-153'>Publisher Location</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=item.getPublisherLocation()%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Volume
						if (hasValue(item.getVolume())) {
						%>
							<tr >
								<th class='record-label b-153'>Volume</th>
								
								<td class='record-value'>
									<%=item.getVolume()%>
								</td>
							</tr>
						<%
						}
						
						//Issue
						if (hasValue(item.getIssue())) {
						%>
							<tr >
								<th class='record-label b-153'>Issue</th>
								
								<td class='record-value'>
									<%=item.getIssue()%>
								</td>
							</tr>
						<%
						}
						
						//Page
						if (hasValue(item.getPage())) {
						%>
							<tr >
								<th class='record-label b-153'>Page</th>
								
								<td class='record-value'>
									<%=item.getPage()%>
								</td>
							</tr>
						<%
						}
						
						//Date Issued
						if (!formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate()).equals("")) {
						%>
							<tr>
								<th class='record-label b-153'>Date Issued</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=formatDate(item.getDdIssuedDate(), item.getMmIssuedDate(), item.getYyyyIssuedDate())%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						// Date Created
						if (!formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate()).equals("")) { 
							%>
							<tr>
								<th class='record-label b-153'>Date Created</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=formatDate(item.getDdCreateDate(), item.getMmCreateDate(), item.getYyyyCreateDate())%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Date of Copyright
						if (!formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate()).equals("")) {
						%>
							<tr>
								<th class='record-label b-153'>>Date Of Copyright</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=formatDate(item.getDdCopyrightDate(), item.getMmCopyrightDate(), item.getYyyyCopyrightDate())%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Date Accessioned
						if (!formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate()).equals("")) {
							%>
							<tr>
								<th class='record-label b-153'>Date Accessioned</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=formatDate(item.getDdAccessionedDate(), item.getMmAccessionedDate(), item.getYyyyAccessionedDate())%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Date Notes
						if (hasValue(item.getDateNotes())) {
						%>
							<tr>
								<th class='record-label b-153'>Date Notes</th>
								
								<td class='record-value'>
									<%=item.getDateNotes()%>
								</td>
							</tr>
						<%
						}
						
						//Catologue Id
						if (hasValue(item.getCatalogueId())) {
						%>
							<tr>
								<th class='record-label b-153'>Catalogue ID</th>
								
								<td class='record-value'>
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
								<th class='record-label b-153'>Holding Institution</th>
								
								<td class='record-value'>
									<a href="/pages/organisation/?id=<%=item.getInstitutionId()%>" valign="top"><%=institutionName%></a>
								</td>
							</tr>
						<%
						}
						
						//Rights
						if (hasValue(item.getRights())) {
						%>
							<tr>
								<th class='record-label b-153'>Rights</th>
								
								<td class='record-value'>
									<%=item.getRights()%>
								</td>
							</tr>
						<% 
						}
						
						//Rights Holder
						if (hasValue(item.getRightsHolder())) {
						%>
							<tr>
								<th class='record-label b-153'>Rights Holder</th>
								
								<td class='record-value'>
									<%=item.getRightsHolder()%>
								</td>
							</tr>
						<% 
						}
						
						//Access Rights
						if (hasValue(item.getRightsAccessRights())) {
						%>
							<tr>
								<th class='record-label b-153'>Access Rights</th>
								
								<td class='record-value'>
									<%=item.getRightsAccessRights()%>
								</td>
							</tr>
						<% 
						}
						
						//Language
						if (hasValue(item.getItemLanguage())) {
						%>
							<tr>
								<th class='record-label b-153'>Language</th>
								
								<td class='record-value'>
									<%=language.getDescription()%>
								</td>
							</tr>
						<% 
						}
						
						//Medium
						if (hasValue(item.getFormatMedium())) {
						%>
							<tr>
								<th class='record-label b-153'>Medium</th>
								
								<td class='record-value'>
									<%=item.getFormatMedium()%>
								</td>
							</tr>
						<% 
						}
						
						//Extent
						if (hasValue(item.getFormatExtent())) {
						%>
							<tr>
								<th class='record-label b-153'>Extent</th>
								
								<td class='record-value'>
									<%=item.getFormatExtent()%>
								</td>
							</tr>
						<% 
						}
						
						//Mimetype
						if (hasValue(item.getFormatMimetype())) {
						%>
							<tr>
								<th class='record-label b-153'>Mimetype</th>
								
								<td class='record-value'>
									<%=item.getFormatMimetype()%>
								</td>
							</tr>
						<% 
						}
						
						//Format
						if (hasValue(item.getFormat())) {
						%>
							<tr>
								<th class='record-label b-153'>Format</th>
								
								<td class='record-value'>
									<%=item.getFormat()%>
								</td>
							</tr>
						<% 
						}
						
						//ISBN
						if (hasValue(item.getIdentIsbn())) {
						%>
							<tr>
								<th class='record-label b-153'>ISBN</th>
								
								<td class='record-value'>
									<%=item.getIdentIsbn()%>
								</td>
							</tr>
						<% 
						}
						
						//ISMN
						if (hasValue(item.getIdentIsmn())) {
						%>
							<tr>
								<th class='record-label b-153'>ISMN</th>
								
								<td class='record-value'>
									<%=item.getIdentIsmn()%>
								</td>
							</tr>
						<% 
						}
						
						//ISSN
						if (hasValue(item.getIdentIssn())) {
						%>
							<tr>
								<th class='record-label b-153'>ISSN</th>
								
								<td class='record-value'>
									<%=item.getIdentIssn()%>
								</td>
							</tr>
						<% 
						}
						
						//SRCN
						if (hasValue(item.getIdentSici())) {
						%>
							<tr>
								<th class='record-label b-153'>SRCN</th>
								
								<td class='record-value'>
									<%=item.getIdentSici()%>
								</td>
							</tr>
						<% 
						}
						
						//Comments
						if (hasValue(item.getComments())) {
						%>
							<tr>
								<th class='record-label b-153'>Comments</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=item.getComments()%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Citation
						if (hasValue(item.getCitation())) {
						%>
							<tr>
								<th class='record-label b-153'>Citation</th>
								
								<td class='record-value'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top">
												<%=item.getCitation()%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						<%
						}
						
						//Resource Identifier
						if (hasValue(item.getItemId())) {
						%>
							<tr>
								<th class='record-label b-153'>Resource Identifier</th>
								
								<td class='record-value'>
									<%=item.getItemId()%>
								</td>
							</tr>
						<%
						}
						
						// close statement
						stmt.close();
						%>
						
					</table>
					<!--<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>-->
						<!-- AddThis Button BEGIN -->
					<!--<div align="right" class="addthis_toolbox addthis_default_style ">
						<a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
						<a class="addthis_button_tweet"></a>
						<a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
						<a class="addthis_counter addthis_pill_style"></a>
					</div>-->
</div>
<cms:include property="template" element="foot" />
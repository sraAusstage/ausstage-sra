
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%--@ page import = "ausstage.Event, ausstage.DescriptionSource"--%>
<%--@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"--%>
<%--@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"--%>
<%--@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"--%>
<%--@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"--%>
<%--@ page import = "ausstage.ConEvLink, ausstage.Contributor"--%>
<%--@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.RelationLookup, ausstage.ContentIndicator"--%>
<%@ page import = "ausstage.Item"%>
<%--@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"--%>
<%--@ page import = "ausstage.SecondaryGenre, ausstage.Work"--%>
<%--@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" --%>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

 <!-- libraries here        -->
        <script src="/resources/js/jquery-3.2.1.min.js"></script> 
        <script src="/resources/bootstrap-4.0.0-beta.2/js/bootstrap.min.js"></script>


<%@ include file="../../public/common.jsp"%>

						<%
						ausstage.Database db_ausstage_for_drill = (ausstage.Database)session.getAttribute("database-connection");
						
						if(db_ausstage_for_drill == null) {
							db_ausstage_for_drill = new ausstage.Database();
							db_ausstage_for_drill.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
						}
						
						ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage_for_drill);
						
						List<String> groupNames = new ArrayList();	
						if (session.getAttribute("userName")!= null) {
							admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
						  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
						}

						CachedRowSet crset          = null;
						ResultSet    rset;
						Statement     stmt = db_ausstage_for_drill.m_conn.createStatement();
						String item_id              = request.getParameter("itemid");

						Item item;
						admin.Common Common = new admin.Common();  
					
						///////////////////////////////////
						//    DISPLAY RESOURCE DETAILS
						//////////////////////////////////
						item = new Item(db_ausstage_for_drill);
						int x = Integer.parseInt(item_id);
						item.load(x);
						
						String secTableWdth = "100%";
			                        String secCol1Wdth  = "30%";
                        			String secCol2Wdth  = "70%";
						
						%>
						
<div style="margin: 0px;">	
	<div style="width: 100%; ">
		<div class='record item-light' style="margin: 0px; padding-top:20px;padding-bottom: 20px;margin-bottom:5px">	
						<table class='record-table' style="margin-top: 0px;">					
						
						<%
						

						
						//added extra table row for item url 21-02-06.
						if (hasValue(item.getItemUrl())) {
							
							boolean isImage = item.isImageUrl(item.getItemUrl());
							Vector additionalUrls = item.getAdditionalUrls(); 
						%> <!-- Jerry -->
							<tr >
								<td class='record-value' colspan='2'>
									<table width="<%=secTableWdth%>" border="0" cellpadding="0" cellspacing="0">
									<%

									%>
								
									
										<tr>
											<td valign="top">
											
											
											
											
												<div class="container">
												  <div id="myCarousel" class="carousel slide" data-ride="carousel">
												    <!-- Indicators -->
												    <ol class="carousel-indicators">
												      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
													<%
													for (int i = 1; i < additionalUrls.size(); i++) {%>
														<li data-target="#myCarousel" data-slide-to="<%=i%>"></li>
													<%}%>      
												
												    </ol>
												
												    <!-- Wrapper for slides -->
												    <div class="carousel-inner">
												
												      <div class="item active">
													<img src="<%=item.getItemUrl()%>" alt="<%=item.getItemUrl()%>" style="height:auto"/>
												      </div>
												
												
												<%
												String encodedUrl = ""; 
												for (int i = 0; i < additionalUrls.size(); i++) {
													//fix the ' error - by replacing it with a URL encoded value. 									
													encodedUrl = additionalUrls.elementAt(i).toString().replaceAll("'", "%27");
												%>	
												 
												     <div class="item">
												        <img src="<%=additionalUrls.elementAt(i).toString()%>" alt="<%=additionalUrls.elementAt(i).toString()%>" style="height:auto;">
												      </div>  
												  
												  
												 <%      
												}
												
												%>
												
						
												    </div>
												
												    <!-- Left and right controls -->
												    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
												      <span class="glyphicon glyphicon-chevron-left"></span>
												      <span class="sr-only">Previous</span>
												    </a>
												    <a class="right carousel-control" href="#myCarousel" data-slide="next">
												      <span class="glyphicon glyphicon-chevron-right"></span>
												      <span class="sr-only">Next</span>
												    </a>
												  </div>
												</div>											
																							
																						
											</td>
										</tr>
									<%}%>

									</table>
								</td>
							</tr>
							
						<%
						

						// close statement
						stmt.close();
						%>
						
					</table>				
		</div>
	</div>
</div>

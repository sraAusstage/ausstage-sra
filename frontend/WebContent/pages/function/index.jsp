<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Event, ausstage.DescriptionSource"%>
<%@ page import = "ausstage.Datasource, ausstage.Venue, ausstage.ItemItemLink"%>
<%@ page import = "ausstage.PrimaryGenre, ausstage.SecGenreEvLink"%>
<%@ page import = "ausstage.Country, ausstage.PrimContentIndicatorEvLink"%>
<%@ page import = "ausstage.OrgEvLink, ausstage.Organisation, ausstage.Organisation"%>
<%@ page import = "ausstage.ConEvLink, ausstage.Contributor,ausstage.ContFunctPref , ausstage.ContributorFunction"%>
<%@ page import = "ausstage.Item, ausstage.LookupCode, ausstage.ContentIndicator"%>
<%@ page import = "ausstage.ItemContribLink, ausstage.ItemOrganLink"%>
<%@ page import = "ausstage.SecondaryGenre, ausstage.Work"%>
<%@ page import = "ausstage.WorkContribLink, ausstage.WorkEvLink,ausstage.WorkOrganLink" %>

<%@ page session="true" import=" java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
<jsp:include page="../../templates/header.jsp" />


<div class='record'>
			<%
			ausstage.Database db_ausstage_for_drill = new ausstage.Database ();
			db_ausstage_for_drill.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
			
			List<String> groupNames = new ArrayList();	
			if (session.getAttribute("userName")!= null) {
				admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
			  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
			}
	
	
			ResultSet rset;
			Statement stmt = db_ausstage_for_drill.m_conn.createStatement();
			String formatted_date = "";
			String contfunction_id = request.getParameter("id");	
	
			ContFunctPref function = null;
	
			boolean displayUpdateForm = true;
			admin.Common Common = new admin.Common();  
			
			function = new ContFunctPref (db_ausstage_for_drill);
			function.load(contfunction_id);

			// Function Term
			%>
			<table class='record-table'>
				<tr>
					<th class='record-label b-105 bold'><img src='../../../resources/images/icon-blank.png' class='box-icon'>Function</th>
					
					<td class='record-value bold'><%=function.getPreferredTerm()%></td>
					<td  class='record-comment'>
					<%
					if(displayUpdateForm) {
					displayUpdateForm(contfunction_id, "Contributor Function", function.getPreferredTerm(),out,
					request, ausstage_search_appconstants_for_drill);
					}   
					%>
					</td>
				</tr>
			
			<%
			
			//Contributors
			rset = function.getAssociatedContributors(Integer.parseInt(contfunction_id), stmt);
			if(rset != null && rset.isBeforeFirst()) {
			%>

				<tr>
          <th class='record-label b-105'>Contributors</th>
          
          <td class='record-value'  colspan='2'>
            <table class='record-value-table' cellspacing="0">
              <tr>
                <th  class='record-value-table light'>Name</th>
                <th  class='record-value-table light'>Event Dates</th>
              </tr>
            <%
              while(rset.next()) {
              %>
              <tr>
                <td  class='record-value-table'>
                  <a href="/pages/contributor/<%=rset.getString("contributorid") %>">
                    <%=rset.getString("name")%>
                  </a>
                </td>
                <td  class='record-value-table'>
                <%

                String firstStartDateYear = rset.getString("min_first_date");
                String lastStartDateYear = rset.getString("max_first_date");
                String lastEndDateYear = rset.getString("max_last_date");
               
                
                String eventDates = firstStartDateYear;
                int firstEventStartYear = Integer.valueOf(firstStartDateYear);
                int lastEventStartYear = Integer.valueOf(lastStartDateYear);
                
                if(hasValue(lastEndDateYear)){
                	int lastEventEndYear = Integer.valueOf(lastEndDateYear);
                	// if the last event end date is greater than the last event start date and not equal to first event start date then we use it as the end of the event dates
                	if(lastEventEndYear > lastEventStartYear && lastEventEndYear != firstEventStartYear) {
                		eventDates += " - " + lastEndDateYear;
                	// there may be cases when the last event end date may be null so the last event start date would be larger so we use that as the end of the event dates
                	// if it isn't equal to the first event start date
                	} else if (lastEventStartYear != firstEventStartYear) {
                		eventDates += " - " + lastEventStartYear;
                	}
                // if last event end date doesn't have a value then make sure that last event start date isn't equal to the first event start date
                } else if (lastEventStartYear != firstEventStartYear) {
                  eventDates += " - " + lastEventStartYear;
                }
                %>
                <%= eventDates %>
                
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
			
			//Contributor Function Identifier
			%>
			<tr>
				<th class='record-label b-105'>Function Identifier</th>
				
				<td class='record-value' colspan='2'><%=function.getPreferredId()%></td>
			</tr>
			
		</table>
	<%  
	// close statement
	stmt.close();
%>
<!--<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4e7960206c641ecd"></script>-->
  <!-- AddThis Button BEGIN -->
<!--<div align="right" class="addthis_toolbox addthis_default_style ">
  <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
  <a class="addthis_button_tweet"></a>
  <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
  <a class="addthis_counter addthis_pill_style"></a>
</div>-->

</div>
<jsp:include page="../../templates/footer.jsp" />
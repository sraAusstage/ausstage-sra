<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="java.sql.*, ausstage.*, sun.jdbc.rowset.*" %>

<jsp:include page="../../../templates/header.jsp" /><%@ include file="../../../public/common.jsp"%>
<!--Script to enable sorting columns  -->
<script language="JavaScript" type="text/JavaScript">
  <!--
  /**
  * Make modifications to the sort column and sort order.
  */
  function reSortData( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.col.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value == 'ASC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.col.value = sortColumn;
  document.form_searchSort_report.order.value = 'ASC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
    -->
</script>

<div class="browse">

<div class="browse-bar b-90"><img class="browse-icon" src="../../../resources/images/icon-international.png">
   
    <span class="browse-heading large">International</span>

</div>
<%
  int recordCount;
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  
  String        sqlString;
  String	  sqlString1;
  String sortCol = request.getParameter("col");
   String validSql = "countryname orgcount venuecount workcount dates ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "countryname";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null || !validSql.contains(sortOrd)) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
  
   

%>
<div class="scroll-table">
<table class="browse-table">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <thead>
    <tr>
      <th width="25%" align="left" ><b><a href="#" onClick="reSortData('countryname')"> Country </a></b></th>
      <th width="25%" align="left" ><b><a href="#" onClick="reSortData('dates')">Event Dates</a></b></th>
      <th width="25%" style="text-align:right" align="right" ><b><a href="#" onClick="reSortData('orgcount')">Organisations</a></b></th>
      <th width="25%" style="text-align:right" align="right" ><b><a href="#" onClick="reSortData('venuecount')">Venues</a></b></th>
     <!-- <th width="20%" align="right" ><b><a href="#" onClick="reSortData('workcount')">Works</a></b></th>-->
    </tr>
    </thead>
    <%
    sqlString = "SELECT * from("+
    			"SELECT c.countryid, c.countryname as countryname, "+
    			"COALESCE(org.orgCount,0) AS orgcount, "+
    			"COALESCE(ven.venCount,0) AS venuecount, "+
    			"COALESCE(wor.workCount,0) AS workcount, "+
    			"concat_ws(' - ',dates.mindate, if(dates.maxdate = dates.mindate, null, dates.maxdate)) as dates, "+
    			"COALESCE(orgdates.mindate,'') as o_mindate, "+
    			"COALESCE(orgdates.maxdate,'') as o_maxdate, "+
                	"COALESCE(vendates.mindate,'') as v_mindate, "+
                	"COALESCE(vendates.maxdate,'') as v_maxdate, "+
                	"COALESCE(wordates.mindate,'') as w_mindate, "+
                	"COALESCE(wordates.maxdate,'') as w_maxdate "+
    			"FROM country AS c "+
			 " LEFT JOIN ( "+
            			"select count(distinct work.workid) as workCount, country.countryid AS countryid "+
            			"from events, country, playevlink, eventworklink, work "+
            			"where events.eventid = playevlink.eventid "+
            			"and playevlink.countryid = country.countryid "+
            			"and events.eventid = eventworklink.eventid "+
            			"and eventworklink.workid = work.workid "+
            			"group by country.countryid "+
        			" ) AS wor "+
        			" ON wor.countryId = c.countryid "+
    			" LEFT JOIN ( "+
            			"SELECT COUNT(*) AS orgCount, countryid AS countryId "+
            			"FROM organisation "+
           			"GROUP BY countryid "+
        			" ) AS org "+
        			" ON org.countryId = c.countryid "+
    			" LEFT JOIN ( "+
            			"SELECT COUNT(*) AS venCount, countryid AS countryId "+
           			"FROM venue "+
            			"GROUP BY countryid "+
        			") AS ven "+
        			" ON ven.countryId = c.countryid "+
        		" LEFT JOIN ( "+
            			"SELECT min(events.yyyyfirst_date) as mindate, max(events.yyyyfirst_date) as maxdate,"+
            			" playevlink.countryid AS countryId "+
            			"FROM playevlink, events "+
            			"WHERE playevlink.eventid = events.eventid "+
            			"GROUP BY countryid "+
        			") AS dates "+
        			"on dates.countryid = c.countryid "+
        		" LEFT JOIN ( "+
        			"SELECT countryid, "+
                      		"min(events.yyyyfirst_date) mindate, "+
		              	" if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+
                	  	"FROM organisation, orgevlink, events "+
                  	  	"WHERE orgevlink.organisationid = organisation.organisationid "+
                	  	"AND orgevlink.eventid = events.eventid "+
              		  	"group by organisation.countryid "+
	              		"  ) as orgdates "+
	              		" on orgdates.countryid = c.countryid "+
        		" LEFT JOIN ( "+
	        		"select min(events.yyyyfirst_date) as mindate, countryid, "+
            			"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+
            			"FROM events, venue "+
            			"WHERE venue.venueid = events.venueid "+
            			"group by countryid "+
        			") AS venDates "+
         			"ON venDates.countryId = c.countryid "+
         		" LEFT JOIN ( "+
         			"select      playevlink.countryid as countryid, "+
				"min(events.yyyyfirst_date) as mindate, "+
            			"if(max(ifnull(events.yyyylast_date, events.yyyyfirst_date)) = min(events.yyyyfirst_date), null, max(ifnull(events.yyyylast_date, events.yyyyfirst_date))) as maxdate "+
				"FROM work, events, eventworklink, playevlink "+
				"WHERE eventworklink.workid = work.workid "+
            			"AND events.eventid = eventworklink.eventid "+
            			"AND playevlink.eventid = events.eventid "+
 		    		"group by countryid "+
			        " ) AS worDates "+
			        "on wordates.countryid = c.countryid "+
			        
    			"group by c.countryid Order by " + sortCol + " " + sortOrd + ", countryname "+
    			") res WHERE countryname != 'Australia' AND(orgcount > 0 OR venuecount > 0 or workcount > 0 OR dates != '')";
    l_rs = m_db.runSQL (sqlString, stmt);

    int i = 0;
    int x;
    //get result count
    l_rs.last();
    recordCount = l_rs.getRow();
    l_rs.beforeFirst();

    
    
    
    while (l_rs.next())
    {
        	    
      //if(!l_rs.getString("dates").equals("")&&!l_rs.getString("orgcount").equals("")&&!l_rs.getString("venuecount").equals("")){
      if(!l_rs.getString("orgcount").equals("0")||!l_rs.getString("venuecount").equals("0")||!l_rs.getString("workcount").equals("0")){
	x = 0;      
      Vector dateSorter = new Vector();
      String minDate = "";
      String maxDate = "";
      String dateRange = "";
      //get overall date range from org, venue and work - pretty sure this could have been done in the query. BW
      //add all possible date values to vector
      	if (!l_rs.getString("o_mindate").equals("")){dateSorter.add(l_rs.getString("o_mindate"));}
	if (!l_rs.getString("o_maxdate").equals("")){dateSorter.add(l_rs.getString("o_maxdate"));}
      	if (!l_rs.getString("v_mindate").equals("")){dateSorter.add(l_rs.getString("v_mindate"));}
      	if (!l_rs.getString("v_maxdate").equals("")){dateSorter.add(l_rs.getString("v_maxdate"));}
      	if (!l_rs.getString("w_mindate").equals("")){dateSorter.add(l_rs.getString("w_mindate"));}
      	if (!l_rs.getString("w_maxdate").equals("")){dateSorter.add(l_rs.getString("w_maxdate"));}
	//loop through vector and find min and max	
      if(dateSorter.size()>0){
      minDate = (String)dateSorter.firstElement();
      maxDate = (String)dateSorter.firstElement();
      }
      
      int y = 1;
      while(y<dateSorter.size()){
	      if (Integer.parseInt((String)dateSorter.get(y)) < Integer.parseInt(minDate)) minDate = (String)dateSorter.get(y);
	      if (Integer.parseInt((String)dateSorter.get(y)) > Integer.parseInt(maxDate)) maxDate = (String)dateSorter.get(y);
	      y++;
      }
      //format min and max dates 
      if (minDate.equals(maxDate)){dateRange = minDate;}
      else dateRange = minDate + " - " +maxDate;
      
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
      
      %>
      <tr class="<%=evenOdd[evenOddValue]%>">
        <td width="25%"><a href="/pages/country/<%=l_rs.getString("countryid")%>"><%=l_rs.getString("countryname")%></a></td>
        <td width="25%" align="left"><%=dateRange%> </td>
	<td width="25%" align="right"><%if(l_rs.getString("orgcount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("orgcount")); %>
	</td>
   	<td width="25%" align="right"><%if(l_rs.getString("venuecount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("venuecount")); %>
   	</td>
   	<!--<td width="20%" align="right"><%if(l_rs.getString("workcount").equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString("workcount")); %>
   	</td>-->
      </tr>
      <%
  	i += 1;
  	}
    }
    %>
	<tfoot>
    <tr  width="100%" class="browse-bar b-90" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class='browse-index browse-index-genre'>
        </div> 
      </td>
    </tr>
    </tfoot>
  </form>
</table>
</div>
</div>
<jsp:include page="../../../templates/footer.jsp" />
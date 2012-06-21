<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../public/common.jsp"%>
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
  function reSortNumbers( sortColumn ) {
  if ( sortColumn == document.form_searchSort_report.col.value ) {
  // The same column was selected. Toggle the sort order.
  if ( document.form_searchSort_report.order.value != 'DESC' ) {
  document.form_searchSort_report.order.value = 'DESC';
  } else {
  document.form_searchSort_report.order.value = 'ASC';
  }
  } else {
  // A different column was selected.
  document.form_searchSort_report.col.value = sortColumn;
  document.form_searchSort_report.order.value = 'DESC';
  }
  // Submit the form.
  document.form_searchSort_report.submit();
  }
  -->
</script>


<div class="browse">

<div class="browse-bar b-153">

    <img src="../../../resources/images/icon-resource.png" class="browse-icon">
    
    <span class="browse-heading large">Resources</span>

</div>
<%
  String pno=request.getParameter("pno"); // this will be coming from url
  int pageno=0;
  if(pno!=null)
  {
    pageno=Integer.parseInt(pno);
  }
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  
  int next=pageno+1;
  int previous=pageno-1;
  String        sqlString;
  String	  sqlString1;
  String sortCol = request.getParameter("col");
  String validSql = "name counter total ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "name";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";

  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"select count(*) from (SELECT lookup_codes.code_lov_id, count(distinct item.itemid) counter FROM lookup_codes  "+
		"Left JOIN item ON (lookup_codes.code_lov_id = item.item_sub_type_lov_id) WHERE lookup_codes.`code_type`='RESOURCE_SUB_TYPE' "+
		"group by lookup_codes.code_lov_id) `lookup_codes` where counter > 0";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
%>

<table class="browse-table">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <thead>
    <tr>
      <th width="70%"><b> <a href="#" onClick="reSortData('name')"> Name  (<%=l_rs.getString(1)%>)</a></b></th>
      <th width="30%" align="right"><b><a href="#" onClick="reSortNumbers('counter')">Resources</a></b></th>
    </tr>
    </thead>
    <%
    sqlString = 	"select * from (SELECT lookup_codes.short_code name, count(item.itemid) counter,lookup_codes.code_lov_id FROM lookup_codes  "+
			"LEFT JOIN item ON (lookup_codes.code_lov_id = item.item_sub_type_lov_id) WHERE lookup_codes.`code_type`='RESOURCE_SUB_TYPE' Group by lookup_codes.short_code "+
			"Order by " + sortCol + " " + sortOrd + ") a where a.counter > 0  limit " + ((pageno)*25) + ",26 ";
			
    l_rs = m_db.runSQL (sqlString, stmt);
    int i = 0;
    while (l_rs.next())
    {
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
      %>
      <tr class="<%=evenOdd[evenOddValue]%>">
        <td width="70%"><a href="/pages/resourcetype/?id=<%=l_rs.getString(3)%>"><%=l_rs.getString(1)%></a></td>
       	<td width="30%" align="right"><%if(l_rs.getString(2).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(2)); %>
   	</td>
      </tr>
      <%
  	i += 1;
  	if (i == 25) break;
    }
    %>
     
    <tr  width="100%" class="browse-bar b-153" style="height:2.5em;">
      <td align="right" colspan="5">
        <div class='letters'>
        <%if (previous >= 0) 
        {
          out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
   	  out.println("<a href='?order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous </a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/25));
        if (max >= 1) {
	  if (start + 9 > max && max > 9) start = max-9;
	  for(int j=0;j<=9;j++) 
	  {       
	    if (j+start <= max) 
	    {
	      int k= j+start;      	 
	      String bold = ""+(k+1);
	      if (k == pageno) bold = "<b>" + (k+1) + "</b>";
	      out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'>"+bold+" </a>");
	    }
	  }
	  if (i == 25 && l_rs.next()) 
	  {
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	    out.println("<a href='?order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/25 +"'>Last</a> ");
	  }
        }
        %>  	
        </div> 
      </td>
    </tr>
  </form>
</table>
<cms:include property="template" element="foot" />
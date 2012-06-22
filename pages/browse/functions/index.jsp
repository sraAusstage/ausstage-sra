<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, admin.AppConstants, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" /><%@ include file="../../../public/common.jsp"%>
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

<div class="browse-bar b-105">

    
    <span class="browse-heading large">Functions</span>
<%
  String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
    if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
%>

<div class='browse-index browse-index-function'>
  <a href="?letter=A" <%=letter.equals("a")?"style='font-weight:bold'":""%>>A</a>
  <a href="?letter=B" <%=letter.equals("b")?"style='font-weight:bold'":""%>>B</a>
  <a href="?letter=C" <%=letter.equals("c")?"style='font-weight:bold'":""%>>C</a>
  <a href="?letter=D" <%=letter.equals("d")?"style='font-weight:bold'":""%>>D</a>
  <a href="?letter=E" <%=letter.equals("e")?"style='font-weight:bold'":""%>>E</a>
  <a href="?letter=F" <%=letter.equals("f")?"style='font-weight:bold'":""%>>F</a>
  <a href="?letter=G" <%=letter.equals("g")?"style='font-weight:bold'":""%>>G</a>
  <a href="?letter=H" <%=letter.equals("h")?"style='font-weight:bold'":""%>>H</a>
  <a href="?letter=I" <%=letter.equals("i")?"style='font-weight:bold'":""%>>I</a>
  <a href="?letter=J" <%=letter.equals("j")?"style='font-weight:bold'":""%>>J</a>
  <a href="?letter=K" <%=letter.equals("k")?"style='font-weight:bold'":""%>>K</a>
  <a href="?letter=L" <%=letter.equals("l")?"style='font-weight:bold'":""%>>L</a>
  <a href="?letter=M" <%=letter.equals("m")?"style='font-weight:bold'":""%>>M</a>
  <a href="?letter=N" <%=letter.equals("n")?"style='font-weight:bold'":""%>>N</a>
  <a href="?letter=O" <%=letter.equals("o")?"style='font-weight:bold'":""%>>O</a>
  <a href="?letter=P" <%=letter.equals("p")?"style='font-weight:bold'":""%>>P</a>
  <a href="?letter=Q" <%=letter.equals("q")?"style='font-weight:bold'":""%>>Q</a>
  <a href="?letter=R" <%=letter.equals("r")?"style='font-weight:bold'":""%>>R</a>
  <a href="?letter=S" <%=letter.equals("s")?"style='font-weight:bold'":""%>>S</a>
  <a href="?letter=T" <%=letter.equals("t")?"style='font-weight:bold'":""%>>T</a>
  <a href="?letter=U" <%=letter.equals("u")?"style='font-weight:bold'":""%>>U</a>
  <a href="?letter=V" <%=letter.equals("v")?"style='font-weight:bold'":""%>>V</a>
  <a href="?letter=W" <%=letter.equals("w")?"style='font-weight:bold'":""%>>W</a>
  <a href="?letter=X" <%=letter.equals("x")?"style='font-weight:bold'":""%>>X</a>
  <a href="?letter=Y" <%=letter.equals("y")?"style='font-weight:bold'":""%>>Y</a>
  <a href="?letter=Z" <%=letter.equals("z")?"style='font-weight:bold'":""%>>Z</a>
</div>
</div>
<%
  String pno=request.getParameter("pno"); // this will be coming from url
  int pageno=0;
  if(pno!=null)
  {
    pageno =Integer.parseInt(pno);
  }
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  String[] evenOdd = {"b-185", "b-184"};  // two-element String array
  int next=pageno+1;
  int previous=pageno-1;
  String        sqlString;
  String	  sqlString1;
  //String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
  if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
  String sortCol = request.getParameter("col");
  if (sortCol == null) sortCol = "preferredterm";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null) sortOrd = "ASC";
  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;
  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"select count(*) from (SELECT COUNT(*) From `contributorfunctpreferred` "+
		"INNER JOIN contfunctlink ON (contributorfunctpreferred.contributorfunctpreferredid = contfunctlink.contributorfunctpreferredid) "+
		"WHERE lcase(`contributorfunctpreferred`.`preferredterm`) LIKE '" + letter + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid`) a ";
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
%>

<table class="browse-table">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="letter" value="<%=letter%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <thead>
    <tr>
      <th width="20%"><b><a href="#" onClick="reSortData('preferredterm')">Name  (<%=l_rs.getString(1)%>)</a></b> </th>
      
      <th width="15%" align="right"><b><a href="#" onClick="reSortNumbers('total')">Contributors</a></b></th>
    </tr>
    </thead>
    <%
    sqlString = 	"SELECT contributorfunctpreferred.preferredterm,count(contfunctlink.contributorid) as total,`contributorfunctpreferred`.`contributorfunctpreferredid`  " +
			"FROM contributorfunctpreferred "+
			"INNER JOIN contfunctlink ON (contributorfunctpreferred.contributorfunctpreferredid = contfunctlink.contributorfunctpreferredid) "+
			"WHERE lcase(`contributorfunctpreferred`.preferredterm) LIKE '" + letter + "%' group by `contributorfunctpreferred`.`contributorfunctpreferredid` " +
  			"Order by " + sortCol + " " + sortOrd + ", preferredterm limit " + ((pageno)*25) + ",26";  
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
      <td width="20%"><a href="/pages/function/?id=<%=l_rs.getString(3)%>"><%=l_rs.getString(1)%></a></td>
       
      <td width="15%" align="right"><%=l_rs.getString(2)%></td>  	 
    </tr>
  	 
    <div class='letters'>
    <%
      i += 1;
      if (i == 25) break;
    }
    %>
    <tr  width="100%" class="browse-bar b-105" style="height:2.5em;" >
      <td align="right" colspan="5">
        <div class="browse-index browse-index-function">
        <%if (previous >= 0) 
        {
          out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
   	  out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous </a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/25));
        if (max >= 1) 
        {
	  if (start + 9 > max && max > 9) start = max-9;
	  for(int j=0;j<=9;j++) 
	  {       
	    if (j+start <= max) 
	    {
	      int k= j+start;      	 
	      String bold = ""+(k+1);
	      if (k == pageno) bold = "<b>" + (k+1) + "</b>";
	      out.println("<a href='?letter=" + letter +"&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'>"+bold+" </a>");
	    }
	  }
	  if (i == 25 && l_rs.next()) 
	  {
	    out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	    out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/25 +"'>Last</a> ");
	 }
        }
        %>  	
        </div> 
      </td>
    </tr>
  </form>
</table>
<cms:include property="template" element="foot" />
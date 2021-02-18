<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.*, admin.AppConstants, sun.jdbc.rowset.*" %>
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


<%

  String letter = request.getParameter("letter");
  if (letter == null) letter = "a";
  if (letter.length() > 1) letter = letter.substring(0,1);
  letter = letter.toLowerCase();
   
   //added to account for numbers and non alphanumeric at the beginning of names
   String switchLike = "";
   if (letter.equals("0")) switchLike =  "REGEXP '^[[:digit:]]'";
   else if (letter.equals("*")) switchLike =  "REGEXP '^[^A-Za-z0-9]'";
   else switchLike = " LIKE '" + letter + "%' ";

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
  
  String sortCol = request.getParameter("col");
  String validSql = "name year function num total ASC DESC";
  if (sortCol == null || !validSql.contains(sortCol)) sortCol = "name";
  String sortOrd = request.getParameter("order");
  if (sortOrd == null || !validSql.contains(sortOrd)) sortOrd = "ASC";
  System.out.println("3");
  ausstage.Database     m_db = new ausstage.Database ();
  System.out.println("4");
  CachedRowSet  l_rs     = null;
  admin.AppConstants constants = new admin.AppConstants();
  
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
    System.out.println("5");
  Statement stmt    = m_db.m_conn.createStatement ();
      
  sqlString =	"SELECT COUNT(*) From `contributor` WHERE lcase(`contributor`.last_name) "+switchLike;
  l_rs = m_db.runSQL (sqlString, stmt);
  l_rs.next();
  int recordCount = Integer.parseInt(l_rs.getString(1));
%>
<div class="browse">

<div class="browse-bar b-105">

  <form name="form_searchSort_report" method="POST" action="index.jsp">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
    <input type="hidden" name="col" value="<%=sortCol%>">
    <input type="hidden" name="order" value="<%=sortOrd%>">
    <input type="hidden" name="letter" value="<%=letter%>">
    <input type="hidden" name="pageno" value="<%=pno%>">
    <img src="../../../resources/images/icon-contributor.png" class="browse-icon">
    
    <span class="browse-heading large">Contributors</span>


 <span class="browse-index browse-index-contributor">
  <a href="?letter=A" <%=letter.equals("a")?"class='b-106 bold'":""%>>A</a>
  <a href="?letter=B" <%=letter.equals("b")?"class='b-106 bold'":""%>>B</a>
  <a href="?letter=C" <%=letter.equals("c")?"class='b-106 bold'":""%>>C</a>
  <a href="?letter=D" <%=letter.equals("d")?"class='b-106 bold'":""%>>D</a>
  <a href="?letter=E" <%=letter.equals("e")?"class='b-106 bold'":""%>>E</a>
  <a href="?letter=F" <%=letter.equals("f")?"class='b-106 bold'":""%>>F</a>
  <a href="?letter=G" <%=letter.equals("g")?"class='b-106 bold'":""%>>G</a>
  <a href="?letter=H" <%=letter.equals("h")?"class='b-106 bold'":""%>>H</a>
  <a href="?letter=I" <%=letter.equals("i")?"class='b-106 bold'":""%>>I</a>
  <a href="?letter=J" <%=letter.equals("j")?"class='b-106 bold'":""%>>J</a>
  <a href="?letter=K" <%=letter.equals("k")?"class='b-106 bold'":""%>>K</a>
  <a href="?letter=L" <%=letter.equals("l")?"class='b-106 bold'":""%>>L</a>
  <a href="?letter=M" <%=letter.equals("m")?"class='b-106 bold'":""%>>M</a>
  <a href="?letter=N" <%=letter.equals("n")?"class='b-106 bold'":""%>>N</a>
  <a href="?letter=O" <%=letter.equals("o")?"class='b-106 bold'":""%>>O</a>
  <a href="?letter=P" <%=letter.equals("p")?"class='b-106 bold'":""%>>P</a>
  <a href="?letter=Q" <%=letter.equals("q")?"class='b-106 bold'":""%>>Q</a>
  <a href="?letter=R" <%=letter.equals("r")?"class='b-106 bold'":""%>>R</a>
  <a href="?letter=S" <%=letter.equals("s")?"class='b-106 bold'":""%>>S</a>
  <a href="?letter=T" <%=letter.equals("t")?"class='b-106 bold'":""%>>T</a>
  <a href="?letter=U" <%=letter.equals("u")?"class='b-106 bold'":""%>>U</a>
  <a href="?letter=V" <%=letter.equals("v")?"class='b-106 bold'":""%>>V</a>
  <a href="?letter=W" <%=letter.equals("w")?"class='b-106 bold'":""%>>W</a>
  <a href="?letter=X" <%=letter.equals("x")?"class='b-106 bold'":""%>>X</a>
  <a href="?letter=Y" <%=letter.equals("y")?"class='b-106 bold'":""%>>Y</a>
  <a href="?letter=Z" <%=letter.equals("z")?"class='b-106 bold'":""%>>Z</a>
  <a href="?letter=0" <%=letter.equals("0")?"class='b-106 bold'":""%>>0-9</a>
  <a href="?letter=*" <%=letter.equals("*")?"class='b-106 bold'":""%>>%</a>
</span>
</div>


<table class="browse-table">
<thead>
    <tr>
           
      <th><a href="#" onClick="reSortData('name')">Name  (<%=SearchCount.formatSearchCountWithCommas(l_rs.getString(1))%>)</a></th>
      <th><a href="#" onClick="reSortData('function')">Functions</a></th>
      <th align="left"><a href="#" onClick="reSortNumbers('year')">Event Dates</a></th>
      <th align="right"><a href="#" onClick="reSortNumbers('num')">Events</a></th>
      <th align="right"><a href="#" onClick="reSortNumbers('total')">Resources</a></th>
    </tr>
</thead>
    <%
    sqlString = 	"SELECT contributor.`contributorid`,contributor.last_name name,contributor.first_name, "+
    			" min(events.yyyyfirst_date)year,max(events.yyyylast_date),count(distinct events.eventid) num, "+
    			" group_concat(distinct contributorfunctpreferred.preferredterm separator ', ') function,"+
    			" count(distinct itemconlink.itemid) total " +
			" FROM contributor "+
			" LEFT JOIN conevlink ON (contributor.contributorid = conevlink.contributorid) "+
			" LEFT JOIN events ON (conevlink.eventid = events.eventid) "+
			" Left JOIN contfunctlink ON (contributor.contributorid = contfunctlink.contributorid) "+ 
			" Left JOIN contributorfunctpreferred ON (contfunctlink.contributorfunctpreferredid = contributorfunctpreferred.contributorfunctpreferredid)" +
			" Left join itemconlink ON (contributor.contributorid = itemconlink.contributorid) "+
			//" WHERE lcase(`contributor`.last_name) " + switchLike + " group by `contributor`.contributorid " +
			" WHERE TRIM(leading ' ' from lcase(`contributor`.last_name)) " + switchLike + " group by `contributor`.contributorid " +
  			" ORDER BY  " + (sortCol.equals("name")? ((letter.equals("0"))?"convert(":"")+ "last_name " + ((letter.equals("0"))?", decimal)":"")+ sortOrd + ", "+((letter.equals("0"))?"convert(":"")+"first_name"+((letter.equals("0"))?", decimal)":""):sortCol) 
  			+ " " + sortOrd + (sortCol.equals("year")?", ifnull(max(events.yyyylast_date),min(events.yyyyfirst_date)) " + sortOrd:"") 
  			+ (sortCol.equals("last_name")?"":", last_name asc, first_name asc") + " limit " + ((pageno)*100) + ",101"; 
    l_rs = m_db.runSQL (sqlString, stmt);      
    System.out.println(sqlString);
    int i = 0;
    while (l_rs.next())
    {
      rowCounter++;
      // set evenOddValue to 0 or 1 based on rowCounter
      evenOddValue = 1;
      if (rowCounter % 2 == 0) evenOddValue = 0;
    %>
    <tr class="<%=evenOdd[evenOddValue]%>">
      <td width="25%"><a href="/pages/contributor/<%=l_rs.getString(1)%>"><%=l_rs.getString(3)==null?"":l_rs.getString(3)%> <%=l_rs.getString(2)==null?"":l_rs.getString(2)%></a></td>
       <td width="40%" align="left"><%if (l_rs.getString(7) != null) out.write(l_rs.getString(7)); %></td>
      <td width="15%" align="left"><%   	     
        if(l_rs.getString(6).equals("1") || l_rs.getString(4) != null && l_rs.getString(4).equals(l_rs.getString(5)))
      	{
          if (l_rs.getString(4) != null) out.write(l_rs.getString(4)); 
      	}
        else 
      	{
          if (l_rs.getString(4) != null) out.write(l_rs.getString(4));
          if (l_rs.getString(4) != null && l_rs.getString(5) != null) out.write(" - ") ; 
          if (l_rs.getString(5) != null) out.write(l_rs.getString(5));
      	}%>
      </td>
     <td width="10%" align="right"><%if(l_rs.getString(6).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(6)); %>
      </td>  
      <td width="10%" align="right"><%if(l_rs.getString(8).equals("0")){
   	  out.write("");}else
   	  out.write(l_rs.getString(8)); %>
      </td>  	 
    </tr>
        

    <%
      i += 1;
      if (i == 100) break;
    }
    %>
    
    <tr  width="100%" class="browse-bar b-105" style="height:2.5em;">
      <td align="right" colspan="5">
        <div class="browse-index browse-index-contributor">

        <%if (previous >= 0) 
        {
          out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"'>First</a> ");
   	  out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol +"&pno=" + previous + "'>Previous</a>  ");
        }
        int start = pageno-4;
        if (start <= 0) start = 0;
        int max = (int)(Math.ceil((recordCount-1)/100));
        if (max >= 1) 
        {
	  if (start + 19 > max && max > 19) start = max-19;
	  for(int j=0;j<=19;j++) 
	  {       
	    if (j+start <= max) 
	    {
	      int k= j+start;      	 
	      String bold = ">"+(k+1);
	      if (k == pageno) bold = "class='b-106 bold'>" + (k+1) + "";
	      out.println("<a href='?letter=" + letter +"&order="+ sortOrd +"&col="+ sortCol+"&pno="+ k +"'"+bold+"</a>");
	    }
	  }
	  if (i == 100 && l_rs.next()) 
	  {
	    out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" + next + "'>Next</a> ");
	    out.println("<a href='?letter=" + letter + "&order="+ sortOrd +"&col="+ sortCol+"&pno=" +(recordCount-1)/100 +"'>Last</a> ");
	 }
        }
        %>  		
        </div> 
      </td>
    </tr>
  </form>
</table>
<cms:include property="template" element="foot" />
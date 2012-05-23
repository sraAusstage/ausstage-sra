<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="admin.Common, java.util.*,java.sql.*, ausstage.Database, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<!--Include the header from the OpenCMS template -->
<cms:include property="template" element="head" />
<%@ include file="/system/modules/au.edu.flinders.ausstage/public/common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<!--Script to enable sorting columns  -->

<!--Adding inline styles to the page-->
<style>
  #bar {
     padding: 10px;
    margin: 5px;
  }
</style>

<br>
<%
  int rowCounter = 0;                  // counts the number of rows emitted
  int evenOddValue = 0;                // alternates between 0 and 1
  String[] evenOdd = {"b-195", "b-172"};  // two-element String array
  
  String        sqlString; 
  String        sqlString1;
  String validSql = "table_name table_rows";
  
  ausstage.Database     m_db = new ausstage.Database ();
  CachedRowSet  l_rs     = null;
  CachedRowSet  l_rs1     = null;

  admin.AppConstants constants = new admin.AppConstants();
  m_db.connDatabase(constants.DB_ADMIN_USER_NAME, constants.DB_ADMIN_USER_PASSWORD);
  Statement stmt    = m_db.m_conn.createStatement ();
  Statement stmt1   = m_db.m_conn.createStatement ();    
 
%>
<table width="100%">
  <form name="form_searchSort_report" method="POST" action=".">
  <%-- These are hidden inputs that will be populated by the reSortData() JavaScript function. --%>
   
    <tr width="100%" id="bar" class="b-186">
      <td width="40%"><b>Name</b></td>
      <td width="20%" align="left"><b>Number of Rows</b></td>      
    </tr>
    <%
      sqlString = 	"Select table_name, table_rows from information_schema.tables where table_schema = 'ausstage_schema'";
      l_rs = m_db.runSQL (sqlString, stmt);
      int i = 0;  
      while (l_rs.next() && l_rs.getString(1) != null && !l_rs.getString(1).equals(""))
      {
      rowCounter++;
        // set evenOddValue to 0 or 1 based on rowCounter
 	evenOddValue = 1;
  	if (rowCounter % 2 == 0) evenOddValue = 0;
      %>
      <tr class="<%=evenOdd[evenOddValue]%>">
        <td width="40%"><%=l_rs.getString(1)%></td>
        <%
        sqlString1 = 	"Select count(*) from `" + l_rs.getString(1) + "`";
        l_rs1 = m_db.runSQL (sqlString1, stmt1); 
        l_rs1.next();
         %>
         <td width="20%" align="left"><%=l_rs1.getString(1)%></td>
       </tr>
       <%
       out.flush();
    	}
       %>
    
    
  </form>
</table>
<cms:include property="template" element="foot" />
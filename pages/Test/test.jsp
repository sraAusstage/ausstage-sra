<%@ page pageEncoding="UTF-8" %>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*, ausstage.Database, sun.jdbc.rowset.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../public/common.jsp"%>
<cms:include property="template" element="head" />

<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
<div>Please select the first letter of Organisation name</div>
<br>
<div>
  <a href="?letter=A">A</a>
  <a href="?letter=B">B</a>
  <a href="?letter=C">C</a>
  <a href="?letter=D">D</a>
  <a href="?letter=E">E</a>
  <a href="?letter=F">F</a>
  <a href="?letter=G">G</a>
  <a href="?letter=H">H</a>
  <a href="?letter=I">I</a>
  <a href="?letter=J">J</a>
  <a href="?letter=K">K</a>
  <a href="?letter=L">L</a>
  <a href="?letter=M">M</a>
  <a href="?letter=N">N</a>
  <a href="?letter=O">O</a>
  <a href="?letter=P">P</a>
  <a href="?letter=Q">Q</a>
  <a href="?letter=R">R</a>
  <a href="?letter=S">S</a>
  <a href="?letter=T">T</a>
  <a href="?letter=U">U</a>
  <a href="?letter=V">V</a>
  <a href="?letter=W">W</a>
  <a href="?letter=X">X</a>
  <a href="?letter=Y">Y</a>
  <a href="?letter=Z">Z</a>
</div>
<br><br>

<%

ausstage.Database     m_db = new ausstage.Database ();;
CachedRowSet  l_rs     = null;
    String        sqlString;
    String letter = request.getParameter("letter");
    if (letter == null) letter = "";
    if (letter.length() > 1) letter = letter.substring(0,1);
    letter = letter.toLowerCase();
try {
m_db.connDatabase("root", "srasra");
      Statement stmt    = m_db.m_conn.createStatement ();

      sqlString = 	"SELECT  `secgenreclass`.`genreclassid`,secgenreclass.genreclass,min(events.yyyyfirst_date),max(events.yyyylast_date),count(distinct events.eventid)" +
			"FROM secgenreclass LEFT JOIN secgenreclasslink ON (secgenreclass.secgenrepreferredid = secgenreclasslink.secgenrepreferredid)LEFT JOIN events ON (secgenreclasslink.eventid = events.eventid)" +
			"WHERE lcase(`secgenreclass`.genreclass) LIKE '" + letter + "%' group by `secgenreclass`.`genreclassid` Order by secgenreclass.genreclass ";
  			
      l_rs = m_db.runSQL (sqlString, stmt);
        
      while (l_rs.next())
      {
      	%>
      	<a href="indexdrilldown.jsp?=<%=l_rs.getString(1)%>"><%=l_rs.getString(2)%>  </a>,( <%=l_rs.getString(3)%> - <%=l_rs.getString(4)%>) ,<%=l_rs.getString(5)%>.
      	<br><%
      }
} catch (Exception e) {
	throw new Exception("Error!");
}
%>
</table>
<cms:include property="template" element="foot" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../public/common.jsp"%>
<cms:include property="template" element="head" />

<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
 <div id="topbar">
    <a href="../pages/default.jsp" title="Basic Search">Basic Search</a> 
    <a href="../pages/advancedsearch.jsp" title="Event Search">Event Search</a> 
    <a href="../pages/resourcesearch.jsp" title="Resource Search">Resource Search</a>
    <a href="queries.jsp" title="Contact information">Whats On</a>
  </div>

  <tr bgcolor="#FFFFFF">
    <td>&nbsp;</td>
    <td><br>
      <%@ include file="ausstage/whats_on_search_form.jsp"%>
    </td>
  </tr>
  <tr>
    <td align="left" valign="top" bgcolor="#ffffff">
    </td>
  </tr>

  <tr bgcolor="#FFFFFF">
    <td>&nbsp;</td>
    <td>
      <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="content">
        <tr bgcolor="#FFFFFF">
          <td width="10">&nbsp;</td>
          <td width="10">&nbsp;</td>
          <td width="100%"><br> <%@ include file="ausstage/whats_on_search_result.jsp"%></td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<cms:include property="template" element="foot" />
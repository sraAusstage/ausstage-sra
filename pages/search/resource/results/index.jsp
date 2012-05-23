<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%@ include file="../../../../public/common.jsp"%>
<body topmargin="0" leftmargin="0" bgproperties="fixed" bgcolor="#333333">
<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
<%@ include file="../../../../templates/MainMenu.jsp"%>
<tr>
  <td bgcolor="#FFFFFF"><%@ include file="resource_search_result.jsp"%></td>
</tr>
</table>
<cms:include property="template" element="foot" />
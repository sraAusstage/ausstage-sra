<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>
<cms:include property="template" element="head" />

<%@ include file="../../../public/common.jsp"%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
  <tr>
    <td>
      <table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
<%@ include file="../../../templates/MainMenu.jsp"%>

        <tr bgcolor="#FFFFFF">
	  <td width="10px" background='ausstagebgside.gif'>&nbsp;</td>
	  <td><%@ include file="advanced_search_form.jsp"%></td>
	</tr>
      </table>
    </td>
  </tr>
</table>
<cms:include property="template" element="foot" />
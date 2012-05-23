<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<%@ include file="../../templates/MainMenu.jsp"%>

<table width="100%" align="right" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
  <tr>
    <td bgcolor="#FFFFFF"><%@ include file="event_search_result_drill_down.jsp"%></td>
  </tr>
</table>
   
<cms:include property="template" element="foot" />
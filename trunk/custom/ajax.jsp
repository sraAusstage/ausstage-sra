<% response.setHeader("Cache-Control","no-store"); /*HTTP 1.1 */ response.addHeader("Pragma","no-cache"); /*HTTP 1.0*/ response.setDateHeader ("Expires", 0); /*prevents caching at the proxy server*/ %><%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="ausstage.*, java.sql.Statement, sun.jdbc.rowset.CachedRowSet, java.util.*, ausstage.AusstageCommon" %><%
  String ajaxType = request.getParameter("ajaxType");
  ausstage.Database          db_ausstage          = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 
  if (ajaxType.equals("CODE_ASSOCIATION")) {
    String code1LovId = request.getParameter("code1LovId");

    ArrayList associatedLookUps = CodeAssociation.getAssociatedLookupCodes(code1LovId, "", db_ausstage);
    if (request.getParameter("additionalOption") != null) {
      out.print(request.getParameter("additionalOption") + "~0#"); // Add a additional option eg Please select the Resource Type'
    }
    if (associatedLookUps != null) {
      ArrayList codeLovIds   = (ArrayList)associatedLookUps.get(0); // First array within the array is codeLovIds
      ArrayList descriptions = (ArrayList)associatedLookUps.get(1); // Second array within the array is the descriptions for the codeLovIds
      for(int i = 0; i<codeLovIds.size(); i++) {
        out.print(descriptions.get(i) + "~" + codeLovIds.get(i) + "#");
      }
    }
  }
  db_ausstage.disconnectDatabase();
%>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%  

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement                stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.SecondaryGenre  second_genre  = new ausstage.SecondaryGenre (db_ausstage);

  String sect_genre_id = request.getParameter("f_select_this_sec_genre_id");
  pageFormater.writeHeader(out);

  if(sect_genre_id != null && !sect_genre_id.equals("")){

    second_genre.loadLinkedProperties(Integer.parseInt(sect_genre_id));
    pageFormater.writePageTableHeader (out, "Selected Preferred Term", ausstage_main_page_link);
    pageFormater.writeTwoColTableHeader (out, "Secondary Genre id:");
    out.println("<b>" + second_genre.getId() + "</b>"); 
    pageFormater.writeTwoColTableFooter (out);
  
    pageFormater.writeTwoColTableHeader (out, "Secondary Genre:");
    out.println("<b>" + second_genre.getName() + "</b>"); 
    pageFormater.writeTwoColTableFooter (out);
    
  }else{
    pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
    out.println("You have not selected a Secondary Genre to preview.<br>Please click the tick button to return to the event linking page.");
  }
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "BACK", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();
%><cms:include property="template" element="foot" />
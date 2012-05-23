<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%
  admin.ValidateLogin     login             = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage        pageFormater      = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database          db_ausstage       = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  ausstage.AusstageReports reccountreport = null;
    
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Record Count Report", AusstageCommon.ausstage_main_page_link);
  String commadelimfilename = "";
  
  reccountreport = new ausstage.AusstageReports (db_ausstage, request, "report_record_count.csv");
  boolean success = reccountreport.ExecuteQuery();
  if (!success){
    out.println (reccountreport.getErrorMessage());
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");
  }else{
    commadelimfilename = reccountreport.getCommaDelimFileName();
      
    if(!commadelimfilename.equals("")){
      out.println("<p>Generating Record Count report was successful.<br>");
      out.print("You can <a href=\"../../custom/reports/" + reccountreport.getCommaDelimFileName() + "\"");
      out.print("><font COLOR='#99CF16'>click here</font></a> to get the comma delimited file. ");
      out.print("(size " + reccountreport.getCommaDelimFileSize() + "KB)</p>");
      
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons(out, "", "", "", "", "BACK", "tick.gif");
      
    }else{
    
      out.println ("Report generator did not return any result(s).");
      pageFormater.writePageTableFooter (out);
      pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");  
      
    }
  }
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();

%>

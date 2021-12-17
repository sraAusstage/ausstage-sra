<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  CachedRowSet  rset;
  String delimited_country_ids =  request.getParameter("f_delimeted_ids_11_0");
  String countryLeadingSubString = "", countryTrailingSubString = "";
  
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.Country country             = new ausstage.Country (db_ausstage);

  // get the EVENT object from session
  ausstage.Event eventObj = new ausstage.Event(db_ausstage);
  eventObj = (ausstage.Event) session.getAttribute("eventObj");
  eventObj.setEventAttributes(request);

  // reset/set the state of the EVENT object
  session.setAttribute("eventObj",eventObj);
  
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", ausstage_main_page_link);
%>
  <form action='event_country_play_select_process.jsp' name='content_form' id='content_form' method='post'><%

  pageFormater.writeHelper(out, "Select Country", "helpers_no1.gif");
  rset = country.getCountries (stmt);

     
  if (rset.next ())
  {
    pageFormater.writeTwoColTableHeader(out, "");
%>
    <select name='f_id' class='line250' size='15' multiple>
<%
    // We have at least one country
    do
    {%>
<%
      String selected = "";

      // deal with the current selected item(s)
      if(delimited_country_ids.indexOf(",") != -1){
        StringTokenizer str_id_tokens = new StringTokenizer(delimited_country_ids,",");
        while(str_id_tokens.hasMoreTokens()){
          if(delimited_country_ids != null 
           && !delimited_country_ids.equals("") 
           && Integer.parseInt(rset.getString ("countryid")) == Integer.parseInt(str_id_tokens.nextToken())){
            selected = "selected";
            break;
          }
        }
      }else{
        if(delimited_country_ids != null 
           && !delimited_country_ids.equals("") 
           && Integer.parseInt(rset.getString ("countryid")) == Integer.parseInt(delimited_country_ids))
          selected = "selected";
      }
      
      if(!rset.getString ("countryname").toLowerCase().equals("australia")){
        countryTrailingSubString += "<option " + selected + " value='" + rset.getString ("countryid") + "'" +
                                    ">" + rset.getString ("countryname") + "</option>\n";
      }else{
        countryLeadingSubString = "<option " + selected + " value='" + rset.getString ("countryid") + "'>" + rset.getString ("countryname") + "</option>\n";
      }
    }
    while (rset.next ());
    out.println(countryLeadingSubString + countryTrailingSubString);
%>
    </select>
<%
    pageFormater.writeTwoColTableFooter(out);
  }

  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT", "next.gif");
  pageFormater.writeFooter(out);
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />
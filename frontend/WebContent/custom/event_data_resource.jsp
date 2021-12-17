<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<%  
  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Event Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  String eventid = request.getParameter("f_eventid");
  String data_sources_ids = request.getParameter("f_delimeted_ids_4");
                    
  CachedRowSet  rset;
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt          = db_ausstage.m_conn.createStatement ();
  ausstage.Datasource    datasource    = new ausstage.Datasource (db_ausstage);

  // get the EVENT object from session
  ausstage.Event eventObj = new ausstage.Event(db_ausstage);
  eventObj = (ausstage.Event) session.getAttribute("eventObj");
  eventObj.setEventAttributes(request);

  // reset/set the state of the EVENT object
  session.setAttribute("eventObj",eventObj);

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Select Data Source(s)", AusstageCommon.ausstage_main_page_link);


%>
  <form action='event_data_resource_link.jsp' name='content_form' id='content_form' method='post' onsubmit="finalise();">
    <input type="hidden" name="f_eventid" value="<%=request.getParameter("f_eventid")%>">
<%
  rset = datasource.getDataSources (stmt);
  if (rset.next())
  {
%>
    <select name='f_id_list' class='line300' size='15'><%
    // We have at least one datasource
    do
    {
%>
      <option value='<%=rset.getString ("DATASOURCEID")%>'><%=rset.getString ("DATASOURCE")%></option>
<%
    }
    while (rset.next ());

%>
    </select>
<%
  }
  out.println("<br><br><input type='button' value='Select' onclick=\"addtoSelected();\"><br><br>");
  out.println("Selected Data Source");
  out.println("<br><br><select name='f_id' class='line300' size='10' multiple>\n");

  for(int x=0; x < eventObj.getDataSources().size(); x++){  
%>
  <option value='<%=((ausstage.Datasource)eventObj.getDataSources().elementAt(x)).getId()%>'><%=((ausstage.Datasource)eventObj.getDataSources().elementAt(x)).getName()%></option>
<%
  }
  
  out.println("\t</select>\n"); 
  
  rset.close ();
  stmt.close ();
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif");
  pageFormater.writeFooter(out);
%>
  </form>
  <script language="javascript"><!--
  
    function finalise(){
      var f_sel_list  = window.document.content_form.f_id;
      var i;
      for(i =0; i < f_sel_list.length; i++)
        f_sel_list.options[i].selected = true;
        
      window.document.content_form.submit();
    }
    
    function addtoSelected(){
      var f_list      = window.document.content_form.f_id_list;
      var f_sel_list  = window.document.content_form.f_id;
      
      var index       = f_list.selectedIndex;
      var sel_index   = f_sel_list.selectedIndex;
      var selected_id;
      var selected_name;
      var i = 0;
      //var found = false;
    
      if((index > -1 && sel_index == -1) || (index == -1 && sel_index > -1)){

        if(index > -1){                                                       
          // repository list is selected, so put it to the selected list
          selected_id   = f_list.options[index].value;
          selected_name = f_list.options[index].text;
         
          if(selected_name != ""){
            if(f_sel_list.options.length != 0){
              f_sel_list.options[f_sel_list.options.length] = new Option(selected_name, selected_id, false, false); // add to selected list
            }else{
              f_sel_list.options[0] = new Option(selected_name, selected_id); // add to selected list
            }
          }
        }else{
          // remove from the selected list
          f_sel_list.options[sel_index] = null; 
        }
      }else{
        alert("You have not selected a Data Source to Add/Remove.");
      }
      f_list.selectedIndex     = -1;
      f_sel_list.selectedIndex = -1;
    }
  //--></script>
<jsp:include page="../templates/admin-footer.jsp" />
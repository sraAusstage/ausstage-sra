<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %><%@ page  import = "java.sql.*, sun.jdbc.rowset.*, java.util.*, ausstage.Datasource"%>
<cms:include property="template" element="head" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
	admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage pageFormater = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database   db_ausstage  = new ausstage.Database ();
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  
  String delimeted_data_sources_ids = "";
  String[] data_sources_ids         = request.getParameterValues("f_id");
  int eventId                       = Integer.parseInt(request.getParameter("f_eventid"));

  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "Select Data Source(s)", AusstageCommon.ausstage_main_page_link);
  
  if(data_sources_ids != null && !data_sources_ids.equals("")){

    // get the EVENT object from session
    ausstage.Event eventObj = new ausstage.Event(db_ausstage);
    eventObj = (ausstage.Event) session.getAttribute("eventObj");
    Vector datasource_vector = new Vector(); 

    // store the selected ones from the previous page's list
    String datasourceevelinkids = "";
    for(int i= 0; i < data_sources_ids.length; i++){
      ausstage.Datasource datasource = new ausstage.Datasource(db_ausstage);   
      if(i==0){
        datasource.loadLinkedProperties(Integer.parseInt(data_sources_ids[i]), eventId, "0");
      }else{
        if(datasourceevelinkids.equals("")){
          if(!((ausstage.Datasource)datasource_vector.elementAt(i-1)).getDatasoureEvlinkId().equals(""))
            datasourceevelinkids = ((ausstage.Datasource)datasource_vector.elementAt(i-1)).getDatasoureEvlinkId();
        }else{
          if(!((ausstage.Datasource)datasource_vector.elementAt(i-1)).getDatasoureEvlinkId().equals(""))
            datasourceevelinkids += "," + ((ausstage.Datasource)datasource_vector.elementAt(i-1)).getDatasoureEvlinkId();            
        }
        // lets check if there are any datasource previously associated
        // to this event.
        if(!eventObj.getDataSources().isEmpty() && !datasourceevelinkids.equals(""))
          datasource.loadLinkedProperties(Integer.parseInt(data_sources_ids[i]), eventId, datasourceevelinkids);    
        else
          datasource.loadLinkedProperties(Integer.parseInt(data_sources_ids[i]), eventId, "0");    
      }        
      datasource_vector.addElement(datasource);
    }

     if(!eventObj.getDataSources().isEmpty()){
      // find out if selected ones exists in the event bean
      for(int i =0; i < datasource_vector.size(); i++){
        for(int x =0; x < eventObj.getDataSources().size(); x++){
          if(((ausstage.Datasource) eventObj.getDataSources().elementAt(x)).getDatasoureEvlinkId().equals(((ausstage.Datasource)datasource_vector.elementAt(i)).getDatasoureEvlinkId())){
            // we have a selected one in the previous page's list that exist in the event bean,
            // so lets get that one from the event bean and place it to the current index
            // thus, preserving the old state of the object ie. description, is part of collection etc.
            datasource_vector.removeElementAt(i);
            datasource_vector.insertElementAt(((ausstage.Datasource) eventObj.getDataSources().elementAt(x)),i);
            Vector tmp_vec = eventObj.getDataSources();
            tmp_vec.removeElementAt(x);
            eventObj.setDataSources(tmp_vec);
            break;
          }
        }  
      }
    }

    // set the vector Datasources EVENT member
    eventObj.setDataSources(datasource_vector);
    session.setAttribute("eventObj",eventObj);
%>
    <form action='event_data_resource_link_process.jsp' name='content_form' id='content_form' method='post'>
      <input type="hidden" name="f_eventid" value="<%=request.getParameter("f_eventid")%>">
      <table cellspacing='0' cellpadding='0' border='0' width='450'>
        <tr>
          <td class="bodytext" width="190"><B>Selected Data Source</B></td>
          <td width="5">&nbsp;</td>
          <td class="bodytext" width="200"><B>Data Source Description</B></td>
          <td width="5">&nbsp;</td>
          <td colspan="2" class="bodytext"><B>Collection</B></td>
        </tr>  
<%
  	// We have at least one datasource
        for(int i= 0; i < datasource_vector.size(); i++){
          ausstage.Datasource datasource = (ausstage.Datasource) datasource_vector.elementAt(i);
  %>
      <tr>
        <td class="bodytext" width="190"><%=datasource.getName()%></td>
        <td width="5">&nbsp;</td>
        <td class="bodytext" width="170"><textarea name="f_datasource_desc_<%=i%>" row="5" cols="20"><%=datasource.getDescription()%></textarea></td>
        <td width="1">&nbsp;</td>
<%
        if(datasource.getCollection().equals("yes")){
%>
           <td width="50" class="bodytext">Yes<input type="radio" checked name="f_datasource_collection_<%=i%>" value="yes"></td>
           <td width="40" class="bodytext">No<input type="radio" name="f_datasource_collection_<%=i%>" value="no"></td>
<%
        }else{
%>
          <td width="50" class="bodytext">Yes<input type="radio" name="f_datasource_collection_<%=i%>" value="yes"></td>
          <td width="40" class="bodytext">No<input type="radio" checked name="f_datasource_collection_<%=i%>" value="no"></td>
<%      }%>
      </tr>
      <input type="hidden" name="f_datasource_<%=i%>" value="<%=datasource.getId()%>">
<%
        // build the data sources ids
        if(delimeted_data_sources_ids.equals(""))
          delimeted_data_sources_ids = Integer.toString(datasource.getId());
        else
          delimeted_data_sources_ids += "," + Integer.toString(datasource.getId());
      }
%>
      </table>
<%
  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "SUBMIT" , "next.gif");
%>
  <input type="hidden" name="f_delimeted_data_sources_ids" value="<%=delimeted_data_sources_ids%>">
<%
    
  }else{
    out.println("You have not selected a Data Source to link.<br>Please click the back button to return to the Data Source list page.");
    pageFormater.writePageTableFooter (out);
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", ""); 
  }
  pageFormater.writeFooter(out);
  
%>
  </form>
<cms:include property="template" element="foot" />
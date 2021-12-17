<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.*"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
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
  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);

  String delimeted_data_sources_ids = request.getParameter("f_delimeted_data_sources_ids");
  String eventid = request.getParameter("f_eventid");
  //String data_source_id = "";
  String datasourcedesc = "";  
  String datasource_collection = "";
  String error_msg = "";
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);



  // get the EVENT object from session
  ausstage.Event eventObj = new ausstage.Event(db_ausstage);
  eventObj = (ausstage.Event) session.getAttribute("eventObj");

  // use vector to handle the objects
  Vector datasource_vector = new Vector();
  Vector temp_vec = eventObj.getDataSources();
  
  try{

    for(int i= 0; i < temp_vec.size(); i++){  

      // get data from the request object
      //datasourcedesc        = request.getParameter("f_datasource_desc_" + Integer.toString(((ausstage.Datasource) temp_vec.elementAt(i)).getId()));  
      //datasource_collection = request.getParameter("f_datasource_collection_" + Integer.toString(((ausstage.Datasource) temp_vec.elementAt(i)).getId()));  

      datasourcedesc        = request.getParameter("f_datasource_desc_" + i);  
      datasource_collection = request.getParameter("f_datasource_collection_" + i);    

      // create new Datasource
      ausstage.Datasource datasource = new ausstage.Datasource(db_ausstage);

      // set the state of the object
      datasource.setId(Integer.toString(((ausstage.Datasource) temp_vec.elementAt(i)).getId()));
      datasource.setDatasoureEvlinkId(((ausstage.Datasource) temp_vec.elementAt(i)).getDatasoureEvlinkId());
      datasource.setName(((ausstage.Datasource) temp_vec.elementAt(i)).getName());

      // add description
      if(datasourcedesc != null)
        datasource.setDescription(datasourcedesc);            
      else
        datasource.setDescription("");        

      // add yes/no for collection
      datasource.setCollection(datasource_collection);
      // add the object to the vector
      datasource_vector.addElement(datasource);
                      
    }
  }catch(Exception e){
      error_msg = "Data Source and Event linking was unsuccessful.<br>Click the tick button to continue.";
    }

  if(error_msg.equals("")){
    // set the vector Datasources EVENT member
    eventObj.setDataSources(datasource_vector);
    session.setAttribute("eventObj",eventObj);
    
    pageFormater.writeText (out, "Data Source and Event linking was successful.<br>Click the tick button to continue.");
  }else{
    pageFormater.writeText (out, error_msg);
  }
  
  pageFormater.writePageTableFooter (out);
  pageFormater.writeButtons (out, "", "", "", "", "event_addedit.jsp", "tick.gif");
  pageFormater.writeFooter(out);
  db_ausstage.disconnectDatabase();


  

%>
<jsp:include page="../templates/admin-footer.jsp" />
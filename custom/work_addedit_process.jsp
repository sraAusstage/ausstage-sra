<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, ausstage.Work, ausstage.WorkCountryLink, java.util.Vector"%>
<cms:include property="template" element="head" /><%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%
  admin.ValidateLogin   login = (admin.ValidateLogin) session.getAttribute("login");
  admin.FormatPage      pageFormater    = (admin.FormatPage) session.getAttribute("pageFormater");
  ausstage.Database        db_ausstage     = new ausstage.Database ();
  Work                  work            = null;            
  boolean               error_occurred  = false;
  CachedRowSet          rset;
  String                workid;
  String country_ids    = request.getParameter("delimited_country_ids");
   
  Vector countries	=new Vector();
  String                action          = request.getParameter("action");
  if (action == null) action = "";


  db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
 
  pageFormater.writeHeader(out);
  pageFormater.writePageTableHeader (out, "", AusstageCommon.ausstage_main_page_link);
    
  //get the work object out of the session.
  work = (Work)session.getAttribute("work");
  //The entered user is only set on insert and the updated user is only updated on update. This is controlled in the work.java
  work.setEnteredByUser((String)session.getAttribute("fullUserName"));
  work.setUpdatedByUser((String)session.getAttribute("fullUserName"));
  
  // Update with new data from form
  work.setWorkAttributes(request);  
  
  
  workid = request.getParameter ("f_workid");

  //using delimiter list of country ids make a Vector of country links.
  /* for (String country: country_ids.split(",")){
      	System.out.println("/**** at here **"+country+"++");
   	if(country != null && !country.equals("") && !country.equals(" ") && !country.equals("[]")){
   	System.out.println("/****** adding country");
	   	WorkCountryLink workCountry = new WorkCountryLink(db_ausstage); 	
		workCountry.setCountryId(country);
		workCountry.setWorkId(workid);
		countries.add(workCountry);
	}
      }
*/	

  if (workid == null || workid.equals("0") || workid.equals("null")){
    //therefore adding a work, no id has been assigned yet.
    workid = "-1";
  }
  
  session.setAttribute("work", work);
  work.setDatabaseConnection(db_ausstage); // Refresh connection


  //work.setWorkCountries(countries);
  // adding a work
  if (workid.equals ("-1"))
  {
    System.out.println("adding work");
    error_occurred = !work.addWork();
  }
  //deleting a work
  else if(action != null && !action.equals("") && action.equals("delete")){
    System.out.println("deleting work");
    error_occurred = !work.deleteWork();
  }
  else // Editing a work
  {
    if(action != null && !action.equals("") && action.equals("copy")){
      System.out.println("copy work");
      error_occurred = !work.addWork();
    }
    else{
      System.out.println("****Countries "+work.getAssociatedCountries());
      error_occurred = !work.updateWork();
      System.out.println("update work");
    }
  }

  // Error
  if (error_occurred){
    out.println (work.getErrorMessage());
  }
  else{
    if(action != null && !action.equals("") && action.equals("delete"))
      pageFormater.writeText(out,"The work with a title of <b>" + work.getWorkTitle() +
                   "</b> was successfully deleted");
    else
      pageFormater.writeText(out,"The work with a title of <b>" + work.getWorkTitle() +
                   "</b> was successfully saved");
  }

  db_ausstage.disconnectDatabase();
  pageFormater.writePageTableFooter (out);
  if (error_occurred)
    pageFormater.writeButtons (out, "BACK", "prev.gif", "", "", "", "");  
  else if (action != null && action.equals("ForItem")|| action.equals("isPreviewForItemWork") )
    pageFormater.writeButtons (out, "", "", "", "", "item_work.jsp", "tick.gif");
  else if (action != null && action.equals("ForEvent") )
    pageFormater.writeButtons (out, "", "", "", "", "event_work.jsp", "tick.gif");
  else
    pageFormater.writeButtons(out, "", "", "", "", "work_search.jsp", "tick.gif");
  
  pageFormater.writeFooter(out);
%>
</form>

<cms:include property="template" element="foot" />
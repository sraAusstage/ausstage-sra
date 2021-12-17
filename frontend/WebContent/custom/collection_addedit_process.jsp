<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, ausstage.WebLinks, java.sql.Statement, sun.jdbc.rowset.*, ausstage.Collection"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ include file="ausstage_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />
<%

  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
  if (!session.getAttribute("permissions").toString().contains("Collection Information Access Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }

	String exhibitionid = request.getParameter("id");;
	
	//get event data
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	Statement stmt = m_db.m_conn.createStatement();
	
	
	CachedRowSet rowSetExhibitions = null;
	String sqlExhibitions = 
	"SELECT\n" +
	"	`exhibition`.`exhibitionid`,\n" +
	"	`exhibition`.`name`,\n" +
	"	`exhibition`.`description`,\n" +
	"	`exhibition`.`published_flag`,\n" +
	"	`exhibition`.`owner`,\n" +
	"	`exhibition`.`entered_by_user`,\n" +
	"	`exhibition`.`entered_date`,\n" +
	"	`exhibition`.`updated_by_user`,\n" +
	"	`exhibition`.`updated_date`,\n" +
	"	`exhibition_section`.`exhibition_sectionid`,\n" +
	"	`exhibition_section`.`heading`,\n" +
	"	`exhibition_section`.`text`,\n" +
	"	`exhibition_section`.`sequencenumber`,\n" +
	//"	`exhibition_section`.`exhibitionid`,\n" +
	"	`exhibition_section`.`itemid`,\n" +
	"	`exhibition_section`.`organisationid`,\n" +
	"	`exhibition_section`.`eventid`,\n" +
	"	`exhibition_section`.`venueid`,\n" +
	"	`exhibition_section`.`contributorid`\n" +
	"FROM \n" +
	"	`ausstage_schema`.`exhibition` left outer join \n" +
	"	`ausstage_schema`.`exhibition_section` on `exhibition`.`exhibitionid` = `exhibition_section`.`exhibitionid` \n" +
	"WHERE \n" +
	"	`exhibition`.`exhibitionid` = " + exhibitionid + " \n" +
	"ORDER BY \n" +
	"	`exhibition_section`.`sequencenumber`"  ;
	

	out.println("<!-- " + sqlExhibitions  + " -->");

	rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);





                 
  //m_db.disconnectDatabase();
%>
</form>
<jsp:include page="../templates/admin-footer.jsp" />
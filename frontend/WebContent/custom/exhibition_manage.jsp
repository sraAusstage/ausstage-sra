<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>


<%--@ page import = "java.util.Vector, java.text.SimpleDateFormat"--%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "admin.Common"%>

<%@ page session="true" import="java.lang.String, java.util.*" %>

<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../public/common.jsp"%>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>

<!-- exhibition_manage.jsp specific style sheets -->
<link rel="stylesheet" href="/resources/exhibition.css"/>
<link rel="stylesheet" href="/pages/assets/javascript/libraries/bootstrap-3.3.7/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/pages/assets/styles/bootstrap-override.css">

<jsp:include page="../templates/admin-header.jsp" />
<div class="heading-bar" style="margin-bottom:10px;margin-top:0px;">Manage Exhibitions</div>

<div class='alert alert-info'>
<p><i class="glyphicon glyphicon-info-sign"></i> This area allows you to manage your personal ausstage exhibitions.</p>
<p>Create an exhibition, and then browse Ausstage to add events, contributors, venues, organisitions, resources and your own notes. Once you have created an exhibition and added records, you can view or edit your exhibition , rearrange the records and add text and headings.</p>
<p>Published exhibitions will be visible to everyone in the public gallery. Unpublished exhibitions will be visible only to you.					</p>
</div>


<h4 class='gridHeader'>Create new exhibition space</h4>
    <div class=''>
	<form  id="exhibition_form" onsubmit="return validateAndCreate();">


          <div style="	
        			background-color: #c8c8c8;
        			margin-left: auto;
        			margin-right: auto;
				padding: 16px;
    			        padding-bottom: 0px;">		
	        <input type="hidden" name="action" value="new">
	        <div class="row">
                    <div class="col-md-12" style="padding-right:0;padding-left:10px">Exhibition Title *</div>
	            <div class="col-md-12" style="padding-right:0;padding-left:10px">
        	        <input type='text' class="txtTypeHeading" maxlength="250" name='name' id="name" value='' style='width: calc(100% - 41px);' required='true'  >
	            </div>
        	</div>
                <div class="row">
	            <div class="col-md-12" style="padding-right:0;padding-left:10px">Description</div>
	            <div class="col-md-12" style="padding-right:0;padding-left:10px">
                        <textarea name='description' id='description' class="txtTypeTextArea" maxlength="998" rows='4' style='width: calc(100% - 41px);' ></textarea>
                    </div>
				
		</div>
	       	<div class="row" style="text-align:right">
	       	    	<div class="col-md-12 edit-exhibition-tools" style="padding-right:0;padding-left:10px;text-align:right">
                		<a style="padding-right:25px;" href="#" onclick="validateAndCreate()">CREATE</a>
          	   	</div>
                </div>
          </div>


   	</form>	
    </div>		


<h4 class='gridHeader'>Your exhibition spaces</h4>

	<div style="width: 100%;">

		<div class='exhibition-tile ' id='exhibitionTileTemplate' style="display:none">
		
			<div class='exhibition-title ' >
				<div style='width: 32px;display: inline-block;height: 100%;float:left' class='b-153'>
							<img src='/resources/images/icon-exhibition.png' class='browse-icon'/>
						</div>
				<div class='exhibitionHeader' style="padding-left:38px">
					T_NAME
				</div>

				<div class='curated-text'>
				<span class="text-danger">NOT PUBLISHED</span>
				</div>
			</div>
			<div class='exhibition-blurb' >
				<div style='padding:10px;'>
					T_DESCRIPTION
				</div>
				<div style=' position: absolute; bottom:3px; right:13px;' class='edit-exhibition-tools' >
					<a href="/custom/exhibition_addedit.jsp?id=T_ID">EDIT</a> | 
					<a href="/pages/exhibition/index.jsp?id=T_ID">VIEW</a> | 
					<!-- use ajax to delete -->
					<a href="#" onclick="confirmDelete('T_NAME', T_ID);">DELETE</a>
				</div>
			</div>
			
		</div>
		<div id="currentExhibitions">	  
	<%
	  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	if (!session.getAttribute("permissions").toString().contains("Exhibition Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
		response.sendRedirect("/custom/welcome.jsp" );
		return;
	}
	//get event data
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	Statement stmt = m_db.m_conn.createStatement();
	
	String userName = (String)session.getAttribute("fullUserName");
	
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
		"	fn_get_group_concat_contributor(`exhibition`.`exhibitionid`) `curator`\n" +      
		"FROM \n" +
		"	`exhibition`\n" +
		"WHERE\n" +
		"	`exhibition`.`owner` = '" + userName  + "'\n" +
		" ORDER BY name ASC";
	rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);
	
	if (rowSetExhibitions != null && rowSetExhibitions .size() > 0) {
		while (rowSetExhibitions .next()) {
			%>

			<div class='exhibition-tile ' id='<%= rowSetExhibitions.getString("exhibitionid") %>'>
			
				<div class='exhibition-title ' >
					<div style='width: 32px;display: inline-block;height: 100%;float:left' class='b-153'>
							<img src='/resources/images/icon-exhibition.png' class='browse-icon'/>
					</div>
					<div class='exhibitionHeader' style="padding-left:38px">
						
							<%= rowSetExhibitions.getString("name") %>

					</div>
					
					<div class='curated-text'>
					<%if (rowSetExhibitions.getString("published_flag").equals("Y")){
					%>
					<span class="text-success">PUBLISHED</span>
					<%
					}else {
					%>
					<span class="text-danger">NOT PUBLISHED</span>
					<%
					}
					
					%>
					</div>
				</div>
				<div class='exhibition-blurb' >
					<div style='padding:10px;'>
						<%=rowSetExhibitions.getString("description")%>
					</div>
					<div style=' position: absolute; bottom:3px; right:13px;' class='edit-exhibition-tools' >
						<a href="/custom/exhibition_addedit.jsp?id=<%= rowSetExhibitions.getString("exhibitionid") %>">EDIT</a> | 
						<a href="/pages/exhibition/index.jsp?id=<%= rowSetExhibitions.getString("exhibitionid") %>">VIEW</a> | 
						<!-- use ajax to delete -->
						<a href="#" onclick="confirmDelete('<%=rowSetExhibitions.getString("name")%>', <%= rowSetExhibitions.getString("exhibitionid") %>);">DELETE</a>
					</div>
				</div>
			</div>

			<%
		}
	}
	//*************************************
	//show all exhibitions for admin users
	
	List<String> groupNames = new ArrayList();
	admin.Authentication ams = new admin.Authentication(new admin.AppConstants(request));
  	groupNames = ams.getUserRoles(session.getAttribute("userName").toString());
	if (groupNames.contains("Administrators")){
		
		%>
		<h4 class='gridHeader'>All exhibition spaces</h4>
		<%
	
		rowSetExhibitions = null;
		sqlExhibitions = 
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
			"	fn_get_group_concat_contributor(`exhibition`.`exhibitionid`) `curator`\n" +      
			"FROM \n" +
			"	`exhibition`\n" +
			" ORDER BY name ASC";
		rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);
		
		
		if (rowSetExhibitions != null && rowSetExhibitions .size() > 0) {
			while (rowSetExhibitions .next()) {
			
				String curatorName = rowSetExhibitions.getString("owner").replaceAll("\\(.*\\)", "");

			if (curatorName.isEmpty()){
				curatorName = rowSetExhibitions.getString("entered_by_user");	
			}
				%>
	
				<div class='exhibition-tile ' id='<%= rowSetExhibitions.getString("exhibitionid") %>'>
				
					<div class='exhibition-title ' >
						<div style='width: 32px;display: inline-block;height: 100%;float:left' class='b-153'>
								<img src='/resources/images/icon-exhibition.png' class='browse-icon'/>
						</div>
						<div class='exhibitionHeader' style="padding-left:38px">
								<%= rowSetExhibitions.getString("name") %>
						</div>
						<div class='' style="padding-left:38px; color:#ccc">
								<%= curatorName %>

						</div>

						
						<div class='curated-text'>
						<%if (rowSetExhibitions.getString("published_flag").equals("Y")){
						%>
						<span class="text-success">PUBLISHED</span>
						<%
						}else {
						%>
						<span class="text-danger">NOT PUBLISHED</span>
						<%
						}
						
						%>
						</div>
					</div>
					<div class='exhibition-blurb' >
						<div style='padding:10px;'>
							<%=rowSetExhibitions.getString("description")%>
						</div>
						<div style=' position: absolute; bottom:3px; right:13px;' class='edit-exhibition-tools' >
							<a href="/custom/exhibition_addedit.jsp?id=<%= rowSetExhibitions.getString("exhibitionid") %>">EDIT</a> | 
							<a href="/pages/exhibition/index.jsp?id=<%= rowSetExhibitions.getString("exhibitionid") %>">VIEW</a> | 
							<!-- use ajax to delete -->
							<a href="#" onclick="confirmDelete('<%=rowSetExhibitions.getString("name")%>', <%= rowSetExhibitions.getString("exhibitionid") %>);">DELETE</a>
						</div>
					</div>
				</div>
	
				<%
			}
		}
	}
	%>		
	</div>
</div>
<script>

//validate and submit - 
//check that exhibition title is not null and submit
function validateAndCreate(){
	//check that exhibition title is not null before creating new exhibition
	var name = $('#name')[0].value;
	var description = $('#description')[0].value;
	if ($('#name')[0].value.length>0){
		$.get( '../pages/exhibition/exhibition_functions/common_ajax.jsp?action=createExhibition&name='+name +'&description='+description , function (data){
		//returns the newly created id
		var newId = $.trim(data);
		if (newId > 0){
			//use the id and other details to get the template DOM and replace all the details and then insert at the top.
			var exhibitionTile = $("#exhibitionTileTemplate").clone();
			exhibitionTile[0].id = newId;
			//clear the create fields
			var innerHtml = exhibitionTile[0].innerHTML;
			innerHtml = innerHtml.replace(/T_ID/g, newId);
			innerHtml = innerHtml.replace(/T_NAME/g, name);
			innerHtml = innerHtml.replace(/T_DESCRIPTION/g, description);
			exhibitionTile[0].innerHTML = innerHtml;
			exhibitionTile.prependTo("#currentExhibitions");
			exhibitionTile.show();
			$('#exhibition_form')[0].reset();
		}
		else {
			alert('An error occurred creating the exhibition');
		}
		

		});

	}
	else {
		alert('An Exhibition Title is required to create a new exhibition');
	}
	return false
}

//confirm delete 
//- confirm delete
//if confirmed then delete the record and remove the div.
function confirmDelete(name, exhibitId){

	if(confirm('Are you sure you want to delete the exhibition - '+name+'?')){
		$.get( '../pages/exhibition/exhibition_functions/common_ajax.jsp?id='+exhibitId+'&action=deleteExhibition' , function (data){
			//remove the tile
			$('#'+exhibitId).remove();	
		});
	}
}

</script>			
	<jsp:include page="../templates/admin-footer.jsp" />


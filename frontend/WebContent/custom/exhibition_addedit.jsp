<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.sql.*, sun.jdbc.rowset.*" %> 

<%@ page session="true" import=" java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../public/common.jsp"%>


   
<!-- Include all the things reqired for Exhibitions -->
 <%@ include file="../pages/exhibition/exhibition_include.jsp"%>       
<!-- INCLUDE HEADER -->
<div class="exhibition-fix">

<jsp:include page="../templates/admin-header.jsp" />
<!-- END HEADER -->

<link rel="stylesheet" href="/resources/exhibition.css">

<!-- Bootstrap -->
        <link rel='stylesheet' href="/resources/bootstrap-3.3.7/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="/resources/bootstrap-toggle-master/css/bootstrap-toggle.min.css"> 
        <link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">        
<!-- override some of bootstraps default settings that clash with existing ausstage styles -->
	<link rel="stylesheet" type="text/css" href="../pages/assets/styles/bootstrap-override.css">
 <!-- libraries here        -->
        <script src="/resources/js/jquery-3.2.1.min.js"></script> 
        <script src="/resources/bootstrap-3.3.7/js/bootstrap.min.js"></script>
        <script src="/resources/bootstrap-toggle-master/js/bootstrap-toggle.min.js"></script>
        <script src="/resources/bootstrap-datepicker-1.6.4-dist/js/bootstrap-datepicker.min.js"></script>
        <script src="/resources/bootstrap-select-1.12.2/dist/js/bootstrap-select.min.js"></script>
        <script src="/resources/jQuery-Drag-drop-Sorting-Plugin-For-Bootstrap-html5sortable/jquery.sortable.min.js"></script>
	<script src="/resources/jquery-show-hide-plugin/showHide.js"></script> 
	
<div class='heading-bar'>Edit Exhibition</div>

	<form id="exhibition_form" action="exhibition_addedit_process.jsp" method="post">

	<%
	  admin.ValidateLogin login = (admin.ValidateLogin) session.getAttribute("login");
	  if (!session.getAttribute("permissions").toString().contains("Exhibition Editor") && !session.getAttribute("permissions").toString().contains("Administrators")) {
		response.sendRedirect("/custom/welcome.jsp" );
		return;
	  }

	String exhibitionid = request.getParameter("id");
	
  	String p_name = request.getParameter("name");
  	String p_description= request.getParameter("description");
	
	String p_itemid = request.getParameter("itemid");
	String p_organisationid = request.getParameter("organisationid");
	String p_eventid = request.getParameter("eventid");
	String p_venueid = request.getParameter("venueid");
	String p_contributorid = request.getParameter("contributorid");
	String p_workid = request.getParameter("workid");
	String p_exhibition_sectionid = request.getParameter("exhibition_sectionid");
	String p_action = request.getParameter("action");
	
	String userName = (String)session.getAttribute("fullUserName");
	
	//get event data
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	
	session.setAttribute("database-connection", m_db);
		
	%>
	  <div class="edit-exhibition-tools sticky" >
	  
		  <a href="#" onclick="addHeading()">ADD HEADING</a> |
		  <a href="#" onclick="addText()">ADD TEXT</a> |
		  <a href="#" onclick="saveExhibition()">SAVE CHANGES</a>
	  </div>
	
	<%
	
	
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
	"	`exhibition_section`.`contributorid`,\n" +
	"	`exhibition_section`.`workid`\n" +
	"FROM \n" +
	"	`exhibition` left outer join \n" +
	"	`exhibition_section` on `exhibition`.`exhibitionid` = `exhibition_section`.`exhibitionid` \n" +
	"WHERE \n" +
	"	`exhibition`.`exhibitionid` = " + exhibitionid + " \n" +
	"ORDER BY \n" +
	"	`exhibition_section`.`sequencenumber`"  ;
	
	try
	{
	
		rowSetExhibitions = m_db.runSQL(sqlExhibitions , stmt);
		
		if (rowSetExhibitions != null && rowSetExhibitions .size() > 0) {
			%><div class='heading-bar exhibition'><%
			if(rowSetExhibitions.next()) {
				%>
				 <input type="hidden" name="exhibitionid" value="<%= exhibitionid %>">
				 <input type="hidden" id="published_flag" name="published_flag" value='<%= rowSetExhibitions.getString("published_flag")%>'>
				<table class="exhibition-detail" style="width:100%">
					<tr>
						<td class='record-label '>EXHIBITION TITLE</td>
						<td>
							<input type='text' class="txtTypeHeading" maxlength="250" name='name' value='<%= rowSetExhibitions.getString("name") %>'>
						</td>
					</tr>
					<tr>
						<td class='record-label '>Description</td>
						<td>
							<textarea name='description' class="txtTypeTextArea" maxlength="998" rows='4' cols='50' style="height:150px"><%= rowSetExhibitions.getString("description") %></textarea>
						</td>
					</tr>
					<tr>
						<td class='record-label '>Publish</td>
						<td>
							<!--<input type="checkbox" name="published_flag" value="Y" <%= ("Y".equals(rowSetExhibitions.getString("published_flag")) ? "checked" : "") %> > -->
							<input type="checkbox" data-size="mini" class="form-control" data-toggle="toggle" data-on="Yes" <%= ("Y".equals(rowSetExhibitions.getString("published_flag")) ? "checked" : "") %> data-off="No" data-onstyle="success" id="published_flag_cbx" name="published_flag_cbx" >
						</td>
					</tr>
				</table>
				
				<%
			}
			%></div>
			
				<ul id="exhibition-sections" class="order-by list-group" style="list-style: none;">		
			
			<%
		
			do {
				String itemid = rowSetExhibitions.getString("itemid");
				String organisationid = rowSetExhibitions.getString("organisationid");
				String eventid = rowSetExhibitions.getString("eventid");
				String venueid = rowSetExhibitions.getString("venueid");
				String contributorid = rowSetExhibitions.getString("contributorid");
				String workid = rowSetExhibitions.getString("workid");
				String heading = rowSetExhibitions.getString("heading");
				String text = rowSetExhibitions.getString("text");
				String exhibition_sectionid= rowSetExhibitions.getString("exhibition_sectionid");
				String sequencenumber = rowSetExhibitions.getString("sequencenumber");
				
				%>
				 <input type="hidden" name="section_id<%= exhibition_sectionid%>_seq" value="<%= sequencenumber %>">
				<%
	
				if(itemid != null && !"".equals(itemid)) {
					%>
					
				<li >
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>" data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">				
						<div style=""><!--Is this div necessary?-->
							<div class="exhibition-edit-bar" style="">
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px; ">
								<!--itemid: <%= itemid%> -->
								<!-- INCLUDE ITEM -->
								<jsp:include page="../pages/exhibition/item.jsp" >
									<jsp:param name="itemid" value="<%= itemid%>"></jsp:param>
								</jsp:include>
								<!-- END ITEM -->
							</div>
						</div>
				     	</div>  
				</li>					
					<%
				} else if(organisationid != null && !"".equals(organisationid )) {
					%>
					
		
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>" data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">				
								
						<div style=""><!--Is this div necessary?-->
							<div class=' exhibition-edit-bar' style="">
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
								<!--organisationid: <%= organisationid %> -->
								<!-- INCLUDE ORG -->
								<jsp:include page="../pages/exhibition/organisation.jsp" >
									<jsp:param name="organisationid" value="<%= organisationid %>"></jsp:param>
								</jsp:include>
								<!-- END ORG -->
							</div>
						</div>
				     	</div>  
				</li>					
						
					<%
				} else if(eventid != null && !"".equals(eventid )) {
					%>
					
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>" data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">					
						<div style=""><!--Is this div necessary?-->
							<div class=' exhibition-edit-bar' style="">
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
								<!--eventid : <%= eventid %> -->
								<!-- INCLUDE EVENT -->
								<jsp:include page="../pages/exhibition/event.jsp" >
									<jsp:param name="eventid" value="<%= eventid %>"></jsp:param>
								</jsp:include>
								<!-- END EVENT -->
							</div>
						</div>
						
				     	</div>  
				</li>					
									
					<%
				} else if(venueid != null && !"".equals(venueid )) {
					%>
					
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>" data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">				
						<div style=""><!--Is this div necessary?-->
							<div class="exhibition-edit-bar" style="">
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
								<!--venueid : <%= venueid %> -->
								<!-- VENUE -->
								<jsp:include page="../pages/exhibition/venue.jsp" >
									<jsp:param name="venueid" value="<%= venueid %>"></jsp:param>
								</jsp:include>
								<!-- END VENUE -->
							</div>
						</div>
				     	</div>  
				</li>					
									
						
					<%
				} else if(contributorid != null && !"".equals(contributorid )) {
					%>
					
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>"  data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">					
						<div style=""><!--Is this div necessary?-->
							<div class='exhibition-edit-bar' style="">
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
								<!--contributorid : <%= contributorid %> -->
								<!-- INCLUDE CONTRIBUTOR -->
								<jsp:include page="../pages/exhibition/contributor.jsp" >
									<jsp:param name="contributorid" value="<%= contributorid %>"></jsp:param>
								</jsp:include>
								<!-- END CONTRIBUTOR -->
							</div>
						</div>
						
				     	</div>  
				</li>					
									
					<%
				} else if(workid != null && !"".equals(workid)) {
					%>
					
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>"  data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">					
						<div style=""><!--Is this div necessary?-->
							<div class='exhibition-edit-bar' style="">
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
								<!--workid : <%= workid %> -->
								<!-- INCLUDE WORK -->
								<jsp:include page="../pages/exhibition/work.jsp" >
									<jsp:param name="workid" value="<%= workid %>"></jsp:param>
								</jsp:include>
								<!-- END WORK -->
							</div>
						</div>
						
				     	</div>  
				</li>					
									
					<%
				} else {
					if (exhibition_sectionid != null){
					%>
					
				<li>
					<div class="exhibition-element-container linked-resources" name="<%= exhibition_sectionid%>" data-exhibition-sectionid="<%= exhibition_sectionid%>" data-sequencenumber="<%= sequencenumber%>">				
						<div style=""><!--Is this div necessary?-->
							<div  class="exhibition-edit-bar" >
								
								<!--<span class="glyphicon glyphicon-option-vertical small" aria-hidden="true" style="color: white; float: left; padding-left: 0px;top: 9px;"></span>-->
								<a  onclick="removeSection(<%=exhibition_sectionid%>)" style="float: right; color: white;">
								<span class="glyphicon glyphicon-remove small" aria-hidden="true" style="color: white;"></span>
								</a>
							</div>
							<div style="width: 100%; margin-top:5px;">
							<!-- INCLUDE TEXT -->
								<jsp:include page="./exhibition_addedit_text.jsp" >
									<jsp:param name="exhibition_sectionid" value="<%= exhibition_sectionid%>"></jsp:param>
									<jsp:param name="heading" value="<%= heading%>"></jsp:param>
									<jsp:param name="text" value="<%= text%>"></jsp:param>
								</jsp:include>
							<!-- END TEXT -->
							</div>
						</div>
				     	</div>  
				</li>					
									
				<%
					}			
				}
				
				//out.println("<p>"+rowSetExhibitions.getString("name")+"</p>");
			} while (rowSetExhibitions .next());
			
	%>		
			</ul>		
	<%		
		}
	}catch(Exception ex)
	{
		System.out.println(ex);
	}finally{
		stmt.close();
		m_db.m_conn.close();	
	}	
	
	session.setAttribute("database-connection", null);
	
	%>
	

<SCRIPT type="text/javascript">
	$(document).ready(function(){
	
	   $('.show-hide').showHide({
       		 speed: 400, // speed you want the toggle to happen
		 easing: '', // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
	         changeIcon: 1
	    });
	
		//make the area sortable
      	    sortable();

		
		$('.txtTypeHeading').on('input propertychange', function() {
	            CharLimit(this, 250);
	        });
		$('.txtTypeTextArea').on('input propertychange', function() {
	            CharLimit(this, 998);
	        });
    
	});
	
	$(function() {
	    $('#published_flag_cbx').bootstrapToggle();
	})

	$(function() {
	    $('#published_flag_cbx').change(function() {
	    	//alert("published_flag BEFORE: " + $(this).prop('checked'));
	    	if($("#published_flag").val() == "Y")
	    	{
	    		$("#published_flag_cbx").prop("checked", false);
	    		$("#published_flag").val("N");
	    	}
	    	else{
	    		$("#published_flag_cbx").prop("checked", true);
	    		$("#published_flag").val("Y");
	    	}
	    	
	    })
	})	
	
    	function CharLimit(input, maxChar) {
        	var len = $(input).val().length;
        	if (len > maxChar) {
            		$(input).val($(input).val().substring(0, maxChar));
        	}
    	}	
	
	//make the ul a sortable area
	function sortable(){
		$('.order-by').sortable(
			{
			placeholderClass: 'b-185',
			 forcePlaceholderSize: true 

			}).bind('sortupdate', function(e, ui) {
			console.log("I've been triggered")
		    //Triggered when the user stopped sorting and the DOM position has changed.
		    SetSortOrder();
		    //alert("Sort triggered: " + ui);
		});
		
	}
	
	function SetSortOrder()
	{
	    var list = $(document.getElementsByClassName('linked-resources'));
	    var listCount = list.length;
	    var i=1;
	    console.log( "listCount : " + listCount );
	    $.each(list, function (index, data) {
	    	var sectionId = $( this ).attr("data-exhibition-sectionid");
	    	console.log(' exhibition-sectionid: ' + sectionId);
	    	var nameStr = 'section_id' + sectionId  + '_seq';
	    	var item = $('input:hidden[name=' + nameStr + ']');

	    	item.val(i);

	    	i++;
	    });
	}
	
	//Save exhibition
	function saveExhibition(){	
	console.log($("#exhibition_form :input").serialize());	
		$.ajax({
			url:"exhibition_addedit_process.jsp",
			type:"post",
			data: $("#exhibition_form :input").serialize(),
			success:function(data){
				alert(data.trim());
				//hide the loading div?	
			}	
		})	
	}
	
	//function 
	//addHeading 
	//calls ajax function that adds heading to the database and returns a string we can insert into the database that us the heading template.
	function addHeading(){
	console.log("insert heading ");
		$.ajax({
			url: 'exhibition_addedit_process.jsp?action=addheading',
			type: "post",
			data: $("#exhibition_form :input").serialize(),
			success: function(data){
				html = $.parseHTML(data.trim());
				for(var i = html.length - 1 ; i > -1 ; i--){
					$("ul#exhibition-sections")[0].prepend(html[i]);
				}
				//initiate the sortable areas				
				sortable();
				SetSortOrder();
			}		
		})
	}
	//function
	//addText
	//same as add heading 
	function addText(){
		$.ajax({
			url: 'exhibition_addedit_process.jsp?action=addtext',
			type: "post",
			data: $("#exhibition_form :input").serialize(),
			success: function(data){
				html = $.parseHTML(data.trim());
				for(var i = html.length - 1 ; i > -1 ; i--){
					$("ul#exhibition-sections")[0].prepend(html[i]);
				}

				//initiate the sortable areas
				sortable();
				SetSortOrder();
			}	
		})
	}
	
	/***
	*function
	* removeSection(string exhibition_sectionid)
	*Removes the section from the exhibition - ajax call 
	* updates the dom
	*****/
	function removeSection(exhibitionSectionid){
		if (confirm("Are you sure you want to remove this item from the exhibition?")){
  		  $.ajax({
			url: 'exhibition_addedit_process.jsp?action=delete_section&exhibition_sectionid='+exhibitionSectionid,
			type: "post",
			//data: $("#exhibition_form :input").serialize(),
			success: function(data){
				//remove the hidden element and the li section.
				$( "[name='section_id" + exhibitionSectionid + "_seq']" ).next().remove();
				$( "[name='section_id" + exhibitionSectionid + "_seq']" ).remove();
				SetSortOrder();
			}	
		  })
		}
	}
</SCRIPT>

</form>
<jsp:include page="../templates/admin-footer.jsp" />
</div>





	
	

	


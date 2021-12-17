<%@ page import = "java.sql.*, sun.jdbc.rowset.*, ausstage.*, admin.*"%>

<%
	String eventid = request.getParameter("eventid");
	String venueid = request.getParameter("venueid");
	String organisationid = request.getParameter("organisationid");
	String contributorid = request.getParameter("contributorid");
	String itemid = request.getParameter("itemid");
	String workid = request.getParameter("workid");
	
	
	String userName = (String)session.getAttribute("fullUserName");
	
	String parametersForURL = getParameterForURL(eventid, venueid, organisationid, contributorid, itemid, workid );
	
	ausstage.Database m_db = new ausstage.Database ();
	m_db.connDatabase(AppConstants.DB_ADMIN_USER_NAME, AppConstants.DB_ADMIN_USER_PASSWORD);
	Statement stmt = m_db.m_conn.createStatement();

	//this would have been easier if there was a java class made... grrrr!	
	//select all exhibitions that are owned by the currewnt user, and a count of how many times this current 
	// element has been added to the exhibition (should be 1 or 0)
	String element = "NULL";
	String elementid = "NULL";
	//check each element to see which one has a value
	if (eventid != null){
		element = "eventid";
		elementid = eventid;
	}
	if (venueid != null){
		element = "venueid";
		elementid = venueid;
	}
	if (organisationid != null){
		element = "organisationid";
		elementid = organisationid;
	}
	if (contributorid != null){
		element = "contributorid";
		elementid = contributorid ;
	}
	if (itemid != null){
		element = "itemid";
		elementid = itemid;
	}
	if (workid != null){
		element = "workid";
		elementid = workid;
	}
	
	String sqlStmt =
	"SELECT exhibition.exhibitionid, name, owner, "+
		"(	SELECT count(*) from exhibition_section "+ 
		"	WHERE "+element+" = "+elementid+
		"	and contributorid IS null "+
		"	and exhibitionid = exhibition.exhibitionid) sectionAdded "+ 
		"FROM exhibition "+
		"where owner = '" + userName  + "'";			
	
	CachedRowSet rowSet = m_db.runSQL(sqlStmt , stmt);
%>

    <div style="margin-bottom:5px; text-align: right;margin-right: 0px;" class="row">
	<div>Add to exhibition</div>
	<!-- new select approach -->
	<%
	rowSet = m_db.runSQL(sqlStmt , stmt);
	%>
	<div class='selectContainer' style="    width: 250px;float: right; padding-right: 36px;">
		<select id="exhibitionSelect" multiple class="form-control selectpicker" data-live-search="true" title="No exhibitions selected" data-selected-text-format="count > 2" data-dropdown-align-right='auto'>
	<%
		while (rowSet.next()) {
	%>
			<option value='<%= rowSet.getString("exhibitionid")%>' <%=(rowSet.getString("SectionAdded").equals("1"))?"selected":""%>><%=rowSet.getString("name")%></option>
	<%
		}
	%>
		</select>
	</div>

    </div>


<script>

//SCRIP to deal with adding/removing when users select and deselect exhibitions.
$(document).ready(function(){
	//when a element is clicked, get either add or remove it.
	$('#exhibitionSelect').on('changed.bs.select', function (event, index, newValue, oldValue) {
		//get the exhibit id
		var exhibitId = event.currentTarget[index].value;
		//are we adding or removing?
		if(newValue == true){ //then we're adding
		
		
			$.get( '../exhibition/exhibition_functions/common_ajax.jsp?id='+exhibitId+'&action=add<%=parametersForURL %>' , function (data){
			}).done(function() {});
		}
		else { 		//we're removing 
			console.log('../exhibition/exhibition_functions/common_ajax.jsp?id='+exhibitId+'&action=deleteByEntityId<%=parametersForURL %>');
			$.get( '../exhibition/exhibition_functions/common_ajax.jsp?id='+exhibitId+'&action=deleteByEntityId<%=parametersForURL %>' , function (data){
				console.log(data);
			}).done(function() {});

			//call some ajax to remove
		}
	});
});
	function addToExhibitionSelected() {
		var comboBox = document.getElementById("exhibitionid");
		var id = comboBox .options[comboBox .selectedIndex].value;
		window.location.href = '/custom/exhibition_addedit.jsp?id=' + id + '&action=add<%=parametersForURL %>';
	}
</script>

<%!
	public String getParameterForURL(String eventid, String venueid, String organisationid, String contributorid, String itemid, String workid) {
		if (itemid != null && !"".equals(itemid) && !"null".equals(itemid)) {
			return "&itemid=" + itemid;
		} else if (organisationid != null && !"".equals(organisationid) && !"null".equals(organisationid)) {
			return  "&organisationid=" + organisationid;
		} else if (eventid != null && !"".equals(eventid) && !"null".equals(eventid)) {
			return  "&eventid=" + eventid;
		} else if (venueid != null && !"".equals(venueid) && !"null".equals(venueid)) {
			return  "&venueid=" + venueid;
		} else if (contributorid != null && !"".equals(contributorid) && !"null".equals(contributorid)) {
			return  "&contributorid=" + contributorid;
		} else if (workid!= null && !"".equals(workid) && !"null".equals(workid)) {
			return  "&workid=" + workid;
		} else {
			return "";
		}
	}
%>
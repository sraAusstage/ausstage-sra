<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>


<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "ausstage.State"%>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.LookupCode"%>
<%@ page import = "ausstage.Item"%>



<%@ page session="true" import=" java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ include file="../../public/common.jsp"%>
        
   <!-- slick carousel library downloaded from http://kenwheeler.github.io/slick/ -->
   <link rel="stylesheet" type="text/css" href="/resources/slick-master/slick/slick.css"/> 
   <link rel="stylesheet" type="text/css" href="/resources/slick-master/slick/slick-theme.css"/>

   <script type="text/javascript" src="/resources/slick-master/slick/slick.min.js"></script>



<%
	ausstage.Database db_ausstage = (ausstage.Database)session.getAttribute("database-connection");
				
	if(db_ausstage == null) {
		db_ausstage = new ausstage.Database();
		db_ausstage.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
	}
	Statement     stmt 	    = db_ausstage.m_conn.createStatement();
	String item_id              = request.getParameter("itemid");
	Item item;
	LookupCode item_type = null;
	LookupCode item_sub_type = null;
	admin.Common Common = new admin.Common();  
	///////////////////////////////////
	//    GET RESOURCE DETAILS
	//////////////////////////////////
	item = new Item(db_ausstage);
	int x = Integer.parseInt(item_id);
	item.load(x);
	//load up the item type for the item
	if (item.getItemType() != null) {
		item_type = new LookupCode(db_ausstage);
		item_type.load(Integer.parseInt("0" + item.getItemType()));
	}
	// load the item sub type
	if (item.getItemSubType() != null) {
		item_sub_type = new LookupCode(db_ausstage);
		item_sub_type.load(Integer.parseInt("0" + item.getItemSubType()));
	}
	%>
	<!-- ITEM header -->		
	

	<div style="margin: 0px;" class="show-hide">
		<!--<div class='b-153 exhibition-element-header' >					-->
		<div class='b-153 browse-bar' >
	<%//Title
	if (hasValue(item.getTitle())) {
	
	%>
			<img src='/resources/images/icon-resource.png' class='browse-icon'/><span class='browse-heading large' ><%=item.getTitle()%></span>
			<span class="show-hide-icon glyphicon glyphicon-chevron-up"></span>													
	<%
	}
	
    	%>
	       	</div>
	</div>
	<div class="toggle-div" style="padding-bottom:10px;">
	<%
					
	/////////////////////////////////////////////////
	//ITEM exhibition display logic.
	//first check the item - does it have
	// 1 : images
	// 2 : pdfs
	// 3 : full text articles -- not yet implemented -- TODO
	//and then display the appropriate info.
	String itemArticle = item.getItemArticle();
	String sqlStmt = 	
		"select\n" +
		// Wrapping this columns in functions in order to get around issue where the query throws 
		// Invalid Column Name
		// https://stackoverflow.com/questions/15184709/cachedrowsetimpl-getstring-based-on-column-label-throws-invalid-column-name
		"	cast(images.cnt as signed) images_cnt,\n" +
		"	cast(pdfs.cnt as signed) pdfs_cnt,\n" +
		"	item.item_url\n" +
		"from\n" +
		"	(select count(*) cnt from item_url where itemid = " + item_id + " and (lower(url) like '%.jpg%' or lower(url) like '%.jpeg%' or lower(url) like '%.png%' or lower(url) like '%:jpg%' or lower(url) like '%:jpeg%' or lower(url) like '%:png%')) images,\n" +
		"	(select count(*) cnt from item_url where itemid = " + item_id + " and (lower(url) like '%.pdf%')) pdfs,\n" +
		"	item \n" +
		"where\n" + 
		"	item.itemid = "+item_id;
	
	try {
				
		CachedRowSet rowSet= null;		
		//out.println("<!-- " + sqlStmt + " -->");
		rowSet = db_ausstage.runSQL(sqlStmt, stmt);

		if (rowSet!= null && rowSet.size() > 0) {
			if( rowSet.next()) {
				if(rowSet.getInt("images_cnt") > 0) {
					%>		
					<!-- carousel  -->
					<cms:include page="item_image.jsp" >
						<cms:param name="itemid"><%= item_id%></cms:param>
					</cms:include>
					
					
					<%
				} if(rowSet.getInt("pdfs_cnt") > 0) {
					%>	
					<!-- pdf  -->	
					<cms:include page="item_pdf.jsp" >
						<cms:param name="itemid"><%= item_id%></cms:param>
					</cms:include>
					<%
				} 
				//if ((rowSet.getInt("images_cnt") == 0) && (rowSet.getInt("pdfs_cnt") == 0) ) {
					%>		
					<cms:include page="item_data.jsp" >
						<cms:param name="itemid"><%= item_id%></cms:param>
					</cms:include>  
					<%
				//}
			}
		}
		//if the item Article has a value then display it
		if (itemArticle != null && !itemArticle.isEmpty() ){
		%>
		<!--just replicating the layout that has been used throughout.-->
		<table class="record-table" style="margin-top: 0px;margin-bottom: 0px;">
			<tbody>
				<tr>
					<th class="record-label item-light  bold"></th>
					<td class="record-value" colspan="2">
					<div class="item-article-container wysiwyg"  ><%=itemArticle%></div>
					</td>
				</tr>
			</tbody>
		</table>
		
		<%
		}
		
		stmt .close();
	} catch(Exception e) {
		System.out.println(e);
		System.out.println(sqlStmt);
	}


%></div>
	

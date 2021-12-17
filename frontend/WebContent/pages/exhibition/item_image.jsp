
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "java.util.Vector, java.text.SimpleDateFormat"%>
<%@ page import = "java.sql.*, sun.jdbc.rowset.*, java.util.Calendar"%>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "admin.Common"%>
<%@ page import = "ausstage.Item"%>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%admin.AppConstants ausstage_search_appconstants_for_drill = new admin.AppConstants(request);%>
<%@ page import = "ausstage.AusstageCommon"%>

 <!-- libraries here        -->
<%@ include file="../../public/common.jsp"%>
<%
//get DB connection - used to load the item.
//pretty sure we should be able to pass the Item object from the page this is embedded in.... TODO
ausstage.Database db_ausstage_for_drill = (ausstage.Database)session.getAttribute("database-connection");
if(db_ausstage_for_drill == null) {
	db_ausstage_for_drill = new ausstage.Database();
	db_ausstage_for_drill.connDatabase(AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
}
			
int item_id = Integer.parseInt(request.getParameter("itemid"));
Item item = new Item(db_ausstage_for_drill);
item.load(item_id);
					
%>
        <script src="/resources/highslide/highslide-full.js"></script><!-- gallery http://highslide.com/tutorial#gallery-->
	<link rel="stylesheet" type="text/css" href="/resources/highslide/highslide.css" />
	<script type="text/javascript">
	hs.graphicsDir = '/resources/highslide/graphics/';
	hs.align = 'center';
	hs.transitions = ['expand', 'crossfade'];
	hs.outlineType = 'rounded-white';
	hs.fadeInOut = true;
	hs.dimmingOpacity = 0.75;
	hs.showCredits=false;
	// define the restraining box
	hs.useBox = true;
	hs.width = 640;
	hs.height = 480;

	// Add the controlbar
	hs.addSlideshow({
		slideshowGroup: 'group<%=item_id%>',
		interval: 5000,
		repeat: false,
		useControls: true,
		fixedControls: 'fit',
		overlayOptions: {
			opacity: 1,
			position: 'bottom center',
			hideOnMouseOut: true
		}
	});
</script>
	
	
<div style="margin: 0px;">	
	<div style="width: 100%; ">
		<div class='record ' style="margin: 0px;padding:0px;text-align:center">	
			<table class="record-table" style="margin-top:0px; margin-bottom:0px">
			<tbody>
			<tr>
			<th class="record-label item-light" style="margin-top:0px; margin-bottom:0px;"></th>
			<td class="record-value" colspan="2" style="text-align:center">
<%
		//IF VALUE

		if (hasValue(item.getItemUrl())) {
		
			Vector additionalUrls = item.getAdditionalUrls(); 
			%> 
			<!-- slide.js used to ceate carousel -->
			<div class="highslide-gallery" >	
			<%
			if (((item.getItemUrl()).toLowerCase()).endsWith(".jpg") || ((item.getItemUrl()).toLowerCase()).endsWith(".jpeg") || ((item.getItemUrl()).toLowerCase()).endsWith(".png")){%>
			      <!-- include the item-url -->			    
			      <a href="<%=item.getItemUrl()%>" class="highslide" onclick="return hs.expand(this, {slideshowGroup: 'group<%=item_id%>'})">
				<img src="<%=item.getItemUrl()%>" alt="<%=item.getItemUrl()%>" style=" padding:5px; max-height:200px" />
			      </a>
			      <div class="highslide-caption"></div>
			<%
			}
			//include all the additional urls
			String encodedUrl = ""; 
		//BEGIN FOR LOOP
			for (int i = 0; i < additionalUrls.size(); i++) {
				//fix the ' error - by replacing it with a URL encoded value. 									
				encodedUrl = additionalUrls.elementAt(i).toString().replaceAll("'", "%27");
				
							

				
				if ((encodedUrl.toLowerCase()).contains(".jpg") || (encodedUrl.toLowerCase()).contains(".jpeg")|| (encodedUrl.toLowerCase()).contains(".png") ||
				(encodedUrl.toLowerCase()).contains(":jpg") || (encodedUrl.toLowerCase()).contains(":jpeg")|| (encodedUrl.toLowerCase()).contains(":png")
				){%>
											 
				 <a href="<%=encodedUrl%>" class="highslide" onclick="return hs.expand(this, {slideshowGroup: 'group<%=item_id%>'})">
					<img src="<%=encodedUrl%>" alt="<%=encodedUrl%>" style=" padding:5px; max-height:200px" />
			      	</a>	
			      	<div class="highslide-caption"></div>									  
				<%
				}      
			}
			%>
			</div>	
			<%
		//END FOR LOOP	
		
		}
		//END IF
			%>
			</td>
			</tr>
			</tbody>
			</table>												
		</div>
	</div>
</div>


 <script type="text/javascript">     
 	//once loaded make the carousel
    $(document).ready(function(){
      $('.item-carousel').slick({
	 // dots: true,
	  infinite: false,
	  speed: 300,
//	  slidesToShow: 1,
//	  slidesToScroll:1,
//	  centerMode: true,
	  variableWidth: true,
	  adaptiveHeight:true
	});
  
    });

  </script>
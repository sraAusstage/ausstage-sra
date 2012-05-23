<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Researching Audiences</title>
        
	<link rel="stylesheet" href="../assets/main-style.css"/>
	<link rel="stylesheet" href="../assets/ausstage-colours.css"/>
	<link rel="stylesheet" href="../assets/ausstage-background-colours.css"/>
	<link rel="stylesheet" href="../assets/jquery-ui-1.8.6.custom.css"/>

    
    <link rel="stylesheet" href="../assets/vis.css"/>
    <link rel="stylesheet" href="../assets/list.css"/>
    
	<!-- libraries -->
	<script type="text/javascript" src="../assets/javascript/libraries/jquery-1.5.min.js"></script>
	<script type="text/javascript" src="../assets/javascript/libraries/jquery-ui-1.8.6.custom.min.js"></script>
	<script type="text/javascript" src="../assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
	<!-- custom code -->
    
    	<script src="../assets/javascript/vis-model.js"></script>
        <script src="../assets/javascript/errorController.js"></script>

        
        <script src="../assets/javascript/visControllerList.js"></script>
        <script type="text/javascript" charset="utf-8">
         
	       /**
                * The Jquery document ready. Acts like the main.
                */
						   
		   $(document).ready(function() {			
			
				myModel = new model();
				myModel.controllers.push(new visControllerList(myModel)); // Add the timeline controller the model
				myModel.startLoading();
				
		});
		
        </script>
      
</head>
<body>
<div >
	<div><%@ include file="/system/modules/au.edu.flinders.ausstage/templates/MainMenu.jsp"%></div>
	
	<div>
		<!-- main content -->
		
    		<div class="ui-state-error ui-corner-all status-messages" id="search_error_message"> 
                             <p><span class="ui-icon ui-icon-alert status-icon"></span> 
                             <span id="error_text"></span>
                            </p>
		  </div>
          
          <div class="ui-state-highlight ui-corner-all status-messages" id="status_message" >
						<p>
						<span class="ui-icon ui-icon-info status-icon"></span>
						<span id="message_text"></span>
					    </p>
	   	</div>    
                
                
                
                                   
              <div class="info">
                 <h2><span class="event"></span></h2>
                 <p><span class="organisation"></span>, <span class="venue"></span>, <span class="date"></span> </p>
                 
                 <p class="question"> <span>Question: </span><span class="question"></span></p>
           </div>
         
            
        <table id="feedback_messages">
          <thead>
            <tr class="heading">
            <th scope="col">Response</th>
            <th scope="col">Date</th>
            <th scope="col">Time</th>
            <th scope="col">Source</th>    
            </tr>
          </thead>
          
			<tbody id="table_anchor">
				
			</tbody>
		</table>

<p class="feedbackfooter">
If you have any feedback, questions or queries about the Researching Audiences service, please <a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">contact us</a>.
</p>
     

	</div>
	<!-- always at the bottom of the content -->
	<div class="push"></div>
</div>
<!-- include the Google Analytics code -->


<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script> <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>	</body>
</html>

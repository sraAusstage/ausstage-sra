<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />

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
	<script type="text/javascript" src="../assets/javascript/libraries/jquery.form-2.4.3.js"></script>
        <!-- custom code for this page  -->
    	<script src="../assets/javascript/vis-model.js"></script>
        <script src="../assets/javascript/errorController.js"></script>
        <script src="../assets/javascript/visControllerList.js"></script>
        <script src="../assets/javascript/addController.js"></script>
        <script type="text/javascript" charset="utf-8">       			
             //Globals
              var gCurrentPerformance = 0 ;
              var myModel = new model();
              var addControl = new addController(myModel);			
                  /**
                  * The Jquery document ready. Acts like the main.
                  *  See if there is any url varialbes and
                  *  the user directly to that feedback if that is the case.
                  *  If there is now URL variable then the current peformance list is loaded in on the homepage
                  */						  
                  $(document).ready(function() {
				myModel.controllers.push(new visControllerList(myModel)); // Add the timeline controller the model
                                myModel.controllers.push(addControl); // Add the timeline controller the model
				myModel.startLoading();
                                $("#submit_btn").click(function(e) {
                                          e.preventDefault(); // stop the page reloading
                                          addControl.submitForm(e);
                                });

                                 $("#cancel_btn").click(function(e) {
                                          e.preventDefault(); // stop the page reloading
                                          window.location.href = '.';
                                });                               
		    });
        </script>        
	<div style="margin-bottom: 60px">
          <div class="info">
            <h2>Send your response to 
              <span class="event"></span>
              <span class="organisation"></span>,
              <span class="venue"></span>,
              <span class="date"></span>
            </h2>
            <span class="CurrentPerformance"></span>
	    <p></p>
            <h4 class="question"> <span>Question: </span><span class="question"></span></h4 >
          </div>
           
          <form id="submit-feedback" action="" class="form" >              
            <textarea placeholder="" name="message" class="" rows="10" cols="80"></textarea>
            <div class="about">AusStage doesn't record any identifying information about you. Your response will be stored anonymously</div>
            <div>
              <input type="submit" name="submit" id="submit_btn" value="Send" class="ui-button ui-widget ui-state-default ui-corner-all ui-state-hover ui-state-active" role="button" aria-disabled="false">
              <input type="submit" id="cancel_btn" value="Cancel" class="ui-button ui-widget ui-state-default ui-corner-all ui-state-hover ui-state-active" role="button" aria-disabled="false">
             </div>
          </form>
         
           <div class="ui-state-error ui-corner-all status-messages" id="search_error_message">
             <p>
               <span class="ui-icon ui-icon-alert status-icon"></span>
               <span id="error_text"></span>
             </p>
	   </div>

           <div class="ui-state-highlight ui-corner-all status-messages" id="status_message" >
             <p>
                <span class="ui-icon ui-icon-info status-icon"></span>
                <span id="message_text"></span>
            </p>
          </div>
            
	  <div class ="feedback">         
            <table id="feedback_messages">
              <thead>
                <tr class="heading">
                  <th scope="col">Response</th>
                  <th scope="col">Date</th>
                  <th scope="col">Time</th>
                  <th scope="col">Source</th>
                </tr>
              </thead>

              <tbody id="table_anchor"></tbody>
            </table>
          </div>
           
<!-- include the Google Analytics code -->
<p class="feedbackfooter">
If you have any feedback, questions or queries about the Researching Audiences service, please <a href="http://beta.ausstage.edu.au/?tab=contacts" title="Contact information">contact us</a>.
</p>
<!-- always at the bottom of the content -->
<div class="push"></div>
   
<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script> <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>	</body>

<cms:include property="template" element="foot" />

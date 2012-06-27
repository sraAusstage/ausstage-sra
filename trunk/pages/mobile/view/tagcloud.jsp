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
  <link rel="stylesheet" href="../assets/jquery.qtip.min.css">
  <link rel="stylesheet" href="../assets/tagcloud.css"> <!-- we overide some the qtip styles here --!>                                                   
  <link rel="stylesheet" href="assets/vis.css"/>

  <!-- Libraries  -->

  <script src="../assets/javascript/libraries/jquery-1.4.2.min.js"></script>
  <script src="../assets/javascript/libraries/jquery.highlight-3.js"></script>
  <script src="../assets/javascript/libraries/jquery-ui-1.8.6.custom.min.js"></script>

  <script type="text/javascript" src="../assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
  <!-- custom code -->
  <script src="../assets/javascript/vis-model.js"></script>
  <script src="../assets/javascript/errorController.js"></script>
  <script src="../assets/javascript/visControllerWordStats.js"></script>
  <script src="../assets/javascript/visControllerTagCloud.js"></script>
  <script type="text/javascript" charset="utf-8">
  /**
  * The Jquery document ready. Acts like the main. 
  */	   
  $(document).ready(function() {			
    myModel = new model();
    myModel.controllers.push(new visControllerWordStats(myModel)); // Add the word stats to controller to model
    myModel.controllers.push(new visControllerTagCloud(myModel));
    myModel.startLoading();
  });
  ;     
  </script>             


    <div style="margin-bottom: 60px">        	
      <div class="ui-state-error ui-corner-all status-messages" id="search_error_message"> 
        <p><span class="ui-icon ui-icon-alert status-icon"></span> 
           <span id="error_text"></span>
        </p>
      </div>
          
      <div class="ui-state-highlight ui-corner-all status-messages" id="status_message" >
	<p><span class="ui-icon ui-icon-info status-icon"></span>
	  <span id="message_text"></span>
        </p>
      </div>

      <div class="info">
 	<h2><span class="event"></span></h2>
 	<h4><span class="organisation"></span></h4>
    	<p><span class="venue"></span> ,
    	<span class="date"></span> </p>
 	<h4 class="question"> <span>Question: </span><span class="question"></span></h4>
      </div>

      <div id="tagCloud" ></div>
    </div>
    <!-- always at the bottom of the content -->
    <div class="push"></div>
  <!-- include the Google Analytics code -->
  <script type="text/javascript"> 
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); 
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); 
  </script> 
  <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>	

<cms:include property="template" element="foot" />

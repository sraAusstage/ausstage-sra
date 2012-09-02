<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />

<!--	<link rel="stylesheet" href="/pages/assets/main-style.css"/> -->
<!--	<link rel="stylesheet" href="assets/main-style.css"/> -->
	<link rel="stylesheet" href="/pages/assets/ausstage-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/ausstage-background-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/jquery-ui-1.8.6.custom.css"/>
    <link rel="stylesheet" href="assets/vis.css"/>    
	<!-- libraries -->
	<script type="text/javascript" src="assets/javascript/libraries/jquery-1.5.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery-ui-1.8.6.custom.min.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
	<script type="text/javascript" src="assets/javascript/libraries/jquery.form-2.4.3.js"></script>
        <script type="text/javacript" src="assets/javascript/chain-0.2.js" type="application/x-javascript" charset="utf-8"></script>
        <!-- libraries -->
	
  <!-- main content -->
    <div class="page">
      <div id="About">
<h1>Researching Audiences</h1>
	<h2>Inviting feedback from audiences using mobile devices</h2>
	  <p>AusStage provides audience members with opportunities to share their experiences of performance. Recording audience responses to performance is important for companies, researchers, performers and you. It fleshes out our cultural history and will provide future generations with a richer and fuller understanding of what we did, saw, liked and didn't like.</p>

<p>Artists and companies can select questions to put to their audiences. They can view audience responses to a particular performance in various ways - as a list in chronological order, as signage for use at a venue, as a tag cloud of key words, or as a sequence of images retrieved for key words. They can also select multiple performances for viewing as a list or as a tag cloud.</p>

<p>Spectators can use mobile phones to send text messages, tweet via Twitter or respond online via a mobile web site. Spectators can also register with AusStage to leave comments about performances on the AusStage website.</p>
	   
	      <a href="mobile/send/" title="Send a response" class="box" style="overflow:hidden;">
		<h3>Send a response</h3><img src="mobile/assets/images/response-screengrab.jpg" width="200" height="150" alt="Send Response">
		Performances seeking response
	      </a>
	   
	   
	      <a href="mobile/view/" title="View response" class="box" style="overflow:hidden;">
		<h3>View response</h3>
                <img src="mobile/assets/images/list-screengrab.jpg" width="200" height="150" alt="View Responses">
                Past performances with response
	      </a>
   

<h2>About the Researching Audiences service</h2>
	    
<p>AusStage does not record or store any identifying information about spectators. It does not record the phone number or web details used by audience members to respond. Audience members cannot be identified in any way by AusStage or any other individuals or parties (including performance companies). Individuals will not be identified in any results and all responses are stored confidentially.</p>

<p>Participation is entirely voluntary. If you choose to have your say about a performance you have seen, standard costs for SMS or internet access will apply. If you are under 18 years of age, you must ask for a parent or guardian's permission to participate. However, please note that sending information via mobile devices is inherently insecure. Contact the Project Manager for further information.</p>
	    

	  <p>The Researching Audiences service is documented on our development wiki including:</p>
	  <ul>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceSpecification">Mobile Service Specification</a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceDatabaseTables">Mobile Service Database Tables</a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceAPI">Mobile Service API<a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceInfoCardTmpl">Information Card Template</a></li>
	  </ul>
	  <p><a href="../learn/contact">Contact</a> the Project Manager for further information.This research is led by Flinders University in collaboration with the companies and artists seeking feedback on their work. It was  funded by the National e-Research Architecture Taskforce (NeAT). The project was approved by the Flinders University Social and Behavioural Research Ethics Committee (Project Number 4892). For more information regarding ethical approval of the project the Executive Officer of the Committee can be contacted on <a href="mailto:human.researchethics@flinders.edu.au">human.researchethics@flinders.edu.au</a>. </p>
	  

        </div>
      </div>
    <!-- always at the bottom of the content -->
  <div class="push"></div>

                                    
<!-- include the Google Analytics code -->

<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script> <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>

<cms:include property="template" element="foot" />

</div>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />

	<link rel="stylesheet" href="/pages/assets/main-style.css"/>
	<link rel="stylesheet" href="assets/main-style.css"/>
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
    <div style="margin-bottom: 60px">
      <div id="About">
        <br>
	<h2>Send feedback on live performance</h2>
	  <p>AusStage documents the performing arts in Australia. Future generations, researchers and contemporary audiences can go to <a href="http://www.ausstage.edu.au/">AusStage</a>, search and retrieve information about company and performer histories, maps, tours and links to related material.</p>
	  <p>AusStage now provides audiences with the chance to share their experience of performance. You can let companies know what you thought of a performance you've seen. You can use your phone to send a text message, a tweet via Twitter, or respond online via a mobile or desktop web site.</p>

	  <ul class="services">
	    <li>
	      <a href="send/" title="Send a response">
		<h3>Send a response</h3><img src="assets/images/response-screengrab.jpg" width="200" height="150" alt="Send a response">
		<p>Performances now seeking response</p>
	      </a>
	    </li>
	    <li>
	      <a href="view/" title="View response">
		<h3>View response</h3>
                <img src="assets/images/list-screengrab.jpg" width="200" height="150" alt="View Responses">
                <p>Past performances with response you can view</p>
	      </a>
	    </li>
	  </ul>

	  <p class="clear">More information on the Researching Audiences service is available in our Wiki including:</p>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceSpecification">Mobile Service Specification</a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceDatabaseTables">Mobile Service Database Tables</a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceAPI">Mobile Service API<a></li>
	  <li><a href="http://code.google.com/p/aus-e-stage/wiki/MobileServiceInfoCardTmpl">Information Card Template</a></li>
	  
	  <p>This project is led by Flinders University alongside the companies and artists who are seeking feedback on their work. It has been funded by the National e-Research Architecture Taskforce (NeAT).</p>
	  <p>This research has been approved by the Flinders University Social and Behavioural Research Ethics Committee (Project Number 4892). For more information regarding ethical approval of the project the Executive Officer of the Committee can be contacted on <a href="mailto:human.researchethics@flinders.edu.au">human.researchethics@flinders.edu.au</a> </p>
	  <p>Any enquiries you may have concerning this project should be directed to Jonathan Bollen on 8201 5874 or by email to <a href="mailto:jonathan.bollen@flinders.edu.a">jonathan.bollen@flinders.edu.au</a></p>

	  <p class="clear homefooter">
	    <a href="http://beta.ausstage.edu.au/" title="Aus-e-Stage Project homepage">Aus-e-Stage</a> is funded by <a href="http://www.pfc.org.au/bin/view/Main/NeAT" title="NeAT homepage">NeAT</a>, the National eResearch Architecture Taskforce. The source code for these services is available on the <a href="http://code.google.com/p/aus-e-stage/" title="Aus-e-Stage Project Wiki and Source Code Repository">aus-e-stage</a> project hosted on Google Code.
	  </p>
        </div>
      </div>
    <!-- always at the bottom of the content -->
  <div class="push"></div>
</div>
                                    
<!-- include the Google Analytics code -->

<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script> <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>

<cms:include property="template" element="foot" />

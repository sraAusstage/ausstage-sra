<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import = "ausstage.AusstageCommon"%>
<%@ page import="java.sql.*" %>

<jsp:include page="../../../templates/header.jsp" />

	<link rel="stylesheet" href="/pages/assets/main-style.css"/>
	<link rel="stylesheet" href="../assets/main-style.css"/>
	<link rel="stylesheet" href="/pages/assets/ausstage-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/ausstage-background-colours.css"/>
	<link rel="stylesheet" href="/pages/assets/jquery-ui-1.8.6.custom.css"/>
    <link rel="stylesheet" href="../assets/vis.css"/>
    
	<!-- libraries -->
	<script type="text/javascript" src="../assets/javascript/libraries/jquery-1.5.min.js"></script>
	<script type="text/javascript" src="../assets/javascript/libraries/jquery-ui-1.8.6.custom.min.js"></script>
	<script type="text/javascript" src="../assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
	<script type="text/javascript" src="../assets/javascript/libraries/jquery.form-2.4.3.js"></script>
        <script type="text/javascript" src="../assets/javascript/chain-0.2.js" type="application/x-javascript" charset="utf-8"></script>

                
        <!-- custom code -->
        <script src="../assets/javascript/searchModel.js"></script>
        <script src="../assets/javascript/errorController.js"></script>
        <script src="../assets/javascript/visControllerSearch.js"></script>
        <script src="../assets/javascript/visControllerChooseView.js"></script>


        <script type="text/javascript" charset="utf-8">
         
			  /**
			  * The Jquery document ready. Acts like the main. 
			  */
						   
		   $(document).ready(function() {			
			
				myModel = new model();
				myModel.controllers.push(new visControllerSearch(myModel)); // Add the timeline controller the model
				myModel.controllers.push(new visControllerChooseView(this)); // Add the timeline controller the model
                                myModel.searchPerformances();

                                myModel.getPerformances (0,0,'.currentPerformancesBlock'); // See what performances are currently looking for feedback
				myModel.getPerformances (0,0,'.currentPerformancesBlock'); // See what performances are currently looking for feedback

		});
		
        </script>
      
	
	<div style="margin-bottom: 60px">
		<!-- main content -->
                <div id="content">

                    <div id="About">




<h2>View audience response to past performances</h2>

<p>Recording audience responses to performance is important for companies, researchers,
   performers and you. It fleshes out our cultural history and will provide future generations with a richer and fuller understanding of what we did, saw, liked and didn't like.</p>

<p>You can view audience response to a particular performance in various ways - as a list in chronological order, as signage for use at a  
venue, as a tag cloud of key words, or as a sequence of images retrieved
for key words. You can also select multiple performances for viewing as a list or as a tag cloud.</p>




                    </div>

                    
<p>
                    </div>
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

                                                                
        
       
        <div id="Performances">
        <h3>Performances that currently have feedback</h3>


         <form action="" method="get" id="performanceForm">

          <table id="SearchResults">
          <thead>
        	<tr>
                    <th scope="col"></th>
                    <th scope="col">Event</th>
                     <th scope="col">Date and Time</th>

                    <th scope="col">Feedback Count</th>

                    <th scope="col View">View</th>
            </tr>
          </thead>
          
                <tr id="table_anchor"></tr>
                <!-- Below is where the actual date goes -->

		</table>
             <div id="instructions"><strong>To view response to multiple performances: Click the checkboxes toselect performances. Then click the button for List View or Cloud View.</strong></div> <br/>
             <div id="viewChoices">
                 <input type="button" value="List View" name="ListView" id="chooseList" />
                 <input type="button" value="Cloud View" name="CloudView" id="chooseCloud" />
             </div>


         </form>

<p class="clear">
						<a href="http://beta.ausstage.edu.au/" title="Aus-e-Stage Project homepage">Aus-e-Stage</a> is funded by <a href="http://www.pfc.org.au/bin/view/Main/NeAT" title="NeAT homepage">NeAT</a>, the National eResaerch Architecture Taskforce. The source code for these services is available on the <a href="http://code.google.com/p/aus-e-stage/" title="Aus-e-Stage Project Wiki and Source Code Repository">aus-e-stage</a> project hosted on Google Code.
					</p>
        </div>
	</div>

	<!-- always at the bottom of the content -->
	<div class="push"></div>

                                        
<!-- include the Google Analytics code -->


<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script> <script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-10089663-2"); pageTracker._trackPageview(); } catch(err) {} </script>

<jsp:include page="../../../templates/header.jsp" />

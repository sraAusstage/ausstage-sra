<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ include file="../../public/common.jsp"%>
<cms:include property="template" element="head" />
<script src="assets/javascript/libraries/jquery-1.6.min.js"></script>
<script src="assets/javascript/libraries/jquery-ui-1.8.12.custom.min.js"></script>
<script src="assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
<script src="assets/javascript/libraries/jquery.form-2.64.js"></script>
<script src="assets/javascript/index.js"></script>
<script src="assets/javascript/tab-selector.js"></script>
	<div class="main1 b-184 f-187">
		<!-- main content -->
		<div id="tabs" class="tab-container" style="border-width:0px;">
			<%@ include file="../../templates/MainMenu.jsp"%>
					<div id="analytics-1">
						
					</div>
					<div id="analytics-2">
						
					</div>
					<div id="analytics-3">
						
					</div>
					<div id="analytics-4">
						
					</div>
					<div id="analytics-5">
						
					</div>
					<div id="analytics-6">
						
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- always at the bottom of the content -->
	<div class="push"></div>
<cms:include property="template" element="foot" />
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<cms:include property="template" element="head" />
<link rel="stylesheet" href="/pages/assets/main-style.css"/>
<link rel="stylesheet" href="/pages/ausstage/assets/jquery-ui/jquery-ui-1.8.6.custom.css"/>

<script src="assets/javascript/libraries/jquery-1.6.min.js"></script>
<script src="assets/javascript/libraries/jquery-ui-1.8.12.custom.min.js"></script>
<script src="assets/javascript/libraries/jquery.ajaxmanager-3.0.9.js"></script>
<script src="assets/javascript/libraries/jquery.form-2.64.js"></script>
<script src="assets/javascript/index.js"></script>
<script src="assets/javascript/tab-selector.js"></script>
<div class="main1 b-184 f-187">
	<!-- main content -->
	<div id="tabs" class="tab-container" style="border-width: 0px; margin: 13px 0px 60px 0px;">
		<div id="analytics-tabs" style="border-width: 0px;">
			<ul class="fix-ui-tabs" style="padding: 0px">
				<li><a href="#analytics-1">Mapping Service</a>
				</li>
				<li><a href="#analytics-2">Networks Service</a>
				</li>
				<li><a href="#analytics-3">Mobile Service</a>
				</li>
				<li><a href="#analytics-4">AusStage Website</a>
				</li>
				<li><a href="#analytics-5">AusStage Database</a>
				</li>
				<li><a href="#analytics-6">Data Exchange Service</a>
				</li>
			</ul>
			<div id="analytics-1"></div>
			<div id="analytics-2"></div>
			<div id="analytics-3"></div>
			<div id="analytics-4"></div>
			<div id="analytics-5"></div>
			<div id="analytics-6"></div>
		</div>
	</div>
</div>
<!-- always at the bottom of the content -->
<div class="push"></div>
<cms:include property="template" element="foot" />
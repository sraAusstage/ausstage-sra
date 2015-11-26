
<%
	String ausstage_main_page_link = "";
	admin.AppConstants Constants = new admin.AppConstants(request);

	ausstage_main_page_link = "<table border='0' cellspacing='0' cellpadding='0'><tr><td>";

	if (Constants.LINK_TO_CUSTOM_MAIN_PAGE) {
		if (Constants.CUSTOM_DISPLAY_NAME != null
				|| !Constants.CUSTOM_DISPLAY_NAME.equals(""))
			ausstage_main_page_link += "<a href='"
					+ Constants.ADMIN_DIRECTORY + "/"
					+ Constants.LINK_TO_CUSTOM_MAIN_PAGE_NAME
					+ "'><img border='0' src='"
					+ Constants.IMAGE_DIRECTORY
					+ "/custom_main_menu.gif' alt='Return to the "
					+ Constants.CUSTOM_DISPLAY_NAME
					+ " Main Menu'></a>";
		else
			ausstage_main_page_link += "<a href='"
					+ Constants.ADMIN_DIRECTORY
					+ "/"
					+ Constants.LINK_TO_CUSTOM_MAIN_PAGE_NAME
					+ "'><img border='0' src='"
					+ Constants.IMAGE_DIRECTORY
					+ "/custom_main_menu.gif' alt='Return to the Main Menu'></a>";
	} else {
		ausstage_main_page_link += "<a href='"
				+ Constants.ADMIN_DIRECTORY
				+ "/content_main_menu_custom.jsp'><img border='0' src='"
				+ Constants.IMAGE_DIRECTORY
				+ "/custom_main_menu.gif' alt='Return to the Custom Main Menu'></a>";
	}

	ausstage_main_page_link += "</td></tr></table>";
%>
<script type="text/javascript">

	var ajaxChildSelect;
	var ajaxLoadingImageCell;
	var req;
	try { // Firefox, Opera 8.0+, Safari
		req = new XMLHttpRequest();
	} catch (e) { // Internet Explorer
		try {
			req = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				req = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				alert("Your browser does not support AJAX!");
				//return false;
			}
		}
	}

	function refreshChildCodeTypeList(childLookupType, childName,
			loadingImageCell) {
		try {
			ajaxLoadingImageCell = loadingImageCell;
			if (ajaxLoadingImageCell != "") {
				document.getElementById(ajaxLoadingImageCell).innerHTML = "<img src='/custom/files/ajax_loader.gif' height='9' align='middle' border='0' alt='Loading...' />";
			}

			// Initialise an asynchronous connection to the server
			req.open("POST", "/custom/ajax.jsp", true);

			// Register the calllback function
			req.onreadystatechange = updateChildSelectList;

			ajaxChildSelect = childName;
			// Initiate a call to the server
			req.setRequestHeader('Content-Type',
					'application/x-www-form-urlencoded');
			req.send("ajaxType=" + encodeURIComponent("CODE_ASSOCIATION")
					+ "&code1LovId=" + encodeURIComponent(childLookupType)
					+ "&additionalOption="
					+ encodeURIComponent("--- Select Resource Sub Type ---"));
		} catch (e) {
			alert(e.message + '\n' + req.statusText);
			document.getElementById(ajaxLoadingImageCell).innerHTML = "";
		}
	}

	function updateChildSelectList() {
		if (req.readyState == 4) { // Request Complete
			if (req.status == 200) { // Request Successful
				updateSelectList(ajaxChildSelect, req.responseText);
			}
			// Hide AJAX loading icon
			if (ajaxLoadingImageCell != "") {
				document.getElementById(ajaxLoadingImageCell).innerHTML = "";
			}
		}
	}

	function updateSelectList(selectList, newSelectItems) {
		var selectItem = "";
		var i;
		var temp;

		// Split the response string (select list items)
		var newVals = newSelectItems.split("#");
		// Get select list form element
		var s = document.getElementById(selectList);
		// Empty the select list
		s.options.length = 0;

		// Add options to the select list
		for (i = 0; i < newVals.length - 1; i++) {
			selectItem = newVals[i].split("~"); // Description ~ Value
			temp = new Option(selectItem[0], selectItem[1]);
			s.options[i] = temp;
		}
	}
	
	
  function validateUrl(input_field){
    var tmp_url = "";  	
    var is_valid = true;
    if (input_field.val()!=""){
      tmp_url = input_field.val();
//      var is_valid =  /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(tmp_url);  	
//	var is_valid =  /^(http(s)?:\/\/)?(www\.)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/.test(tmp_url);
//	var is_valid =  /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/.test(tmp_url);
	var is_valid =  /^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(tmp_url);
	//var is_valid =  /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/.test(tmp_url);
      if (!is_valid){alert(input_field.val()+" is not a valid URLs."); input_field.focus();}
    }
    return is_valid;
  }

</script>
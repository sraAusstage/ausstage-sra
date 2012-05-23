<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
  String ausstage_main_page_link        = "";
  admin.AppConstants Constants          = new admin.AppConstants(request);
  
  ausstage_main_page_link = "<table border='0' cellspacing='0' cellpadding='0'><tr><td>";

    if(Constants.CUSTOM_DISPLAY_NAME != null || !Constants.CUSTOM_DISPLAY_NAME.equals(""))
      ausstage_main_page_link += "<a href='/resources/images/custom_main_menu.gif' alt='Return to the AusStage Main Menu'></a>";
    else
       ausstage_main_page_link += "<a href='/pages/map/'><img border='0' src='/resources/images/custom_main_menu.gif' alt='Return to the Main Menu'></a>";

  
  ausstage_main_page_link += "</td></tr></table>";
%>
<script language="Javascript">
var ajaxChildSelect;
var ajaxLoadingImageCell;
var req;
try {  // Firefox, Opera 8.0+, Safari
  req=new XMLHttpRequest();  }
catch (e) {  // Internet Explorer
  try {
    req=new ActiveXObject("Msxml2.XMLHTTP");
  }
  catch (e) {
    try {
      req=new ActiveXObject("Microsoft.XMLHTTP");
    }
    catch (e) {
      alert("Your browser does not support AJAX!");
      //return false;
    }
  }
}

function refreshChildCodeTypeList(childLookupType, childName, loadingImageCell) {
  try {
    ajaxLoadingImageCell = loadingImageCell;
    if (ajaxLoadingImageCell != "") {
      document.getElementById(ajaxLoadingImageCell).innerHTML = "<img src='/custom/files/ajax_loader.gif' height='9' align='middle' border='0' alt='Loading...' />";
    }
    
    // Initialise an asynchronous connection to the server
    req.open("POST", "/custom/ausstage/ajax.jsp", true);
    
    // Register the calllback function
    req.onreadystatechange = updateChildSelectList;

    ajaxChildSelect = childName;
    // Initiate a call to the server
    req.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    req.send("ajaxType=" + encodeURIComponent("CODE_ASSOCIATION") + "&code1LovId=" + encodeURIComponent(childLookupType) + "&additionalOption=" + encodeURIComponent("--- Select Resource Sub Type ---"));
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
  s.options.length=0;

  // Add options to the select list
  for(i=0;i<newVals.length-1;i++) {
    selectItem = newVals[i].split("~"); // Description ~ Value
    temp = new Option(selectItem[0], selectItem[1]);
    s.options[i]=temp;
  }
}
</script>

<%
admin.AppConstants AppConstants = new admin.AppConstants(request);
String current_function = "";
try {
	if (session.getAttribute("loginOK") == null) {
	  response.sendRedirect ("/admin/login.jsp");
	  return;
	}
} catch (Exception e) {
  response.sendRedirect ("login.jsp");
  return;
}
%>

<script type="text/javascript">
<!--

function isIE(){

  // do some browser detection
  var isIE = false;
  
  if (navigator.appVersion.indexOf("MSIE") != -1)
    isIE = true;

  return(isIE);
}

function trimText(p_str, p_length)
{
  if (p_str.length > p_length)
  {
    p_str = p_str.substr(0 , p_length - 3);
    p_str = p_str + "...";
  }
  document.write (p_str);
}


function checkValidDate(p_day, p_month, p_year)
{
	
 var check_date;
 var tcheck_date;
 var current_date;
 var l_month;
 var l_year;
 var l_day;
  
  p_day   = removeLeadingZeros(p_day);
  p_month = removeLeadingZeros(p_month);
  p_year  = removeLeadingZeros(p_year);

  l_day = p_day;
  l_month  = p_month;
  l_year   = p_year;

  check_date = new Date(l_year, l_month-1, p_day);		

  if (((check_date.getDate()).toString() == l_day.toString()) && 
    ((check_date.getMonth()+1).toString() == l_month.toString()) &&
    ((check_date.getFullYear()).toString() == l_year.toString()))
    return true;
  else
    return false;

}

function removeLeadingZeros(p_integer_string){
	var l_ret = "";
	var i;
	for(i=0;i<p_integer_string.length;i++){
		if(p_integer_string.charAt(i) != "0"){
			l_ret = p_integer_string.substring(i);
			break;
		}
			
	}
	return(l_ret);
}


  function verify(f) 
  {
    var msg = "";
    var msg1 = "";
    var i;
     
    for(i=0; i < document.forms[0].elements.length; i++){
     if(isBlank(document.forms[0].elements[i].value) || document.forms[0].elements[i].value == "null")
        msg += "\t" + document.forms[0].elements[i].name + "\n";
      
    }
  
    if(msg) {		
      alert("You appear to have not entered the following information for:\n" + msg + "Please press the OK button to continue and then fill in the required fields.");
        return false;
    }
    return true;
  }

  function isBlank(s) {
    if((s == null)||(s == "")) 
      return true;
    for(var i=0;i<s.length;i++) {
      var c=s.charAt(i);
      if((c != ' ') && (c !='\n') && (c != '\t')) return false;
    }
    return true;
  }

  function isInteger (s){
    var i;
    var c;


      // Search through string's characters one by one
      // until we find a non-numeric character.
      // When we do, return false; if we don't, return true.

      for (i = 0; i < s.length; i++)
      {   
          // Check that current character is number.
          c = s.charAt(i);
          if (!isDigit(c)) 
            return false;
      }
      // All characters are numbers.
      return true;
  }

  function isDigit (c)
  {
    return ((c >= "0") && (c <= "9"))
  }

  function checkMail(email_field, produce_alert)
	{
		var ret_bool = true;
		var x = "";

		x = email_field;

		if(!x == ""){
			var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9])+$/;
			if (filter.test(x)){
				ret_bool = true;
			}
			else{
        if(produce_alert)
          alert('NO! Incorrect email address');
				ret_bool = false;
			}
		}else{
      if(produce_alert)
        alert("please enter an email address");
			ret_bool = false;	
		}	
		return (ret_bool);
	}

  function isURL(argvalue) {
    var ret_bool = true;

    if (argvalue.indexOf(" ") != -1)
      ret_bool = false;
    else if (argvalue.indexOf("http://") == -1)
      ret_bool = false;

    else if (argvalue == "http://")
      ret_bool = false;
    else if (argvalue.indexOf("http://") > 0)   
      ret_bool = false;


    argvalue = argvalue.substring(7, argvalue.length);
    if (argvalue.indexOf(".") == -1)
      ret_bool = false;
    else if (argvalue.indexOf(".") == 0)
      ret_bool = false;
    else if (argvalue.charAt(argvalue.length - 1) == ".")
      ret_bool = false;

    if (argvalue.indexOf("/") != -1) {
      argvalue = argvalue.substring(0, argvalue.indexOf("/"));
      if (argvalue.charAt(argvalue.length - 1) == ".")
        ret_bool = false;
    }

    if (argvalue.indexOf(":") != -1) {
      if (argvalue.indexOf(":") == (argvalue.length - 1))
        ret_bool = false;
      else if (argvalue.charAt(argvalue.indexOf(":") + 1) == ".")
        ret_bool = false;
      argvalue = argvalue.substring(0, argvalue.indexOf(":"));
      if (argvalue.charAt(argvalue.length - 1) == ".")
        ret_bool = false;
    }
  
    //if(!retVal)
      //alert("invalid URL!!");
    //else
      //alert("VALID URL!");
    return ret_bool;
  }


  //*************************************************************
  // Function
  //
  // Purpose: Moves items from the right select box to the left
  //          select box in a multilist.
  //          
  // Inputs: leftObject    : Points to the left select box Id.
  //         rightObject   : Points to the right select box Id.
  //
  // Returns: N/A
  //  
  //
  //*************************************************************
  function moveRightToLeft (leftObject, rightObject)
  {
     // Make sure that something is selected in the Right List
     while (rightObject.options.selectedIndex >= 0)
     {
        addOption (leftObject,
                   rightObject.options [rightObject.selectedIndex].text,
                   rightObject.options [rightObject.selectedIndex].value);
        deleteOption (rightObject, rightObject.options.selectedIndex);
     }
  }



  //*************************************************************
  // Function
  //
  // Purpose: Moves items from the left select box to the right
  //          select box in a multilist.
  //          
  // Inputs: leftObject    : Points to the left select box Id.
  //         rightObject   : Points to the right select box Id.
  //
  // Returns: N/A
  //  
  //
  //*************************************************************
  function moveLeftToRight (leftObject, rightObject)
  {
     // Make sure that something is selected in the Left List
     while (leftObject.options.selectedIndex >= 0)
     {
        addOption (rightObject,
                   leftObject.options [leftObject.selectedIndex].text,
                   leftObject.options [leftObject.selectedIndex].value);
        deleteOption (leftObject, leftObject.options.selectedIndex);
     }
  }


  //*************************************************************
  // Function
  //
  // Purpose: Adds an option to a select box.
  //          
  // Inputs:   Object    : Points to the select box Id.
  //           text      : The text of the option to add.
  //           value     : The value of the option to add
  //                       (Option Id).
  //
  // Returns: N/A
  //  
  //
  //*************************************************************
  function addOption (object, text, value)
  {
      var defaultSelected = false;
      var selected        = false;
      var optionName      = new Option(text, value, defaultSelected , selected)

      object.options [object.length] = optionName;   
  }



  //*************************************************************
  // Function
  //
  // Purpose: Deletes an option from a select box.
  //          
  // Inputs:   Object    : Points to the select box Id.
  //           index     : The index into the select box of the
  //                       option to delete.
  //
  // Returns: N/A
  //  
  //
  //*************************************************************
  function deleteOption (object, index)
  {
      object.options [index].selected = false;   
      object.options [index] = null;
  }



  //*************************************************************
  // Function
  //
  // Purpose: Causes the selection of all options in the select
  //          box. The select box has to be a multiselect. This
  //          function is normaly called before posting the page
  //          to the ASP server. Selection of all the options
  //          causes all the data in the select box to be posted
  //          as comma separated text.
  //          
  // Inputs:   selectBoxName : The name of the select box that is
  //                           to have all of its options
  //                           selected.
  //
  // Returns: true  : If there was atleast one option in the box.
  //          false : If there was no options in the box.
  //  
  //
  //*************************************************************
  function selectAllOptionsInSelectBox (selectBoxName)
  {
     var numberOfOptions;
     var ret;
     var i;
   
     numberOfOptions = document.getElementById(selectBoxName).length;
     if (numberOfOptions < 1)
     {
        return (false);
     }
  
     for (i = 0; i < numberOfOptions; ++i)
     {
       document.getElementById(selectBoxName).options[i].selected = true;
     }
     return (true);
  }

  //*************************************************************
  // Function
  //
  // Purpose: Causes the selection of all options in the select
  //          box. The select box has to be a multiselect. 
  //          Selection of all the options causes all the data indexes 
  //          in the select box to be posted as comma separated text.
  //          This function also retrieves the text for each element
  //          in the box, and stores it as comma separated text.
  //          
  // Inputs:   selectBoxName       : The name of the select box that is
  //                                 to have all of its options
  //                                 selected.
  //
  // Returns: comma separated text  : If there was at least one option in the box.
  //          null                  : If there was no options in the box.
  //  
  //
  //*************************************************************
  function selectAllTextOptionsInSelectBox (selectBoxName)
  {
     var numberOfOptions;
     var ret;
     var i;   
   
     // comma separated text
     var cst; 
     numberOfOptions = document.getElementById(selectBoxName).length;
     if (numberOfOptions < 1)
     {
        return (null);
     }
     i = 0;
     document.getElementById(selectBoxName).options[i].selected = true;   
     cst = document.getElementById(selectBoxName).options[i].text;
      
     for (i = 1; i < numberOfOptions; ++i)
     {
       document.getElementById(selectBoxName).options[i].selected = true;
       cst = cst + "," + document.getElementById(selectBoxName).options[i].text;          
     }   
     return (cst);
  }

  //*************************************************************
  // Function
  //
  // Purpose: Causes the selection of all options in the specified
  //          select boxs. The select boxs have to be multiselect. 
  //          Selection of all the options causes all the data indexes 
  //          in the select box to be posted as comma separated text.
  //          This function also retrieves the text for each element
  //          in the box, and stores it as comma separated text, together
  //          with its associated box name.
  //          
  // Inputs:   comma_sep_text_Tables : comma separated list select boxs that are
  //                                    to have all of their options
  //                                    selected.
  //
  //                       strPrefix : "L_" specifies LHS select box 
  //                                   "R_" specifies RHS select box 
  //
  // Returns: comma_colon_sep_text_Fields : eg "boxname1,txtdata1,txtdata1:boxname2,txtdata2,txtdata2" 
  //
  //************************************************************* 
  function getAllSelectionsInMultipleMultiLists (comma_sep_text_Tables, strPrefix)
  {   
     var tableArray = new Array();
     var comma_colon_sep_text_Fields = "";
     var selectBoxName = "";
     var cst = "";
     var numVar = 0;
     var i;
     var oObject = null;
   
     // Split at each comma character and create an array.
     tableArray = comma_sep_text_Tables.split(",");
     numVar = tableArray.length;
     if (numVar < 1)
     {
        return (null);
     }
     i = 0;
     selectBoxName  = strPrefix + tableArray [i];
     oObject = document.all.item (selectBoxName);
     if (oObject != null)      
     {
        cst = selectAllTextOptionsInSelectBox (selectBoxName);         
        if (cst == null)
        {
           comma_colon_sep_text_Fields = selectBoxName;
        }
        else   
           comma_colon_sep_text_Fields = selectBoxName + "," + cst;
     }
   
     for (i = 1; i < numVar; ++i)
     {
        selectBoxName  = strPrefix + tableArray [i];
        oObject = document.all.item (selectBoxName);
        if (oObject != null)      
        {      
           cst = selectAllTextOptionsInSelectBox (selectBoxName);                  
           if (cst == null)
           {
              comma_colon_sep_text_Fields = comma_colon_sep_text_Fields + ":" + selectBoxName;
           }
           else   
           {
              comma_colon_sep_text_Fields = comma_colon_sep_text_Fields + ":" + selectBoxName + "," + cst;
           }         
        }
     }   
     return (comma_colon_sep_text_Fields);
  }


  //*************************************************************
  // function getSelectedTextOptionInSelectBox (selectBoxName)
  //
  // Purpose: Gets the text value of a selected option within a 
  //          select box. 
  //          
  // Inputs:   selectBoxName       : The name of the select box.
  //                                 
  //
  // Returns:  selected_txt        : The selected text value. 
  //          
  //*************************************************************
  function getSelectedTextOptionInSelectBox (selectBoxName)
  {
     var index;
     var selected_txt;
     index = document.getElementById(selectBoxName).selectedIndex;
     selected_txt = document.getElementById(selectBoxName).options [index].text;
   
     return (selected_txt);
  }



//-->
</script>
<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.opencms.main.OpenCms" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<cms:include property="template" element="head" />
<%@ include file="../../../public/common.jsp"%>
<body topmargin="0" leftmargin="0" bgproperties="fixed" bgcolor="#333333">



<%@ page import = "ausstage.Database, java.sql.*, sun.jdbc.rowset.*, java.util.Date"%>
<%@ page import = "ausstage.AusstageCommon, ausstage.LookupCode, ausstage.Organisation, ausstage.SecondaryGenre"%>
<%admin.AppConstants ausstage_search_appconstants_for_form = new admin.AppConstants(request);%>

<%
  // This database user is only for connecting to lookup codes -> not using the overriding connection: admin_db_resource_result
  ausstage.Database db_ausstage_for_result = new ausstage.Database ();
  db_ausstage_for_result.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
  Statement              stmt           = db_ausstage_for_result.m_conn.createStatement ();
  Organisation organisation             = new Organisation(db_ausstage_for_result);
  SecondaryGenre       secGenre         = new SecondaryGenre(db_ausstage_for_result);

  // Need a lookup code object to get sub types for resource/item
  LookupCode lookupCode                 = new LookupCode(db_ausstage_for_result);
  // Cached row of data
  CachedRowSet crsetForm                = null;

    ///////////////////////////////////
    //    DISPLAY SEARCH PAGE
    //////////////////////////////////

%>
  <form class='search-form' name="searchform" id="searchform" method="post" action ="results/" onsubmit="return checkFields();">
   
<style>


/* prevent a FOUC */
.js {display: none;}
.hideMe {display: none;}

</style>
<table class='search-form-table'>

      <tr>
        <th class='search-form-label b-153 bold'><img src='../../../resources/images/icon-resource.png' class='box-icon' >Title</th>
        <td class='search-form-value'><input class='search-form-input-text' name = 'f_title' id ='f_title' type='text' size='60'       <%if(request.getParameter("f_title") != null) { out.print("value=\"" + request.getParameter("f_title") + "\"");}%> >&nbsp;</td>
      </tr>
      <tr>
        <th class='search-form-label b-153'>Creator</th>
        <td class='search-form-value'>
          <input class='search-form-input-text' name = 'f_creator' id ='f_creator' type='text' size='60'       <%if(request.getParameter("f_creator") != null) { out.print("value=\"" + request.getParameter("f_creator") + "\"");}%> >&nbsp;
        </td>
      </tr>
      <tr>
        <th class='search-form-label b-153 '>Source</th>
        <td class='search-form-value'>
          <input class='search-form-input-text' name = 'f_source' id ='f_source' type='text' size='60'   <%if(request.getParameter("f_source") != null) { out.print("value=\"" + request.getParameter("f_source") + "\"");}%> >&nbsp;
        </td>
     </tr>
     <tr>
       <th class='search-form-label b-153 '>Keywords</th>
       <td  class='search-form-value'>
         <input class='search-form-input-text ' name = 'f_keywords' id ='f_keywords' type=text class='fsearchlarge' size='60'   <%if(request.getParameter("f_keywords") != null) { out.print("value=\"" + request.getParameter("f_keywords") + "\"");}%> >
       </td>
     </tr>
    
     <tr></tr>
    
     <tr>
       <th class='search-form-label b-153 '>Date</th>
       <td class='search-form-value'>
         <select name='f_firstdate_dd' id='f_firstdate_dd'>
         <option value=''>Day</option>
         
            <%
            String m_firstdate_dd = request.getParameter("f_firstdate_dd");
             for (int i=1; i<=31; i++) {
                out.println("<option value='" + i + "'");
                if (m_firstdate_dd != null && m_firstdate_dd.equals(new Integer(i).toString())) {
                  out.print(" selected ");
                }
                out.println(">" + i +  "</option>");
             }
            %>       
         </select>
        
         <select name='f_firstdate_mm' id='f_firstdate_mm'>
            <option value=''>Month</option>
            <option value='01' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("01")) { out.print(" selected ");}%> >January</option>
            <option value='02' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("02")) { out.print(" selected ");}%> >February</option>
            <option value='03' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("03")) { out.print(" selected ");}%> >March</option>
            <option value='04' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("04")) { out.print(" selected ");}%> >April</option>
            <option value='05' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("05")) { out.print(" selected ");}%> >May</option>
            <option value='06' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("06")) { out.print(" selected ");}%> >June</option>
            <option value='07' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("07")) { out.print(" selected ");}%> >July</option>
            <option value='08' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("08")) { out.print(" selected ");}%> >August</option>
            <option value='09' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("09")) { out.print(" selected ");}%> >September</option>
            <option value='10' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("10")) { out.print(" selected ");}%> >October</option>
            <option value='11' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("11")) { out.print(" selected ");}%> >November</option>
            <option value='12' <%if(request.getParameter("f_firstdate_mm") != null && request.getParameter("f_firstdate_mm").equals("12")) { out.print(" selected ");}%> >December</option>
         </select>
         Year
         <input id ='f_firstdate_yyyy' name ='f_firstdate_yyyy' type='text' size='4' <%if(request.getParameter("f_firstdate_yyyy") != null) { out.print("value=\"" + request.getParameter("f_firstdate_yyyy") + "\"");}%>>&nbsp;(yyyy)
      </td>
    </tr>
    <tr>
      <th class='search-form-label b-153 '>Type</th>
      <td class='search-form-value'>
         <select name="f_sub_types" id="f_sub_types" size='10' id="f_sub_types"  multiple>
            <%
              String [] subTypesTemp = (String [])request.getParameterValues("f_sub_types");
              
              // let's get the lookup codes that are associated to resources/items
              crsetForm = lookupCode.getLookupCodes("RESOURCE_SUB_TYPE", "ITEM","ITEM_SUB_TYPE_LOV_ID");

              if(crsetForm != null && crsetForm.next()){
                do{
                  out.print("<option value='" + crsetForm.getString("code_lov_id") + "'" );
                  if (subTypesTemp != null)  {
                    for (int i=0; i<subTypesTemp.length; i++) {
                      if (subTypesTemp[i].equals(crsetForm.getString("code_lov_id"))) {
                        out.print(" selected");
                        break;
                      }
                    }
                  }
                  out.println(">" + crsetForm.getString("description") + "</option>");
                }while(crsetForm.next());
              }
              else
                out.println("<option>No Sub Types</option>");
            %>
         </select>
       </td>
     </tr>

     <tr>
       <th class='search-form-label b-153 '>Collecting&nbsp;Institution</th>
       <td class='search-form-value'>
         <select id = 'f_collectingInstitution' name='f_collectingInstitution'>
         <option value=''>Collecting Institution</option>

            <%
                           
              // let's get the lookup codes that are associated to resources/items
              
              crsetForm = organisation.getOrganisations(stmt,"2");
              String m_collectingInstitution = request.getParameter("f_collectingInstitution");

              if(crsetForm != null && crsetForm.next()){
                do{
                  out.print("<option value='" + crsetForm.getString("ORGANISATIONID") + "'" );
                  if (m_collectingInstitution!= null && m_collectingInstitution.equals(crsetForm.getString("ORGANISATIONID"))) {
                        out.print(" selected");
                  }
                  out.println(">" + crsetForm.getString("NAME") + "</option>");
                }while(crsetForm.next());
              }
              else
                out.println("<option>No Collection Institutions</option>");
            %>

           </select>
         </td>
       </tr>

    
        
       <tr>
          <th class='search-form-label b-153 '>Work</th>
          <td class='search-form-value'>
            <input class='search-form-input-text' id='f_work' name ='f_work' type='text' size='60' <%if(request.getParameter("f_work") != null) { out.print("value=\"" + request.getParameter("f_work") + "\"");}%> >&nbsp;</td>
        </tr>
        <tr>
          <th class='search-form-label b-153 '>Event</th>
          <td class='search-form-value'>
            <input class='search-form-input-text' id='f_event' name ='f_event' type='text' size='60' <%if(request.getParameter("f_event") != null) { out.print("value=\"" + request.getParameter("f_event") + "\"");}%>>&nbsp;</td>
        </tr>
        <tr>
       <th class='search-form-label b-153 '>Contributor</th>
        <td class='search-form-value'>
          <input class='search-form-input-text' id='f_contributor' name ='f_contributor' type='text' size='60' <%if(request.getParameter("f_contributor") != null) { out.print("value=\"" + request.getParameter("f_contributor") + "\"");}%>>&nbsp;</td>
        </tr>
        
        <tr>
        <th class='search-form-label b-153 '>Venue</th>
        <td class='search-form-value'>
          <input class='search-form-input-text' id='f_venue' name ='f_venue' type='text' size='60' <%if(request.getParameter("f_venue") != null) { out.print("value=\"" + request.getParameter("f_venue") + "\"");}%>>&nbsp;</td>
        </tr>
        
        <tr>
          <th class='search-form-label b-153 '>Organisation</th>
          <td class='search-form-value' >
            <input class='search-form-input-text' id='f_organisation' name ='f_organisation' type=text class='fsearchlarge' size='60' <%if(request.getParameter("f_organisation") != null) { out.print("value=\"" + request.getParameter("f_organisation") + "\"");}%>></td>
        </tr>

<tr>
  <th class='search-form-label b-153 '>Display</th> 
  <td class='search-form-value'>
    <select name='f_assoc_item' id='s'>
      <option value='all'>All Resources</option>
      <option value='ONLINE'>Online Resources</option>
    </select>
 </td>
</tr>
        <tr>
        <th class='search-form-label b-153 '>Sort results by</th>
          <td class='search-form-value'>
            <select name='f_sort_by' id='f_sort_by'>
              <option value='item_sub_type'   <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("type")) { out.print(" selected ");}%> >Type</option>
              <option value='title'  <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("title")) { out.print(" selected ");}%> >Title</option>
              <!--<option value='state'  <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("creator")) { out.print(" selected ");}%> >Creator</option>-->
              <option value='source_citation' <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("source")) { out.print(" selected ");}%> >Source</option>
              <option value='citation_date'   <%if(request.getParameter("f_sort_by") != null && request.getParameter("f_sort_by").equals("date")) { out.print(" selected ");}%> >Date</option>
            </select>
          </td>
          </tr>
        
        <tr>
          <th class='search-form-label b-153 '>Number of results per page</th>
    	  <td class='search-form-value'>
 	    <select name='f_limit_by'>
	      <option value='20'>20</option>
	      <option value='50'>50</option>
	      <option value='75'>75</option>
	      <option value='100'>100</option>
            </select>
          </td>
	</tr>
        <tr>
          <th class='search-form-label b-153 '></th>
          <td  class='search-form-value'><input value='Search'type="submit" ><a class="helpIcon" target='_blank' href="/pages/static/help.html"></a></td>
        </tr>      
      </table>
</form>
<script language="javascript">
   
  MM_preloadImages('/custom/ausstage/images/ausstage_home_searchon.gif');

  function MM_preloadImages() { 
   var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
     var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
     if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
  }

  function MM_swapImgRestore() { 
   var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
  }

  function MM_findObj(n, d) { 
   var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
     d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
   if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
   for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
  }

  function MM_swapImage() {

   var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
  }

  // just need to validate the year 
  // to do with 2 digit year, which won't happen here
  function getYear(d) { 
    return (d < 1000) ? d + 1900 : d;
    }
  
  // validate the date
  function isDate (day, month, year) {
    // month argument must be in the range 1 - 12
    month = month - 1;  // javascript month range : 0- 11
    var tempDate = new Date(year,month,day);
    if ( (getYear(tempDate.getYear()) == year) &&
       (month == tempDate.getMonth()) &&
       (day == tempDate.getDate()) ){ 

        return true;
    } else {

        return false;
    }
  }

    var temp = 1;
    var msg = "";
    var form = document.searchform;

    function checkFields(){
    
      //all fields are empty
      if(form.f_keywords.value == "" && form.f_firstdate_yyyy.value == "" && form.f_collectingInstitution.value == ""
          && form.f_creator.value == "" && form.f_title.value == "" 
          && form.f_source.value == "" && form.f_work.value == "" && form.f_event.value == ""
          && form.f_contributor.value == "" && form.f_venue.value == "" 
          && form.f_organisation.value == ""
          && form.f_sub_types.selectedIndex == -1
          //&& form.f_secondary_genre.selectedIndex ==-1
          ){
      
        alert("At least one search field is required. Please press ok.");
        return (false);
      }
      
      //the user does not have to enter a date as long as they enter a full date or
      //just the month and year or just the year.
      msg = "";
      
      // check dates
      // DATE
      // Check  Date
      if(form.f_firstdate_dd.value != ""){
        // must have mm & yyyy as well
        if(form.f_firstdate_mm.value == "" || form.f_firstdate_yyyy.value == "")
          msg += "- Date - MM and YYYY are required as well\n";
      }
      else if(form.f_firstdate_mm.value != ""){
         // must have yyyy as well
         if(form.f_firstdate_yyyy.value == "")
           msg += "- Date - YYYY is required as well\n";
      }
    
      //Check Integer
      if ((!isBlank(form.f_firstdate_yyyy.value) && !isInteger(form.f_firstdate_yyyy.value)) ||
    		     (!isBlank(form.f_firstdate_yyyy.value) && form.f_firstdate_yyyy.value.length != 4) ){
    		    msg += "- Date. Year must be valid number using the format YYYY\n";
    		  }

      
      if(msg != ""){
        alert("You have not entered the correct value(s) for\n" + msg + "Please press OK.");
        return(false);
      }
      else{
        return(ajaxFunction());
      }
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
      for (i = 0; i < s.length; i++){   
          // Check that current character is number.
          c = s.charAt(i);
          if (!isDigit(c)) 
            return false;
      }
      // All characters are numbers.
      return true;
  }

  function isDigit (c){
    return ((c >= "0") && (c <= "9"))
  }
  
  function checkValidDate (p_fieldName, p_day, p_month, p_year) {
    // rules:
    // can have only year and no month or day
    // can have year and month
    // can have year, month and day - then validate
    var msg = "";

    if (!isBlank(p_year)){
      // valid year
      if (isInteger(p_year)){
        // check month
        if(!isBlank(p_month)){
          // valid month
          if (isInteger(p_month)
              && document.searchform.p_month.value < 13){
            // check valid day
            if (!isBlank(p_day)
                && isInteger(p_day)){
              // validate day, month, year combination
              if (isDate(p_day, p_month, p_year)){
                // good date
              } else {
                msg += "- " + p_fieldName + " Date on - must be complete & valid (DD MM YYYY)\n";
              }
            }                  
          } else {
            msg += "- " + p_fieldName + " Date - must have valid month\n";
          }
        } else {
          if (!isBlank(p_day)){
            msg += "- " + p_fieldName + " Date on - must be complete & valid (DD MM YYYY)\n";
          }
        }
      } else {
        msg += "- " + p_fieldName + " Date - must have valid year\n";
      }
    } else {
      // if no year then day and month can't have values
      if (!isBlank(p_month)
          || !isBlank(p_day)){
            
          msg += "- " + p_fieldName + " Date on - must be complete & valid (DD MM YYYY)\n";
      } else {
        // is okay
      }
    }
    return msg;
  }
  
  
  function ajaxFunction(){
	var ajaxRequest;  // The variable that makes Ajax possible!
	
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong, return true to go to the next page
				return true;
			}
		}
	}
	// Create a function that will receive data sent from the server
	ajaxRequest.open("GET", "results/ajax.jsp?f_title=" + document.searchform.f_title.value
			+ "&f_creator=" + document.searchform.f_creator.value
			+ "&f_source=" + document.searchform.f_source.value
			+ "&f_keywords=" + document.searchform.f_keywords.value
			+ "&f_firstdate_dd=" + document.searchform.f_firstdate_dd.value
			+ "&f_firstdate_mm=" + document.searchform.f_firstdate_mm.value
			+ "&f_firstdate_yyyy=" + document.searchform.f_firstdate_yyyy.value
			+ "&f_collectingInstitution=" + document.searchform.f_collectingInstitution.value
			+ "&f_work=" + document.searchform.f_work.value
			+ "&f_event=" + document.searchform.f_event.value
			+ "&f_contributor=" + document.searchform.f_contributor.value
			+ "&f_venue=" + document.searchform.f_venue.value
			+ "&f_organisation=" + document.searchform.f_organisation.value
			+ "&f_assoc_item=" + document.searchform.f_assoc_item.value
			+ "&f_sort_by=" + document.searchform.f_sort_by.value
			+ "&f_limit_by=" + document.searchform.f_limit_by.value
			+ "&f_sub_types=" +$("#f_sub_types").val().join("&f_sub_types=")

, false);
	ajaxRequest.send(null); 

	if (ajaxRequest.responseText == "0") {
		alert("There were no results found for your search.");
		return false;
	} else {
		return true;
	}

}
  //-->
  </script>
  
  <%
stmt.close();
%>


<cms:include property="template" element="foot" />

</body>
</html>
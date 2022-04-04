<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page session="true" import="java.lang.String, java.util.*" %>
<%@ page import = "java.sql.Statement, sun.jdbc.rowset.CachedRowSet, admin.Common, java.util.*"%>
<%@ page import = "ausstage.User"%>
<%@ page import = "ausstage.Role"%>
<jsp:include page="../templates/admin-header.jsp" />
<%@ include file="../admin/content_common.jsp"%>
<%@ page import = "ausstage.AusstageCommon"%>
<link rel="stylesheet" type="text/css" href="resources/backend.css" />

<%

if (!session.getAttribute("permissions").toString().contains("Administrators")) {
    response.sendRedirect("/custom/welcome.jsp" );
    return;
  }

admin.FormatPage      pageFormater         = (admin.FormatPage)    session.getAttribute("pageFormater");
ausstage.Database     db_ausstage          = new ausstage.Database ();
Role	  role     		= new Role(db_ausstage);
User              	userObj             = new User(db_ausstage);
AusstageCommon        ausstageCommon       = new AusstageCommon();

String       username = "";
CachedRowSet rset;
String       mode= "";

db_ausstage.connDatabase (AusstageCommon.AUSSTAGE_DB_USER_NAME, AusstageCommon.AUSSTAGE_DB_PASSWORD);
Statement stmt = db_ausstage.m_conn.createStatement ();

ausstage.HtmlGenerator htmlGenerator = new ausstage.HtmlGenerator (db_ausstage);
ausstage.Datasource    datasource    = new ausstage.Datasource (db_ausstage);
Vector <Role> role_ids       	= new Vector();
Vector   selectedItems 	= new Vector();

mode = request.getParameter ("mode");

if (mode == null) { // Have come back from editing child records
	response.sendRedirect("/custom/user_search.jsp" );
    return;
  }
  else {
    // first time to this page
    String result = request.getParameter ("f_username");
    

    
    if (result == null) {
      username = "";
      mode = "add"; // Mode is really "add" if no username was selected.
      userObj = new User(db_ausstage);
    }
    else {
      
      mode = "edit";
      username=result.substring(0, result.indexOf(","));
     userObj.load(username);
     role_ids=userObj.getRoles();
     
    }
  }

	out.println("<form name='user_addedit_form' id='user_addedit_form' action='user_addedit_process.jsp' method='post' onsubmit='return checkMandatoryFields();'>");
	pageFormater.writeHelper(out, "General Information", "helpers_no1.gif");
	
	%>
    <input type="hidden" name="mode" value="<%=mode%>">
    
    <%
	if(userObj.getAccountFlag().equals("Y")){
		pageFormater.writeTwoColTableHeader(out,"");
		out.println("<font color='FF0000' size='2px'>Account Locked. To unlock, set a new password and save the record.</font>");
		pageFormater.writeTwoColTableFooter(out);
	}
	 pageFormater.writeTwoColTableHeader(out, "Username *");
	 if(mode.equals("add")){
		 out.println("<input type='text' name='f_username' size='60' class='line300' maxlength=256 value=\"" + userObj.getUserName() + "\">");
	 }
	 else{
		 
		 out.println(userObj.getUserName());
	 }
	 pageFormater.writeTwoColTableFooter(out);
	 
	 pageFormater.writeTwoColTableHeader(out, "First Name *");
	 out.println("<input type='text' name='f_first_name' size='60' class='line300' maxlength=256 value=\"" + userObj.getFirstName() + "\">");
	 pageFormater.writeTwoColTableFooter(out);
	 
	 pageFormater.writeTwoColTableHeader(out, "Last Name *");
	 out.println("<input type='text' name='f_last_name' size='60' class='line300' maxlength=256 value=\"" + userObj.getLastName() + "\">");
	 pageFormater.writeTwoColTableFooter(out);
	 
	 pageFormater.writeTwoColTableHeader(out, "Email *");
	 out.println("<input type='text' name='f_email' size='60' class='line300' maxlength=500 value=\"" + userObj.getEmail() + "\">");
	 pageFormater.writeTwoColTableFooter(out);
	 
	 pageFormater.writeTwoColTableHeader(out, "Organization");
	 out.println("<input type='text' name='f_organization' size='60' class='line300' maxlength=500 value=\"" + userObj.getOrganization() + "\">");
	 pageFormater.writeTwoColTableFooter(out);
	 
	 pageFormater.writeTwoColTableHeader (out, "Available Roles");
	 rset = role.getRoles(stmt);
	 if(rset.next()){   
	      out.println("\t<select name='f_role_id' class='line200' size='6' >\n");
	      do{
	        String selected = "";
	        
	        if(role_ids.size() >0){
	         
		    for (Role roleid : role_ids){//while(t_country_ids.hasMoreTokens())
	            	if(roleid.getRoleId().equals(rset.getString("role_id"))){//if(t_country_ids.nextToken().equals(rset.getString("CountryId")))
	              		if(!selectedItems.contains(rset.getString("role_id")))
	                		selectedItems.addElement(rset.getString("role_id"));   //adput(rset.getString("CONTFUNCTIONID"), rset.getString("CONTFUNCTION"));
	              			break;
	            	}
	            }
	        }
	        
	        out.println("\t\t<option value='"+ rset.getString("role_id") +"'>" + rset.getString("name")+"</option>\n");
	      }while(rset.next());
	      out.println("\t</select>\n");  
	    } else{
	        out.println("\t<select name='f_role_id' class='line200' >\n");
	        out.println("\t\t<option value=''>No Role found.</option>\n");
	        out.println("\t</select>\n"); 
	      }
	 
		pageFormater.writeTwoColTableFooter (out); 
	    pageFormater.writeTwoColTableHeader (out, "");
	    
	    out.println("\t<input type='button' value='Select' onclick=\"addtoSelected();\">\n");
	    pageFormater.writeTwoColTableFooter (out); 
	    
	    pageFormater.writeTwoColTableHeader (out, "Selected Role(s)*");
	    out.println("\t<select name='f_role_ids' class='line200' size='6' >\n");
	    String role_ids_string = "";
	    
	    for (Role roleId : role_ids){
	        role.load(Integer.parseInt(roleId.getRoleId()));
		role_ids_string += role_ids_string.equals("")? roleId.getRoleId():","+roleId.getRoleId();
	        out.println("\t\t<option value='" + role.getId() + "'>" +   role.getName() +"</option>\n");     	
	    }

	    out.println("\t</select>\n"); 
	    pageFormater.writeTwoColTableFooter (out); 
	    
	    %>
	    <input type="hidden" name="delimited_role_ids" value="<%=role_ids_string%>">
	    
	    <%
	 
	 pageFormater.writeHelper(out, "Password", "helpers_no2.gif");
	   
	 pageFormater.writeTwoColTableHeader(out,"");
	 out.println("<button type='button' onclick='generateRandom()'>Generate Random Password</button>");
	 pageFormater.writeTwoColTableFooter(out);
	 
	 if(mode.equals("add")){
		 
	 pageFormater.writeTwoColTableHeader(out, "Password *");
	 out.println("<input type='password' name='f_password' size='60' class='line300' maxlength=16 >");
	 pageFormater.writeTwoColTableFooter(out);
		 
	 pageFormater.writeTwoColTableHeader(out, "Confirm Password *");
	 out.println("<input type='password' name='f_confirm_password' size='60' class='line300' maxlength=16 >");
	 pageFormater.writeTwoColTableFooter(out); 
	 }
	 else {
		 pageFormater.writeTwoColTableHeader(out, "Password");
		 out.println("<input type='password' name='f_u_password' size='60' class='line300' maxlength=16 >");
		 pageFormater.writeTwoColTableFooter(out);
			 
		 pageFormater.writeTwoColTableHeader(out, "Confirm Password");
		 out.println("<input type='password' name='f_u_confirm_password' size='60' class='line300' maxlength=16 >");
		 pageFormater.writeTwoColTableFooter(out);
	 }
	    
	 
	 
	 if(mode.equals("edit")){
		 pageFormater.writeHelper(out, "Data Entry Information", "helpers_no3.gif"); 
		 
		 if(userObj.getLastLogin() != null && !userObj.getLastLogin().equals("")){
		 pageFormater.writeTwoColTableHeader(out, "Last Login:");
		 out.print(userObj.getLastLogin());
		 pageFormater.writeTwoColTableFooter(out);
		 }
		 pageFormater.writeTwoColTableHeader(out, "Created By User:");
		 out.print(userObj.getCreatedByUser());
		 pageFormater.writeTwoColTableFooter(out);
		 
		 pageFormater.writeTwoColTableHeader(out, "Date Created:");
		 out.print(userObj.getCreatedDate());
		 pageFormater.writeTwoColTableFooter(out);
		 
		 
		 if(userObj.getModifiedByUser() != null && !userObj.getModifiedByUser().equals("")){
		 
		 pageFormater.writeTwoColTableHeader(out, "Updated By User:");
		 out.print(userObj.getModifiedByUser());
		 pageFormater.writeTwoColTableFooter(out);
		 
		
		 
		 pageFormater.writeTwoColTableHeader(out, "Date Updated:");
		 out.print(userObj.getModifiedByDate());
		 pageFormater.writeTwoColTableFooter(out);
		 }
	 }
	 
	 db_ausstage.disconnectDatabase();
	  pageFormater.writePageTableFooter (out);
	  pageFormater.writeButtons(out, "back", "prev.gif", AppConstants.CONTEXT_ROOT + "welcome.jsp", "cross.gif", "submit", "next.gif");
	 
	  session.setAttribute("userObj",userObj);

%>
<script>
function addtoSelected(){
	
    var f_list      = document.getElementById('user_addedit_form').f_role_id;
    var f_sel_list  = document.getElementById('user_addedit_form').f_role_ids;
    console.log(f_list);
    console.log(f_sel_list);
    var index       = f_list.selectedIndex;
    var sel_index   = f_sel_list.selectedIndex;
    var selected_id;
    var selected_name;
    var i = 0;
    var selected_ids = '';
    var found = false;
    
    console.log(index);
    
//console.log('1');
    if((index > -1 && sel_index == -1) || (index == -1 && sel_index > -1)){

      if(index > -1){                                                       
        // repository list is selected, so put it to the selected list
        selected_id   = f_list.options[index].value;
        selected_name = f_list.options[index].text;
//console.log('2');
        if(f_sel_list.options.length != 0){
        console.log('3');
          for(i= 0 ; i < f_sel_list.options.length; i++){
          console.log('4');
            if(f_sel_list.options[i].value == selected_id){
              found = true;
              break;
            }
          }
        }
        //console.log('5');
        if(!found){
          //selected_name = selected_name.substring(selected_name.indexOf(', ') + 2, selected_name.length);
          console.log('6');
          if(selected_name != ""){
          
            if(f_sel_list.options.length != 0){
            console.log('7');
              f_sel_list.options[f_sel_list.options.length] = new Option(selected_name, selected_id, false, false); // add to selected list
            }else{
              f_sel_list.options[0] = new Option(selected_name, selected_id); // add to selected list
              console.log('8');
            }
          }
        }
      }else{
        // remove from the selected list
        f_sel_list.options[sel_index] = null; 
      }
    }else{
      alert("You have not selected a Role to Add/Remove.");
    }
    
    f_list.selectedIndex     = -1;
    f_sel_list.selectedIndex = -1;
    var i =0;
    var temp_ids = '';
    var seleted_list = document.getElementById('user_addedit_form').f_role_ids;
    for(i= 0; i < seleted_list.options.length; i++){
      if(temp_ids == '')
        temp_ids = seleted_list.options[i].value;
      else
        temp_ids += "," + seleted_list.options[i].value;
    }
    document.getElementById('user_addedit_form').delimited_role_ids.value = temp_ids;
  }

function checkMandatoryFields(){
	if (document.user_addedit_form.mode.value == "edit"){
		if(
 		       document.user_addedit_form.f_first_name.value == null ||
 		       document.user_addedit_form.f_first_name.value == "" ||
 		       document.user_addedit_form.f_last_name.value == null ||
 		       document.user_addedit_form.f_last_name.value == ""||
 		       document.user_addedit_form.f_email.value == null ||
 		       document.user_addedit_form.f_email.value == ""||
 		       document.user_addedit_form.delimited_role_ids.value == null ||
 		       document.user_addedit_form.delimited_role_ids.value == ""){     
 		      alert("Please make sure all mandatory fields (*) are filled in");
 		      return false;
 		    }
    } else if(document.user_addedit_form.mode.value == "add"){
    	 if(document.user_addedit_form.f_username.value == null ||
    		       document.user_addedit_form.f_username.value =="" || 
    		       document.user_addedit_form.f_first_name.value == null ||
    		       document.user_addedit_form.f_first_name.value == "" ||
    		       document.user_addedit_form.f_last_name.value == null ||
    		       document.user_addedit_form.f_last_name.value == ""||
    		       document.user_addedit_form.f_email.value == null ||
    		       document.user_addedit_form.f_email.value == ""||
    		       document.user_addedit_form.f_password.value == null ||
    		       document.user_addedit_form.f_password.value == "" ||
    		       document.user_addedit_form.f_confirm_password.value == null ||
    		       document.user_addedit_form.f_confirm_password.value == "" ||
    		       document.user_addedit_form.delimited_role_ids.value == null ||
    		       document.user_addedit_form.delimited_role_ids.value == ""){     
    		      alert("Please make sure all mandatory fields (*) are filled in");
    		      return false;
    		    }
    }
    
   
    return true 

  }
function generateRandom() {
	var result           = '';
    var characters       = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var charactersLength = characters.length;
    for ( var i = 0; i < 5; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   				}
    var characters       = "abcdefghijklmnopqrstuvwxyz";
    var charactersLength = characters.length;
    for ( var i = 0; i < 3; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   				}
    var characters       = "^`!@#$%^&?*-_=+'/.,";
    var charactersLength = characters.length;
    for ( var i = 0; i < 2; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   				}
    var choice = confirm("Password(Please Copy and Save for Yourself):       "+result);
    
    if (document.user_addedit_form.mode.value == "edit"){
    	if(choice==true){
  		  document.getElementById('user_addedit_form').f_u_password.value = result;
  		  document.getElementById('user_addedit_form').f_u_confirm_password.value = result;
  	  }	
    } else if(document.user_addedit_form.mode.value == "add"){
    	if(choice==true){
    		document.getElementById('user_addedit_form').f_password.value = result;
  		  document.getElementById('user_addedit_form').f_confirm_password.value = result;
    	}
    	
    }
    
    
}



</script>


<jsp:include page="../templates/admin-footer.jsp" />

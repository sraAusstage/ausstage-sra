<% 
	String heading = request.getParameter("heading");
	String text = request.getParameter("text");

if(heading != null && !"".equals(heading) && !"null".equals(heading)) {
%>
	<div class="heading-element">
		<%= heading %>
	</div>
<%
}

if(text != null && !"".equals(text) && !"null".equals(text)) {
%>
	<div class="text-element">
		<%= text %>	
	</div>
<%
}

%>
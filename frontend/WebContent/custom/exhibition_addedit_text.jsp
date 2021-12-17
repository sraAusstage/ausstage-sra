<div class="exhibition-element-header exhibition-text-block">
	<div>
<% 
	String exhibitionSectionId = request.getParameter("exhibition_sectionid");
	String heading = request.getParameter("heading");
	String text = request.getParameter("text");

if(heading != null  && !"null".equals(heading )) {
%>
		
			<div style='' class='exhibition-text-label'>Heading</div>
			<div><input class="txtTypeHeading" placeholder="Type your heading here..." type="text" maxlength="250" id="section_id<%= exhibitionSectionId %>_heading" name="section_id<%= exhibitionSectionId %>_heading" value="<%= heading.replaceAll("\"", "&quot;") %>"></div>
		
<%
}

if(text != null  && !"null".equals(text )) {
%>
		
			<div  class='exhibition-text-label'>Text</div>
			<div><textarea class="txtTypeTextArea" placeholder="Type your text here..." maxlength="998" id="section_id<%= exhibitionSectionId %>_text" name="section_id<%= exhibitionSectionId %>_text" rows="4" cols="50"><%= text.replaceAll("\"", "&quot;")%></textarea></div>
		
<%
}

%>
	</div>
</div>
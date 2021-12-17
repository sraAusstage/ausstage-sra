 	
<!--added class=footer for mapping-->
<div id="footer" class="footer">
 
<div class="footer-left">
<span class="footer-label"><a href="/pages/browse/">AusStage</a> &bull; Researching Australian live performance</span>
<br><span class="footer-label small"><a href="/pages/learn/about/">About</a> | <a href="/pages/learn/contact/accessibility.html">Accessibility</a> | <a href="/pages/learn/contact/">Contact</a> | <a href="/pages/learn/contact/cultural-advice.html">Cultural Advice</a> | <a href="/pages/learn/help.html">Help</a> | <a href="/pages/learn/contact/privacy.html">Privacy</a> | <a href="/pages/learn/contact/terms-of-use.html">Terms of Use</a></span>
</div>

<div class="footer-right label small">
Copyright &copy; AusStage and contributors, 2003<script type="text/javascript">var d=new Date();d=d.getFullYear();document.write("-"+d);</script>.<br>Licensed for use <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">CC BY-NC-SA 4.0</a>.
</div>

 
 </div>
 </div>
</body>
</html>
<script type="text/javascript">

function headerSearch (){
	console.log($("#header-search-keywords").val())	;
	$('#header-search-form #h_keyword').attr('value',$("#header-search-keywords").val());
	$('#header-search-form').submit();
}

$(document).ready(function() {

	$("#header-search-form").keypress(function(event) {
  		if ( event.which == 13 ) {
  			console.log("enter");
     			event.preventDefault(); headerSearch();
   		}
   		
   	});
   	
   	 //this is to handle chrome on mac render bug. see JIRA AUS-52
 	$(".scroll-table").scroll(function(){
		$("thead tr").hide().show(0);
		$("tfoot tr").hide().show(0);    
	});
				
});



</script>

<script type="text/javascript">

var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-10089663-1");
pageTracker._trackPageview();
} catch(err) {}</script>

<!-- TEMPLATE 2 FRONTEND END-->
///////////////////////////////////////////////////
// ShowHide plugin                               
// Author: Ashley Ford - http://papermashup.com
// edited by : Brad Williams
// Demo: Tutorial - http://papermashup.com/jquery-show-hide-plugin
// Built: 19th August 2011                                     
///////////////////////////////////////////////////

(function ($) {
    $.fn.showHide = function (options) {

		//default vars for the plugin
        var defaults = {
            speed: 500,
			easing: '',			
            changeIcon: 1,
            showIcon: 'glyphicon-chevron-down',
            hideIcon: 'glyphicon-chevron-up'
        };
        var options = $.extend(defaults, options);
	$(this).addClass('clickable');
        $(this).click(function () {	             
			 // this var stores which button you've clicked
             var toggleClick = $(this);
		     // this reads the rel attribute of the button to determine which div id to toggle
		     var toggleDiv = toggleClick[0].nextElementSibling;
		     // here we toggle show/hide the correct div at the right speed and using which easing effect
		     $(toggleDiv).slideToggle(options.speed, options.easing, function() {
		     // this only fires once the animation is completed
                if(options.changeIcon==1){
                console.log("this is a test!!!!!!");
                    var toggleClickIcon = toggleClick.find('.show-hide-icon');
                    toggleClickIcon.toggleClass(options.hideIcon);
                    toggleClickIcon.toggleClass(options.showIcon);
                }    
             });
		   
		  return false;
		   	   
        });

    };
})(jQuery);
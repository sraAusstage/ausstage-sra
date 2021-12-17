//plugins?

(function ($) {
    $.fn.formbutton = function (options) {

		//default vars for the plugin
        var defaults = {
            speed: 500,
			easing: '',			
            changeIcon: 0,
            showIcon: 'glyphicon-plus',
            hideIcon: 'glyphicon-minus'
            
        };
        var options = $.extend(defaults, options);
        console.log($(this));
        $(this).click(function () {	             
             console.log("i've been clicked. There should be a variable that I can "+
                        "get access to, so I can pick which TAB to show....? what do you think?");            
            
			 // this var stores which button you've clicked
             var click = $(this);
             //$("#"+div_to_open).appendTo("#addEvent");
             var div_to_open = click.data("id-to-open");
             //find the div, make sure it's size is appropriate and bring it in. 
             $("#"+div_to_open).toggleClass('page-on');
             //alert(click.data("id-to-open"));
             //console.log($(this).data("id-to-open"));
            
             
		  return false;
		   	   
        });

    };
})(jQuery);
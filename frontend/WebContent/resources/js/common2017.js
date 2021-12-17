

$(document).ready(function(){
    //show hide areas
    $('.show-hide').showHide({
        speed: 400, // speed you want the toggle to happen
        easing: '', // the animation effect you want. Remove this line if you dont want an effect and if you haven't included jQuery UI
        changeIcon: 1,
        showIcon: 'glyphicon-chevron-down',
        hideIcon: 'glyphicon-chevron-up'
    });
    
    //format the date pickers
    //$('.input-group.date').datepicker({
     //   format: "dd MM yyyy",    
    //});
    
    //initiate the form buttons
    //$('.input-group.venue').formbutton();
    
    //initiate the sortable areas
    //$('.order-by').sortable();
    
    //inject the templates
     //$('#hidden').load('/templates.html');
});
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.

//= require jquery
//= require jquery_ujs
//= require underscore
//= require jquery.more
//= require gmaps/google
//= require bootstrap
//= require ckeditor/init
//= require config
//= require jquery.ui.all
//= require autocomplete-rails
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.smoothDivScrol
//= require jquery.mousewheel.min
//= require jquery.kinetic.min
//= require jquery-tablesorter
//= require wice_grid
//= require jquery.jrating
//= require jquery.cookie

$(document).on("click", "#dLabel", function() {
    window.location.href = "/about_us"
} )


jQuery.extend(jQuery.validator.messages, {
    required: "This field is required.",
    remote: "Please fix this field.",
    email: "Please enter a valid email address.",
    url: "Please enter a valid URL.",
    date: "Please enter a valid date.",
    dateISO: "Please enter a valid date (ISO).",
    number: "Please enter a valid number.",
    digits: "Please enter only digits.",
    creditcard: "Please enter a valid credit card number.",
    equalTo: "Please enter the same value again.",
    accept: "Please enter a value with a valid extension.",
    maxlength: jQuery.validator.format("Please enter no more than {0} characters."),
    minlength: jQuery.validator.format("Please enter at least {0} characters."),
    rangelength: jQuery.validator.format("Please enter a value between {0} and {1} characters long."),
    range: jQuery.validator.format("Please enter a value between {0} and {1}."),
    max: jQuery.validator.format("Please enter a value less than or equal to {0}."),
    min: jQuery.validator.format("Please enter a value greater than or equal to {0}.")
});

jQuery.validator.addClassRules('required', {
    required: true
})



$(document).ajaxComplete(function(event, request){

    var flash = $.parseJSON(request.getResponseHeader('X-Flash-Messages'));
    if(!flash) return;
    if(flash.notice) {
        /* code to display the 'notice' flash */
        $('.flash.notice').html(flash.notice);
        $("#flash-message").html('<div class="alert alert-info alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' + flash.notice + '</div>');
        console.log("flash: " + $("#flash-message").html());
    }
    if(flash.success) {
        /* code to display the 'notice' flash */
        $('.flash.success').html(flash.success);
        $("#flash-message").html('<div class="alert alert-success alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' + flash.success + '</div>');
        console.log("flash: " + $("#flash-message").html());
    }
    if(flash.error) {
        /* code to display the 'error' flash */
        $("#flash-message").html('<div class="alert alert-danger alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' + flash.error + '</div>');
        console.log("flash: " + $("#flash-message").html());
    }

    window.setTimeout(function() {
        $("#flash-message").fadeTo(500, 0).slideUp(500, function(){
            $(this).remove();
        });
    }, 50000);

})

$(document).ready(function(){
    console.log("=> register form validation");
    $('#new_user').validate();
})

$(document).ready(function(){
    console.log("=> login form validation");
    $('#login_form').validate();
})





// START OF CODE FROM http://homework.nwsnet.de/news/9132_put-and-delete-with-jquery
/* Extend jQuery with functions for PUT and DELETE requests. */

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}


jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});

// END OF CODE FROM http://homework.nwsnet.de/news/9132_put-and-delete-with-jquery

var chart; // high charts for results/analysis

$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function() {
  //make links with ajax class request with ajax VERY IMPORTANT FUNCTION
  $('a.ajax').live('click', function() {
    $.get($(this).attr("href"));
	  return false;
  });
  
  //make forms with ajax class submit with ajax VERY IMPORTANT FUNCTION
  $('form.ajax').live('submit', function() {
    $.post($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  });
		
  //make inputs submit on click
  $('input[step[completed]].ajax').live('click', function() {
    $(this).closest('form').submit();
  });

  //make select submit on change; However,
  //this only applies to the select on the current page
  //You have to do this again in the foo.js.erb for later selects that are generated
  $('select.ajax').change(function() {
    $(this).closest('form').submit();
  });

  //make divs with ajax class follow its child link with ajax
  $('div.ajax').live('click', function() {
     $.get($(this).find('a').attr("href"));
     return false;
  });

  //make links with popup class use the fancybox dialog
  $('a.popup').fancybox({
    'scrolling': 'no',
    'titleShow': false,
    'hideOnOverlayClick': false,
    'centerOnScroll': true
  });
  
  //make forms with validate class use ajax validation http://bassistance.de/jquery-plugins/jquery-plugin-validation/
  $("form.validate").validate({
    rules: {
      "user[first_name]": "required",
      "user[last_name]": "required",
      "user[email]": {
        required: true,
        email: true
      },
      "user[password]": {
        required: true,
        minlength: 5,
        maxlength: 15
      },
      "user[password_confirmation]": {
        equalTo: "#user_password"
      },
      "user[birth_date]": { 
        required: true,
        dateISO: true
      },
      "user[gender]": "required",
      "user[country]": "required"
    },
    messages: {
      "user[first_name]": {
        required: " "
      },
      "user[last_name]": {
        required: " "
      },
      "user[email]": {
        required: " ",
        email: " "
      },
      "user[password]": {
        required: " ",
        minlength: " ",
        maxlength: " "
      },
      "user[password_confirmation]": {
        equalTo: " "
      },
      "user[birth_date]": { 
        required: " ",
        dateISO: " "
      },
      "user[gender]": {
        required: " "
      },
      "user[country]": {
        required: " "
      }
    },
    errorPlacement: function(error, element) { 
        if ( element.is(":radio") ) 
            error.appendTo( element.parent().parent().parent()); 
        else if ( element.is(":checkbox") ) 
            error.appendTo ( element.next() ); 
        else 
            error.appendTo( element.parent() ); 
    },
    success: function(label) {
      label.html(" ").addClass("success");
    }
  });
		
		// Display a loading message when ajax requesting		
		$('.ajax').ajaxStart(function() {
			$.fancybox.showActivity();	// spinner		
		});		
		$('.ajax').ajaxComplete(function() {
			$.fancybox.hideActivity();			
		});
		/* $('.ajax #step_completed').ajaxStart(function() {
			$(this).hide();// spinner
			$(this).after("<span class='proc'>Processing!</span>");		
		});
		$('.ajax #step_completed').ajaxComplete(function() {
			$(this).show();// spinner
			$(this).parents().remove("span");			
		}); */

//DASHBOARD*****************


    //  attempting sortable lists

  // UJS authenticity token fix: add the authenticy_token parameter
  // expected by any Rails POST request.
  //$(document).ajaxSend(function(event, request, settings) {

    // do nothing if this is a GET request. Rails doesn't need
    // the authenticity token, and IE converts the request method
    // to POST, just because - with love from redmond.
    //if (settings.type == 'GET') return;
    //if (typeof(AUTH_TOKEN) == "undefined") return;
   // settings.data = settings.data || "";
   // settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
 //});



  // User Form Date Picker

  $('#user_birth_date').datepicker({
    yearRange: '-95:-10',
    minDate: '-95y',
    maxDate: '-10y',
    changeMonth: true,
    changeYear: true,

    dateFormat: 'yy-mm-dd',
    defaultDate: '-20y',
    onSelect: function() {
      this.focus();
    }
  });
  

//  $('.remove_unsent_invitation').click(function() {
//    $.delete_($(this).attr("href"));
//    //	  return false;
//  })

  //Rich Text for textareas http://code.google.com/p/jwysiwyg/
  $('textarea').wysiwyg({
    controls: {
      strikeThrough : { visible : false },
      underline     : { visible : false },
      
      separator00 : { visible : false },
      
      justifyLeft   : { visible : false },
      justifyCenter : { visible : false },
      justifyRight  : { visible : false },
      justifyFull   : { visible : false },
      
      separator01 : { visible : false },
      
      indent  : { visible : false },
      outdent : { visible : false },
      
      separator02 : { visible : false },
      
      subscript   : { visible : false },
      superscript : { visible : false },
      
      separator03 : { visible : false },
      
      undo : { visible : false },
      redo : { visible : false },
      
      separator04 : { visible : true },
      
      insertOrderedList    : { visible : true },
      insertUnorderedList  : { visible : true },
      insertHorizontalRule : { visible : true },
      
      separator05 : { visible : false },
      
      createLink  : { visible : false },
      insertImage : { visible : false },
      

      separator07 : { visible : true },
      
      cut   : { visible : false },
      copy  : { visible : false },
      paste : { visible : true }
    }
  });
		
/*
 * Growth Plan
 */
			
	  $('#goals').sortable({
    axis: 'y',
    cursor: 'move',
    handle: '.handle',
    update: function(){
      $.ajax({
        type: 'put',
        data: $('#goals').sortable('serialize') + '&id=' + current_user_id,
        dataType: 'script',
        complete: function(request){
          $('#goals').effect('highlight');
        },
        url: '/goals/re_order_goals'});
    }  
  });
});

function remove_fields(link) {  
    $(link).closest("fieldset").remove();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).before(content.replace(regexp, new_id));
}
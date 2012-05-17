$(document).ready(function() {
/* Sliding on the tour */
	if($('#tour').length > 0) {
	  var horizontal = true;

	  var $panels = $('#tour .panel');
	  var $container = $('#scroll_container');
	  var $scroll = $('#scroll').css('overflow', 'hidden');

	  if (horizontal) {
	    /* console.log($container); */
	    $panels.css({
	      'float' : 'left',
	      'position' : 'relative'
	    });

	    $container.css('width', $panels[0].offsetWidth * $panels.length);
	  }

	  function selectNav() {
	    $(this)
	      .parents('ul:first')
	        .find('a') 
	          .removeClass('selected') 
	        .end()
	      .end()
	      .addClass('selected'); 
	  }

	  $('#tour .navigation a').click(selectNav);	  
	  $('#tour .navigation').find('a').click(selectNav);

	  function trigger(data) {
	    var el = $('#slider .navigation').find('a[href$="' + data.id + '"]').get(0);
	    selectNav.call(el);
	  }

	  if (window.location.hash) {
	    trigger({ id : window.location.hash.substr(1) });
	  } else {
	    $('ul.navigation a:first').click();
	  }

	  var offset = parseInt((horizontal ?
	    $container.css('paddingTop') :
	    $container.css('paddingLeft'))
	    || 0) * -1;

	  var scrollOptions = {
	    target: $scroll, 
	    items: $panels,
	    navigation: '.navigation a',
	    axis: 'xy',
	    onAfter: trigger,
	    offset: offset,
	    duration: 200,
	    easing: 'swing'
	  };

	  $('#tour').serialScroll(scrollOptions);

	  scrollOptions.duration = 1;
	  $.localScroll.hash(scrollOptions);
	}
});
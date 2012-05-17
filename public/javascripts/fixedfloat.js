$(document).ready(function() {
  var msie6 = $.browser == 'msie' && $.browser.version < 7;

  if (!msie6) {
    var left = $('#content_inner').offset().left + 774;
    var top = $('#table_of_contents').offset().top - parseFloat($('#table_of_contents').css('margin-top').replace(/auto/, 0));
    $('#table_of_contents.fixed').css('left', left);
    $(window).scroll(function(event) {
      var y = $(this).scrollTop();

      if (y >= (top- 20)) {
        var left = $('#content_inner').offset().left + 774;
        $('#table_of_contents').addClass('fixed');
      } else {
        var left = 770;
        $('#table_of_contents').removeClass('fixed');
      }
      $('#table_of_contents').css('left', left);
    });
    $(window).resize(function(event) {
  
      var left = $('#content_inner').offset().left + 774;
      $('#table_of_contents.fixed').css('left', left);
    })
  }
});
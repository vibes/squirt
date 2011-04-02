var Squirts = (function($){
  var pageBody,

  init = function(){
    pageBody = $('body');

    setTimeout(function() { 
      // move screen to middle
      window.scrollTo(360, 465);
      // position the background video.
      positionBG(); 
    }, 0);

    $(window).scroll(positionBG);
    $(window).scroll(sendCoords);
    
  },

  /*
    mobile safari does not support position fixed.  we will manually do it
  */
  positionBG = function() {
    $('#video-feed').css({top: (window.pageYOffset) + 'px', left:(window.pageXOffset) + 'px'});
  },

  sendCoords = function(){
    $.post('/cmd/move/' + (pageBody.scrollLeft()) + ',' + (pageBody.scrollTop()));
  };

  return {
    init:init
  };
})(jQuery);

window.onload = Squirts.init;

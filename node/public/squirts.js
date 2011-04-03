var Squirts = (function($){
  var pageBody,currPos,

  init = function(){
    pageBody = $('body');

    setTimeout(function() { 
      // move screen to middle
      window.scrollTo(360, 465);
      // position the background video.
      positionBG(); 
      currPos = getPos();
    }, 0);

    $(window).scroll(positionBG);
    $(window).scroll(sendCoords);
    $(window).bind('touchStart',alert);
    $('#control').bind('click',squirt); 
  },

  getPos = function(){
    return {
      x:(20+(pageBody.scrollLeft() / 10)),
      y:(20+(pageBody.scrollTop() / 10))
    };
  },

  /*
    mobile safari does not support position fixed.  we will manually do it
  */
  positionBG = function() {
    $('#video-feed').css({top: (window.pageYOffset) + 'px', left:(window.pageXOffset) + 'px'});
  },

  sendCoords = function(){
    $.post('/cmd/move/' + (20+(pageBody.scrollLeft() / 10)) + ',' + (20+(pageBody.scrollTop() / 10)));
  },

  squirt = function(){
    $.post('/cmd/fire/');
  };

  return {
    init:init
  };
})(jQuery);

window.onload = Squirts.init;

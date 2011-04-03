var Squirts = (function($){
  var pageBody,currPos,

  init = function(){
    pageBody = $('body');

    setTimeout(function() { 
      // move screen to middle
      window.scrollTo(735, 705);
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
      x:(20+parseInt(pageBody.scrollLeft() / 10,10)),
      y:(20+parseInt(pageBody.scrollTop() / 10,10))
    };
  },

  /*
    mobile safari does not support position fixed.  we will manually do it
  */
  positionBG = function() {
    $('#video-feed').css({top: (window.pageYOffset) + 'px', left:(window.pageXOffset) + 'px'});
  },

  sendCoords = function(){
    var coords = getPos();
    $.post('/cmd/move/' + coords['x'] + ',' + coords['y'] );
  },

  squirt = function(){
    $.post('/cmd/fire/');
  };

  return {
    init:init
  };
})(jQuery);

window.onload = Squirts.init;

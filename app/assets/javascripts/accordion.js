$(function() {
  $('.accordion_head').click(function(){
    $(this).next().slideToggle();
  }).next().hide();
});


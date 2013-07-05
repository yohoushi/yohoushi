$(function() {
  $('.accordion_head').each( function() {
    $(this).after('<ul style="display: block;"></ul>');
  });

  $(document).on("click", '.accordion_head', function() {
    var ul = $(this).next();
    if (ul.text() == '') {
      term = $(this).data('term');
      $.getJSON("/children_graph?term=" + term, function(data) {
        $.each(data, function(i,item) {
          ul.append('<li><div class="accordion_head" data-term="' + item.path + '"><a href="' + item.uri + '" >' + item.basename+ "</a></div><ul style='dispaly: none;'><ul></li>");
        });
      });
      ul.hide().slideToggle();
    } else {
      ul.slideToggle();
    }
  }).next().hide();

});


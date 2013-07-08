$(function() {
  $('.accordion_head').each( function() {
    $(this).after('<ul style="display: none;"></ul>');
  });

  $(document).on("click", '.accordion_head', function() {
    var ul = $(this).next();
    if (ul.text() == '') {
      term = $(this).data('term');
      $.getJSON("/children_graph?term=" + term)
      .done(function(data) {
        $.each(data, function(i,item) {
          var accordion_class = (item.has_children == true) ? "accordion_head" : "accordion_leaf";
          ul.append('<li><div class="' + accordion_class + '" data-term="' + item.path + '"><a href="' + item.uri + '" >' + item.basename+ '</a></div><ul style="display: none;"></ul></li>');
        });
        ul.hide().slideToggle();
      });
    } else {
      ul.slideToggle();
    }
  }).next().hide();

});


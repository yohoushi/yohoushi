$(function() {
  $('.accordion-head').each( function() {
    $(this).after('<ul class="accordion-nav" style="display: none;"></ul>');
  });

  $(document).on("click", '.accordion-head', function() {

    var ul = $(this).next();
    if (ul.text() == '') {
      term = $(this).data('term');
      $.getJSON("/children_graph?term=" + term)
      .done(function(data) {
        $.each(data, function(i,item) {
          var div_class = (item.has_children == true) ? 'class="accordion-head"' : ''
          var icon_right = (item.has_children == true) ? '' : '<i class="icon-chevron-right"></i>'
          var arrow = (item.has_children == true) ?  '<span class="accordion-nav-arrow"></span>' : ''
          ul.append('<li><div ' + div_class + ' data-term="' + item.path + '"><a href="' + item.uri + '" >' + icon_right + ' ' + item.basename + '</a>' + arrow + '</div><ul class="accordion-nav" style="display: none;"></ul></li>');
        });

        // Add a class to ul tag if creat the last leaf box
        if (data[0].has_children == false) {
          ul.addClass('accordion-nav-leaf');
        }

        ul.hide().slideToggle();
      });
    } else {
      ul.slideToggle();
    }
  }).next().hide();

});


// @reference http://coder.blog.uhuru.co.jp/js/easy_accordion
$(function() {
  $('.accordion-head').each( function() {
    $(this).after('<ul class="accordion-nav" style="display: none;"></ul>');
  });

  $(document).on("click", '.accordion-head', function() {
    // Add/Remove opened status
    var arrow = $('> .accordion-nav-arrow', this);
    if (arrow.hasClass('accordion-nav-arrow-rotate')) {
      arrow.removeClass('accordion-nav-arrow-rotate');
    } else {
      arrow.addClass('accordion-nav-arrow-rotate');
    }

   var ul = $(this).next();
   if (ul.text() == '') {
      // fetch string from <ul data-term=""">
      term = $(this).data('term');

      // load contents via ajax
      $.getJSON("/accordion_graph?term=" + term)
      .done(function(data) {
        $.each(data, function(i,item) {
          var div_class = (item.has_children == true) ? 'class="accordion-head"' : ''
          var arrow = (item.has_children == true) ?  '<span class="accordion-nav-arrow"></span>' : ''
          ul.append('<li><div ' + div_class + ' data-term="' + item.path + '"><a href="' + item.uri + '" > ' + item.basename + '</a>' + arrow + '</div><ul class="accordion-nav" style="display: none;"></ul></li>');
        });

        // Add a class to ul tag if creat the last leaf box
        if (data[0].has_children == false) {
          ul.addClass('accordion-nav-leaf');
        }

        // Open the content window
        ul.hide().slideToggle();
      });
    } else {
        // Just open it
      ul.slideToggle();
    }

  });

});


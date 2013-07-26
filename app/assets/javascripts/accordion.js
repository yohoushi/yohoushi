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
      // fetch string from <ul data-path=""">
      var path = $(this).data('path');

      // load contents via ajax
      $.getJSON("/accordion_graph?path=" + path)
      .done(function(data) {
        $.each(data, function(i,item) {
          // Append following doms to <ul>.
          //
          //   li
          //     div.accordion-head data-path="a/b/c"
          //       a href="/list_graph?a/b/c" "c"
          //       span.accordion-nav-arrow /
          //     ul.accordion-nav style="display: none;" /
          //

          var li = $("<li/>");

          var div_class = (item.has_children == true) ? "accordion-head" : "accordion-nav-leaf";
          var div = $("<div/>").addClass(div_class).attr('data-path', escape(item.path));
          var a = $("<a/>").attr('href', item.uri).text(item.basename);
          var arrow_class = (item.has_children == true) ?  "accordion-nav-arrow" : ''
          var arrow = $("<span/>").addClass(arrow_class);
          li.append(div.append(a).append(arrow));

          var ul_dummy = $("<ul/>").addClass("accordion-nav").css('display', 'none');
          li.append(ul_dummy);

          ul.append(li);
        });

        // Open the content window
        ul.hide().slideToggle();
      });
    } else {
        // Just open or close it
      ul.slideToggle();
    }

  });

});


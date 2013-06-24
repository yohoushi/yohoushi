$(function() {
    function split( val ) {
      return val.split( /,\s*/ );
    }
    $( "#tagselect" ).bind( "keydown", function( event ) {
        if ( event.keyCode === $.ui.keyCode.TAB &&
            $( this ).data( "ui-autocomplete" ).menu.active ) {
          event.preventDefault();
        }
    }).autocomplete({
        minLength: 0,
        autoFocus: true,
        source: $('#tagselect').attr('data-autocomplete'),
        select: function( event, ui ) {
          var terms = split( this.value );
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push( ui.item.value );
          // add placeholder to get the comma-and-space at the end
          terms.push( "" );
          this.value = terms.join( ", " );
          return false;
        }
    });
});


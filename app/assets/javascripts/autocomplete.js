$(function() {
    $('#autocomplete').autocomplete({
        minLength: 0,
        autoFocus: true,
        source : $('#autocomplete').attr('data-autocomplete')
    }).focus(function() {
        $(this).autocomplete("search", "");
    });
});

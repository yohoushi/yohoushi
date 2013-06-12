$(function() {
    $('#autocomplete').autocomplete({
        minLength: 0,
        source : $('#autocomplete').attr('data-autocomplete')
    }).focus(function() {
        $(this).autocomplete("search", "");
    });
});

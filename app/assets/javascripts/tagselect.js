$(function() {
    $('#tagselect').tagit({
        autocomplete: {
            minLength: 0,
            autoFocus: true,
            source: $('#tagselect').attr('data-tagselect') 
        },
        showAutocompleteOnFocus: true,
    });
    $('.tagit').addClass('span11');
});

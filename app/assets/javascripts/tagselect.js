$(function() {
    $('#tagselect').tagit({
        autocomplete: {
            minLength: 0,
            autoFocus: true,
            source: $('#tagselect').attr('data-tagselect') 
        },
        placeholderText: $('#tagselect').attr('data-placeholder'),
        singleFieldDelimiter: ","
    });
    $('.tagit').addClass('span5');
    $(".tagcloud a").click(function(event){
        $("#tagselect").tagit("createTag", event.target.name);
        $('#tagselect-button').focus();
        return false;
    })
});

$(function() {
    $("#select-term").change(function(event){
        $('#tune-form').submit();
        return false;
    });
    $("#select-size").change(function(event){
        $('#tune-form').submit();
        return false;
    });
});

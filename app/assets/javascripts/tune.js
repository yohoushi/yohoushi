$(function() {
    $('#datetimepicker-from').datetimepicker();
    $('#datetimepicker-to').datetimepicker();
    // auto-submit
    $("#select-term").change(function(event){
        $('#select-from').val('');
        $('#select-to').val('');
        $('#tune-form').submit();
    });
    $("#select-size").change(function(event){
        $('#tune-form').submit();
    });
});

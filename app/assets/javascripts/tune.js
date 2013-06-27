$(function() {
    var datetime_submit = function(){
        if ($("#select-from").val().length > 0 && $("#select-to").val().length > 0) {
            $('#tune-form').submit();
        }
    };
    $('#datetimepicker-from').datetimepicker().on('changeDate', function(event){
        datetime_submit();
    });
    $('#datetimepicker-to').datetimepicker().on('changeDate', function(event){
        datetime_submit();
    });
    $("#select-from").blur(function(event){
        datetime_submit();
    });
    $("#select-to").blur(function(event){
        datetime_submit();
    });
    $("#select-term").change(function(event){
        $('#tune-form').submit();
    });
    $("#select-size").change(function(event){
        $('#tune-form').submit();
    });
});

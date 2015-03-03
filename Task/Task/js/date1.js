function onchange() {
    var x = $("#Hidenn").val();
    $("#Domestic_Early_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Early_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange,
        change: function () {

            var x = $("#Hidenn").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');
                debugger;
                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn").val(" ");
                    $("#Domestic_Early_Decision_Deadline").val("");
                    $("#Hidenn").val(val);
                    $("#Domestic_Early_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn").val(x);
                    $("#Domestic_Early_Decision_Deadline").val(x);
                }
            }
        }
    });

});


function onchange2() {
    var x = $("#Hidenn1").val();
    $("#International_Early_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Early_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange2,
        change: function () {

            var x = $("#Hidenn1").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn1").val(" ");
                    $("#International_Early_Decision_Deadline").val("");
                    $("#Hidenn1").val(val);
                    $("#International_Early_Decision_Deadline").val(val);
                }
                else{
                    x = x + "," + val;
                    $("#Hidenn1").val(x);
                    $("#International_Early_Decision_Deadline").val(x);
                }
            }
        }
    });

});


function onchange1() {
    var x = $("#Hidenn2").val();
    $("#Domestic_Earlr_Notification").val(x);
}
$(document).ready(function () {

    $("#Domestic_Earlr_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange1,
        change: function () {

            var x = $("#Hidenn2").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn2").val(" ");
                    $("#Domestic_Earlr_Notification").val("");
                    $("#Hidenn2").val(val);
                    $("#Domestic_Earlr_Notification").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn2").val(x);
                    $("#Domestic_Earlr_Notification").val(x);
                }
               
            }
        }
    });

});

function onchange3() {
    var x = $("#Hidenn3").val();
    $("#International_Earlr_Notification").val(x);
}
$(document).ready(function () {

    $("#International_Earlr_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange3,
        change: function () {

            var x = $("#Hidenn3").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn3").val(" ");
                    $("#International_Earlr_Notification").val("");
                    $("#Hidenn3").val(val);
                    $("#International_Earlr_Notification").val(val);
                }
                else{
                    x = x + "," + val;
                    $("#Hidenn3").val(x);
                    $("#International_Earlr_Notification").val(x);
                }
            }
        }
    });

});


function onchange4() {
    var x = $("#Hidenn4").val();
    $("#Domestic_Early_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Early_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange4,
        change: function () {

            var x = $("#Hidenn4").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn4").val(" ");
                    $("#Domestic_Early_Deposit_Deadline").val("");
                    $("#Hidenn4").val(val);
                    $("#Domestic_Early_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn4").val(x);
                    $("#Domestic_Early_Deposit_Deadline").val(x);
                }
            }
        }
    });

});

function onchange5() {
    var x = $("#Hidenn5").val();
    $("#International_Early_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Early_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange5,
        change: function () {

            var x = $("#Hidenn5").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn5").val(" ");
                    $("#International_Early_Deposit_Deadline").val("");
                    $("#Hidenn5").val(val);
                    $("#International_Early_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn5").val(x);
                    $("#International_Early_Deposit_Deadline").val(x);
                }
            }
        }
    });

});


function onchange6() {
    var x = $("#Hidenn6").val();
    $("#Domestic_Spring_Priority_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Spring_Priority_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange6,
        change: function () {

            var x = $("#Hidenn6").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn6").val(" ");
                    $("#Domestic_Spring_Priority_Decision_Deadline").val("");
                    $("#Hidenn6").val(val);
                    $("#Domestic_Spring_Priority_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn6").val(x);
                    $("#Domestic_Spring_Priority_Decision_Deadline").val(x);
                }
            }
        }
    });

});


function onchange7() {
    var x = $("#Hidenn7").val();
    $("#International_Spring_Priority_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Spring_Priority_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange7,
        change: function () {

            var x = $("#Hidenn7").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn7").val(" ");
                    $("#International_Spring_Priority_Decision_Deadline").val("");
                    $("#Hidenn7").val(val);
                    $("#International_Spring_Priority_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn7").val(x);
                    $("#International_Spring_Priority_Decision_Deadline").val(x);
                }
            }
        }
    });

});

function onchange8() {
    var x = $("#Hidenn8").val();
    $("#Domestic_Spring_Priority_Decision_Notification").val(x);
}
$(document).ready(function () {

    $("#Domestic_Spring_Priority_Decision_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange8,
        change: function () {

            var x = $("#Hidenn8").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn8").val(" ");
                    $("#Domestic_Spring_Priority_Decision_Notification").val("");
                    $("#Hidenn8").val(val);
                    $("#Domestic_Spring_Priority_Decision_Notification").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn8").val(x);
                    $("#Domestic_Spring_Priority_Decision_Notification").val(x);
                }
            }
        }
    });

});

function onchange9() {
    var x = $("#Hidenn9").val();
    $("#International_Spring_Priority_Decision_Notification").val(x);
}
$(document).ready(function () {

    $("#International_Spring_Priority_Decision_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange9,
        change: function () {

            var x = $("#Hidenn9").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn9").val(" ");
                    $("#International_Spring_Priority_Decision_Notification").val("");
                    $("#Hidenn9").val(val);
                    $("#International_Spring_Priority_Decision_Notification").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn9").val(x);
                    $("#International_Spring_Priority_Decision_Notification").val(x);
                }
            }
        }
    });

});

function onchange10() {
    var x = $("#Hidenn10").val();
    $("#Domestic_Spring_Priority_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Spring_Priority_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange10,
        change: function () {

            var x = $("#Hidenn10").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn10").val(" ");
                    $("#Domestic_Spring_Priority_Deposit_Deadline").val("");
                    $("#Hidenn10").val(val);
                    $("#Domestic_Spring_Priority_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn10").val(x);
                    $("#Domestic_Spring_Priority_Deposit_Deadline").val(x);
                }
            }
        }
    });

});

function onchange11() {
    var x = $("#Hidenn11").val();
    $("#International_Spring_Priority_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Spring_Priority_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange11,
        change: function () {

            var x = $("#Hidenn11").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn11").val(" ");
                    $("#International_Spring_Priority_Deposit_Deadline").val("");
                    $("#Hidenn11").val(val);
                    $("#International_Spring_Priority_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn11").val(x);
                    $("#International_Spring_Priority_Deposit_Deadline").val(x);
                }
            }
        }
    });

});

function onchange12() {
    var x = $("#Hidenn12").val();
    $("#Domestic_Summer_Priority_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Summer_Priority_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange12,
        change: function () {

            var x = $("#Hidenn12").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn12").val(" ");
                    $("#Domestic_Summer_Priority_Decision_Deadline").val("");
                    $("#Hidenn12").val(val);
                    $("#Domestic_Summer_Priority_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn12").val(x);
                    $("#Domestic_Summer_Priority_Decision_Deadline").val(x);
                }
            }
        }
    });

});

function onchange12() {
    var x = $("#Hidenn12").val();
    $("#Domestic_Summer_Priority_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Summer_Priority_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange12,
        change: function () {

            var x = $("#Hidenn12").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn12").val(" ");
                    $("#Domestic_Summer_Priority_Decision_Deadline").val("");
                    $("#Hidenn12").val(val);
                    $("#Domestic_Summer_Priority_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn12").val(x);
                    $("#Domestic_Summer_Priority_Decision_Deadline").val(x);
                }
            }
        }
    });

});


function onchange13() {
    var x = $("#Hidenn13").val();
    $("#International_Summer_Priority_Decision_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Summer_Priority_Decision_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange13,
        change: function () {

            var x = $("#Hidenn13").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn13").val(" ");
                    $("#International_Summer_Priority_Decision_Deadline").val("");
                    $("#Hidenn13").val(val);
                    $("#International_Summer_Priority_Decision_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn13").val(x);
                    $("#International_Summer_Priority_Decision_Deadline").val(x);
                }
            }
        }
    });

});


function onchange14() {
    var x = $("#Hidenn14").val();
    $("#Domestic_Summer_Priority_Decision_Notification").val(x);
}
$(document).ready(function () {

    $("#Domestic_Summer_Priority_Decision_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange14,
        change: function () {

            var x = $("#Hidenn14").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn14").val(" ");
                    $("#Domestic_Summer_Priority_Decision_Notification").val("");
                    $("#Hidenn14").val(val);
                    $("#Domestic_Summer_Priority_Decision_Notification").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn14").val(x);
                    $("#Domestic_Summer_Priority_Decision_Notification").val(x);
                }
            }
        }
    });

});

function onchange15() {
    var x = $("#Hidenn15").val();
    $("#International_Summer_Priority_Decision_Notification").val(x);
}
$(document).ready(function () {

    $("#International_Summer_Priority_Decision_Notification").kendoDatePicker({

        // display month and year in the input
        start: onchange15,
        change: function () {

            var x = $("#Hidenn15").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn15").val(" ");
                    $("#International_Summer_Priority_Decision_Notification").val("");
                    $("#Hidenn15").val(val);
                    $("#International_Summer_Priority_Decision_Notification").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn15").val(x);
                    $("#International_Summer_Priority_Decision_Notification").val(x);
                }
            }
        }
    });

});

function onchange16() {
    var x = $("#Hidenn16").val();
    $("#Domestic_Summer_Priority_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#Domestic_Summer_Priority_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange16,
        change: function () {

            var x = $("#Hidenn16").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn16").val(" ");
                    $("#Domestic_Summer_Priority_Deposit_Deadline").val("");
                    $("#Hidenn16").val(val);
                    $("#Domestic_Summer_Priority_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn16").val(x);
                    $("#Domestic_Summer_Priority_Deposit_Deadline").val(x);
                }
            }
        }
    });

});

function onchange17() {
    var x = $("#Hidenn17").val();
    $("#International_Summer_Priority_Deposit_Deadline").val(x);
}
$(document).ready(function () {

    $("#International_Summer_Priority_Deposit_Deadline").kendoDatePicker({

        // display month and year in the input
        start: onchange17,
        change: function () {

            var x = $("#Hidenn17").val();
            var value = this.value();
            if (value != null) {
                var date = new Date(value);

                var Month = date.getMonthName();

                var day = date.getDate();

                var val = Month + ' ' + day;
                var partsOfStr = x.split(',');

                if (partsOfStr.length == 2 || partsOfStr == "") {
                    $("#Hidenn17").val(" ");
                    $("#International_Summer_Priority_Deposit_Deadline").val("");
                    $("#Hidenn17").val(val);
                    $("#International_Summer_Priority_Deposit_Deadline").val(val);
                }
                else {
                    x = x + "," + val;
                    $("#Hidenn17").val(x);
                    $("#International_Summer_Priority_Deposit_Deadline").val(x);
                }
            }
        }
    });

});
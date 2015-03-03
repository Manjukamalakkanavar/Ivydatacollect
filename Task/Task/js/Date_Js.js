$(function () {


    $('#Domestic_Early_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn").val(x);
						        $("#Domestic_Early_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn").val(res[1]);
						            $("#Domestic_Early_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn").val(res[0]);
						            $("#Domestic_Early_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn").val(" ");
						            $("#Domestic_Early_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});



		$(function () {


		    $('#International_Early_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn1").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn1").val(x);
						        $("#International_Early_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn1").val(res[1]);
						            $("#International_Early_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn1").val(res[0]);
						            $("#International_Early_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn1").val(" ");
						            $("#International_Early_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#Domestic_Earlr_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn2").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn2").val(x);
						        $("#Domestic_Earlr_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn2").val(res[1]);
						            $("#Domestic_Earlr_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn2").val(res[0]);
						            $("#Domestic_Earlr_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn2").val(" ");
						            $("#Domestic_Earlr_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Earlr_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn3").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn3").val(x);
						        $("#International_Earlr_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn3").val(res[1]);
						            $("#International_Earlr_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn3").val(res[0]);
						            $("#International_Earlr_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn3").val(" ");
						            $("#International_Earlr_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#Domestic_Early_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn4").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn4").val(x);
						        $("#Domestic_Early_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn4").val(res[1]);
						            $("#Domestic_Early_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn4").val(res[0]);
						            $("#Domestic_Early_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn4").val(" ");
						            $("#Domestic_Early_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Early_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn5").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn5").val(x);
						        $("#International_Early_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn5").val(res[1]);
						            $("#International_Early_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn5").val(res[0]);
						            $("#International_Early_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn5").val(" ");
						            $("#International_Early_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});


		$(function () {


		    $('#Domestic_Spring_Priority_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn6").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn6").val(x);
						        $("#Domestic_Spring_Priority_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn6").val(res[1]);
						            $("#Domestic_Summer_Priority_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn6").val(res[0]);
						            $("#Domestic_Summer_Priority_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn6").val(" ");
						            $("#Domestic_Summer_Priority_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Spring_Priority_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn7").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn7").val(x);
						        $("#International_Spring_Priority_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn7").val(res[1]);
						            $("#International_Summer_Priority_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn7").val(res[0]);
						            $("#International_Summer_Priority_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn7").val(" ");
						            $("#International_Summer_Priority_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#Domestic_Spring_Priority_Decision_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn8").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn8").val(x);
						        $("#Domestic_Spring_Priority_Decision_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn8").val(res[1]);
						            $("#Domestic_Spring_Priority_Decision_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn8").val(res[0]);
						            $("#Domestic_Spring_Priority_Decision_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn8").val(" ");
						            $("#Domestic_Spring_Priority_Decision_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Spring_Priority_Decision_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn9").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn9").val(x);
						        $("#International_Spring_Priority_Decision_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn9").val(res[1]);
						            $("#International_Spring_Priority_Decision_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn9").val(res[0]);
						            $("#International_Spring_Priority_Decision_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn9").val(" ");
						            $("#International_Spring_Priority_Decision_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});


		$(function () {
         $('#Domestic_Spring_Priority_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn10").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn10").val(x);
						        $("#Domestic_Spring_Priority_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn10").val(res[1]);
						            $("#Domestic_Spring_Priority_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn10").val(res[0]);
						            $("#Domestic_Spring_Priority_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn10").val(" ");
						            $("#Domestic_Spring_Priority_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {
		    $('#International_Spring_Priority_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn11").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn11").val(x);
						        $("#International_Spring_Priority_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn11").val(res[1]);
						            $("#International_Spring_Priority_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn11").val(res[0]);
						            $("#International_Spring_Priority_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn11").val(" ");
						            $("#International_Spring_Priority_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});




		$(function () {


		    $('#Domestic_Summer_Priority_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn12").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn12").val(x);
						        $("#Domestic_Summer_Priority_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn12").val(res[1]);
						            $("#Domestic_Summer_Priority_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn12").val(res[0]);
						            $("#Domestic_Summer_Priority_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn12").val(" ");
						            $("#Domestic_Summer_Priority_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Summer_Priority_Decision_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn13").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn13").val(x);
						        $("#International_Summer_Priority_Decision_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn13").val(res[1]);
						            $("#International_Summer_Priority_Decision_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn13").val(res[0]);
						            $("#International_Summer_Priority_Decision_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn13").val(" ");
						            $("#International_Summer_Priority_Decision_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#Domestic_Summer_Priority_Decision_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn14").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn14").val(x);
						        $("#Domestic_Summer_Priority_Decision_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn14").val(res[1]);
						            $("#Domestic_Summer_Priority_Decision_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn14").val(res[0]);
						            $("#Domestic_Summer_Priority_Decision_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn14").val(" ");
						            $("#Domestic_Summer_Priority_Decision_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {


		    $('#International_Summer_Priority_Decision_Notification')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn15").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn15").val(x);
						        $("#International_Summer_Priority_Decision_Notification").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn15").val(res[1]);
						            $("#International_Summer_Priority_Decision_Notification").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn15").val(res[0]);
						            $("#International_Summer_Priority_Decision_Notification").val(res[0]);
						        }
						        else {
						            $("#Hidenn15").val(" ");
						            $("#International_Summer_Priority_Decision_Notification").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});


		$(function () {
		    $('#Domestic_Summer_Priority_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn16").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn16").val(x);
						        $("#Domestic_Summer_Priority_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn16").val(res[1]);
						            $("#Domestic_Summer_Priority_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn16").val(res[0]);
						            $("#Domestic_Summer_Priority_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn16").val(" ");
						            $("#Domestic_Summer_Priority_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		$(function () {
		    $('#International_Summer_Priority_Deposit_Deadline')
					.datePicker(
						{
						    createButton: false,
						    displayClose: true,
						    closeOnSelect: false,
						    selectMultiple: true,
						    numSelectable: 2
						}
					)
					.bind(
						'click',
						function () {

						    $(this).dpDisplay();
						    this.blur();
						    return false;
						}
					)
					.bind(
						'dateSelected',
						function (e, selectedDate, $td, state) {
						    debugger;

						    var x = $("#Hidenn17").val();

						    var date = new Date(selectedDate);

						    var Month = date.getMonthName();

						    var day = date.getDate();

						    var val = Month + ' ' + day;

						    if (state == true) {

						        if (x == "") {

						            x = val;
						        }
						        else {
						            x = x + "," + val;
						        }

						        $("#Hidenn17").val(x);
						        $("#International_Summer_Priority_Deposit_Deadline").val(x);
						    }
						    else {
						        var res = x.split(",");
						        if (val == res[0]) {
						            $("#Hidenn17").val(res[1]);
						            $("#International_Summer_Priority_Deposit_Deadline").val(res[1]);
						        }
						        else if (val == res[1]) {
						            $("#Hidenn17").val(res[0]);
						            $("#International_Summer_Priority_Deposit_Deadline").val(res[0]);
						        }
						        else {
						            $("#Hidenn17").val(" ");
						            $("#International_Summer_Priority_Deposit_Deadline").val("");

						        }
						    }

						}
					)
					.bind(
						'dpClosed',
						function (e, selectedDates) {
						    //console.log('You closed the date picker and the ' // wrap
						    //	+ 'currently selected dates are:');
						    //console.log(selectedDates);
						}
					);
		});

		
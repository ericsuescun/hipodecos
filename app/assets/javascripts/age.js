function age() {
  $('input#patient_birth_date').keyup(function (e) {
    console.log(e.which);
    input_date = Date.parse($('input#patient_birth_date').val());
    today = Date.now();
    var days_diff
    days_diff = parseInt((today - input_date)/1000/60/60/24);
    var uniedad;
    if (days_diff >= 0) { 
    	uniedad = "D";
	    $('input#patient_informs_attributes_0_p_age').val(parseInt(days_diff));
	    console.log(days_diff);
    }
    if (days_diff >= 30) {
    	uniedad = "M";
    	$('input#patient_informs_attributes_0_p_age').val(parseInt(days_diff / 30));
    	console.log(days_diff / 30);
	}
    if (days_diff >= 365) {
    	uniedad = "A";
    	$('input#patient_informs_attributes_0_p_age').val(parseInt(days_diff / 365));
    	console.log(days_diff / 365);
    }
    $('select#patient_informs_attributes_0_p_age_type').val(uniedad);
    
	console.log(uniedad);
	
  });
}
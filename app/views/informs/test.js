$('form').on('submit', function(e) {
  e.preventDefault(); // previene la acción por defecto (enviar el formulario)

  // escribe acá tu solución
  if($('#username').val().length == 0) {
  	$('#username').next().html('Ingresa un ususario');
  	$('#username').parent().addClass('has-error');
  } else {
  	if($('#username').val().length != $('#username').val().replace(/\s+/g, '').length) {
  		$('#username').next().html('No debe contener espacios');
  		$('#username').parent().addClass('has-error');
  	} else {
  		$('#username').next().html('');
  		$('#username').parent().removeClass('has-error');
  	}
  }
  if($('#password').val().length == 0) {
  	$('#password').next().html('Ingresa una contraseña');
  	$('#password').parent().addClass('has-error');
  } else {
  	if($('#password').val().length < 6) {
  		$('#password').next().html('Debe contener mínimo 6 caracteres');
  		$('#password').parent().addClass('has-error');
  	} else {
  		if($('#password').val().length > 40) {
  			$('#password').next().html('Debe contener máximo 40 caracteres');
  			$('#password').parent().addClass('has-error');
  		} else {
  			$('#password').next().html('');
  			$('#password').parent().removeClass('has-error');
  		}
  	}
  }
  if($('#terms:checkbox').prop('checked') == false) {
  	$('div.checkbox.terms-checkbox').addClass('has-error');
  	console.log('Sin check mark');
  } else {
  	$('div.checkbox.terms-checkbox').removeClass('has-error');
  }
});
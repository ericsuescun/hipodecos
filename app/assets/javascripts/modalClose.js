function modalClose() {
	$('#autosMacroModal').modal('hide');
	$('div#autosMacroModal').remove();
	$('body').removeClass('modal-open');
	$('div.modal-backdrop').remove();
}

function modalMicroClose() {
	$('#MicrosModal').modal('hide');
	$('div#MicrosModal').remove();
	$('body').removeClass('modal-open');
	$('div.modal-backdrop').remove();
}
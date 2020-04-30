function modalClose() {
	$('#autosMacroModal').modal('hide');
	$('div#autosMacroModal').remove();
	$('body').removeClass('modal-open');
	$('div.modal-backdrop').remove();
}
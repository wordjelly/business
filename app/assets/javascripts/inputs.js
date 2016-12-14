//ON CLICKING OUT THE SENTENCE, THE
$(document).on('blur','.sentence',function(event){
	//provided that sentence is not empty.
	if($(this).val().length === 0) return;
	var form = $(this).closest('form');
	form.submit();
});
/**

**/
var doc_ready = function(){
	
};

$(document).on('click','#add-piece',function(){
	$.get( "/fields/add_field", {} )
	  .done(function( data ) {
	    $("#pieces").append(data);
	});
});

$(document).on('click','.remove_field',function(){
	$(this).parent().hide();
})

$(document).ready(function(){
	console.log("document is ready");
	doc_ready();
});

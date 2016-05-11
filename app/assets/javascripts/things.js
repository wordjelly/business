/**

**/
var doc_ready = function(){
	
};

//the element being passed in has to be a jquery element.
var get_piece_id = function(j_el){
	//find the data field that has the piece id.
	return j_el.attr("data-piece-id");
}

//request new field from server.
$(document).on('click','#add-piece',function(){
	$.get( "/fields/add_field", {"parent_piece_id" : "root"} )
	  .done(function( data ) {
	    $("#pieces").append(data);
	});
});

//on click remove field, hide its parent.
$(document).on('click','.remove_field',function(){
	$(this).parent().hide();
});

//functions to choose complex object as field type.
$(document).on('click','.add_subfield',function(){
	var parent = $(this).closest(".piece").first();
	$.get( "/fields/add_field", {"parent_piece_id" : get_piece_id(parent)} )
	  .done(function( data ) {
	  	$(parent).after("<div style='margin-left:80px; margin-top:20px;'>" + data + "</div>");
	});
});

//handlers for all the options on the fields.
//all are on click or keypress handlers.
//they set the data-(name) on the piece itself.
//so all the values can be got from the piece div data-attribbutes.
$(document).on('keyup','.piece_name,.piece_description',function(event){
	var class_name = event.target.className;
	$(this).closest(".piece").attr("data-" + class_name.replace("_","-"),$(this).val());
});

$(document).on('click','.ft_text,.ft_numeric,.ft_timestamp,.ft_mcq,.ft_array',function(event){
	var class_name = event.target.className;
	$(this).closest(".piece").attr("data-piece-type",$(this).val());
});

/*****
create new thing.
*****/
$(document).on('click','#create_thing',function(){
	
	//iterate all the pieces, and take their piece and parent piece ids.
	//then submit, an array of pieces.
	$("#create_thing_spinner").show();
	var pieces = [];
	$(".piece").each(function(index){
		pieces.push({"parent_piece_id" : $(this).attr("data-parent-piece-id"),  "piece_id" : $(this).attr("data-piece-id"), "title": $(this).attr("data-piece-name"), "description": $(this).attr("data-piece-description"), "type": $(this).attr("data-piece-type")});
	});

	var data_hash = {"thing": {"pieces" : pieces, "name" : $("#thing_name").val()}};

	console.log("this is the data hash");
	console.log(data_hash);
	
    $.ajax({
	  url:"/things",
	  type:"POST",
	  data:JSON.stringify(data_hash),
	  contentType: 'application/json',
	  dataType:"script",
	  success: function(){
	   
   		
	  }
    });
    
});

/****
test function:
this function is a one button click to test the server side functioning.
****/
$(document).on('click','#test_create_thing',function(){

	var data_hash = {"thing":{"pieces":[{"parent_piece_id":"root", "piece_id":"1462944038", "title":"here ", "description":"there", "type":"multiple_choice_field"}, {"parent_piece_id":"1462944038", "piece_id":"1462944059", "title":"subfield", "description":"this is the first subfield", "type":"array_field"}, {"parent_piece_id":"root", "piece_id":"1462944051", "title":"hello", "description":"there", "type":"multiple_choice_field"}], "name":"dog and cat"}};

	$.ajax({
	  url:"/things",
	  type:"POST",
	  data:JSON.stringify(data_hash),
	  contentType: 'application/json',
	  dataType:"script",
	  success: function(){
	   
   		
	  }
    });

});



$(document).ready(function(){
	console.log("document is ready");
	doc_ready();
});


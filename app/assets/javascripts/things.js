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

/*****
create new thing.
*****/
$(document).on('click','#create_thing',function(){
	
	//iterate all the pieces, and take their piece and parent piece ids.
	//then submit, an array of pieces.
	$("#create_thing_spinner").show();
	var pieces = [];
	$(".piece").each(function(index){
		pieces.push({"parent_piece_id" : $(this).attr("data-parent-piece-id"),  "piece_id" : $(this).attr("data-piece-id")});
	});

	var data_hash = {"thing": {"pieces" : pieces, "name" : $("#thing_name").val()}};

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

****/
$(document).on('click','#test_create_thing',function(){

	var data_hash = {"thing":{"pieces":[{"parent_piece_id":"root", "piece_id":"1461937371"}, {"parent_piece_id":"1461937371", "piece_id":"1461937380"}, {"parent_piece_id":"1461937380", "piece_id":"1461937387"}, {"parent_piece_id":"1461937380", "piece_id":"1461937383"}, {"parent_piece_id":"root", "piece_id":"1461937393"}, {"parent_piece_id":"root", "piece_id":"1461937398"}], "name":"alabaster"}};

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


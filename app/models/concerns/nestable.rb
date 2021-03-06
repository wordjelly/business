module Nestable
	extend ActiveSupport::Concern
	included do
		include Mongoid::Document
		field :pieces, type: Array, default: []
  		field :schema, type: Hash

  		 after_initialize do |document|
		  	document.set_schema
		 end
	end

	def set_schema

	  	##key -> parent_id
	  	##value -> hash  


	  	##hash structure
	  	##key -> child_id
	  	##value -> child node attributes
	    parent_to_child = {}


	    ##key -> child_id
	    ##value -> parent_id
	    child_to_parent = {}
	    	
	    ##key -> node_id
	    ##value -> node
	    nodes = {}
	    
	    ##we create a new node, with the piece id of "root"
	    ##this is essential, because the api does not provide for sending in a root node.
	    root = Node.new({:piece_id => "root"})
	    
	    ##next we add this node to the nodes hash.
	    nodes[root.piece_id] = root


	    ##now we iterate each of the pieces coming in.
	  	self.pieces.each do |piece|
			
	  		##currently we have longs as the piece ids, so we convert them to strings
	  		#piece["parent_piece_id"] = piece["parent_piece_id"].to_s
	  		##same for this as well.
	  		#piece["piece_id"] = piece["piece_id"].to_s

	  		##if the enum is not nil, then we convert the enum into an array.
	  		if !piece["enum"].nil?
	  			piece["enum"] = piece["enum"].split(",")
	  		end
	  		
	  		##now we build a new node from this piece
	    	n = Node.new(piece)

	    	##we add it to the nodes hash.
	  		nodes[n.piece_id.to_s] = n
	  			

	  		##time to add the current node to the parent_to_child and child_to_parent hashes.

	  		##if the current nodes parent is not in the parent to child hash, then create a new entry in the hash, with the value as a hash , as described above.
	  		##else
	  		##just add to the current entry. 
	  		if parent_to_child[n.parent_piece_id.to_s].nil?
	  			parent_to_child[n.parent_piece_id.to_s] = {n.piece_id.to_s => n.attributes}
	  		else
	  			parent_to_child[n.parent_piece_id.to_s][n.piece_id.to_s] = n.attributes
	  		end  	

	  		child_to_parent[n.piece_id.to_s] = n.parent_piece_id.to_s

	  	end

	  	##this part is specifically for the array type
	  	##what happens is that if the user does not configure sub-fields for the array type, then we need to add a default sub-field for it.
	  	##so we check each of the nodes, to see if there is any array type that does not exist in the parent_to_child hash, i.e an array node, that does not have children
	  	##if found, then we create a new node, we make its parent piece, this array node , and give it a default type of string, and its title becomes the same as the array type ttitle.
	  	##we then add it to the parent_to_child and child_to_parent hashes, and also add it to the new nodes array.
	  	new_nodes = []
	  	nodes.each do |id,n|
	  		if (n.type == "array" && parent_to_child[id].nil?)
	  			
	  			nn = Node.new(:parent_piece_id => id, :type => "string", :title => n.title)
	  			parent_to_child[id] = {nn.piece_id => nn.attributes}
	  			child_to_parent[nn.piece_id] = id
	  			new_nodes << nn
	  		end  
	  	end

	  	##each of the new nodes is added to the nodes hash.
	  	new_nodes.each do |nn|  nodes[nn.id] = nn  end

	  	

	  	##iterate each key in the parent to child hash.
	    ##basically this is a one-step-up iterative algorithm.
	    ##it takes a given parent key.(current_key)
	    ##it finds out if it has a parent.(called grandparent)(parent_of_current_key)
	    ##if yes, then it adds the entry of the given parent key, to the grandparent.

	    ##then it moves up, i.e treats the grandparent as the given_key(current_key), and checks if that has a parent(super-parent)(parent_of_current_key), and assigns the entry of the grandparent(which has just been modified in the previous step of the while loop) to the super-parent.
	    ##all these assignments go on in the parent_to_child hash.

	  	parent_to_child.keys.each do |parent|

	  	##curr par is a variable that holds the parent of the current key being iterated.
	    ##so we just take the parent of the current parent.

	    parent_of_current_key = child_to_parent[parent]

	  		while(true)
	  			
	        ##the current_key is another variable that represents the current key of the parent_to_child hash being iterated.

	        ##basically this is an iterative system.
	        ##first we take the the parent of the current key being iterated.
	        ##that we assigned to parent_of_current_key

	        ##then we assign the current key to current_key
	        ##at the end of the code block, we make current_key equal to parent_of_current_key.
	        ##then we make parent_of_current_key = to its parent.
	        ##so basically the hierarchy is as follows:
	        
	        ##parent_of_current_key --is_parent_of-- current_key
	        ##then at end of loop, current_key becomes old parent_of_current_key, and parent_of_current_key becomes its own parent.
	        ##parent_of_current_key(parent_of_parent_of_current_key) --is parent of-- current_key(old_parent_of_current_key)
	        ##in the beginning, we check if parent_of_current_key is nil, so if there is no parent of the old_parent_of_current_key, the while loop breaks out.

	        ##the first time we run it , current_key will be nil, so we make it equal to the parent key, but thereafter if the loop continues, we leave it, since its not nil
	  			current_key = current_key.nil? ? parent : current_key

	  			if parent_of_current_key.nil?
	  				break
	  			else

	          ##we need to determine if the node of the current key being iterated is an array or not.
	          ##since it is a key in the parent_to_child hash , it has children.
	          ##so we just have to determine if it is a array or object.
	          ##if it is an array, then set this "object_or_array" variable to items, otherwise set it to properties.
	          
	  				object_or_array = (parent_to_child[parent_of_current_key][current_key]["type"] == "array") ? "items" : "properties"

	  				if object_or_array == "items"
	  					h = {}
	  					h["type"] = "object"
	  					h["properties"] = parent_to_child[current_key]
	            parent_to_child[parent_of_current_key][current_key][object_or_array] = h
	  				else
	  					parent_to_child[parent_of_current_key][current_key][object_or_array] = parent_to_child[current_key]
	  				  parent_to_child[parent_of_current_key][current_key]["type"] = "object"
	          end

	  				nodes[parent_of_current_key].increment_score()
	  				current_key = parent_of_current_key
	  				parent_of_current_key = child_to_parent[parent_of_current_key]
	  				
	  			end

	  		end  		

	  	end
	  	
	  	parent_to_child = parent_to_child.sort_by{|k,v| nodes[k].score}.reverse.to_h
	  	
	  	self.schema = parent_to_child["root"]
	    

	    #puts "this is the schema"
	    if !self.schema.nil?
	      puts JSON.pretty_generate(self.schema)
	    end

	    ##need to put this schema into elasticsearch as a document mapping.
	    ##then we can commit new documents of this type into es.
	    ##we also need to maintain a list of fields.

	    ##TODO:

	    ##1.it should not set type : for pure objects
	    ##2.it should set type to nested for arrays of objects
	    ##3.create a new index called field_names
	    ##4.its structure should be final name of field, and name of document, as well as field address
	    ##5.on creating or changing thing, this index should get populated.
	    

 	 end

end
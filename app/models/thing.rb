class Thing
  include Mongoid::Document
  field :name, type: String
  field :pieces, type: Array, default: []
  field :schema, type: Hash

  after_initialize do |document|
  	document.set_schema
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
		piece["parent_piece_id"] = piece["parent_piece_id"].to_s
		##same for this as well.
		piece["piece_id"] = piece["piece_id"].to_s

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
  			
  			nn = Node.new(:piece_id => Node.get_piece_id(), :parent_piece_id => id, :type => "string", :title => n.title)
  			parent_to_child[id] = {nn.piece_id => nn.attributes}
  			child_to_parent[nn.piece_id] = id
  			new_nodes << nn
  		end  
  	end

  	##each of the new nodes is added to the nodes hash.
  	new_nodes.each do |nn|  nodes[nn.id] = nn  end

  	

  	##iterate each key in the parent to child hash.
    ##basically this is a one-step-up iterative algorithm.
    ##it takes a given parent key.(new_par)
    ##it finds out if it has a parent.(called grandparent)(curr_par)
    ##if yes, then it adds the entry of the given parent key, to the grandparent.

    ##then it moves up, i.e treats the grandparent as the given_key(new_par), and checks if that has a parent(super-parent)(curr_par), and assigns the entry of the grandparent(which has just been modified in the previous step of the while loop) to the super-parent.
    ##all these assignments go on in the parent_to_child hash.

  	parent_to_child.keys.each do |parent|

  	##curr par is a variable that holds the parent of the current key being iterated.
    ##so we just take the parent of the current parent.

    curr_par = child_to_parent[parent]

  		while(true)
  			
        ##the new_par is another variable that represents the current key of the parent_to_child hash being iterated.

        ##basically this is an iterative system.
        ##first we take the the parent of the current key being iterated.
        ##that we assigned to curr_par

        ##then we assign the current key to new_par
        ##at the end of the code block, we make new_par equal to curr_par.
        ##then we make curr_par = to its parent.
        ##so basically the hierarchy is as follows:
        
        ##curr_par --is_parent_of-- new_par
        ##then at end of loop, new_par becomes old curr_par, and curr_par becomes its own parent.
        ##curr_par(parent_of_curr_par) --is parent of-- new_par(old_curr_par)
        ##in the beginning, we check if curr_par is nil, so if there is no parent of the old_curr_par, the while loop breaks out.

        ##the first time we run it , new_par will be nil, so we make it equal to the parent key, but thereafter if the loop continues, we leave it, since its not nil
  			new_par = new_par.nil? ? parent : new_par

  			if curr_par.nil?
  				break
  			else

          ##we need to determine if the node of the current key being iterated is an array or not.
          ##since it is a key in the parent_to_child hash , it has children.
          ##so we just have to determine if it is a array or object.
          ##if it is an array, then set this "object_or_array" variable to items, otherwise set it to properties.
  				object_or_array = (parent_to_child[curr_par][new_par]["type"] == "array") ? "items" : "properties"

  				if object_or_array == "items"
  					h = {}
  					h["type"] = "object"
  					h["properties"] = parent_to_child[new_par]
  					parent_to_child[curr_par][new_par][object_or_array] = h
  				else
  					parent_to_child[curr_par][new_par][object_or_array] = parent_to_child[new_par]
  				end

  				nodes[curr_par].increment_score()
  				new_par = curr_par
  				curr_par = child_to_parent[curr_par]
  				
  			end

  		end  		

  	end
  	
  	parent_to_child = parent_to_child.sort_by{|k,v| nodes[k].score}.reverse.to_h
  	
  	self.schema = parent_to_child["root"]


  end

end

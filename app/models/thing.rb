class Thing
  include Mongoid::Document
  field :name, type: String
  field :pieces, type: Array, default: []
  field :schema, type: Hash

  after_initialize do |document|
  	document.set_schema
  end


  def set_schema

    parent_to_child = {}

    child_to_parent = {}
    
    nodes = {}
    
    root = Node.new({:piece_id => "root"})
    
    nodes[root.piece_id] = root
  	self.pieces.each do |piece|
		
		piece["parent_piece_id"] = piece["parent_piece_id"].to_s
		piece["piece_id"] = piece["piece_id"].to_s
		if !piece["enum"].nil?
			piece["enum"] = piece["enum"].split(",")
		end
			
  		n = Node.new(piece)
		nodes[n.piece_id.to_s] = n
		
		if parent_to_child[n.parent_piece_id.to_s].nil?
			parent_to_child[n.parent_piece_id.to_s] = {n.piece_id.to_s => n.attributes}
		else
			parent_to_child[n.parent_piece_id.to_s][n.piece_id.to_s] = n.attributes
		end  	

		child_to_parent[n.piece_id.to_s] = n.parent_piece_id.to_s

  	end

  	##FOR ARRAYS ONLY.
  	##check if any of the arrays are such that they do not feature as keys in the parent to child hash.
  	new_nodes = []
  	nodes.each do |id,n|
  		if (n.type == "array" && parent_to_child[id].nil?)
  			##this array has no children.
  			##so we must give it a default child.
  			nn = Node.new(:piece_id => Node.get_piece_id(), :parent_piece_id => id, :type => "string", :title => n.title)
  			parent_to_child[id] = {id => nn.attributes}
  			child_to_parent[nn.id] = id
  			new_nodes << nn
  		end  
  	end

  	##add the new nodes.
  	new_nodes.each do |nn|  nodes[nn.id] = nn  end

  	##now iterate the parent pieces.
  	parent_to_child.keys.each do |parent|

  		##Rails.logger.debug("doing parent key:" + parent)
		##find the who is its parent.
		curr_par = curr_par.nil? ? child_to_parent[parent] : child_to_parent[curr_par]

		##Rails.logger.debug("this is the curr par")
		##Rails.logger.debug(curr_par)
		
		while(true)
		
			if curr_par.nil?
				##Rails.logger.debug("curr par is nil")
				break
			else
				##add the parent key to the curr par key in the parent to child hash

				##determine if it is an array type or an object type.
				##if it is an array type, then instead of properties use "items"
				##if parent_to_child[curr_par][parent]["type"] == "array"
				##else
				##end

				object_or_array = (parent_to_child[curr_par][parent]["type"] == "array") ? "items" : "properties"

				if object_or_array == "items"
					##here we dont want to use the key.
					##it needs only the values, and there can be only one
					##since we cannot support an array of more than one object.
					##all the subfields will be part of one object.
					##if there are more than one values.
					h = {}
					h["type"] = "object"
					h["properties"] = parent_to_child[parent]
					puts parent_to_child[parent].to_s
					

					parent_to_child[curr_par][parent][object_or_array] = h

					##we need to combine all these children into one object.
					##we need to give it a name
					##so we build it from the 

				else
					parent_to_child[curr_par][parent][object_or_array] = parent_to_child[parent]
				end

	
				##increment the value of the curr par in the node_scores.
				nodes[curr_par].increment_score()

				##need to change curr_par
				##next curr parent is the current parents parent.
				curr_par = child_to_parent[curr_par]
			end

		end  		

  	end
  	
  	parent_to_child = parent_to_child.sort_by{|k,v| nodes[k].score}.reverse.to_h
  	
  	self.schema = parent_to_child["root"]


  end

end

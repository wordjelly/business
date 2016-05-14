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
		
		##some preinitialization code should be shifted to 
		##before initialize for node, but mongoid does not offer a before_initialize_hook
		piece["parent_piece_id"] = piece["parent_piece_id"].to_s
		piece["piece_id"] = piece["piece_id"].to_s
		piece["enum"] = piece["enum"].nil? ? nil : piece["enum"].split(",") 
		
  		n = Node.new(piece)
		nodes[n.piece_id.to_s] = n
		
		if parent_to_child[n.parent_piece_id.to_s].nil?
			parent_to_child[n.parent_piece_id.to_s] = {n.piece_id.to_s => n.attributes}
		else
			parent_to_child[n.parent_piece_id.to_s][n.piece_id.to_s] = n.attributes
		end  	

		child_to_parent[n.piece_id.to_s] = n.parent_piece_id.to_s

  	end


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


			
				parent_to_child[curr_par][parent][object_or_array] = parent_to_child[parent]
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

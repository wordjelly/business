class Thing
  include Mongoid::Document
  field :name, type: String
  field :pieces, type: Array, default: []
  field :schema, type: String

  after_initialize do |document|
  	document.set_schema
  end

  def set_schema

    parent_to_child = {}

    child_to_parent = {}

    ##holds the information about each piece.
    nodes = {}

    ##need to convert each piece into a node object.

    ##Rails.logger.debug(self.pieces.to_s)
    ##first pass
    ##add node
    root = Node.new({:piece_id => "root"})
    nodes[root.piece_id] = root
  	self.pieces.each do |piece|
		
		##Rails.logger.debug(piece)
		piece["parent_piece_id"] = piece["parent_piece_id"].to_s
		piece["piece_id"] = piece["piece_id"].to_s
  		n = Node.new(piece)
		nodes[n.piece_id.to_s] = n
		##Rails.logger.debug("node is:")
		##Rails.logger.debug(n.parent_piece_id)
		##Rails.logger.debug(n.piece_id)

		##Rails.logger.debug("n.parent piece id." + n.parent_piece_id.to_s);
		##Rails.logger.debug("hash before")
		##Rails.logger.debug(parent_to_child)

		if parent_to_child[n.parent_piece_id.to_s].nil?
			parent_to_child[n.parent_piece_id.to_s] = {n.piece_id.to_s => {}}
		else
			parent_to_child[n.parent_piece_id.to_s][n.piece_id.to_s] = {}
		end  	

		child_to_parent[n.piece_id.to_s] = n.parent_piece_id.to_s

  	end

  	##Rails.logger.debug("the parent to child array")
  	##Rails.logger.debug(parent_to_child)

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
				parent_to_child[curr_par][parent] = parent_to_child[parent]
				##increment the value of the curr par in the node_scores.
				nodes[curr_par].increment_score()

				##need to change curr_par
				##next curr parent is the current parents parent.
				curr_par = child_to_parent[curr_par]
			end

		end  		

  	end

  	##Rails.logger.debug(parent_to_child)
  	parent_to_child = parent_to_child.sort_by{|k,v|
  		##Rails.logger.debug("this is k")
  		##Rails.logger.debug(k)
  	 nodes[k].score}.reverse.to_h
  	##Rails.logger.debug(JSON.pretty_generate(parent_to_child))
  	self.schema = JSON.generate(parent_to_child)

  end

end

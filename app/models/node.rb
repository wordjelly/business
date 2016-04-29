class Node
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :score, type: Integer
  field :piece_id, type: String
  field :parent_piece_id, type: String

 
  after_initialize do |document|
  	self.score = 1
  end

  def increment_score
  	self.score+=1
  end

end

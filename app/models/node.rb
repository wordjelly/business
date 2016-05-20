class Node
  include Mongoid::Document
  
  ###
  #following three fields are used while building the tree.
  ###

  ##score is assigned internally, just to decide which field has the greatest number of grandchildren.
  field :score, type: Integer

  ##this is sent by the server.
  field :piece_id, type: String

  ##this is provided by the user, or defaults to root if not provided.
  field :parent_piece_id, type: String, default: "root"

  ##----------------------------------------------------------------

  ###
  #these fields are specific to the jsonform library.

  ##the name of the field
  field :title, type: String

  ##something to guide the user while filling out the field
  field :description, type: String

  ##the default value for the field.
  field :default, type: String

  ##the maximum length for the field
  field :maxLength, type: Integer

  ##these next four are for range slider.
  field :minimum, type: Integer
  field :maximum, type: Integer
  field :exclusiveMaximum, type: Integer
  field :exclusiveMinimum, type: Integer

  ##if the field is to be readOnly.
  field :readOnly, type: Integer

  ##if the field is to be marked as required.
  field :required, type: Boolean

  ##this supports the following types:
  ##String
  ##Integer
  ##Boolean
  ##Object
  ##Array
  field :type, type: String
  
  ##this is for fields of type object - this basically carries the nested fields.
  field :properties, type: Hash

  ##this should be an array of options, it generates a 
  field :enum, type: Array
 
  after_initialize do |document|
  	##set the score as 1 this is increment everytime a child is added somewhere below
    self.score = 1
  end

  def self.get_piece_id
    return Time.now.to_i.to_s
  end

  def increment_score
  	self.score+=1
  end

  

end

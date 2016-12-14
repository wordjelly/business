class Suggestion
	include Mongoid::Document
	embedded_in :input

	##es result for a similar named things
	field :existing_things

	##es result for similar named fields
	field :existing_fields

	##suggest that they create a new object out of this field name
	field :suggest_thing_creation


end
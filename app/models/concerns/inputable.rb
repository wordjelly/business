module Inputable
	extend ActiveSupport::Concern
	included do
    	include Mongoid::Document
    	field :inputs , type: Array, default: []
    	attr_accessor :loaded_inputs_array
	end
end
module Inputable
	extend ActiveSupport::Concern
	included do
    	include Mongoid::Document
    	field :inputs , type: Array, default: [Input.new.attributes]
	end
end
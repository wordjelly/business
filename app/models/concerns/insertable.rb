module Insertable
	extend ActiveSupport::Concern
	included do
    	attr_accessor :div_id
	end
end
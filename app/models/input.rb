class Input
  include Parser  
  include Insertable
  embeds_many :suggestions, cascade_callbacks: true
end

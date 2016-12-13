class Input
  include Parser  
  include Insertable

  before_save do |document|
  	document.parse
  end

end

class Site < ActiveRecord::Base
  
  validates_presence_of :url
  # validates_format_of :url, :with => TODO [thorsten, 24.06.2008]

  has_many :combinations
  
end

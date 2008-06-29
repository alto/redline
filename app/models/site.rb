# == Schema Information
# Schema version: 20080629091000
#
# Table name: sites
#
#  id         :integer(11)     not null, primary key
#  url        :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Site < ActiveRecord::Base
  
  validates_presence_of :url
  # validates_format_of :url, :with => TODO [thorsten, 24.06.2008]

  has_many :connections
  has_many :claims
  
end

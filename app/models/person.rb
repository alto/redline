# == Schema Information
# Schema version: 20080629091000
#
# Table name: people
#
#  id         :integer(11)     not null, primary key
#  name       :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#  user_id    :integer(11)     
#

class Person < ActiveRecord::Base
    
  validates_presence_of :name
  
  belongs_to :user
  
  has_many :connections
  has_many :people, :through => :connections
  has_many :sites, :through => :connections
  
end

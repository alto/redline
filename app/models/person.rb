# == Schema Information
# Schema version: 20080624222854
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
  
  has_many :combinations
  has_many :people, :through => :combinations
  has_many :sites, :through => :combinations
  
end

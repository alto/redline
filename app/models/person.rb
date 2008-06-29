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
  
  has_many :connections
  has_many :people, :through => :connections
  has_many :sites, :through => :connections
  
  def user
    site_claims = sites.collect {|site| site.claims}.flatten
    site_users = site_claims.collect {|claim| claim.user_id}
    max = 0; max_user_id = nil
    site_users.each do |u| 
      count = site_users.count(u)
      if count > max
        max_user_id = u
        max = count
      end
    end
    User.find_by_id(max_user_id)
  end
  
end

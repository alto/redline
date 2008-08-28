# == Schema Information
# Schema version: 20080828215249
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
  
  has_many :namings
  has_many :people, :through => :namings
  has_many :sites, :through => :namings
  
  def representing_users
    sites.collect {|s| s.users}.flatten
  end
  
  # def user
  #   site_claims = sites.collect {|site| site.claims}.flatten
  #   site_users = site_claims.collect {|claim| claim.user_id}
  #   max = 0; max_user_id = nil
  #   site_users.each do |u| 
  #     count = site_users.count(u)
  #     if count > max
  #       max_user_id = u
  #       max = count
  #     end
  #   end
  #   User.find_by_id(max_user_id)
  # end
  
  def self.find_linking_to(user)
    sites = user.claims.map(&:site)
    namings_for_sites = sites.collect {|site| site.namings}.flatten
    namings_for_sites.map(&:person)
  end
  
end

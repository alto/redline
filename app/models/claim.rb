# == Schema Information
# Schema version: 20080629091000
#
# Table name: claims
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  site_id    :integer(11)     
#  label      :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Claim < ActiveRecord::Base

  validates_presence_of :user
  validates_presence_of :site
  
  belongs_to :user
  belongs_to :site
  
  def url=(url)
    self.site = Site.find_by_url(url) || Site.new(:url => url)
  end
  def url
    site ? site.url : nil
  end
  
end

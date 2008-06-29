class Claim < ActiveRecord::Base

  validates_presence_of :user_id
  validates_presence_of :site_id
  
  belongs_to :user
  belongs_to :site
  
  def label
    read_attribute(:label).blank? ? url : read_attribute(:label)
  end
  
  def url=(url)
    self.site = Site.find_by_url(url) || Site.new(:url => url)
  end
  def url
    site ? site.url : nil
  end
  
end
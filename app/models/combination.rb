# == Schema Information
# Schema version: 20080624222854
#
# Table name: combinations
#
#  id         :integer(11)     not null, primary key
#  person_id  :integer(11)     
#  site_id    :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#  created_by :integer(11)     
#

class Combination < ActiveRecord::Base

  validates_presence_of :person
  validates_presence_of :site
  validates_presence_of :created_by
  
  belongs_to :person
  belongs_to :site
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'created_by'
  
  def name=(name)
    self.person = Person.find_by_name(name) || Person.new(:name => name)
  end
  def name
    person ? person.name : nil
  end
  
  def url=(url)
    self.site = Site.find_by_url(url) || Site.new(:url => url)
  end
  def url
    site ? site.url : nil
  end

end

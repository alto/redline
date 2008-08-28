# == Schema Information
# Schema version: 20080828143000
#
# Table name: namings
#
#  id         :integer(11)     not null, primary key
#  person_id  :integer(11)     
#  site_id    :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#  user_id    :integer(11)     
#

class Naming < ActiveRecord::Base

  validates_presence_of :person
  validates_presence_of :site
  validates_presence_of :user_id
  
  belongs_to :person
  belongs_to :site
  belongs_to :user
  
  before_validation :name_to_person
  
  attr_accessor :name
  
  def name
    @name ||= (person ? person.name : nil)
  end
  
  def url=(url)
    url = Site.ensure_protocol(url)
    self.site = Site.find_by_url(url) || Site.new(:url => url)
  end
  def url
    site ? site.url : nil
  end
  
  def self.find_to(user)
    sites = user.claims.map(&:site)
    namings_for_sites = sites.collect {|site| site.namings}.flatten
  end
  
  private
    def name_to_person
      self.person = user.people.find_by_name(name) || Person.new(:name => name, :user => user)
    end
  
end

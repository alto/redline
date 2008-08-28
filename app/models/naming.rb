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
  acts_as_deletable :after => :removed_naming

  validates_presence_of :site_id
  validates_presence_of :user_id
  validates_presence_of :person_id
  
  belongs_to :site
  belongs_to :user
  belongs_to :person
  
  after_create :added_naming
  
  def name=(name)
    self.person = Person.find_by_name(name) || Person.create(:name => name)
  end
  def name
    person ? person.name : nil
  end
  
  def url=(url)
    url = Site.ensure_protocol(url)
    self.site = Site.find_by_url(url) || Site.create(:url => url)
  end
  def url
    site ? site.url : nil
  end
  
  def self.find_to(user)
    sites = user.claims.map(&:site)
    namings_for_sites = sites.collect {|site| site.namings}.flatten
  end
  
  private
    def added_naming
      Command.create!(:user => self.user, :action => 'added_naming', :commandable => self)
    end
    def removed_naming
      Command.create!(:user => self.user, :action => 'removed_naming', :commandable => self)
    end
  
end

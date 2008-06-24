class Combination < ActiveRecord::Base

  validates_presence_of :person
  validates_presence_of :site
  
  belongs_to :person
  belongs_to :site
  
  after_save
  
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

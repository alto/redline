# == Schema Information
# Schema version: 20080828143000
#
# Table name: claims
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  site_id    :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#  deleted_at :datetime        
#

class Claim < ActiveRecord::Base
  acts_as_deletable :after => :removed_claim

  validates_presence_of :user_id
  validates_presence_of :site_id
  
  belongs_to :user
  belongs_to :site
  
  after_create :added_claim

  def url=(url)
    url = Site.ensure_protocol(url)
    self.site = Site.find_by_url(url) || Site.new(:url => url)
  end
  def url
    site ? site.url : nil
  end
  
  private
    def added_claim
      Command.create!(:user => self.user, :action => 'added_claim', :commandable => self)
    end
    def removed_claim
      Command.create!(:user => self.user, :action => 'removed_claim', :commandable => self)
    end
  
end

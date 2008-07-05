# == Schema Information
# Schema version: 20080629091000
#
# Table name: sites
#
#  id         :integer(11)     not null, primary key
#  url        :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Site < ActiveRecord::Base
  
  validates_presence_of :url
  # validates_format_of :url, :with => TODO [thorsten, 24.06.2008]

  has_many :connections
  has_many :people, :through => :connections
  has_many :claims
  has_many :users, :through => :claims
  
  before_validation :normalize_url
  
  def claimed?
    !claims.empty?
  end
  
  def self.ensure_protocol(website)
    return '' if website.blank?
    website =~ /^http/ ? website : "http://#{website}"
  end

  def self.normalize_url(url)
    url = Site.ensure_protocol(url).gsub(/\/$/,'')
  end
  
  private
    def normalize_url
      self.url = Site.normalize_url(url)
    end
end

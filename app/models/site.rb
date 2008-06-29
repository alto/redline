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
  has_many :claims
  
  before_save :enhance_url
  
  def claimed?
    !claims.empty?
  end
  
  private
    def enhance_url
      self.url = ensure_protocol(url) if valid?
    end

    def ensure_protocol(website)
      return '' if website.blank?
      website =~ /^http/ ? website : "http://#{website}"
    end
  
end

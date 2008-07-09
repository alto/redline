# == Schema Information
# Schema version: 20080704215702
#
# Table name: photos
#
#  id           :integer(11)     not null, primary key
#  user_id      :integer(11)     
#  parent_id    :integer(11)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Photo < ActiveRecord::Base
  
  belongs_to :user
  
  has_attachment :storage => :file_system, 
    :thumbnails => { 
      :huge   => '118x118!', 
      :big    => '69x69!', 
      :medium => '60x60!', 
      :small  => '35x35!',
      :mini   => '25x25!', 
      :pin    => '13x13!' 
    }, 
    :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg'],
    :max_size => 5.megabytes,
    :path_prefix => "public/data/photos"
    
  validates_as_attachment
  validates_presence_of :user_id, :if => Proc.new { |i| i.parent_id.nil? }
  
end

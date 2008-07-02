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

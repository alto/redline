# examples:
#
# user portraits only
#   ./script/runner ./script/resize_images.rb Photo
#
# all images
#   ./script/runner ./script/resize_images.rb 
#
only_this = ARGV[0]
classes = [
  'Photo',
]
classes = only_this.blank? ? classes : [only_this]
classes.each do |klass|
  puts "resizing all #{klass.to_s.tableize}"
  Kernel.const_get(klass).find(:all, :conditions => 'parent_id IS NULL').each do |image|
    puts "...#{image.public_filename}"
    temp_file = image.create_temp_file
    image.attachment_options[:thumbnails].each { |suffix, size|
      image.create_or_update_thumbnail(temp_file, suffix, *size)
    }
  end
end

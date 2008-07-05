module ApplicationHelper
  
  def self_view?(user)
    return false unless logged_in?
    return false if user.nil? || user == :false
    user.id == current_user.id
  end

  def small_user(user, options={})
    name = options[:name] || user.name
    link_to(photo_tag(user.photo, :mini) + " #{name}", user_path(user))
  end

  def photo_tag(image, size, html_options={}, options={})
    filename = photo_path(image, size)
    if options[:path_only]
      return filename if (filename)
    end
    if (filename)
      return image_tag(filename, html_options)
    else
      return ""
    end
  end
  
  def photo_path(image, size)
    if image && !image.new_record?
      image_path(image.public_filename(size))
    else
      "default_user_image_#{size.to_s}.png"
    end
  end
  
  def icon_link_to(url, size='pin')
    puts "icon_link_to #{url}"
    link_to(icon_tag(url, size), url, :title => url)
  end
  
  def icon_tag(url, size='mini')
    image = case url
    when /xing\.com/
      "icons/xing_#{size}.jpg"
    when /twitter\.com/
      "icons/twitter_#{size}.png"
    else
      "icons/homepage_#{size}.png"
    end
    image_tag(image)
  end
  
  def invited?
    !session[:inviter].blank?
  end
  
end

module ApplicationHelper
  
  def self_view?(user)
    return false unless logged_in?
    return false if user.nil? || user == :false
    user.id == current_user.id
  end

  def small_user(user)
    link_to(photo_tag(user.photo, :mini) + " #{user.name}", user_path(user))
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
  
  def invited?
    !session[:inviter].blank?
  end
  
end

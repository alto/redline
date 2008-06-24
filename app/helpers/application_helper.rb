module ApplicationHelper
  
  def self_view?(user)
    return false if user.nil? || user == :false
    user.id == current_user.id
  end
  
end

class Command < ActiveRecord::Base
  
  validates_presence_of :user_id
  validates_presence_of :action
  
  belongs_to :user
  belongs_to :commandable, :polymorphic => true
  
  def undo!
    undone = case action
    when 'added_claim'
      commandable.delete!(false)
    when 'removed_claim'
      commandable.undelete!
    end
    update_attribute(:undone_at, Time.now) if undone
  end
  
  def undone?
    !undone_at.nil?
  end
  
  def self.history(options={})
    find_options = {
      :conditions => ['undone_at IS NULL'],
      :order => 'created_at DESC',
    }
    if options[:user]
      find_options[:conditions][0] += ' AND user_id = ?'
      find_options[:conditions] << options[:user].id
    end
    find_options[:limit] = options[:limit] if options[:limit]
    find(:all, find_options)
  end
  
  def to_s(options={})
    prefix = options[:without_date] ? '' : "#{display_date(created_at)}"
    prefix += " #{user.name}" unless options[:without_name]
    main = case action
    when 'created_towwl'
      "created towwl '#{commandable.to_s}'"
    when 'created_item'
      "created item '#{commandable.to_s}' on towwl '#{commandable.towwl.to_s}'"
    when 'deleted_towwl'
      "deleted towwl '#{commandable.to_s}'"
    when 'deleted_item'
      "deleted item '#{commandable.to_s}' on towwl '#{commandable.towwl.to_s}'"
    when 'moved_item'
      "moved item '#{commandable.to_s}' on towwl '#{commandable.towwl.to_s}' from position #{param1} to #{param2}"
    end
    "#{prefix} #{main}"
  end

  private
    def display_date(time)
      time.strftime('%d.%m.%Y')
    end
    
end

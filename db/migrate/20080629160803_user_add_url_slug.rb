class UserAddUrlSlug < ActiveRecord::Migration
  def self.up
    add_column :users, :url_slug, :string
    User.find(:all).each {|user| user.save!}
  end

  def self.down
    remove_column :users, :url_slug
  end
end

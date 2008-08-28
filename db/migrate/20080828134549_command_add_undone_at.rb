class CommandAddUndoneAt < ActiveRecord::Migration
  def self.up
    add_column :commands, :undone_at, :datetime
  end

  def self.down
    remove_column :commands, :undone_at
  end
end

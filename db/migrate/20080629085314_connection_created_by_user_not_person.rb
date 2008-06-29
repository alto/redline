class ConnectionCreatedByUserNotPerson < ActiveRecord::Migration
  def self.up
    rename_column :connections, :created_by, :user_id
  end

  def self.down
    rename_column :connections, :user_id, :created_by
  end
end

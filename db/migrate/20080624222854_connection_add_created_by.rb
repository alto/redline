class ConnectionAddCreatedBy < ActiveRecord::Migration
  def self.up
    add_column :connections, :created_by, :integer
  end

  def self.down
    remove_column :connections, :created_by
  end
end

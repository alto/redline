class CombinationCreatedByUserNotPerson < ActiveRecord::Migration
  def self.up
    rename_column :combinations, :created_by, :user_id
  end

  def self.down
    rename_column :combinations, :user_id, :created_by
  end
end

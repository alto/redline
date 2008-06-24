class CombinationAddCreatedBy < ActiveRecord::Migration
  def self.up
    add_column :combinations, :created_by, :integer
  end

  def self.down
    remove_column :combinations, :created_by
  end
end

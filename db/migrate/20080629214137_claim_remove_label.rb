class ClaimRemoveLabel < ActiveRecord::Migration
  def self.up
    remove_column :claims, :label
  end

  def self.down
    add_column :claims, :label, :string
  end
end

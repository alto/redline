class ClaimAddDeletedAt < ActiveRecord::Migration
  def self.up
    add_column :claims, :deleted_at, :datetime
  end

  def self.down
    remove_column :claims, :deleted_at
  end
end

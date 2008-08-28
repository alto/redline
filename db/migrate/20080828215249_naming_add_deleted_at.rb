class NamingAddDeletedAt < ActiveRecord::Migration
  def self.up
    add_column :namings, :deleted_at, :datetime
  end

  def self.down
    remove_column :namings, :deleted_at
  end
end

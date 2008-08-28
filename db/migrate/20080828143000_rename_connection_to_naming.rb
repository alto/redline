class RenameConnectionToNaming < ActiveRecord::Migration
  def self.up
    rename_table :connections, :namings
  end

  def self.down
    rename_table :namings, :connections
  end
end

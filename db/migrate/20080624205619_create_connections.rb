class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.integer :person_id
      t.integer :site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :connections
  end
end

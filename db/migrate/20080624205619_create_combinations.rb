class CreateCombinations < ActiveRecord::Migration
  def self.up
    create_table :combinations do |t|
      t.integer :person_id
      t.integer :site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :combinations
  end
end

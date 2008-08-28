class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.integer :user_id
      t.string  :action
      t.string  :commandable_type
      t.integer :commandable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :commands
  end
end
